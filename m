Return-Path: <linux-kernel-owner+w=401wt.eu-S965492AbXBFVKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492AbXBFVKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965490AbXBFVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:10:47 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:9594 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965487AbXBFVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:10:24 -0500
Date: Tue, 6 Feb 2007 22:10:23 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Fixup interface for setting options on ccw devices.
Message-ID: <20070206211023.GC30335@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Fixup interface for setting options on ccw devices.

The current ccw_device_set_options() sets a specified mask of options
and clears those not specified, but there is no way to find out which
options have already been set.

In order to fix this up, introduce the following interface changes:

ccw_device_set_options() now only sets the specified bits, but does
not clear those that are not specified.

ccw_device_clear_options() clears the specified bits.

ccw_device_set_options_mask() provides the old semantics (setting only
the specified bits and clearing the others).

Device drivers now work as expected. qdio has been adapted.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_ops.c |   32 ++++++++++++++++++++++++++++++--
 drivers/s390/cio/qdio.c       |    2 +-
 include/asm-s390/ccwdev.h     |    2 ++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/device_ops.c linux-2.6-patched/drivers/s390/cio/device_ops.c
--- linux-2.6/drivers/s390/cio/device_ops.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_ops.c	2007-02-06 21:43:36.000000000 +0100
@@ -23,8 +23,7 @@
 #include "chsc.h"
 #include "device.h"
 
-int
-ccw_device_set_options(struct ccw_device *cdev, unsigned long flags)
+int ccw_device_set_options_mask(struct ccw_device *cdev, unsigned long flags)
 {
        /*
 	* The flag usage is mutal exclusive ...
@@ -39,6 +38,33 @@ ccw_device_set_options(struct ccw_device
 	return 0;
 }
 
+int ccw_device_set_options(struct ccw_device *cdev, unsigned long flags)
+{
+       /*
+	* The flag usage is mutal exclusive ...
+	*/
+	if (((flags & CCWDEV_EARLY_NOTIFICATION) &&
+	    (flags & CCWDEV_REPORT_ALL)) ||
+	    ((flags & CCWDEV_EARLY_NOTIFICATION) &&
+	     cdev->private->options.repall) ||
+	    ((flags & CCWDEV_REPORT_ALL) &&
+	     cdev->private->options.fast))
+		return -EINVAL;
+	cdev->private->options.fast |= (flags & CCWDEV_EARLY_NOTIFICATION) != 0;
+	cdev->private->options.repall |= (flags & CCWDEV_REPORT_ALL) != 0;
+	cdev->private->options.pgroup |= (flags & CCWDEV_DO_PATHGROUP) != 0;
+	cdev->private->options.force |= (flags & CCWDEV_ALLOW_FORCE) != 0;
+	return 0;
+}
+
+void ccw_device_clear_options(struct ccw_device *cdev, unsigned long flags)
+{
+	cdev->private->options.fast &= (flags & CCWDEV_EARLY_NOTIFICATION) == 0;
+	cdev->private->options.repall &= (flags & CCWDEV_REPORT_ALL) == 0;
+	cdev->private->options.pgroup &= (flags & CCWDEV_DO_PATHGROUP) == 0;
+	cdev->private->options.force &= (flags & CCWDEV_ALLOW_FORCE) == 0;
+}
+
 int
 ccw_device_clear(struct ccw_device *cdev, unsigned long intparm)
 {
@@ -601,7 +627,9 @@ _ccw_device_get_device_number(struct ccw
 
 
 MODULE_LICENSE("GPL");
+EXPORT_SYMBOL(ccw_device_set_options_mask);
 EXPORT_SYMBOL(ccw_device_set_options);
+EXPORT_SYMBOL(ccw_device_clear_options);
 EXPORT_SYMBOL(ccw_device_clear);
 EXPORT_SYMBOL(ccw_device_halt);
 EXPORT_SYMBOL(ccw_device_resume);
diff -urpN linux-2.6/drivers/s390/cio/qdio.c linux-2.6-patched/drivers/s390/cio/qdio.c
--- linux-2.6/drivers/s390/cio/qdio.c	2007-02-06 21:43:03.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/qdio.c	2007-02-06 21:43:36.000000000 +0100
@@ -3194,7 +3194,7 @@ qdio_establish(struct qdio_initialize *i
 
 	spin_lock_irqsave(get_ccwdev_lock(cdev),saveflags);
 
-	ccw_device_set_options(cdev, 0);
+	ccw_device_set_options_mask(cdev, 0);
 	result=ccw_device_start_timeout(cdev,&irq_ptr->ccw,
 					QDIO_DOING_ESTABLISH,0, 0,
 					QDIO_ESTABLISH_TIMEOUT);
diff -urpN linux-2.6/include/asm-s390/ccwdev.h linux-2.6-patched/include/asm-s390/ccwdev.h
--- linux-2.6/include/asm-s390/ccwdev.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/ccwdev.h	2007-02-06 21:43:36.000000000 +0100
@@ -110,7 +110,9 @@ extern void ccw_driver_unregister (struc
 
 struct ccw1;
 
+extern int ccw_device_set_options_mask(struct ccw_device *, unsigned long);
 extern int ccw_device_set_options(struct ccw_device *, unsigned long);
+extern void ccw_device_clear_options(struct ccw_device *, unsigned long);
 
 /* Allow for i/o completion notification after primary interrupt status. */
 #define CCWDEV_EARLY_NOTIFICATION	0x0001
