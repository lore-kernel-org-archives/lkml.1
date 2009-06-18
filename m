Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZFRJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZFRJ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZFRJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:26:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:56803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZFRJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:26:14 -0400
Message-ID: <4A3A0899.4040506@suse.de>
Date: Thu, 18 Jun 2009 18:27:53 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: [PATCH libfuse] implement direct mmap support
References: <1245317073-24000-1-git-send-email-tj@kernel.org>
In-Reply-To: <1245317073-24000-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements direct mmap.  It allows FUSE server to honor
each mmap request with anonymous mapping.  FUSE server can make
multiple mmap requests share a single anonymous mapping or separate
mappings as it sees fit.

mmap request is handled in two steps.  MMAP first queries the server
whether it wants to share the mapping with an existing one or create a
new one, and if so, with which flags.  MMAP_COMMIT notifies the server
the result of mmap and if successful the fd the server can use to
access the mmap region.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Here's updated direct mmap implementation in libfuse.  Thanks.

 example/Makefile.am     |    6 
 example/fmmap.c         |  370 ++++++++++++++++++++++++++++++++++++++++++++++++
 example/fmmapclient.c   |  112 ++++++++++++++
 include/cuse_lowlevel.h |    8 +
 include/fuse.h          |   70 +++++++++
 include/fuse_common.h   |    9 +
 include/fuse_kernel.h   |   47 ++++++
 include/fuse_lowlevel.h |   76 +++++++++
 lib/cuse_lowlevel.c     |   30 +++
 lib/fuse.c              |  129 ++++++++++++++++
 lib/fuse_lowlevel.c     |   65 ++++++++
 lib/fuse_versionscript  |    4 
 12 files changed, 924 insertions(+), 2 deletions(-)

Index: fuse/include/fuse.h
===================================================================
--- fuse.orig/include/fuse.h
+++ fuse/include/fuse.h
@@ -493,6 +493,67 @@ struct fuse_operations {
 	 */
 	int (*poll) (const char *, struct fuse_file_info *,
 		     struct fuse_pollhandle *ph, unsigned *reventsp);
+
+	/**
+	 * Direct mmap
+	 *
+	 * Direct mmap is available for direct_io files.  FUSE direct
+	 * mmap is always backed by anonymous mapping which can be
+	 * shared between different maps.
+	 *
+	 * mmap is done in two steps.  mmap() is the first step and
+	 * queries the server whether an existing mmap should be
+	 * reused or a new one should be created and if a new area is
+	 * to be created with which flags.
+	 *
+	 * The server can set *@fdp to an existing fd to share the map
+	 * and set flags on *@flagsp for new map.  Note that setting
+	 * both *@fdp and *@flagsp makes *@flagsp setting ignored.
+	 * The fd set in *@fdp must be from previous FUSE mmaps.
+	 *
+	 * Introduced in version 2.9
+	 */
+	int (*mmap) (const char *, void *addr, size_t len, int prot, int flags,
+		     off_t offset, struct fuse_file_info *fi,
+		     int *fdp, unsigned *flagsp);
+
+	/**
+	 * Direct mmap commit
+	 *
+	 * This method is called to commit a direct mmap.  This method
+	 * is guaranteed to be called after successful return from
+	 * mmap().  If @fd is negative, it contains -errno and
+	 * indicates internal error occurred and the mmap request is
+	 * being failed.  Otherwise, @fd is connected to the anonymous
+	 * mapping which will be used for the mmap.  The server is
+	 * free to resize or fill the area as it likes.  If @fd has
+	 * been created for this mmap, it will be visible to the
+	 * client only after mmap_commit() completes successfully.
+	 *
+	 * On mmap_commit() failure, the kernel will automatically
+	 * close @fd if it has been created for this mmap.
+	 *
+	 * The server can associate MMAP_COMMIT with the respective
+	 * MMAP using @mmap_unique which contains request unique ID of
+	 * the MMAP request.
+	 */
+	int (*mmap_commit) (const char *, void *addr, size_t len,
+			    int prot, int flags, int fd, off_t offset,
+			    struct fuse_file_info *fi, uint64_t mmap_unique);
+
+	/**
+	 * Direct munmap
+	 *
+	 * This method is called when a direct mmap area is being
+	 * unmapped.
+	 *
+	 * The server can associate MUNMAP with the respective MMAP or
+	 * MMAP_COMMIT using @mmap_unique which contains request
+	 * unique ID of the MMAP request.
+	 */
+	void (*munmap) (const char *, void *addr, size_t len,
+			struct fuse_file_info *fi, uint64_t mmap_unique,
+			int fd);
 };
 
 /** Extra context that may be needed by some filesystems
@@ -730,6 +791,15 @@ int fuse_fs_ioctl(struct fuse_fs *fs, co
 int fuse_fs_poll(struct fuse_fs *fs, const char *path,
 		 struct fuse_file_info *fi, struct fuse_pollhandle *ph,
 		 unsigned *reventsp);
+int fuse_fs_mmap(struct fuse_fs *fs, const char *path, void *addr, size_t len,
+		 int prot, int flags, off_t offset, struct fuse_file_info *fi,
+		 int *fdp, unsigned *flagsp);
+int fuse_fs_mmap_commit(struct fuse_fs *fs, const char *path, void *addr,
+			size_t len, int prot, int flags, int fd, off_t offset,
+			struct fuse_file_info *fi, uint64_t mmap_unique);
+void fuse_fs_munmap(struct fuse_fs *fs, const char *path,
+		    void *addr, size_t len, struct fuse_file_info *fi,
+		    uint64_t mmap_unique, int fd);
 void fuse_fs_init(struct fuse_fs *fs, struct fuse_conn_info *conn);
 void fuse_fs_destroy(struct fuse_fs *fs);
 
Index: fuse/include/fuse_kernel.h
===================================================================
--- fuse.orig/include/fuse_kernel.h
+++ fuse/include/fuse_kernel.h
@@ -207,6 +207,15 @@ struct fuse_file_lock {
  */
 #define FUSE_POLL_SCHEDULE_NOTIFY (1 << 0)
 
+/**
+ * Mmap flags
+ *
+ * FUSE_MMAP_DONT_COPY: don't copy the region on fork
+ * FUSE_MMAP_DONT_EXPAND: can't be expanded with mremap()
+ */
+#define FUSE_MMAP_DONT_COPY	(1 << 0)
+#define FUSE_MMAP_DONT_EXPAND	(1 << 1)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -246,6 +255,9 @@ enum fuse_opcode {
 	FUSE_DESTROY       = 38,
 	FUSE_IOCTL         = 39,
 	FUSE_POLL          = 40,
+	FUSE_MMAP          = 41,
+	FUSE_MMAP_COMMIT   = 42,
+	FUSE_MUNMAP        = 43,
 
 	/* CUSE specific operations */
 	CUSE_INIT          = 4096,
@@ -507,6 +519,41 @@ struct fuse_notify_poll_wakeup_out {
 	__u64	kh;
 };
 
+struct fuse_mmap_in {
+	__u64	fh;
+	__u64	addr;
+	__u64	len;
+	__s32	prot;
+	__s32	flags;
+	__u64	offset;
+};
+
+struct fuse_mmap_out {
+	__s32	fd;
+	__u32	flags;
+};
+
+struct fuse_mmap_commit_in {
+	__u64	fh;
+	__u64	mmap_unique;
+	__u64	addr;
+	__u64	len;
+	__s32	prot;
+	__s32	flags;
+	__s32	fd;
+	__u32	padding;
+	__u64	offset;
+};
+
+struct fuse_munmap_in {
+	__u64	fh;
+	__u64	mmap_unique;
+	__u64	addr;
+	__u64	len;
+	__s32	fd;
+	__u32	padding;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
Index: fuse/include/fuse_lowlevel.h
===================================================================
--- fuse.orig/include/fuse_lowlevel.h
+++ fuse/include/fuse_lowlevel.h
@@ -869,6 +869,72 @@ struct fuse_lowlevel_ops {
 	 */
 	void (*poll) (fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
 		      struct fuse_pollhandle *ph);
+
+	/**
+	 * Mmap
+	 *
+	 * Introduced in version 2.8
+	 *
+	 * Valid replies:
+	 *   fuse_reply_mmap
+	 *   fuse_reply_err
+	 *
+	 * @param req request handle
+	 * @param ino the inode number
+	 * @param addr address to be mapped
+	 * @param len length of the mapping
+	 * @param prot PROT_*
+	 * @param flags MAP_* flags
+	 * @param offset mmap offset
+	 * @param fi file information
+	 */
+	void (*mmap) (fuse_req_t req, fuse_ino_t ino, void *addr, size_t len,
+		      int prot, int flags, off_t offset,
+		      struct fuse_file_info *fi);
+
+	/**
+	 * Mmap commit
+	 *
+	 * Introduced in version 2.8
+	 *
+	 * Valid replies:
+	 *   fuse_reply_err
+	 *
+	 * @param req request handle
+	 * @param ino the inode number
+	 * @param addr address to be mapped
+	 * @param len length of the mapping
+	 * @param prot PROT_*
+	 * @param flags MAP_* flags
+	 * @param fd file backing the anonymous shared mapping for this mmap
+	 * @param offset mmap offset
+	 * @param fi file information
+	 * @param mmap_unique req->unique of the corresponding MMAP request
+	 */
+	void (*mmap_commit) (fuse_req_t req, fuse_ino_t ino,
+			     void *addr, size_t len, int prot, int flags,
+			     int fd, off_t offset, struct fuse_file_info *fi,
+			     uint64_t mmap_unique);
+
+	/**
+	 * Munmap
+	 *
+	 * Introduced in version 2.8
+	 *
+	 * Valid replies:
+	 *   fuse_reply_none
+	 *
+	 * @param req request handle
+	 * @param ino the inode number
+	 * @param addr address to be mapped
+	 * @param len length of the mapping
+	 * @param fi file information
+	 * @param mmap_unique req->unique of the corresponding MMAP request
+	 * @param fd file backing the anonymous shared mapping for this mmap
+	 */
+	void (*munmap) (fuse_req_t req, fuse_ino_t ino,
+			void *addr, size_t len, struct fuse_file_info *fi,
+			uint64_t mmap_unique, int fd);
 };
 
 /**
@@ -1138,6 +1204,16 @@ int fuse_reply_ioctl_iov(fuse_req_t req,
  */
 int fuse_reply_poll(fuse_req_t req, unsigned revents);
 
+/**
+ * Reply with mmap information
+ *
+ * @param req request handle
+ * @param fd file for the mapping.  -1 creates new one; otherwise,
+ *	  should point to fd created by mmap
+ * @param flags FUSE_MMAP_* flags
+ */
+int fuse_reply_mmap(fuse_req_t req, int fd, unsigned flags);
+
 /* ----------------------------------------------------------- *
  * Notification						       *
  * ----------------------------------------------------------- */
Index: fuse/lib/fuse_lowlevel.c
===================================================================
--- fuse.orig/lib/fuse_lowlevel.c
+++ fuse/lib/fuse_lowlevel.c
@@ -509,6 +509,17 @@ int fuse_reply_poll(fuse_req_t req, unsi
 	return send_reply_ok(req, &arg, sizeof(arg));
 }
 
+int fuse_reply_mmap(fuse_req_t req, int fd, unsigned flags)
+{
+	struct fuse_mmap_out arg;
+
+	memset(&arg, 0, sizeof(arg));
+	arg.fd = fd;
+	arg.flags = flags;
+
+	return send_reply_ok(req, &arg, sizeof(arg));
+}
+
 static void do_lookup(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
 {
 	char *name = (char *) inarg;
@@ -1125,6 +1136,57 @@ static void do_poll(fuse_req_t req, fuse
 	}
 }
 
+static void do_mmap(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
+{
+	struct fuse_mmap_in *arg = (struct fuse_mmap_in *) inarg;
+	struct fuse_file_info fi;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.fh = arg->fh;
+	fi.fh_old = fi.fh;
+
+	if (req->f->op.mmap)
+		req->f->op.mmap(req, nodeid, (void *)(unsigned long)arg->addr,
+				arg->len, arg->prot, arg->flags, arg->offset,
+				&fi);
+	else
+		fuse_reply_err(req, ENOSYS);
+}
+
+static void do_mmap_commit(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
+{
+	struct fuse_mmap_commit_in *arg = (struct fuse_mmap_commit_in *) inarg;
+	struct fuse_file_info fi;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.fh = arg->fh;
+	fi.fh_old = fi.fh;
+
+	if (req->f->op.mmap_commit)
+		req->f->op.mmap_commit(req, nodeid,
+				       (void *)(unsigned long)arg->addr,
+				       arg->len, arg->prot, arg->flags, arg->fd,
+				       arg->offset, &fi, arg->mmap_unique);
+	else
+		fuse_reply_err(req, ENOSYS);
+}
+
+static void do_munmap(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
+{
+	struct fuse_munmap_in *arg = (struct fuse_munmap_in *) inarg;
+	struct fuse_file_info fi;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.fh = arg->fh;
+	fi.fh_old = fi.fh;
+
+	if (req->f->op.munmap)
+		req->f->op.munmap(req, nodeid, (void *)(unsigned long)arg->addr,
+				  arg->len, &fi, arg->mmap_unique, arg->fd);
+	else
+		fuse_reply_none(req);
+}
+
 static void do_init(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
 {
 	struct fuse_init_in *arg = (struct fuse_init_in *) inarg;
@@ -1341,7 +1403,10 @@ static struct {
 	[FUSE_BMAP]	   = { do_bmap,	       "BMAP"	     },
 	[FUSE_IOCTL]	   = { do_ioctl,       "IOCTL"	     },
 	[FUSE_POLL]	   = { do_poll,        "POLL"	     },
+	[FUSE_MMAP]	   = { do_mmap,        "MMAP"	     },
+	[FUSE_MMAP_COMMIT] = { do_mmap_commit, "MMAP_COMMIT" },
 	[FUSE_DESTROY]	   = { do_destroy,     "DESTROY"     },
+	[FUSE_MUNMAP]	   = { do_munmap,      "MUNMAP"	     },
 	[CUSE_INIT]	   = { do_cuse_init,   "CUSE_INIT"   },
 };
 
Index: fuse/lib/fuse_versionscript
===================================================================
--- fuse.orig/lib/fuse_versionscript
+++ fuse/lib/fuse_versionscript
@@ -169,6 +169,10 @@ FUSE_2.8 {
 		fuse_reply_ioctl;
 		fuse_reply_ioctl_iov;
 		fuse_reply_ioctl_retry;
+		fuse_fs_mmap;
+		fuse_fs_mmap_commit;
+		fuse_fs_munmap;
+		fuse_reply_mmap;
 		fuse_reply_poll;
 
 	local:
Index: fuse/example/Makefile.am
===================================================================
--- fuse.orig/example/Makefile.am
+++ fuse/example/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include -D_FILE_OFFSET_BITS=64 -D_REENTRANT
 noinst_HEADERS = fioc.h
 noinst_PROGRAMS = fusexmp fusexmp_fh null hello hello_ll fioc fioclient \
-		  fsel fselclient cusexmp
+		  fsel fselclient fmmap fmmapclient cusexmp
 
 LDADD = ../lib/libfuse.la @libfuse_libs@
 fusexmp_fh_LDADD = ../lib/libfuse.la ../lib/libulockmgr.la @libfuse_libs@
@@ -14,4 +14,6 @@ fioclient_LDADD =
 fselclient_CPPFLAGS =
 fselclient_LDFLAGS =
 fselclient_LDADD =
-
+fmmapclient_CPPFLAGS =
+fmmapclient_LDFLAGS =
+fmmapclient_LDADD =
Index: fuse/example/fmmap.c
===================================================================
--- /dev/null
+++ fuse/example/fmmap.c
@@ -0,0 +1,370 @@
+/*
+  FUSE fmmap: FUSE mmap example
+  Copyright (C) 2008-2009  SUSE Linux Products GmbH
+  Copyright (C) 2008-2009  Tejun Heo <tj@kernel.org>
+
+  This program can be distributed under the terms of the GNU GPL.
+  See the file COPYING.
+
+  gcc -Wall `pkg-config fuse --cflags --libs` fmmap.c -o fmmap
+*/
+
+#define FUSE_USE_VERSION 29
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fuse.h>
+#include <pthread.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#define FMMAP_NAME	"fmmap"
+
+struct fmmap_data {
+	struct fmmap_data	*next;
+	uid_t			uid;
+	int			fd;
+	void			*buf;
+	size_t			size;
+	size_t			cur;
+};
+
+static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+static struct fmmap_data *fmmap_data_list;
+static pthread_t fmmap_worker_thread;
+
+enum {
+	FMMAP_NONE,
+	FMMAP_ROOT,
+	FMMAP_FILE,
+};
+
+static struct fmmap_data *fmmap_get_data(uid_t uid)
+{
+	struct fmmap_data **pos, *fmdata;
+
+	pthread_mutex_lock(&mutex);
+
+	for (pos = &fmmap_data_list; *pos; pos = &((*pos)->next))
+		if ((*pos)->uid == uid)
+			break;
+	fmdata = *pos;
+
+	if (!fmdata) {
+		fmdata = calloc(1, sizeof(*fmdata));
+		if (fmdata) {
+			fmdata->fd = -1;
+			fmdata->uid = uid;
+			*pos = fmdata;
+		}
+	}
+
+	pthread_mutex_unlock(&mutex);
+
+	return fmdata;
+}
+
+static int fmmap_mmap_buf(struct fmmap_data *fmdata, int fd, size_t size)
+{
+	void *buf;
+	int rc = 0;
+
+	pthread_mutex_lock(&mutex);
+
+	if (fmdata->fd >= 0 && fmdata->fd != fd) {
+		rc = -EBUSY;
+		goto out_unlock;
+	}
+	fmdata->fd = fd;
+
+	if (size <= fmdata->size)
+		goto out_unlock;
+
+	if (ftruncate(fd, size)) {
+		rc = -errno;
+		goto out_unlock;
+	}
+
+	if (!fmdata->buf)
+		buf = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
+			   fmdata->fd, 0);
+	else
+		buf = mremap(fmdata->buf, fmdata->size, size, MREMAP_MAYMOVE);
+
+	if (buf == MAP_FAILED) {
+		rc = -errno;
+		goto out_unlock;
+	}
+
+	fmdata->buf = buf;
+	fmdata->size = size;
+ out_unlock:
+	pthread_mutex_unlock(&mutex);
+	return rc;
+}
+
+static int fmmap_file_type(const char *path)
+{
+	if (strcmp(path, "/") == 0)
+		return FMMAP_ROOT;
+	if (strcmp(path, "/" FMMAP_NAME) == 0)
+		return FMMAP_FILE;
+	return FMMAP_NONE;
+}
+
+static int fmmap_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
+			 off_t offset, struct fuse_file_info *fi)
+{
+	(void) fi;
+	(void) offset;
+
+	if (fmmap_file_type(path) != FMMAP_ROOT)
+		return -ENOENT;
+
+	filler(buf, ".", NULL, 0);
+	filler(buf, "..", NULL, 0);
+	filler(buf, FMMAP_NAME, NULL, 0);
+
+	return 0;
+}
+
+static int fmmap_getattr(const char *path, struct stat *stbuf)
+{
+	stbuf->st_uid = getuid();
+	stbuf->st_gid = getgid();
+	stbuf->st_atime = stbuf->st_mtime = time(NULL);
+
+	switch (fmmap_file_type(path)) {
+	case FMMAP_ROOT:
+		stbuf->st_mode = S_IFDIR | 0777;
+		stbuf->st_nlink = 2;
+		break;
+	case FMMAP_FILE:
+		stbuf->st_mode = S_IFREG | 0666;
+		stbuf->st_nlink = 1;
+		break;
+	case FMMAP_NONE:
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
+static int fmmap_open(const char *path, struct fuse_file_info *fi)
+{
+	struct fuse_context *cxt = fuse_get_context();
+
+	switch (fmmap_file_type(path)) {
+	case FMMAP_ROOT:
+		return 0;
+	case FMMAP_FILE:
+		fi->fh = cxt->uid;
+		fi->direct_io = 1;
+		return 0;
+	default:
+		return -ENOENT;
+	}
+}
+
+static int fmmap_read(const char *path, char *buf, size_t size,
+		     off_t offset, struct fuse_file_info *fi)
+{
+	struct fmmap_data *fmdata;
+	size_t bytes = 0;
+
+	(void) path;
+	(void) fi;
+
+	/* all data should be fetched in one slurp */
+	if (offset)
+		return 0;
+
+#define append(fmt, args...)						\
+	({								\
+		size_t cur, t;						\
+		cur = t = snprintf(buf + bytes, size - bytes,		\
+				   fmt , ##args);			\
+		if (cur >= size - bytes)				\
+			cur = size - bytes;				\
+		bytes += cur;						\
+		t;							\
+	})
+
+	pthread_mutex_lock(&mutex);
+
+	for (fmdata = fmmap_data_list; fmdata; fmdata = fmdata->next) {
+		int col = 80, step, i;
+		size_t off = 0;
+
+		col -= append("%6d: %6zu ", fmdata->uid, fmdata->size);
+		step = fmdata->size / col;
+
+		for (i = 0; i < col; i++) {
+			int nr_zeros = 0, nr_ones = 0, has_cursor = 0;
+			size_t end;
+
+			if (i < col - 1)
+				end = off + step;
+			else
+				end = fmdata->size;
+
+			for (; off < end; off++) {
+				char *p = fmdata->buf + off;
+
+				if (off == fmdata->cur)
+					has_cursor = 1;
+				if (*p)
+					nr_ones++;
+				else
+					nr_zeros++;
+			}
+
+			if (has_cursor)
+				append("^");
+			else if (nr_ones && nr_zeros)
+				append("?");
+			else if (nr_ones)
+				append("1");
+			else
+				append("0");
+		}
+		append("\n");
+	}
+
+	pthread_mutex_unlock(&mutex);
+	return bytes;
+}
+
+static int fmmap_mmap(const char *path, void *addr, size_t len, int prot,
+		      int flags, off_t offset, struct fuse_file_info *fi,
+		      int *fdp, unsigned *flagsp)
+{
+	uid_t uid = fi->fh;
+	struct fmmap_data *fmdata;
+
+	(void) path;
+	(void) addr;
+	(void) len;
+	(void) prot;
+	(void) flags;
+	(void) offset;
+
+	printf("MMAP: addr=%p len=%zu prot=0x%x flags=0x%x offset=%lld\n",
+	       addr, len, prot, flags, (long long)offset);
+
+	fmdata = fmmap_get_data(uid);
+	if (!fmdata)
+		return -ENOMEM;
+
+	*fdp = fmdata->fd;
+	*flagsp |= FUSE_MMAP_DONT_COPY;
+
+	return 0;
+}
+
+static int fmmap_mmap_commit(const char *path, void *addr, size_t len,
+			     int prot, int flags, int fd, off_t offset,
+			     struct fuse_file_info *fi, uint64_t mmap_unique)
+{
+	uid_t uid = fi->fh;
+	struct fmmap_data *fmdata;
+	int rc;
+
+	(void) path;
+
+	printf("MMAP_COMMIT: addr=%p len=%zu prot=0x%x flags=0x%x\n"
+	       "             fd=%d offset=%lld mmap_unique=%llu\n",
+	       addr, len, prot, flags, fd, (long long)offset,
+	       (unsigned long long)mmap_unique);
+
+	if (fd < 0)
+		return 0;
+
+	fmdata = fmmap_get_data(uid);
+	if (!fmdata)
+		return -ENOMEM;
+
+	if (offset + len > SIZE_MAX)
+		return -EOVERFLOW;
+
+	rc = fmmap_mmap_buf(fmdata, fd, offset + len);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static void fmmap_munmap(const char *path, void *addr, size_t len,
+			 struct fuse_file_info *fi, uint64_t mmap_unique,
+			 int fd)
+{
+	(void) path;
+	(void) addr;
+	(void) len;
+	(void) fi;
+	(void) mmap_unique;
+	(void) fd;
+
+	printf("MUNMAP: addr=%p len=%zu mmap_unique=%llu fd=%d\n",
+	       addr, len, (unsigned long long)mmap_unique, fd);
+}
+
+static struct fuse_operations fmmap_oper = {
+	.getattr	= fmmap_getattr,
+	.readdir	= fmmap_readdir,
+	.open		= fmmap_open,
+	.read		= fmmap_read,
+	.mmap		= fmmap_mmap,
+	.mmap_commit	= fmmap_mmap_commit,
+	.munmap		= fmmap_munmap,
+};
+
+static void *fmmap_worker(void *arg)
+{
+	const struct timespec delay = { 0, 1000000 };	/* 1ms */
+	struct fmmap_data *fmdata;
+
+	(void) arg;
+
+ repeat:
+	pthread_mutex_lock(&mutex);
+
+	for (fmdata = fmmap_data_list; fmdata; fmdata = fmdata->next) {
+		char *p = NULL;
+		int i;
+
+		for (i = 0; i < fmdata->size; i++) {
+			p = fmdata->buf + (fmdata->cur + i) % fmdata->size;
+			if (!*p)
+				break;
+		}
+
+		if (p && !*p) {
+			*p = 1;
+			fmdata->cur = (fmdata->cur + i + 1) % fmdata->size;
+		}
+	}
+
+	pthread_mutex_unlock(&mutex);
+
+	nanosleep(&delay, NULL);
+
+	goto repeat;
+}
+
+int main(int argc, char *argv[])
+{
+	errno = pthread_create(&fmmap_worker_thread, NULL, &fmmap_worker, NULL);
+	if (errno) {
+		perror("pthread_create");
+		return 1;
+	}
+
+	return fuse_main(argc, argv, &fmmap_oper, NULL);
+}
Index: fuse/include/fuse_common.h
===================================================================
--- fuse.orig/include/fuse_common.h
+++ fuse/include/fuse_common.h
@@ -109,6 +109,15 @@ struct fuse_file_info {
 #define FUSE_IOCTL_MAX_IOV	256
 
 /**
+ * Mmap flags
+ *
+ * FUSE_MMAP_DONT_COPY: don't copy the region on fork
+ * FUSE_MMAP_DONT_EXPAND: can't be expanded with mremap()
+ */
+#define FUSE_MMAP_DONT_COPY	(1 << 0)
+#define FUSE_MMAP_DONT_EXPAND	(1 << 1)
+
+/**
  * Connection information, passed to the ->init() method
  *
  * Some of the elements are read-write, these can be changed to
Index: fuse/example/fmmapclient.c
===================================================================
--- /dev/null
+++ fuse/example/fmmapclient.c
@@ -0,0 +1,112 @@
+/*
+  FUSE fmmapclient: FUSE mmap example client
+  Copyright (C) 2008-2009  SUSE Linux Products GmbH
+  Copyright (C) 2008-2009  Tejun Heo <tj@kernel.org>
+
+  This program can be distributed under the terms of the GNU GPL.
+  See the file COPYING.
+
+  gcc -Wall fmmapclient.c -o fmmapclient
+*/
+
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#define COL	78
+
+const char *usage =
+"Usage: fmmapclient FMMAP_FILE OFF SIZE\n"
+"\n"
+"  OFF      : offset in pages\n"
+"  SIZE     : size in pages\n"
+"\n";
+
+int main(int argc, char **argv)
+{
+	const struct timespec delay = { 0, 1000000 };	/* 1ms */
+	unsigned long param[2] = { 0, 0 };
+	char status[COL] = "";
+	size_t pos = 0;
+	int nr_ones = 0, nr_zeros = 0;
+	size_t page_size;
+	off_t offset;
+	size_t size;
+	char *endp, *map;
+	int i, fd;
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	if (argc < 4)
+		goto usage;
+
+	for (i = 2; i < 4; i++) {
+		param[i - 2] = strtoul(argv[i], &endp, 0);
+		if (endp == argv[i] || *endp != '\0')
+			goto usage;
+	}
+
+	/* well, let's not care about overflow for now */
+	offset = param[0] * page_size;
+	size = param[1] * page_size;
+
+	if (!size)
+		goto usage;
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	map = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset);
+	if (map == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+
+	while (1) {
+		int col = COL, step = size / col;
+		char *p = map + pos;
+		int col_pre, col_new;
+
+		col_pre = pos / step;
+		pos = (pos + 1) % size;
+		col_new = pos / step;
+
+		if (*p) {
+			status[col_pre] = '#';
+			nr_ones++;
+			*p = 0;
+		} else {
+			status[col_pre] = '^';
+			nr_zeros++;
+		}
+
+		if (col_pre != col_new) {
+			if (nr_zeros && nr_ones)
+				status[col_pre] = '?';
+			else if (nr_ones)
+				status[col_pre] = '1';
+			else
+				status[col_pre] = '0';
+			nr_zeros = 0;
+			nr_ones = 0;
+		}
+		printf("\r%s", status);
+		fflush(stdout);
+
+		nanosleep(&delay, NULL);
+	}
+	return 0;
+
+ usage:
+	fprintf(stderr, usage);
+	return 1;
+}
Index: fuse/include/cuse_lowlevel.h
===================================================================
--- fuse.orig/include/cuse_lowlevel.h
+++ fuse/include/cuse_lowlevel.h
@@ -63,6 +63,14 @@ struct cuse_lowlevel_ops {
 		       const void *in_buf, size_t in_bufsz, size_t out_bufsz);
 	void (*poll) (fuse_req_t req, struct fuse_file_info *fi,
 		      struct fuse_pollhandle *ph);
+	void (*mmap) (fuse_req_t req, void *addr, size_t len, int prot,
+		      int flags, off_t offset, struct fuse_file_info *fi);
+	void (*mmap_commit) (fuse_req_t req, void *addr, size_t len, int prot,
+			     int flags, int fd, off_t offset,
+			     struct fuse_file_info *fi, uint64_t mmap_unique);
+	void (*munmap) (fuse_req_t req, void *addr, size_t len,
+			struct fuse_file_info *fi, uint64_t mmap_unique,
+			int fd);
 };
 
 struct fuse_session *cuse_lowlevel_new(struct fuse_args *args,
Index: fuse/lib/fuse.c
===================================================================
--- fuse.orig/lib/fuse.c
+++ fuse/lib/fuse.c
@@ -1690,6 +1690,67 @@ int fuse_fs_poll(struct fuse_fs *fs, con
 		return -ENOSYS;
 }
 
+int fuse_fs_mmap(struct fuse_fs *fs, const char *path, void *addr, size_t len,
+		 int prot, int flags, off_t offset, struct fuse_file_info *fi,
+		 int *fdp, unsigned *flagsp)
+{
+	fuse_get_context()->private_data = fs->user_data;
+	if (fs->op.mmap) {
+		int res;
+
+		if (fs->debug)
+			fprintf(stderr, "mmap[%llu] addr: %p len: %zu "
+				"prot: 0x%x flags: 0x%x offset: %llu\n",
+				(unsigned long long) fi->fh, addr, len,
+				prot, flags, (unsigned long long) offset);
+
+		res = fs->op.mmap(path, addr, len, prot, flags, offset, fi,
+				  fdp, flagsp);
+
+		if (fs->debug && !res)
+			fprintf(stderr, "   mmap[%llu] fd: %d flags: 0x%x\n",
+				(unsigned long long) fi->fh, *fdp, *flagsp);
+
+		return res;
+	} else
+		return -ENOSYS;
+}
+
+int fuse_fs_mmap_commit(struct fuse_fs *fs, const char *path, void *addr,
+			size_t len, int prot, int flags, int fd, off_t offset,
+			struct fuse_file_info *fi, uint64_t mmap_unique)
+{
+	fuse_get_context()->private_data = fs->user_data;
+	if (fs->op.mmap_commit) {
+		if (fs->debug)
+			fprintf(stderr, "mmap_commit[%llu] addr: %p len: %zu "
+				"prot: 0x%x flags: 0x%x fd: %d offset: %llu "
+				"mmap_unique: 0x%llx\n",
+				(unsigned long long) fi->fh, addr, len,
+				prot, flags, fd, (unsigned long long) offset,
+				(unsigned long long) mmap_unique);
+
+		return fs->op.mmap_commit(path, addr, len, prot, flags, fd,
+					  offset, fi, mmap_unique);
+	} else
+		return -ENOSYS;
+}
+
+void fuse_fs_munmap(struct fuse_fs *fs, const char *path, void *addr, size_t len,
+		    struct fuse_file_info *fi, uint64_t mmap_unique, int fd)
+{
+	fuse_get_context()->private_data = fs->user_data;
+	if (fs->op.munmap) {
+		if (fs->debug)
+			fprintf(stderr, "munmap[%llu] addr: %p len: %zu "
+				"mmap_unique: 0x%llx fd: %d\n",
+				(unsigned long long) fi->fh, addr, len,
+				(unsigned long long) mmap_unique, fd);
+
+		fs->op.munmap(path, addr, len, fi, mmap_unique, fd);
+	}
+}
+
 static int is_open(struct fuse *f, fuse_ino_t dir, const char *name)
 {
 	struct node *node;
@@ -3274,6 +3335,71 @@ static void fuse_lib_poll(fuse_req_t req
 		reply_err(req, ret);
 }
 
+static void fuse_lib_mmap(fuse_req_t req, fuse_ino_t ino,
+			  void *addr, size_t len, int prot, int flags,
+			  off_t offset, struct fuse_file_info *fi)
+{
+	struct fuse *f = req_fuse_prepare(req);
+	struct fuse_intr_data d;
+	char *path;
+	int ret;
+	int fd = -1;
+	unsigned fmmap_flags = 0;
+
+	ret = get_path(f, ino, &path);
+	if (!ret) {
+		fuse_prepare_interrupt(f, req, &d);
+		ret = fuse_fs_mmap(f->fs, path, addr, len, prot, flags,
+				   offset, fi, &fd, &fmmap_flags);
+		fuse_finish_interrupt(f, req, &d);
+		free_path(f, ino, path);
+	}
+	if (!ret)
+		fuse_reply_mmap(req, fd, fmmap_flags);
+	else
+		reply_err(req, ret);
+}
+
+static void fuse_lib_mmap_commit(fuse_req_t req, fuse_ino_t ino, void *addr,
+				 size_t len, int prot, int flags, int fd,
+				 off_t offset, struct fuse_file_info *fi,
+				 uint64_t mmap_unique)
+{
+	struct fuse *f = req_fuse_prepare(req);
+	struct fuse_intr_data d;
+	char *path;
+	int ret;
+
+	ret = get_path(f, ino, &path);
+	if (!ret) {
+		fuse_prepare_interrupt(f, req, &d);
+		ret = fuse_fs_mmap_commit(f->fs, path, addr, len, prot, flags,
+					  fd, offset, fi, mmap_unique);
+		fuse_finish_interrupt(f, req, &d);
+		free_path(f, ino, path);
+	}
+	reply_err(req, ret);
+}
+
+static void fuse_lib_munmap(fuse_req_t req, fuse_ino_t ino, void *addr,
+			    size_t len, struct fuse_file_info *fi,
+			    uint64_t mmap_unique, int fd)
+{
+	struct fuse *f = req_fuse_prepare(req);
+	struct fuse_intr_data d;
+	char *path;
+	int ret;
+
+	ret = get_path(f, ino, &path);
+	if (!ret) {
+		fuse_prepare_interrupt(f, req, &d);
+		fuse_fs_munmap(f->fs, path, addr, len, fi, mmap_unique, fd);
+		fuse_finish_interrupt(f, req, &d);
+		free_path(f, ino, path);
+	}
+	fuse_reply_none(req);
+}
+
 static struct fuse_lowlevel_ops fuse_path_ops = {
 	.init = fuse_lib_init,
 	.destroy = fuse_lib_destroy,
@@ -3311,6 +3437,9 @@ static struct fuse_lowlevel_ops fuse_pat
 	.bmap = fuse_lib_bmap,
 	.ioctl = fuse_lib_ioctl,
 	.poll = fuse_lib_poll,
+	.mmap = fuse_lib_mmap,
+	.mmap_commit = fuse_lib_mmap_commit,
+	.munmap = fuse_lib_munmap,
 };
 
 int fuse_notify_poll(struct fuse_pollhandle *ph)
Index: fuse/lib/cuse_lowlevel.c
===================================================================
--- fuse.orig/lib/cuse_lowlevel.c
+++ fuse/lib/cuse_lowlevel.c
@@ -93,6 +93,33 @@ static void cuse_fll_poll(fuse_req_t req
 	req_clop(req)->poll(req, fi, ph);
 }
 
+static void cuse_fll_mmap(fuse_req_t req, fuse_ino_t ino, void *addr,
+			  size_t len, int prot, int flags, off_t offset,
+			  struct fuse_file_info *fi)
+{
+	(void)ino;
+	req_clop(req)->mmap(req, addr, len, prot, flags, offset, fi);
+}
+
+static void cuse_fll_mmap_commit(fuse_req_t req, fuse_ino_t ino,
+				 void *addr, size_t len, int prot, int flags,
+				 int fd, off_t offset,
+				 struct fuse_file_info *fi,
+				 uint64_t mmap_unique)
+{
+	(void)ino;
+	req_clop(req)->mmap_commit(req, addr, len, prot, flags, fd, offset, fi,
+				   mmap_unique);
+}
+
+static void cuse_fll_munmap(fuse_req_t req, fuse_ino_t ino,
+			    void *addr, size_t len, struct fuse_file_info *fi,
+			    uint64_t mmap_unique, int fd)
+{
+	(void)ino;
+	req_clop(req)->munmap(req, addr, len, fi, mmap_unique, fd);
+}
+
 static size_t cuse_pack_info(int argc, const char **argv, char *buf)
 {
 	size_t size = 0;
@@ -169,6 +196,9 @@ struct fuse_session *cuse_lowlevel_new(s
 	lop.fsync	= clop->fsync		? cuse_fll_fsync	: NULL;
 	lop.ioctl	= clop->ioctl		? cuse_fll_ioctl	: NULL;
 	lop.poll	= clop->poll		? cuse_fll_poll		: NULL;
+	lop.mmap	= clop->mmap		? cuse_fll_mmap		: NULL;
+	lop.mmap_commit	= clop->mmap_commit	? cuse_fll_mmap_commit	: NULL;
+	lop.munmap	= clop->munmap		? cuse_fll_munmap	: NULL;
 
 	se = fuse_lowlevel_new_common(args, &lop, sizeof(lop), userdata);
 	if (!se) {
