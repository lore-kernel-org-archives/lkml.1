Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYGGV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYGGV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbYGGV6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:58:01 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52940 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844AbYGGV55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:57:57 -0400
Subject: [PATCH 5/5] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
References: <20080707192529.489789904@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 17:57:53 -0400
Message-Id: <1215467873.27626.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-release of Integrity Measurement Architecture(IMA) as an 
independent Linunx Integrity Module(LIM) service provider.

This version addresses a number of issues discussed on LKML, including:
- Added Documentation/ABI/testing/ima_policy which describes loading
  the IMA measurement policy.
- Added policy support for magic numbers and removed them from
  skip_measurement().
- Added policy support for LSM obj_type.
- Replaced using .i_mtime to detect when a file has been modified
  with .i_version. This requires the filesystem to be mounted with
  iversion.  (Requires iversion mount support.)
- Added const for integrity_template_operations.
- Removed integrity_fixup_ops(), to make integrity_operations const too.
- Removed ima_fixup_inodes() by registering the integrity_ops early in
  security_initcall(), but waiting to start IMA in late_initcall(), until
  after the TPM is available.
- Removed CONFIG_IMA_BOOTPARAM and CONFIG_IMA_BOOTPARAM_VALUE.
- Replaced,as appropriate, all GFP_ATOMICs with GFP_KERNEL.

As a LIM integrity provider, IMA implements the new LIM must_measure(),
collect_measurement(), store_measurement(), and display_template() API
calls. The store_measurement() call supports two types of data, IMA
(i.e. file data) and generic template data.

IMA provides hardware (TPM) based measurement and attestation for both
files and other types of template measurements. As the Trusted Computing
(TPM) model requires, IMA measures all files before they are accessed
in any way (on the bprm_check_integrity, file_mmap and inode_permission
hooks), and commits the measurements to the TPM.  In addition, IMA
maintains a list of these hash values, which can be used to validate
the aggregate PCR value.  The TPM can sign these measurements, and thus
the system can prove to itself and to a third party these measurements
in a way that cannot be circumvented by malicious or compromised software.

When store_measurement() is called for the IMA type of data, the file
measurement and the file name hint are used to form an IMA template.
IMA then calculates the IMA template measurement(hash) and submits it
to the TPM chip for inclusion in one of the chip's Platform Configuration
Registers (PCR).

When store_measurement() is called for generic template data, IMA
calculates the measurement(hash) of the template data, and submits
the template measurement to the TPM chip for inclusion in one of the
chip's Platform Configuration Registers(PCR).

In order to view the contents of template data through securityfs, the
template_display() function must be defined in the registered 
template_operations.  In the case of the IMA template, the list of 
file names and files hashes submitted can be viewed through securityfs.

As mentioned above, IMA maintains a list of hash values of executables 
and other sensitive system files loaded into the run-time of the system.
Our work has shown that requests for integrity appraisal and measurement 
need to be based on knowledge of the filesystem, requiring the system
to either be labeled with integrity data or depend on the existent LSM
security labels.  The previous set of integrity patches modified the LSM
modules to be integrity context aware, meaning that the LSM modules made
integrity data/metadata appraisal and measurement API calls based on 
an understanding of the LSM security labels.  Both of the LSM maintainers
felt that the changes were too intrusive and that integrity enforcement
should be made by the integrity provider, not the LSM module.  

To address these concerns, Stephen Smalley suggested using the 
security_audit_rule_match(), renamed to security_filter_rule_match(), to 
define LSM specific integrity measurement policy rules, in lieu of 
modifying the LSM modules.  In the current set of patches, the integrity
API calls can be made either by IMA, based on an LSM specific integrity 
policy, or by an integrity context aware LSM. 

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.26-rc9-git1/Documentation/ABI/testing/ima_policy
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/Documentation/ABI/testing/ima_policy
@@ -0,0 +1,55 @@
+What:		security/ima/policy
+Date:		May 2008
+Contact:	Mimi Zohar <zohar@us.ibm.com>
+Description:
+		The Trusted Computing Group(TCG) runtime Integrity
+	  	Measurement Architecture(IMA) maintains a list of hash
+		values of executables and other sensitive system files
+		loaded into the run-time of this system.  At runtime,
+		the policy can be constrained based on LSM specific data.
+		Policies are loaded into security/ima/policy by opening
+		the file, writing the rules one at a time and then
+		closing the file.  The new policy takes effect after
+		the security/ima/policy is closed.
+
+		rule format: action [condition ...]
+
+		action: measure | dont_measure
+		condition:= base | lsm
+			base:	[[func=] [mask=] [fsmagic=]]
+			lsm:	[[subj=] [obj=] [type=]]
+
+		base: 	func:= [BPRM_CHECK][FILE_MMAP][INODE_PERMISSION]
+			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
+			fsmagic:= hex value
+		lsm:  	are LSM specific
+
+		default policy:
+ 			# PROC_SUPER_MAGIC
+			dont_measure fsmagic=0x9fa0
+			# SYSFS_MAGIC
+			dont_measure fsmagic=0x62656572
+ 			# DEBUGFS_MAGIC
+			dont_measure fsmagic=0x64626720
+			# TMPFS_MAGIC
+			dont_measure fsmagic=0x01021994
+			# SECURITYFS_MAGIC
+			dont_measure fsmagic=0x73636673
+
+			measure func=BPRM_CHECK
+			measure func=FILE_MMAP mask=MAY_EXEC
+			measure func=INODE_PERM mask=MAY_READ
+
+		The default policy measures all executables in bprm_check,
+		all files mmapped executable in file_mmap, and all files
+		open for read in inode_permission.
+
+		Examples of LSM specific definitions:
+
+		SELinux:
+			dont_measure type=var_log_t
+			dont_measure type=auditd_log_t
+			measure subj=system_u func=INODE_PERM mask=MAY_READ
+
+		Smack:
+			measure subj=_ func=INODE_PERM mask=MAY_READ
Index: linux-2.6.26-rc9-git1/security/integrity/ima/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/Kconfig
@@ -0,0 +1,41 @@
+#
+# IBM Integrity Measurement Architecture
+#
+
+config IMA
+	bool "Integrity Measurement Architecture(IMA)"
+	depends on INTEGRITY
+	depends on ACPI
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
+	int "PCR for Aggregate (8<= Index <= 14)"
+	depends on IMA
+	range 8 14
+	default 10
+	help
+	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
+	  that IMA uses to maintain the integrity aggregate of the
+	  measurement list.  If unsure, use the default 10.
+
+config IMA_BASE_HOOKS
+	bool "IMA base hooks"
+	depends on IMA
+	default n
+	help
+	  Enable this option to allow the LSM module to enforce integrity.
Index: linux-2.6.26-rc9-git1/security/integrity/ima/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for building Trusted Computing Group's(TCG) runtime Integrity
+# Measurement Architecture(IMA).
+#
+
+obj-$(CONFIG_IMA) += ima.o
+
+ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
+	 ima_policy.o
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_main.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_main.c
@@ -0,0 +1,361 @@
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
+#include <linux/integrity.h>
+#include <linux/magic.h>
+#include <linux/writeback.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/audit.h>
+#include <linux/ima.h>
+#include <linux/mman.h>
+
+#include "ima.h"
+
+static bool ima_initialized = false;
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
+
+__setup("ima_hash=", hash_setup);
+
+/* For use when the LSM module makes LIM API calls */
+#ifdef CONFIG_IMA_BASE_HOOKS
+static int ima_base_hooks = 1;
+#else
+static int ima_base_hooks;
+#endif
+
+/*
+ * Setup the data structure used for the IMA LIM API calls.
+ */
+void ima_fixup_argsdata(struct ima_args_data *data,
+			struct inode *inode, struct dentry *dentry,
+			struct file *file, struct nameidata *nd, int mask,
+			int function)
+{
+	data->inode = inode;
+	data->dentry = dentry;
+	data->file = file;
+	data->nd = nd;
+	data->mask = mask;
+	data->function = function;
+
+	if (file && file->f_dentry) {
+		if (!dentry)
+			data->dentry = dentry = file->f_dentry;
+	}
+	if (nd && nd->path.dentry) {
+		if (!dentry)
+			data->dentry = dentry = nd->path.dentry;
+	}
+	if (dentry && dentry->d_inode) {
+		if (!inode)
+			data->inode = inode = dentry->d_inode;
+	}
+
+	return;
+}
+
+/**
+ * ima_file_free - called on close
+ * @file: pointer to file being closed
+ *
+ * Flag files that changed, based on i_version.
+ */
+static void ima_file_free(struct file *file)
+{
+	struct inode *inode = NULL;
+	struct ima_iint_cache *iint;
+
+	if (!file->f_dentry)	/* can be NULL */
+		return;
+
+	inode = file->f_dentry->d_inode;
+	if (S_ISDIR(inode->i_mode))
+		return;
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (atomic_read(&inode->i_writecount) == 1)) {
+		iint = inode->i_integrity;
+		mutex_lock(&iint->mutex);
+		if (iint->version != inode->i_version)
+			iint->measured = 0;
+		mutex_unlock(&iint->mutex);
+	}
+}
+
+/**
+ * ima_alloc_integrity - allocate and attach an integrity structure
+ * @inode: the inode structure
+ *
+ * Returns 0 on success, -ENOMEM on failure
+ */
+static int ima_inode_alloc_integrity(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
+	if (!iint)
+		return -ENOMEM;
+
+	mutex_init(&iint->mutex);
+	inode->i_integrity = iint;
+	iint->version = inode->i_version;
+	return 0;
+}
+
+/**
+ * ima_inode_free_integrity - free the integrity structure
+ * @inode: the inode structure
+ */
+static void ima_inode_free_integrity(struct inode *inode)
+{
+	struct ima_iint_cache *iint = inode->i_integrity;
+
+	if (iint) {
+		inode->i_integrity = NULL;
+		kfree(iint);
+	}
+}
+
+/**
+ * ima_inode_permission - based on policy, collect/store measurement.
+ * @inode: pointer to the inode to be measured
+ * @mask: contains MAY_READ, MAY_WRITE, MAY_APPEND or MAY_EXECUTE
+ * @nd: pointer to a nameidata
+ *
+ * Measure the file associated with the inode, if the
+ * file is open for read and the results of the call to
+ * ima_must_measure() require the file to be measured.
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
+static int ima_inode_permission(struct inode *inode, int mask,
+				struct nameidata *nd)
+{
+	struct ima_data idata;
+	struct ima_args_data *data = &idata.data.args;
+
+	if (!ima_initialized)
+		return 0;
+
+	memset(&idata, 0, sizeof idata);
+	ima_fixup_argsdata(data, inode, NULL, NULL, nd, mask, INODE_PERMISSION);
+
+	/* The file name is not required, but only a hint. */
+	if (nd)
+		data->filename = (!nd->path.dentry->d_name.name) ?
+		    (char *)nd->path.dentry->d_iname :
+		    (char *)nd->path.dentry->d_name.name;
+
+	/* Invalidate PCR, if a measured file is already open for read */
+	if ((mask == MAY_WRITE) || (mask == MAY_APPEND)) {
+		int mask_sav = data->mask;
+		int rc;
+
+		data->mask = MAY_READ;
+		rc = ima_must_measure(&idata);
+		if (!rc) {
+			if (atomic_read(&(data->dentry->d_count)) - 1 >
+			    atomic_read(&(inode->i_writecount)))
+				ima_add_violation(inode, data->filename,
+						  "invalid_pcr", "ToMToU");
+		}
+		data->mask = mask_sav;
+		goto out;
+	}
+
+	/* measure executables later */
+	if (mask & MAY_READ) {
+		int rc;
+
+		rc = ima_must_measure(&idata);
+		if (!rc) {
+			/* Invalidate PCR, if a measured file is
+			 * already open for write.
+			 */
+			if (atomic_read(&(inode->i_writecount)) > 0)
+				ima_add_violation(inode, data->filename,
+						  "invalid_pcr",
+						  "open_writers");
+
+			idata.type = IMA_DATA;
+			rc = ima_collect_measurement(&idata);
+			if (!rc)
+				ima_store_measurement(&idata);
+		}
+	}
+out:
+	return 0;
+}
+
+/**
+ * ima_file_mmap - based on policy, collect/store measurement.
+ * @inode: pointer to the inode to be measured
+ * @mask: contains MAY_READ, MAY_WRITE, MAY_APPEND or MAY_EXECUTE
+ * @nd: pointer to a nameidata
+ *
+ * Measure files being mmapped executable based on the ima_must_measure()
+ * policy decision.
+ *
+ * Return 0 on success, an error code on failure.
+ * (Based on the results of appraise_measurement().)
+ */
+static int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags,
+			 unsigned long addr, unsigned long addr_only)
+{
+	struct ima_data idata;
+	struct ima_args_data *data = &idata.data.args;
+	int rc = 0;
+
+	if (!ima_initialized)
+		return 0;
+	if (!file || !file->f_dentry)
+		return rc;
+	if (!(prot & VM_EXEC))
+		return rc;
+
+	ima_fixup_argsdata(data, NULL, NULL, file, NULL, MAY_EXEC, FILE_MMAP);
+	data->filename = (file->f_dentry->d_name.name) ?
+	    (char *)file->f_dentry->d_iname :
+	    (char *)file->f_dentry->d_name.name;
+
+	rc = ima_must_measure(&idata);
+	if (!rc) {
+		idata.type = IMA_DATA;
+		rc = ima_collect_measurement(&idata);
+		if (!rc)
+			ima_store_measurement(&idata);
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
+	struct ima_data idata;
+	struct ima_args_data *data = &idata.data.args;
+	int rc = 0;
+
+	if (!ima_initialized)
+		return 0;
+	ima_fixup_argsdata(data, NULL, NULL, bprm->file, NULL, MAY_EXEC,
+			   BPRM_CHECK);
+	data->filename = bprm->filename;
+
+	rc = ima_must_measure(&idata);
+	if (!rc) {
+		idata.type = IMA_DATA;
+		rc = ima_collect_measurement(&idata);
+		if (!rc)
+			ima_store_measurement(&idata);
+	}
+	return 0;
+}
+
+static const struct integrity_operations ima_integrity_ops = {
+	.bprm_check_integrity = ima_bprm_check_integrity,
+	.inode_permission = ima_inode_permission,
+	.inode_alloc_integrity = ima_inode_alloc_integrity,
+	.inode_free_integrity = ima_inode_free_integrity,
+	.file_free_integrity = ima_file_free,
+	.file_mmap = ima_file_mmap,
+};
+
+static const struct integrity_operations ima_base_ops = {
+	.inode_alloc_integrity = ima_inode_alloc_integrity,
+	.inode_free_integrity = ima_inode_free_integrity,
+	.file_free_integrity = ima_file_free,
+};
+
+/* Register the integrity ops early so that i_integrity is
+ * allocated at inode initialization.
+ */
+static int __init init_ops(void)
+{
+	int error;
+
+	if (ima_base_hooks)
+		error = register_integrity(&ima_base_ops);
+	else
+		error = register_integrity(&ima_integrity_ops);
+	return error;
+}
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
+	ima_initialized = true;
+	integrity_register_template("ima", &ima_template_ops);
+out:
+	return error;
+}
+
+static void __exit cleanup_ima(void)
+{
+	integrity_unregister_template("ima");
+	unregister_integrity(&ima_integrity_ops);
+	ima_cleanup();
+}
+
+security_initcall(init_ops);	/* Register the integrity ops early */
+late_initcall(init_ima);	/* Start IMA after the TPM is available */
+module_exit(cleanup_ima);
+
+MODULE_DESCRIPTION("Integrity Measurement Architecture");
+MODULE_LICENSE("GPL");
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_init.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_init.c
@@ -0,0 +1,105 @@
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
+static const char version[] = "v7.6 02/27/2007";
+
+int ima_used_chip;
+
+static void ima_add_boot_aggregate(void)
+{
+	/* cumulative sha1 over tpm registers 0-7 */
+	struct ima_measure_entry *entry;
+	size_t count;
+	int err;
+
+	/* create new entry for boot aggregate */
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL) {
+		ima_add_violation(NULL, boot_aggregate_name,
+				  "add_measure", "ENOMEM");
+		return;
+	}
+	count = strlen(boot_aggregate_name);
+	if (count > IMA_EVENT_NAME_LEN_MAX)
+		count = IMA_EVENT_NAME_LEN_MAX;
+	memcpy(entry->template_name, boot_aggregate_name, count);
+	entry->template_name[count] = '\0';
+	if (ima_used_chip) {
+		int i;
+		u8 pcr_i[20];
+		struct hash_desc desc;
+		struct crypto_hash *tfm;
+		struct scatterlist sg;
+
+		tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+		if (!tfm || IS_ERR(tfm)) {
+			kfree(entry);
+			ima_error("error initializing digest.\n");
+			return;
+		}
+		desc.tfm = tfm;
+		desc.flags = 0;
+		crypto_hash_init(&desc);
+
+		for (i = 0; i < 8; i++) {
+			ima_pcrread(i, pcr_i, sizeof(pcr_i));
+			/* now accumulate with current aggregate */
+			sg_init_one(&sg, (u8 *) pcr_i, 20);
+			crypto_hash_update(&desc, &sg, 20);
+		}
+		crypto_hash_final(&desc, entry->digest);
+		crypto_free_hash(tfm);
+	} else
+		memset(entry->digest, 0xff, 20);
+
+	/* now add measurement; if TPM bypassed, we have a ff..ff entry */
+	err = ima_add_measure_entry(entry, 0);
+	if (err < 0) {
+		kfree(entry);
+		ima_add_violation(NULL, boot_aggregate_name,
+				  "add_measure", " ");
+	}
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
+
+	return ima_fs_init();
+}
+
+void __exit ima_cleanup(void)
+{
+	ima_fs_cleanup();
+}
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_api.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_api.c
@@ -0,0 +1,350 @@
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
+#include <linux/magic.h>
+#include <linux/writeback.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/audit.h>
+#include <linux/ima.h>
+
+#include "ima.h"
+
+const struct template_operations ima_template_ops = {
+	.must_measure = ima_must_measure,
+	.collect_measurement = ima_collect_measurement,
+	.store_measurement = ima_store_measurement,
+	.display_template = ima_template_show
+};
+
+/**
+ * mode_setup - for compatability with non-template IMA versions
+ * @str: is pointer to a string
+ */
+int ima_template_mode = 1;
+static int __init mode_setup(char *str)
+{
+	if (strncmp(str, "ima", 3) == 0)
+		ima_template_mode = 0;
+	if (strncmp(str, "template", 7) == 0)
+		ima_template_mode = 1;
+	ima_info("template_mode %s \n",
+	       	  ima_template_mode ? "template" : "ima");
+	return 1;
+}
+
+__setup("ima_mode=", mode_setup);
+
+/**
+ * ima_digest_cpy - copy the hash in the IMA template structure to a digest
+ * @template_name: string containing the name of the template (i.e. "ima")
+ * @template: pointer to template structure
+ * @digest: pointer to the digest
+ *
+ * Returns 0 on success, error code otherwise
+ */
+static int ima_digest_cpy(char *template_name, void *template, u8 *digest)
+{
+	int rc, result = 0;
+	struct ima_inode_measure_entry *inode_template =
+	    (struct ima_inode_measure_entry *)template;
+
+	rc = strcmp(template_name, "ima");
+	if (rc == 0)
+		memcpy(digest, inode_template->digest,
+		       sizeof inode_template->digest);
+	else
+		result = -ENODATA;
+	return result;
+}
+
+/**
+ * ima_store_template_measure - collect and protect template measurements
+ * @template_name: string containing the name of the template (i.e. "ima")
+ * @template_len: length of the template data
+ * @template: actual template data
+ * @violation: invalidate pcr measurement indication
+ * @audit_cause: string containing the audit failure cause
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
+static int ima_store_template_measure(char *template_name, int template_len,
+				      char *template, int violation,
+				      char **audit_cause)
+{
+	struct ima_measure_entry *entry;
+	u8 digest[IMA_DIGEST_SIZE];
+	struct ima_queue_entry *qe;
+	int count, result = 0;
+
+	memset(digest, 0, IMA_DIGEST_SIZE);
+	if (!violation) {
+		int rc = -ENODATA;
+
+		if (!ima_template_mode)
+			rc = ima_digest_cpy(template_name, template, digest);
+		if (rc < 0)
+			result = ima_calc_template_hash(template_len, template,
+							digest);
+
+		/* hash exists already? */
+		qe = ima_lookup_digest_entry(digest);
+		if (qe) {
+			*audit_cause = "hash_exists";
+			result = -EEXIST;
+			goto out;
+		}
+	}
+
+	/* create new entry and add to measurement list */
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		*audit_cause = "ENOMEM";
+		result = -ENOMEM;
+		goto out;
+	}
+
+	entry->template = kzalloc(template_len, GFP_KERNEL);
+	if (!entry->template) {
+		*audit_cause = "ENOMEM";
+		result = -ENOMEM;
+		goto out;
+	}
+	if (!template_name) {
+		*audit_cause = "null_template_name";
+		count = 1;
+	} else {
+		count = strlen(template_name);
+		if (count > IMA_EVENT_NAME_LEN_MAX)
+			count = IMA_EVENT_NAME_LEN_MAX;
+		memcpy(entry->template_name, template_name, count);
+	}
+	entry->template_name[count] = '\0';
+	entry->template_len = template_len;
+	memcpy(entry->template, template, template_len);
+	memcpy(entry->digest, digest, IMA_DIGEST_SIZE);
+
+	result = ima_add_measure_entry(entry, violation);
+	if (result < 0)
+		kfree(entry);
+out:
+	return result;
+}
+
+/**
+ * ima_store_inode_measure - create and store an inode template measurement
+ * @name: ascii file name associated with the measurement hash
+ * @hash_len: length of hash value in bytes (16 for MD5, 20 for SHA1)
+ * @hash: actual hash value pre-calculated
+ *
+ * Returns 0 on success, error code otherwise
+ */
+static int ima_store_inode_measure(struct inode *inode,
+				   const unsigned char *name,
+				   int hash_len, char *hash, int violation)
+{
+	struct ima_inode_measure_entry measure_entry, *entry = &measure_entry;
+	int result;
+	int namelen;
+	char *op = "add_measure";
+	char *cause = " ";
+
+	memset(entry, 0, sizeof *entry);
+	if (!violation)
+		memcpy(entry->digest, hash, hash_len > IMA_DIGEST_SIZE ?
+		       IMA_DIGEST_SIZE : hash_len);
+	if (name) {
+		namelen = strlen(name);
+		memcpy(entry->file_name, name, namelen > IMA_EVENT_NAME_LEN_MAX
+		       ? IMA_EVENT_NAME_LEN_MAX : namelen);
+		entry->file_name[namelen] = '\0';
+	}
+	result = ima_store_template_measure("ima", sizeof *entry, (char *)entry,
+					    violation, &cause);
+	if (result < 0)
+		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
+				    name, op, cause, result);
+	return result;
+}
+
+/**
+ * ima_add_violation - add violation to measurement list.
+ * @inode: inode associated with the violation
+ * @fname: name associated with the inode
+ * @op: string pointer to audit operation (i.e. "invalid_pcr", "add_measure")
+ * @cause: string pointer to reason for violation (i.e. "ToMToU")
+ *
+ * Violations are flagged in the measurement list with zero hash values.
+ * By extending the PCR with 0xFF's instead of with zeroes, the PCR
+ * value is invalidated.
+ */
+void ima_add_violation(struct inode *inode, const unsigned char *fname,
+		       char *op, char *cause)
+{
+	int result;
+
+	/* can overflow, only indicator */
+	atomic_inc(&ima_htable.violations);
+
+	result = ima_store_inode_measure(inode, fname, 0, NULL, 1);
+	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, fname, op,
+			    cause, result);
+}
+
+/**
+ * skip_measurement - measure only regular files, skip everything else.
+ * @inode: inode being measured
+ * @mask: contains the permission mask
+ *
+ * Quick sanity check to make sure that only regular files opened
+ * for read-only or execute are measured.
+ *
+ * Return 1 to skip measure, 0 to measure
+ */
+static int skip_measurement(struct inode *inode, int mask)
+{
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
+		return 1;	/* can't measure */
+
+	if (special_file(inode->i_mode) || S_ISLNK(inode->i_mode))
+		return 1;	/* don't measure */
+
+	if (S_ISREG(inode->i_mode))
+		return 0;	/* measure */
+	return 1;		/* don't measure */
+}
+
+/**
+ * ima_must_measure - measure decision based on policy.
+ * @template_data: pointer to struct ima_data containing ima_args_data
+ *
+ * The policy is defined in terms of keypairs:
+ * 		subj=, obj=, type=, func=, mask=, fsmagic=
+ *	subj,obj, and type: are LSM specific.
+ * 	func: INODE_PERMISSION | BPRM_CHECK | FILE_MMAP
+ * 	mask: contains the permission mask
+ *	fsmagic: hex value
+ *
+ * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
+ * or other error, return an error code.
+*/
+int ima_must_measure(void *template_data)
+{
+	struct ima_data *idata = (struct ima_data *)template_data;
+	struct ima_args_data *data = &idata->data.args;
+	int rc;
+
+	if ((data->mask & MAY_WRITE) || (data->mask & MAY_APPEND))
+		return -EPERM;
+
+	if (skip_measurement(data->inode, data->mask))
+		return -EPERM;
+
+	rc = ima_match_policy(data->inode, data->function, data->mask);
+	if (rc)
+		return 0;
+	return -EACCES;
+}
+
+/**
+ * ima_collect_measurement - collect file measurements and store in the inode
+ * @template_data: pointer to struct ima_data containing ima_args_data
+ *
+ * Return 0 on success, error code otherwise
+ */
+int ima_collect_measurement(void *template_data)
+{
+	struct ima_iint_cache *iint;
+	struct ima_data *idata = (struct ima_data *)template_data;
+	struct ima_args_data *data = &idata->data.args;
+	struct inode *inode = data->inode;
+	struct dentry *dentry = data->dentry;
+	struct nameidata *nd = data->nd;
+	struct file *file = data->file;
+	int result = 0;
+
+	if (idata->type != IMA_DATA)
+		return -EPERM;
+
+	if (!inode || !dentry)
+		return -EINVAL;
+
+	iint = inode->i_integrity;
+	mutex_lock(&iint->mutex);
+	if (!iint->measured) {
+		memset(iint->digest, 0, IMA_DIGEST_SIZE);
+		result = ima_calc_hash(dentry, file, nd, iint->digest);
+	} else
+		result = -EEXIST;
+	mutex_unlock(&iint->mutex);
+	return result;
+}
+
+/**
+ * ima_store_measurement - store file and template measurements
+ * @template_data: pointer to struct ima_data containing ima_args_data,
+ * used to create an IMA template, or a template.
+ *
+ * For file measurements, first create an IMA template and then store it.
+ * For all other types of template measurements, just store it.
+ */
+void ima_store_measurement(void *template_data)
+{
+	struct ima_data *idata = (struct ima_data *)template_data;
+	int result;
+	char *op = "add_template_measure";
+	char *cause = "";
+
+	if (idata->type == IMA_DATA) {
+		struct ima_args_data *data = &idata->data.args;
+		struct ima_iint_cache *iint;
+
+		iint = data->inode->i_integrity;
+		mutex_lock(&iint->mutex);
+		if (iint->measured) {
+			mutex_unlock(&iint->mutex);
+			return;
+		}
+		result = ima_store_inode_measure(data->inode, data->filename,
+						 IMA_DIGEST_SIZE, iint->digest,
+						 0);
+		if (!result || result == -EEXIST) {
+			iint->measured = 1;
+			iint->version = data->inode->i_version;
+		}
+		mutex_unlock(&iint->mutex);
+	} else if (idata->type == IMA_TEMPLATE) {
+		struct ima_store_data *template = (struct ima_store_data *)
+		    &idata->data.template;
+
+		result = ima_store_template_measure(template->name,
+						    template->len,
+						    template->data, 0, &cause);
+		if (result < 0)
+			integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL,
+					    template->name, op, cause, result);
+	}
+}
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima.h
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima.h
@@ -0,0 +1,148 @@
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
+struct ima_measure_entry {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1 or md5 measurement hash */
+	char template_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+	int template_len;
+	char *template;
+};
+
+struct ima_queue_entry {
+	struct hlist_node hnext;	/* place in hash collision list */
+	struct list_head later;		/* place in ima_measurements list */
+	struct ima_measure_entry *entry;
+};
+extern struct list_head ima_measurements;	/* list of all measurements */
+
+/* declarations */
+extern int ima_template_mode;
+extern const struct template_operations ima_template_ops;
+
+/* Internal IMA function definitions */
+int ima_init(void);
+void ima_cleanup(void);
+int ima_fs_init(void);
+void ima_fs_cleanup(void);
+void ima_create_htable(void);
+int ima_add_measure_entry(struct ima_measure_entry *entry, int violation);
+struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest);
+int ima_calc_hash(struct dentry *dentry, struct file *file,
+			struct nameidata *, char *digest);
+int ima_calc_template_hash(int template_len, char *template, char *digest);
+void ima_add_violation(struct inode *inode, const unsigned char *fname,
+			char *op, char *cause);
+
+enum ima_action {DONT_MEASURE, MEASURE};
+int ima_match_policy(struct inode *inode, enum lim_hooks func, int mask);
+int ima_add_rule(int, char *, char *, char *, char *, char *, char *);
+void ima_init_policy(void);
+void ima_update_policy(void);
+
+
+/* LIM API function definitions */
+int ima_must_measure(void *d);
+int ima_collect_measurement(void *d);
+int ima_appraise_measurement(void *d);
+void ima_store_measurement(void *d);
+void ima_template_show(struct seq_file *m, void *e,
+			     enum integrity_show_type show);
+
+
+/*
+ * used to protect h_table and sha_table
+ */
+extern spinlock_t ima_queue_lock;
+
+struct ima_h_table {
+	atomic_t len;		/* number of stored measurements in the list */
+	atomic_long_t violations;
+	unsigned int max_htable_size;
+	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
+	atomic_t queue_len[IMA_MEASURE_HTABLE_SIZE];
+};
+extern struct ima_h_table ima_htable;
+
+static inline unsigned long IMA_HASH_KEY(u8 *digest)
+{
+	 return(hash_ptr(digest, IMA_HASH_BITS));
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
+struct ima_inode_measure_entry {
+	u8 digest[IMA_DIGEST_SIZE];	/* sha1/md5 measurement hash */
+	char file_name[IMA_EVENT_NAME_LEN_MAX + 1];	/* name + \0 */
+};
+
+/* inode integrity data */
+struct ima_iint_cache {
+	u64 		version;
+	int 		measured;
+	u8 		hmac[IMA_DIGEST_SIZE];
+	u8 		digest[IMA_DIGEST_SIZE];
+	struct mutex mutex;
+};
+#endif
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_crypto.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_crypto.c
@@ -0,0 +1,153 @@
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
+#include <linux/init.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/crypto.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/scatterlist.h>
+#include "ima.h"
+
+/*
+ * Calculate the file hash, using an open file descriptor if available.
+ */
+static int update_file_hash(struct dentry *dentry, struct file *f,
+			    struct nameidata *nd, struct hash_desc *desc)
+{
+	struct file *file = f;
+	struct scatterlist sg[1];
+	loff_t i_size;
+	int rc = 0;
+	char *rbuf;
+	int offset = 0;
+
+	if (!file) {
+		struct dentry *de = dget(dentry);
+		struct vfsmount *mnt = mntget(nd->path.mnt);
+		if (!de || !mnt) {
+			rc = -EINVAL;
+			goto err_out;
+		}
+		file = dentry_open(de, mnt, O_RDONLY);
+		if (IS_ERR(file)) {
+			ima_info("%s dentry_open failed\n", de->d_name.name);
+			rc = PTR_ERR(file);
+			file = NULL;
+		}
+err_out:
+		if (!file) {
+			dput(de);
+			mntput(mnt);
+			goto out;
+		}
+	}
+
+	if (!file->f_dentry || !file->f_dentry->d_inode) {
+		rc = -EINVAL;
+		goto out;
+	}
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
+		rc = crypto_hash_update(desc, sg, rbuf_len);
+		if (rc)
+			break;
+	}
+	kfree(rbuf);
+out:
+	if (file && !f)
+		fput(file);	/* clean up dentry_open() */
+	return rc;
+}
+
+/*
+ * Calculate the MD5/SHA1 digest
+ */
+int ima_calc_hash(struct dentry *dentry, struct file *file,
+		  struct nameidata *nd, char *digest)
+{
+	struct hash_desc desc;
+	int rc;
+
+	if (!dentry && !file)
+		return -EINVAL;
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
+	rc = update_file_hash(dentry, file, nd, &desc);
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
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_fs.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_fs.c
@@ -0,0 +1,458 @@
+/*
+ * Copyright (C) 2005,2006,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Kylene Hall <kjhall@us.ibm.com>
+ * Reiner Sailer <sailer@us.ibm.com>
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_fs.c
+ *	implemenents security file system for reporting
+ *	current measurement list and IMA statistics
+ */
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/integrity.h>
+
+#include "ima.h"
+
+#define TMPBUFLEN 12
+static ssize_t ima_show_htable_value(char __user *buf, size_t count,
+				     loff_t *ppos, atomic_t *val)
+{
+	char tmpbuf[TMPBUFLEN];
+	ssize_t len;
+
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%i\n", atomic_read(val));
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
+}
+
+static ssize_t ima_show_htable_violations(struct file *filp,
+					  char __user *buf,
+					  size_t count, loff_t *ppos)
+{
+	return ima_show_htable_value(buf, count, ppos, &ima_htable.violations);
+}
+
+static struct file_operations ima_htable_violations_ops = {
+	.read = ima_show_htable_violations
+};
+
+static ssize_t ima_show_measurements_count(struct file *filp,
+					   char __user *buf,
+					   size_t count, loff_t *ppos)
+{
+	return ima_show_htable_value(buf, count, ppos, &ima_htable.len);
+
+}
+
+static struct file_operations ima_measurements_count_ops = {
+	.read = ima_show_measurements_count
+};
+
+/* returns pointer to hlist_node */
+static void *ima_measurements_start(struct seq_file *m, loff_t *pos)
+{
+	struct list_head *lpos;
+	loff_t l = *pos;
+	/* we need a lock since pos could point beyond last element */
+	rcu_read_lock();
+	list_for_each_rcu(lpos, &ima_measurements) {
+		if (!l--) {
+			rcu_read_unlock();
+			return lpos;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+static void *ima_measurements_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	/* lock protects when reading beyond last element
+	 * against concurrent list-extension */
+	struct list_head *lpos = (struct list_head *)v;
+
+	rcu_read_lock();
+	lpos = rcu_dereference(lpos->next);
+	rcu_read_unlock();
+	(*pos)++;
+
+	return (lpos == &ima_measurements) ? NULL : lpos;
+}
+
+static void ima_measurements_stop(struct seq_file *m, void *v)
+{
+}
+
+/* print format:
+ *       32bit-le=pcr#
+ *       char[20]=template digest
+ *       32bit-le=template size
+ *       32bit-le=template name size
+ *       eventdata[n] = template name
+ *
+ */
+static int ima_measurements_show(struct seq_file *m, void *v)
+{
+	/* the list never shrinks, so we don't need a lock here */
+	struct list_head *lpos = v;
+	struct ima_queue_entry *qe;
+	struct ima_measure_entry *e;
+	struct ima_inode_measure_entry *entry;
+	const struct template_operations *template_ops;
+	int templatename_len;
+	int i;
+	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
+	char data[4];
+
+	/* get entry */
+	qe = list_entry(lpos, struct ima_queue_entry, later);
+	e = qe->entry;
+	if (e == NULL)
+		return -1;
+
+	/*
+	 * 1st: PCRIndex
+	 * PCR used is always the same (config option) in
+	 * little-endian format
+	 */
+	memcpy(data, &pcr, 4);
+	for (i = 0; i < 4; i++)
+		seq_putc(m, data[i]);
+
+	/* 2nd: template digest */
+	for (i = 0; i < 20; i++)
+		seq_putc(m, e->digest[i]);
+
+	/* 3rd: template name size */
+	templatename_len = strlen(e->template_name);
+	if (templatename_len > IMA_EVENT_NAME_LEN_MAX)
+		templatename_len = IMA_EVENT_NAME_LEN_MAX;
+
+	memcpy(data, &templatename_len, 4);
+	for (i = 0; i < 4; i++)
+		seq_putc(m, data[i]);
+
+	/* 4th:  template name  */
+	for (i = 0; i < templatename_len; i++)
+		seq_putc(m, e->template_name[i]);
+
+	/* 5th:  template dependent */
+	entry = (struct ima_inode_measure_entry *)e->template;
+	if (integrity_find_template(e->template_name, &template_ops) == 0)
+		template_ops->display_template(m, entry, INTEGRITY_SHOW_BINARY);
+	else
+		seq_printf(m, " \n");
+	return 0;
+}
+
+static struct seq_operations ima_measurments_seqops = {
+	.start = ima_measurements_start,
+	.next = ima_measurements_next,
+	.stop = ima_measurements_stop,
+	.show = ima_measurements_show
+};
+
+static int ima_measurements_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ima_measurments_seqops);
+}
+
+static struct file_operations ima_measurements_ops = {
+	.open = ima_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+void ima_template_show(struct seq_file *m, void *e,
+		       enum integrity_show_type show)
+{
+	struct ima_inode_measure_entry *entry =
+	    (struct ima_inode_measure_entry *)e;
+	int filename_len;
+	char data[4];
+	int i;
+
+	/* Display file digest */
+	if (ima_template_mode)
+		for (i = 0; i < 20; i++) {
+			switch (show) {
+			case INTEGRITY_SHOW_ASCII:
+				seq_printf(m, "%02x", entry->digest[i]);
+				break;
+			case INTEGRITY_SHOW_BINARY:
+				seq_putc(m, entry->digest[i]);
+			default:
+				break;
+			}
+		}
+
+	switch (show) {
+	case INTEGRITY_SHOW_ASCII:
+		seq_printf(m, " %s\n", entry->file_name);
+		break;
+	case INTEGRITY_SHOW_BINARY:
+		filename_len = strlen(entry->file_name);
+		if (filename_len > IMA_EVENT_NAME_LEN_MAX)
+			filename_len = IMA_EVENT_NAME_LEN_MAX;
+
+		memcpy(data, &filename_len, 4);
+		for (i = 0; i < 4; i++)
+			seq_putc(m, data[i]);
+		for (i = 0; i < filename_len; i++)
+			seq_putc(m, entry->file_name[i]);
+	default:
+		break;
+	}
+}
+
+/* print in ascii */
+static int ima_ascii_measurements_show(struct seq_file *m, void *v)
+{
+	/* the list never shrinks, so we don't need a lock here */
+	struct list_head *lpos = v;
+	struct ima_queue_entry *qe;
+	struct ima_measure_entry *e;
+	struct ima_inode_measure_entry *entry;
+	const struct template_operations *template_ops;
+	int i;
+
+	/* get entry */
+	qe = list_entry(lpos, struct ima_queue_entry, later);
+	e = qe->entry;
+	if (e == NULL)
+		return -1;
+
+	/* 1st: PCR used (config option) */
+	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
+
+	/* 2nd: SHA1 template hash */
+	for (i = 0; i < 20; i++)
+		seq_printf(m, "%02x", e->digest[i]);
+
+	/* 3th:  template name */
+	seq_printf(m, " %s ", e->template_name);
+
+	/* 4th:  filename <= max + \'0' delimiter */
+	entry = (struct ima_inode_measure_entry *)e->template;
+	if (integrity_find_template(e->template_name, &template_ops) == 0)
+		template_ops->display_template(m, entry, INTEGRITY_SHOW_ASCII);
+	else
+		seq_printf(m, " \n");
+
+	return 0;
+}
+
+static struct seq_operations ima_ascii_measurements_seqops = {
+	.start = ima_measurements_start,
+	.next = ima_measurements_next,
+	.stop = ima_measurements_stop,
+	.show = ima_ascii_measurements_show
+};
+
+static int ima_ascii_measurements_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ima_ascii_measurements_seqops);
+}
+
+static struct file_operations ima_ascii_measurements_ops = {
+	.open = ima_ascii_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static char *get_tag(char *bufStart, char *bufEnd, char delimiter, int *taglen)
+{
+	char *bufp = bufStart;
+	char *tag;
+
+	/* Get start of tag */
+	while (bufp < bufEnd) {
+		if (*bufp == ' ')	/* skip blanks */
+			while ((*bufp == ' ') && (bufp++ < bufEnd)) ;
+		else if (*bufp == '#') {	/* skip comment */
+			while ((*bufp != '\n') && (bufp++ < bufEnd)) ;
+			bufp++;
+		} else if (*bufp == '\n')	/* skip newline */
+			bufp++;
+		else if (*bufp == '\t')	/* skip tabs */
+			bufp++;
+		else
+			break;
+	}
+	if (bufp < bufEnd)
+		tag = bufp;
+	else
+		return NULL;
+
+	/* Get tag */
+	*taglen = 0;
+	while ((bufp < bufEnd) && (*taglen == 0)) {
+		if ((*bufp == delimiter) || (*bufp == '\n')) {
+			*taglen = bufp - tag;
+			*bufp = '\0';
+		}
+		bufp++;
+	}
+	if (*taglen == 0)	/* Didn't find end delimiter */
+		tag = NULL;
+	return tag;
+}
+
+static ssize_t ima_write_policy(struct file *file, const char __user *buf,
+				size_t buflen, loff_t *ppos)
+{
+	size_t rc = 0, datalen;
+	int action = 0;
+	char *data, *datap, *dataend;
+	char *subj = NULL, *obj = NULL, *type = NULL;
+	char *func = NULL, *mask = NULL, *fsmagic = NULL;
+	int err = 0;
+	char *tag;
+	int taglen, i;
+
+	datalen = buflen > 4095 ? 4095 : buflen;
+	data = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!data)
+		rc = -ENOMEM;
+
+	if (copy_from_user(data, buf, datalen)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	rc = datalen;
+	*(data + datalen) = ' ';
+
+	datap = data;
+	dataend = data + datalen;
+
+	if (strncmp(datap, "measure", 7) == 0) {
+		datap += 8;
+		action = 1;
+	} else if (strncmp(datap, "dont_measure", 12) == 0)
+		datap += 13;
+	else			/* bad format */
+		goto out;
+
+	for (i = 0; i < 6; i++) {
+		tag = get_tag(datap, dataend, ' ', &taglen);
+		if (!tag)
+			break;
+		if (strncmp(tag, "obj=", 4) == 0)
+			obj = tag + 4;
+		else if (strncmp(tag, "subj=", 5) == 0)
+			subj = tag + 5;
+		else if (strncmp(tag, "type=", 5) == 0)
+			type = tag + 5;
+		else if (strncmp(tag, "func=", 5) == 0)
+			func = tag + 5;
+		else if (strncmp(tag, "mask=", 5) == 0)
+			mask = tag + 5;
+		else if (strncmp(tag, "fsmagic=", 8) == 0)
+			fsmagic = tag + 8;
+		else {		/* bad format */
+			err = 1;
+			break;
+		}
+		datap += taglen + 1;
+	}
+
+	if (!err) {
+		ima_info("%s %s %s %s %s %s %s\n",
+			 action ? "measure " : "dont_measure",
+			 subj, obj, type, func, mask, fsmagic);
+		ima_add_rule(action, subj, obj, type, func, mask, fsmagic);
+	}
+out:
+	if (!data)
+		kfree(data);
+	return rc;
+}
+
+static struct dentry *ima_dir;
+static struct dentry *binary_runtime_measurements;
+static struct dentry *ascii_runtime_measurements;
+static struct dentry *runtime_measurements_count;
+static struct dentry *violations;
+static struct dentry *ima_policy;
+
+static int ima_release_policy(struct inode *inode, struct file *file)
+{
+	ima_update_policy();
+	securityfs_remove(ima_policy);
+	ima_policy = NULL;
+	return 0;
+}
+
+static struct file_operations ima_measure_policy_ops = {
+	.write = ima_write_policy,
+	.release = ima_release_policy
+};
+
+int ima_fs_init(void)
+{
+	ima_dir = securityfs_create_dir("ima", NULL);
+	if (!ima_dir || IS_ERR(ima_dir))
+		return -1;
+
+	binary_runtime_measurements =
+	    securityfs_create_file("binary_runtime_measurements",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_measurements_ops);
+	if (!binary_runtime_measurements || IS_ERR(binary_runtime_measurements))
+		goto out;
+
+	ascii_runtime_measurements =
+	    securityfs_create_file("ascii_runtime_measurements",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_ascii_measurements_ops);
+	if (!ascii_runtime_measurements || IS_ERR(ascii_runtime_measurements))
+		goto out;
+
+	runtime_measurements_count =
+	    securityfs_create_file("runtime_measurements_count",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_measurements_count_ops);
+	if (!runtime_measurements_count || IS_ERR(runtime_measurements_count))
+		goto out;
+
+	violations =
+	    securityfs_create_file("violations", S_IRUSR | S_IRGRP,
+				   ima_dir, NULL, &ima_htable_violations_ops);
+	if (!violations || IS_ERR(violations))
+		goto out;
+
+	ima_policy = securityfs_create_file("policy",
+					    S_IRUSR | S_IRGRP | S_IWUSR,
+					    ima_dir, NULL,
+					    &ima_measure_policy_ops);
+	ima_init_policy();
+	return 0;
+
+out:
+	securityfs_remove(runtime_measurements_count);
+	securityfs_remove(ascii_runtime_measurements);
+	securityfs_remove(binary_runtime_measurements);
+	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
+	return -1;
+}
+
+void __exit ima_fs_cleanup(void)
+{
+	securityfs_remove(violations);
+	securityfs_remove(runtime_measurements_count);
+	securityfs_remove(ascii_runtime_measurements);
+	securityfs_remove(binary_runtime_measurements);
+	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
+}
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_queue.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_queue.c
@@ -0,0 +1,124 @@
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
+	atomic_set(&ima_htable.violations, 0);
+	ima_htable.max_htable_size = IMA_MEASURE_HTABLE_SIZE;
+
+	for (i = 0; i < ima_htable.max_htable_size; i++) {
+		INIT_HLIST_HEAD(&ima_htable.queue[i]);
+		atomic_set(&ima_htable.queue_len[i], 0);
+	}
+}
+
+struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
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
+static int ima_add_digest_entry(struct ima_measure_entry *entry)
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
+int ima_add_measure_entry(struct ima_measure_entry *entry, int violation)
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
+	atomic_inc(&ima_htable.len);
+	if (ima_add_digest_entry(entry)) {
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
Index: linux-2.6.26-rc9-git1/security/integrity/ima/ima_policy.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/security/integrity/ima/ima_policy.c
@@ -0,0 +1,249 @@
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
+	- load a policy ruleset
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
+#define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_match security_audit_rule_match
+
+struct ima_measure_rule_entry {
+	struct list_head list;
+	int action;
+	void *lsm_obj_rule;
+	void *lsm_subj_rule;
+	void *lsm_type_rule;
+	enum lim_hooks func;
+	int mask;
+	ulong fsmagic;
+};
+
+/* Without LSM specific knowledge, default policy can only
+ * be written in terms of .action, .func, .mask and .fsmagic.
+ */
+static struct ima_measure_rule_entry default_rules[] = {
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC},
+	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC},
+	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC},
+	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC},
+	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC},
+	{.action = MEASURE,.func = INODE_PERMISSION,.mask = MAY_READ},
+};
+
+static struct list_head measure_default_rules;
+static struct list_head measure_policy_rules;
+static struct list_head *ima_measure;
+
+static DEFINE_MUTEX(ima_measure_mutex);
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
+			   struct inode *inode, enum lim_hooks func, int mask)
+{
+	if (rule->func && rule->func != func)
+		return false;
+	if (rule->mask && rule->mask != mask)
+		return false;
+	if (rule->fsmagic && rule->fsmagic != inode->i_sb->s_magic)
+		return false;
+	if (rule->lsm_subj_rule) {
+		struct task_struct *tsk = current;
+		u32 sid;
+		int rc;
+
+		security_task_getsecid(tsk, &sid);
+		rc = security_filter_rule_match(sid, AUDIT_SUBJ_USER,
+						AUDIT_EQUAL,
+						rule->lsm_subj_rule, NULL);
+		if (!rc)
+			return false;
+	}
+	if (rule->lsm_obj_rule) {
+		u32 osid;
+		int rc;
+
+		security_inode_getsecid(inode, &osid);
+		rc = security_filter_rule_match(osid, AUDIT_OBJ_USER,
+						AUDIT_EQUAL,
+						rule->lsm_obj_rule, NULL);
+		if (!rc)
+			return false;
+	}
+	if (rule->lsm_type_rule) {
+		u32 osid;
+		int rc;
+
+		security_inode_getsecid(inode, &osid);
+		rc = security_filter_rule_match(osid, AUDIT_OBJ_TYPE,
+						AUDIT_EQUAL,
+						rule->lsm_type_rule, NULL);
+		if (!rc)
+			return false;
+	}
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
+
+	INIT_LIST_HEAD(&measure_policy_rules);
+}
+
+/**
+ * ima_update_policy - update default_rules with new measure rules
+ *
+ * Wait to update the default rules with a complete new set of measure rules.
+ */
+void ima_update_policy(void)
+{
+	char *op = "policy_update";
+	char *cause = "already exists";
+	int result = 1;
+
+	if (ima_measure == &measure_default_rules) {
+		ima_measure = &measure_policy_rules;
+		cause = "complete";
+		result = 0;
+	}
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+			    NULL, op, cause, result);
+}
+
+/**
+ * ima_add_rule - add ima measure rules
+ * @action: integer 1 indicating MEASURE, 0 indicating DONT_MEASURE
+ * @subj: pointer to an LSM subject value
+ * @obj:  pointer to an LSM object value
+ * @type:  pointer to an LSM object type value
+ * @func: LIM hook identifier
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ * @fsmagic: fs magic hex value string
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int ima_add_rule(int action, char *subj, char *obj, char *type,
+		 char *func, char *mask, char *fsmagic)
+{
+	struct ima_measure_rule_entry *entry;
+	int result = 0;
+
+	/* Prevent installed policy from changing */
+	if (ima_measure != &measure_default_rules) {
+		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+				    NULL, "policy_update", "already exists", 1);
+		return -EACCES;
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	INIT_LIST_HEAD(&entry->list);
+	if (action < 0 || action > 1)
+		result = -EINVAL;
+	else
+		entry->action = action;
+	if (!result && subj)
+		result = security_filter_rule_init(AUDIT_SUBJ_USER, AUDIT_EQUAL,
+						   subj, &entry->lsm_subj_rule);
+	if (!result && obj)
+		result = security_filter_rule_init(AUDIT_OBJ_USER, AUDIT_EQUAL,
+						   obj, &entry->lsm_obj_rule);
+	if (!result && type)
+		result = security_filter_rule_init(AUDIT_OBJ_TYPE, AUDIT_EQUAL,
+						   obj, &entry->lsm_obj_rule);
+	if (!result && func) {
+		if (strcmp(func, "INODE_PERMISSION") == 0)
+			entry->func = INODE_PERMISSION;
+		else if (strcmp(func, "FILE_MMAP") == 0)
+			entry->func = FILE_MMAP;
+		else if (strcmp(func, "BPRM_CHECK") == 0)
+			entry->func = BPRM_CHECK;
+		else
+			result = -EINVAL;
+	}
+	if (!result && mask) {
+		if (strcmp(mask, "MAY_EXEC") == 0)
+			entry->mask = MAY_EXEC;
+		else if (strcmp(mask, "MAY_WRITE") == 0)
+			entry->mask = MAY_WRITE;
+		else if (strcmp(mask, "MAY_READ") == 0)
+			entry->mask = MAY_READ;
+		else if (strcmp(mask, "MAY_APPEND") == 0)
+			entry->mask = MAY_APPEND;
+		else
+			result = -EINVAL;
+	}
+	if (!result && fsmagic) {
+		int rc;
+
+		rc = strict_strtoul(fsmagic, 16, &entry->fsmagic);
+		if (rc)
+			result = -EINVAL;
+	}
+	if (!result) {
+		mutex_lock(&ima_measure_mutex);
+		list_add_tail(&entry->list, &measure_policy_rules);
+		mutex_unlock(&ima_measure_mutex);
+	}
+	return result;
+}
Index: linux-2.6.26-rc9-git1/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.26-rc9-git1.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.26-rc9-git1/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	IMA     Integrity measurement architecture is enabled.
 	INTEGRITY Integrity support is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
@@ -805,6 +806,10 @@ and is between 256 and 4096 characters. 
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_hash=	[IMA] runtime ability to define hash crypto alg.
+			Format: { "MD5" | "SHA1" }
+			Default is "SHA1".
+
 	in2000=		[HW,SCSI]
 			See header of drivers/scsi/in2000.c.
 
Index: linux-2.6.26-rc9-git1/include/linux/ima.h
===================================================================
--- /dev/null
+++ linux-2.6.26-rc9-git1/include/linux/ima.h
@@ -0,0 +1,48 @@
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
+/* IMA LIM Data */
+enum ima_type { IMA_DATA, IMA_METADATA, IMA_TEMPLATE };
+
+struct ima_args_data {
+	const char	*filename;
+	struct inode 	*inode;
+	struct dentry 	*dentry;
+	struct nameidata 	*nd;
+	struct file 	*file;
+	enum lim_hooks	function;
+	u32		osid;
+	int 		mask;
+};
+
+struct ima_store_data {
+	char 		*name;
+	int 		len;
+	char 		*data;
+	int  		violation;
+};
+
+struct ima_data {
+	enum ima_type 	type;
+	union {
+		struct ima_args_data 	args;
+		struct ima_store_data	template;
+	} data;
+};
+
+void ima_fixup_argsdata(struct ima_args_data *data,
+			struct inode *inode, struct dentry *dentry,
+			struct file *file, struct nameidata *nd, int mask,
+			int function);
+#endif
Index: linux-2.6.26-rc9-git1/security/integrity/Makefile
===================================================================
--- linux-2.6.26-rc9-git1.orig/security/integrity/Makefile
+++ linux-2.6.26-rc9-git1/security/integrity/Makefile
@@ -4,3 +4,5 @@
 
 # Object file lists
 obj-$(CONFIG_INTEGRITY)			+= integrity.o integrity_audit.o
+
+obj-$(CONFIG_IMA)			+= ima/
Index: linux-2.6.26-rc9-git1/security/integrity/Kconfig
===================================================================
--- linux-2.6.26-rc9-git1.orig/security/integrity/Kconfig
+++ linux-2.6.26-rc9-git1/security/integrity/Kconfig
@@ -2,8 +2,6 @@
 # Integrity configuration
 #
 
-menu "Integrity options"
-
 config INTEGRITY
 	bool "Enable different integrity models"
 	help
@@ -21,4 +19,5 @@ config INTEGRITY_AUDIT
 	  allows integrity auditing to be disabled at boot.  If this
 	  option is selected, integrity auditing can be disabled with
 	  'integrity_audit=0' on the kernel command line.
-endmenu
+
+source security/integrity/ima/Kconfig

-- 

