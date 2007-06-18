Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbXFRUpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbXFRUpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763705AbXFRUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:45:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40631 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762455AbXFRUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:45:16 -0400
Subject: [RFC][Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 18 Jun 2007 16:48:10 -0400
Message-Id: <1182199690.8577.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-release of Integrity Based Access Control(IBAC) LSM module
which bases access control decisions on the new integrity framework
services.  IBAC is a sample LSM module to help clarify the interaction
between LSM and Linux Integrity Modules(LIM).

New to this release of IBAC is digsig's functionality of preventing
files open for write to be mmapped, and files that are mmapped from being
opened for write.

IBAC originally verified/measured executables only in the
bprm_check_security() hook.  By only doing the verification/measurement
in bprm_check_security(), libraries could be loaded without first being
verified/measured.  This release of IBAC, files are also verified/measured 
in the file_mmap() hook, which catches the libraries, and inode_permission() 
hook, which verifies/measures files tagged, by a userspace application,
with the extended attribute 'security.measure'.

IBAC can be included or excluded in the kernel configuration.  If
included in the kernel and IBAC_BOOTPARAM is enabled, IBAC can also be
enabled/disabled on the kernel command line with 'ibac='.

IBAC can be configured to either verify and enforce integrity or to just log
integrity failures on the kernel command line with 'ibac_enforce='.  When
IBAC_BOOTPARAM is enabled, the default is only to log integrity failures.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---

Index: linux-2.6.22-rc4-mm2/security/ibac/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4-mm2/security/ibac/Kconfig
@@ -0,0 +1,54 @@
+config SECURITY_IBAC
+	boolean "IBAC support"
+	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
+	help
+	  Integrity Based Access Control(IBAC) uses the Linux
+	  Integrity Module(LIM) API calls to verify an executable's
+	  metadata and data's integrity.  Based on the results,
+	  execution permission is permitted/denied.  Integrity
+	  providers may implement the LIM hooks differently.  For
+	  more information on integrity verification refer to the
+	  specific integrity provider documentation.
+
+config SECURITY_IBAC_BOOTPARAM
+	bool "IBAC boot parameter"
+	depends on SECURITY_IBAC
+	default n
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
+	  'ibac', which allows IBAC to be enabled at boot.  If this
+	  option is set to 1 (one), the IBAC kernel parameter will
+	  default to 1, enabling IBAC at bootup.  If this option is
+	  set to 0 (zero), the IBAC kernel parameter will default to 0,
+	  disabling IBAC at bootup.
+
+	  If you are unsure how to answer this question, answer 0.
+
+config SECURITY_IBAC_ENFORCE
+	bool "IBAC integrity enforce boot parameter"
+	depends on SECURITY_IBAC_BOOTPARAM
+	default y
+	help
+	  This option adds a kernel parameter 'ibac_enforce', which
+	  allows integrity enforcement to be enabled/disabled at boot.
+	  If this option is selected, integrity enforcement can be
+	  enabled with ibac_enforce=1 on the kernel command line.
+	  The default is not to enforce integrity, but simply log
+	  integrity verification errors.
+
+	  If you are unsure how to answer this question, answer Y.
Index: linux-2.6.22-rc4-mm2/security/ibac/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4-mm2/security/ibac/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for building IBAC
+#
+
+obj-$(CONFIG_SECURITY_IBAC) += ibac.o
+ibac-y 	:= ibac_main.o
Index: linux-2.6.22-rc4-mm2/security/ibac/ibac_main.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4-mm2/security/ibac/ibac_main.c
@@ -0,0 +1,434 @@
+/*
+ * Integrity Based Access Control(IBAC) sample LSM module calling LIM hooks.
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
+#include <linux/mm.h>
+#include <linux/security.h>
+#include <linux/xattr.h>
+#include <linux/integrity.h>
+#include <linux/writeback.h>
+
+#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
+static int ibac_enabled = CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;
+
+static int __init ibac_enabled_setup(char *str)
+{
+	ibac_enabled = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac=", ibac_enabled_setup);
+
+static int integrity_enforce;
+static int __init integrity_enforce_setup(char *str)
+{
+	integrity_enforce = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac_enforce=", integrity_enforce_setup);
+
+#else
+static int ibac_enabled = 1;
+static int integrity_enforce = 1;
+#endif
+
+#define get_file_security(file) ((unsigned long)(file->f_security))
+#define set_file_security(file, val) (file->f_security = (void *)val)
+
+#define get_task_security(task) ((unsigned long)(task->security))
+#define set_task_security(task, val) (task->security = (void *)val)
+
+#define XATTR_MEASURE_SUFFIX "measure"
+#define XATTR_MEASURE_SUFFIX_LEN (sizeof (XATTR_MEASURE_SUFFIX) -1)
+
+struct ibac_isec_data {
+	int mmapped;		/* no. of times inode mmapped */
+	int measure;		/* inode tagged to be measured */
+	spinlock_t lock;	/* protect inode state */
+};
+
+static int ibac_inode_alloc_security(struct inode *inode)
+{
+	struct ibac_isec_data *isec;
+
+	isec = kzalloc(sizeof(struct ibac_isec_data), GFP_KERNEL);
+	if (!isec)
+		return -ENOMEM;
+
+	spin_lock_init(&isec->lock);
+	inode->i_security = isec;
+	return 0;
+}
+
+static void ibac_inode_free_security(struct inode *inode)
+{
+	struct ibac_isec_data *isec = inode->i_security;
+
+	if (isec) {
+		inode->i_security = NULL;
+		kfree(isec);
+	}
+}
+
+/*
+ * For all inodes allocate inode->i_security(isec), before the security
+ * subsystem is enabled.
+ */
+static void ibac_fixup_inodes(void)
+{
+	struct super_block *sb;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		struct inode *inode;
+
+		spin_unlock(&sb_lock);
+
+		spin_lock(&inode_lock);
+		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+			spin_unlock(&inode_lock);
+
+			spin_lock(&inode->i_lock);
+			if (!inode->i_security)
+				ibac_inode_alloc_security(inode);
+			spin_unlock(&inode->i_lock);
+
+			spin_lock(&inode_lock);
+		}
+		spin_unlock(&inode_lock);
+
+		spin_lock(&sb_lock);
+	}
+	spin_unlock(&sb_lock);
+}
+
+static void ibac_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	struct ibac_isec_data *isec;
+	char *xattr_flags = XATTR_SECURITY_PREFIX XATTR_MEASURE_SUFFIX;
+
+	if (!inode)
+		return;
+
+	if (!inode->i_op || !inode->i_op->getxattr)
+		return;
+
+	if (vfs_getxattr(dentry, xattr_flags, NULL, 0) > 0) {
+		isec = inode->i_security;
+		spin_lock(&isec->lock);
+		isec->measure = 1;
+		spin_unlock(&isec->lock);
+	}
+}
+
+static inline int is_kernel_thread(struct task_struct *tsk)
+{
+	return (!tsk->mm) ? 1 : 0;
+}
+
+static int verify_metadata_integrity(struct dentry *dentry)
+{
+	int rc, status;
+
+	if (!dentry)
+		return 0;
+
+	rc = integrity_verify_metadata(dentry, NULL, NULL, NULL, &status);
+	if (rc == -EOPNOTSUPP)
+		return 0;
+
+	if (rc < 0) {
+		printk(KERN_INFO "ibac: verify_metadata %s failed"
+		       "(rc: %d - status: %d)\n",
+		       dentry->d_name.name, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+	if (status != INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "ibac: verify_metadata %s "
+			       "(Integrity status: %s)\n",
+			       dentry->d_name.name,
+			       status == INTEGRITY_FAIL ? "FAIL" : "NOLABEL");
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+	return 0;
+out:
+	return rc;
+}
+
+static int verify_and_measure_integrity(struct dentry *dentry,
+					struct file *file,
+					char *filename, int mask)
+{
+	int rc, status;
+
+	if (!dentry && !file)
+		return 0;
+
+	rc = integrity_verify_data(dentry, file, &status);
+	if (rc < 0) {
+		printk(KERN_INFO "ibac: %s verify_data failed "
+		       "(rc: %d - status: %d)\n", filename, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+
+	if (status != INTEGRITY_PASS) {
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "ibac: verify_data %s "
+			       "(Integrity status: FAIL)\n", filename);
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+
+	/* Only measure files that passed integrity verification. */
+	integrity_measure(dentry, file, filename, mask);
+	return 0;
+out:
+	/*
+	 * Verification failed, but as integrity is not being enforced,
+	 * we still need to measure.
+	 */
+	if (rc == 0)
+		integrity_measure(dentry, file, filename, mask);
+	return rc;
+}
+
+static int ibac_inode_permission(struct inode *inode, int mask,
+				 struct nameidata *nd)
+{
+	struct ibac_isec_data *isec = inode->i_security;
+	struct dentry *dentry;
+	char *path = NULL;
+	char *fname = NULL;
+	int rc = 0;
+	int measure;
+
+	dentry = (!nd || !nd->dentry) ? d_find_alias(inode) : nd->dentry;
+	if (!dentry)
+		return 0;
+	if (nd) {		/* preferably use fullname */
+		path = (char *)__get_free_page(GFP_KERNEL);
+		if (path)
+			fname = d_path(nd->dentry, nd->mnt, path, PAGE_SIZE);
+	}
+
+	if (!fname)		/* no choice, use short name */
+		fname = (!dentry->d_name.name) ? (char *)dentry->d_iname :
+		    (char *)dentry->d_name.name;
+
+	/* Measure labeled files */
+	spin_lock(&isec->lock);
+	measure = isec->measure;
+	spin_unlock(&isec->lock);
+
+	if (S_ISREG(inode->i_mode) && (measure == 1)
+	    && (mask & MAY_READ)) {
+		rc = verify_metadata_integrity(dentry);
+		if (rc == 0)
+			rc = verify_and_measure_integrity(dentry, NULL,
+							  fname, mask);
+	}
+
+	/* Deny permission to write, if currently mmapped. */
+	if (inode && mask & MAY_WRITE) {
+		spin_lock(&isec->lock);
+		if (isec->mmapped > 0) {
+			printk(KERN_INFO "%s: %s - denied write access"
+			       " (isec=%d)\n",
+			       __FUNCTION__, fname, isec->mmapped);
+			rc = -EPERM;
+		}
+		spin_unlock(&isec->lock);
+	}
+
+	if (!nd || !nd->dentry)
+		dput(dentry);
+	if (path)
+		free_page((unsigned long)path);
+	return rc;
+}
+
+/*
+ * If the file is opened for writing, deny mmap(PROT_EXEC) access.
+ * Otherwise, increment the inode->i_security, which is our own
+ * writecount.  When the file is closed, f->f_security will be 1,
+ * and so we will decrement the inode->i_security.
+ * Just to be clear:
+ * 	file->f_security is 1 or 0.
+ * 	inode->i_security->mmapped is the *number* of processes which
+ * 		have this file mmapped(PROT_EXEC), so it can be >1.
+ */
+static int ibac_deny_write_access(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ibac_isec_data *isec = inode->i_security;
+
+	spin_lock(&inode->i_lock);
+	if (atomic_read(&inode->i_writecount) > 0) {
+		spin_unlock(&inode->i_lock);
+		return -ETXTBSY;
+	}
+
+	spin_lock(&isec->lock);
+	isec->mmapped += 1;
+	spin_unlock(&isec->lock);
+	set_file_security(file, 1);
+	spin_unlock(&inode->i_lock);
+
+	return 0;
+}
+
+/*
+ * decrement our writer count on the inode.  When it hits 0, we will
+ * again allow opening the inode for writing.
+ */
+static void ibac_allow_write_access(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ibac_isec_data *isec = inode->i_security;
+
+	spin_lock(&inode->i_lock);
+	spin_lock(&isec->lock);
+	isec->mmapped -= 1;
+	spin_unlock(&isec->lock);
+	set_file_security(file, 0);
+	spin_unlock(&inode->i_lock);
+}
+
+/*
+ * the file is being closed.  If we ever mmaped it for exec, then
+ * file->f_security>0, and we decrement the inode usage count to
+ * show that we are done with it.
+ */
+static void ibac_file_free_security(struct file *file)
+{
+	if (file->f_security)
+		ibac_allow_write_access(file);
+}
+
+/*
+ * We don't want to validate files which can be written while they are
+ * being executed.
+ * This means NFS.
+ */
+static inline int is_unprotected_file(struct file *file)
+{
+	if (strcmp(file->f_dentry->d_inode->i_sb->s_type->name, "nfs") == 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Verify data integrity, metadata integrity and measure it.
+ */
+static int ibac_file_mmap(struct file *file,
+			  unsigned long reqprot,
+			  unsigned long calcprot, unsigned long flags)
+{
+	unsigned long prot = reqprot;
+	int rc;
+
+	if (!(prot & VM_EXEC))
+		return 0;
+	if (!file || !file->f_dentry)
+		return 0;
+
+	if (is_unprotected_file(file))
+		return (-EPERM);
+	/*
+	 * if file_security is set, then this process has already
+	 * incremented the writer count on this inode, don't do
+	 * it again.
+	 */
+	if (get_file_security(file) == 0) {
+		rc = ibac_deny_write_access(file);
+		if (rc) {
+			if (S_ISCHR(file->f_dentry->d_inode->i_mode))
+				rc = 0;
+			goto out;
+		}
+	}
+
+	rc = verify_metadata_integrity(file->f_dentry);
+	if (rc == 0) {
+		char *fname = NULL;
+		char *path = NULL;
+
+		path = (char *)__get_free_page(GFP_KERNEL);
+		if (path)
+			fname = d_path(file->f_dentry, file->f_path.mnt,
+				       path, PAGE_SIZE);
+
+		if (!fname)	/* no choice, use short name */
+			fname = (!file->f_dentry->d_name.name) ?
+			    (char *)file->f_dentry->d_iname :
+			    (char *)file->f_dentry->d_name.name;
+
+		rc = verify_and_measure_integrity(NULL, file, fname, MAY_EXEC);
+		if (path)
+			free_page((unsigned long)path);
+	}
+out:
+	return rc;
+}
+
+static int ibac_bprm_check_security(struct linux_binprm *bprm)
+{
+	struct dentry *dentry = bprm->file->f_dentry;
+	int rc;
+
+	rc = verify_metadata_integrity(dentry);
+	if (rc == 0)
+		rc = verify_and_measure_integrity(dentry,
+						  bprm->file, bprm->filename,
+						  MAY_EXEC);
+	return rc;
+}
+
+static struct security_operations ibac_security_ops = {
+	.bprm_check_security = ibac_bprm_check_security,
+	.file_mmap = ibac_file_mmap,
+	.file_free_security = ibac_file_free_security,
+	.inode_alloc_security = ibac_inode_alloc_security,
+	.inode_free_security = ibac_inode_free_security,
+	.inode_permission = ibac_inode_permission,
+	.d_instantiate = ibac_d_instantiate
+};
+
+static int __init init_ibac(void)
+{
+	int rc;
+
+	if (!ibac_enabled)
+		return 0;
+
+	ibac_fixup_inodes();
+	rc = register_security(&ibac_security_ops);
+	if (rc != 0)
+		panic("ibac: unable to register with kernel\n");
+	return rc;
+}
+
+security_initcall(init_ibac);
Index: linux-2.6.22-rc4-mm2/security/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm2.orig/security/Kconfig
+++ linux-2.6.22-rc4-mm2/security/Kconfig
@@ -114,5 +114,6 @@ config SECURITY_ROOTPLUG
 
 source security/selinux/Kconfig
 
+source security/ibac/Kconfig
 endmenu
 
Index: linux-2.6.22-rc4-mm2/security/Makefile
===================================================================
--- linux-2.6.22-rc4-mm2.orig/security/Makefile
+++ linux-2.6.22-rc4-mm2/security/Makefile
@@ -14,6 +14,7 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 obj-$(CONFIG_IMA_MEASURE)		+= ima/
+obj-$(CONFIG_SECURITY_IBAC)		+= ibac/
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
Index: linux-2.6.22-rc4-mm2/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.22-rc4-mm2.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.22-rc4-mm2/Documentation/kernel-parameters.txt
@@ -42,6 +42,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	IBAC	Integrity Based Access Control support is enabled.
 	IMA	Integrity measurement architecture is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
@@ -761,6 +762,17 @@ and is between 256 and 4096 characters. 
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ibac=		[IBAC] Disable or enable IBAC at boot time.
+                        Format: { "0" | "1" }
+                        See security/ibac/Kconfig help text.
+                        0 -- disable.
+                        1 -- enable.
+                        Default value is set via kernel config option.
+
+	ibac_enforce=	[IBAC] Enable integrity enforcing at boot time.
+                        Format: { "0" | "1" }
+                        Default is 0 to disable integrity enforcing.
+
 	ima=		[IMA] Disable or enable IMA at boot time.
 			Format: { "0" | "1" }
 			See security/ima/Kconfig help text.


