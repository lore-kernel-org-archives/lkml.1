Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYBDJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYBDJRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYBDJRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:17:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54959 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYBDJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:17:03 -0500
Subject: [RFC PATCH] vfs: optimization to /proc/<pid>/mountinfo patch
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       a.p.zijlstra@chello.nl
In-Reply-To: <1201805123.10358.23.camel@ram.us.ibm.com>
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
	 <20080130160839.828c4363.akpm@linux-foundation.org>
	 <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
	 <1201805123.10358.23.camel@ram.us.ibm.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 01:15:05 -0800
Message-Id: <1202116505.3949.91.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) reports deleted inode in dentry_path() consistent with that in __d_path()
2) modified __d_path() to use prepend(), reducing the size of __d_path()
3) moved all the functionality that reports mount information in /proc under
	CONFIG_PROC_FS.

Could not verify if the code would work with CONFIG_PROC_FS=n, since it was
impossible to disable CONFIG_PROC_FS. Looking for ideas on how to disable
CONFIG_PROC_FS.
	


Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 fs/dcache.c              |   59 +++++++++++++++++++----------------------------
 fs/namespace.c           |    2 +
 fs/seq_file.c            |    2 +
 include/linux/dcache.h   |    3 ++
 include/linux/seq_file.h |    3 ++
 5 files changed, 34 insertions(+), 35 deletions(-)

Index: linux-2.6.23/fs/dcache.c
===================================================================
--- linux-2.6.23.orig/fs/dcache.c
+++ linux-2.6.23/fs/dcache.c
@@ -1747,6 +1747,17 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
+static int prepend(char **buffer, int *buflen, const char *str,
+			  int namelen)
+{
+	*buflen -= namelen;
+	if (*buflen < 0)
+		return 1;
+	*buffer -= namelen;
+	memcpy(*buffer, str, namelen);
+	return 0;
+}
+
 /**
  * d_path - return the path of a dentry
  * @dentry: dentry to report
@@ -1768,17 +1779,11 @@ static char *__d_path(struct dentry *den
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
+		prepend(&end, &buflen, " (deleted)", 10))
 			goto Elong;
-		memcpy(end, " (deleted)", 10);
-	}
 
 	if (buflen < 1)
 		goto Elong;
@@ -1805,13 +1810,10 @@ static char *__d_path(struct dentry *den
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		namelen = dentry->d_name.len;
-		buflen -= namelen + 1;
-		if (buflen < 0)
+		if (prepend(&end, &buflen, dentry->d_name.name,
+				dentry->d_name.len) ||
+		    prepend(&end, &buflen, "/", 1))
 			goto Elong;
-		end -= namelen;
-		memcpy(end, dentry->d_name.name, namelen);
-		*--end = '/';
 		retval = end;
 		dentry = parent;
 	}
@@ -1819,12 +1821,9 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
-	namelen = dentry->d_name.len;
-	buflen -= namelen;
-	if (buflen < 0)
-		goto Elong;
-	retval -= namelen-1;	/* hit the slash */
-	memcpy(retval, dentry->d_name.name, namelen);
+	retval += 1;	/* hit the slash */
+	if (prepend(&retval, &buflen, dentry->d_name.name, dentry->d_name.len))
+			goto Elong;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1890,17 +1889,8 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
-static int prepend(char **buffer, int *buflen, const char *str,
-			  int namelen)
-{
-	*buflen -= namelen;
-	if (*buflen < 0)
-		return 1;
-	*buffer -= namelen;
-	memcpy(*buffer, str, namelen);
-	return 0;
-}
 
+#ifdef CONFIG_PROC_FS
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
@@ -1910,11 +1900,9 @@ char *dentry_path(struct dentry *dentry,
 	char *retval;
 
 	spin_lock(&dcache_lock);
-	prepend(&end, &buflen, "\0", 1);
-	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
-		if (prepend(&end, &buflen, "//deleted", 9))
+	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
+		prepend(&end, &buflen, " (deleted)", 10))
 			goto Elong;
-	}
 	if (buflen < 1)
 		goto Elong;
 	/* Get '/' right */
@@ -1943,6 +1931,7 @@ Elong:
 	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
+#endif /* CONFIG_PROC_FS */
 
 /*
  * NOTE! The user-level library version returns a
Index: linux-2.6.23/fs/namespace.c
===================================================================
--- linux-2.6.23.orig/fs/namespace.c
+++ linux-2.6.23/fs/namespace.c
@@ -609,6 +609,7 @@ void mnt_unpin(struct vfsmount *mnt)
 
 EXPORT_SYMBOL(mnt_unpin);
 
+#ifdef CONFIG_PROC_FS
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
@@ -795,6 +796,7 @@ const struct seq_operations mountstats_o
 	.stop	= m_stop,
 	.show	= show_vfsstat,
 };
+#endif  /* CONFIG_PROC_FS */
 
 /**
  * may_umount_tree - check if a mount tree is busy
Index: linux-2.6.23/fs/seq_file.c
===================================================================
--- linux-2.6.23.orig/fs/seq_file.c
+++ linux-2.6.23/fs/seq_file.c
@@ -369,6 +369,7 @@ static char *mangle_path(char *s, char *
 	return NULL;
 }
 
+#ifdef CONFIG_PROC_FS
 /*
  * return the absolute path of 'dentry' residing in mount 'mnt'.
  */
@@ -390,6 +391,7 @@ int seq_path(struct seq_file *m, struct 
 	return -1;
 }
 EXPORT_SYMBOL(seq_path);
+#endif /* CONFIG_PROC_FS */
 
 /*
  * returns the path of the 'dentry' from the root of its filesystem.
Index: linux-2.6.23/include/linux/dcache.h
===================================================================
--- linux-2.6.23.orig/include/linux/dcache.h
+++ linux-2.6.23/include/linux/dcache.h
@@ -302,7 +302,10 @@ extern int d_validate(struct dentry *, s
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
 extern char *d_path(struct path *, char *, int);
+
+#ifdef CONFIG_PROC_FS
 extern char *dentry_path(struct dentry *, char *, int);
+#endif /* CONFIG_PROC_FS */
 
 /* Allocation counts.. */
 
Index: linux-2.6.23/include/linux/seq_file.h
===================================================================
--- linux-2.6.23.orig/include/linux/seq_file.h
+++ linux-2.6.23/include/linux/seq_file.h
@@ -44,7 +44,10 @@ int seq_printf(struct seq_file *, const 
 	__attribute__ ((format (printf,2,3)));
 
 int seq_path(struct seq_file *, struct path *, char *);
+
+#ifdef CONFIG_PROC_FS
 int seq_dentry(struct seq_file *, struct dentry *, char *);
+#endif /* CONFIG_PROC_FS */
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);


