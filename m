Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbXCMSka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbXCMSka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXCMSka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:40:30 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:55631 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbXCMSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:40:29 -0400
Date: Tue, 13 Mar 2007 19:42:04 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <20070313194204.5192ab19@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
References: <1173735075.5936.139.camel@localhost.localdomain>
	<Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 11:00:21 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> The consensus is that we would be better off keeping Oliver's original 
> patch without your silly change, and instead fixing the particular method 
> call that deadlocked.

Another call that deadlocked with Oliver's patch is ungroup for s390
ccwgroup devices. It can be made to work again with a similar patch.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/cio/ccwgroup.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ linux-2.6/drivers/s390/cio/ccwgroup.c
@@ -67,22 +67,49 @@ __ccwgroup_remove_symlinks(struct ccwgro
 	
 }
 
+struct ccwgroup_work_struct {
+	struct ccwgroup_device *gdev;
+	struct work_struct work;
+};
+
+static void ccwgroup_ungroup_work(struct work_struct *work)
+{
+	struct ccwgroup_work_struct *ungroup_work
+		= container_of(work, struct ccwgroup_work_struct, work);
+
+	__ccwgroup_remove_symlinks(ungroup_work->gdev);
+	device_unregister(&ungroup_work->gdev->dev);
+	put_device(&ungroup_work->gdev->dev);
+	kfree(ungroup_work);
+}
+
 /*
  * Provide an 'ungroup' attribute so the user can remove group devices no
  * longer needed or accidentially created. Saves memory :)
+ * Note that we cannot unregister the device from one of its attribute
+ * methods, so we have to delay it.
  */
-static ssize_t
-ccwgroup_ungroup_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t ccwgroup_ungroup_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
 {
 	struct ccwgroup_device *gdev;
+	struct ccwgroup_work_struct *ungroup_work;
 
 	gdev = to_ccwgroupdev(dev);
 
 	if (gdev->state != CCWGROUP_OFFLINE)
 		return -EINVAL;
 
-	__ccwgroup_remove_symlinks(gdev);
-	device_unregister(dev);
+	ungroup_work = kmalloc(sizeof(*ungroup_work), GFP_KERNEL);
+	if (!ungroup_work)
+		return -ENOMEM;
+	ungroup_work->gdev = gdev;
+	INIT_WORK(&ungroup_work->work, ccwgroup_ungroup_work);
+	if (!get_device(&gdev->dev))
+		kfree(ungroup_work);
+	else
+		schedule_work(&ungroup_work->work);
 
 	return count;
 }
