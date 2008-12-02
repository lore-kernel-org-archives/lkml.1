Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYLBVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYLBVte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYLBVs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:48:29 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49542 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYLBVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:48:25 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 4/6] integrity: IMA display
Date: Tue,  2 Dec 2008 16:47:58 -0500
Message-Id: <4a75fc985dc650c405238d31e40608456895f53d.1228253619.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the measurement lists available through securityfs.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index d9d4405..959ae66 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_IMA) += ima.o
 
-ima-y := ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
+ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_iint.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index b727a5e..795b552 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -64,6 +64,9 @@ extern const struct template_operations ima_template_ops;
 
 /* Internal IMA function definitions */
 int ima_init(void);
+void ima_cleanup(void);
+int ima_fs_init(void);
+void ima_fs_cleanup(void);
 void ima_create_htable(void);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation);
 int ima_calc_hash(struct file *file, char *digest);
@@ -117,6 +120,8 @@ int ima_collect_measurement(void *d);
 int ima_appraise_measurement(void *d);
 void ima_store_measurement(void *d);
 int ima_store_template(void *d);
+void ima_template_show(struct seq_file *m, void *e,
+		       enum integrity_show_type show);
 
 /* For use with ima_must_measure() */
 struct ima_measure_data {
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 83ab012..f2b53c7 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -21,6 +21,7 @@ const struct template_operations ima_template_ops = {
 	.collect_measurement = ima_collect_measurement,
 	.store_measurement = ima_store_measurement,
 	.store_template = ima_store_template,
+	.display_template = ima_template_show
 };
 
 /**
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
new file mode 100644
index 0000000..2627e56
--- /dev/null
+++ b/security/integrity/ima/ima_fs.c
@@ -0,0 +1,339 @@
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
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+
+#include "../integrity.h"
+#include "ima.h"
+
+#define TMPBUFLEN 12
+static ssize_t ima_show_htable_value(char __user *buf, size_t count,
+				     loff_t *ppos, atomic_long_t *val)
+{
+	char tmpbuf[TMPBUFLEN];
+	ssize_t len;
+
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read(val));
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
+	__list_for_each_rcu(lpos, &ima_measurements) {
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
+	struct ima_template_entry *e;
+	struct ima_inode_measure_entry *entry;
+	struct template_list_entry *template_entry;
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
+	template_entry = integrity_find_get_template(e->template_name);
+	if (template_entry) {
+		const struct template_operations *ops;
+
+		ops = template_entry->template_ops;
+		ops->display_template(m, entry, INTEGRITY_SHOW_BINARY);
+		kref_put(&template_entry->refcount, template_release);
+	} else
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
+	for (i = 0; i < 20; i++) {
+		switch (show) {
+		case INTEGRITY_SHOW_ASCII:
+			seq_printf(m, "%02x", entry->digest[i]);
+			break;
+		case INTEGRITY_SHOW_BINARY:
+			seq_putc(m, entry->digest[i]);
+		default:
+			break;
+		}
+	}
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
+	struct ima_template_entry *e;
+	struct ima_inode_measure_entry *entry;
+	struct template_list_entry *template_entry;
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
+	template_entry = integrity_find_get_template(e->template_name);
+	if (template_entry) {
+		const struct template_operations *ops;
+
+		ops = template_entry->template_ops;
+		ops->display_template(m, entry, INTEGRITY_SHOW_ASCII);
+		kref_put(&template_entry->refcount, template_release);
+	} else
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
+static struct dentry *ima_dir;
+static struct dentry *binary_runtime_measurements;
+static struct dentry *ascii_runtime_measurements;
+static struct dentry *runtime_measurements_count;
+static struct dentry *violations;
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
+	return 0;
+
+out:
+	securityfs_remove(runtime_measurements_count);
+	securityfs_remove(ascii_runtime_measurements);
+	securityfs_remove(binary_runtime_measurements);
+	securityfs_remove(ima_dir);
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
+}
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 374b368..de78f93 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -86,5 +86,11 @@ int ima_init(void)
 	ima_create_htable();	/* for measurements */
 	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	ima_init_policy();
-	return 0;
+
+	return ima_fs_init();
+}
+
+void __exit ima_cleanup(void)
+{
+	ima_fs_cleanup();
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2dcc3b5..8672f86 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -265,6 +265,7 @@ static void __exit cleanup_ima(void)
 {
 	integrity_unregister_template("ima");
 	unregister_integrity(&ima_integrity_ops);
+	ima_cleanup();
 }
 
 late_initcall(init_ima);	/* Start IMA after the TPM is available */
-- 
1.5.6.5

