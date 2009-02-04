Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZBDOUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZBDOUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZBDOTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:32 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49553 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBDOTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:30 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3/7] integrity: IMA display
Date: Wed,  4 Feb 2009 09:06:59 -0500
Message-Id: <77c9d760b2fffbb341d82150a70f523afe57d568.1233750616.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the measurement lists available through securityfs.
- removed test for NULL return code from securityfs_create_file/dir

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 9d6bf97..787c4cb 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_IMA) += ima.o
 
-ima-y := ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
+ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_iint.o ima_audit.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index bfa72ed..9c280cc 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -67,6 +67,9 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 /* Internal IMA function definitions */
 void ima_iintcache_init(void);
 int ima_init(void);
+void ima_cleanup(void);
+int ima_fs_init(void);
+void ima_fs_cleanup(void);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode);
 int ima_calc_hash(struct file *file, char *digest);
@@ -115,6 +118,8 @@ void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode);
+void ima_template_show(struct seq_file *m, void *e,
+		       enum ima_show_type show);
 
 /* radix tree calls to lookup, insert, delete
  * integrity data associated with an inode.
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
new file mode 100644
index 0000000..4f25be7
--- /dev/null
+++ b/security/integrity/ima/ima_fs.c
@@ -0,0 +1,296 @@
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
+	loff_t l = *pos;
+	struct ima_queue_entry *qe;
+
+	/* we need a lock since pos could point beyond last element */
+	rcu_read_lock();
+	list_for_each_entry_rcu(qe, &ima_measurements, later) {
+		if (!l--) {
+			rcu_read_unlock();
+			return qe;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+static void *ima_measurements_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct ima_queue_entry *qe = v;
+
+	/* lock protects when reading beyond last element
+	 * against concurrent list-extension
+	 */
+	rcu_read_lock();
+	qe = list_entry(rcu_dereference(qe->later.next),
+			struct ima_queue_entry, later);
+	rcu_read_unlock();
+	(*pos)++;
+
+	return (&qe->later == &ima_measurements) ? NULL : qe;
+}
+
+static void ima_measurements_stop(struct seq_file *m, void *v)
+{
+}
+
+static void ima_putc(struct seq_file *m, void *data, int datalen)
+{
+	while (datalen--)
+		seq_putc(m, *(char *)data++);
+}
+
+/* print format:
+ *       32bit-le=pcr#
+ *       char[20]=template digest
+ *       32bit-le=template name size
+ *       char[n]=template name
+ *       eventdata[n]=template specific data
+ */
+static int ima_measurements_show(struct seq_file *m, void *v)
+{
+	/* the list never shrinks, so we don't need a lock here */
+	struct ima_queue_entry *qe = v;
+	struct ima_template_entry *e;
+	int namelen;
+	u32 pcr = CONFIG_IMA_MEASURE_PCR_IDX;
+
+	/* get entry */
+	e = qe->entry;
+	if (e == NULL)
+		return -1;
+
+	/*
+	 * 1st: PCRIndex
+	 * PCR used is always the same (config option) in
+	 * little-endian format
+	 */
+	ima_putc(m, &pcr, sizeof pcr);
+
+	/* 2nd: template digest */
+	ima_putc(m, e->digest, IMA_DIGEST_SIZE);
+
+	/* 3rd: template name size */
+	namelen = strlen(e->template_name);
+	ima_putc(m, &namelen, sizeof namelen);
+
+	/* 4th:  template name */
+	ima_putc(m, e->template_name, namelen);
+
+	/* 5th:  template specific data */
+	ima_template_show(m, (struct ima_template_data *)&e->template,
+			  IMA_SHOW_BINARY);
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
+static void ima_print_digest(struct seq_file *m, u8 *digest)
+{
+	int i;
+
+	for (i = 0; i < IMA_DIGEST_SIZE; i++)
+		seq_printf(m, "%02x", *(digest + i));
+}
+
+void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show)
+{
+	struct ima_template_data *entry = e;
+	int namelen;
+
+	switch (show) {
+	case IMA_SHOW_ASCII:
+		ima_print_digest(m, entry->digest);
+		seq_printf(m, " %s\n", entry->file_name);
+		break;
+	case IMA_SHOW_BINARY:
+		ima_putc(m, entry->digest, IMA_DIGEST_SIZE);
+
+		namelen = strlen(entry->file_name);
+		ima_putc(m, &namelen, sizeof namelen);
+		ima_putc(m, entry->file_name, namelen);
+	default:
+		break;
+	}
+}
+
+/* print in ascii */
+static int ima_ascii_measurements_show(struct seq_file *m, void *v)
+{
+	/* the list never shrinks, so we don't need a lock here */
+	struct ima_queue_entry *qe = v;
+	struct ima_template_entry *e;
+
+	/* get entry */
+	e = qe->entry;
+	if (e == NULL)
+		return -1;
+
+	/* 1st: PCR used (config option) */
+	seq_printf(m, "%2d ", CONFIG_IMA_MEASURE_PCR_IDX);
+
+	/* 2nd: SHA1 template hash */
+	ima_print_digest(m, e->digest);
+
+	/* 3th:  template name */
+	seq_printf(m, " %s ", e->template_name);
+
+	/* 4th:  template specific data */
+	ima_template_show(m, (struct ima_template_data *)&e->template,
+			  IMA_SHOW_ASCII);
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
+	if (IS_ERR(ima_dir))
+		return -1;
+
+	binary_runtime_measurements =
+	    securityfs_create_file("binary_runtime_measurements",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_measurements_ops);
+	if (IS_ERR(binary_runtime_measurements))
+		goto out;
+
+	ascii_runtime_measurements =
+	    securityfs_create_file("ascii_runtime_measurements",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_ascii_measurements_ops);
+	if (IS_ERR(ascii_runtime_measurements))
+		goto out;
+
+	runtime_measurements_count =
+	    securityfs_create_file("runtime_measurements_count",
+				   S_IRUSR | S_IRGRP, ima_dir, NULL,
+				   &ima_measurements_count_ops);
+	if (IS_ERR(runtime_measurements_count))
+		goto out;
+
+	violations =
+	    securityfs_create_file("violations", S_IRUSR | S_IRGRP,
+				   ima_dir, NULL, &ima_htable_violations_ops);
+	if (IS_ERR(violations))
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
index e0f02e3..cf227db 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -86,5 +86,11 @@ int ima_init(void)
 
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
index 53cee4c..871e356 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -274,6 +274,11 @@ static int __init init_ima(void)
 	return error;
 }
 
+static void __exit cleanup_ima(void)
+{
+	ima_cleanup();
+}
+
 late_initcall(init_ima);	/* Start IMA after the TPM is available */
 
 MODULE_DESCRIPTION("Integrity Measurement Architecture");
-- 
1.5.6.6

