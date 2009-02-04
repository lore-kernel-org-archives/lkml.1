Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZBDOUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZBDOUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZBDOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:35 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55374 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZBDOTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:30 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/7] integrity: IMA as an integrity service provider
Date: Wed,  4 Feb 2009 09:06:58 -0500
Message-Id: <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA provides hardware (TPM) based measurement and attestation for
file measurements. As the Trusted Computing (TPM) model requires,
IMA measures all files before they are accessed in any way (on the
integrity_bprm_check, integrity_path_check and integrity_file_mmap
hooks), and commits the measurements to the TPM. Once added to the
TPM, measurements can not be removed.

In addition, IMA maintains a list of these file measurements, which
can be used to validate the aggregate value stored in the TPM.  The
TPM can sign these measurements, and thus the system can prove, to
itself and to a third party, the system's integrity in a way that
cannot be circumvented by malicious or compromised software.

- alloc ima_template_entry before calling ima_store_template()
- log ima_add_boot_aggregate() failure
- removed unused IMA_TEMPLATE_NAME_LEN
- replaced hard coded string length with #define name

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7c67b94..31e0c2c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -895,6 +895,15 @@ and is between 256 and 4096 characters. It is defined in the file
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_audit=	[IMA]
+			Format: { "0" | "1" }
+			0 -- integrity auditing messages. (Default)
+			1 -- enable informational integrity auditing messages.
+
+	ima_hash=	[IMA]
+			Formt: { "sha1" | "md5" }
+			default: "sha1"
+
 	in2000=		[HW,SCSI]
 			See header of drivers/scsi/in2000.c.
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 26c4f6f..8d1f677 100644
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
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 4ed1e4d..dcc3664 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -12,6 +12,15 @@
 #ifndef _LINUX_IMA_H
 #define _LINUX_IMA_H
 
+#ifdef CONFIG_IMA
+extern int ima_bprm_check(struct linux_binprm *bprm);
+extern int ima_inode_alloc(struct inode *inode);
+extern void ima_inode_free(struct inode *inode);
+extern int ima_path_check(struct path *path, int mask);
+extern void ima_file_free(struct file *file);
+extern int ima_file_mmap(struct file *file, unsigned long prot);
+
+#else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
 {
 	return 0;
@@ -41,4 +50,5 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
 {
 	return 0;
 }
+#endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/Kconfig b/security/Kconfig
index d9f47ce..a79b23f 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -55,7 +55,8 @@ config SECURITYFS
 	bool "Enable the securityfs filesystem"
 	help
 	  This will build the securityfs filesystem.  It is currently used by
-	  the TPM bios character driver.  It is not used by SELinux or SMACK.
+	  the TPM bios character driver and IMA, an integrity provider.  It is
+	  not used by SELinux or SMACK.
 
 	  If you are unsure how to answer this question, answer N.
 
@@ -126,5 +127,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 source security/selinux/Kconfig
 source security/smack/Kconfig
 
+source security/integrity/ima/Kconfig
+
 endmenu
 
diff --git a/security/Makefile b/security/Makefile
index c05c127..595536c 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -17,3 +17,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+
+# Object integrity file lists
+subdir-$(CONFIG_IMA)			+= integrity/ima
+obj-$(CONFIG_IMA)			+= integrity/ima/built-in.o
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
new file mode 100644
index 0000000..2a761c8
--- /dev/null
+++ b/security/integrity/ima/Kconfig
@@ -0,0 +1,49 @@
+# IBM Integrity Measurement Architecture
+#
+config IMA
+	bool "Integrity Measurement Architecture(IMA)"
+	depends on ACPI
+	select SECURITYFS
+	select CRYPTO
+	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select TCG_TPM
+	select TCG_TIS
+	help
+	  The Trusted Computing Group(TCG) runtime Integrity
+	  Measurement Architecture(IMA) maintains a list of hash
+	  values of executables and other sensitive system files,
+	  as they are read or executed. If an attacker manages
+	  to change the contents of an important system file
+	  being measured, we can tell.
+
+	  If your system has a TPM chip, then IMA also maintains
+	  an aggregate integrity value over this list inside the
+	  TPM hardware, so that the TPM can prove to a third party
+	  whether or not critical system files have been modified.
+	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
+	  to learn more about IMA.
+	  If unsure, say N.
+
+config IMA_MEASURE_PCR_IDX
+	int
+	depends on IMA
+	range 8 14
+	default 10
+	help
+	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
+	  that IMA uses to maintain the integrity aggregate of the
+	  measurement list.  If unsure, use the default 10.
+
+config IMA_AUDIT
+	bool
+	depends on IMA
+	default y
+	help
+	  This option adds a kernel parameter 'ima_audit', which
+	  allows informational auditing messages to be enabled
+	  at boot.  If this option is selected, informational integrity
+	  auditing messages can be enabled with 'ima_audit=1' on
+	  the kernel command line.
+
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
new file mode 100644
index 0000000..9d6bf97
--- /dev/null
+++ b/security/integrity/ima/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for building Trusted Computing Group's(TCG) runtime Integrity
+# Measurement Architecture(IMA).
+#
+
+obj-$(CONFIG_IMA) += ima.o
+
+ima-y := ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
+	 ima_policy.o ima_iint.o ima_audit.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
new file mode 100644
index 0000000..bfa72ed
--- /dev/null
+++ b/security/integrity/ima/ima.h
@@ -0,0 +1,135 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima.h
+ *	internal Integrity Measurement Architecture (IMA) definitions
+ */
+
+#ifndef __LINUX_IMA_H
+#define __LINUX_IMA_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/security.h>
+#include <linux/hash.h>
+#include <linux/tpm.h>
+#include <linux/audit.h>
+
+enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_ASCII };
+enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
+
+/* digest size for IMA, fits SHA1 or MD5 */
+#define IMA_DIGEST_SIZE		20
+#define IMA_EVENT_NAME_LEN_MAX	255
+
+#define IMA_HASH_BITS 9
+#define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
+
+/* set during initialization */
+extern int ima_initialized;
+extern int ima_used_chip;
+extern char *ima_hash;
+
+/* IMA inode template definition */
+struct ima_template_data {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
+	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+};
+
+struct ima_template_entry {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
+	char *template_name;
+	int template_len;
+	struct ima_template_data template;
+};
+
+struct ima_queue_entry {
+	struct hlist_node hnext;	/* place in hash collision list */
+	struct list_head later;		/* place in ima_measurements list */
+	struct ima_template_entry *entry;
+};
+extern struct list_head ima_measurements;	/* list of all measurements */
+
+/* declarations */
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, const char *op,
+			 const char *cause, int result, int info);
+
+/* Internal IMA function definitions */
+void ima_iintcache_init(void);
+int ima_init(void);
+int ima_add_template_entry(struct ima_template_entry *entry, int violation,
+			   const char *op, struct inode *inode);
+int ima_calc_hash(struct file *file, char *digest);
+int ima_calc_template_hash(int template_len, void *template, char *digest);
+int ima_calc_boot_aggregate(char *digest);
+void ima_add_violation(struct inode *inode, const unsigned char *filename,
+		       const char *op, const char *cause);
+
+/*
+ * used to protect h_table and sha_table
+ */
+extern spinlock_t ima_queue_lock;
+
+struct ima_h_table {
+	atomic_long_t len;	/* number of stored measurements in the list */
+	atomic_long_t violations;
+	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
+};
+extern struct ima_h_table ima_htable;
+
+static inline unsigned long ima_hash_key(u8 *digest)
+{
+	return hash_long(*digest, IMA_HASH_BITS);
+}
+
+/* iint cache flags */
+#define IMA_MEASURED		1
+
+/* integrity data associated with an inode */
+struct ima_iint_cache {
+	u64 version;		/* track inode changes */
+	unsigned long flags;
+	u8 digest[IMA_DIGEST_SIZE];
+	struct mutex mutex;	/* protects: version, flags, digest */
+	long readcount;		/* measured files readcount */
+	long writecount;	/* measured files writecount */
+	struct kref refcount;	/* ima_iint_cache reference count */
+	struct rcu_head rcu;
+};
+
+/* LIM API function definitions */
+int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
+		     int mask, int function);
+int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file);
+void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
+			   const unsigned char *filename);
+int ima_store_template(struct ima_template_entry *entry, int violation,
+		       struct inode *inode);
+
+/* radix tree calls to lookup, insert, delete
+ * integrity data associated with an inode.
+ */
+struct ima_iint_cache *ima_iint_insert(struct inode *inode);
+struct ima_iint_cache *ima_iint_find_get(struct inode *inode);
+struct ima_iint_cache *ima_iint_find_insert_get(struct inode *inode);
+void ima_iint_delete(struct inode *inode);
+void iint_free(struct kref *kref);
+void iint_rcu_free(struct rcu_head *rcu);
+
+/* IMA policy related functions */
+enum ima_hooks { PATH_CHECK = 1, FILE_MMAP, BPRM_CHECK };
+
+int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
+void ima_init_policy(void);
+void ima_update_policy(void);
+#endif
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
new file mode 100644
index 0000000..a148a25
--- /dev/null
+++ b/security/integrity/ima/ima_api.c
@@ -0,0 +1,190 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ *
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_api.c
+ *	Implements must_measure, collect_measurement, store_measurement,
+ *	and store_template.
+ */
+#include <linux/module.h>
+
+#include "ima.h"
+static char *IMA_TEMPLATE_NAME = "ima";
+
+/*
+ * ima_store_template - store ima template measurements
+ *
+ * Calculate the hash of a template entry, add the template entry
+ * to an ordered list of measurement entries maintained inside the kernel,
+ * and also update the aggregate integrity value (maintained inside the
+ * configured TPM PCR) over the hashes of the current list of measurement
+ * entries.
+ *
+ * Applications retrieve the current kernel-held measurement list through
+ * the securityfs entries in /sys/kernel/security/ima. The signed aggregate
+ * TPM PCR (called quote) can be retrieved using a TPM user space library
+ * and is used to validate the measurement list.
+ *
+ * Returns 0 on success, error code otherwise
+ */
+int ima_store_template(struct ima_template_entry *entry,
+		       int violation, struct inode *inode)
+{
+	const char *op = "add_template_measure";
+	const char *audit_cause = "hashing_error";
+	int result;
+
+	memset(entry->digest, 0, sizeof(entry->digest));
+	entry->template_name = IMA_TEMPLATE_NAME;
+	entry->template_len = sizeof(entry->template);
+
+	if (!violation) {
+		result = ima_calc_template_hash(entry->template_len,
+						&entry->template,
+						entry->digest);
+		if (result < 0) {
+			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
+					    entry->template_name, op,
+					    audit_cause, result, 0);
+			return result;
+		}
+	}
+	result = ima_add_template_entry(entry, violation, op, inode);
+	return result;
+}
+
+/*
+ * ima_add_violation - add violation to measurement list.
+ *
+ * Violations are flagged in the measurement list with zero hash values.
+ * By extending the PCR with 0xFF's instead of with zeroes, the PCR
+ * value is invalidated.
+ */
+void ima_add_violation(struct inode *inode, const unsigned char *filename,
+		       const char *op, const char *cause)
+{
+	struct ima_template_entry *entry;
+	int violation = 1;
+	int result;
+
+	/* can overflow, only indicator */
+	atomic_long_inc(&ima_htable.violations);
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		result = -ENOMEM;
+		goto err_out;
+	}
+	memset(&entry->template, 0, sizeof(entry->template));
+	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
+	result = ima_store_template(entry, violation, inode);
+	if (result < 0)
+		kfree(entry);
+err_out:
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
+			    op, cause, result, 0);
+}
+
+/**
+ * ima_must_measure - measure decision based on policy.
+ * @inode: pointer to inode to measure
+ * @mask: contains the permission mask (MAY_READ, MAY_WRITE, MAY_EXECUTE)
+ * @function: calling function (PATH_CHECK, BPRM_CHECK, FILE_MMAP)
+ *
+ * The policy is defined in terms of keypairs:
+ * 		subj=, obj=, type=, func=, mask=, fsmagic=
+ *	subj,obj, and type: are LSM specific.
+ * 	func: PATH_CHECK | BPRM_CHECK | FILE_MMAP
+ * 	mask: contains the permission mask
+ *	fsmagic: hex value
+ *
+ * Must be called with iint->mutex held.
+ *
+ * Return 0 to measure. Return 1 if already measured.
+ * For matching a DONT_MEASURE policy, no policy, or other
+ * error, return an error code.
+*/
+int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
+		     int mask, int function)
+{
+	int must_measure;
+
+	if (iint->flags & IMA_MEASURED)
+		return 1;
+
+	must_measure = ima_match_policy(inode, function, mask);
+	return must_measure ? 0 : -EACCES;
+}
+
+/*
+ * ima_collect_measurement - collect file measurement
+ *
+ * Calculate the file hash, if it doesn't already exist,
+ * storing the measurement and i_version in the iint.
+ *
+ * Must be called with iint->mutex held.
+ *
+ * Return 0 on success, error code otherwise
+ */
+int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file)
+{
+	int result = -EEXIST;
+
+	if (!(iint->flags & IMA_MEASURED)) {
+		u64 i_version = file->f_dentry->d_inode->i_version;
+
+		memset(iint->digest, 0, IMA_DIGEST_SIZE);
+		result = ima_calc_hash(file, iint->digest);
+		if (!result)
+			iint->version = i_version;
+	}
+	return result;
+}
+
+/*
+ * ima_store_measurement - store file measurement
+ *
+ * Create an "ima" template and then store the template by calling
+ * ima_store_template.
+ *
+ * We only get here if the inode has not already been measured,
+ * but the measurement could already exist:
+ * 	- multiple copies of the same file on either the same or
+ *	  different filesystems.
+ *	- the inode was previously flushed as well as the iint info,
+ *	  containing the hashing info.
+ *
+ * Must be called with iint->mutex held.
+ */
+void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
+			   const unsigned char *filename)
+{
+	const char *op = "add_template_measure";
+	const char *audit_cause = "ENOMEM";
+	int result = -ENOMEM;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_template_entry *entry;
+	int violation = 0;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
+				    op, audit_cause, result, 0);
+		return;
+	}
+	memset(&entry->template, 0, sizeof(entry->template));
+	memcpy(entry->template.digest, iint->digest, IMA_DIGEST_SIZE);
+	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
+
+	result = ima_store_template(entry, violation, inode);
+	if (!result)
+		iint->flags |= IMA_MEASURED;
+	else
+		kfree(entry);
+}
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
new file mode 100644
index 0000000..8a0f1e2
--- /dev/null
+++ b/security/integrity/ima/ima_audit.c
@@ -0,0 +1,78 @@
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
+#include <linux/fs.h>
+#include <linux/audit.h>
+#include "ima.h"
+
+static int ima_audit;
+
+#ifdef CONFIG_IMA_AUDIT
+
+/* ima_audit_setup - enable informational auditing messages */
+static int __init ima_audit_setup(char *str)
+{
+	unsigned long audit;
+	int rc;
+	char *op;
+
+	rc = strict_strtoul(str, 0, &audit);
+	if (rc || audit > 1)
+		printk(KERN_INFO "ima: invalid ima_audit value\n");
+	else
+		ima_audit = audit;
+	op = ima_audit ? "ima_audit_enabled" : "ima_audit_not_enabled";
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL, NULL, op, 0, 0);
+	return 1;
+}
+__setup("ima_audit=", ima_audit_setup);
+#endif
+
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, const char *op,
+			 const char *cause, int result, int audit_info)
+{
+	struct audit_buffer *ab;
+
+	if (!ima_audit && audit_info == 1) /* Skip informational messages */
+		return;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
+			 current->pid, current->cred->uid,
+			 audit_get_loginuid(current));
+	audit_log_task_context(ab);
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
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
new file mode 100644
index 0000000..c2a46e4
--- /dev/null
+++ b/security/integrity/ima/ima_crypto.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: ima_crypto.c
+ * 	Calculates md5/sha1 file hash, template hash, boot-aggreate hash
+ */
+
+#include <linux/kernel.h>
+#include <linux/file.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/err.h>
+#include "ima.h"
+
+static int init_desc(struct hash_desc *desc)
+{
+	int rc;
+
+	desc->tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		pr_info("failed to load %s transform: %ld\n",
+			ima_hash, PTR_ERR(desc->tfm));
+		rc = PTR_ERR(desc->tfm);
+		return rc;
+	}
+	desc->flags = 0;
+	rc = crypto_hash_init(desc);
+	if (rc)
+		crypto_free_hash(desc->tfm);
+	return rc;
+}
+
+/*
+ * Calculate the MD5/SHA1 file digest
+ */
+int ima_calc_hash(struct file *file, char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	loff_t i_size;
+	char *rbuf;
+	int rc, offset = 0;
+
+	rc = init_desc(&desc);
+	if (rc != 0)
+		return rc;
+
+	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rbuf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	i_size = i_size_read(file->f_dentry->d_inode);
+	while (offset < i_size) {
+		int rbuf_len;
+
+		rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
+		if (rbuf_len < 0) {
+			rc = rbuf_len;
+			break;
+		}
+		offset += rbuf_len;
+		sg_set_buf(sg, rbuf, rbuf_len);
+
+		rc = crypto_hash_update(&desc, sg, rbuf_len);
+		if (rc)
+			break;
+	}
+	kfree(rbuf);
+	if (!rc)
+		rc = crypto_hash_final(&desc, digest);
+out:
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
+
+/*
+ * Calculate the hash of a given template
+ */
+int ima_calc_template_hash(int template_len, void *template, char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	int rc;
+
+	rc = init_desc(&desc);
+	if (rc != 0)
+		return rc;
+
+	sg_set_buf(sg, template, template_len);
+	rc = crypto_hash_update(&desc, sg, template_len);
+	if (!rc)
+		rc = crypto_hash_final(&desc, digest);
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
+
+static void ima_pcrread(int idx, u8 *pcr)
+{
+	if (!ima_used_chip)
+		return;
+
+	if (tpm_pcr_read(TPM_ANY_NUM, idx, pcr) != 0)
+		pr_err("Error Communicating to TPM chip\n");
+}
+
+/*
+ * Calculate the boot aggregate hash
+ */
+int ima_calc_boot_aggregate(char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg;
+	u8 pcr_i[IMA_DIGEST_SIZE];
+	int rc, i;
+
+	rc = init_desc(&desc);
+	if (rc != 0)
+		return rc;
+
+	/* cumulative sha1 over tpm registers 0-7 */
+	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
+		ima_pcrread(i, pcr_i);
+		/* now accumulate with current aggregate */
+		sg_init_one(&sg, pcr_i, IMA_DIGEST_SIZE);
+		rc = crypto_hash_update(&desc, &sg, IMA_DIGEST_SIZE);
+	}
+	if (!rc)
+		crypto_hash_final(&desc, digest);
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
new file mode 100644
index 0000000..750db3c
--- /dev/null
+++ b/security/integrity/ima/ima_iint.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_iint.c
+ * 	- implements the IMA hooks: ima_inode_alloc, ima_inode_free
+ *	- cache integrity information associated with an inode
+ *	  using a radix tree.
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/radix-tree.h>
+#include "ima.h"
+
+#define ima_iint_delete ima_inode_free
+
+RADIX_TREE(ima_iint_store, GFP_ATOMIC);
+DEFINE_SPINLOCK(ima_iint_lock);
+
+static struct kmem_cache *iint_cache __read_mostly;
+
+/* ima_iint_find_get - return the iint associated with an inode
+ *
+ * ima_iint_find_get gets a reference to the iint. Caller must
+ * remember to put the iint reference.
+ */
+struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	rcu_read_lock();
+	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
+	if (!iint)
+		goto out;
+	kref_get(&iint->refcount);
+out:
+	rcu_read_unlock();
+	return iint;
+}
+
+/* Allocate memory for the iint associated with the inode
+ * from the iint_cache slab, initialize the iint, and
+ * insert it into the radix tree.
+ *
+ * On success return a pointer to the iint; on failure return NULL.
+ */
+struct ima_iint_cache *ima_iint_insert(struct inode *inode)
+{
+	struct ima_iint_cache *iint = NULL;
+	int rc = 0;
+
+	if (!ima_initialized)
+		return iint;
+	iint = kmem_cache_alloc(iint_cache, GFP_KERNEL);
+	if (!iint)
+		return iint;
+
+	rc = radix_tree_preload(GFP_KERNEL);
+	if (rc < 0)
+		goto out;
+
+	spin_lock(&ima_iint_lock);
+	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
+	spin_unlock(&ima_iint_lock);
+out:
+	if (rc < 0) {
+		kmem_cache_free(iint_cache, iint);
+		if (rc == -EEXIST) {
+			iint = radix_tree_lookup(&ima_iint_store,
+						 (unsigned long)inode);
+		} else
+			iint = NULL;
+	}
+	radix_tree_preload_end();
+	return iint;
+}
+
+/**
+ * ima_inode_alloc - allocate an iint associated with an inode
+ * @inode: pointer to the inode
+ *
+ * Return 0 on success, 1 on failure.
+ */
+int ima_inode_alloc(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	if (!ima_initialized)
+		return 0;
+
+	iint = ima_iint_insert(inode);
+	if (!iint)
+		return 1;
+	return 0;
+}
+
+/* ima_iint_find_insert_get - get the iint associated with an inode
+ *
+ * Most insertions are done at inode_alloc, except those allocated
+ * before late_initcall. When the iint does not exist, allocate it,
+ * initialize and insert it, and increment the iint refcount.
+ *
+ * (Can't initialize at security_initcall before any inodes are
+ * allocated, got to wait at least until proc_init.)
+ *
+ *  Return the iint.
+ */
+struct ima_iint_cache *ima_iint_find_insert_get(struct inode *inode)
+{
+	struct ima_iint_cache *iint = NULL;
+
+	iint = ima_iint_find_get(inode);
+	if (iint)
+		return iint;
+
+	iint = ima_iint_insert(inode);
+	if (iint)
+		kref_get(&iint->refcount);
+
+	return iint;
+}
+
+/* iint_free - called when the iint refcount goes to zero */
+void iint_free(struct kref *kref)
+{
+	struct ima_iint_cache *iint = container_of(kref, struct ima_iint_cache,
+						   refcount);
+	iint->version = 0;
+	iint->flags = 0UL;
+	kref_set(&iint->refcount, 1);
+	kmem_cache_free(iint_cache, iint);
+}
+
+void iint_rcu_free(struct rcu_head *rcu_head)
+{
+	struct ima_iint_cache *iint = container_of(rcu_head,
+						   struct ima_iint_cache, rcu);
+	kref_put(&iint->refcount, iint_free);
+}
+
+/**
+ * ima_iint_delete - called on integrity_inode_free
+ * @inode: pointer to the inode
+ *
+ * Free the integrity information(iint) associated with an inode.
+ */
+void ima_iint_delete(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	if (!ima_initialized)
+		return;
+	spin_lock(&ima_iint_lock);
+	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
+	spin_unlock(&ima_iint_lock);
+	if (iint)
+		call_rcu(&iint->rcu, iint_rcu_free);
+}
+
+static void init_once(void *foo)
+{
+	struct ima_iint_cache *iint = foo;
+
+	memset(iint, 0, sizeof *iint);
+	iint->version = 0;
+	iint->flags = 0UL;
+	mutex_init(&iint->mutex);
+	iint->readcount = 0;
+	iint->writecount = 0;
+	kref_set(&iint->refcount, 1);
+}
+
+void ima_iintcache_init(void)
+{
+	iint_cache =
+	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
+			      SLAB_PANIC, init_once);
+}
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
new file mode 100644
index 0000000..e0f02e3
--- /dev/null
+++ b/security/integrity/ima/ima_init.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Reiner Sailer      <sailer@watson.ibm.com>
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Mimi Zohar         <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_init.c
+ *             initialization and cleanup functions
+ */
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/err.h>
+#include "ima.h"
+
+/* name for boot aggregate entry */
+static char *boot_aggregate_name = "boot_aggregate";
+int ima_used_chip;
+
+/* Add the boot aggregate to the IMA measurement list and extend
+ * the PCR register.
+ *
+ * Calculate the boot aggregate, a SHA1 over tpm registers 0-7,
+ * assuming a TPM chip exists, and zeroes if the TPM chip does not
+ * exist.  Add the boot aggregate measurement to the measurement
+ * list and extend the PCR register.
+ *
+ * If a tpm chip does not exist, indicate the core root of trust is
+ * not hardware based by invalidating the aggregate PCR value.
+ * (The aggregate PCR value is invalidated by adding one value to
+ * the measurement list and extending the aggregate PCR value with
+ * a different value.) Violations add a zero entry to the measurement
+ * list and extend the aggregate PCR value with ff...ff's.
+ */
+static void ima_add_boot_aggregate(void)
+{
+	struct ima_template_entry *entry;
+	const char *op = "add_boot_aggregate";
+	const char *audit_cause = "ENOMEM";
+	int result = -ENOMEM;
+	int violation = 1;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		goto err_out;
+
+	memset(&entry->template, 0, sizeof(entry->template));
+	strncpy(entry->template.file_name, boot_aggregate_name,
+		IMA_EVENT_NAME_LEN_MAX);
+	if (ima_used_chip) {
+		violation = 0;
+		result = ima_calc_boot_aggregate(entry->template.digest);
+		if (result < 0) {
+			audit_cause = "hashing_error";
+			kfree(entry);
+			goto err_out;
+		}
+	}
+	result = ima_store_template(entry, violation, NULL);
+	if (result < 0)
+		kfree(entry);
+	return;
+err_out:
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,
+			    audit_cause, result, 0);
+}
+
+int ima_init(void)
+{
+	u8 pcr_i[IMA_DIGEST_SIZE];
+	int rc;
+
+	ima_used_chip = 0;
+	rc = tpm_pcr_read(TPM_ANY_NUM, 0, pcr_i);
+	if (rc == 0)
+		ima_used_chip = 1;
+
+	if (!ima_used_chip)
+		pr_info("No TPM chip found, activating TPM-bypass!\n");
+
+	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
+	ima_init_policy();
+	return 0;
+}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
new file mode 100644
index 0000000..53cee4c
--- /dev/null
+++ b/security/integrity/ima/ima_main.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Serge Hallyn <serue@us.ibm.com>
+ * Kylene Hall <kylene@us.ibm.com>
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_main.c
+ *             implements the IMA hooks: ima_bprm_check, ima_file_mmap,
+ *             and ima_path_check.
+ */
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/binfmts.h>
+#include <linux/mount.h>
+#include <linux/mman.h>
+
+#include "ima.h"
+
+int ima_initialized;
+
+char *ima_hash = "sha1";
+static int __init hash_setup(char *str)
+{
+	const char *op = "hash_setup";
+	const char *hash = "sha1";
+	int result = 0;
+	int audit_info = 0;
+
+	if (strncmp(str, "md5", 3) == 0) {
+		hash = "md5";
+		ima_hash = str;
+	} else if (strncmp(str, "sha1", 4) != 0) {
+		hash = "invalid_hash_type";
+		result = 1;
+	}
+	integrity_audit_msg(AUDIT_INTEGRITY_HASH, NULL, NULL, op, hash,
+			    result, audit_info);
+	return 1;
+}
+__setup("ima_hash=", hash_setup);
+
+/**
+ * ima_file_free - called on __fput()
+ * @file: pointer to file structure being freed
+ *
+ * Flag files that changed, based on i_version;
+ * and decrement the iint readcount/writecount.
+ */
+void ima_file_free(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_iint_cache *iint;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return;
+	iint = ima_iint_find_get(inode);
+	if (!iint)
+		return;
+
+	mutex_lock(&iint->mutex);
+	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		iint->readcount--;
+
+	if (file->f_mode & FMODE_WRITE) {
+		iint->writecount--;
+		if (iint->writecount == 0) {
+			if (iint->version != inode->i_version)
+				iint->flags &= ~IMA_MEASURED;
+		}
+	}
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+}
+
+/* ima_read_write_check - reflect possible reading/writing errors in the PCR.
+ *
+ * When opening a file for read, if the file is already open for write,
+ * the file could change, resulting in a file measurement error.
+ *
+ * Opening a file for write, if the file is already open for read, results
+ * in a time of measure, time of use (ToMToU) error.
+ *
+ * In either case invalidate the PCR.
+ */
+enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
+static void ima_read_write_check(enum iint_pcr_error error,
+				 struct ima_iint_cache *iint,
+				 struct inode *inode,
+				 const unsigned char *filename)
+{
+	switch (error) {
+	case TOMTOU:
+		if (iint->readcount > 0)
+			ima_add_violation(inode, filename, "invalid_pcr",
+					  "ToMToU");
+		break;
+	case OPEN_WRITERS:
+		if (iint->writecount > 0)
+			ima_add_violation(inode, filename, "invalid_pcr",
+					  "open_writers");
+		break;
+	}
+}
+
+static int get_path_measurement(struct ima_iint_cache *iint, struct file *file,
+				const unsigned char *filename)
+{
+	int rc = 0;
+
+	if (IS_ERR(file)) {
+		pr_info("%s dentry_open failed\n", filename);
+		return rc;
+	}
+	iint->readcount++;
+
+	rc = ima_collect_measurement(iint, file);
+	if (!rc)
+		ima_store_measurement(iint, file, filename);
+	return rc;
+}
+
+/**
+ * ima_path_check - based on policy, collect/store measurement.
+ * @path: contains a pointer to the path to be measured
+ * @mask: contains MAY_READ, MAY_WRITE or MAY_EXECUTE
+ *
+ * Measure the file being open for readonly, based on the
+ * ima_must_measure() policy decision.
+ *
+ * Keep read/write counters for all files, but only
+ * invalidate the PCR for measured files:
+ * 	- Opening a file for write when already open for read,
+ *	  results in a time of measure, time of use (ToMToU) error.
+ *	- Opening a file for read when already open for write,
+ * 	  could result in a file measurement error.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+int ima_path_check(struct path *path, int mask)
+{
+	struct inode *inode = path->dentry->d_inode;
+	struct ima_iint_cache *iint;
+	struct file *file = NULL;
+	int rc;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return 0;
+	iint = ima_iint_find_insert_get(inode);
+	if (!iint)
+		return 0;
+
+	mutex_lock(&iint->mutex);
+	if ((mask & MAY_WRITE) || (mask == 0))
+		iint->writecount++;
+	else if (mask & (MAY_READ | MAY_EXEC))
+		iint->readcount++;
+
+	rc = ima_must_measure(iint, inode, MAY_READ, PATH_CHECK);
+	if (rc < 0)
+		goto out;
+
+	if ((mask & MAY_WRITE) || (mask == 0))
+		ima_read_write_check(TOMTOU, iint, inode,
+				     path->dentry->d_name.name);
+
+	if ((mask & (MAY_WRITE | MAY_READ | MAY_EXEC)) != MAY_READ)
+		goto out;
+
+	ima_read_write_check(OPEN_WRITERS, iint, inode,
+			     path->dentry->d_name.name);
+	if (!(iint->flags & IMA_MEASURED)) {
+		struct dentry *dentry = dget(path->dentry);
+		struct vfsmount *mnt = mntget(path->mnt);
+
+		file = dentry_open(dentry, mnt, O_RDONLY, current->cred);
+		rc = get_path_measurement(iint, file, dentry->d_name.name);
+	}
+out:
+	mutex_unlock(&iint->mutex);
+	if (file)
+		fput(file);
+	kref_put(&iint->refcount, iint_free);
+	return 0;
+}
+
+static int process_measurement(struct file *file, const unsigned char *filename,
+			       int mask, int function)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_iint_cache *iint;
+	int rc;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return 0;
+	iint = ima_iint_find_insert_get(inode);
+	if (!iint)
+		return -ENOMEM;
+
+	mutex_lock(&iint->mutex);
+	rc = ima_must_measure(iint, inode, mask, function);
+	if (rc != 0)
+		goto out;
+
+	rc = ima_collect_measurement(iint, file);
+	if (!rc)
+		ima_store_measurement(iint, file, filename);
+out:
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+	return rc;
+}
+
+/**
+ * ima_file_mmap - based on policy, collect/store measurement.
+ * @file: pointer to the file to be measured (May be NULL)
+ * @prot: contains the protection that will be applied by the kernel.
+ *
+ * Measure files being mmapped executable based on the ima_must_measure()
+ * policy decision.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+int ima_file_mmap(struct file *file, unsigned long prot)
+{
+	int rc;
+
+	if (!file)
+		return 0;
+	if (prot & PROT_EXEC)
+		rc = process_measurement(file, file->f_dentry->d_name.name,
+					 MAY_EXEC, FILE_MMAP);
+	return 0;
+}
+
+/**
+ * ima_bprm_check - based on policy, collect/store measurement.
+ * @bprm: contains the linux_binprm structure
+ *
+ * The OS protects against an executable file, already open for write,
+ * from being executed in deny_write_access() and an executable file,
+ * already open for execute, from being modified in get_write_access().
+ * So we can be certain that what we verify and measure here is actually
+ * what is being executed.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+int ima_bprm_check(struct linux_binprm *bprm)
+{
+	int rc;
+
+	rc = process_measurement(bprm->file, bprm->filename,
+				 MAY_EXEC, BPRM_CHECK);
+	return 0;
+}
+
+static int __init init_ima(void)
+{
+	int error;
+
+	ima_iintcache_init();
+	error = ima_init();
+	ima_initialized = 1;
+	return error;
+}
+
+late_initcall(init_ima);	/* Start IMA after the TPM is available */
+
+MODULE_DESCRIPTION("Integrity Measurement Architecture");
+MODULE_LICENSE("GPL");
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
new file mode 100644
index 0000000..7c3d1ff
--- /dev/null
+++ b/security/integrity/ima/ima_policy.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * ima_policy.c
+ * 	- initialize default measure policy rules
+ *
+ */
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/audit.h>
+#include <linux/security.h>
+#include <linux/magic.h>
+
+#include "ima.h"
+
+/* flags definitions */
+#define IMA_FUNC 	0x0001
+#define IMA_MASK 	0x0002
+#define IMA_FSMAGIC	0x0004
+#define IMA_UID		0x0008
+
+enum ima_action { DONT_MEASURE, MEASURE };
+
+struct ima_measure_rule_entry {
+	struct list_head list;
+	enum ima_action action;
+	unsigned int flags;
+	enum ima_hooks func;
+	int mask;
+	unsigned long fsmagic;
+	uid_t uid;
+};
+
+static struct ima_measure_rule_entry default_rules[] = {
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = 0xF97CFF8C,.flags = IMA_FSMAGIC},
+	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
+};
+
+static LIST_HEAD(measure_default_rules);
+static struct list_head *ima_measure;
+
+/**
+ * ima_match_rules - determine whether an inode matches the measure rule.
+ * @rule: a pointer to a rule
+ * @inode: a pointer to an inode
+ * @func: LIM hook identifier
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ *
+ * Returns true on rule match, false on failure.
+ */
+static bool ima_match_rules(struct ima_measure_rule_entry *rule,
+			    struct inode *inode, enum ima_hooks func, int mask)
+{
+	struct task_struct *tsk = current;
+
+	if ((rule->flags & IMA_FUNC) && rule->func != func)
+		return false;
+	if ((rule->flags & IMA_MASK) && rule->mask != mask)
+		return false;
+	if ((rule->flags & IMA_FSMAGIC)
+	    && rule->fsmagic != inode->i_sb->s_magic)
+		return false;
+	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
+		return false;
+	return true;
+}
+
+/**
+ * ima_match_policy - decision based on LSM and other conditions
+ * @inode: pointer to an inode for which the policy decision is being made
+ * @func: IMA hook identifier
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ *
+ * Measure decision based on func/mask/fsmagic and LSM(subj/obj/type)
+ * conditions.
+ *
+ * (There is no need for locking when walking the policy list,
+ * as elements in the list are never deleted, nor does the list
+ * change.)
+ */
+int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
+{
+	struct ima_measure_rule_entry *entry;
+
+	list_for_each_entry(entry, ima_measure, list) {
+		bool rc;
+
+		rc = ima_match_rules(entry, inode, func, mask);
+		if (rc)
+			return entry->action;
+	}
+	return 0;
+}
+
+/**
+ * ima_init_policy - initialize the default measure rules.
+ *
+ * (Could use the default_rules directly, but in policy patch
+ * ima_measure points to either the measure_default_rules or the
+ * the new measure_policy_rules.)
+ */
+void ima_init_policy(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
+		list_add_tail(&default_rules[i].list, &measure_default_rules);
+	ima_measure = &measure_default_rules;
+}
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
new file mode 100644
index 0000000..7ec9431
--- /dev/null
+++ b/security/integrity/ima/ima_queue.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Serge Hallyn <serue@us.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_queue.c
+ *       Implements queues that store template measurements and
+ *       maintains aggregate over the stored measurements
+ *       in the pre-configured TPM PCR (if available).
+ *       The measurement list is append-only. No entry is
+ *       ever removed or changed during the boot-cycle.
+ */
+#include <linux/module.h>
+#include <linux/rculist.h>
+#include "ima.h"
+
+LIST_HEAD(ima_measurements);	/* list of all measurements */
+
+/* key: inode (before secure-hashing a file) */
+struct ima_h_table ima_htable = {
+	.len = ATOMIC_LONG_INIT(0),
+	.violations = ATOMIC_LONG_INIT(0),
+	.queue[0 ... IMA_MEASURE_HTABLE_SIZE - 1] = HLIST_HEAD_INIT
+};
+
+/* mutex protects atomicity of extending measurement list
+ * and extending the TPM PCR aggregate. Since tpm_extend can take
+ * long (and the tpm driver uses a mutex), we can't use the spinlock.
+ */
+static DEFINE_MUTEX(ima_extend_list_mutex);
+
+/* lookup up the digest value in the hash table, and return the entry */
+static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
+{
+	struct ima_queue_entry *qe, *ret = NULL;
+	unsigned int key;
+	struct hlist_node *pos;
+	int rc;
+
+	key = ima_hash_key(digest_value);
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
+		rc = memcmp(qe->entry->digest, digest_value, IMA_DIGEST_SIZE);
+		if (rc == 0) {
+			ret = qe;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/* ima_add_template_entry helper function:
+ * - Add template entry to measurement list and hash table.
+ *
+ * (Called with ima_extend_list_mutex held.)
+ */
+static int ima_add_digest_entry(struct ima_template_entry *entry)
+{
+	struct ima_queue_entry *qe;
+	unsigned int key;
+
+	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
+	if (qe == NULL) {
+		pr_err("OUT OF MEMORY ERROR creating queue entry.\n");
+		return -ENOMEM;
+	}
+	qe->entry = entry;
+
+	INIT_LIST_HEAD(&qe->later);
+	list_add_tail_rcu(&qe->later, &ima_measurements);
+
+	atomic_long_inc(&ima_htable.len);
+	key = ima_hash_key(entry->digest);
+	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	return 0;
+}
+
+static int ima_pcr_extend(const u8 *hash)
+{
+	int result = 0;
+
+	if (!ima_used_chip)
+		return result;
+
+	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
+	if (result != 0)
+		pr_err("Error Communicating to TPM chip\n");
+	return result;
+}
+
+/* Add template entry to the measurement list and hash table,
+ * and extend the pcr.
+ */
+int ima_add_template_entry(struct ima_template_entry *entry, int violation,
+			   const char *op, struct inode *inode)
+{
+	u8 digest[IMA_DIGEST_SIZE];
+	const char *audit_cause = "hash_added";
+	int audit_info = 1;
+	int result = 0;
+
+	mutex_lock(&ima_extend_list_mutex);
+	if (!violation) {
+		memcpy(digest, entry->digest, sizeof digest);
+		if (ima_lookup_digest_entry(digest)) {
+			audit_cause = "hash_exists";
+			goto out;
+		}
+	}
+
+	result = ima_add_digest_entry(entry);
+	if (result < 0) {
+		audit_cause = "ENOMEM";
+		audit_info = 0;
+		goto out;
+	}
+
+	if (violation)		/* invalidate pcr */
+		memset(digest, 0xff, sizeof digest);
+
+	result = ima_pcr_extend(digest);
+	if (result != 0) {
+		audit_cause = "TPM error";
+		audit_info = 0;
+	}
+out:
+	mutex_unlock(&ima_extend_list_mutex);
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, entry->template_name,
+			    op, audit_cause, result, audit_info);
+	return result;
+}
-- 
1.5.6.6

