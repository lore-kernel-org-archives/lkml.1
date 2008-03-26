Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbYCZVYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbYCZVYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759037AbYCZVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:22:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51795 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbYCZVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:22:08 -0400
Message-Id: <20080326212136.632431397@szeredi.hu>
References: <20080326211131.705321084@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 26 Mar 2008 22:11:32 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/7] vfs: mountinfo: add dentry_path()
Content-Disposition: inline; filename=mountinfo_dentry_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

[mszeredi@suse.cz] split big patch into managable chunks

Add the following functions:

  dentry_path()
  seq_dentry()

These are similar to d_path() and seq_path().  But instead of
calculating the path within a mount namespace, they calculate the path
from the root of the filesystem to a given dentry, ignoring mounts
completely.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c              |   88 ++++++++++++++++++++++++++++++++++-------------
 fs/seq_file.c            |   65 ++++++++++++++++++++++++++--------
 include/linux/dcache.h   |    1 
 include/linux/seq_file.h |    2 +
 4 files changed, 117 insertions(+), 39 deletions(-)

Index: vfs-2.6/fs/dcache.c
===================================================================
--- vfs-2.6.orig/fs/dcache.c	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/fs/dcache.c	2008-03-26 21:37:35.000000000 +0100
@@ -1746,6 +1746,17 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
 /**
  * d_path - return the path of a dentry
  * @dentry: dentry to report
@@ -1767,17 +1778,11 @@ static char *__d_path(struct dentry *den
 {
 	char * end = buffer+buflen;
 	char * retval;
-	int namelen;
 
-	*--end = '\0';
-	buflen--;
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		buflen -= 10;
-		end -= 10;
-		if (buflen < 0)
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, " (deleted)", 10) != 0))
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
-	}
 
 	if (buflen < 1)
 		goto Elong;
@@ -1804,13 +1809,10 @@ static char *__d_path(struct dentry *den
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
 		retval = end;
 		dentry = parent;
 	}
@@ -1818,12 +1820,10 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
-	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
+	retval += 1;	/* hit the slash */
+	if (prepend(&retval, &buflen, dentry->d_name.name,
+		    dentry->d_name.len) != 0)
 		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1859,7 +1859,7 @@ char *d_path(struct path *path, char *bu
 
 	read_lock(&current->fs->lock);
 	root = current->fs->root;
-	path_get(&current->fs->root);
+	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
 	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
@@ -1890,6 +1890,48 @@ char *dynamic_dname(struct dentry *dentr
 }
 
 /*
+ * Write full pathname from the root of the filesystem into the buffer.
+ */
+char *dentry_path(struct dentry *dentry, char *buf, int buflen)
+{
+	char *end = buf + buflen;
+	char *retval;
+
+	spin_lock(&dcache_lock);
+	prepend(&end, &buflen, "\0", 1);
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		(prepend(&end, &buflen, "//deleted", 9) != 0))
+			goto Elong;
+	if (buflen < 1)
+		goto Elong;
+	/* Get '/' right */
+	retval = end-1;
+	*retval = '/';
+
+	for (;;) {
+		struct dentry *parent;
+		if (IS_ROOT(dentry))
+			break;
+
+		parent = dentry->d_parent;
+		prefetch(parent);
+
+		if ((prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) != 0) ||
+		    (prepend(&end, &buflen, "/", 1) != 0))
+			goto Elong;
+
+		retval = end;
+		dentry = parent;
+	}
+	spin_unlock(&dcache_lock);
+	return retval;
+Elong:
+	spin_unlock(&dcache_lock);
+	return ERR_PTR(-ENAMETOOLONG);
+}
+
+/*
  * NOTE! The user-level library version returns a
  * character pointer. The kernel system call just
  * returns the length of the buffer filled (which
@@ -1918,9 +1960,9 @@ asmlinkage long sys_getcwd(char __user *
 
 	read_lock(&current->fs->lock);
 	pwd = current->fs->pwd;
-	path_get(&current->fs->pwd);
+	path_get(&pwd);
 	root = current->fs->root;
-	path_get(&current->fs->root);
+	path_get(&root);
 	read_unlock(&current->fs->lock);
 
 	error = -ENOENT;
Index: vfs-2.6/fs/seq_file.c
===================================================================
--- vfs-2.6.orig/fs/seq_file.c	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/fs/seq_file.c	2008-03-26 21:37:35.000000000 +0100
@@ -342,28 +342,40 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
+static char *mangle_path(char *s, char *p, char *esc)
+{
+	while (s <= p) {
+		char c = *p++;
+		if (!c) {
+			return s;
+		} else if (!strchr(esc, c)) {
+			*s++ = c;
+		} else if (s + 4 > p) {
+			break;
+		} else {
+			*s++ = '\\';
+			*s++ = '0' + ((c & 0300) >> 6);
+			*s++ = '0' + ((c & 070) >> 3);
+			*s++ = '0' + (c & 07);
+		}
+	}
+	return NULL;
+}
+
+/*
+ * return the absolute path of 'dentry' residing in mount 'mnt'.
+ */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
 		char *p = d_path(path, s, m->size - m->count);
 		if (!IS_ERR(p)) {
-			while (s <= p) {
-				char c = *p++;
-				if (!c) {
-					p = m->buf + m->count;
-					m->count = s - m->buf;
-					return s - p;
-				} else if (!strchr(esc, c)) {
-					*s++ = c;
-				} else if (s + 4 > p) {
-					break;
-				} else {
-					*s++ = '\\';
-					*s++ = '0' + ((c & 0300) >> 6);
-					*s++ = '0' + ((c & 070) >> 3);
-					*s++ = '0' + (c & 07);
-				}
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
 			}
 		}
 	}
@@ -372,6 +384,27 @@ int seq_path(struct seq_file *m, struct 
 }
 EXPORT_SYMBOL(seq_path);
 
+/*
+ * returns the path of the 'dentry' from the root of its filesystem.
+ */
+int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
+{
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p = dentry_path(dentry, s, m->size - m->count);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return s - p;
+			}
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
Index: vfs-2.6/include/linux/dcache.h
===================================================================
--- vfs-2.6.orig/include/linux/dcache.h	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/include/linux/dcache.h	2008-03-26 21:37:35.000000000 +0100
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
 
Index: vfs-2.6/include/linux/seq_file.h
===================================================================
--- vfs-2.6.orig/include/linux/seq_file.h	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/include/linux/seq_file.h	2008-03-26 21:37:35.000000000 +0100
@@ -10,6 +10,7 @@ struct seq_operations;
 struct file;
 struct path;
 struct inode;
+struct dentry;
 
 struct seq_file {
 	char *buf;
@@ -42,6 +43,7 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+int seq_dentry(struct seq_file *, struct dentry *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);

--
