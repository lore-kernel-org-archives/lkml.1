Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZIGIi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZIGIi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZIGIiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:38:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56527 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZIGIiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:38:55 -0400
To: akpm@linux-foundation.org
CC: Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, miklos@szeredi.hu,
       akpm@linux-foundation.org, matthew@wil.cx, agruen@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, linux-kernel@vger.kernel.org
Subject: [patch 1/2] vfs: seq_file: add helpers for data filling
References: <2818.1252160549@turing-police.cc.vt.edu> <1252312254.4733.12.camel@tucsk>
Message-Id: <E1MkZk0-00006N-So@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 10:38:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add two helpers that allow access to the seq_file's own buffer, but
hides the internal details of seq_files.

This allows easier implementation of special purpose filling
functions.  It also cleans up some existing functions which duplicated
the seq_file logic.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/seq_file.c            |  112 ++++++++++++++++++++++++++++++++---------------
 include/linux/seq_file.h |    3 +
 2 files changed, 80 insertions(+), 35 deletions(-)

Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c	2009-09-03 19:40:10.000000000 +0200
+++ linux-2.6/fs/seq_file.c	2009-09-04 14:58:04.000000000 +0200
@@ -419,6 +419,44 @@ char *mangle_path(char *s, char *p, char
 EXPORT_SYMBOL(mangle_path);
 
 /**
+ * seq_get_buf - get buffer to write arbitrary data to
+ * @m: the seq_file handle
+ * @bufp: the beginning of the buffer is stored here
+ *
+ * Return the number of bytes available in the buffer, or zero if
+ * there's no space.
+ */
+size_t seq_get_buf(struct seq_file *m, char **bufp)
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
+void seq_commit(struct seq_file *m, int num)
+{
+	if (num < 0) {
+		m->count = m->size;
+	} else {
+		BUG_ON(m->count + num > m->size);
+		m->count += num;
+	}
+}
+
+/**
  * seq_path - seq_file interface to print a pathname
  * @m: the seq_file handle
  * @path: the struct path to print
@@ -429,20 +467,21 @@ EXPORT_SYMBOL(mangle_path);
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
 
@@ -454,26 +493,28 @@ EXPORT_SYMBOL(seq_path);
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
@@ -481,20 +522,21 @@ int seq_path_root(struct seq_file *m, st
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
--- linux-2.6.orig/include/linux/seq_file.h	2009-09-04 13:17:03.000000000 +0200
+++ linux-2.6/include/linux/seq_file.h	2009-09-04 14:26:49.000000000 +0200
@@ -48,6 +48,9 @@ int seq_write(struct seq_file *seq, cons
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
 
+size_t seq_get_buf(struct seq_file *m, char **bufp);
+void seq_commit(struct seq_file *m, int num);
+
 int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
