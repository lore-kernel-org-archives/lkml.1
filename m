Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXE0U3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXE0U3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXE0U2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:28:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbXE0U2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:28:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Sun, 27 May 2007 22:31:53 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl>
In-Reply-To: <200705272229.21263.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272231.54535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use a hibernation and suspend notifier to disable the firmware requesting
mechanism before a hibernation/suspend and enable it after the operation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

 drivers/base/firmware_class.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6.22-rc3/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/base/firmware_class.c	2007-05-27 19:43:03.000000000 +0200
+++ linux-2.6.22-rc3/drivers/base/firmware_class.c	2007-05-27 19:44:06.000000000 +0200
@@ -17,6 +17,8 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
 
 #include <linux/firmware.h>
 #include "base.h"
@@ -35,6 +37,9 @@ enum {
 
 static int loading_timeout = 60;	/* In seconds */
 
+/* If set, _request_firmware() will exit immediately returning -EBUSY */
+static int requesting_firmware_disabled;
+
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
  * guarding for corner cases a global lock should be OK */
 static DEFINE_MUTEX(fw_lock);
@@ -397,6 +402,9 @@ _request_firmware(const struct firmware 
 	struct firmware *firmware;
 	int retval;
 
+	if (requesting_firmware_disabled)
+		return -EBUSY;
+
 	if (!firmware_p)
 		return -EINVAL;
 
@@ -568,6 +576,26 @@ request_firmware_nowait(
 	return 0;
 }
 
+static int firmware_class_pm_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *ignored)
+{
+	switch (action) {
+	case PM_PRE_FREEZE:
+		requesting_firmware_disabled = 1;
+		return NOTIFY_OK;
+	case PM_POST_THAW:
+		requesting_firmware_disabled = 0;
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block firmware_class_pm_nb = {
+	.notifier_call  = firmware_class_pm_callback,
+};
+
 static int __init
 firmware_class_init(void)
 {
@@ -582,6 +610,13 @@ firmware_class_init(void)
 		printk(KERN_ERR "%s: class_create_file failed\n",
 		       __FUNCTION__);
 		class_unregister(&firmware_class);
+		return error;
+	}
+	error = register_pm_notifier(&firmware_class_pm_nb);
+	if (error) {
+		printk(KERN_ERR "%s: register_pm_notifier failed\n",
+		       __FUNCTION__);
+		class_unregister(&firmware_class);
 	}
 	return error;
 
@@ -589,6 +624,7 @@ firmware_class_init(void)
 static void __exit
 firmware_class_exit(void)
 {
+	unregister_pm_notifier(&firmware_class_pm_nb);
 	class_unregister(&firmware_class);
 }
 
