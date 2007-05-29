Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXE2HZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXE2HZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXE2HZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:25:49 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:16378 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbXE2HZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:25:49 -0400
Date: Tue, 29 May 2007 09:25:43 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Tilman Schmidt" <tilman@imap.cc>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46585953.80200@imap.cc>
	<20070526090117.dda72286.akpm@linux-foundation.org>
	<465A033C.3070400@imap.cc>
	<3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 00:41:19 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> Cornelia,
> in the patch is:
>   +	if (dev->kobj.parent == &dev->class->subsys.kobj)
>   +		return 0;
> 
> which will skip the creation of the "device"-link, right?

...and this is certainly broken. Argl.

Could those folks that had trouble with this kernel check out whether
the following patch helps?


From: Cornelia Huck <cornelia.huck@de.ibm.com>

Fix check when to create certain symlinks (the device link and some
compatible links).

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -657,12 +657,12 @@ static int device_add_class_symlinks(str
 	 * If this is not a "fake" compatible device, then create the
 	 * symlink from the class to the device.
 	 */
-	if (dev->kobj.parent == &dev->class->subsys.kobj)
-		return 0;
-	error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
-				  dev->bus_id);
-	if (error)
-		goto out_subsys;
+	if (dev->kobj.parent != &dev->class->subsys.kobj) {
+		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+					  dev->bus_id);
+		if (error)
+			goto out_subsys;
+	}
 	if (dev->parent) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
@@ -689,7 +689,8 @@ out_device:
 		sysfs_remove_link(&dev->kobj, "device");
 #endif
 out_busid:
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out:
@@ -712,7 +713,8 @@ static void device_remove_class_symlinks
 #endif
 		sysfs_remove_link(&dev->kobj, "device");
 	}
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
