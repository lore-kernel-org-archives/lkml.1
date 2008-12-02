Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYLBVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYLBVum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYLBVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:48:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55188 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYLBVs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:48:26 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3/6] integrity: IMA as an integrity service provider
Date: Tue,  2 Dec 2008 16:47:57 -0500
Message-Id: <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on suggestions on the mailing list:

- Due to the large patch size, IMA is broken up into three smaller patches:
  ima-service-provider, ima-display, and ima-policy.
- Replaced skip_measurement() function with single S_ISREG() call.
- Simplified ima_calc_hash() and removed update_file_hash() by
  eliminating the 'path' parameter. Getting a 'file' handle is now
  done by the caller.
- Removed tiny wrappers ima_inode_alloc_integrity()/free_integrity().
  Now calls ima_iint_alloc()/delete() directly.
- Removed all references to d_iname.
- Corrected ima_path_check() mask comparisons, removing MAY_APPEND.
- For readability, removed audit_type and lsm_type defines and usage.
- Replaced the generic 'struct ima_args_data' with integrity API
  function specific structures. (definitions in include/linux/ima.h and "ima.h")
- ima_store_measurement() now only forms an "ima" specific template measurement
- Defined a new integrity API call store_template().
- ima_store_template wraps a template specific measurement with a header
  containing: template hash, template name, template data length and data.
- Replaced local iint_get/iint_put calls with kref calls.

IMA provides hardware (TPM) based measurement and attestation for both
files and other types of template measurements. As the Trusted Computing
(TPM) model requires, IMA measures all files before they are accessed
in any way (on the bprm_check_integrity, path_check_integrity, and
file_mmap hooks), and commits the measurements to the TPM.  In addition,
IMA maintains a list of these hash values, which can be used to validate
the aggregate PCR value.  The TPM can sign these measurements, and thus
the system can prove to itself and to a third party these measurements
in a way that cannot be circumvented by malicious or compromised software.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f98984e..aff7933 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	IMA     Integrity measurement architecture is enabled.
 	INTEGRITY Integrity support is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
@@ -880,6 +881,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_hash=	[IMA] runtime ability to define hash crypto algorithm.
+			Format: { "MD5" | "SHA1" }
+			Default is "SHA1".
+
 	in2000=		[HW,SCSI]
 			See header of drivers/scsi/in2000.c.
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
new file mode 100644
index 0000000..6453100
--- /dev/null
+++ b/include/linux/ima.h
@@ -0,0 +1,24 @@
+/*
+ * ima.h
+ *
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _LINUX_IMA_H
+#define _LINUX_IMA_H
+
+/* Store template measurements for use with ima_store_template() */
+struct ima_store_template_data {
+	char *name;
+	int len;
+	char *data;
+	int violation;
+	struct inode *inode;
+};
+
+#endif
diff --git a/security/Kconfig b/security/Kconfig
index 4c602be..665a1b7 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -55,7 +55,8 @@ config SECURITYFS
 	bool "Enable the securityfs filesystem"
 	help
 	  This will build the securityfs filesystem.  It is currently used by
-	  the TPM bios character driver.  It is not used by SELinux or SMACK.
+	  the TPM bios character driver and IMA, an integrity provider.  It
+	  is not used by SELinux or SMACK.
 
 	  If you are unsure how to answer this question, answer N.
 
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 2123dfc..57213d6 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -22,3 +22,5 @@ config INTEGRITY_AUDIT
 	  at boot.  If this option is selected, informational integrity
 	  auditing messages can be enabled with 'integrity_audit=1' on
 	  the kernel command line.
+
+source security/integrity/ima/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index a6e1405..107dafd 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -4,3 +4,4 @@
 
 # Object file lists
 obj-$(CONFIG_INTEGRITY) += integrity.o integrity_audit.o
+obj-$(CONFIG_IMA) += ima/
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
new file mode 100644
index 0000000..6c6fcd9
--- /dev/null
+++ b/security/integrity/ima/Kconfig
@@ -0,0 +1,34 @@
+#
+# IBM Integrity Measurement Architecture
+#
+config IMA
+	bool "Integrity Measurement Architecture(IMA)"
+	depends on INTEGRITY
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
+	  values of executables and other sensitive system files
+	  loaded into the run-time of this system.  If your system
+	  has a TPM chip, then IMA also maintains an aggregate
+	  integrity value over this list inside the TPM hardware.
+	  These measurements and the aggregate (signed inside the
+	  TPM) can be retrieved and presented to remote parties to
+	  establish system properties. If unsure, say N.
+
+config IMA_MEASURE_PCR_IDX
+	int "PCR for Aggregate (8 <= Index <= 14)"
+	depends on IMA
+	range 8 14
+	default 10
+	help
+	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
+	  that IMA uses to maintain the integrity aggregate of the
+	  measurement list.  If unsure, use the default 10.
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
new file mode 100644
index 0000000..d9d4405
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
+	 ima_policy.o ima_iint.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
new file mode 100644
index 0000000..b727a5e
--- /dev/null
+++ b/security/integrity/ima/ima.h
@@ -0,0 +1,169 @@
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
+ *	internal ima definitions
+ */
+
+#ifndef __LINUX_IMA_H
+#define __LINUX_IMA_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/security.h>
+#include <linux/integrity.h>
+#include <linux/hash.h>
+#include <linux/tpm.h>
+#include <linux/ima.h>
+
+#define ima_printk(level, format, arg...)		\
+	printk(level "ima (%s): " format, __func__, ## arg)
+
+#define ima_error(format, arg...)	\
+	ima_printk(KERN_ERR, format, ## arg)
+
+#define ima_info(format, arg...)	\
+	ima_printk(KERN_INFO, format, ## arg)
+
+/* digest size for IMA, fits SHA1 or MD5 */
+#define IMA_DIGEST_SIZE		20
+#define IMA_EVENT_NAME_LEN_MAX	255
+
+#define IMA_HASH_BITS 9
+#define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
+
+/* set during initialization */
+extern int ima_used_chip;
+extern char *ima_hash;
+
+struct ima_template_entry {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
+	char template_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+	int template_len;
+	char *template;
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
+extern const struct template_operations ima_template_ops;
+
+/* Internal IMA function definitions */
+int ima_init(void);
+void ima_create_htable(void);
+int ima_add_template_entry(struct ima_template_entry *entry, int violation);
+int ima_calc_hash(struct file *file, char *digest);
+int ima_calc_template_hash(int template_len, char *template, char *digest);
+void ima_add_violation(struct inode *inode, const unsigned char *filename,
+		       char *op, char *cause);
+
+/*
+ * used to protect h_table and sha_table
+ */
+extern spinlock_t ima_queue_lock;
+
+struct ima_h_table {
+	atomic_long_t len;	/* number of stored measurements in the list */
+	atomic_long_t violations;
+	unsigned int max_htable_size;
+	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
+	atomic_t queue_len[IMA_MEASURE_HTABLE_SIZE];
+};
+extern struct ima_h_table ima_htable;
+
+static inline unsigned long IMA_HASH_KEY(u8 *digest)
+{
+	return (hash_long(*digest, IMA_HASH_BITS));
+}
+
+/* TPM "Glue" definitions */
+
+#define IMA_TPM ((((u32)TPM_ANY_TYPE)<<16) | (u32)TPM_ANY_NUM)
+static inline void ima_extend(const u8 *hash)
+{
+	if (!ima_used_chip)
+		return;
+
+	if (tpm_pcr_extend(IMA_TPM, CONFIG_IMA_MEASURE_PCR_IDX, hash) != 0)
+		ima_error("Error Communicating to TPM chip\n");
+}
+
+static inline void ima_pcrread(int idx, u8 *pcr, int pcr_size)
+{
+	if (!ima_used_chip)
+		return;
+
+	if (tpm_pcr_read(IMA_TPM, idx, pcr) != 0)
+		ima_error("Error Communicating to TPM chip\n");
+}
+
+/* LIM API function definitions */
+int ima_must_measure(void *d);
+int ima_collect_measurement(void *d);
+int ima_appraise_measurement(void *d);
+void ima_store_measurement(void *d);
+int ima_store_template(void *d);
+
+/* For use with ima_must_measure() */
+struct ima_measure_data {
+	struct inode *inode;
+	int function;
+	int mask;
+};
+
+/* For use with ima_store_measurement() */
+struct ima_store_data {
+	struct file *file;
+	const unsigned char *filename;
+};
+
+/* IMA inode template definition */
+struct ima_inode_measure_entry {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
+	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+};
+
+/* integrity data associated with an inode */
+struct ima_iint_cache {
+	u64 version;
+	ulong flags;
+	u8 hmac[IMA_DIGEST_SIZE];
+	u8 digest[IMA_DIGEST_SIZE];
+	struct mutex mutex;
+	struct kref refcount;
+};
+#define IMA_IINT_INIT		1
+#define IMA_MUST_MEASURE	2
+#define IMA_MEASURED		4
+
+/* radix tree calls to lookup, insert, delete
+ * integrity data associated with an inode.
+ */
+struct ima_iint_cache *ima_iint_lookup(struct inode *inode);
+int ima_iint_insert(struct inode *inode);
+void ima_iint_delete(struct inode *inode);
+void iint_free(struct kref *kref);
+
+/* IMA policy related functions */
+enum ima_action { DONT_MEASURE, MEASURE };
+int ima_match_policy(struct inode *inode, enum lim_hooks func, int mask);
+int ima_add_rule(int, char *subj_user, char *subj_role, char *subj_type,
+		 char *obj_user, char *obj_role, char *obj_type,
+		 char *func, char *mask, char *fsmagic, char *uid);
+void ima_init_policy(void);
+void ima_update_policy(void);
+#endif
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
new file mode 100644
index 0000000..83ab012
--- /dev/null
+++ b/security/integrity/ima/ima_api.c
@@ -0,0 +1,309 @@
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
+ *            - implements the LIM API
+ */
+#include <linux/module.h>
+#include <linux/integrity.h>
+
+#include "ima.h"
+
+const struct template_operations ima_template_ops = {
+	.must_measure = ima_must_measure,
+	.collect_measurement = ima_collect_measurement,
+	.store_measurement = ima_store_measurement,
+	.store_template = ima_store_template,
+};
+
+/**
+ * ima_store_template - collect and protect template measurements
+ * @data: pointer to struct ima_store_template_data
+ *
+ * ima_struct_template_data contains the template name, template data length,
+ * template data, inode, and violation (invalidate pcr measurement indication).
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
+int ima_store_template(void *data)
+{
+	struct ima_store_template_data *template =
+	    (struct ima_store_template_data *)data;
+	struct ima_template_entry *entry;
+	char *op = "add_template_measure";
+	char *audit_cause = "";
+	int namelen, result = 0;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		result = -ENOMEM;
+		goto out;
+	}
+
+	entry->template = kzalloc(template->len, GFP_KERNEL);
+	if (!entry->template) {
+		kfree(entry);
+		result = -ENOMEM;
+		goto out;
+	}
+	namelen = strlen(template->name);
+	if (namelen > IMA_EVENT_NAME_LEN_MAX)
+		namelen = IMA_EVENT_NAME_LEN_MAX;
+	memcpy(entry->template_name, template->name, namelen);
+
+	entry->template_len = template->len;
+	memcpy(entry->template, template->data, template->len);
+
+	if (!template->violation) {
+		result = ima_calc_template_hash(template->len, template->data,
+						entry->digest);
+		if (result < 0)
+			goto free_out;
+	}
+
+	result = ima_add_template_entry(entry, template->violation);
+free_out:
+	if (result < 0) {
+		kfree(entry->template);
+		kfree(entry);
+	}
+out:
+	switch (result) {
+	case -EEXIST:
+		audit_cause = "hash_exists";
+		break;
+	case -ENOMEM:
+		audit_cause = "ENOMEM";
+		break;
+	default:
+		break;
+	}
+
+	if (!result || result == -EEXIST) {
+		integrity_audit_msg(AUDIT_INTEGRITY_PCR, template->inode,
+				    template->name, op, audit_cause, 1);
+	} else if (result < 0)
+		integrity_audit_msg(AUDIT_INTEGRITY_PCR, template->inode,
+				    template->name, op, audit_cause, 0);
+	return result;
+}
+
+/**
+ * ima_add_violation - add violation to measurement list.
+ * @inode: inode associated with the violation
+ * @filename: the file name associated with the inode
+ * @op: string pointer to audit operation (i.e. "invalid_pcr", "add_measure")
+ * @cause: string pointer to reason for violation (i.e. "ToMToU")
+ *
+ * Violations are flagged in the measurement list with zero hash values.
+ * By extending the PCR with 0xFF's instead of with zeroes, the PCR
+ * value is invalidated.
+ */
+void ima_add_violation(struct inode *inode, const unsigned char *filename,
+		       char *op, char *cause)
+{
+	int result, namelen;
+	struct ima_inode_measure_entry measure_entry;
+	struct ima_store_template_data template = {
+		.name = "ima",
+		.len = sizeof(measure_entry),
+		.data = (char *)&measure_entry,
+		.violation = 1,
+	};
+
+	/* can overflow, only indicator */
+	atomic_long_inc(&ima_htable.violations);
+
+	memset(&measure_entry, 0, sizeof measure_entry);
+	namelen = strlen(filename);
+	if (namelen > IMA_EVENT_NAME_LEN_MAX)
+		namelen = IMA_EVENT_NAME_LEN_MAX;
+	memcpy(measure_entry.file_name, filename, namelen);
+	result = ima_store_template(&template);
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename, op, cause, 0);
+}
+
+/**
+ * ima_must_measure - measure decision based on policy.
+ * @data: pointer to struct ima_measure_data(contains inode, function, mask)
+ *
+ * The policy is defined in terms of keypairs:
+ * 		subj=, obj=, type=, func=, mask=, fsmagic=
+ *	subj,obj, and type: are LSM specific.
+ * 	func: PATH_CHECK | BPRM_CHECK | FILE_MMAP
+ * 	mask: contains the permission mask
+ *	fsmagic: hex value
+ *
+ * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
+ * or other error, return an error code.
+*/
+int ima_must_measure(void *data)
+{
+	struct ima_measure_data *mdata = (struct ima_measure_data *)data;
+	struct ima_iint_cache *iint;
+	int must_measure = -EACCES;
+
+	if (!S_ISREG(mdata->inode->i_mode))
+		return -EPERM;
+	if ((mdata->mask & MAY_WRITE) || (mdata->mask & MAY_APPEND))
+		return -EPERM;
+
+	rcu_read_lock();
+	iint = ima_iint_lookup(mdata->inode);
+	if (iint)
+		kref_get(&iint->refcount);
+	rcu_read_unlock();
+
+	if (!iint) {
+		int rc;
+
+		/* Most insertions are done at inode_alloc,
+		 * except those allocated before late_initcall.
+		 * Can't initialize at security_initcall,
+		 * got to wait at least until proc_init.
+		 */
+		rc = ima_iint_insert(mdata->inode);
+		if (rc < 0)
+			return rc;
+
+		rcu_read_lock();
+		iint = ima_iint_lookup(mdata->inode);
+		if (!iint) {
+			rcu_read_unlock();
+			return -ENOMEM;
+		}
+		kref_get(&iint->refcount);
+		rcu_read_unlock();
+	}
+
+	mutex_lock(&iint->mutex);
+	/* short circuit out of here, if iint initialized
+	 * and either no measurement required or already measured.
+	 */
+	if (iint->flags & IMA_IINT_INIT) {
+		if (!(iint->flags & IMA_MUST_MEASURE))
+			must_measure = -EACCES;
+		else if (iint->flags & IMA_MEASURED)
+			must_measure = -EEXIST;
+		else
+			must_measure = 0;
+	} else {
+		int rc;
+
+		rc = ima_match_policy(mdata->inode, mdata->function,
+				      mdata->mask);
+		if (rc) {
+			iint->flags = IMA_MUST_MEASURE;
+			must_measure = 0;
+		} else
+			must_measure = -EACCES;
+		iint->flags |= IMA_IINT_INIT;
+	}
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+	return must_measure;
+}
+
+/**
+ * ima_collect_measurement - collect file measurement
+ * @data: is a pointer to the file to be measured
+ *
+ * Calculate the file hash, if it doesn't already exist,
+ * and store the measurement in the radix tree.
+ * Return 0 on success, error code otherwise
+ */
+int ima_collect_measurement(void *data)
+{
+	struct file *file = (struct file *)data;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_iint_cache *iint;
+	int result = 0;
+
+	rcu_read_lock();
+	iint = ima_iint_lookup(inode);
+	if (!iint) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+	kref_get(&iint->refcount);
+	rcu_read_unlock();
+
+	mutex_lock(&iint->mutex);
+	if (!(iint->flags & IMA_MEASURED)) {
+		memset(iint->digest, 0, IMA_DIGEST_SIZE);
+		result = ima_calc_hash(file, iint->digest);
+	} else
+		result = -EEXIST;
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+	return result;
+}
+
+/**
+ * ima_store_measurement - store file measurement
+ * @data: pointer to struct ima_store_data (contains file and filename)
+ *
+ * Create an "ima" template and then store the template by calling
+ * ima_store_template.
+ */
+void ima_store_measurement(void *data)
+{
+	struct ima_store_data *sdata = (struct ima_store_data *)data;
+	struct ima_iint_cache *iint = NULL;
+	int result;
+	int namelen;
+	struct ima_inode_measure_entry measure_entry;
+	struct ima_store_template_data template = {
+		.name = "ima",
+		.len = sizeof(measure_entry),
+		.data = (char *)&measure_entry,
+	};
+
+	template.inode = sdata->file->f_dentry->d_inode;
+	rcu_read_lock();
+	iint = ima_iint_lookup(template.inode);
+	if (!iint) {
+		rcu_read_unlock();
+		return;
+	}
+	kref_get(&iint->refcount);
+	rcu_read_unlock();
+
+	mutex_lock(&iint->mutex);
+	if (iint->flags & IMA_MEASURED) {	/* already exists */
+		mutex_unlock(&iint->mutex);
+		return;
+	}
+	memset(&measure_entry, 0, sizeof measure_entry);
+	memcpy(measure_entry.digest, iint->digest, IMA_DIGEST_SIZE);
+	namelen = strlen(sdata->filename);
+	if (namelen > IMA_EVENT_NAME_LEN_MAX)
+		namelen = IMA_EVENT_NAME_LEN_MAX;
+	memcpy(measure_entry.file_name, sdata->filename, namelen);
+
+	result = ima_store_template(&template);
+	if (!result || result == -EEXIST) {
+		iint->flags |= IMA_MEASURED;
+		iint->version = template.inode->i_version;
+	}
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+}
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
new file mode 100644
index 0000000..79d591c
--- /dev/null
+++ b/security/integrity/ima/ima_crypto.c
@@ -0,0 +1,102 @@
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
+ * 	Calculate a file's or a template's hash.
+ */
+
+#include <linux/kernel.h>
+#include <linux/file.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include "ima.h"
+
+/*
+ * Calculate the MD5/SHA1 digest
+ */
+int ima_calc_hash(struct file *file, char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	loff_t i_size;
+	char *rbuf;
+	int rc, offset = 0;
+
+	desc.tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm)) {
+		ima_info("failed to load %s transform: %ld\n",
+			 ima_hash, PTR_ERR(desc.tfm));
+		rc = PTR_ERR(desc.tfm);
+		return rc;
+	}
+	desc.flags = 0;
+	rc = crypto_hash_init(&desc);
+	if (rc)
+		goto out;
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
+int ima_calc_template_hash(int template_len, char *template, char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	int rc;
+
+	desc.tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm)) {
+		ima_info("failed to load %s transform: %ld\n",
+			 ima_hash, PTR_ERR(desc.tfm));
+		rc = PTR_ERR(desc.tfm);
+		return rc;
+	}
+	desc.flags = 0;
+	rc = crypto_hash_init(&desc);
+	if (rc)
+		goto out;
+
+	sg_set_buf(sg, template, template_len);
+	rc = crypto_hash_update(&desc, sg, template_len);
+	if (!rc)
+		rc = crypto_hash_final(&desc, digest);
+out:
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
new file mode 100644
index 0000000..420855c
--- /dev/null
+++ b/security/integrity/ima/ima_iint.c
@@ -0,0 +1,71 @@
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
+ *             cache integrity information associated with an inode
+ *             using a radix tree.
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/radix-tree.h>
+#include "ima.h"
+
+RADIX_TREE(ima_iint_store, GFP_ATOMIC);
+DEFINE_SPINLOCK(ima_iint_lock);
+
+/* Call with rcu_read_lock */
+struct ima_iint_cache *ima_iint_lookup(struct inode *inode)
+{
+	return radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
+}
+
+int ima_iint_insert(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+	int rc = 0;
+
+	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
+	if (!iint)
+		return -ENOMEM;
+	mutex_init(&iint->mutex);
+	kref_set(&iint->refcount, 1);
+	iint->version = inode->i_version;
+
+	rc = radix_tree_preload(GFP_KERNEL);
+	if (rc < 0) {
+		kfree(iint);
+		return rc;
+	}
+
+	spin_lock(&ima_iint_lock);
+	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
+	spin_unlock(&ima_iint_lock);
+	radix_tree_preload_end();
+	return rc;
+}
+
+void iint_free(struct kref *kref)
+{
+	struct ima_iint_cache *iint = container_of(kref, struct ima_iint_cache,
+						   refcount);
+	kfree(iint);
+}
+
+void ima_iint_delete(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	spin_lock(&ima_iint_lock);
+	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
+	spin_unlock(&ima_iint_lock);
+	if (iint)
+		kref_put(&iint->refcount, iint_free);
+}
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
new file mode 100644
index 0000000..374b368
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
+#include "ima.h"
+
+/* name for boot aggregate entry */
+static char *boot_aggregate_name = "boot_aggregate";
+int ima_used_chip;
+
+static void ima_add_boot_aggregate(void)
+{
+	struct ima_inode_measure_entry measure_entry;
+	struct ima_store_template_data template = {
+		.name = "ima",
+		.len = sizeof(measure_entry),
+		.data = (char *)&measure_entry,
+	};
+	int namelen, result;
+
+	memset(&measure_entry, 0, sizeof measure_entry);
+	namelen = strlen(boot_aggregate_name);
+	if (namelen > IMA_EVENT_NAME_LEN_MAX)
+		namelen = IMA_EVENT_NAME_LEN_MAX;
+	memcpy(measure_entry.file_name, boot_aggregate_name, namelen);
+
+	if (ima_used_chip) {
+		int i;
+		u8 pcr_i[IMA_DIGEST_SIZE];
+		struct hash_desc desc;
+		struct crypto_hash *tfm;
+		struct scatterlist sg;
+
+		tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
+		if (!tfm || IS_ERR(tfm)) {
+			ima_error("error initializing digest.\n");
+			return;
+		}
+		desc.tfm = tfm;
+		desc.flags = 0;
+		crypto_hash_init(&desc);
+
+		/* cumulative sha1 over tpm registers 0-7 */
+		for (i = 0; i < 8; i++) {
+			ima_pcrread(i, pcr_i, sizeof(pcr_i));
+			/* now accumulate with current aggregate */
+			sg_init_one(&sg, (u8 *) pcr_i, IMA_DIGEST_SIZE);
+			crypto_hash_update(&desc, &sg, IMA_DIGEST_SIZE);
+		}
+		crypto_hash_final(&desc, measure_entry.digest);
+		crypto_free_hash(tfm);
+	} else
+		template.violation = 1;
+
+	/* now add measurement; if TPM bypassed, we have a ff..ff entry */
+	result = ima_store_template(&template);
+}
+
+int ima_init(void)
+{
+	int rc;
+
+	ima_used_chip = 0;
+	rc = tpm_pcr_read(IMA_TPM, 0, NULL);
+	if (rc == 0)
+		ima_used_chip = 1;
+
+	if (!ima_used_chip)
+		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n",
+			 rc);
+
+	ima_create_htable();	/* for measurements */
+	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
+	ima_init_policy();
+	return 0;
+}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
new file mode 100644
index 0000000..2dcc3b5
--- /dev/null
+++ b/security/integrity/ima/ima_main.c
@@ -0,0 +1,274 @@
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
+ *             implements the IMA LIM hooks
+ */
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/mman.h>
+
+#include "ima.h"
+
+char *ima_hash = "sha1";
+static int __init hash_setup(char *str)
+{
+	char *op = "setup";
+	char *hash = "sha1";
+
+	if (strncmp(str, "md5", 3) == 0) {
+		op = "setup";
+		hash = "md5";
+		ima_hash = str;
+	} else if (strncmp(str, "sha1", 4) != 0) {
+		op = "hash_setup";
+		hash = "invalid_hash_type";
+	}
+	integrity_audit_msg(AUDIT_INTEGRITY_HASH, NULL, NULL, op, hash, 0);
+	return 1;
+}
+__setup("ima_hash=", hash_setup);
+
+/**
+ * ima_file_free - called on close
+ * @file: pointer to file being closed
+ *
+ * Flag files that changed, based on i_version.
+ */
+static void ima_file_free(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_iint_cache *iint;
+
+	if (S_ISDIR(inode->i_mode))
+		return;
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (atomic_read(&inode->i_writecount) == 1)) {
+		rcu_read_lock();
+		iint = ima_iint_lookup(inode);
+		if (!iint) {
+			rcu_read_unlock();
+			return;
+		}
+		kref_get(&iint->refcount);
+		rcu_read_unlock();
+
+		mutex_lock(&iint->mutex);
+		if (iint->version != inode->i_version)
+			iint->flags &= ~IMA_MEASURED;
+		mutex_unlock(&iint->mutex);
+		kref_put(&iint->refcount, iint_free);
+	}
+}
+
+/**
+ * ima_path_check_integrity - based on policy, collect/store measurement.
+ * @path: contains a pointer to the path to be measured
+ * @mask: contains MAY_READ, MAY_WRITE or MAY_EXECUTE
+ *
+ * Measure the file being open for read, based on the ima_must_measure()
+ * policy decision.
+ *
+ * Invalidate the PCR:
+ * 	- Opening a file for write when already open for read,
+ *	  results in a time of measure, time of use (ToMToU) error.
+ *	- Opening a file for read when already open for write,
+ * 	  could result in a file measurement error.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+static int ima_path_check_integrity(struct path *path, int mask)
+{
+	struct ima_measure_data mdata;
+
+	memset(&mdata, 0, sizeof mdata);
+	mdata.inode = path->dentry->d_inode;
+	mdata.mask = mask;
+	mdata.function = PATH_CHECK;
+
+	/* Invalidate PCR, if a measured file is already open for read */
+	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_WRITE) {
+		int rc;
+
+		mdata.mask = MAY_READ;
+		rc = ima_must_measure(&mdata);
+		if (!rc || rc == -EEXIST) {
+			if (atomic_read(&(path->dentry->d_count)) - 1 >
+			    atomic_read(&(mdata.inode->i_writecount)))
+				ima_add_violation(mdata.inode,
+						  path->dentry->d_name.name,
+						  "invalid_pcr", "ToMToU");
+		}
+		return 0;
+	}
+
+	/* measure executables later */
+	if ((mdata.mask & (MAY_WRITE | MAY_READ)) == MAY_READ) {
+		int rc;
+
+		rc = ima_must_measure(&mdata);
+		if (!rc || rc == -EEXIST) {
+			/* Invalidate PCR, if a measured file is
+			 * already open for write.
+			 */
+			if (atomic_read(&(mdata.inode->i_writecount)) > 0)
+				ima_add_violation(mdata.inode,
+						  path->dentry->d_name.name,
+						  "invalid_pcr",
+						  "open_writers");
+		}
+		if (!rc) {
+			struct dentry *de = dget(path->dentry);
+			struct vfsmount *mnt = mntget(path->mnt);
+			struct file *file;
+
+			file = dentry_open(de, mnt, O_RDONLY);
+			if (IS_ERR(file)) {
+				ima_info("%s dentry_open failed\n",
+					 de->d_name.name);
+			} else if (file) {
+				rc = ima_collect_measurement(file);
+				if (!rc) {
+					struct ima_store_data sdata;
+
+					sdata.file = file;
+					sdata.filename =
+					    file->f_dentry->d_name.name;
+					ima_store_measurement(&sdata);
+				}
+				fput(file);
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * ima_file_mmap - based on policy, collect/store measurement.
+ * @file: pointer to the file to be measured (May be NULL)
+ * @prot contains the protection that will be applied by the kernel.
+ *
+ * Measure files being mmapped executable based on the ima_must_measure()
+ * policy decision.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+static int ima_file_mmap(struct file *file, unsigned long prot)
+{
+	struct ima_measure_data mdata;
+	int rc = 0;
+
+	if (!file)
+		return rc;
+	if (!(prot & VM_EXEC))
+		return rc;
+
+	memset(&mdata, 0, sizeof mdata);
+	mdata.inode = file->f_dentry->d_inode;
+	mdata.mask = MAY_EXEC;
+	mdata.function = FILE_MMAP;
+
+	rc = ima_must_measure(&mdata);
+	if (!rc) {
+		rc = ima_collect_measurement(file);
+		if (!rc) {
+			struct ima_store_data sdata;
+
+			sdata.file = file;
+			sdata.filename = file->f_dentry->d_name.name;
+			ima_store_measurement(&sdata);
+		}
+	}
+	return 0;
+}
+
+/**
+ * ima_bprm_check_integrity - based on policy, collect/store measurement.
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
+static int ima_bprm_check_integrity(struct linux_binprm *bprm)
+{
+	struct ima_measure_data mdata;
+	int rc = 0;
+
+	memset(&mdata, 0, sizeof mdata);
+	mdata.inode = bprm->file->f_dentry->d_inode;
+	mdata.mask = MAY_EXEC;
+	mdata.function = BPRM_CHECK;
+
+	rc = ima_must_measure(&mdata);
+	if (!rc) {
+		rc = ima_collect_measurement(bprm->file);
+		if (!rc) {
+			struct ima_store_data sdata;
+
+			sdata.file = bprm->file;
+			sdata.filename = bprm->filename;
+			ima_store_measurement(&sdata);
+		}
+	}
+	return 0;
+}
+
+static const struct integrity_operations ima_integrity_ops = {
+	.bprm_check_integrity = ima_bprm_check_integrity,
+	.path_check_integrity = ima_path_check_integrity,
+	.inode_alloc_integrity = ima_iint_insert,
+	.inode_free_integrity = ima_iint_delete,
+	.file_free_integrity = ima_file_free,
+	.file_mmap = ima_file_mmap,
+};
+
+/* After the TPM is available, start IMA
+ */
+static int __init init_ima(void)
+{
+	int error;
+
+	error = ima_init();
+	if (error)
+		goto out;
+
+	error = register_integrity(&ima_integrity_ops);
+	if (error)
+		goto out;
+
+	integrity_register_template("ima", &ima_template_ops);
+out:
+	return error;
+}
+
+static void __exit cleanup_ima(void)
+{
+	integrity_unregister_template("ima");
+	unregister_integrity(&ima_integrity_ops);
+}
+
+late_initcall(init_ima);	/* Start IMA after the TPM is available */
+module_exit(cleanup_ima);
+
+MODULE_DESCRIPTION("Integrity Measurement Architecture");
+MODULE_LICENSE("GPL");
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
new file mode 100644
index 0000000..260f71c
--- /dev/null
+++ b/security/integrity/ima/ima_policy.c
@@ -0,0 +1,124 @@
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
+#include <linux/integrity.h>
+#include <linux/magic.h>
+
+#include "ima.h"
+
+struct ima_measure_rule_entry {
+	struct list_head list;
+	int action;
+	unsigned int flags;
+	enum lim_hooks func;
+	int mask;
+	unsigned long fsmagic;
+	uid_t uid;
+};
+
+/* flags definitions */
+#define IMA_FUNC 	0x0001
+#define IMA_MASK 	0x0002
+#define IMA_FSMAGIC	0x0004
+#define IMA_UID		0x0008
+
+/* Without LSM specific knowledge, default policy can only be
+ * written in terms of .action, .func, .mask, .fsmagic, and .uid
+ */
+static struct ima_measure_rule_entry default_rules[] = {
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
+};
+
+static struct list_head measure_default_rules;
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
+			    struct inode *inode, enum lim_hooks func, int mask)
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
+	if ((rule->flags & IMA_UID) && rule->uid != tsk->uid)
+		return false;
+	return true;
+}
+
+/**
+ * ima_match_policy - decision based on LSM and other conditions
+ * @inode: pointer to an inode
+ * @func: IMA hook identifier
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ *
+ * Measure decision based on func/mask/fsmagic and LSM(subj/obj/type)
+ * conditions. Returns rule action on rule match, 0 on failure.
+ */
+int ima_match_policy(struct inode *inode, enum lim_hooks func, int mask)
+{
+	struct ima_measure_rule_entry *entry;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, ima_measure, list) {
+		bool rc;
+
+		rc = ima_match_rules(entry, inode, func, mask);
+		if (rc) {
+			rcu_read_unlock();
+			return entry->action;
+		}
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+/**
+ * ima_init_policy - initialize the default and policy measure rules.
+ */
+void ima_init_policy(void)
+{
+	int i;
+
+	INIT_LIST_HEAD(&measure_default_rules);
+	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
+		list_add_tail(&default_rules[i].list, &measure_default_rules);
+	ima_measure = &measure_default_rules;
+}
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
new file mode 100644
index 0000000..4224920
--- /dev/null
+++ b/security/integrity/ima/ima_queue.c
@@ -0,0 +1,125 @@
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
+ *       implements queues that store IMA measurements and
+ *       maintains aggregate over the stored measurements
+ *       in the pre-configured TPM PCR (if available)
+ *       The measurement list is append-only. No entry is
+ *       ever removed or changed during the boot-cycle.
+ */
+#include <linux/module.h>
+
+#include "ima.h"
+
+struct list_head ima_measurements;	/* list of all measurements */
+struct ima_h_table ima_htable;	/* key: inode (before secure-hashing a file) */
+
+/* mutex protects atomicity of extending measurement list
+ * and extending the TPM PCR aggregate. Since tpm_extend can take
+ * long (and the tpm driver uses a mutex), we can't use the spinlock.
+ */
+static DEFINE_MUTEX(ima_extend_list_mutex);
+
+void ima_create_htable(void)
+{
+	int i;
+
+	INIT_LIST_HEAD(&ima_measurements);
+	atomic_set(&ima_htable.len, 0);
+	atomic_long_set(&ima_htable.violations, 0);
+	ima_htable.max_htable_size = IMA_MEASURE_HTABLE_SIZE;
+
+	for (i = 0; i < ima_htable.max_htable_size; i++) {
+		INIT_HLIST_HEAD(&ima_htable.queue[i]);
+		atomic_set(&ima_htable.queue_len[i], 0);
+	}
+}
+
+static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
+{
+	struct ima_queue_entry *qe, *ret = NULL;
+	unsigned int key;
+	struct hlist_node *pos;
+
+	key = IMA_HASH_KEY(digest_value);
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
+		if (memcmp(qe->entry->digest, digest_value, 20) == 0) {
+			ret = qe;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+/* Called with mutex held */
+static int ima_add_digest_entry(struct ima_template_entry *entry)
+{
+	struct ima_queue_entry *qe;
+	unsigned int key;
+
+	key = IMA_HASH_KEY(entry->digest);
+	qe = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (qe == NULL) {
+		ima_error("OUT OF MEMORY ERROR creating queue entry.\n");
+		return -ENOMEM;
+	}
+	qe->entry = entry;
+
+	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	atomic_inc(&ima_htable.queue_len[key]);
+	return 0;
+}
+
+int ima_add_template_entry(struct ima_template_entry *entry, int violation)
+{
+	struct ima_queue_entry *qe;
+	int error = 0;
+
+	mutex_lock(&ima_extend_list_mutex);
+	if (!violation) {
+		if (ima_lookup_digest_entry(entry->digest)) {
+			error = -EEXIST;
+			goto out;
+		}
+	}
+	qe = kmalloc(sizeof(struct ima_queue_entry), GFP_KERNEL);
+	if (qe == NULL) {
+		ima_error("OUT OF MEMORY in %s.\n", __func__);
+		error = -ENOMEM;
+		goto out;
+	}
+	qe->entry = entry;
+
+	INIT_LIST_HEAD(&qe->later);
+	list_add_tail_rcu(&qe->later, &ima_measurements);
+
+	atomic_long_inc(&ima_htable.len);
+	if (ima_add_digest_entry(entry)) {
+		kfree(qe);
+		error = -ENOMEM;
+		goto out;
+	}
+	if (violation) {	/* Replace 0x00 with 0xFF */
+		u8 digest[IMA_DIGEST_SIZE];
+
+		memset(digest, 0xff, sizeof digest);
+		ima_extend(digest);
+	} else
+		ima_extend(entry->digest);
+out:
+	mutex_unlock(&ima_extend_list_mutex);
+	return error;
+}
-- 
1.5.6.5

