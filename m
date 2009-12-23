Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZLWJqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZLWJqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZLWJqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:46:06 -0500
Received: from smtp21.orange.fr ([80.12.242.46]:27454 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZLWJqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:46:02 -0500
X-ME-UUID: 20091223094530580.8D89420010FD@mwinf2128.orange.fr
X-ME-User-Auth: jean-pierre.andre
Message-ID: <4B31E63D.5040202@wanadoo.fr>
Date: Wed, 23 Dec 2009 10:43:25 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4) Gecko/20091027 Fedora/2.0-7.fc13 SeaMonkey/2.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr> <87my1aevro.fsf@devron.myhome.or.jp>
In-Reply-To: <87my1aevro.fsf@devron.myhome.or.jp>
Content-Type: multipart/mixed;
 boundary="------------080702050200070508050205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080702050200070508050205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

OGAWA Hirofumi wrote:
>> I suggest I port Miklos patch to fuse-lite soon,
>> and delay the low-level case (and microsecond
>> precision) until January. Does that suit your needs ?
>>      
> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
> bug report on lkml to others. Eric?

Attached is a proposed patch for selective update
of timestamps in ntfs-3g (based on the release
candidate version ntfs-3g-2009.11.14AC.2).

It includes the backport of Miklos's patch posted
yesterday to fuse-lite. As a matter of fact fuse-lite
is needed, because I do not know how to make this
compile with unpatched fuse.

Note : this does not yet include  sub-second precision.

Regards

Jean-Pierre




--------------080702050200070508050205
Content-Type: text/plain;
 name="utimensat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="utimensat.patch"

--- ntfs-3g-2009.11.14AC.2/configure.ac	2009-12-16 08:33:26.000000000 +0100
+++ ntfslow/ntfs-3g/configure.ac	2009-12-23 10:24:29.000000000 +0100
@@ -314,7 +314,7 @@
 	atexit basename daemon dup2 fdatasync ffs getopt_long hasmntopt \
 	mbsinit memmove memset realpath regcomp setlocale setxattr \
 	strcasecmp strchr strdup strerror strnlen strsep strtol strtoul \
-	sysconf utime fork \
+	sysconf utime utimensat fork \
 ])
 AC_SYS_LARGEFILE
 
--- ntfs-3g-2009.11.14AC.2/include/fuse-lite/fuse.h	2009-07-30 15:11:50.000000000 +0200
+++ ntfslow/ntfs-3g/include/fuse-lite/fuse.h	2009-12-23 08:22:10.000000000 +0100
@@ -67,7 +67,23 @@
  * Changed in fuse 2.8.0 (regardless of API version)
  * Previously, paths were limited to a length of PATH_MAX.
  */
+
+#define HAS_UTIME_OMIT_OK 1
+
 struct fuse_operations {
+ 	unsigned int flag_nullpath_ok : 1;
+ 
+ 	/**
+	 * Flag indicating that the filesystem accepts special
+	 * UTIME_NOW and UTIME_OMIT values in its utimens operation.
+	 */
+	unsigned int flag_utime_omit_ok : 1;
+
+	/**
+ 	 * Reserved flags, don't set
+ 	 */
+	unsigned int flag_reserved : 30;
+ 
 	/** Get file attributes.
 	 *
 	 * Similar to stat().  The 'st_dev' and 'st_blksize' fields are
--- ntfs-3g-2009.11.14AC.2/include/fuse-lite/fuse_lowlevel.h	2009-07-30 15:11:50.000000000 +0200
+++ ntfslow/ntfs-3g/include/fuse-lite/fuse_lowlevel.h	2009-12-22 18:24:54.000000000 +0100
@@ -114,6 +114,8 @@
 #define FUSE_SET_ATTR_SIZE	(1 << 3)
 #define FUSE_SET_ATTR_ATIME	(1 << 4)
 #define FUSE_SET_ATTR_MTIME	(1 << 5)
+#define FUSE_SET_ATTR_ATIME_NOW	(1 << 7)
+#define FUSE_SET_ATTR_MTIME_NOW	(1 << 8)
 
 /* ----------------------------------------------------------- *
  * Request methods and replies				       *
--- ntfs-3g-2009.11.14AC.2/libfuse-lite/fuse.c	2009-07-30 15:11:50.000000000 +0200
+++ ntfslow/ntfs-3g/libfuse-lite/fuse.c	2009-12-23 10:06:50.000000000 +0100
@@ -75,6 +75,7 @@
     struct fuse_config conf;
     int intr_installed;
     struct fuse_fs *fs;
+    int utime_omit_ok;
 };
 
 struct lock {
@@ -1187,6 +1188,29 @@
             else
                 err = fuse_fs_truncate(f->fs, path, attr->st_size);
         }
+#ifdef HAVE_UTIMENSAT
+        if (!err && f->utime_omit_ok &&
+            (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME))) {
+            struct timespec tv[2];
+
+            tv[0].tv_sec = 0;
+            tv[1].tv_sec = 0;
+            tv[0].tv_nsec = UTIME_OMIT;
+            tv[1].tv_nsec = UTIME_OMIT;
+
+            if (valid & FUSE_SET_ATTR_ATIME_NOW)
+                tv[0].tv_nsec = UTIME_NOW;
+            else if (valid & FUSE_SET_ATTR_ATIME)
+                tv[0] = attr->st_atim;
+
+            if (valid & FUSE_SET_ATTR_MTIME_NOW)
+                tv[1].tv_nsec = UTIME_NOW;
+            else if (valid & FUSE_SET_ATTR_MTIME)
+                tv[1] = attr->st_mtim;
+
+            err = fuse_fs_utimens(f->fs, path, tv);
+        } else
+#endif
         if (!err && (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) ==
             (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
             struct timespec tv[2];
@@ -2606,6 +2630,7 @@
         goto out_free;
 
     f->fs = fs;
+    f->utime_omit_ok = fs->op.flag_utime_omit_ok;
 
     /* Oh f**k, this is ugly! */
     if (!fs->op.lock) {
@@ -2639,6 +2664,8 @@
 
     fuse_session_add_chan(f->se, ch);
 
+    if (f->conf.debug)
+        fprintf(stderr, "utime_omit_ok: %i\n", f->utime_omit_ok);
     f->ctr = 0;
     f->generation = 0;
     /* FIXME: Dynamic hash table */
--- ntfs-3g-2009.11.14AC.2/src/ntfs-3g.c	2009-12-16 08:33:25.000000000 +0100
+++ ntfslow/ntfs-3g/src/ntfs-3g.c	2009-12-23 10:28:15.000000000 +0100
@@ -2171,6 +2171,63 @@
 	return ntfs_fuse_rm(path);
 }
 
+#ifdef HAVE_UTIMENSAT
+
+static int ntfs_fuse_utimens(const char *path, const struct timespec tv[2])
+{
+	ntfs_inode *ni;
+	int res = 0;
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+	struct SECURITY_CONTEXT security;
+#endif
+
+	if (ntfs_fuse_is_named_data_stream(path))
+		return -EINVAL; /* n/a for named data streams. */
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+		   /* parent directory must be executable */
+	if (ntfs_fuse_fill_security_context(&security)
+	    && !ntfs_allowed_dir_access(&security,path,
+			(ntfs_inode*)NULL,(ntfs_inode*)NULL,S_IEXEC)) {
+		return (-errno);
+	}
+#endif
+	ni = ntfs_pathname_to_inode(ctx->vol, NULL, path);
+	if (!ni)
+		return -errno;
+
+			/* no check or update if both UTIME_OMIT */
+	if ((tv[0].tv_nsec != UTIME_OMIT) || (tv[1].tv_nsec != UTIME_OMIT)) {
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+		if (ntfs_allowed_access(&security, ni, S_IWRITE)
+		    || ((tv[0].tv_nsec == UTIME_NOW)
+			&& (tv[0].tv_nsec == UTIME_NOW)
+			&& ntfs_allowed_as_owner(&security, ni))) {
+#endif
+			ntfs_time_update_flags mask = NTFS_UPDATE_CTIME;
+
+			if (tv[0].tv_nsec == UTIME_NOW)
+				mask |= NTFS_UPDATE_ATIME;
+			else
+				if (tv[0].tv_nsec != UTIME_OMIT)
+					ni->last_access_time = tv[0].tv_sec;
+			if (tv[1].tv_nsec == UTIME_NOW)
+				mask |= NTFS_UPDATE_MTIME;
+			else
+				if (tv[1].tv_nsec != UTIME_OMIT)
+					ni->last_data_change_time = tv[1].tv_sec;
+			ntfs_inode_update_times(ni, mask);
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+		} else
+			res = -errno;
+#endif
+	}
+	if (ntfs_inode_close(ni))
+		set_fuse_error(&res);
+	return res;
+}
+
+#else /* HAVE_UTIMENSAT */
+
 static int ntfs_fuse_utime(const char *path, struct utimbuf *buf)
 {
 	ntfs_inode *ni;
@@ -2238,6 +2295,8 @@
 	return res;
 }
 
+#endif /* HAVE_UTIMENSAT */
+
 static int ntfs_fuse_bmap(const char *path, size_t blocksize, uint64_t *idx)
 {
 	ntfs_inode *ni;
@@ -3372,6 +3431,9 @@
 }
 
 static struct fuse_operations ntfs_3g_ops = {
+#if defined(HAVE_UTIMENSAT) && HAS_UTIME_OMIT_OK
+	.flag_utime_omit_ok = 1, /* accept UTIME_NOW and UTIME_OMIT in utimens */
+#endif
 	.getattr	= ntfs_fuse_getattr,
 	.readlink	= ntfs_fuse_readlink,
 	.readdir	= ntfs_fuse_readdir,
@@ -3392,7 +3454,11 @@
 	.rename		= ntfs_fuse_rename,
 	.mkdir		= ntfs_fuse_mkdir,
 	.rmdir		= ntfs_fuse_rmdir,
+#ifdef HAVE_UTIMENSAT
+	.utimens	= ntfs_fuse_utimens,
+#else
 	.utime		= ntfs_fuse_utime,
+#endif
 	.bmap		= ntfs_fuse_bmap,
 	.destroy        = ntfs_fuse_destroy2,
 #if !KERNELPERMS | (POSIXACLS & !KERNELACLS)

--------------080702050200070508050205--


