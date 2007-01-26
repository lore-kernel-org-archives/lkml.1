Return-Path: <linux-kernel-owner+w=401wt.eu-S1030858AbXAZQtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858AbXAZQtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030861AbXAZQtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:49:42 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25527 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030850AbXAZQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:49:36 -0500
Date: Fri, 26 Jan 2007 17:49:29 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: wein@de.ibm.com
Subject: [S390] dasd: fix bug in dasd initialization cleanup
Message-ID: <20070126164929.GI11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

[S390] dasd: fix bug in dasd initialization cleanup

The initialization of the dasd_eer code is one of the last steps of the
dasd driver initialization. When initialization fails in one of the
earlier steps, the dasd_exit function is called to clean up what has been
done so far. So the dasd_eer_exit function may be called, although the
dasd_eer_init function wasn't called before and dasd_eer_exit tries to
unregister a misc device that wasn't registered, which results in a BUG.

Make sure that dasd_eer_exit can be called without initialization. Use a
dynamically allocated struct miscdevice instead of a static one, so we
only try to unregister the device if it exists and was actually registered.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eer.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/drivers/s390/block/dasd_eer.c linux-2.6-patched/drivers/s390/block/dasd_eer.c
--- linux-2.6/drivers/s390/block/dasd_eer.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_eer.c	2007-01-26 17:27:54.000000000 +0100
@@ -658,18 +658,24 @@ static struct file_operations dasd_eer_f
 	.owner		= THIS_MODULE,
 };
 
-static struct miscdevice dasd_eer_dev = {
-	.minor	    = MISC_DYNAMIC_MINOR,
-	.name	    = "dasd_eer",
-	.fops	    = &dasd_eer_fops,
-};
+static struct miscdevice *dasd_eer_dev = NULL;
 
 int __init dasd_eer_init(void)
 {
 	int rc;
 
-	rc = misc_register(&dasd_eer_dev);
+	dasd_eer_dev = kzalloc(sizeof(*dasd_eer_dev), GFP_KERNEL);
+	if (!dasd_eer_dev)
+		return -ENOMEM;
+
+	dasd_eer_dev->minor = MISC_DYNAMIC_MINOR;
+	dasd_eer_dev->name  = "dasd_eer";
+	dasd_eer_dev->fops  = &dasd_eer_fops;
+
+	rc = misc_register(dasd_eer_dev);
 	if (rc) {
+		kfree(dasd_eer_dev);
+		dasd_eer_dev = NULL;
 		MESSAGE(KERN_ERR, "%s", "dasd_eer_init could not "
 		       "register misc device");
 		return rc;
@@ -680,5 +686,9 @@ int __init dasd_eer_init(void)
 
 void dasd_eer_exit(void)
 {
-	WARN_ON(misc_deregister(&dasd_eer_dev) != 0);
+	if (dasd_eer_dev) {
+		WARN_ON(misc_deregister(dasd_eer_dev) != 0);
+		kfree(dasd_eer_dev);
+		dasd_eer_dev = NULL;
+	}
 }
