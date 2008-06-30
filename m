Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbYF3VVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbYF3VVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYF3VVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:21:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52344 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYF3VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:21:22 -0400
Subject: Re: [RFC][PATCH 4/5] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <Xine.LNX.4.64.0806302023240.23266@us.intercode.com.au>
References: <20080627131946.225566613@linux.vnet.ibm.com>
	 <1214583780.28077.17.camel@new-host.home>
	 <Xine.LNX.4.64.0806302023240.23266@us.intercode.com.au>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 17:21:17 -0400
Message-Id: <1214860877.5613.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-30 at 20:43 +1000, James Morris wrote: 

Thank you for the suggestions.  I've incorporated them into 
the patch below, except for this: 

> > +/* Hook used to measure executable file integrity. */
> > +int integrity_bprm_check(struct linux_binprm *bprm)
> > +{
> > +	int rc = 0;
> > +
> > +	if (integrity_ops && integrity_ops->bprm_check_integrity)
> > +		rc = integrity_ops->bprm_check_integrity(bprm);
> > +	return rc;
> > +}
> 
> Have you considered using a set of dummy ops similar to LSM, so that 
> integrity_ops->whatever will always point to something and can be 
> unconditionally called?  (see security_fixup_ops()).
> 
> - James

The code up to this point did exactly that, but
On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote:

> - All the `static struct integrity_operations' instances could be
>   made const.  And lots of other foo_operations too, I expect.
> 
>   That will lead to a constification chase all over the place, but
>   it's probably for the best.  This is after all a "security" feature
>   and there is perhaps some benefit in getting your eminently
>   hijackable function pointers into read-only memory.

Can't use fixup_ops if integrity_ops is defined as a const.

Mimi

[RFC][PATCH 4/5]integrity: Linux Integrity Module(LIM)

This is a request for comments for a redesign of the integrity patches.
The new version addresses a number of issues, including
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
	inode_permission, inode_alloc_integrity, inode_free_integrity, 
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
Index: linux-2.6.26-rc8/include/linux/integrity.h
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/include/linux/integrity.h
@@ -0,0 +1,195 @@
+/*
+ * integrity.h
+ *
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
+			const unsigned char *fname, char *op,
+			char *cause, int result);
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
+enum integrity_show_type { INTEGRITY_SHOW_BINARY, INTEGRITY_SHOW_ASCII};
+
+struct template_operations {
+	int (*collect_measurement)(void *);
+	int (*appraise_measurement)(void *);
+	void (*store_measurement)(void *);
+	int (*must_measure)(void *);
+	void (*display_template)(struct seq_file *m, void *,
+				 enum integrity_show_type);
+};
+extern int integrity_register_template(const char *template_name,
+					const struct template_operations *ops);
+extern int integrity_unregister_template(const char *template_name);
+extern int integrity_find_template(const char *,
+				   const struct template_operations **ops);
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
+ *	Allocate and attach an integrity structure to @inode->i_integrity.  The
+ * 	i_integrity field is initialized to NULL when the inode structure is
+ * 	allocated.
+ * 	@inode contains the inode structure.
+ * 	Return 0 if operation was successful.
+ *
+ * @inode_free_integrity:
+ *	@inode contains the inode structure.
+ * 	Deallocate the inode integrity structure and set @inode->i_integrity to
+ * 	NULL.
+ *
+ * @inode_permission:
+ *	This hook is called by the existing Linux permission function, when
+ * 	a file is opened (as well as many other operations).  At this point,
+ *	measurements of files open for read(collect, appraise, store) can
+ * 	be made.
+ *	@inode contains the inode structure to check.
+ *	@mask contains the permission mask.
+ *      @nd contains the nameidata (may be NULL).
+ *
+ * @file_free_integrity:
+ *	Update the integrity xattr value as necessary.
+ * 	*file contains the file structure being closed.
+ *
+ * @file_mmap :
+ *	Measurement(collect, appraise, store) of files mmaped for EXEC,
+ *	could be measured at this point.
+ *	@file contains the file structure for file to map (may be NULL).
+ *	@reqprot contains the protection requested by the application.
+ *	@prot contains the protection that will be applied by the kernel.
+ *	@flags contains the operational flags.
+ *	Return 0 if permission is granted.
+ */
+
+enum lim_hooks {INODE_PERMISSION = 1, FILE_MMAP, BPRM_CHECK };
+
+struct integrity_operations {
+	int (*bprm_check_integrity) (struct linux_binprm *bprm);
+	int (*inode_alloc_integrity) (struct inode *inode);
+	void (*inode_free_integrity) (struct inode *inode);
+	int (*inode_permission) (struct inode *inode, int mask,
+				struct nameidata *nd);
+	void (*file_free_integrity) (struct file *file);
+	int (*file_mmap) (struct file *file,
+			  unsigned long reqprot, unsigned long prot,
+			  unsigned long flags, unsigned long addr,
+			  unsigned long addr_only);
+};
+extern int register_integrity(const struct integrity_operations *ops);
+extern int unregister_integrity(const struct integrity_operations *ops);
+
+/* global variables */
+extern const struct integrity_operations *integrity_ops;
+
+
+int integrity_collect_measurement(const char *template_name, void *data);
+int integrity_appraise_measurement(const char *template_name, void *data);
+int integrity_must_measure(const char *template_name, void *data);
+int integrity_store_measurement(const char *template_name, void *data);
+
+int integrity_bprm_check(struct linux_binprm *bprm);
+int integrity_inode_alloc(struct inode *inode);
+void integrity_inode_free(struct inode *inode);
+int integrity_inode_permission(struct inode *inode, int mask,
+				struct nameidata *nd);
+void integrity_file_free(struct file *file);
+int integrity_file_mmap(struct file *file,
+			  unsigned long reqprot, unsigned long prot,
+			  unsigned long flags, unsigned long addr,
+			  unsigned long addr_only);
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
+static inline int integrity_inode_permission(struct inode *inode, int mask,
+				struct nameidata *nd)
+{
+	return 0;
+}
+
+static inline int integrity_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	return;
+}
+
+static inline int integrity_file_mmap(struct file *file,
+			  unsigned long reqprot, unsigned long prot,
+			  unsigned long flags, unsigned long addr,
+			  unsigned long addr_only)
+{
+	return 0;
+}
+#endif
+#endif
Index: linux-2.6.26-rc8/security/integrity/integrity.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/security/integrity/integrity.c
@@ -0,0 +1,310 @@
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/integrity.h>
+
+const struct integrity_operations *integrity_ops;
+EXPORT_SYMBOL(integrity_ops);
+
+#define TEMPLATE_NAME_LEN_MAX 12
+struct template_list_entry {
+	struct list_head template;
+	char template_name[TEMPLATE_NAME_LEN_MAX + 1];
+	const struct template_operations *template_ops;
+};
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
+	template_len = strlen(template_name);
+	if (template_len > TEMPLATE_NAME_LEN_MAX)
+		return -EINVAL;
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
+			kfree(entry);
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
+ * @template_ops: a pointer to the template functions
+ *
+ * Called with an rcu_read_lock
+ * Returns 0 on success, -EINVAL on failure.
+ */
+int integrity_find_template(const char *template_name,
+			    const struct template_operations **template_ops)
+{
+	struct template_list_entry *entry;
+
+	list_for_each_entry_rcu(entry, &integrity_templates, template) {
+		if (strncmp(entry->template_name, template_name,
+			    strlen(entry->template_name)) == 0) {
+			*template_ops = entry->template_ops;
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
+	const struct template_operations *template_ops;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_ops);
+	if (rc == 0)
+		rc = template_ops->collect_measurement(data);
+	rcu_read_unlock();
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
+	const struct template_operations *template_ops;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_ops);
+	if (rc == 0)
+		rc = template_ops->appraise_measurement(data);
+	rcu_read_unlock();
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
+	const struct template_operations *template_ops;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_ops);
+	if (rc == 0)
+		template_ops->store_measurement(data);
+	rcu_read_unlock();
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
+	const struct template_operations *template_ops;
+	int rc;
+
+	rcu_read_lock();
+	rc = integrity_find_template(template_name, &template_ops);
+	if (rc == 0)
+		rc = template_ops->must_measure(data);
+	rcu_read_unlock();
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
+/* Allocate, attach and initialize an inode's i_integrity. */
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
+int integrity_inode_permission(struct inode *inode, int mask,
+			       struct nameidata *nd)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->inode_permission)
+		rc = integrity_ops->inode_permission(inode, mask, nd);
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
+int integrity_file_mmap(struct file *file, unsigned long reqprot,
+			unsigned long prot, unsigned long flags,
+			unsigned long addr, unsigned long addr_only)
+{
+	int rc = 0;
+
+	if (integrity_ops && integrity_ops->file_mmap)
+		rc = integrity_ops->file_mmap(file, reqprot, prot,
+					      flags, addr, addr_only);
+	return rc;
+}
Index: linux-2.6.26-rc8/fs/file_table.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/file_table.c
+++ linux-2.6.26-rc8/fs/file_table.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/eventpoll.h>
 #include <linux/rcupdate.h>
 #include <linux/mount.h>
@@ -272,6 +273,7 @@ void __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	integrity_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
@@ -343,6 +345,7 @@ void put_filp(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count)) {
 		security_file_free(file);
+		integrity_file_free(file);
 		file_kill(file);
 		file_free(file);
 	}
Index: linux-2.6.26-rc8/fs/inode.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/inode.c
+++ linux-2.6.26-rc8/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -151,6 +152,15 @@ static struct inode *alloc_inode(struct 
 			return NULL;
 		}
 
+		/* allocate, attach and initialize an i_integrity */
+		if (integrity_inode_alloc(inode)) {
+			if (inode->i_sb->s_op->destroy_inode)
+				inode->i_sb->s_op->destroy_inode(inode);
+			else
+				kmem_cache_free(inode_cachep, (inode));
+			return NULL;
+		}
+
 		spin_lock_init(&inode->i_lock);
 		lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -190,6 +200,7 @@ void destroy_inode(struct inode *inode) 
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	integrity_inode_free(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
Index: linux-2.6.26-rc8/include/linux/fs.h
===================================================================
--- linux-2.6.26-rc8.orig/include/linux/fs.h
+++ linux-2.6.26-rc8/include/linux/fs.h
@@ -653,6 +653,9 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+#ifdef CONFIG_INTEGRITY
+	void			*i_integrity;
+#endif
 	void			*i_private; /* fs or device private pointer */
 };
 
Index: linux-2.6.26-rc8/include/linux/audit.h
===================================================================
--- linux-2.6.26-rc8.orig/include/linux/audit.h
+++ linux-2.6.26-rc8/include/linux/audit.h
@@ -123,6 +123,11 @@
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
+#define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
+#define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
+#define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
+#define AUDIT_INTEGRITY_HASH	    1803 /* Integrity HASH type */
+#define AUDIT_INTEGRITY_PCR	    1804 /* PCR invalidation msgs */
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
@@ -441,6 +446,8 @@ extern int  audit_set_loginuid(struct ta
 #define audit_get_loginuid(t) ((t)->loginuid)
 #define audit_get_sessionid(t) ((t)->sessionid)
 extern void audit_log_task_context(struct audit_buffer *ab);
+extern void audit_log_inode_context(struct audit_buffer *ab,
+					struct inode *inode);
 extern int __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
 extern int audit_bprm(struct linux_binprm *bprm);
@@ -521,6 +528,7 @@ extern int audit_signals;
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
 #define audit_log_task_context(b) do { ; } while (0)
+#define audit_log_inode_context(b, a) do {  } while (0)
 #define audit_ipc_obj(i) ({ 0; })
 #define audit_ipc_set_perm(q,u,g,m) ({ 0; })
 #define audit_bprm(p) ({ 0; })
Index: linux-2.6.26-rc8/security/integrity/integrity_audit.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/security/integrity/integrity_audit.c
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
+static int integrity_audit = 1;
+
+#ifdef CONFIG_INTEGRITY_AUDIT
+static int __init integrity_audit_setup(char *str)
+{
+	ulong audit;
+	int rc;
+	char *op;
+
+	rc = strict_strtoul(str, 10, &audit);
+	if (rc < 0 || audit > 1)
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
+	if (!integrity_audit && result == 1)
+		return;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
+			 current->pid, current->uid,
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
Index: linux-2.6.26-rc8/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.26-rc8.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.26-rc8/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
+	INTEGRITY Integrity support is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
 	ISAPNP	ISA PnP code is enabled.
@@ -821,6 +822,11 @@ and is between 256 and 4096 characters. 
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
 			Format: <irq>
 
+	integrity_audit= [INTEGRITY]
+                        Format: { "0" | "1" }
+                        0 -- disable integrity auditing messages.
+                        1 -- enable integrity auditing messages. (Default)
+
 	inttest=	[IA64]
 
 	iommu=		[x86]
Index: linux-2.6.26-rc8/security/integrity/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/security/integrity/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the kernel integrity code
+#
+
+# Object file lists
+obj-$(CONFIG_INTEGRITY)			+= integrity.o integrity_audit.o
Index: linux-2.6.26-rc8/security/integrity/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.26-rc8/security/integrity/Kconfig
@@ -0,0 +1,24 @@
+#
+# Integrity configuration
+#
+
+menu "Integrity options"
+
+config INTEGRITY
+	bool "Enable different integrity models"
+	help
+	  This allows you to choose different integrity modules to be
+	  configured into your kernel.
+
+	  If you are unsure how to answer this question, answer N.
+
+config INTEGRITY_AUDIT
+	bool "Integrity audit boot parameter"
+	depends on INTEGRITY
+	default y
+	help
+	  This option adds a kernel parameter 'integrity_audit', which
+	  allows integrity auditing to be disabled at boot.  If this
+	  option is selected, integrity auditing can be disabled with
+	  'integrity_audit=0' on the kernel command line.
+endmenu
Index: linux-2.6.26-rc8/security/Kconfig
===================================================================
--- linux-2.6.26-rc8.orig/security/Kconfig
+++ linux-2.6.26-rc8/security/Kconfig
@@ -4,6 +4,8 @@
 
 menu "Security options"
 
+source security/integrity/Kconfig
+
 config KEYS
 	bool "Enable access key retention support"
 	help
Index: linux-2.6.26-rc8/fs/exec.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/exec.c
+++ linux-2.6.26-rc8/fs/exec.c
@@ -46,6 +46,7 @@
 #include <linux/ptrace.h>
 #include <linux/mount.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/rmap.h>
 #include <linux/tsacct_kern.h>
@@ -1197,6 +1198,9 @@ int search_binary_handler(struct linux_b
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
+	retval = integrity_bprm_check(bprm);
+	if (retval)
+		return retval;
 
 	/* kernel module loader fixup */
 	/* so we don't try to load run modprobe in kernel space. */
Index: linux-2.6.26-rc8/fs/namei.c
===================================================================
--- linux-2.6.26-rc8.orig/fs/namei.c
+++ linux-2.6.26-rc8/fs/namei.c
@@ -24,6 +24,7 @@
 #include <linux/fsnotify.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
 #include <linux/audit.h>
@@ -286,7 +287,10 @@ int permission(struct inode *inode, int 
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask, nd);
+	retval = security_inode_permission(inode, mask, nd);
+	if (retval)
+		return retval;
+	return integrity_inode_permission(inode, mask, nd);
 }
 
 /**
@@ -462,6 +466,7 @@ static struct dentry * cached_lookup(str
 static int exec_permission_lite(struct inode *inode,
 				       struct nameidata *nd)
 {
+	int retval;
 	umode_t	mode = inode->i_mode;
 
 	if (inode->i_op && inode->i_op->permission)
@@ -486,7 +491,10 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC, nd);
+	retval =  security_inode_permission(inode, MAY_EXEC, nd);
+	if (retval)
+		return retval;
+	return integrity_inode_permission(inode, MAY_EXEC, nd);
 }
 
 /*
Index: linux-2.6.26-rc8/mm/mmap.c
===================================================================
--- linux-2.6.26-rc8.orig/mm/mmap.c
+++ linux-2.6.26-rc8/mm/mmap.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/personality.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/hugetlb.h>
 #include <linux/profile.h>
 #include <linux/module.h>
@@ -1042,6 +1043,9 @@ unsigned long do_mmap_pgoff(struct file 
 	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
+	error = integrity_file_mmap(file, reqprot, prot, flags, addr, 0);
+	if (error)
+		return error;
 
 	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
 			   accountable);
Index: linux-2.6.26-rc8/security/Makefile
===================================================================
--- linux-2.6.26-rc8.orig/security/Makefile
+++ linux-2.6.26-rc8/security/Makefile
@@ -19,3 +19,7 @@ obj-$(CONFIG_SECURITY_SMACK)		+= commonc
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+
+# Object integrity file lists
+subdir-$(CONFIG_INTEGRITY)		+= integrity
+obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o


