Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZLVNBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZLVNBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZLVNBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:01:23 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57379 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZLVNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:01:23 -0500
To: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
CC: hirofumi@mail.parknet.co.jp, ebb9@byu.net,
       fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, hch@lst.de,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
In-reply-to: <4B30B67A.7080703@wanadoo.fr> (message from
	=?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= on Tue, 22 Dec 2009 13:07:22
	+0100)
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr> <874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1NN4MD-0005ZG-7M@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Dec 2009 14:00:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Jean-Pierre André wrote:
> With ntfs-3g this is not directly possible, because
> the interface does not provide flags telling which
> timestamps should be updated. The only way would
> be fuse feeding both values (even though unchanged)
> before calling ntfs-3g. This is true for all versions of
> ntfs-3g.

Here's a patch for the high level lib.  If the flag_utime_omit_ok flag
is set then the ->utimes() method will be supplied with arguments that
correspond to utimensat (i.e. it can have UTIME_NOW and UTIME_OMIT
values).

Thanks,
Miklos

Index: fuse/configure.in
===================================================================
--- fuse.orig/configure.in	2009-12-22 12:46:44.000000000 +0100
+++ fuse/configure.in	2009-12-22 13:16:07.000000000 +0100
@@ -53,7 +53,7 @@ fi
 if test "$enable_mtab" = "no"; then
 	AC_DEFINE(IGNORE_MTAB, 1, [Don't update /etc/mtab])
 fi
-AC_CHECK_FUNCS([fork setxattr fdatasync])
+AC_CHECK_FUNCS([fork setxattr fdatasync utimensat])
 AC_CHECK_MEMBERS([struct stat.st_atim])
 AC_CHECK_MEMBERS([struct stat.st_atimespec])
 
Index: fuse/include/fuse.h
===================================================================
--- fuse.orig/include/fuse.h	2009-12-22 12:46:44.000000000 +0100
+++ fuse/include/fuse.h	2009-12-22 13:16:07.000000000 +0100
@@ -458,9 +458,15 @@ struct fuse_operations {
 	unsigned int flag_nullpath_ok : 1;
 
 	/**
+	 * Flag indicating that the filesystem accepts special
+	 * UTIME_NOW and UTIME_OMIT values in its utimens operation.
+	 */
+	unsigned int flag_utime_omit_ok : 1;
+
+	/**
 	 * Reserved flags, don't set
 	 */
-	unsigned int flag_reserved : 31;
+	unsigned int flag_reserved : 30;
 
 	/**
 	 * Ioctl
Index: fuse/lib/fuse.c
===================================================================
--- fuse.orig/lib/fuse.c	2009-12-22 12:46:44.000000000 +0100
+++ fuse/lib/fuse.c	2009-12-22 13:16:07.000000000 +0100
@@ -97,6 +97,7 @@ struct fuse {
 	int intr_installed;
 	struct fuse_fs *fs;
 	int nullpath_ok;
+	int utime_omit_ok;
 	int curr_ticket;
 	struct lock_queue_element *lockq;
 };
@@ -2119,6 +2120,29 @@ static void fuse_lib_setattr(fuse_req_t
 				err = fuse_fs_truncate(f->fs, path,
 						       attr->st_size);
 		}
+#ifdef HAVE_UTIMENSAT
+		if (!err && f->utime_omit_ok &&
+		    (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME))) {
+			struct timespec tv[2];
+
+			tv[0].tv_sec = 0;
+			tv[1].tv_sec = 0;
+			tv[0].tv_nsec = UTIME_OMIT;
+			tv[1].tv_nsec = UTIME_OMIT;
+
+			if (valid & FUSE_SET_ATTR_ATIME_NOW)
+				tv[0].tv_nsec = UTIME_NOW;
+			else if (valid & FUSE_SET_ATTR_ATIME)
+				tv[0] = attr->st_atim;
+
+			if (valid & FUSE_SET_ATTR_MTIME_NOW)
+				tv[1].tv_nsec = UTIME_NOW;
+			else if (valid & FUSE_SET_ATTR_MTIME)
+				tv[1] = attr->st_mtim;
+
+			err = fuse_fs_utimens(f->fs, path, tv);
+		} else
+#endif
 		if (!err &&
 		    (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) ==
 		    (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
@@ -3637,6 +3661,7 @@ static int fuse_push_module(struct fuse
 	newfs->m = m;
 	f->fs = newfs;
 	f->nullpath_ok = newfs->op.flag_nullpath_ok && f->nullpath_ok;
+	f->utime_omit_ok = newfs->op.flag_utime_omit_ok && f->utime_omit_ok;
 	return 0;
 }
 
@@ -3687,6 +3712,7 @@ struct fuse *fuse_new_common(struct fuse
 	fs->compat = compat;
 	f->fs = fs;
 	f->nullpath_ok = fs->op.flag_nullpath_ok;
+	f->utime_omit_ok = fs->op.flag_utime_omit_ok;
 
 	/* Oh f**k, this is ugly! */
 	if (!fs->op.lock) {
@@ -3743,8 +3769,10 @@ struct fuse *fuse_new_common(struct fuse
 
 	fuse_session_add_chan(f->se, ch);
 
-	if (f->conf.debug)
+	if (f->conf.debug) {
 		fprintf(stderr, "nullpath_ok: %i\n", f->nullpath_ok);
+		fprintf(stderr, "utime_omit_ok: %i\n", f->utime_omit_ok);
+	}
 
 	/* Trace topmost layer by default */
 	f->fs->debug = f->conf.debug;
Index: fuse/example/fusexmp_fh.c
===================================================================
--- fuse.orig/example/fusexmp_fh.c	2009-06-19 12:24:25.000000000 +0200
+++ fuse/example/fusexmp_fh.c	2009-12-22 13:55:04.000000000 +0100
@@ -283,6 +283,9 @@ static int xmp_ftruncate(const char *pat
 static int xmp_utimens(const char *path, const struct timespec ts[2])
 {
 	int res;
+#ifdef HAVE_UTIMENSAT
+	res = utimensat(AT_FDCWD, path, ts, AT_SYMLINK_NOFOLLOW);
+#else
 	struct timeval tv[2];
 
 	tv[0].tv_sec = ts[0].tv_sec;
@@ -291,6 +294,7 @@ static int xmp_utimens(const char *path,
 	tv[1].tv_usec = ts[1].tv_nsec / 1000;
 
 	res = utimes(path, tv);
+#endif
 	if (res == -1)
 		return -errno;
 
@@ -486,6 +490,9 @@ static struct fuse_operations xmp_oper =
 	.lock		= xmp_lock,
 
 	.flag_nullpath_ok = 1,
+#if HAVE_UTIMENSAT
+	.flag_utime_omit_ok = 1,
+#endif
 };
 
 int main(int argc, char *argv[])

