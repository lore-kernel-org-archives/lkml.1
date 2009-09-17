Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZIQRQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZIQRQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZIQRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:16:45 -0400
Received: from verein.lst.de ([213.95.11.210]:59492 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZIQRQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:16:44 -0400
Date: Thu, 17 Sep 2009 19:16:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, kyle@mcmartin.ca,
       sct@redhat.com
Subject: Re: [PATCH] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090917171617.GB858@lst.de>
References: <20090915131252.GA13754@lst.de> <4AAFA9BC.1000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAFA9BC.1000409@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, a little update on O_RSYNC:  I have a patch that should work,
but surprisingly enough it doesn't.  Seem like the O_ flags grew too
large and somewhere in the middle they get truncated off.  Here's what I
have so far:

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-09-15 00:06:09.737003454 -0300
+++ linux-2.6/fs/splice.c	2009-09-15 00:08:23.669254032 -0300
@@ -501,6 +501,10 @@ ssize_t generic_file_splice_read(struct 
 	if (unlikely(left < len))
 		len = left;
 
+	ret = generic_read_sync(in, *ppos, len);
+	if (ret)
+		return ret;
+
 	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
 	if (ret > 0) {
 		*ppos += ret;
Index: linux-2.6/fs/sync.c
===================================================================
--- linux-2.6.orig/fs/sync.c	2009-09-15 00:08:23.180271144 -0300
+++ linux-2.6/fs/sync.c	2009-09-15 00:28:41.359031442 -0300
@@ -295,6 +295,33 @@ int generic_write_sync(struct file *file
 }
 EXPORT_SYMBOL(generic_write_sync);
 
+/**
+ * generic_read_sync - perform syncing befor
+ * @file:	file to which the read happens
+ * @pos:	offset where the read starts
+ * @count:	length of the read
+ *
+ * This implements the O_RSYNC semantics:
+ *   O_RSYNC on its own just means the data is successfully transferred to
+ *   the calling process (always the case).
+ *
+ *   O_RSYNC|O_DSYNC means that if a read request hits data that is currently
+ *   in a cache and not yet on the medium, then the write to medium is
+ *   successful before the read succeeds.
+ *
+ *   O_RSYNC|O_SYNC means the same plus the integrity of file meta information
+ *   (access time etc).
+ */
+int generic_read_sync(struct file *file, loff_t pos, loff_t count)
+{
+	if (((file->f_flags & (O_RSYNC|O_DSYNC)) != (O_RSYNC|O_DSYNC)))
+		return 0;
+	return vfs_fsync_range(file, file->f_path.dentry, pos,
+			       pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
+}
+EXPORT_SYMBOL(generic_read_sync);
+
 /*
  * sys_sync_file_range() permits finely controlled syncing over a segment of
  * a file in the range offset .. (offset+nbytes-1) inclusive.  If nbytes is
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h	2009-09-15 00:08:23.162254189 -0300
+++ linux-2.6/include/asm-generic/fcntl.h	2009-09-15 00:08:23.672254134 -0300
@@ -68,6 +68,10 @@
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 #endif
 
+#ifndef O_RSYNC
+#define O_RSYNC		010000000
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-09-15 00:06:09.758004312 -0300
+++ linux-2.6/include/linux/fs.h	2009-09-15 00:08:23.673254191 -0300
@@ -2097,6 +2097,7 @@ extern int vfs_fsync_range(struct file *
 			   loff_t start, loff_t end, int datasync);
 extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern int generic_write_sync(struct file *file, loff_t pos, loff_t count);
+extern int generic_read_sync(struct file *file, loff_t pos, loff_t count);
 extern void sync_supers(void);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2009-09-15 00:06:09.764004377 -0300
+++ linux-2.6/mm/filemap.c	2009-09-15 00:08:23.676300248 -0300
@@ -1285,6 +1285,10 @@ generic_file_aio_read(struct kiocb *iocb
 	if (retval)
 		return retval;
 
+	retval = generic_read_sync(filp, pos, count);
+	if (retval)
+		return retval;
+
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
Index: linux-2.6/arch/alpha/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/fcntl.h	2009-09-15 00:08:23.169254241 -0300
+++ linux-2.6/arch/alpha/include/asm/fcntl.h	2009-09-15 00:08:23.678253988 -0300
@@ -30,6 +30,7 @@
  */
 #define __O_SYNC	020000000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
+#define O_RSYNC		040000000
 
 #define F_GETLK		7
 #define F_SETLK		8
Index: linux-2.6/arch/mips/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/fcntl.h	2009-09-15 00:08:23.172253854 -0300
+++ linux-2.6/arch/mips/include/asm/fcntl.h	2009-09-15 00:08:23.678253988 -0300
@@ -34,6 +34,7 @@
 #define __O_SYNC	0x4000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 #define O_DIRECT	0x8000	/* direct disk access hint */
+#define O_DSYNC		0x10000
 
 #define F_GETLK		14
 #define F_SETLK		6
Index: linux-2.6/arch/parisc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/fcntl.h	2009-09-15 00:08:23.178298896 -0300
+++ linux-2.6/arch/parisc/include/asm/fcntl.h	2009-09-15 00:08:23.680301735 -0300
@@ -14,6 +14,7 @@
 #define O_RSYNC		002000000 /* HPUX only */
 #define O_NOATIME	004000000
 #define O_CLOEXEC	010000000 /* set close_on_exec */
+#define O_RSYNC		020000000
 
 #define O_DIRECTORY	000010000 /* must be a directory */
 #define O_NOFOLLOW	000000200 /* don't follow links */
Index: linux-2.6/arch/sparc/include/asm/fcntl.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/fcntl.h	2009-09-15 00:08:23.179254674 -0300
+++ linux-2.6/arch/sparc/include/asm/fcntl.h	2009-09-15 00:08:23.681254370 -0300
@@ -33,6 +33,7 @@
  */
 #define __O_SYNC	0x800000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
+#define O_RSYNC		0x1000000
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
