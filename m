Return-Path: <linux-kernel-owner+w=401wt.eu-S1030837AbXCHWpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837AbXCHWpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030836AbXCHWpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:45:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59661 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030827AbXCHWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:45:52 -0500
Subject: [RFC] [Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Mar 2007 17:58:16 -0500
Message-Id: <1173394696.5981.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments for a new Integrity Based Access
Control(IBAC) LSM module which bases access control decisions
on the new integrity framework services. 

(Hopefully this will help clarify the interaction between an LSM 
module and LIM module.)

Index: linux-2.6.21-rc3-mm2/security/ibac/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.21-rc3-mm2/security/ibac/Kconfig
@@ -0,0 +1,36 @@
+config SECURITY_IBAC
+	boolean "IBAC support"
+	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
+	help
+	  Integrity Based Access Control(IBAC) implements integrity
+	  based access control.
+
+config SECURITY_IBAC_BOOTPARAM
+	bool "IBAC boot parameter"
+	depends on SECURITY_IBAC
+	default y
+	help
+	  This option adds a kernel parameter 'ibac', which allows IBAC
+	  to be disabled at boot.  If this option is selected, IBAC
+	  functionality can be disabled with ibac=0 on the kernel
+	  command line.  The purpose of this option is to allow a
+	  single kernel image to be distributed with IBAC built in,
+	  but not necessarily enabled.
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_IBAC_BOOTPARAM_VALUE
+	int "IBAC boot parameter default value"
+	depends on SECURITY_IBAC_BOOTPARAM
+	range 0 1
+	default 0
+	help
+	  This option sets the default value for the kernel parameter
+	  'ibac', which allows IBAC to be disabled at boot.  If this
+	  option is set to 0 (zero), the IBAC kernel parameter will
+	  default to 0, disabling IBAC at bootup.  If this option is
+	  set to 1 (one), the IBAC kernel parameter will default to 1,
+	  enabling IBAC at bootup.
+
+	  If you are unsure how to answer this question, answer 0.
+
Index: linux-2.6.21-rc3-mm2/security/ibac/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.21-rc3-mm2/security/ibac/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for building IBAC
+#
+
+obj-$(CONFIG_SECURITY_IBAC) += ibac.o
+ibac-y 	:= ibac_main.o
Index: linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
===================================================================
--- /dev/null
+++ linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
@@ -0,0 +1,126 @@
+/*
+ * Integrity Based Access Control (IBAC)
+ *
+ * Copyright (C) 2007 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/integrity.h>
+
+#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
+int ibac_enabled = CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;
+
+static int __init ibac_enabled_setup(char *str)
+{
+	ibac_enabled = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac=", ibac_enabled_setup);
+#else
+int ibac_enabled = 0;
+#endif
+
+static unsigned int integrity_enforce = 0;
+static int __init integrity_enforce_setup(char *str)
+{
+	integrity_enforce = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac_enforce=", integrity_enforce_setup);
+
+#define XATTR_NAME "security.evm.hash"
+
+static inline int is_kernel_thread(struct task_struct *tsk)
+{
+	return (!tsk->mm) ? 1 : 0;
+}
+
+static int ibac_bprm_check_security(struct linux_binprm *bprm)
+{
+	struct dentry *dentry = bprm->file->f_dentry;
+	int xattr_len;
+	char *xattr_value = NULL;
+	int rc, status;
+
+	rc = integrity_verify_metadata(dentry, XATTR_NAME,
+				       &xattr_value, &xattr_len, &status);
+	if (rc < 0 && rc == -EOPNOTSUPP) {
+		kfree(xattr_value);
+		return 0;
+	}
+
+	if (rc < 0) {
+		printk(KERN_INFO "verify_metadata %s failed "
+		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+	if (status != INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "verify_metadata %s "
+			       "(Integrity status: FAIL)\n", bprm->filename);
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+
+	rc = integrity_verify_data(dentry, &status);
+	if (rc < 0) {
+		printk(KERN_INFO "%s verify_data failed "
+		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+	if (status != INTEGRITY_PASS) {
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "verify_data %s "
+			       "(Integrity status: FAIL)\n", bprm->filename);
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+
+	kfree(xattr_value);
+
+	/* measure all integrity level executables */
+	integrity_measure(dentry, bprm->filename, MAY_EXEC);
+	return 0;
+      out:
+	kfree(xattr_value);
+	return rc;
+}
+
+static struct security_operations ibac_security_ops = {
+	.bprm_check_security = ibac_bprm_check_security
+};
+
+static int __init init_ibac(void)
+{
+	int rc;
+
+	if (!ibac_enabled)
+		return 0;
+
+	rc = register_security(&ibac_security_ops);
+	if (rc != 0)
+		panic("IBAC: Unable to register with kernel\n");
+	return rc;
+}
+
+security_initcall(init_ibac);
Index: linux-2.6.21-rc3-mm2/security/Kconfig
===================================================================
--- linux-2.6.21-rc3-mm2.orig/security/Kconfig
+++ linux-2.6.21-rc3-mm2/security/Kconfig
@@ -125,5 +125,6 @@ config SECURITY_ROOTPLUG
 source security/selinux/Kconfig
 
 source security/slim/Kconfig
+source security/ibac/Kconfig
 endmenu
 
Index: linux-2.6.21-rc3-mm2/security/Makefile
===================================================================
--- linux-2.6.21-rc3-mm2.orig/security/Makefile
+++ linux-2.6.21-rc3-mm2/security/Makefile
@@ -14,6 +14,7 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 obj-$(CONFIG_INTEGRITY_EVM)		+= evm/
+obj-$(CONFIG_SECURITY_IBAC)		+= ibac/
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SLIM)		+= slim/
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o



