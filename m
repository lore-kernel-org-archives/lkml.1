Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZJTFC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZJTFC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZJTFC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:02:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:47622 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZJTFCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:02:55 -0400
Date: Tue, 20 Oct 2009 16:02:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH][RFC] security: remove root_plug
Message-ID: <alpine.LRH.2.00.0910201601340.14695@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    Remove the root_plug example LSM code.  It's unmaintained and
    increasingly broken in various ways.
    
    Made at the 2009 Kernel Summit in Tokyo!
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..5d386b4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -85,7 +85,6 @@ parameter is applicable:
 	PPT	Parallel port support is enabled.
 	PS2	Appropriate PS/2 support is enabled.
 	RAM	RAM disk support is enabled.
-	ROOTPLUG The example Root Plug LSM is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
 			A lot of drivers has their options described inside of
@@ -2163,15 +2162,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
 
-	root_plug.vendor_id=
-			[ROOTPLUG] Override the default vendor ID
-
-	root_plug.product_id=
-			[ROOTPLUG] Override the default product ID
-
-	root_plug.debug=
-			[ROOTPLUG] Enable debugging output
-
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff --git a/security/Kconfig b/security/Kconfig
index fb363cd..aeea8c2 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -100,19 +100,6 @@ config SECURITY_FILE_CAPABILITIES
 
 	  If in doubt, answer N.
 
-config SECURITY_ROOTPLUG
-	bool "Root Plug Support"
-	depends on USB=y && SECURITY
-	help
-	  This is a sample LSM module that should only be used as such.
-	  It prevents any programs running with egid == 0 if a specific
-	  USB device is not present in the system.
-
-	  See <http://www.linuxjournal.com/article.php?sid=6279> for
-	  more information about this module.
-
-	  If you are unsure how to answer this question, answer N.
-
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
 	depends on HAVE_INTEL_TXT
diff --git a/security/Makefile b/security/Makefile
index 95ecc06..bb44e35 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
-obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/commoncap.c b/security/commoncap.c
index fe30751..45b87af 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1,4 +1,4 @@
-/* Common capabilities, needed by capability.o and root_plug.o
+/* Common capabilities, needed by capability.o.
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
diff --git a/security/root_plug.c b/security/root_plug.c
deleted file mode 100644
index 2f7ffa6..0000000
--- a/security/root_plug.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Root Plug sample LSM module
- *
- * Originally written for a Linux Journal.
- *
- * Copyright (C) 2002 Greg Kroah-Hartman <greg@kroah.com>
- *
- * Prevents any programs running with egid == 0 if a specific USB device
- * is not present in the system.  Yes, it can be gotten around, but is a
- * nice starting point for people to play with, and learn the LSM
- * interface.
- *
- * If you want to turn this into something with a semblance of security,
- * you need to hook the task_* functions also.
- *
- * See http://www.linuxjournal.com/article.php?sid=6279 for more information
- * about this code.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2 of the
- *	License.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/security.h>
-#include <linux/usb.h>
-#include <linux/moduleparam.h>
-
-/* default is a generic type of usb to serial converter */
-static int vendor_id = 0x0557;
-static int product_id = 0x2008;
-
-module_param(vendor_id, uint, 0400);
-module_param(product_id, uint, 0400);
-
-/* should we print out debug messages */
-static int debug = 0;
-
-module_param(debug, bool, 0600);
-
-#define MY_NAME "root_plug"
-
-#define root_dbg(fmt, arg...)					\
-	do {							\
-		if (debug)					\
-			printk(KERN_DEBUG "%s: %s: " fmt ,	\
-				MY_NAME , __func__ , 	\
-				## arg);			\
-	} while (0)
-
-static int rootplug_bprm_check_security (struct linux_binprm *bprm)
-{
-	struct usb_device *dev;
-
-	root_dbg("file %s, e_uid = %d, e_gid = %d\n",
-		 bprm->filename, bprm->cred->euid, bprm->cred->egid);
-
-	if (bprm->cred->egid == 0) {
-		dev = usb_find_device(vendor_id, product_id);
-		if (!dev) {
-			root_dbg("e_gid = 0, and device not found, "
-				 "task not allowed to run...\n");
-			return -EPERM;
-		}
-		usb_put_dev(dev);
-	}
-
-	return 0;
-}
-
-static struct security_operations rootplug_security_ops = {
-	.bprm_check_security =		rootplug_bprm_check_security,
-};
-
-static int __init rootplug_init (void)
-{
-	/* register ourselves with the security framework */
-	if (register_security (&rootplug_security_ops)) {
-		printk (KERN_INFO 
-			"Failure registering Root Plug module with the kernel\n");
-			return -EINVAL;
-	}
-	printk (KERN_INFO "Root Plug module initialized, "
-		"vendor_id = %4.4x, product id = %4.4x\n", vendor_id, product_id);
-	return 0;
-}
-
-security_initcall (rootplug_init);

-- 
James Morris
<jmorris@namei.org>
