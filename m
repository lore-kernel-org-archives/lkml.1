Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZIUMsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZIUMsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZIUMsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:48:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43037 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZIUMsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:48:53 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu, agruen@suse.de,
       hch@lst.de, hugh.dickins@tiscali.co.uk, matthew@wil.cx
Subject: [PATCH 1/2] vfs: seq_file: add helpers for data filling
Message-Id: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Sep 2009 14:48:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add two helpers that allow access to the seq_file's own buffer, but
hide the internal details of seq_files.

This allows easier implementation of special purpose filling
functions.  It also cleans up some existing functions which duplicated
the seq_file logic.

Make these inline functions in seq_file.h, as suggested by Al.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 fs/seq_file.c            |   74 ++++++++++++++++++++++++-----------------------
 include/linux/seq_file.h |   38 ++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c	2009-09-09 13:29:21.000000000 +0200
+++ linux-2.6/fs/seq_file.c	2009-09-21 14:17:10.000000000 +0200
@@ -429,20 +429,21 @@ EXPORT_SYMBOL(mangle_path);
  */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
-		char *p = d_path(path, s, m->size - m->count);
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path(path, buf, size);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return s - p;
-			}
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
 		}
 	}
-	m->count = m->size;
-	return -1;
+	seq_commit(m, res);
+
+	return res;
 }
 EXPORT_SYMBOL(seq_path);
 
@@ -454,26 +455,28 @@ EXPORT_SYMBOL(seq_path);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc)
 {
-	int err = -ENAMETOOLONG;
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -ENAMETOOLONG;
+
+	if (size) {
 		char *p;
 
 		spin_lock(&dcache_lock);
-		p = __d_path(path, root, s, m->size - m->count);
+		p = __d_path(path, root, buf, size);
 		spin_unlock(&dcache_lock);
-		err = PTR_ERR(p);
+		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return 0;
-			}
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+			else
+				res = -ENAMETOOLONG;
 		}
 	}
-	m->count = m->size;
-	return err;
+	seq_commit(m, res);
+
+	return res < 0 ? res : 0;
 }
 
 /*
@@ -481,20 +484,21 @@ int seq_path_root(struct seq_file *m, st
  */
 int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 {
-	if (m->count < m->size) {
-		char *s = m->buf + m->count;
-		char *p = dentry_path(dentry, s, m->size - m->count);
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = dentry_path(dentry, buf, size);
 		if (!IS_ERR(p)) {
-			s = mangle_path(s, p, esc);
-			if (s) {
-				p = m->buf + m->count;
-				m->count = s - m->buf;
-				return s - p;
-			}
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
 		}
 	}
-	m->count = m->size;
-	return -1;
+	seq_commit(m, res);
+
+	return res;
 }
 
 int seq_bitmap(struct seq_file *m, const unsigned long *bits,
Index: linux-2.6/include/linux/seq_file.h
===================================================================
--- linux-2.6.orig/include/linux/seq_file.h	2009-09-09 13:29:21.000000000 +0200
+++ linux-2.6/include/linux/seq_file.h	2009-09-21 14:15:40.000000000 +0200
@@ -35,6 +35,44 @@ struct seq_operations {
 
 #define SEQ_SKIP 1
 
+/**
+ * seq_get_buf - get buffer to write arbitrary data to
+ * @m: the seq_file handle
+ * @bufp: the beginning of the buffer is stored here
+ *
+ * Return the number of bytes available in the buffer, or zero if
+ * there's no space.
+ */
+static inline size_t seq_get_buf(struct seq_file *m, char **bufp)
+{
+	BUG_ON(m->count > m->size);
+	if (m->count < m->size)
+		*bufp = m->buf + m->count;
+	else
+		*bufp = NULL;
+
+	return m->size - m->count;
+}
+
+/**
+ * seq_commit - commit data to the buffer
+ * @m: the seq_file handle
+ * @num: the number of bytes to commit
+ *
+ * Commit @num bytes of data written to a buffer previously acquired
+ * by seq_buf_get.  To signal an error condition, or that the data
+ * didn't fit in the available space, pass a negative @num value.
+ */
+static inline void seq_commit(struct seq_file *m, int num)
+{
+	if (num < 0) {
+		m->count = m->size;
+	} else {
+		BUG_ON(m->count + num > m->size);
+		m->count += num;
+	}
+}
+
 char *mangle_path(char *s, char *p, char *esc);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
