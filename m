Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYKMDud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYKMDud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYKMDt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:49:56 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48109 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYKMDtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:49:53 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
Date: Wed, 12 Nov 2008 22:47:12 -0500
Message-Id: <9395c0a4110469d19100084664900789c34ebd42.1226547084.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version resolves the merge issues resulting from the removal
of the nameidata parameter to inode_permission(), by moving the
integrity_inode_permission() call from inode_permission() to
may_open(), and renaming the hook to integrity_nameidata_check().
The nameidata is needed in order to open and read the file, so
that the file can be hashed(a cryptographically strong checksum.)

This patch also fixes the template locking, preventing the template
from being freed while being used.

This patch is a redesign of the integrity framework, which address a
number of issues, including
   - generalizing the measurement API beyond just inode measurements.
   - separation of the measurement into distinct collection, appraisal,
     and commitment phases, for greater flexibility.

Extended Verification Module(EVM) and the Integrity Measurement
Architecture(IMA) were originally implemented as an LSM module.  Based
on discussions on the LSM mailing list, a decision was made that the
LSM hooks should only be used to enforce mandatory access control
decisions and a new set of hooks should be defined specifically for
integrity.

EVM/IMA was limited to verifying and measuring a file's (i.e. an inode)
integrity and the metadata associated with it.  Current research is
looking into other types of integrity measurements. (i.e. "Linux kernel
integrity measurement using contextual inspection",  by Peter A. Loscocco,
Perry W. Wilson, J. Aaron Pendergrass, C. Durward McDonell,
http://doi.acm.org/10.1145/1314354.1314362). As a result, a requirement
of the new integrity framework is support for different types of integrity
measurements.
This patch provides an integrity framework(api and hooks) and placement
of the integrity hooks in the appropriate places in the fs directory.
Collecting, appraising, and storing of file and other types of integrity
data is supported.  Multiple integrity templates, which implement the
integrity API, may register themselves.  For now, only a single integrity
provider can register itself for the integrity hooks. (Support for multiple
providers registering themselves for the integrity hooks would require
some form of stacking.)

The six integrity hooks are:
   nameidata_check_integrity, inode_alloc_integrity, inode_free_integrity,
   bprm_check_integrity, file_free_integrity, file_mmap

The five integrity API calls provided are:
   integrity_must_measure, integrity_collect_measurement,
   integrity_appraise_measurement, integrity_store_measurement,
   and integrity_display_template.

The type of integrity data being collected, appraised, stored, or
displayed is template dependent.

(Details on the calls and their exact arguments are in linux/integrity.h,
included in the patch.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 784443a..6d4d675 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	INTEGRITY Integrity support is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
 	ISAPNP	ISA PnP code is enabled.
@@ -911,6 +912,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
 			Format: <irq>
 
+	integrity_audit= [INTEGRITY]
+                        Format: { "0" | "1" }
+                        0 -- integrity auditing messages. (Default)
+                        1 -- enable informational integrity auditing messages.
+
 	inttest=	[IA64]
 
 	iommu=		[x86]
diff --git a/fs/exec.c b/fs/exec.c
index 4e834f1..9abcaea 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -45,6 +45,7 @@
 #include <linux/proc_fs.h>
 #include <linux/mount.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
@@ -129,6 +130,9 @@ asmlinkage long sys_uselib(const char __user * library)
 	error = vfs_permission(&nd, MAY_READ | MAY_EXEC | MAY_OPEN);
 	if (error)
 		goto exit;
+	error = integrity_nameidata_check(&nd, MAY_READ | MAY_EXEC | MAY_OPEN);
+	if (error)
+		goto exit;
 
 	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	error = PTR_ERR(file);
@@ -1199,6 +1203,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
+	retval = integrity_bprm_check(bprm);
+	if (retval)
+		return retval;
 
 	/* kernel module loader fixup */
 	/* so we don't try to load run modprobe in kernel space. */
diff --git a/fs/file_table.c b/fs/file_table.c
index 5ad0eca..74b30ba 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/eventpoll.h>
 #include <linux/rcupdate.h>
 #include <linux/mount.h>
@@ -276,6 +277,7 @@ void __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	integrity_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
@@ -347,6 +349,7 @@ void put_filp(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		security_file_free(file);
+		integrity_file_free(file);
 		file_kill(file);
 		file_free(file);
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..bc2c3a5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -143,12 +144,13 @@ static struct inode *alloc_inode(struct super_block *sb)
 		inode->i_cdev = NULL;
 		inode->i_rdev = 0;
 		inode->dirtied_when = 0;
-		if (security_inode_alloc(inode)) {
-			if (inode->i_sb->s_op->destroy_inode)
-				inode->i_sb->s_op->destroy_inode(inode);
-			else
-				kmem_cache_free(inode_cachep, (inode));
-			return NULL;
+		if (security_inode_alloc(inode))
+			goto out_free_inode;
+
+		/* allocate, attach and initialize an i_integrity */
+		if (integrity_inode_alloc(inode)) {
+			security_inode_free(inode);
+			goto out_free_inode;
 		}
 
 		spin_lock_init(&inode->i_lock);
@@ -185,12 +187,20 @@ static struct inode *alloc_inode(struct super_block *sb)
 		inode->i_mapping = mapping;
 	}
 	return inode;
+
+out_free_inode:
+	if (inode->i_sb->s_op->destroy_inode)
+		inode->i_sb->s_op->destroy_inode(inode);
+	else
+		kmem_cache_free(inode_cachep, (inode));
+	return NULL;
 }
 
 void destroy_inode(struct inode *inode) 
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	integrity_inode_free(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
diff --git a/fs/namei.c b/fs/namei.c
index 09ce58e..bae619c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -24,6 +24,7 @@
 #include <linux/fsnotify.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
 #include <linux/audit.h>
@@ -1523,6 +1524,11 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 	error = vfs_permission(nd, acc_mode);
 	if (error)
 		return error;
+
+	error = integrity_nameidata_check(nd, acc_mode
+					  & (MAY_READ | MAY_WRITE | MAY_EXEC));
+	if (error)
+		return error;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6fbebac..0f6b57e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -125,6 +125,11 @@
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
+#define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
+#define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
+#define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
+#define AUDIT_INTEGRITY_HASH	    1803 /* Integrity HASH type */
+#define AUDIT_INTEGRITY_PCR	    1804 /* PCR invalidation msgs */
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
@@ -442,6 +447,8 @@ extern int  audit_set_loginuid(struct task_struct *task, uid_t loginuid);
 #define audit_get_loginuid(t) ((t)->loginuid)
 #define audit_get_sessionid(t) ((t)->sessionid)
 extern void audit_log_task_context(struct audit_buffer *ab);
+extern void audit_log_inode_context(struct audit_buffer *ab,
+				    struct inode *inode);
 extern int __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
 extern int audit_bprm(struct linux_binprm *bprm);
@@ -554,6 +561,7 @@ extern int audit_signals;
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
 #define audit_log_task_context(b) do { ; } while (0)
+#define audit_log_inode_context(b, a) do {  } while (0)
 #define audit_ipc_obj(i) ({ 0; })
 #define audit_ipc_set_perm(q,u,g,m) ({ 0; })
 #define audit_bprm(p) ({ 0; })
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..bc6460c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -683,6 +683,9 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+#ifdef CONFIG_INTEGRITY
+	void			*i_integrity;
+#endif
 	void			*i_private; /* fs or device private pointer */
 };
 
diff --git a/include/linux/integrity.h b/include/linux/integrity.h
new file mode 100644
index 0000000..2fb0ccb
--- /dev/null
+++ b/include/linux/integrity.h
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _LINUX_INTEGRITY_H
+#define _LINUX_INTEGRITY_H
+
+#include <linux/fs.h>
+#include <linux/audit.h>
+
+#ifdef CONFIG_INTEGRITY
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, char *op,
+			 char *cause, int result);
+
+/*
+ * Integrity API calls:
+ *
+ * @collect_measurement:
+ *	Collect template specific measurement data.
+ *	@data contains template specific data used for collecting the
+ *	measurement.
+ * 	Return 0 if operation was successful.
+ *
+ * @appraise_measurement:
+ *	Appraise the integrity of the template specific measurement data.
+ *	@data contains template specific data used for appraising the
+ *	measurement.
+ * 	Return 0 if operation was successful.
+ *
+ * @store_measurement:
+ *	Store the template specific data.
+ *	@data contains template specific data used for storing the
+ *	measurement.
+ *
+ * @must_measure:
+ *	Measurement decision based on an integrity policy.
+ *	@data contains template specific data used for making policy
+ * 	decision.
+ * 	Return 0 if operation was successful.
+ *
+ * @display_template:
+ *	Display template specific data.
+ *
+ */
+
+enum integrity_show_type { INTEGRITY_SHOW_BINARY, INTEGRITY_SHOW_ASCII };
+
+struct template_operations {
+	int (*collect_measurement) (void *);
+	int (*appraise_measurement) (void *);
+	void (*store_measurement) (void *);
+	int (*must_measure) (void *);
+	void (*display_template) (struct seq_file *m, void *,
+				  enum integrity_show_type);
+};
+extern int integrity_register_template(const char *template_name,
+				       const struct template_operations *ops);
+extern int integrity_unregister_template(const char *template_name);
+
+/*
+ * Integrity hooks:
+ *
+ * @bprm_check_integrity:
+ * 	This hook mediates the point when a search for a binary handler	will
+ * 	begin.  At this point, the OS protects against an executable file,
+ * 	already open for write, from being executed; and an executable file
+ * 	already open for execute, from being modified. So we can be certain
+ *	that any measurements(collect, appraise, store) done here are of
+ * 	the file being executed.
+ * 	@bprm contains the linux_binprm structure.
+ *	Return 0 if the hook is successful and permission is granted.
+ *
+ * @inode_alloc_integrity:
+ *	Allocate an integrity structure associated with an inode.
+ * 	@inode contains the inode structure.
+ * 	Return 0 if operation was successful.
+ *
+ * @inode_free_integrity:
+ *	@inode contains the inode structure.
+ * 	Deallocate the integrity structure associated with the inode
+ *
+ * @nameidata_check_integrity:
+ *	This hook is called by the existing Linux may_open function,
+ *	after calling verify_permission(), as a file is opened.  At
+ *	this point, measurements(collect, appraise, store) of files
+ *	open for read can be made.
+ *	@nd contains the nameidata structure.
+ *	@mask contains the permission mask.
+ *	Return 0 if the hook is successful and permission is granted.
+ *
+ * @file_free_integrity:
+ *	Update the integrity xattr value as necessary.
+ * 	@file contains the file structure being closed.
+ *
+ * @file_mmap :
+ *	Measurements(collect, appraise, store) of files mmaped for EXEC
+ *	can be made.
+ *	@file contains the file structure of the file to map (may be NULL).
+ *	@prot contains the protection that will be applied by the kernel.
+ *	Return 0 if the hook is successful and permission is granted.
+ */
+
+enum lim_hooks { INODE_PERMISSION = 1, FILE_MMAP, BPRM_CHECK };
+
+struct integrity_operations {
+	int (*bprm_check_integrity) (struct linux_binprm *bprm);
+	int (*inode_alloc_integrity) (struct inode *inode);
+	void (*inode_free_integrity) (struct inode *inode);
+	int (*nameidata_check_integrity) (struct nameidata *nd, int mask);
+	void (*file_free_integrity) (struct file *file);
+	int (*file_mmap) (struct file *file, unsigned long prot);
+};
+extern int register_integrity(const struct integrity_operations *ops);
+extern int unregister_integrity(const struct integrity_operations *ops);
+
+/* global variables */
+int integrity_collect_measurement(const char *template_name, void *data);
+int integrity_appraise_measurement(const char *template_name, void *data);
+int integrity_must_measure(const char *template_name, void *data);
+int integrity_store_measurement(const char *template_name, void *data);
+
+int integrity_bprm_check(struct linux_binprm *bprm);
+int integrity_inode_alloc(struct inode *inode);
+void integrity_inode_free(struct inode *inode);
+int integrity_nameidata_check(struct nameidata *nd, int mask);
+void integrity_file_free(struct file *file);
+int integrity_file_mmap(struct file *file, unsigned long prot);
+#else
+
+static inline int integrity_bprm_check(struct linux_binprm *bprm)
+{
+	return 0;
+}
+
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{
+	return;
+}
+
+static inline int integrity_nameidata_check(struct nameidata *nd, int mask)
+{
+	return 0;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	return;
+}
+
+static inline int integrity_file_mmap(struct file *file, unsigned long prot)
+{
+	return 0;
+}
+#endif
+#endif
diff --git a/mm/mmap.c b/mm/mmap.c
index de14ac2..9d74949 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/hugetlb.h>
 #include <linux/profile.h>
 #include <linux/module.h>
@@ -1050,6 +1051,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
+	error = integrity_file_mmap(file, prot);
+	if (error)
+		return error;
 
 	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
 			   accountable);
diff --git a/security/Kconfig b/security/Kconfig
index d9f47ce..4c602be 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -126,5 +126,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 source security/selinux/Kconfig
 source security/smack/Kconfig
 
+source security/integrity/Kconfig
+
 endmenu
 
diff --git a/security/Makefile b/security/Makefile
index c05c127..db9efb5 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -17,3 +17,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+
+# Object integrity file lists
+subdir-$(CONFIG_INTEGRITY)		+= integrity
+obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
new file mode 100644
index 0000000..7dcb50e
--- /dev/null
+++ b/security/integrity/Kconfig
@@ -0,0 +1,24 @@
+#
+# Integrity configuration
+#
+
+config INTEGRITY
+	bool "Enable different integrity models"
+	help
+	  This allows you to choose different integrity modules to be
+	  configured into your kernel. Integrity models can collect,
+	  verify, and record measurements, such as of a file's data
+	  and metadata before it is read or executed.
+
+	  If you are unsure how to answer this question, answer N.
+
+config INTEGRITY_AUDIT
+	bool "Integrity audit boot parameter"
+	depends on INTEGRITY
+	default n
+	help
+          This option adds a kernel parameter 'integrity_audit', which
+	  allows informational integrity auditing messages to be enabled
+	  at boot.  If this option is selected, informational integrity
+	  auditing messages can be enabled with 'integrity_audit=1' on
+	  the kernel command line.
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
new file mode 100644
index 0000000..a6e1405
--- /dev/null
+++ b/security/integrity/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the kernel integrity code
+#
+
+# Object file lists
+obj-$(CONFIG_INTEGRITY) += integrity.o integrity_audit.o
diff --git a/security/integrity/integrity.c b/security/integrity/integrity.c
new file mode 100644
index 0000000..c819620
--- /dev/null
+++ b/security/integrity/integrity.c
@@ -0,0 +1,315 @@
+/*
+ * Copyright (C) 2006,2007,2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: integrity.c
+ * 	register integrity subsystem
+ * 	register integrity template
+ */
+
+#include <asm/atomic.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/integrity.h>
+#include "integrity.h"
+
+static const struct integrity_operations *integrity_ops;
+static LIST_HEAD(integrity_templates);
+static DEFINE_MUTEX(integrity_templates_mutex);
+
+/**
+ * register_integrity - registers an integrity framework with the kernel
+ * @ops: a pointer to the struct security_options that is to be registered
+ *
+ * Perhaps in the future integrity module stacking will be necessary, but
+ * for the time being, this function permits only one integrity module to
+ * register itself with the kernel integrity subsystem.
+ *
+ * If another integrity module is already registered, an error code is
+ * returned. On success 0 is returned.
+ */
+int register_integrity(const struct integrity_operations *ops)
+{
+	if (integrity_ops != NULL)
+		return -EAGAIN;
+	integrity_ops = ops;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(register_integrity);
+
+/**
+ * unregister_integrity - unregisters an integrity framework from the kernel
+ * @ops: a pointer to the struct security_options that is to be registered
+ *
+ * Returns 0 on success, -EINVAL on failure.
+ */
+int unregister_integrity(const struct integrity_operations *ops)
+{
+	if (ops != integrity_ops)
+		return -EINVAL;
+
+	integrity_ops = NULL;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(unregister_integrity);
+
+/**
+ * integrity_register_template - registers an integrity template with the kernel
+ * @template_name: a pointer to a string containing the template name.
+ * @template_ops: a pointer to the template functions
+ *
+ * Register a set of functions to collect, appraise, store, and display
+ * a template measurement, and a means to decide whether to do them.
+ * Unlike integrity modules, any number of templates may be registered.
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int integrity_register_template(const char *template_name,
+				const struct template_operations *template_ops)
+{
+	int template_len;
+	struct template_list_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&entry->template);
+
+	atomic_set(&entry->refcount, 1);
+	template_len = strlen(template_name);
+	if (template_len > TEMPLATE_NAME_LEN_MAX) {
+		kfree(entry);
+		return -EINVAL;
+	}
+	strcpy(entry->template_name, template_name);
+	entry->template_ops = template_ops;
+
+	mutex_lock(&integrity_templates_mutex);
+	list_add_rcu(&entry->template, &integrity_templates);
+	mutex_unlock(&integrity_templates_mutex);
+	synchronize_rcu();
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(integrity_register_template);
+
+/**
+ * integrity_unregister_template: unregister a template
+ * @template_name: a pointer to a string containing the template name.
+ *
+ * Returns 0 on success, -EINVAL on failure.
+ */
+int integrity_unregister_template(const char *template_name)
+{
+	struct template_list_entry *entry;
+
+	mutex_lock(&integrity_templates_mutex);
+	list_for_each_entry(entry, &integrity_templates, template) {
+		if (strncmp(entry->template_name, template_name,
+			    strlen(entry->template_name)) == 0) {
+			list_del_rcu(&entry->template);
+			mutex_unlock(&integrity_templates_mutex);
+			synchronize_rcu();
+			tput(entry);
+			return 0;
+		}
+	}
+	mutex_unlock(&integrity_templates_mutex);
+	return -EINVAL;
+}
+
+EXPORT_SYMBOL_GPL(integrity_unregister_template);
+
+/**
+ * integrity_find_template - search the integrity_templates list
+ * @template_name: a pointer to a string containing the template name.
+ * @template_entry: a pointer to an entry in the template list
+ *
+ * Called with an rcu_read_lock
+ * Returns 0 on success, -EINVAL on failure.
+ */
+int integrity_find_template(const char *template_name,
+			    struct template_list_entry **template_entry)
+{
+	struct template_list_entry *entry;
+
+	list_for_each_entry_rcu(entry, &integrity_templates, template) {
+		if (strncmp(entry->template_name, template_name,
+			    strlen(entry->template_name)) == 0) {
+			*template_entry = entry;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+EXPORT_SYMBOL_GPL(integrity_find_template);
+
+/* Start of the integrity API calls */
+
+/**
+ * integrity_collect_measurement - collect template specific measurement
+ * @template_name: a pointer to a string containing the template name.
+ * @data: pointer to template specific data
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int integrity_collect_measurement(const char *template_name, void *data)
+{
+	struct template_list_entry *template_entry;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_entry);
+	tget(template_entry);
+	rcu_read_unlock();
+
+	if (rc == 0 && template_entry)
+		rc = template_entry->template_ops->collect_measurement(data);
+	tput(template_entry);
+	return rc;
+}
+
+EXPORT_SYMBOL_GPL(integrity_collect_measurement);
+
+/**
+ * integrity_appraise_measurement - appraise template specific measurement
+ * @template_name: a pointer to a string containing the template name.
+ * @data: pointer to template specific data
+ *
+ * Returns 0 on success, an error code on failure
+ */
+int integrity_appraise_measurement(const char *template_name, void *data)
+{
+	struct template_list_entry *template_entry;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_entry);
+	tget(template_entry);
+	rcu_read_unlock();
+
+	if (rc == 0 && template_entry)
+		rc = template_entry->template_ops->appraise_measurement(data);
+	tput(template_entry);
+	return rc;
+}
+
+EXPORT_SYMBOL_GPL(integrity_appraise_measurement);
+
+/**
+ * integrity_store_measurement - store template specific measurement
+ * @template_name: a pointer to a string containing the template name.
+ * @data: pointer to template specific data
+ *
+ * Store template specific integrity measurement.
+ */
+int integrity_store_measurement(const char *template_name, void *data)
+{
+	struct template_list_entry *template_entry;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_entry);
+	tget(template_entry);
+	rcu_read_unlock();
+
+	if (rc == 0 && template_entry)
+		template_entry->template_ops->store_measurement(data);
+	tput(template_entry);
+	return rc;
+}
+
+EXPORT_SYMBOL_GPL(integrity_store_measurement);
+
+/**
+ * integrity_must_measure - measure decision based on template policy
+ * @template_name: a pointer to a string containing the template name.
+ * @data: pointer to template specific data
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int integrity_must_measure(const char *template_name, void *data)
+{
+	struct template_list_entry *template_entry;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_entry);
+	tget(template_entry);
+	rcu_read_unlock();
+
+	if (rc == 0 && template_entry)
+		rc = template_entry->template_ops->must_measure(data);
+	tput(template_entry);
+	return rc;
+}
+
+EXPORT_SYMBOL_GPL(integrity_must_measure);
+
+/* Start of the integrity Hooks */
+
+/* Hook used to measure executable file integrity. */
+int integrity_bprm_check(struct linux_binprm *bprm)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->bprm_check_integrity)
+		rc = integrity_ops->bprm_check_integrity(bprm);
+	return rc;
+}
+
+/* Allocate, attach and initialize an inode's i_integrity,
+ * if INTEGRITY is configured.
+ */
+int integrity_inode_alloc(struct inode *inode)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->inode_alloc_integrity)
+		rc = integrity_ops->inode_alloc_integrity(inode);
+	return rc;
+}
+
+/* Hook used to free an inode's i_integrity structure. */
+void integrity_inode_free(struct inode *inode)
+{
+	if (integrity_ops && integrity_ops->inode_free_integrity)
+		integrity_ops->inode_free_integrity(inode);
+}
+
+/* Hook used to measure a file's integrity. */
+int integrity_nameidata_check(struct nameidata *nd, int mask)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->nameidata_check_integrity)
+		rc = integrity_ops->nameidata_check_integrity(nd, mask);
+	return rc;
+}
+
+/* Hook used to update i_integrity data and integrity xattr values
+ * as necessary.
+ */
+void integrity_file_free(struct file *file)
+{
+	if (integrity_ops && integrity_ops->file_free_integrity)
+		integrity_ops->file_free_integrity(file);
+}
+
+/* Hook used to measure integrity of an mmapped file */
+int integrity_file_mmap(struct file *file, unsigned long prot)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->file_mmap)
+		rc = integrity_ops->file_mmap(file, prot);
+	return rc;
+}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
new file mode 100644
index 0000000..2335b1a
--- /dev/null
+++ b/security/integrity/integrity.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#define TEMPLATE_NAME_LEN_MAX 12
+struct template_list_entry {
+	struct list_head template;
+	char template_name[TEMPLATE_NAME_LEN_MAX + 1];
+	const struct template_operations *template_ops;
+	atomic_t refcount;
+};
+
+static inline void tget(struct template_list_entry *entry)
+{
+	if (!entry)
+		return;
+	atomic_inc(&entry->refcount);
+}
+
+static inline void tput(struct template_list_entry *entry)
+{
+	if (!entry)
+		return;
+	if (atomic_dec_and_test(&entry->refcount))
+		kfree(entry);
+}
+
+extern int integrity_find_template(const char *,
+				   struct template_list_entry **entry);
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
new file mode 100644
index 0000000..b23ff67
--- /dev/null
+++ b/security/integrity/integrity_audit.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: integrity_audit.c
+ * 	Audit calls for the integrity subsystem
+ */
+
+#include <linux/audit.h>
+#include <linux/fs.h>
+#include <linux/integrity.h>
+
+static int integrity_audit = 0;
+
+#ifdef CONFIG_INTEGRITY_AUDIT
+static int __init integrity_audit_setup(char *str)
+{
+	ulong audit;
+	int rc;
+	char *op;
+
+	rc = strict_strtoul(str, 0, &audit);
+	if (rc || audit > 1)
+		printk(KERN_INFO "integrity: invalid integrity_audit value\n");
+	else
+		integrity_audit = audit;
+
+	op = integrity_audit ? "integrity_audit_enabled" :
+	    "integrity_audit_not_enabled";
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL, NULL, op, 0);
+	return 1;
+}
+
+__setup("integrity_audit=", integrity_audit_setup);
+#endif
+
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, char *op,
+			 char *cause, int result)
+{
+	struct audit_buffer *ab;
+
+	if (!integrity_audit && result == 1)	/* Skip information messages */
+		return;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
+			 current->pid, current->uid,
+			 audit_get_loginuid(current));
+	//audit_log_task_context(ab);
+	switch (audit_msgno) {
+	case AUDIT_INTEGRITY_DATA:
+	case AUDIT_INTEGRITY_METADATA:
+	case AUDIT_INTEGRITY_PCR:
+		audit_log_format(ab, " op=%s cause=%s", op, cause);
+		break;
+	case AUDIT_INTEGRITY_HASH:
+		audit_log_format(ab, " op=%s hash=%s", op, cause);
+		break;
+	case AUDIT_INTEGRITY_STATUS:
+	default:
+		audit_log_format(ab, " op=%s", op);
+	}
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, current->comm);
+	if (fname) {
+		audit_log_format(ab, " name=");
+		audit_log_untrustedstring(ab, fname);
+	}
+	if (inode)
+		audit_log_format(ab, " dev=%s ino=%lu",
+				 inode->i_sb->s_id, inode->i_ino);
+	audit_log_format(ab, " res=%d", result);
+	audit_log_end(ab);
+}
-- 
1.5.5.1

