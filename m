Return-Path: <linux-kernel-owner+w=401wt.eu-S1031675AbXEHUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031675AbXEHUyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031660AbXEHUyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:54:32 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:40138 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031608AbXEHUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uQpKb2Y8nfpXyfQgCVFC7jERQv2L8LdEUA3mPj4Vlnsjjr6raAKU1YEQvBOYqhKqZEzwIvdWuUkRqjxnpTDVEpT+u1pbvTCyFXC2z0Hj7e+ZhUSRWj+sGiHI7ABPldCFwgAOvXl3CfC0GVP0EvGlVHqJhCtTibft/JTCV+CewjM=
Message-ID: <f158dc670705081354q60db7abbqd3191427b1f77901@mail.gmail.com>
Date: Tue, 8 May 2007 14:54:21 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH 3/4] v9fs: move non-vfs related c files to net/9p
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: fa35ffcb70b3bbe4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
It moves the transport, packet marshalling and connection layers to net/9p
leaving only the VFS related files in fs/9p.

This patch:

Moves the C files implementing the non-VFS related interfaces to net/9p.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 fs/9p/Makefile      |    6 -
 fs/9p/conv.c        |  896 --------------------------------------------
 fs/9p/error.c       |  240 ------------
 fs/9p/fcprint.c     |  353 -----------------
 fs/9p/mux.c         | 1041 ---------------------------------------------------
 fs/9p/trans_fd.c    |  354 -----------------
 fs/9p/util.c        |  125 ------
 fs/9p/v9fs.c        |   12 -
 fs/Kconfig          |    2 +-
 include/net/9p/9p.h |    2 -
 net/9p/conv.c       |  896 ++++++++++++++++++++++++++++++++++++++++++++
 net/9p/error.c      |  240 ++++++++++++
 net/9p/fcprint.c    |  353 +++++++++++++++++
 net/9p/mod.c        |   86 +++++
 net/9p/mux.c        | 1041 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/9p/sysctl.c     |   86 +++++
 net/9p/trans_fd.c   |  354 +++++++++++++++++
 net/9p/util.c       |  125 ++++++
 net/Kconfig         |    1 +
 net/Makefile        |    1 +
 20 files changed, 3184 insertions(+), 3030 deletions(-)

diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index c2305b5..66d40ca 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -1,19 +1,13 @@
 obj-$(CONFIG_9P_FS) := 9p.o

 9p-objs := \
-	trans_fd.o \
-	mux.o \
 	fcall.o \
-	conv.o \
 	vfs_super.o \
 	vfs_inode.o \
 	vfs_addr.o \
 	vfs_file.o \
 	vfs_dir.o \
 	vfs_dentry.o \
-	error.o \
 	v9fs.o \
 	fid.o \
-	fcprint.o \
-	util.o

diff --git a/fs/9p/conv.c b/fs/9p/conv.c
deleted file mode 100644
index 0ce149d..0000000
--- a/fs/9p/conv.c
+++ /dev/null
@@ -1,896 +0,0 @@
-/*
- * net/9p/conv.c
- *
- * 9P protocol conversion functions
- *
- *  Copyright (C) 2004, 2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/idr.h>
-#include <asm/uaccess.h>
-#include <net/9p/9p.h>
-
-/*
- * Buffer to help with string parsing
- */
-struct cbuf {
-	unsigned char *sp;
-	unsigned char *p;
-	unsigned char *ep;
-};
-
-static inline void buf_init(struct cbuf *buf, void *data, int datalen)
-{
-	buf->sp = buf->p = data;
-	buf->ep = data + datalen;
-}
-
-static inline int buf_check_overflow(struct cbuf *buf)
-{
-	return buf->p > buf->ep;
-}
-
-static int buf_check_size(struct cbuf *buf, int len)
-{
-	if (buf->p + len > buf->ep) {
-		if (buf->p < buf->ep) {
-			P9_EPRINTK(KERN_ERR, "buffer overflow: want %d has %d\n",
-				len, (int)(buf->ep - buf->p));
-			dump_stack();
-			buf->p = buf->ep + 1;
-		}
-
-		return 0;
-	}
-
-	return 1;
-}
-
-static void *buf_alloc(struct cbuf *buf, int len)
-{
-	void *ret = NULL;
-
-	if (buf_check_size(buf, len)) {
-		ret = buf->p;
-		buf->p += len;
-	}
-
-	return ret;
-}
-
-static void buf_put_int8(struct cbuf *buf, u8 val)
-{
-	if (buf_check_size(buf, 1)) {
-		buf->p[0] = val;
-		buf->p++;
-	}
-}
-
-static void buf_put_int16(struct cbuf *buf, u16 val)
-{
-	if (buf_check_size(buf, 2)) {
-		*(__le16 *) buf->p = cpu_to_le16(val);
-		buf->p += 2;
-	}
-}
-
-static void buf_put_int32(struct cbuf *buf, u32 val)
-{
-	if (buf_check_size(buf, 4)) {
-		*(__le32 *)buf->p = cpu_to_le32(val);
-		buf->p += 4;
-	}
-}
-
-static void buf_put_int64(struct cbuf *buf, u64 val)
-{
-	if (buf_check_size(buf, 8)) {
-		*(__le64 *)buf->p = cpu_to_le64(val);
-		buf->p += 8;
-	}
-}
-
-static char *buf_put_stringn(struct cbuf *buf, const char *s, u16 slen)
-{
-	char *ret;
-
-	ret = NULL;
-	if (buf_check_size(buf, slen + 2)) {
-		buf_put_int16(buf, slen);
-		ret = buf->p;
-		memcpy(buf->p, s, slen);
-		buf->p += slen;
-	}
-
-	return ret;
-}
-
-static inline void buf_put_string(struct cbuf *buf, const char *s)
-{
-	buf_put_stringn(buf, s, strlen(s));
-}
-
-static u8 buf_get_int8(struct cbuf *buf)
-{
-	u8 ret = 0;
-
-	if (buf_check_size(buf, 1)) {
-		ret = buf->p[0];
-		buf->p++;
-	}
-
-	return ret;
-}
-
-static u16 buf_get_int16(struct cbuf *buf)
-{
-	u16 ret = 0;
-
-	if (buf_check_size(buf, 2)) {
-		ret = le16_to_cpu(*(__le16 *)buf->p);
-		buf->p += 2;
-	}
-
-	return ret;
-}
-
-static u32 buf_get_int32(struct cbuf *buf)
-{
-	u32 ret = 0;
-
-	if (buf_check_size(buf, 4)) {
-		ret = le32_to_cpu(*(__le32 *)buf->p);
-		buf->p += 4;
-	}
-
-	return ret;
-}
-
-static u64 buf_get_int64(struct cbuf *buf)
-{
-	u64 ret = 0;
-
-	if (buf_check_size(buf, 8)) {
-		ret = le64_to_cpu(*(__le64 *)buf->p);
-		buf->p += 8;
-	}
-
-	return ret;
-}
-
-static void buf_get_str(struct cbuf *buf, struct p9_str *vstr)
-{
-	vstr->len = buf_get_int16(buf);
-	if (!buf_check_overflow(buf) && buf_check_size(buf, vstr->len)) {
-		vstr->str = buf->p;
-		buf->p += vstr->len;
-	} else {
-		vstr->len = 0;
-		vstr->str = NULL;
-	}
-}
-
-static void buf_get_qid(struct cbuf *bufp, struct p9_qid *qid)
-{
-	qid->type = buf_get_int8(bufp);
-	qid->version = buf_get_int32(bufp);
-	qid->path = buf_get_int64(bufp);
-}
-
-/**
- * p9_size_wstat - calculate the size of a variable length stat struct
- * @stat: metadata (stat) structure
- * @dotu: non-zero if 9P2000.u
- *
- */
-
-static int p9_size_wstat(struct p9_wstat *wstat, int dotu)
-{
-	int size = 0;
-
-	if (wstat == NULL) {
-		P9_EPRINTK(KERN_ERR, "p9_size_stat: got a NULL stat pointer\n");
-		return 0;
-	}
-
-	size =			/* 2 + *//* size[2] */
-	    2 +			/* type[2] */
-	    4 +			/* dev[4] */
-	    1 +			/* qid.type[1] */
-	    4 +			/* qid.vers[4] */
-	    8 +			/* qid.path[8] */
-	    4 +			/* mode[4] */
-	    4 +			/* atime[4] */
-	    4 +			/* mtime[4] */
-	    8 +			/* length[8] */
-	    8;			/* minimum sum of string lengths */
-
-	if (wstat->name)
-		size += strlen(wstat->name);
-	if (wstat->uid)
-		size += strlen(wstat->uid);
-	if (wstat->gid)
-		size += strlen(wstat->gid);
-	if (wstat->muid)
-		size += strlen(wstat->muid);
-
-	if (dotu) {
-		size += 4 +	/* n_uid[4] */
-		    4 +		/* n_gid[4] */
-		    4 +		/* n_muid[4] */
-		    2;		/* string length of extension[4] */
-		if (wstat->extension)
-			size += strlen(wstat->extension);
-	}
-
-	return size;
-}
-
-/**
- * buf_get_stat - safely decode a recieved metadata (stat) structure
- * @bufp: buffer to deserialize
- * @stat: metadata (stat) structure
- * @dotu: non-zero if 9P2000.u
- *
- */
-
-static void
-buf_get_stat(struct cbuf *bufp, struct p9_stat *stat, int dotu)
-{
-	stat->size = buf_get_int16(bufp);
-	stat->type = buf_get_int16(bufp);
-	stat->dev = buf_get_int32(bufp);
-	stat->qid.type = buf_get_int8(bufp);
-	stat->qid.version = buf_get_int32(bufp);
-	stat->qid.path = buf_get_int64(bufp);
-	stat->mode = buf_get_int32(bufp);
-	stat->atime = buf_get_int32(bufp);
-	stat->mtime = buf_get_int32(bufp);
-	stat->length = buf_get_int64(bufp);
-	buf_get_str(bufp, &stat->name);
-	buf_get_str(bufp, &stat->uid);
-	buf_get_str(bufp, &stat->gid);
-	buf_get_str(bufp, &stat->muid);
-
-	if (dotu) {
-		buf_get_str(bufp, &stat->extension);
-		stat->n_uid = buf_get_int32(bufp);
-		stat->n_gid = buf_get_int32(bufp);
-		stat->n_muid = buf_get_int32(bufp);
-	}
-}
-
-/**
- * p9_deserialize_stat - decode a received metadata structure
- * @buf: buffer to deserialize
- * @buflen: length of received buffer
- * @stat: metadata structure to decode into
- * @dotu: non-zero if 9P2000.u
- *
- * Note: stat will point to the buf region.
- */
-
-int
-p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
-		int dotu)
-{
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-	unsigned char *p;
-
-	buf_init(bufp, buf, buflen);
-	p = bufp->p;
-	buf_get_stat(bufp, stat, dotu);
-
-	if (buf_check_overflow(bufp))
-		return 0;
-	else
-		return bufp->p - p;
-}
-EXPORT_SYMBOL(p9_deserialize_stat);
-
-/**
- * deserialize_fcall - unmarshal a response
- * @buf: recieved buffer
- * @buflen: length of received buffer
- * @rcall: fcall structure to populate
- * @rcalllen: length of fcall structure to populate
- * @dotu: non-zero if 9P2000.u
- *
- */
-
-int
-p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
-		       int dotu)
-{
-
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-	int i = 0;
-
-	buf_init(bufp, buf, buflen);
-
-	rcall->size = buf_get_int32(bufp);
-	rcall->id = buf_get_int8(bufp);
-	rcall->tag = buf_get_int16(bufp);
-
-	P9_DPRINTK(P9_DEBUG_CONV, "size %d id %d tag %d\n", rcall->size, rcall->id,
-		rcall->tag);
-
-	switch (rcall->id) {
-	default:
-		P9_EPRINTK(KERN_ERR, "unknown message type: %d\n", rcall->id);
-		return -EPROTO;
-	case P9_RVERSION:
-		rcall->params.rversion.msize = buf_get_int32(bufp);
-		buf_get_str(bufp, &rcall->params.rversion.version);
-		break;
-	case P9_RFLUSH:
-		break;
-	case P9_RATTACH:
-		rcall->params.rattach.qid.type = buf_get_int8(bufp);
-		rcall->params.rattach.qid.version = buf_get_int32(bufp);
-		rcall->params.rattach.qid.path = buf_get_int64(bufp);
-		break;
-	case P9_RWALK:
-		rcall->params.rwalk.nwqid = buf_get_int16(bufp);
-		if (rcall->params.rwalk.nwqid > P9_MAXWELEM) {
-			P9_EPRINTK(KERN_ERR, "Rwalk with more than %d qids: %d\n",
-				P9_MAXWELEM, rcall->params.rwalk.nwqid);
-			return -EPROTO;
-		}
-
-		for (i = 0; i < rcall->params.rwalk.nwqid; i++)
-			buf_get_qid(bufp, &rcall->params.rwalk.wqids[i]);
-		break;
-	case P9_ROPEN:
-		buf_get_qid(bufp, &rcall->params.ropen.qid);
-		rcall->params.ropen.iounit = buf_get_int32(bufp);
-		break;
-	case P9_RCREATE:
-		buf_get_qid(bufp, &rcall->params.rcreate.qid);
-		rcall->params.rcreate.iounit = buf_get_int32(bufp);
-		break;
-	case P9_RREAD:
-		rcall->params.rread.count = buf_get_int32(bufp);
-		rcall->params.rread.data = bufp->p;
-		buf_check_size(bufp, rcall->params.rread.count);
-		break;
-	case P9_RWRITE:
-		rcall->params.rwrite.count = buf_get_int32(bufp);
-		break;
-	case P9_RCLUNK:
-		break;
-	case P9_RREMOVE:
-		break;
-	case P9_RSTAT:
-		buf_get_int16(bufp);
-		buf_get_stat(bufp, &rcall->params.rstat.stat, dotu);
-		break;
-	case P9_RWSTAT:
-		break;
-	case P9_RERROR:
-		buf_get_str(bufp, &rcall->params.rerror.error);
-		if (dotu)
-			rcall->params.rerror.errno = buf_get_int16(bufp);
-		break;
-	}
-
-	if (buf_check_overflow(bufp)) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "buffer overflow\n");
-		return -EIO;
-	}
-
-	return bufp->p - bufp->sp;
-}
-EXPORT_SYMBOL(p9_deserialize_fcall);
-
-static inline void p9_put_int8(struct cbuf *bufp, u8 val, u8 * p)
-{
-	*p = val;
-	buf_put_int8(bufp, val);
-}
-
-static inline void p9_put_int16(struct cbuf *bufp, u16 val, u16 * p)
-{
-	*p = val;
-	buf_put_int16(bufp, val);
-}
-
-static inline void p9_put_int32(struct cbuf *bufp, u32 val, u32 * p)
-{
-	*p = val;
-	buf_put_int32(bufp, val);
-}
-
-static inline void p9_put_int64(struct cbuf *bufp, u64 val, u64 * p)
-{
-	*p = val;
-	buf_put_int64(bufp, val);
-}
-
-static void
-p9_put_str(struct cbuf *bufp, char *data, struct p9_str *str)
-{
-	int len;
-	char *s;
-
-	if (data)
-		len = strlen(data);
-	else
-		len = 0;
-
-	s = buf_put_stringn(bufp, data, len);
-	if (str) {
-		str->len = len;
-		str->str = s;
-	}
-}
-
-static int
-p9_put_data(struct cbuf *bufp, const char *data, int count,
-		   unsigned char **pdata)
-{
-	*pdata = buf_alloc(bufp, count);
-	memmove(*pdata, data, count);
-	return count;
-}
-
-static int
-p9_put_user_data(struct cbuf *bufp, const char __user * data, int count,
-		   unsigned char **pdata)
-{
-	*pdata = buf_alloc(bufp, count);
-	return copy_from_user(*pdata, data, count);
-}
-
-static void
-p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
-	       struct p9_stat *stat, int statsz, int dotu)
-{
-	p9_put_int16(bufp, statsz, &stat->size);
-	p9_put_int16(bufp, wstat->type, &stat->type);
-	p9_put_int32(bufp, wstat->dev, &stat->dev);
-	p9_put_int8(bufp, wstat->qid.type, &stat->qid.type);
-	p9_put_int32(bufp, wstat->qid.version, &stat->qid.version);
-	p9_put_int64(bufp, wstat->qid.path, &stat->qid.path);
-	p9_put_int32(bufp, wstat->mode, &stat->mode);
-	p9_put_int32(bufp, wstat->atime, &stat->atime);
-	p9_put_int32(bufp, wstat->mtime, &stat->mtime);
-	p9_put_int64(bufp, wstat->length, &stat->length);
-
-	p9_put_str(bufp, wstat->name, &stat->name);
-	p9_put_str(bufp, wstat->uid, &stat->uid);
-	p9_put_str(bufp, wstat->gid, &stat->gid);
-	p9_put_str(bufp, wstat->muid, &stat->muid);
-
-	if (dotu) {
-		p9_put_str(bufp, wstat->extension, &stat->extension);
-		p9_put_int32(bufp, wstat->n_uid, &stat->n_uid);
-		p9_put_int32(bufp, wstat->n_gid, &stat->n_gid);
-		p9_put_int32(bufp, wstat->n_muid, &stat->n_muid);
-	}
-}
-
-static struct p9_fcall *
-p9_create_common(struct cbuf *bufp, u32 size, u8 id)
-{
-	struct p9_fcall *fc;
-
-	size += 4 + 1 + 2;	/* size[4] id[1] tag[2] */
-	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
-	if (!fc)
-		return ERR_PTR(-ENOMEM);
-
-	fc->sdata = (char *)fc + sizeof(*fc);
-
-	buf_init(bufp, (char *)fc->sdata, size);
-	p9_put_int32(bufp, size, &fc->size);
-	p9_put_int8(bufp, id, &fc->id);
-	p9_put_int16(bufp, P9_NOTAG, &fc->tag);
-
-	return fc;
-}
-
-void p9_set_tag(struct p9_fcall *fc, u16 tag)
-{
-	fc->tag = tag;
-	*(__le16 *) (fc->sdata + 5) = cpu_to_le16(tag);
-}
-EXPORT_SYMBOL(p9_set_tag);
-
-struct p9_fcall *p9_create_tversion(u32 msize, char *version)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 2 + strlen(version);	/* msize[4] version[s] */
-	fc = p9_create_common(bufp, size, P9_TVERSION);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, msize, &fc->params.tversion.msize);
-	p9_put_str(bufp, version, &fc->params.tversion.version);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tversion);
-
-struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* afid[4]
uname[s] aname[s] */
-	fc = p9_create_common(bufp, size, P9_TAUTH);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, afid, &fc->params.tauth.afid);
-	p9_put_str(bufp, uname, &fc->params.tauth.uname);
-	p9_put_str(bufp, aname, &fc->params.tauth.aname);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tauth);
-
-struct p9_fcall *
-p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* fid[4]
afid[4] uname[s] aname[s] */
-	fc = p9_create_common(bufp, size, P9_TATTACH);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tattach.fid);
-	p9_put_int32(bufp, afid, &fc->params.tattach.afid);
-	p9_put_str(bufp, uname, &fc->params.tattach.uname);
-	p9_put_str(bufp, aname, &fc->params.tattach.aname);
-
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tattach);
-
-struct p9_fcall *p9_create_tflush(u16 oldtag)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 2;		/* oldtag[2] */
-	fc = p9_create_common(bufp, size, P9_TFLUSH);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int16(bufp, oldtag, &fc->params.tflush.oldtag);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tflush);
-
-struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
-				     char **wnames)
-{
-	int i, size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	if (nwname > P9_MAXWELEM) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "nwname > %d\n", P9_MAXWELEM);
-		return NULL;
-	}
-
-	size = 4 + 4 + 2;	/* fid[4] newfid[4] nwname[2] ... */
-	for (i = 0; i < nwname; i++) {
-		size += 2 + strlen(wnames[i]);	/* wname[s] */
-	}
-
-	fc = p9_create_common(bufp, size, P9_TWALK);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.twalk.fid);
-	p9_put_int32(bufp, newfid, &fc->params.twalk.newfid);
-	p9_put_int16(bufp, nwname, &fc->params.twalk.nwname);
-	for (i = 0; i < nwname; i++) {
-		p9_put_str(bufp, wnames[i], &fc->params.twalk.wnames[i]);
-	}
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_twalk);
-
-struct p9_fcall *p9_create_topen(u32 fid, u8 mode)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 1;		/* fid[4] mode[1] */
-	fc = p9_create_common(bufp, size, P9_TOPEN);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.topen.fid);
-	p9_put_int8(bufp, mode, &fc->params.topen.mode);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_topen);
-
-struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
-	char *extension, int dotu)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 2 + strlen(name) + 4 + 1;	/* fid[4] name[s] perm[4] mode[1] */
-	if (dotu) {
-		size += 2 +			/* extension[s] */
-		    (extension == NULL ? 0 : strlen(extension));
-	}
-
-	fc = p9_create_common(bufp, size, P9_TCREATE);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tcreate.fid);
-	p9_put_str(bufp, name, &fc->params.tcreate.name);
-	p9_put_int32(bufp, perm, &fc->params.tcreate.perm);
-	p9_put_int8(bufp, mode, &fc->params.tcreate.mode);
-	if (dotu)
-		p9_put_str(bufp, extension, &fc->params.tcreate.extension);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tcreate);
-
-struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 8 + 4;	/* fid[4] offset[8] count[4] */
-	fc = p9_create_common(bufp, size, P9_TREAD);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tread.fid);
-	p9_put_int64(bufp, offset, &fc->params.tread.offset);
-	p9_put_int32(bufp, count, &fc->params.tread.count);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tread);
-
-struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
-				      const char *data)
-{
-	int size, err;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
-	fc = p9_create_common(bufp, size, P9_TWRITE);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
-	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
-	p9_put_int32(bufp, count, &fc->params.twrite.count);
-	err = p9_put_data(bufp, data, count, &fc->params.twrite.data);
-	if (err) {
-		kfree(fc);
-		fc = ERR_PTR(err);
-	}
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_twrite);
-
-struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
-				      const char __user * data)
-{
-	int size, err;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
-	fc = p9_create_common(bufp, size, P9_TWRITE);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
-	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
-	p9_put_int32(bufp, count, &fc->params.twrite.count);
-	err = p9_put_user_data(bufp, data, count, &fc->params.twrite.data);
-	if (err) {
-		kfree(fc);
-		fc = ERR_PTR(err);
-	}
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_twrite_u);
-
-struct p9_fcall *p9_create_tclunk(u32 fid)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TCLUNK);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tclunk.fid);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tclunk);
-
-struct p9_fcall *p9_create_tremove(u32 fid)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TREMOVE);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tremove.fid);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tremove);
-
-struct p9_fcall *p9_create_tstat(u32 fid)
-{
-	int size;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	size = 4;		/* fid[4] */
-	fc = p9_create_common(bufp, size, P9_TSTAT);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.tstat.fid);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_tstat);
-
-struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
-				      int dotu)
-{
-	int size, statsz;
-	struct p9_fcall *fc;
-	struct cbuf buffer;
-	struct cbuf *bufp = &buffer;
-
-	statsz = p9_size_wstat(wstat, dotu);
-	size = 4 + 2 + 2 + statsz;	/* fid[4] stat[n] */
-	fc = p9_create_common(bufp, size, P9_TWSTAT);
-	if (IS_ERR(fc))
-		goto error;
-
-	p9_put_int32(bufp, fid, &fc->params.twstat.fid);
-	buf_put_int16(bufp, statsz + 2);
-	p9_put_wstat(bufp, wstat, &fc->params.twstat.stat, statsz, dotu);
-
-	if (buf_check_overflow(bufp)) {
-		kfree(fc);
-		fc = ERR_PTR(-ENOMEM);
-	}
-      error:
-	return fc;
-}
-EXPORT_SYMBOL(p9_create_twstat);
diff --git a/fs/9p/error.c b/fs/9p/error.c
deleted file mode 100644
index 53f2024..0000000
--- a/fs/9p/error.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * linux/fs/9p/error.c
- *
- * Error string handling
- *
- * Plan 9 uses error strings, Unix uses error numbers.  These functions
- * try to help manage that and provide for dynamically adding error
- * mappings.
- *
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/list.h>
-#include <linux/jhash.h>
-#include <linux/errno.h>
-#include <asm/errno.h>
-
-struct errormap {
-	char *name;
-	int val;
-
-	int namelen;
-	struct hlist_node list;
-};
-
-#define ERRHASHSZ		32
-static struct hlist_head hash_errmap[ERRHASHSZ];
-
-/* FixMe - reduce to a reasonable size */
-static struct errormap errmap[] = {
-	{"Operation not permitted", EPERM},
-	{"wstat prohibited", EPERM},
-	{"No such file or directory", ENOENT},
-	{"directory entry not found", ENOENT},
-	{"file not found", ENOENT},
-	{"Interrupted system call", EINTR},
-	{"Input/output error", EIO},
-	{"No such device or address", ENXIO},
-	{"Argument list too long", E2BIG},
-	{"Bad file descriptor", EBADF},
-	{"Resource temporarily unavailable", EAGAIN},
-	{"Cannot allocate memory", ENOMEM},
-	{"Permission denied", EACCES},
-	{"Bad address", EFAULT},
-	{"Block device required", ENOTBLK},
-	{"Device or resource busy", EBUSY},
-	{"File exists", EEXIST},
-	{"Invalid cross-device link", EXDEV},
-	{"No such device", ENODEV},
-	{"Not a directory", ENOTDIR},
-	{"Is a directory", EISDIR},
-	{"Invalid argument", EINVAL},
-	{"Too many open files in system", ENFILE},
-	{"Too many open files", EMFILE},
-	{"Text file busy", ETXTBSY},
-	{"File too large", EFBIG},
-	{"No space left on device", ENOSPC},
-	{"Illegal seek", ESPIPE},
-	{"Read-only file system", EROFS},
-	{"Too many links", EMLINK},
-	{"Broken pipe", EPIPE},
-	{"Numerical argument out of domain", EDOM},
-	{"Numerical result out of range", ERANGE},
-	{"Resource deadlock avoided", EDEADLK},
-	{"File name too long", ENAMETOOLONG},
-	{"No locks available", ENOLCK},
-	{"Function not implemented", ENOSYS},
-	{"Directory not empty", ENOTEMPTY},
-	{"Too many levels of symbolic links", ELOOP},
-	{"No message of desired type", ENOMSG},
-	{"Identifier removed", EIDRM},
-	{"No data available", ENODATA},
-	{"Machine is not on the network", ENONET},
-	{"Package not installed", ENOPKG},
-	{"Object is remote", EREMOTE},
-	{"Link has been severed", ENOLINK},
-	{"Communication error on send", ECOMM},
-	{"Protocol error", EPROTO},
-	{"Bad message", EBADMSG},
-	{"File descriptor in bad state", EBADFD},
-	{"Streams pipe error", ESTRPIPE},
-	{"Too many users", EUSERS},
-	{"Socket operation on non-socket", ENOTSOCK},
-	{"Message too long", EMSGSIZE},
-	{"Protocol not available", ENOPROTOOPT},
-	{"Protocol not supported", EPROTONOSUPPORT},
-	{"Socket type not supported", ESOCKTNOSUPPORT},
-	{"Operation not supported", EOPNOTSUPP},
-	{"Protocol family not supported", EPFNOSUPPORT},
-	{"Network is down", ENETDOWN},
-	{"Network is unreachable", ENETUNREACH},
-	{"Network dropped connection on reset", ENETRESET},
-	{"Software caused connection abort", ECONNABORTED},
-	{"Connection reset by peer", ECONNRESET},
-	{"No buffer space available", ENOBUFS},
-	{"Transport endpoint is already connected", EISCONN},
-	{"Transport endpoint is not connected", ENOTCONN},
-	{"Cannot send after transport endpoint shutdown", ESHUTDOWN},
-	{"Connection timed out", ETIMEDOUT},
-	{"Connection refused", ECONNREFUSED},
-	{"Host is down", EHOSTDOWN},
-	{"No route to host", EHOSTUNREACH},
-	{"Operation already in progress", EALREADY},
-	{"Operation now in progress", EINPROGRESS},
-	{"Is a named type file", EISNAM},
-	{"Remote I/O error", EREMOTEIO},
-	{"Disk quota exceeded", EDQUOT},
-/* errors from fossil, vacfs, and u9fs */
-	{"fid unknown or out of range", EBADF},
-	{"permission denied", EACCES},
-	{"file does not exist", ENOENT},
-	{"authentication failed", ECONNREFUSED},
-	{"bad offset in directory read", ESPIPE},
-	{"bad use of fid", EBADF},
-	{"wstat can't convert between files and directories", EPERM},
-	{"directory is not empty", ENOTEMPTY},
-	{"file exists", EEXIST},
-	{"file already exists", EEXIST},
-	{"file or directory already exists", EEXIST},
-	{"fid already in use", EBADF},
-	{"file in use", ETXTBSY},
-	{"i/o error", EIO},
-	{"file already open for I/O", ETXTBSY},
-	{"illegal mode", EINVAL},
-	{"illegal name", ENAMETOOLONG},
-	{"not a directory", ENOTDIR},
-	{"not a member of proposed group", EPERM},
-	{"not owner", EACCES},
-	{"only owner can change group in wstat", EACCES},
-	{"read only file system", EROFS},
-	{"no access to special file", EPERM},
-	{"i/o count too large", EIO},
-	{"unknown group", EINVAL},
-	{"unknown user", EINVAL},
-	{"bogus wstat buffer", EPROTO},
-	{"exclusive use file already open", EAGAIN},
-	{"corrupted directory entry", EIO},
-	{"corrupted file entry", EIO},
-	{"corrupted block label", EIO},
-	{"corrupted meta data", EIO},
-	{"illegal offset", EINVAL},
-	{"illegal path element", ENOENT},
-	{"root of file system is corrupted", EIO},
-	{"corrupted super block", EIO},
-	{"protocol botch", EPROTO},
-	{"file system is full", ENOSPC},
-	{"file is in use", EAGAIN},
-	{"directory entry is not allocated", ENOENT},
-	{"file is read only", EROFS},
-	{"file has been removed", EIDRM},
-	{"only support truncation to zero length", EPERM},
-	{"cannot remove root", EPERM},
-	{"file too big", EFBIG},
-	{"venti i/o error", EIO},
-	/* these are not errors */
-	{"u9fs rhostsauth: no authentication required", 0},
-	{"u9fs authnone: no authentication required", 0},
-	{NULL, -1}
-};
-
-/**
- * p9_error_init - preload
- * @errstr: error string
- *
- */
-
-int p9_error_init(void)
-{
-	struct errormap *c;
-	int bucket;
-
-	/* initialize hash table */
-	for (bucket = 0; bucket < ERRHASHSZ; bucket++)
-		INIT_HLIST_HEAD(&hash_errmap[bucket]);
-
-	/* load initial error map into hash table */
-	for (c = errmap; c->name != NULL; c++) {
-		c->namelen = strlen(c->name);
-		bucket = jhash(c->name, c->namelen, 0) % ERRHASHSZ;
-		INIT_HLIST_NODE(&c->list);
-		hlist_add_head(&c->list, &hash_errmap[bucket]);
-	}
-
-	return 1;
-}
-EXPORT_SYMBOL(p9_error_init);
-
-/**
- * errstr2errno - convert error string to error number
- * @errstr: error string
- *
- */
-
-int p9_errstr2errno(char *errstr, int len)
-{
-	int errno;
-	struct hlist_node *p;
-	struct errormap *c;
-	int bucket;
-
-	errno = 0;
-	p = NULL;
-	c = NULL;
-	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
-	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
-		if (c->namelen==len && !memcmp(c->name, errstr, len)) {
-			errno = c->val;
-			break;
-		}
-	}
-
-	if (errno == 0) {
-		/* TODO: if error isn't found, add it dynamically */
-		errstr[len] = 0;
-		printk(KERN_ERR "%s: errstr :%s: not found\n", __FUNCTION__,
-		       errstr);
-		errno = 1;
-	}
-
-	return -errno;
-}
-EXPORT_SYMBOL(p9_errstr2errno);
diff --git a/fs/9p/fcprint.c b/fs/9p/fcprint.c
deleted file mode 100644
index 9fc29fe..0000000
--- a/fs/9p/fcprint.c
+++ /dev/null
@@ -1,353 +0,0 @@
-/*
- *  net/9p/fcprint.c
- *
- *  Print 9P call.
- *
- *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/idr.h>
-#include <net/9p/9p.h>
-
-#ifdef CONFIG_NET_9P_DEBUG
-
-static int
-p9_printqid(char *buf, int buflen, struct p9_qid *q)
-{
-	int n;
-	char b[10];
-
-	n = 0;
-	if (q->type & P9_QTDIR)
-		b[n++] = 'd';
-	if (q->type & P9_QTAPPEND)
-		b[n++] = 'a';
-	if (q->type & P9_QTAUTH)
-		b[n++] = 'A';
-	if (q->type & P9_QTEXCL)
-		b[n++] = 'l';
-	if (q->type & P9_QTTMP)
-		b[n++] = 't';
-	if (q->type & P9_QTSYMLINK)
-		b[n++] = 'L';
-	b[n] = '\0';
-
-	return scnprintf(buf, buflen, "(%.16llx %x %s)", (long long int) q->path,
-		q->version, b);
-}
-
-static int
-p9_printperm(char *buf, int buflen, int perm)
-{
-	int n;
-	char b[15];
-
-	n = 0;
-	if (perm & P9_DMDIR)
-		b[n++] = 'd';
-	if (perm & P9_DMAPPEND)
-		b[n++] = 'a';
-	if (perm & P9_DMAUTH)
-		b[n++] = 'A';
-	if (perm & P9_DMEXCL)
-		b[n++] = 'l';
-	if (perm & P9_DMTMP)
-		b[n++] = 't';
-	if (perm & P9_DMDEVICE)
-		b[n++] = 'D';
-	if (perm & P9_DMSOCKET)
-		b[n++] = 'S';
-	if (perm & P9_DMNAMEDPIPE)
-		b[n++] = 'P';
-	if (perm & P9_DMSYMLINK)
-		b[n++] = 'L';
-	b[n] = '\0';
-
-	return scnprintf(buf, buflen, "%s%03o", b, perm&077);
-}
-
-static int
-p9_printstat(char *buf, int buflen, struct p9_stat *st, int extended)
-{
-	int n;
-
-	n = scnprintf(buf, buflen, "'%.*s' '%.*s'", st->name.len,
-		st->name.str, st->uid.len, st->uid.str);
-	if (extended)
-		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_uid);
-
-	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->gid.len, st->gid.str);
-	if (extended)
-		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_gid);
-
-	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->muid.len, st->muid.str);
-	if (extended)
-		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_muid);
-
-	n += scnprintf(buf+n, buflen-n, " q ");
-	n += p9_printqid(buf+n, buflen-n, &st->qid);
-	n += scnprintf(buf+n, buflen-n, " m ");
-	n += p9_printperm(buf+n, buflen-n, st->mode);
-	n += scnprintf(buf+n, buflen-n, " at %d mt %d l %lld",
-		st->atime, st->mtime, (long long int) st->length);
-
-	if (extended)
-		n += scnprintf(buf+n, buflen-n, " ext '%.*s'",
-			st->extension.len, st->extension.str);
-
-	return n;
-}
-
-static int
-p9_dumpdata(char *buf, int buflen, u8 *data, int datalen)
-{
-	int i, n;
-
-	i = n = 0;
-	while (i < datalen) {
-		n += scnprintf(buf + n, buflen - n, "%02x", data[i]);
-		if (i%4 == 3)
-			n += scnprintf(buf + n, buflen - n, " ");
-		if (i%32 == 31)
-			n += scnprintf(buf + n, buflen - n, "\n");
-
-		i++;
-	}
-	n += scnprintf(buf + n, buflen - n, "\n");
-
-	return n;
-}
-
-static int
-p9_printdata(char *buf, int buflen, u8 *data, int datalen)
-{
-	return p9_dumpdata(buf, buflen, data, datalen<16?datalen:16);
-}
-
-int
-p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
-{
-	int i, ret, type, tag;
-
-	if (!fc)
-		return scnprintf(buf, buflen, "<NULL>");
-
-	type = fc->id;
-	tag = fc->tag;
-
-	ret = 0;
-	switch (type) {
-	case P9_TVERSION:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Tversion tag %u msize %u version '%.*s'", tag,
-			fc->params.tversion.msize, fc->params.tversion.version.len,
-			fc->params.tversion.version.str);
-		break;
-
-	case P9_RVERSION:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Rversion tag %u msize %u version '%.*s'", tag,
-			fc->params.rversion.msize, fc->params.rversion.version.len,
-			fc->params.rversion.version.str);
-		break;
-
-	case P9_TAUTH:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Tauth tag %u afid %d uname '%.*s' aname '%.*s'", tag,
-			fc->params.tauth.afid, fc->params.tauth.uname.len,
-			fc->params.tauth.uname.str, fc->params.tauth.aname.len,
-			fc->params.tauth.aname.str);
-		break;
-
-	case P9_RAUTH:
-		ret += scnprintf(buf+ret, buflen-ret, "Rauth tag %u qid ", tag);
-		p9_printqid(buf+ret, buflen-ret, &fc->params.rauth.qid);
-		break;
-
-	case P9_TATTACH:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Tattach tag %u fid %d afid %d uname '%.*s' aname '%.*s'",
-			tag, fc->params.tattach.fid, fc->params.tattach.afid,
-			fc->params.tattach.uname.len, fc->params.tattach.uname.str,
-			fc->params.tattach.aname.len, fc->params.tattach.aname.str);
-		break;
-
-	case P9_RATTACH:
-		ret += scnprintf(buf+ret, buflen-ret, "Rattach tag %u qid ", tag);
-		p9_printqid(buf+ret, buflen-ret, &fc->params.rattach.qid);
-		break;
-
-	case P9_RERROR:
-		ret += scnprintf(buf+ret, buflen-ret, "Rerror tag %u ename '%.*s'",
-			tag, fc->params.rerror.error.len,
-			fc->params.rerror.error.str);
-		if (extended)
-			ret += scnprintf(buf+ret, buflen-ret, " ecode %d\n",
-				fc->params.rerror.errno);
-		break;
-
-	case P9_TFLUSH:
-		ret += scnprintf(buf+ret, buflen-ret, "Tflush tag %u oldtag %u",
-			tag, fc->params.tflush.oldtag);
-		break;
-
-	case P9_RFLUSH:
-		ret += scnprintf(buf+ret, buflen-ret, "Rflush tag %u", tag);
-		break;
-
-	case P9_TWALK:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Twalk tag %u fid %d newfid %d nwname %d", tag,
-			fc->params.twalk.fid, fc->params.twalk.newfid,
-			fc->params.twalk.nwname);
-		for(i = 0; i < fc->params.twalk.nwname; i++)
-			ret += scnprintf(buf+ret, buflen-ret," '%.*s'",
-				fc->params.twalk.wnames[i].len,
-				fc->params.twalk.wnames[i].str);
-		break;
-
-	case P9_RWALK:
-		ret += scnprintf(buf+ret, buflen-ret, "Rwalk tag %u nwqid %d",
-			tag, fc->params.rwalk.nwqid);
-		for(i = 0; i < fc->params.rwalk.nwqid; i++)
-			ret += p9_printqid(buf+ret, buflen-ret,
-				&fc->params.rwalk.wqids[i]);
-		break;
-
-	case P9_TOPEN:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Topen tag %u fid %d mode %d", tag,
-			fc->params.topen.fid, fc->params.topen.mode);
-		break;
-
-	case P9_ROPEN:
-		ret += scnprintf(buf+ret, buflen-ret, "Ropen tag %u", tag);
-		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.ropen.qid);
-		ret += scnprintf(buf+ret, buflen-ret," iounit %d",
-			fc->params.ropen.iounit);
-		break;
-
-	case P9_TCREATE:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Tcreate tag %u fid %d name '%.*s' perm ", tag,
-			fc->params.tcreate.fid, fc->params.tcreate.name.len,
-			fc->params.tcreate.name.str);
-
-		ret += p9_printperm(buf+ret, buflen-ret, fc->params.tcreate.perm);
-		ret += scnprintf(buf+ret, buflen-ret, " mode %d",
-			fc->params.tcreate.mode);
-		break;
-
-	case P9_RCREATE:
-		ret += scnprintf(buf+ret, buflen-ret, "Rcreate tag %u", tag);
-		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.rcreate.qid);
-		ret += scnprintf(buf+ret, buflen-ret, " iounit %d",
-			fc->params.rcreate.iounit);
-		break;
-
-	case P9_TREAD:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Tread tag %u fid %d offset %lld count %u", tag,
-			fc->params.tread.fid,
-			(long long int) fc->params.tread.offset,
-			fc->params.tread.count);
-		break;
-
-	case P9_RREAD:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Rread tag %u count %u data ", tag,
-			fc->params.rread.count);
-		ret += p9_printdata(buf+ret, buflen-ret, fc->params.rread.data,
-			fc->params.rread.count);
-		break;
-
-	case P9_TWRITE:
-		ret += scnprintf(buf+ret, buflen-ret,
-			"Twrite tag %u fid %d offset %lld count %u data ",
-			tag, fc->params.twrite.fid,
-			(long long int) fc->params.twrite.offset,
-			fc->params.twrite.count);
-		ret += p9_printdata(buf+ret, buflen-ret, fc->params.twrite.data,
-			fc->params.twrite.count);
-		break;
-
-	case P9_RWRITE:
-		ret += scnprintf(buf+ret, buflen-ret, "Rwrite tag %u count %u",
-			tag, fc->params.rwrite.count);
-		break;
-
-	case P9_TCLUNK:
-		ret += scnprintf(buf+ret, buflen-ret, "Tclunk tag %u fid %d",
-			tag, fc->params.tclunk.fid);
-		break;
-
-	case P9_RCLUNK:
-		ret += scnprintf(buf+ret, buflen-ret, "Rclunk tag %u", tag);
-		break;
-
-	case P9_TREMOVE:
-		ret += scnprintf(buf+ret, buflen-ret, "Tremove tag %u fid %d",
-			tag, fc->params.tremove.fid);
-		break;
-
-	case P9_RREMOVE:
-		ret += scnprintf(buf+ret, buflen-ret, "Rremove tag %u", tag);
-		break;
-
-	case P9_TSTAT:
-		ret += scnprintf(buf+ret, buflen-ret, "Tstat tag %u fid %d",
-			tag, fc->params.tstat.fid);
-		break;
-
-	case P9_RSTAT:
-		ret += scnprintf(buf+ret, buflen-ret, "Rstat tag %u ", tag);
-		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.rstat.stat,
-			extended);
-		break;
-
-	case P9_TWSTAT:
-		ret += scnprintf(buf+ret, buflen-ret, "Twstat tag %u fid %d ",
-			tag, fc->params.twstat.fid);
-		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.twstat.stat,
-			extended);
-		break;
-
-	case P9_RWSTAT:
-		ret += scnprintf(buf+ret, buflen-ret, "Rwstat tag %u", tag);
-		break;
-
-	default:
-		ret += scnprintf(buf+ret, buflen-ret, "unknown type %d", type);
-		break;
-	}
-
-	return ret;
-}
-
-#else
-int
-p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
-{
-	return 0;
-}
-#endif /* CONFIG_NET_9P_DEBUG */
-
-EXPORT_SYMBOL(p9_printfcall);
diff --git a/fs/9p/mux.c b/fs/9p/mux.c
deleted file mode 100644
index 2436e93..0000000
--- a/fs/9p/mux.c
+++ /dev/null
@@ -1,1041 +0,0 @@
-/*
- * net/9p/mux.c
- *
- * Protocol Multiplexer
- *
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/poll.h>
-#include <linux/kthread.h>
-#include <linux/idr.h>
-#include <linux/mutex.h>
-#include <net/9p/9p.h>
-#include <net/9p/transport.h>
-#include <net/9p/conn.h>
-
-#define ERREQFLUSH	1
-#define SCHED_TIMEOUT	10
-#define MAXPOLLWADDR	2
-
-enum {
-	Rworksched = 1,		/* read work scheduled or running */
-	Rpending = 2,		/* can read */
-	Wworksched = 4,		/* write work scheduled or running */
-	Wpending = 8,		/* can write */
-};
-
-enum {
-	None,
-	Flushing,
-	Flushed,
-};
-
-struct p9_mux_poll_task;
-
-struct p9_req {
-	spinlock_t lock;
-	int tag;
-	struct p9_fcall *tcall;
-	struct p9_fcall *rcall;
-	int err;
-	p9_conn_req_callback cb;
-	void *cba;
-	int flush;
-	struct list_head req_list;
-};
-
-struct p9_conn {
-	spinlock_t lock;
-	struct list_head mux_list;
-	struct p9_mux_poll_task *poll_task;
-	int msize;
-	unsigned char *extended;
-	struct p9_transport *trans;
-	struct p9_idpool *tagpool;
-	int err;
-	wait_queue_head_t equeue;
-	struct list_head req_list;
-	struct list_head unsent_req_list;
-	struct p9_fcall *rcall;
-	int rpos;
-	char *rbuf;
-	int wpos;
-	int wsize;
-	char *wbuf;
-	wait_queue_t poll_wait[MAXPOLLWADDR];
-	wait_queue_head_t *poll_waddr[MAXPOLLWADDR];
-	poll_table pt;
-	struct work_struct rq;
-	struct work_struct wq;
-	unsigned long wsched;
-};
-
-struct p9_mux_poll_task {
-	struct task_struct *task;
-	struct list_head mux_list;
-	int muxnum;
-};
-
-struct p9_mux_rpc {
-	struct p9_conn *m;
-	int err;
-	struct p9_fcall *tcall;
-	struct p9_fcall *rcall;
-	wait_queue_head_t wqueue;
-};
-
-static int p9_poll_proc(void *);
-static void p9_read_work(struct work_struct *work);
-static void p9_write_work(struct work_struct *work);
-static void p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
-			  poll_table * p);
-static u16 p9_mux_get_tag(struct p9_conn *);
-static void p9_mux_put_tag(struct p9_conn *, u16);
-
-static DEFINE_MUTEX(p9_mux_task_lock);
-static struct workqueue_struct *p9_mux_wq;
-
-static int p9_mux_num;
-static int p9_mux_poll_task_num;
-static struct p9_mux_poll_task p9_mux_poll_tasks[100];
-
-int p9_mux_global_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
-		p9_mux_poll_tasks[i].task = NULL;
-
-	p9_mux_wq = create_workqueue("v9fs");
-	if (!p9_mux_wq) {
-		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-void p9_mux_global_exit(void)
-{
-	destroy_workqueue(p9_mux_wq);
-}
-
-/**
- * p9_mux_calc_poll_procs - calculates the number of polling procs
- * based on the number of mounted v9fs filesystems.
- *
- * The current implementation returns sqrt of the number of mounts.
- */
-static int p9_mux_calc_poll_procs(int muxnum)
-{
-	int n;
-
-	if (p9_mux_poll_task_num)
-		n = muxnum / p9_mux_poll_task_num +
-		    (muxnum % p9_mux_poll_task_num ? 1 : 0);
-	else
-		n = 1;
-
-	if (n > ARRAY_SIZE(p9_mux_poll_tasks))
-		n = ARRAY_SIZE(p9_mux_poll_tasks);
-
-	return n;
-}
-
-static int p9_mux_poll_start(struct p9_conn *m)
-{
-	int i, n;
-	struct p9_mux_poll_task *vpt, *vptlast;
-	struct task_struct *pproc;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p muxnum %d procnum %d\n", m, p9_mux_num,
-		p9_mux_poll_task_num);
-	mutex_lock(&p9_mux_task_lock);
-
-	n = p9_mux_calc_poll_procs(p9_mux_num + 1);
-	if (n > p9_mux_poll_task_num) {
-		for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
-			if (p9_mux_poll_tasks[i].task == NULL) {
-				vpt = &p9_mux_poll_tasks[i];
-				P9_DPRINTK(P9_DEBUG_MUX, "create proc %p\n", vpt);
-				pproc = kthread_create(p9_poll_proc, vpt,
-						   "v9fs-poll");
-
-				if (!IS_ERR(pproc)) {
-					vpt->task = pproc;
-					INIT_LIST_HEAD(&vpt->mux_list);
-					vpt->muxnum = 0;
-					p9_mux_poll_task_num++;
-					wake_up_process(vpt->task);
-				}
-				break;
-			}
-		}
-
-		if (i >= ARRAY_SIZE(p9_mux_poll_tasks))
-			P9_DPRINTK(P9_DEBUG_ERROR, "warning: no free poll slots\n");
-	}
-
-	n = (p9_mux_num + 1) / p9_mux_poll_task_num +
-	    ((p9_mux_num + 1) % p9_mux_poll_task_num ? 1 : 0);
-
-	vptlast = NULL;
-	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
-		vpt = &p9_mux_poll_tasks[i];
-		if (vpt->task != NULL) {
-			vptlast = vpt;
-			if (vpt->muxnum < n) {
-				P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
-				list_add(&m->mux_list, &vpt->mux_list);
-				vpt->muxnum++;
-				m->poll_task = vpt;
-				memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-				init_poll_funcptr(&m->pt, p9_pollwait);
-				break;
-			}
-		}
-	}
-
-	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL)
-			return -ENOMEM;
-
-		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
-		list_add(&m->mux_list, &vptlast->mux_list);
-		vptlast->muxnum++;
-		m->poll_task = vptlast;
-		memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-		init_poll_funcptr(&m->pt, p9_pollwait);
-	}
-
-	p9_mux_num++;
-	mutex_unlock(&p9_mux_task_lock);
-
-	return 0;
-}
-
-static void p9_mux_poll_stop(struct p9_conn *m)
-{
-	int i;
-	struct p9_mux_poll_task *vpt;
-
-	mutex_lock(&p9_mux_task_lock);
-	vpt = m->poll_task;
-	list_del(&m->mux_list);
-	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (m->poll_waddr[i] != NULL) {
-			remove_wait_queue(m->poll_waddr[i], &m->poll_wait[i]);
-			m->poll_waddr[i] = NULL;
-		}
-	}
-	vpt->muxnum--;
-	if (!vpt->muxnum) {
-		P9_DPRINTK(P9_DEBUG_MUX, "destroy proc %p\n", vpt);
-		kthread_stop(vpt->task);
-		vpt->task = NULL;
-		p9_mux_poll_task_num--;
-	}
-	p9_mux_num--;
-	mutex_unlock(&p9_mux_task_lock);
-}
-
-/**
- * p9_conn_create - allocate and initialize the per-session mux data
- * Creates the polling task if this is the first session.
- *
- * @trans - transport structure
- * @msize - maximum message size
- * @extended - pointer to the extended flag
- */
-struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
-				    unsigned char *extended)
-{
-	int i, n;
-	struct p9_conn *m, *mtmp;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans, msize);
-	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
-	if (!m)
-		return ERR_PTR(-ENOMEM);
-
-	spin_lock_init(&m->lock);
-	INIT_LIST_HEAD(&m->mux_list);
-	m->msize = msize;
-	m->extended = extended;
-	m->trans = trans;
-	m->tagpool = p9_idpool_create();
-	if (!m->tagpool) {
-		kfree(m);
-		return ERR_PTR(PTR_ERR(m->tagpool));
-	}
-
-	m->err = 0;
-	init_waitqueue_head(&m->equeue);
-	INIT_LIST_HEAD(&m->req_list);
-	INIT_LIST_HEAD(&m->unsent_req_list);
-	m->rcall = NULL;
-	m->rpos = 0;
-	m->rbuf = NULL;
-	m->wpos = m->wsize = 0;
-	m->wbuf = NULL;
-	INIT_WORK(&m->rq, p9_read_work);
-	INIT_WORK(&m->wq, p9_write_work);
-	m->wsched = 0;
-	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-	m->poll_task = NULL;
-	n = p9_mux_poll_start(m);
-	if (n)
-		return ERR_PTR(n);
-
-	n = trans->poll(trans, &m->pt);
-	if (n & POLLIN) {
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
-		set_bit(Rpending, &m->wsched);
-	}
-
-	if (n & POLLOUT) {
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
-		set_bit(Wpending, &m->wsched);
-	}
-
-	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
-		if (IS_ERR(m->poll_waddr[i])) {
-			p9_mux_poll_stop(m);
-			mtmp = (void *)m->poll_waddr;	/* the error code */
-			kfree(m);
-			m = mtmp;
-			break;
-		}
-	}
-
-	return m;
-}
-EXPORT_SYMBOL(p9_conn_create);
-
-/**
- * p9_mux_destroy - cancels all pending requests and frees mux resources
- */
-void p9_conn_destroy(struct p9_conn *m)
-{
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
-		m->mux_list.prev, m->mux_list.next);
-	p9_conn_cancel(m, -ECONNRESET);
-
-	if (!list_empty(&m->req_list)) {
-		/* wait until all processes waiting on this session exit */
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p waiting for empty request queue\n",
-			m);
-		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
-			list_empty(&m->req_list));
-	}
-
-	p9_mux_poll_stop(m);
-	m->trans = NULL;
-	p9_idpool_destroy(m->tagpool);
-	kfree(m);
-}
-EXPORT_SYMBOL(p9_conn_destroy);
-
-/**
- * p9_pollwait - called by files poll operation to add v9fs-poll task
- * 	to files wait queue
- */
-static void
-p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
-	      poll_table * p)
-{
-	int i;
-	struct p9_conn *m;
-
-	m = container_of(p, struct p9_conn, pt);
-	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++)
-		if (m->poll_waddr[i] == NULL)
-			break;
-
-	if (i >= ARRAY_SIZE(m->poll_waddr)) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
-		return;
-	}
-
-	m->poll_waddr[i] = wait_address;
-
-	if (!wait_address) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
-		m->poll_waddr[i] = ERR_PTR(-EIO);
-		return;
-	}
-
-	init_waitqueue_entry(&m->poll_wait[i], m->poll_task->task);
-	add_wait_queue(wait_address, &m->poll_wait[i]);
-}
-
-/**
- * p9_poll_mux - polls a mux and schedules read or write works if necessary
- */
-static void p9_poll_mux(struct p9_conn *m)
-{
-	int n;
-
-	if (m->err < 0)
-		return;
-
-	n = m->trans->poll(m->trans, NULL);
-	if (n < 0 || n & (POLLERR | POLLHUP | POLLNVAL)) {
-		P9_DPRINTK(P9_DEBUG_MUX, "error mux %p err %d\n", m, n);
-		if (n >= 0)
-			n = -ECONNRESET;
-		p9_conn_cancel(m, n);
-	}
-
-	if (n & POLLIN) {
-		set_bit(Rpending, &m->wsched);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
-		if (!test_and_set_bit(Rworksched, &m->wsched)) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
-		}
-	}
-
-	if (n & POLLOUT) {
-		set_bit(Wpending, &m->wsched);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
-		if ((m->wsize || !list_empty(&m->unsent_req_list))
-		    && !test_and_set_bit(Wworksched, &m->wsched)) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
-		}
-	}
-}
-
-/**
- * p9_poll_proc - polls all v9fs transports for new events and queues
- * 	the appropriate work to the work queue
- */
-static int p9_poll_proc(void *a)
-{
-	struct p9_conn *m, *mtmp;
-	struct p9_mux_poll_task *vpt;
-
-	vpt = a;
-	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
-			p9_poll_mux(m);
-		}
-
-		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
-		schedule_timeout(SCHED_TIMEOUT * HZ);
-	}
-
-	__set_current_state(TASK_RUNNING);
-	P9_DPRINTK(P9_DEBUG_MUX, "finish\n");
-	return 0;
-}
-
-/**
- * p9_write_work - called when a transport can send some data
- */
-static void p9_write_work(struct work_struct *work)
-{
-	int n, err;
-	struct p9_conn *m;
-	struct p9_req *req;
-
-	m = container_of(work, struct p9_conn, wq);
-
-	if (m->err < 0) {
-		clear_bit(Wworksched, &m->wsched);
-		return;
-	}
-
-	if (!m->wsize) {
-		if (list_empty(&m->unsent_req_list)) {
-			clear_bit(Wworksched, &m->wsched);
-			return;
-		}
-
-		spin_lock(&m->lock);
-again:
-		req = list_entry(m->unsent_req_list.next, struct p9_req,
-			       req_list);
-		list_move_tail(&req->req_list, &m->req_list);
-		if (req->err == ERREQFLUSH)
-			goto again;
-
-		m->wbuf = req->tcall->sdata;
-		m->wsize = req->tcall->size;
-		m->wpos = 0;
-		spin_unlock(&m->lock);
-	}
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p pos %d size %d\n", m, m->wpos, m->wsize);
-	clear_bit(Wpending, &m->wsched);
-	err = m->trans->write(m->trans, m->wbuf + m->wpos, m->wsize - m->wpos);
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p sent %d bytes\n", m, err);
-	if (err == -EAGAIN) {
-		clear_bit(Wworksched, &m->wsched);
-		return;
-	}
-
-	if (err <= 0)
-		goto error;
-
-	m->wpos += err;
-	if (m->wpos == m->wsize)
-		m->wpos = m->wsize = 0;
-
-	if (m->wsize == 0 && !list_empty(&m->unsent_req_list)) {
-		if (test_and_clear_bit(Wpending, &m->wsched))
-			n = POLLOUT;
-		else
-			n = m->trans->poll(m->trans, NULL);
-
-		if (n & POLLOUT) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
-			queue_work(p9_mux_wq, &m->wq);
-		} else
-			clear_bit(Wworksched, &m->wsched);
-	} else
-		clear_bit(Wworksched, &m->wsched);
-
-	return;
-
-      error:
-	p9_conn_cancel(m, err);
-	clear_bit(Wworksched, &m->wsched);
-}
-
-static void process_request(struct p9_conn *m, struct p9_req *req)
-{
-	int ecode;
-	struct p9_str *ename;
-
-	if (!req->err && req->rcall->id == P9_RERROR) {
-		ecode = req->rcall->params.rerror.errno;
-		ename = &req->rcall->params.rerror.error;
-
-		P9_DPRINTK(P9_DEBUG_MUX, "Rerror %.*s\n", ename->len, ename->str);
-
-		if (*m->extended)
-			req->err = -ecode;
-
-		if (!req->err) {
-			req->err = p9_errstr2errno(ename->str, ename->len);
-
-			if (!req->err) {	/* string match failed */
-				PRINT_FCALL_ERROR("unknown error", req->rcall);
-			}
-
-			if (!req->err)
-				req->err = -ESERVERFAULT;
-		}
-	} else if (req->tcall && req->rcall->id != req->tcall->id + 1) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "fcall mismatch: expected %d, got %d\n",
-			req->tcall->id + 1, req->rcall->id);
-		if (!req->err)
-			req->err = -EIO;
-	}
-}
-
-/**
- * p9_read_work - called when there is some data to be read from a transport
- */
-static void p9_read_work(struct work_struct *work)
-{
-	int n, err;
-	struct p9_conn *m;
-	struct p9_req *req, *rptr, *rreq;
-	struct p9_fcall *rcall;
-	char *rbuf;
-
-	m = container_of(work, struct p9_conn, rq);
-
-	if (m->err < 0)
-		return;
-
-	rcall = NULL;
-	P9_DPRINTK(P9_DEBUG_MUX, "start mux %p pos %d\n", m, m->rpos);
-
-	if (!m->rcall) {
-		m->rcall =
-		    kmalloc(sizeof(struct p9_fcall) + m->msize, GFP_KERNEL);
-		if (!m->rcall) {
-			err = -ENOMEM;
-			goto error;
-		}
-
-		m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
-		m->rpos = 0;
-	}
-
-	clear_bit(Rpending, &m->wsched);
-	err = m->trans->read(m->trans, m->rbuf + m->rpos, m->msize - m->rpos);
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p got %d bytes\n", m, err);
-	if (err == -EAGAIN) {
-		clear_bit(Rworksched, &m->wsched);
-		return;
-	}
-
-	if (err <= 0)
-		goto error;
-
-	m->rpos += err;
-	while (m->rpos > 4) {
-		n = le32_to_cpu(*(__le32 *) m->rbuf);
-		if (n >= m->msize) {
-			P9_DPRINTK(P9_DEBUG_ERROR,
-				"requested packet size too big: %d\n", n);
-			err = -EIO;
-			goto error;
-		}
-
-		if (m->rpos < n)
-			break;
-
-		err =
-		    p9_deserialize_fcall(m->rbuf, n, m->rcall, *m->extended);
-		if (err < 0) {
-			goto error;
-		}
-
-#ifdef CONFIG_NET_9P_DEBUG
-		if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
-			char buf[150];
-
-			p9_printfcall(buf, sizeof(buf), m->rcall,
-				*m->extended);
-			printk(KERN_NOTICE ">>> %p %s\n", m, buf);
-		}
-#endif
-
-		rcall = m->rcall;
-		rbuf = m->rbuf;
-		if (m->rpos > n) {
-			m->rcall = kmalloc(sizeof(struct p9_fcall) + m->msize,
-					   GFP_KERNEL);
-			if (!m->rcall) {
-				err = -ENOMEM;
-				goto error;
-			}
-
-			m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
-			memmove(m->rbuf, rbuf + n, m->rpos - n);
-			m->rpos -= n;
-		} else {
-			m->rcall = NULL;
-			m->rbuf = NULL;
-			m->rpos = 0;
-		}
-
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p fcall id %d tag %d\n", m, rcall->id,
-			rcall->tag);
-
-		req = NULL;
-		spin_lock(&m->lock);
-		list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
-			if (rreq->tag == rcall->tag) {
-				req = rreq;
-				if (req->flush != Flushing)
-					list_del(&req->req_list);
-				break;
-			}
-		}
-		spin_unlock(&m->lock);
-
-		if (req) {
-			req->rcall = rcall;
-			process_request(m, req);
-
-			if (req->flush != Flushing) {
-				if (req->cb)
-					(*req->cb) (req, req->cba);
-				else
-					kfree(req->rcall);
-
-				wake_up(&m->equeue);
-			}
-		} else {
-			if (err >= 0 && rcall->id != P9_RFLUSH)
-				P9_DPRINTK(P9_DEBUG_ERROR,
-					"unexpected response mux %p id %d tag %d\n",
-					m, rcall->id, rcall->tag);
-			kfree(rcall);
-		}
-	}
-
-	if (!list_empty(&m->req_list)) {
-		if (test_and_clear_bit(Rpending, &m->wsched))
-			n = POLLIN;
-		else
-			n = m->trans->poll(m->trans, NULL);
-
-		if (n & POLLIN) {
-			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
-			queue_work(p9_mux_wq, &m->rq);
-		} else
-			clear_bit(Rworksched, &m->wsched);
-	} else
-		clear_bit(Rworksched, &m->wsched);
-
-	return;
-
-      error:
-	p9_conn_cancel(m, err);
-	clear_bit(Rworksched, &m->wsched);
-}
-
-/**
- * p9_send_request - send 9P request
- * The function can sleep until the request is scheduled for sending.
- * The function can be interrupted. Return from the function is not
- * a guarantee that the request is sent successfully. Can return errors
- * that can be retrieved by PTR_ERR macros.
- *
- * @m: mux data
- * @tc: request to be sent
- * @cb: callback function to call when response is received
- * @cba: parameter to pass to the callback function
- */
-static struct p9_req *p9_send_request(struct p9_conn *m,
-					  struct p9_fcall *tc,
-					  p9_conn_req_callback cb, void *cba)
-{
-	int n;
-	struct p9_req *req;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p task %p tcall %p id %d\n", m, current,
-		tc, tc->id);
-	if (m->err < 0)
-		return ERR_PTR(m->err);
-
-	req = kmalloc(sizeof(struct p9_req), GFP_KERNEL);
-	if (!req)
-		return ERR_PTR(-ENOMEM);
-
-	if (tc->id == P9_TVERSION)
-		n = P9_NOTAG;
-	else
-		n = p9_mux_get_tag(m);
-
-	if (n < 0)
-		return ERR_PTR(-ENOMEM);
-
-	p9_set_tag(tc, n);
-
-#ifdef CONFIG_NET_9P_DEBUG
-	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
-		char buf[150];
-
-		p9_printfcall(buf, sizeof(buf), tc, *m->extended);
-		printk(KERN_NOTICE "<<< %p %s\n", m, buf);
-	}
-#endif
-
-	spin_lock_init(&req->lock);
-	req->tag = n;
-	req->tcall = tc;
-	req->rcall = NULL;
-	req->err = 0;
-	req->cb = cb;
-	req->cba = cba;
-	req->flush = None;
-
-	spin_lock(&m->lock);
-	list_add_tail(&req->req_list, &m->unsent_req_list);
-	spin_unlock(&m->lock);
-
-	if (test_and_clear_bit(Wpending, &m->wsched))
-		n = POLLOUT;
-	else
-		n = m->trans->poll(m->trans, NULL);
-
-	if (n & POLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		queue_work(p9_mux_wq, &m->wq);
-
-	return req;
-}
-
-static void p9_mux_free_request(struct p9_conn *m, struct p9_req *req)
-{
-	p9_mux_put_tag(m, req->tag);
-	kfree(req);
-}
-
-static void p9_mux_flush_cb(struct p9_req *freq, void *a)
-{
-	p9_conn_req_callback cb;
-	int tag;
-	struct p9_conn *m;
-	struct p9_req *req, *rreq, *rptr;
-
-	m = a;
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p rc %p err %d oldtag %d\n", m,
-		freq->tcall, freq->rcall, freq->err,
-		freq->tcall->params.tflush.oldtag);
-
-	spin_lock(&m->lock);
-	cb = NULL;
-	tag = freq->tcall->params.tflush.oldtag;
-	req = NULL;
-	list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
-		if (rreq->tag == tag) {
-			req = rreq;
-			list_del(&req->req_list);
-			break;
-		}
-	}
-	spin_unlock(&m->lock);
-
-	if (req) {
-		spin_lock(&req->lock);
-		req->flush = Flushed;
-		spin_unlock(&req->lock);
-
-		if (req->cb)
-			(*req->cb) (req, req->cba);
-		else
-			kfree(req->rcall);
-
-		wake_up(&m->equeue);
-	}
-
-	kfree(freq->tcall);
-	kfree(freq->rcall);
-	p9_mux_free_request(m, freq);
-}
-
-static int
-p9_mux_flush_request(struct p9_conn *m, struct p9_req *req)
-{
-	struct p9_fcall *fc;
-	struct p9_req *rreq, *rptr;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p tag %d\n", m, req, req->tag);
-
-	/* if a response was received for a request, do nothing */
-	spin_lock(&req->lock);
-	if (req->rcall || req->err) {
-		spin_unlock(&req->lock);
-		P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p response already
received\n", m, req);
-		return 0;
-	}
-
-	req->flush = Flushing;
-	spin_unlock(&req->lock);
-
-	spin_lock(&m->lock);
-	/* if the request is not sent yet, just remove it from the list */
-	list_for_each_entry_safe(rreq, rptr, &m->unsent_req_list, req_list) {
-		if (rreq->tag == req->tag) {
-			P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p request is not sent yet\n", m, req);
-			list_del(&rreq->req_list);
-			req->flush = Flushed;
-			spin_unlock(&m->lock);
-			if (req->cb)
-				(*req->cb) (req, req->cba);
-			return 0;
-		}
-	}
-	spin_unlock(&m->lock);
-
-	clear_thread_flag(TIF_SIGPENDING);
-	fc = p9_create_tflush(req->tag);
-	p9_send_request(m, fc, p9_mux_flush_cb, m);
-	return 1;
-}
-
-static void
-p9_conn_rpc_cb(struct p9_req *req, void *a)
-{
-	struct p9_mux_rpc *r;
-
-	P9_DPRINTK(P9_DEBUG_MUX, "req %p r %p\n", req, a);
-	r = a;
-	r->rcall = req->rcall;
-	r->err = req->err;
-
-	if (req->flush!=None && !req->err)
-		r->err = -ERESTARTSYS;
-
-	wake_up(&r->wqueue);
-}
-
-/**
- * p9_mux_rpc - sends 9P request and waits until a response is available.
- *	The function can be interrupted.
- * @m: mux data
- * @tc: request to be sent
- * @rc: pointer where a pointer to the response is stored
- */
-int
-p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc,
-	     struct p9_fcall **rc)
-{
-	int err, sigpending;
-	unsigned long flags;
-	struct p9_req *req;
-	struct p9_mux_rpc r;
-
-	r.err = 0;
-	r.tcall = tc;
-	r.rcall = NULL;
-	r.m = m;
-	init_waitqueue_head(&r.wqueue);
-
-	if (rc)
-		*rc = NULL;
-
-	sigpending = 0;
-	if (signal_pending(current)) {
-		sigpending = 1;
-		clear_thread_flag(TIF_SIGPENDING);
-	}
-
-	req = p9_send_request(m, tc, p9_conn_rpc_cb, &r);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
-		return err;
-	}
-
-	err = wait_event_interruptible(r.wqueue, r.rcall != NULL || r.err < 0);
-	if (r.err < 0)
-		err = r.err;
-
-	if (err == -ERESTARTSYS && m->trans->status == Connected && m->err == 0) {
-		if (p9_mux_flush_request(m, req)) {
-			/* wait until we get response of the flush message */
-			do {
-				clear_thread_flag(TIF_SIGPENDING);
-				err = wait_event_interruptible(r.wqueue,
-					r.rcall || r.err);
-			} while (!r.rcall && !r.err && err==-ERESTARTSYS &&
-				m->trans->status==Connected && !m->err);
-
-			err = -ERESTARTSYS;
-		}
-		sigpending = 1;
-	}
-
-	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
-
-	if (rc)
-		*rc = r.rcall;
-	else
-		kfree(r.rcall);
-
-	p9_mux_free_request(m, req);
-	if (err > 0)
-		err = -EIO;
-
-	return err;
-}
-EXPORT_SYMBOL(p9_conn_rpc);
-
-#if 0
-/**
- * p9_conn_rpcnb - sends 9P request without waiting for response.
- * @m: mux data
- * @tc: request to be sent
- * @cb: callback function to be called when response arrives
- * @cba: value to pass to the callback function
- */
-int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
-		   p9_conn_req_callback cb, void *a)
-{
-	int err;
-	struct p9_req *req;
-
-	req = p9_send_request(m, tc, cb, a);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
-		return PTR_ERR(req);
-	}
-
-	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p tag %d\n", m, tc, req->tag);
-	return 0;
-}
-EXPORT_SYMBOL(p9_conn_rpcnb);
-#endif  /*  0  */
-
-/**
- * p9_conn_cancel - cancel all pending requests with error
- * @m: mux data
- * @err: error code
- */
-void p9_conn_cancel(struct p9_conn *m, int err)
-{
-	struct p9_req *req, *rtmp;
-	LIST_HEAD(cancel_list);
-
-	P9_DPRINTK(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
-	m->err = err;
-	spin_lock(&m->lock);
-	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
-		list_move(&req->req_list, &cancel_list);
-	}
-	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
-		list_move(&req->req_list, &cancel_list);
-	}
-	spin_unlock(&m->lock);
-
-	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
-		list_del(&req->req_list);
-		if (!req->err)
-			req->err = err;
-
-		if (req->cb)
-			(*req->cb) (req, req->cba);
-		else
-			kfree(req->rcall);
-	}
-
-	wake_up(&m->equeue);
-}
-EXPORT_SYMBOL(p9_conn_cancel);
-
-static u16 p9_mux_get_tag(struct p9_conn *m)
-{
-	int tag;
-
-	tag = p9_idpool_get(m->tagpool);
-	if (tag < 0)
-		return P9_NOTAG;
-	else
-		return (u16) tag;
-}
-
-static void p9_mux_put_tag(struct p9_conn *m, u16 tag)
-{
-	if (tag != P9_NOTAG && p9_idpool_check(tag, m->tagpool))
-		p9_idpool_put(tag, m->tagpool);
-}
diff --git a/fs/9p/trans_fd.c b/fs/9p/trans_fd.c
deleted file mode 100644
index cd33885..0000000
--- a/fs/9p/trans_fd.c
+++ /dev/null
@@ -1,354 +0,0 @@
-/*
- * linux/fs/9p/trans_fd.c
- *
- * Fd transport layer.  Includes deprecated socket layer.
- *
- *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
- *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004-2005 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/in.h>
-#include <linux/module.h>
-#include <linux/net.h>
-#include <linux/ipv6.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/un.h>
-#include <asm/uaccess.h>
-#include <linux/inet.h>
-#include <linux/idr.h>
-#include <linux/file.h>
-#include <net/9p/9p.h>
-#include <net/9p/transport.h>
-
-#define P9_PORT 564
-
-struct p9_trans_fd {
-	struct file *rd;
-	struct file *wr;
-};
-
-static int p9_socket_open(struct p9_transport *trans, struct socket *csocket);
-static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd);
-static int p9_fd_read(struct p9_transport *trans, void *v, int len);
-static int p9_fd_write(struct p9_transport *trans, void *v, int len);
-static unsigned int p9_fd_poll(struct p9_transport *trans,
-	struct poll_table_struct *pt);
-static void p9_fd_close(struct p9_transport *trans);
-
-struct p9_transport *p9_trans_create_tcp(const char *addr, int port)
-{
-	int err;
-	struct p9_transport *trans;
-	struct socket *csocket;
-	struct sockaddr_in sin_server;
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(port);
-	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
-
-	if (!csocket) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
-		err = -EIO;
-		goto error;
-	}
-
-	err = csocket->ops->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_tcp: problem connecting socket to %s\n",
-			addr);
-		goto error;
-	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	if (csocket)
-		sock_release(csocket);
-
-	kfree(trans);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL(p9_trans_create_tcp);
-
-struct p9_transport *p9_trans_create_unix(const char *addr)
-{
-	int err;
-	struct socket *csocket;
-	struct sockaddr_un sun_server;
-	struct p9_transport *trans;
-
-	csocket = NULL;
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	if (strlen(addr) > UNIX_PATH_MAX) {
-		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
-			addr);
-		err = -ENAMETOOLONG;
-		goto error;
-	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
-	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
-	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
-			sizeof(struct sockaddr_un) - 1, 0);
-	if (err < 0) {
-		P9_EPRINTK(KERN_ERR,
-			"p9_trans_unix: problem connecting socket: %s: %d\n",
-			addr, err);
-		goto error;
-	}
-
-	err = p9_socket_open(trans, csocket);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	if (csocket)
-		sock_release(csocket);
-
-	kfree(trans);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL(p9_trans_create_unix);
-
-struct p9_transport *p9_trans_create_fd(int rfd, int wfd)
-{
-	int err;
-	struct p9_transport *trans;
-
-	if (rfd == ~0 || wfd == ~0) {
-		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
-		return ERR_PTR(-ENOPROTOOPT);
-	}
-
-	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
-
-	trans->write = p9_fd_write;
-	trans->read = p9_fd_read;
-	trans->close = p9_fd_close;
-	trans->poll = p9_fd_poll;
-
-	err = p9_fd_open(trans, rfd, wfd);
-	if (err < 0)
-		goto error;
-
-	return trans;
-
-error:
-	kfree(trans);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL(p9_trans_create_fd);
-
-static int p9_socket_open(struct p9_transport *trans, struct socket *csocket)
-{
-	int fd, ret;
-
-	csocket->sk->sk_allocation = GFP_NOIO;
-	fd = sock_map_fd(csocket);
-	if (fd < 0) {
-		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
-		return fd;
-	}
-
-	ret = p9_fd_open(trans, fd, fd);
-	if (ret < 0) {
-		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
-		sockfd_put(csocket);
-		return ret;
-	}
-
-	((struct p9_trans_fd *)trans->priv)->rd->f_flags |= O_NONBLOCK;
-
-	return 0;
-}
-
-static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd)
-{
-	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
-					   GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
-
-	trans->priv = ts;
-	trans->status = Connected;
-
-	return 0;
-}
-
-/**
- * p9_fd_read- read from a fd
- * @v9ses: session information
- * @v: buffer to receive data into
- * @len: size of receive buffer
- *
- */
-static int p9_fd_read(struct p9_transport *trans, void *v, int len)
-{
-	int ret;
-	struct p9_trans_fd *ts;
-
-	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
-		return -EREMOTEIO;
-
-	if (!(ts->rd->f_flags & O_NONBLOCK))
-		P9_DPRINTK(P9_DEBUG_ERROR, "blocking read ...\n");
-
-	ret = kernel_read(ts->rd, ts->rd->f_pos, v, len);
-	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
-		trans->status = Disconnected;
-	return ret;
-}
-
-/**
- * p9_fd_write - write to a socket
- * @v9ses: session information
- * @v: buffer to send data from
- * @len: size of send buffer
- *
- */
-static int p9_fd_write(struct p9_transport *trans, void *v, int len)
-{
-	int ret;
-	mm_segment_t oldfs;
-	struct p9_trans_fd *ts;
-
-	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
-		return -EREMOTEIO;
-
-	if (!(ts->wr->f_flags & O_NONBLOCK))
-		P9_DPRINTK(P9_DEBUG_ERROR, "blocking write ...\n");
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-	/* The cast to a user pointer is valid due to the set_fs() */
-	ret = vfs_write(ts->wr, (void __user *)v, len, &ts->wr->f_pos);
-	set_fs(oldfs);
-
-	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
-		trans->status = Disconnected;
-	return ret;
-}
-
-static unsigned int
-p9_fd_poll(struct p9_transport *trans, struct poll_table_struct *pt)
-{
-	int ret, n;
-	struct p9_trans_fd *ts;
-	mm_segment_t oldfs;
-
-	if (!trans || trans->status != Connected || !(ts = trans->priv))
-		return -EREMOTEIO;
-
-	if (!ts->rd->f_op || !ts->rd->f_op->poll)
-		return -EIO;
-
-	if (!ts->wr->f_op || !ts->wr->f_op->poll)
-		return -EIO;
-
-	oldfs = get_fs();
-	set_fs(get_ds());
-
-	ret = ts->rd->f_op->poll(ts->rd, pt);
-	if (ret < 0)
-		goto end;
-
-	if (ts->rd != ts->wr) {
-		n = ts->wr->f_op->poll(ts->wr, pt);
-		if (n < 0) {
-			ret = n;
-			goto end;
-		}
-		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
-	}
-
-      end:
-	set_fs(oldfs);
-	return ret;
-}
-
-/**
- * p9_sock_close - shutdown socket
- * @trans: private socket structure
- *
- */
-static void p9_fd_close(struct p9_transport *trans)
-{
-	struct p9_trans_fd *ts;
-
-	if (!trans)
-		return;
-
-	ts = xchg(&trans->priv, NULL);
-
-	if (!ts)
-		return;
-
-	trans->status = Disconnected;
-	if (ts->rd)
-		fput(ts->rd);
-	if (ts->wr)
-		fput(ts->wr);
-	kfree(ts);
-}
-
diff --git a/fs/9p/util.c b/fs/9p/util.c
deleted file mode 100644
index 22077b7..0000000
--- a/fs/9p/util.c
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- *  net/9p/util.c
- *
- *  This file contains some helper functions
- *
- *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/parser.h>
-#include <linux/idr.h>
-#include <net/9p/9p.h>
-
-struct p9_idpool {
-	struct semaphore lock;
-	struct idr pool;
-};
-
-struct p9_idpool *p9_idpool_create(void)
-{
-	struct p9_idpool *p;
-
-	p = kmalloc(sizeof(struct p9_idpool), GFP_KERNEL);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	init_MUTEX(&p->lock);
-	idr_init(&p->pool);
-
-	return p;
-}
-EXPORT_SYMBOL(p9_idpool_create);
-
-void p9_idpool_destroy(struct p9_idpool *p)
-{
-	idr_destroy(&p->pool);
-	kfree(p);
-}
-EXPORT_SYMBOL(p9_idpool_destroy);
-
-/**
- * p9_idpool_get - allocate numeric id from pool
- * @p - pool to allocate from
- *
- * XXX - This seems to be an awful generic function, should it be in idr.c with
- *            the lock included in struct idr?
- */
-
-int p9_idpool_get(struct p9_idpool *p)
-{
-	int i = 0;
-	int error;
-
-retry:
-	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
-		return 0;
-
-	if (down_interruptible(&p->lock) == -EINTR) {
-		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
-		return -1;
-	}
-
-	/* no need to store exactly p, we just need something non-null */
-	error = idr_get_new(&p->pool, p, &i);
-	up(&p->lock);
-
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
-		return -1;
-
-	return i;
-}
-EXPORT_SYMBOL(p9_idpool_get);
-
-/**
- * p9_idpool_put - release numeric id from pool
- * @p - pool to allocate from
- *
- * XXX - This seems to be an awful generic function, should it be in idr.c with
- *            the lock included in struct idr?
- */
-
-void p9_idpool_put(int id, struct p9_idpool *p)
-{
-	if (down_interruptible(&p->lock) == -EINTR) {
-		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
-		return;
-	}
-	idr_remove(&p->pool, id);
-	up(&p->lock);
-}
-EXPORT_SYMBOL(p9_idpool_put);
-
-/**
- * p9_idpool_check - check if the specified id is available
- * @id - id to check
- * @p - pool
- */
-int p9_idpool_check(int id, struct p9_idpool *p)
-{
-	return idr_find(&p->pool, id) != NULL;
-}
-EXPORT_SYMBOL(p9_idpool_check);
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d1b50d0..70858ed 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -389,10 +389,6 @@ void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
 	p9_conn_cancel(v9ses->conn, -EIO);
 }

-extern int p9_error_init(void);
-extern int p9_mux_global_init(void);
-extern void p9_mux_global_exit(void);
-
 /**
  * v9fs_init - Initialize module
  *
@@ -402,14 +398,7 @@ static int __init init_v9fs(void)
 {
 	int ret;

-	p9_error_init();
 	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
-	ret = p9_mux_global_init();
-	if (ret) {
-		printk(KERN_WARNING "9p: starting mux failed\n");
-		return ret;
-	}
-
 	ret = register_filesystem(&v9fs_fs_type);
 	if (ret)
 		printk(KERN_WARNING "v9fs: registering file system failed\n");
@@ -425,7 +414,6 @@ static int __init init_v9fs(void)
 static void __exit exit_v9fs(void)
 {
 	unregister_filesystem(&v9fs_fs_type);
-	p9_mux_global_exit();
 }

 module_init(init_v9fs)
diff --git a/fs/Kconfig b/fs/Kconfig
index 8ea7b04..f8b2616 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -2052,7 +2052,7 @@ config AFS_DEBUG

 config 9P_FS
 	tristate "Plan 9 Resource Sharing Support (9P2000) (Experimental)"
-	depends on INET && EXPERIMENTAL
+	depends on INET && NET_9P && EXPERIMENTAL
 	help
 	  If you say Y here, you will get experimental support for
 	  Plan 9 resource sharing via the 9P2000 protocol.
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 153129b..a3356ef 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -27,8 +27,6 @@
 #ifndef NET_9P_H
 #define NET_9P_H

-#define CONFIG_NET_9P_DEBUG
-
 #ifdef CONFIG_NET_9P_DEBUG

 #define P9_DEBUG_ERROR		(1<<0)
diff --git a/net/9p/conv.c b/net/9p/conv.c
new file mode 100644
index 0000000..0ce149d
--- /dev/null
+++ b/net/9p/conv.c
@@ -0,0 +1,896 @@
+/*
+ * net/9p/conv.c
+ *
+ * 9P protocol conversion functions
+ *
+ *  Copyright (C) 2004, 2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/idr.h>
+#include <asm/uaccess.h>
+#include <net/9p/9p.h>
+
+/*
+ * Buffer to help with string parsing
+ */
+struct cbuf {
+	unsigned char *sp;
+	unsigned char *p;
+	unsigned char *ep;
+};
+
+static inline void buf_init(struct cbuf *buf, void *data, int datalen)
+{
+	buf->sp = buf->p = data;
+	buf->ep = data + datalen;
+}
+
+static inline int buf_check_overflow(struct cbuf *buf)
+{
+	return buf->p > buf->ep;
+}
+
+static int buf_check_size(struct cbuf *buf, int len)
+{
+	if (buf->p + len > buf->ep) {
+		if (buf->p < buf->ep) {
+			P9_EPRINTK(KERN_ERR, "buffer overflow: want %d has %d\n",
+				len, (int)(buf->ep - buf->p));
+			dump_stack();
+			buf->p = buf->ep + 1;
+		}
+
+		return 0;
+	}
+
+	return 1;
+}
+
+static void *buf_alloc(struct cbuf *buf, int len)
+{
+	void *ret = NULL;
+
+	if (buf_check_size(buf, len)) {
+		ret = buf->p;
+		buf->p += len;
+	}
+
+	return ret;
+}
+
+static void buf_put_int8(struct cbuf *buf, u8 val)
+{
+	if (buf_check_size(buf, 1)) {
+		buf->p[0] = val;
+		buf->p++;
+	}
+}
+
+static void buf_put_int16(struct cbuf *buf, u16 val)
+{
+	if (buf_check_size(buf, 2)) {
+		*(__le16 *) buf->p = cpu_to_le16(val);
+		buf->p += 2;
+	}
+}
+
+static void buf_put_int32(struct cbuf *buf, u32 val)
+{
+	if (buf_check_size(buf, 4)) {
+		*(__le32 *)buf->p = cpu_to_le32(val);
+		buf->p += 4;
+	}
+}
+
+static void buf_put_int64(struct cbuf *buf, u64 val)
+{
+	if (buf_check_size(buf, 8)) {
+		*(__le64 *)buf->p = cpu_to_le64(val);
+		buf->p += 8;
+	}
+}
+
+static char *buf_put_stringn(struct cbuf *buf, const char *s, u16 slen)
+{
+	char *ret;
+
+	ret = NULL;
+	if (buf_check_size(buf, slen + 2)) {
+		buf_put_int16(buf, slen);
+		ret = buf->p;
+		memcpy(buf->p, s, slen);
+		buf->p += slen;
+	}
+
+	return ret;
+}
+
+static inline void buf_put_string(struct cbuf *buf, const char *s)
+{
+	buf_put_stringn(buf, s, strlen(s));
+}
+
+static u8 buf_get_int8(struct cbuf *buf)
+{
+	u8 ret = 0;
+
+	if (buf_check_size(buf, 1)) {
+		ret = buf->p[0];
+		buf->p++;
+	}
+
+	return ret;
+}
+
+static u16 buf_get_int16(struct cbuf *buf)
+{
+	u16 ret = 0;
+
+	if (buf_check_size(buf, 2)) {
+		ret = le16_to_cpu(*(__le16 *)buf->p);
+		buf->p += 2;
+	}
+
+	return ret;
+}
+
+static u32 buf_get_int32(struct cbuf *buf)
+{
+	u32 ret = 0;
+
+	if (buf_check_size(buf, 4)) {
+		ret = le32_to_cpu(*(__le32 *)buf->p);
+		buf->p += 4;
+	}
+
+	return ret;
+}
+
+static u64 buf_get_int64(struct cbuf *buf)
+{
+	u64 ret = 0;
+
+	if (buf_check_size(buf, 8)) {
+		ret = le64_to_cpu(*(__le64 *)buf->p);
+		buf->p += 8;
+	}
+
+	return ret;
+}
+
+static void buf_get_str(struct cbuf *buf, struct p9_str *vstr)
+{
+	vstr->len = buf_get_int16(buf);
+	if (!buf_check_overflow(buf) && buf_check_size(buf, vstr->len)) {
+		vstr->str = buf->p;
+		buf->p += vstr->len;
+	} else {
+		vstr->len = 0;
+		vstr->str = NULL;
+	}
+}
+
+static void buf_get_qid(struct cbuf *bufp, struct p9_qid *qid)
+{
+	qid->type = buf_get_int8(bufp);
+	qid->version = buf_get_int32(bufp);
+	qid->path = buf_get_int64(bufp);
+}
+
+/**
+ * p9_size_wstat - calculate the size of a variable length stat struct
+ * @stat: metadata (stat) structure
+ * @dotu: non-zero if 9P2000.u
+ *
+ */
+
+static int p9_size_wstat(struct p9_wstat *wstat, int dotu)
+{
+	int size = 0;
+
+	if (wstat == NULL) {
+		P9_EPRINTK(KERN_ERR, "p9_size_stat: got a NULL stat pointer\n");
+		return 0;
+	}
+
+	size =			/* 2 + *//* size[2] */
+	    2 +			/* type[2] */
+	    4 +			/* dev[4] */
+	    1 +			/* qid.type[1] */
+	    4 +			/* qid.vers[4] */
+	    8 +			/* qid.path[8] */
+	    4 +			/* mode[4] */
+	    4 +			/* atime[4] */
+	    4 +			/* mtime[4] */
+	    8 +			/* length[8] */
+	    8;			/* minimum sum of string lengths */
+
+	if (wstat->name)
+		size += strlen(wstat->name);
+	if (wstat->uid)
+		size += strlen(wstat->uid);
+	if (wstat->gid)
+		size += strlen(wstat->gid);
+	if (wstat->muid)
+		size += strlen(wstat->muid);
+
+	if (dotu) {
+		size += 4 +	/* n_uid[4] */
+		    4 +		/* n_gid[4] */
+		    4 +		/* n_muid[4] */
+		    2;		/* string length of extension[4] */
+		if (wstat->extension)
+			size += strlen(wstat->extension);
+	}
+
+	return size;
+}
+
+/**
+ * buf_get_stat - safely decode a recieved metadata (stat) structure
+ * @bufp: buffer to deserialize
+ * @stat: metadata (stat) structure
+ * @dotu: non-zero if 9P2000.u
+ *
+ */
+
+static void
+buf_get_stat(struct cbuf *bufp, struct p9_stat *stat, int dotu)
+{
+	stat->size = buf_get_int16(bufp);
+	stat->type = buf_get_int16(bufp);
+	stat->dev = buf_get_int32(bufp);
+	stat->qid.type = buf_get_int8(bufp);
+	stat->qid.version = buf_get_int32(bufp);
+	stat->qid.path = buf_get_int64(bufp);
+	stat->mode = buf_get_int32(bufp);
+	stat->atime = buf_get_int32(bufp);
+	stat->mtime = buf_get_int32(bufp);
+	stat->length = buf_get_int64(bufp);
+	buf_get_str(bufp, &stat->name);
+	buf_get_str(bufp, &stat->uid);
+	buf_get_str(bufp, &stat->gid);
+	buf_get_str(bufp, &stat->muid);
+
+	if (dotu) {
+		buf_get_str(bufp, &stat->extension);
+		stat->n_uid = buf_get_int32(bufp);
+		stat->n_gid = buf_get_int32(bufp);
+		stat->n_muid = buf_get_int32(bufp);
+	}
+}
+
+/**
+ * p9_deserialize_stat - decode a received metadata structure
+ * @buf: buffer to deserialize
+ * @buflen: length of received buffer
+ * @stat: metadata structure to decode into
+ * @dotu: non-zero if 9P2000.u
+ *
+ * Note: stat will point to the buf region.
+ */
+
+int
+p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
+		int dotu)
+{
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+	unsigned char *p;
+
+	buf_init(bufp, buf, buflen);
+	p = bufp->p;
+	buf_get_stat(bufp, stat, dotu);
+
+	if (buf_check_overflow(bufp))
+		return 0;
+	else
+		return bufp->p - p;
+}
+EXPORT_SYMBOL(p9_deserialize_stat);
+
+/**
+ * deserialize_fcall - unmarshal a response
+ * @buf: recieved buffer
+ * @buflen: length of received buffer
+ * @rcall: fcall structure to populate
+ * @rcalllen: length of fcall structure to populate
+ * @dotu: non-zero if 9P2000.u
+ *
+ */
+
+int
+p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
+		       int dotu)
+{
+
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+	int i = 0;
+
+	buf_init(bufp, buf, buflen);
+
+	rcall->size = buf_get_int32(bufp);
+	rcall->id = buf_get_int8(bufp);
+	rcall->tag = buf_get_int16(bufp);
+
+	P9_DPRINTK(P9_DEBUG_CONV, "size %d id %d tag %d\n", rcall->size, rcall->id,
+		rcall->tag);
+
+	switch (rcall->id) {
+	default:
+		P9_EPRINTK(KERN_ERR, "unknown message type: %d\n", rcall->id);
+		return -EPROTO;
+	case P9_RVERSION:
+		rcall->params.rversion.msize = buf_get_int32(bufp);
+		buf_get_str(bufp, &rcall->params.rversion.version);
+		break;
+	case P9_RFLUSH:
+		break;
+	case P9_RATTACH:
+		rcall->params.rattach.qid.type = buf_get_int8(bufp);
+		rcall->params.rattach.qid.version = buf_get_int32(bufp);
+		rcall->params.rattach.qid.path = buf_get_int64(bufp);
+		break;
+	case P9_RWALK:
+		rcall->params.rwalk.nwqid = buf_get_int16(bufp);
+		if (rcall->params.rwalk.nwqid > P9_MAXWELEM) {
+			P9_EPRINTK(KERN_ERR, "Rwalk with more than %d qids: %d\n",
+				P9_MAXWELEM, rcall->params.rwalk.nwqid);
+			return -EPROTO;
+		}
+
+		for (i = 0; i < rcall->params.rwalk.nwqid; i++)
+			buf_get_qid(bufp, &rcall->params.rwalk.wqids[i]);
+		break;
+	case P9_ROPEN:
+		buf_get_qid(bufp, &rcall->params.ropen.qid);
+		rcall->params.ropen.iounit = buf_get_int32(bufp);
+		break;
+	case P9_RCREATE:
+		buf_get_qid(bufp, &rcall->params.rcreate.qid);
+		rcall->params.rcreate.iounit = buf_get_int32(bufp);
+		break;
+	case P9_RREAD:
+		rcall->params.rread.count = buf_get_int32(bufp);
+		rcall->params.rread.data = bufp->p;
+		buf_check_size(bufp, rcall->params.rread.count);
+		break;
+	case P9_RWRITE:
+		rcall->params.rwrite.count = buf_get_int32(bufp);
+		break;
+	case P9_RCLUNK:
+		break;
+	case P9_RREMOVE:
+		break;
+	case P9_RSTAT:
+		buf_get_int16(bufp);
+		buf_get_stat(bufp, &rcall->params.rstat.stat, dotu);
+		break;
+	case P9_RWSTAT:
+		break;
+	case P9_RERROR:
+		buf_get_str(bufp, &rcall->params.rerror.error);
+		if (dotu)
+			rcall->params.rerror.errno = buf_get_int16(bufp);
+		break;
+	}
+
+	if (buf_check_overflow(bufp)) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "buffer overflow\n");
+		return -EIO;
+	}
+
+	return bufp->p - bufp->sp;
+}
+EXPORT_SYMBOL(p9_deserialize_fcall);
+
+static inline void p9_put_int8(struct cbuf *bufp, u8 val, u8 * p)
+{
+	*p = val;
+	buf_put_int8(bufp, val);
+}
+
+static inline void p9_put_int16(struct cbuf *bufp, u16 val, u16 * p)
+{
+	*p = val;
+	buf_put_int16(bufp, val);
+}
+
+static inline void p9_put_int32(struct cbuf *bufp, u32 val, u32 * p)
+{
+	*p = val;
+	buf_put_int32(bufp, val);
+}
+
+static inline void p9_put_int64(struct cbuf *bufp, u64 val, u64 * p)
+{
+	*p = val;
+	buf_put_int64(bufp, val);
+}
+
+static void
+p9_put_str(struct cbuf *bufp, char *data, struct p9_str *str)
+{
+	int len;
+	char *s;
+
+	if (data)
+		len = strlen(data);
+	else
+		len = 0;
+
+	s = buf_put_stringn(bufp, data, len);
+	if (str) {
+		str->len = len;
+		str->str = s;
+	}
+}
+
+static int
+p9_put_data(struct cbuf *bufp, const char *data, int count,
+		   unsigned char **pdata)
+{
+	*pdata = buf_alloc(bufp, count);
+	memmove(*pdata, data, count);
+	return count;
+}
+
+static int
+p9_put_user_data(struct cbuf *bufp, const char __user * data, int count,
+		   unsigned char **pdata)
+{
+	*pdata = buf_alloc(bufp, count);
+	return copy_from_user(*pdata, data, count);
+}
+
+static void
+p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
+	       struct p9_stat *stat, int statsz, int dotu)
+{
+	p9_put_int16(bufp, statsz, &stat->size);
+	p9_put_int16(bufp, wstat->type, &stat->type);
+	p9_put_int32(bufp, wstat->dev, &stat->dev);
+	p9_put_int8(bufp, wstat->qid.type, &stat->qid.type);
+	p9_put_int32(bufp, wstat->qid.version, &stat->qid.version);
+	p9_put_int64(bufp, wstat->qid.path, &stat->qid.path);
+	p9_put_int32(bufp, wstat->mode, &stat->mode);
+	p9_put_int32(bufp, wstat->atime, &stat->atime);
+	p9_put_int32(bufp, wstat->mtime, &stat->mtime);
+	p9_put_int64(bufp, wstat->length, &stat->length);
+
+	p9_put_str(bufp, wstat->name, &stat->name);
+	p9_put_str(bufp, wstat->uid, &stat->uid);
+	p9_put_str(bufp, wstat->gid, &stat->gid);
+	p9_put_str(bufp, wstat->muid, &stat->muid);
+
+	if (dotu) {
+		p9_put_str(bufp, wstat->extension, &stat->extension);
+		p9_put_int32(bufp, wstat->n_uid, &stat->n_uid);
+		p9_put_int32(bufp, wstat->n_gid, &stat->n_gid);
+		p9_put_int32(bufp, wstat->n_muid, &stat->n_muid);
+	}
+}
+
+static struct p9_fcall *
+p9_create_common(struct cbuf *bufp, u32 size, u8 id)
+{
+	struct p9_fcall *fc;
+
+	size += 4 + 1 + 2;	/* size[4] id[1] tag[2] */
+	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
+	if (!fc)
+		return ERR_PTR(-ENOMEM);
+
+	fc->sdata = (char *)fc + sizeof(*fc);
+
+	buf_init(bufp, (char *)fc->sdata, size);
+	p9_put_int32(bufp, size, &fc->size);
+	p9_put_int8(bufp, id, &fc->id);
+	p9_put_int16(bufp, P9_NOTAG, &fc->tag);
+
+	return fc;
+}
+
+void p9_set_tag(struct p9_fcall *fc, u16 tag)
+{
+	fc->tag = tag;
+	*(__le16 *) (fc->sdata + 5) = cpu_to_le16(tag);
+}
+EXPORT_SYMBOL(p9_set_tag);
+
+struct p9_fcall *p9_create_tversion(u32 msize, char *version)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 2 + strlen(version);	/* msize[4] version[s] */
+	fc = p9_create_common(bufp, size, P9_TVERSION);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, msize, &fc->params.tversion.msize);
+	p9_put_str(bufp, version, &fc->params.tversion.version);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tversion);
+
+struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* afid[4]
uname[s] aname[s] */
+	fc = p9_create_common(bufp, size, P9_TAUTH);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, afid, &fc->params.tauth.afid);
+	p9_put_str(bufp, uname, &fc->params.tauth.uname);
+	p9_put_str(bufp, aname, &fc->params.tauth.aname);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tauth);
+
+struct p9_fcall *
+p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* fid[4]
afid[4] uname[s] aname[s] */
+	fc = p9_create_common(bufp, size, P9_TATTACH);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tattach.fid);
+	p9_put_int32(bufp, afid, &fc->params.tattach.afid);
+	p9_put_str(bufp, uname, &fc->params.tattach.uname);
+	p9_put_str(bufp, aname, &fc->params.tattach.aname);
+
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tattach);
+
+struct p9_fcall *p9_create_tflush(u16 oldtag)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 2;		/* oldtag[2] */
+	fc = p9_create_common(bufp, size, P9_TFLUSH);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int16(bufp, oldtag, &fc->params.tflush.oldtag);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tflush);
+
+struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
+				     char **wnames)
+{
+	int i, size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	if (nwname > P9_MAXWELEM) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "nwname > %d\n", P9_MAXWELEM);
+		return NULL;
+	}
+
+	size = 4 + 4 + 2;	/* fid[4] newfid[4] nwname[2] ... */
+	for (i = 0; i < nwname; i++) {
+		size += 2 + strlen(wnames[i]);	/* wname[s] */
+	}
+
+	fc = p9_create_common(bufp, size, P9_TWALK);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.twalk.fid);
+	p9_put_int32(bufp, newfid, &fc->params.twalk.newfid);
+	p9_put_int16(bufp, nwname, &fc->params.twalk.nwname);
+	for (i = 0; i < nwname; i++) {
+		p9_put_str(bufp, wnames[i], &fc->params.twalk.wnames[i]);
+	}
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_twalk);
+
+struct p9_fcall *p9_create_topen(u32 fid, u8 mode)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 1;		/* fid[4] mode[1] */
+	fc = p9_create_common(bufp, size, P9_TOPEN);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.topen.fid);
+	p9_put_int8(bufp, mode, &fc->params.topen.mode);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_topen);
+
+struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
+	char *extension, int dotu)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 2 + strlen(name) + 4 + 1;	/* fid[4] name[s] perm[4] mode[1] */
+	if (dotu) {
+		size += 2 +			/* extension[s] */
+		    (extension == NULL ? 0 : strlen(extension));
+	}
+
+	fc = p9_create_common(bufp, size, P9_TCREATE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tcreate.fid);
+	p9_put_str(bufp, name, &fc->params.tcreate.name);
+	p9_put_int32(bufp, perm, &fc->params.tcreate.perm);
+	p9_put_int8(bufp, mode, &fc->params.tcreate.mode);
+	if (dotu)
+		p9_put_str(bufp, extension, &fc->params.tcreate.extension);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tcreate);
+
+struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 8 + 4;	/* fid[4] offset[8] count[4] */
+	fc = p9_create_common(bufp, size, P9_TREAD);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tread.fid);
+	p9_put_int64(bufp, offset, &fc->params.tread.offset);
+	p9_put_int32(bufp, count, &fc->params.tread.count);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tread);
+
+struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
+				      const char *data)
+{
+	int size, err;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
+	fc = p9_create_common(bufp, size, P9_TWRITE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
+	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
+	p9_put_int32(bufp, count, &fc->params.twrite.count);
+	err = p9_put_data(bufp, data, count, &fc->params.twrite.data);
+	if (err) {
+		kfree(fc);
+		fc = ERR_PTR(err);
+	}
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_twrite);
+
+struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
+				      const char __user * data)
+{
+	int size, err;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
+	fc = p9_create_common(bufp, size, P9_TWRITE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
+	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
+	p9_put_int32(bufp, count, &fc->params.twrite.count);
+	err = p9_put_user_data(bufp, data, count, &fc->params.twrite.data);
+	if (err) {
+		kfree(fc);
+		fc = ERR_PTR(err);
+	}
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_twrite_u);
+
+struct p9_fcall *p9_create_tclunk(u32 fid)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4;		/* fid[4] */
+	fc = p9_create_common(bufp, size, P9_TCLUNK);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tclunk.fid);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tclunk);
+
+struct p9_fcall *p9_create_tremove(u32 fid)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4;		/* fid[4] */
+	fc = p9_create_common(bufp, size, P9_TREMOVE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tremove.fid);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tremove);
+
+struct p9_fcall *p9_create_tstat(u32 fid)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4;		/* fid[4] */
+	fc = p9_create_common(bufp, size, P9_TSTAT);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tstat.fid);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tstat);
+
+struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
+				      int dotu)
+{
+	int size, statsz;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	statsz = p9_size_wstat(wstat, dotu);
+	size = 4 + 2 + 2 + statsz;	/* fid[4] stat[n] */
+	fc = p9_create_common(bufp, size, P9_TWSTAT);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.twstat.fid);
+	buf_put_int16(bufp, statsz + 2);
+	p9_put_wstat(bufp, wstat, &fc->params.twstat.stat, statsz, dotu);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_twstat);
diff --git a/net/9p/error.c b/net/9p/error.c
new file mode 100644
index 0000000..53f2024
--- /dev/null
+++ b/net/9p/error.c
@@ -0,0 +1,240 @@
+/*
+ * linux/fs/9p/error.c
+ *
+ * Error string handling
+ *
+ * Plan 9 uses error strings, Unix uses error numbers.  These functions
+ * try to help manage that and provide for dynamically adding error
+ * mappings.
+ *
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/errno.h>
+#include <asm/errno.h>
+
+struct errormap {
+	char *name;
+	int val;
+
+	int namelen;
+	struct hlist_node list;
+};
+
+#define ERRHASHSZ		32
+static struct hlist_head hash_errmap[ERRHASHSZ];
+
+/* FixMe - reduce to a reasonable size */
+static struct errormap errmap[] = {
+	{"Operation not permitted", EPERM},
+	{"wstat prohibited", EPERM},
+	{"No such file or directory", ENOENT},
+	{"directory entry not found", ENOENT},
+	{"file not found", ENOENT},
+	{"Interrupted system call", EINTR},
+	{"Input/output error", EIO},
+	{"No such device or address", ENXIO},
+	{"Argument list too long", E2BIG},
+	{"Bad file descriptor", EBADF},
+	{"Resource temporarily unavailable", EAGAIN},
+	{"Cannot allocate memory", ENOMEM},
+	{"Permission denied", EACCES},
+	{"Bad address", EFAULT},
+	{"Block device required", ENOTBLK},
+	{"Device or resource busy", EBUSY},
+	{"File exists", EEXIST},
+	{"Invalid cross-device link", EXDEV},
+	{"No such device", ENODEV},
+	{"Not a directory", ENOTDIR},
+	{"Is a directory", EISDIR},
+	{"Invalid argument", EINVAL},
+	{"Too many open files in system", ENFILE},
+	{"Too many open files", EMFILE},
+	{"Text file busy", ETXTBSY},
+	{"File too large", EFBIG},
+	{"No space left on device", ENOSPC},
+	{"Illegal seek", ESPIPE},
+	{"Read-only file system", EROFS},
+	{"Too many links", EMLINK},
+	{"Broken pipe", EPIPE},
+	{"Numerical argument out of domain", EDOM},
+	{"Numerical result out of range", ERANGE},
+	{"Resource deadlock avoided", EDEADLK},
+	{"File name too long", ENAMETOOLONG},
+	{"No locks available", ENOLCK},
+	{"Function not implemented", ENOSYS},
+	{"Directory not empty", ENOTEMPTY},
+	{"Too many levels of symbolic links", ELOOP},
+	{"No message of desired type", ENOMSG},
+	{"Identifier removed", EIDRM},
+	{"No data available", ENODATA},
+	{"Machine is not on the network", ENONET},
+	{"Package not installed", ENOPKG},
+	{"Object is remote", EREMOTE},
+	{"Link has been severed", ENOLINK},
+	{"Communication error on send", ECOMM},
+	{"Protocol error", EPROTO},
+	{"Bad message", EBADMSG},
+	{"File descriptor in bad state", EBADFD},
+	{"Streams pipe error", ESTRPIPE},
+	{"Too many users", EUSERS},
+	{"Socket operation on non-socket", ENOTSOCK},
+	{"Message too long", EMSGSIZE},
+	{"Protocol not available", ENOPROTOOPT},
+	{"Protocol not supported", EPROTONOSUPPORT},
+	{"Socket type not supported", ESOCKTNOSUPPORT},
+	{"Operation not supported", EOPNOTSUPP},
+	{"Protocol family not supported", EPFNOSUPPORT},
+	{"Network is down", ENETDOWN},
+	{"Network is unreachable", ENETUNREACH},
+	{"Network dropped connection on reset", ENETRESET},
+	{"Software caused connection abort", ECONNABORTED},
+	{"Connection reset by peer", ECONNRESET},
+	{"No buffer space available", ENOBUFS},
+	{"Transport endpoint is already connected", EISCONN},
+	{"Transport endpoint is not connected", ENOTCONN},
+	{"Cannot send after transport endpoint shutdown", ESHUTDOWN},
+	{"Connection timed out", ETIMEDOUT},
+	{"Connection refused", ECONNREFUSED},
+	{"Host is down", EHOSTDOWN},
+	{"No route to host", EHOSTUNREACH},
+	{"Operation already in progress", EALREADY},
+	{"Operation now in progress", EINPROGRESS},
+	{"Is a named type file", EISNAM},
+	{"Remote I/O error", EREMOTEIO},
+	{"Disk quota exceeded", EDQUOT},
+/* errors from fossil, vacfs, and u9fs */
+	{"fid unknown or out of range", EBADF},
+	{"permission denied", EACCES},
+	{"file does not exist", ENOENT},
+	{"authentication failed", ECONNREFUSED},
+	{"bad offset in directory read", ESPIPE},
+	{"bad use of fid", EBADF},
+	{"wstat can't convert between files and directories", EPERM},
+	{"directory is not empty", ENOTEMPTY},
+	{"file exists", EEXIST},
+	{"file already exists", EEXIST},
+	{"file or directory already exists", EEXIST},
+	{"fid already in use", EBADF},
+	{"file in use", ETXTBSY},
+	{"i/o error", EIO},
+	{"file already open for I/O", ETXTBSY},
+	{"illegal mode", EINVAL},
+	{"illegal name", ENAMETOOLONG},
+	{"not a directory", ENOTDIR},
+	{"not a member of proposed group", EPERM},
+	{"not owner", EACCES},
+	{"only owner can change group in wstat", EACCES},
+	{"read only file system", EROFS},
+	{"no access to special file", EPERM},
+	{"i/o count too large", EIO},
+	{"unknown group", EINVAL},
+	{"unknown user", EINVAL},
+	{"bogus wstat buffer", EPROTO},
+	{"exclusive use file already open", EAGAIN},
+	{"corrupted directory entry", EIO},
+	{"corrupted file entry", EIO},
+	{"corrupted block label", EIO},
+	{"corrupted meta data", EIO},
+	{"illegal offset", EINVAL},
+	{"illegal path element", ENOENT},
+	{"root of file system is corrupted", EIO},
+	{"corrupted super block", EIO},
+	{"protocol botch", EPROTO},
+	{"file system is full", ENOSPC},
+	{"file is in use", EAGAIN},
+	{"directory entry is not allocated", ENOENT},
+	{"file is read only", EROFS},
+	{"file has been removed", EIDRM},
+	{"only support truncation to zero length", EPERM},
+	{"cannot remove root", EPERM},
+	{"file too big", EFBIG},
+	{"venti i/o error", EIO},
+	/* these are not errors */
+	{"u9fs rhostsauth: no authentication required", 0},
+	{"u9fs authnone: no authentication required", 0},
+	{NULL, -1}
+};
+
+/**
+ * p9_error_init - preload
+ * @errstr: error string
+ *
+ */
+
+int p9_error_init(void)
+{
+	struct errormap *c;
+	int bucket;
+
+	/* initialize hash table */
+	for (bucket = 0; bucket < ERRHASHSZ; bucket++)
+		INIT_HLIST_HEAD(&hash_errmap[bucket]);
+
+	/* load initial error map into hash table */
+	for (c = errmap; c->name != NULL; c++) {
+		c->namelen = strlen(c->name);
+		bucket = jhash(c->name, c->namelen, 0) % ERRHASHSZ;
+		INIT_HLIST_NODE(&c->list);
+		hlist_add_head(&c->list, &hash_errmap[bucket]);
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(p9_error_init);
+
+/**
+ * errstr2errno - convert error string to error number
+ * @errstr: error string
+ *
+ */
+
+int p9_errstr2errno(char *errstr, int len)
+{
+	int errno;
+	struct hlist_node *p;
+	struct errormap *c;
+	int bucket;
+
+	errno = 0;
+	p = NULL;
+	c = NULL;
+	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
+	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
+		if (c->namelen==len && !memcmp(c->name, errstr, len)) {
+			errno = c->val;
+			break;
+		}
+	}
+
+	if (errno == 0) {
+		/* TODO: if error isn't found, add it dynamically */
+		errstr[len] = 0;
+		printk(KERN_ERR "%s: errstr :%s: not found\n", __FUNCTION__,
+		       errstr);
+		errno = 1;
+	}
+
+	return -errno;
+}
+EXPORT_SYMBOL(p9_errstr2errno);
diff --git a/net/9p/fcprint.c b/net/9p/fcprint.c
new file mode 100644
index 0000000..9fc29fe
--- /dev/null
+++ b/net/9p/fcprint.c
@@ -0,0 +1,353 @@
+/*
+ *  net/9p/fcprint.c
+ *
+ *  Print 9P call.
+ *
+ *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <net/9p/9p.h>
+
+#ifdef CONFIG_NET_9P_DEBUG
+
+static int
+p9_printqid(char *buf, int buflen, struct p9_qid *q)
+{
+	int n;
+	char b[10];
+
+	n = 0;
+	if (q->type & P9_QTDIR)
+		b[n++] = 'd';
+	if (q->type & P9_QTAPPEND)
+		b[n++] = 'a';
+	if (q->type & P9_QTAUTH)
+		b[n++] = 'A';
+	if (q->type & P9_QTEXCL)
+		b[n++] = 'l';
+	if (q->type & P9_QTTMP)
+		b[n++] = 't';
+	if (q->type & P9_QTSYMLINK)
+		b[n++] = 'L';
+	b[n] = '\0';
+
+	return scnprintf(buf, buflen, "(%.16llx %x %s)", (long long int) q->path,
+		q->version, b);
+}
+
+static int
+p9_printperm(char *buf, int buflen, int perm)
+{
+	int n;
+	char b[15];
+
+	n = 0;
+	if (perm & P9_DMDIR)
+		b[n++] = 'd';
+	if (perm & P9_DMAPPEND)
+		b[n++] = 'a';
+	if (perm & P9_DMAUTH)
+		b[n++] = 'A';
+	if (perm & P9_DMEXCL)
+		b[n++] = 'l';
+	if (perm & P9_DMTMP)
+		b[n++] = 't';
+	if (perm & P9_DMDEVICE)
+		b[n++] = 'D';
+	if (perm & P9_DMSOCKET)
+		b[n++] = 'S';
+	if (perm & P9_DMNAMEDPIPE)
+		b[n++] = 'P';
+	if (perm & P9_DMSYMLINK)
+		b[n++] = 'L';
+	b[n] = '\0';
+
+	return scnprintf(buf, buflen, "%s%03o", b, perm&077);
+}
+
+static int
+p9_printstat(char *buf, int buflen, struct p9_stat *st, int extended)
+{
+	int n;
+
+	n = scnprintf(buf, buflen, "'%.*s' '%.*s'", st->name.len,
+		st->name.str, st->uid.len, st->uid.str);
+	if (extended)
+		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_uid);
+
+	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->gid.len, st->gid.str);
+	if (extended)
+		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_gid);
+
+	n += scnprintf(buf+n, buflen-n, " '%.*s'", st->muid.len, st->muid.str);
+	if (extended)
+		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_muid);
+
+	n += scnprintf(buf+n, buflen-n, " q ");
+	n += p9_printqid(buf+n, buflen-n, &st->qid);
+	n += scnprintf(buf+n, buflen-n, " m ");
+	n += p9_printperm(buf+n, buflen-n, st->mode);
+	n += scnprintf(buf+n, buflen-n, " at %d mt %d l %lld",
+		st->atime, st->mtime, (long long int) st->length);
+
+	if (extended)
+		n += scnprintf(buf+n, buflen-n, " ext '%.*s'",
+			st->extension.len, st->extension.str);
+
+	return n;
+}
+
+static int
+p9_dumpdata(char *buf, int buflen, u8 *data, int datalen)
+{
+	int i, n;
+
+	i = n = 0;
+	while (i < datalen) {
+		n += scnprintf(buf + n, buflen - n, "%02x", data[i]);
+		if (i%4 == 3)
+			n += scnprintf(buf + n, buflen - n, " ");
+		if (i%32 == 31)
+			n += scnprintf(buf + n, buflen - n, "\n");
+
+		i++;
+	}
+	n += scnprintf(buf + n, buflen - n, "\n");
+
+	return n;
+}
+
+static int
+p9_printdata(char *buf, int buflen, u8 *data, int datalen)
+{
+	return p9_dumpdata(buf, buflen, data, datalen<16?datalen:16);
+}
+
+int
+p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
+{
+	int i, ret, type, tag;
+
+	if (!fc)
+		return scnprintf(buf, buflen, "<NULL>");
+
+	type = fc->id;
+	tag = fc->tag;
+
+	ret = 0;
+	switch (type) {
+	case P9_TVERSION:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Tversion tag %u msize %u version '%.*s'", tag,
+			fc->params.tversion.msize, fc->params.tversion.version.len,
+			fc->params.tversion.version.str);
+		break;
+
+	case P9_RVERSION:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Rversion tag %u msize %u version '%.*s'", tag,
+			fc->params.rversion.msize, fc->params.rversion.version.len,
+			fc->params.rversion.version.str);
+		break;
+
+	case P9_TAUTH:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Tauth tag %u afid %d uname '%.*s' aname '%.*s'", tag,
+			fc->params.tauth.afid, fc->params.tauth.uname.len,
+			fc->params.tauth.uname.str, fc->params.tauth.aname.len,
+			fc->params.tauth.aname.str);
+		break;
+
+	case P9_RAUTH:
+		ret += scnprintf(buf+ret, buflen-ret, "Rauth tag %u qid ", tag);
+		p9_printqid(buf+ret, buflen-ret, &fc->params.rauth.qid);
+		break;
+
+	case P9_TATTACH:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Tattach tag %u fid %d afid %d uname '%.*s' aname '%.*s'",
+			tag, fc->params.tattach.fid, fc->params.tattach.afid,
+			fc->params.tattach.uname.len, fc->params.tattach.uname.str,
+			fc->params.tattach.aname.len, fc->params.tattach.aname.str);
+		break;
+
+	case P9_RATTACH:
+		ret += scnprintf(buf+ret, buflen-ret, "Rattach tag %u qid ", tag);
+		p9_printqid(buf+ret, buflen-ret, &fc->params.rattach.qid);
+		break;
+
+	case P9_RERROR:
+		ret += scnprintf(buf+ret, buflen-ret, "Rerror tag %u ename '%.*s'",
+			tag, fc->params.rerror.error.len,
+			fc->params.rerror.error.str);
+		if (extended)
+			ret += scnprintf(buf+ret, buflen-ret, " ecode %d\n",
+				fc->params.rerror.errno);
+		break;
+
+	case P9_TFLUSH:
+		ret += scnprintf(buf+ret, buflen-ret, "Tflush tag %u oldtag %u",
+			tag, fc->params.tflush.oldtag);
+		break;
+
+	case P9_RFLUSH:
+		ret += scnprintf(buf+ret, buflen-ret, "Rflush tag %u", tag);
+		break;
+
+	case P9_TWALK:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Twalk tag %u fid %d newfid %d nwname %d", tag,
+			fc->params.twalk.fid, fc->params.twalk.newfid,
+			fc->params.twalk.nwname);
+		for(i = 0; i < fc->params.twalk.nwname; i++)
+			ret += scnprintf(buf+ret, buflen-ret," '%.*s'",
+				fc->params.twalk.wnames[i].len,
+				fc->params.twalk.wnames[i].str);
+		break;
+
+	case P9_RWALK:
+		ret += scnprintf(buf+ret, buflen-ret, "Rwalk tag %u nwqid %d",
+			tag, fc->params.rwalk.nwqid);
+		for(i = 0; i < fc->params.rwalk.nwqid; i++)
+			ret += p9_printqid(buf+ret, buflen-ret,
+				&fc->params.rwalk.wqids[i]);
+		break;
+
+	case P9_TOPEN:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Topen tag %u fid %d mode %d", tag,
+			fc->params.topen.fid, fc->params.topen.mode);
+		break;
+
+	case P9_ROPEN:
+		ret += scnprintf(buf+ret, buflen-ret, "Ropen tag %u", tag);
+		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.ropen.qid);
+		ret += scnprintf(buf+ret, buflen-ret," iounit %d",
+			fc->params.ropen.iounit);
+		break;
+
+	case P9_TCREATE:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Tcreate tag %u fid %d name '%.*s' perm ", tag,
+			fc->params.tcreate.fid, fc->params.tcreate.name.len,
+			fc->params.tcreate.name.str);
+
+		ret += p9_printperm(buf+ret, buflen-ret, fc->params.tcreate.perm);
+		ret += scnprintf(buf+ret, buflen-ret, " mode %d",
+			fc->params.tcreate.mode);
+		break;
+
+	case P9_RCREATE:
+		ret += scnprintf(buf+ret, buflen-ret, "Rcreate tag %u", tag);
+		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.rcreate.qid);
+		ret += scnprintf(buf+ret, buflen-ret, " iounit %d",
+			fc->params.rcreate.iounit);
+		break;
+
+	case P9_TREAD:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Tread tag %u fid %d offset %lld count %u", tag,
+			fc->params.tread.fid,
+			(long long int) fc->params.tread.offset,
+			fc->params.tread.count);
+		break;
+
+	case P9_RREAD:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Rread tag %u count %u data ", tag,
+			fc->params.rread.count);
+		ret += p9_printdata(buf+ret, buflen-ret, fc->params.rread.data,
+			fc->params.rread.count);
+		break;
+
+	case P9_TWRITE:
+		ret += scnprintf(buf+ret, buflen-ret,
+			"Twrite tag %u fid %d offset %lld count %u data ",
+			tag, fc->params.twrite.fid,
+			(long long int) fc->params.twrite.offset,
+			fc->params.twrite.count);
+		ret += p9_printdata(buf+ret, buflen-ret, fc->params.twrite.data,
+			fc->params.twrite.count);
+		break;
+
+	case P9_RWRITE:
+		ret += scnprintf(buf+ret, buflen-ret, "Rwrite tag %u count %u",
+			tag, fc->params.rwrite.count);
+		break;
+
+	case P9_TCLUNK:
+		ret += scnprintf(buf+ret, buflen-ret, "Tclunk tag %u fid %d",
+			tag, fc->params.tclunk.fid);
+		break;
+
+	case P9_RCLUNK:
+		ret += scnprintf(buf+ret, buflen-ret, "Rclunk tag %u", tag);
+		break;
+
+	case P9_TREMOVE:
+		ret += scnprintf(buf+ret, buflen-ret, "Tremove tag %u fid %d",
+			tag, fc->params.tremove.fid);
+		break;
+
+	case P9_RREMOVE:
+		ret += scnprintf(buf+ret, buflen-ret, "Rremove tag %u", tag);
+		break;
+
+	case P9_TSTAT:
+		ret += scnprintf(buf+ret, buflen-ret, "Tstat tag %u fid %d",
+			tag, fc->params.tstat.fid);
+		break;
+
+	case P9_RSTAT:
+		ret += scnprintf(buf+ret, buflen-ret, "Rstat tag %u ", tag);
+		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.rstat.stat,
+			extended);
+		break;
+
+	case P9_TWSTAT:
+		ret += scnprintf(buf+ret, buflen-ret, "Twstat tag %u fid %d ",
+			tag, fc->params.twstat.fid);
+		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.twstat.stat,
+			extended);
+		break;
+
+	case P9_RWSTAT:
+		ret += scnprintf(buf+ret, buflen-ret, "Rwstat tag %u", tag);
+		break;
+
+	default:
+		ret += scnprintf(buf+ret, buflen-ret, "unknown type %d", type);
+		break;
+	}
+
+	return ret;
+}
+
+#else
+int
+p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
+{
+	return 0;
+}
+#endif /* CONFIG_NET_9P_DEBUG */
+
+EXPORT_SYMBOL(p9_printfcall);
diff --git a/net/9p/mod.c b/net/9p/mod.c
new file mode 100644
index 0000000..c6168e1
--- /dev/null
+++ b/net/9p/mod.c
@@ -0,0 +1,86 @@
+/*
+ *  net/9p/9p.c
+ *
+ *  9P entry point
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <net/9p/9p.h>
+
+#ifdef CONFIG_NET_9P_DEBUG
+unsigned int p9_debug_level = 0;		/* feature-rific global debug level  */
+module_param_named(debug, p9_debug_level, uint, 0);
+MODULE_PARM_DESC(debug, "9P debugging level");
+EXPORT_SYMBOL(p9_debug_level);
+#endif
+
+extern int p9_error_init(void);
+extern int p9_mux_global_init(void);
+extern void p9_mux_global_exit(void);
+extern int p9_sysctl_register(void);
+extern void p9_sysctl_unregister(void);
+
+/**
+ * v9fs_init - Initialize module
+ *
+ */
+static int __init init_p9(void)
+{
+	int ret;
+
+	p9_error_init();
+	printk(KERN_INFO "Installing 9P2000 support\n");
+	ret = p9_mux_global_init();
+	if (ret) {
+		printk(KERN_WARNING "9p: starting mux failed\n");
+		return ret;
+	}
+
+	ret = p9_sysctl_register();
+	if (ret) {
+		printk(KERN_WARNING "9p: registering sysctl failed\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * v9fs_init - shutdown module
+ *
+ */
+
+static void __exit exit_p9(void)
+{
+	p9_sysctl_unregister();
+	p9_mux_global_exit();
+}
+
+module_init(init_p9)
+module_exit(exit_p9)
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_AUTHOR("Ron Minnich <rminnich@lanl.gov>");
+MODULE_LICENSE("GPL");
diff --git a/net/9p/mux.c b/net/9p/mux.c
new file mode 100644
index 0000000..2436e93
--- /dev/null
+++ b/net/9p/mux.c
@@ -0,0 +1,1041 @@
+/*
+ * net/9p/mux.c
+ *
+ * Protocol Multiplexer
+ *
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/kthread.h>
+#include <linux/idr.h>
+#include <linux/mutex.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/conn.h>
+
+#define ERREQFLUSH	1
+#define SCHED_TIMEOUT	10
+#define MAXPOLLWADDR	2
+
+enum {
+	Rworksched = 1,		/* read work scheduled or running */
+	Rpending = 2,		/* can read */
+	Wworksched = 4,		/* write work scheduled or running */
+	Wpending = 8,		/* can write */
+};
+
+enum {
+	None,
+	Flushing,
+	Flushed,
+};
+
+struct p9_mux_poll_task;
+
+struct p9_req {
+	spinlock_t lock;
+	int tag;
+	struct p9_fcall *tcall;
+	struct p9_fcall *rcall;
+	int err;
+	p9_conn_req_callback cb;
+	void *cba;
+	int flush;
+	struct list_head req_list;
+};
+
+struct p9_conn {
+	spinlock_t lock;
+	struct list_head mux_list;
+	struct p9_mux_poll_task *poll_task;
+	int msize;
+	unsigned char *extended;
+	struct p9_transport *trans;
+	struct p9_idpool *tagpool;
+	int err;
+	wait_queue_head_t equeue;
+	struct list_head req_list;
+	struct list_head unsent_req_list;
+	struct p9_fcall *rcall;
+	int rpos;
+	char *rbuf;
+	int wpos;
+	int wsize;
+	char *wbuf;
+	wait_queue_t poll_wait[MAXPOLLWADDR];
+	wait_queue_head_t *poll_waddr[MAXPOLLWADDR];
+	poll_table pt;
+	struct work_struct rq;
+	struct work_struct wq;
+	unsigned long wsched;
+};
+
+struct p9_mux_poll_task {
+	struct task_struct *task;
+	struct list_head mux_list;
+	int muxnum;
+};
+
+struct p9_mux_rpc {
+	struct p9_conn *m;
+	int err;
+	struct p9_fcall *tcall;
+	struct p9_fcall *rcall;
+	wait_queue_head_t wqueue;
+};
+
+static int p9_poll_proc(void *);
+static void p9_read_work(struct work_struct *work);
+static void p9_write_work(struct work_struct *work);
+static void p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
+			  poll_table * p);
+static u16 p9_mux_get_tag(struct p9_conn *);
+static void p9_mux_put_tag(struct p9_conn *, u16);
+
+static DEFINE_MUTEX(p9_mux_task_lock);
+static struct workqueue_struct *p9_mux_wq;
+
+static int p9_mux_num;
+static int p9_mux_poll_task_num;
+static struct p9_mux_poll_task p9_mux_poll_tasks[100];
+
+int p9_mux_global_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
+		p9_mux_poll_tasks[i].task = NULL;
+
+	p9_mux_wq = create_workqueue("v9fs");
+	if (!p9_mux_wq) {
+		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void p9_mux_global_exit(void)
+{
+	destroy_workqueue(p9_mux_wq);
+}
+
+/**
+ * p9_mux_calc_poll_procs - calculates the number of polling procs
+ * based on the number of mounted v9fs filesystems.
+ *
+ * The current implementation returns sqrt of the number of mounts.
+ */
+static int p9_mux_calc_poll_procs(int muxnum)
+{
+	int n;
+
+	if (p9_mux_poll_task_num)
+		n = muxnum / p9_mux_poll_task_num +
+		    (muxnum % p9_mux_poll_task_num ? 1 : 0);
+	else
+		n = 1;
+
+	if (n > ARRAY_SIZE(p9_mux_poll_tasks))
+		n = ARRAY_SIZE(p9_mux_poll_tasks);
+
+	return n;
+}
+
+static int p9_mux_poll_start(struct p9_conn *m)
+{
+	int i, n;
+	struct p9_mux_poll_task *vpt, *vptlast;
+	struct task_struct *pproc;
+
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p muxnum %d procnum %d\n", m, p9_mux_num,
+		p9_mux_poll_task_num);
+	mutex_lock(&p9_mux_task_lock);
+
+	n = p9_mux_calc_poll_procs(p9_mux_num + 1);
+	if (n > p9_mux_poll_task_num) {
+		for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
+			if (p9_mux_poll_tasks[i].task == NULL) {
+				vpt = &p9_mux_poll_tasks[i];
+				P9_DPRINTK(P9_DEBUG_MUX, "create proc %p\n", vpt);
+				pproc = kthread_create(p9_poll_proc, vpt,
+						   "v9fs-poll");
+
+				if (!IS_ERR(pproc)) {
+					vpt->task = pproc;
+					INIT_LIST_HEAD(&vpt->mux_list);
+					vpt->muxnum = 0;
+					p9_mux_poll_task_num++;
+					wake_up_process(vpt->task);
+				}
+				break;
+			}
+		}
+
+		if (i >= ARRAY_SIZE(p9_mux_poll_tasks))
+			P9_DPRINTK(P9_DEBUG_ERROR, "warning: no free poll slots\n");
+	}
+
+	n = (p9_mux_num + 1) / p9_mux_poll_task_num +
+	    ((p9_mux_num + 1) % p9_mux_poll_task_num ? 1 : 0);
+
+	vptlast = NULL;
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
+		vpt = &p9_mux_poll_tasks[i];
+		if (vpt->task != NULL) {
+			vptlast = vpt;
+			if (vpt->muxnum < n) {
+				P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
+				list_add(&m->mux_list, &vpt->mux_list);
+				vpt->muxnum++;
+				m->poll_task = vpt;
+				memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
+				init_poll_funcptr(&m->pt, p9_pollwait);
+				break;
+			}
+		}
+	}
+
+	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
+		if (vptlast == NULL)
+			return -ENOMEM;
+
+		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
+		list_add(&m->mux_list, &vptlast->mux_list);
+		vptlast->muxnum++;
+		m->poll_task = vptlast;
+		memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
+		init_poll_funcptr(&m->pt, p9_pollwait);
+	}
+
+	p9_mux_num++;
+	mutex_unlock(&p9_mux_task_lock);
+
+	return 0;
+}
+
+static void p9_mux_poll_stop(struct p9_conn *m)
+{
+	int i;
+	struct p9_mux_poll_task *vpt;
+
+	mutex_lock(&p9_mux_task_lock);
+	vpt = m->poll_task;
+	list_del(&m->mux_list);
+	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
+		if (m->poll_waddr[i] != NULL) {
+			remove_wait_queue(m->poll_waddr[i], &m->poll_wait[i]);
+			m->poll_waddr[i] = NULL;
+		}
+	}
+	vpt->muxnum--;
+	if (!vpt->muxnum) {
+		P9_DPRINTK(P9_DEBUG_MUX, "destroy proc %p\n", vpt);
+		kthread_stop(vpt->task);
+		vpt->task = NULL;
+		p9_mux_poll_task_num--;
+	}
+	p9_mux_num--;
+	mutex_unlock(&p9_mux_task_lock);
+}
+
+/**
+ * p9_conn_create - allocate and initialize the per-session mux data
+ * Creates the polling task if this is the first session.
+ *
+ * @trans - transport structure
+ * @msize - maximum message size
+ * @extended - pointer to the extended flag
+ */
+struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
+				    unsigned char *extended)
+{
+	int i, n;
+	struct p9_conn *m, *mtmp;
+
+	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans, msize);
+	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&m->lock);
+	INIT_LIST_HEAD(&m->mux_list);
+	m->msize = msize;
+	m->extended = extended;
+	m->trans = trans;
+	m->tagpool = p9_idpool_create();
+	if (!m->tagpool) {
+		kfree(m);
+		return ERR_PTR(PTR_ERR(m->tagpool));
+	}
+
+	m->err = 0;
+	init_waitqueue_head(&m->equeue);
+	INIT_LIST_HEAD(&m->req_list);
+	INIT_LIST_HEAD(&m->unsent_req_list);
+	m->rcall = NULL;
+	m->rpos = 0;
+	m->rbuf = NULL;
+	m->wpos = m->wsize = 0;
+	m->wbuf = NULL;
+	INIT_WORK(&m->rq, p9_read_work);
+	INIT_WORK(&m->wq, p9_write_work);
+	m->wsched = 0;
+	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
+	m->poll_task = NULL;
+	n = p9_mux_poll_start(m);
+	if (n)
+		return ERR_PTR(n);
+
+	n = trans->poll(trans, &m->pt);
+	if (n & POLLIN) {
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
+		set_bit(Rpending, &m->wsched);
+	}
+
+	if (n & POLLOUT) {
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
+		set_bit(Wpending, &m->wsched);
+	}
+
+	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
+		if (IS_ERR(m->poll_waddr[i])) {
+			p9_mux_poll_stop(m);
+			mtmp = (void *)m->poll_waddr;	/* the error code */
+			kfree(m);
+			m = mtmp;
+			break;
+		}
+	}
+
+	return m;
+}
+EXPORT_SYMBOL(p9_conn_create);
+
+/**
+ * p9_mux_destroy - cancels all pending requests and frees mux resources
+ */
+void p9_conn_destroy(struct p9_conn *m)
+{
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
+		m->mux_list.prev, m->mux_list.next);
+	p9_conn_cancel(m, -ECONNRESET);
+
+	if (!list_empty(&m->req_list)) {
+		/* wait until all processes waiting on this session exit */
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p waiting for empty request queue\n",
+			m);
+		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
+			list_empty(&m->req_list));
+	}
+
+	p9_mux_poll_stop(m);
+	m->trans = NULL;
+	p9_idpool_destroy(m->tagpool);
+	kfree(m);
+}
+EXPORT_SYMBOL(p9_conn_destroy);
+
+/**
+ * p9_pollwait - called by files poll operation to add v9fs-poll task
+ * 	to files wait queue
+ */
+static void
+p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
+	      poll_table * p)
+{
+	int i;
+	struct p9_conn *m;
+
+	m = container_of(p, struct p9_conn, pt);
+	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++)
+		if (m->poll_waddr[i] == NULL)
+			break;
+
+	if (i >= ARRAY_SIZE(m->poll_waddr)) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
+		return;
+	}
+
+	m->poll_waddr[i] = wait_address;
+
+	if (!wait_address) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
+		m->poll_waddr[i] = ERR_PTR(-EIO);
+		return;
+	}
+
+	init_waitqueue_entry(&m->poll_wait[i], m->poll_task->task);
+	add_wait_queue(wait_address, &m->poll_wait[i]);
+}
+
+/**
+ * p9_poll_mux - polls a mux and schedules read or write works if necessary
+ */
+static void p9_poll_mux(struct p9_conn *m)
+{
+	int n;
+
+	if (m->err < 0)
+		return;
+
+	n = m->trans->poll(m->trans, NULL);
+	if (n < 0 || n & (POLLERR | POLLHUP | POLLNVAL)) {
+		P9_DPRINTK(P9_DEBUG_MUX, "error mux %p err %d\n", m, n);
+		if (n >= 0)
+			n = -ECONNRESET;
+		p9_conn_cancel(m, n);
+	}
+
+	if (n & POLLIN) {
+		set_bit(Rpending, &m->wsched);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
+		if (!test_and_set_bit(Rworksched, &m->wsched)) {
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->rq);
+		}
+	}
+
+	if (n & POLLOUT) {
+		set_bit(Wpending, &m->wsched);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
+		if ((m->wsize || !list_empty(&m->unsent_req_list))
+		    && !test_and_set_bit(Wworksched, &m->wsched)) {
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->wq);
+		}
+	}
+}
+
+/**
+ * p9_poll_proc - polls all v9fs transports for new events and queues
+ * 	the appropriate work to the work queue
+ */
+static int p9_poll_proc(void *a)
+{
+	struct p9_conn *m, *mtmp;
+	struct p9_mux_poll_task *vpt;
+
+	vpt = a;
+	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
+			p9_poll_mux(m);
+		}
+
+		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
+		schedule_timeout(SCHED_TIMEOUT * HZ);
+	}
+
+	__set_current_state(TASK_RUNNING);
+	P9_DPRINTK(P9_DEBUG_MUX, "finish\n");
+	return 0;
+}
+
+/**
+ * p9_write_work - called when a transport can send some data
+ */
+static void p9_write_work(struct work_struct *work)
+{
+	int n, err;
+	struct p9_conn *m;
+	struct p9_req *req;
+
+	m = container_of(work, struct p9_conn, wq);
+
+	if (m->err < 0) {
+		clear_bit(Wworksched, &m->wsched);
+		return;
+	}
+
+	if (!m->wsize) {
+		if (list_empty(&m->unsent_req_list)) {
+			clear_bit(Wworksched, &m->wsched);
+			return;
+		}
+
+		spin_lock(&m->lock);
+again:
+		req = list_entry(m->unsent_req_list.next, struct p9_req,
+			       req_list);
+		list_move_tail(&req->req_list, &m->req_list);
+		if (req->err == ERREQFLUSH)
+			goto again;
+
+		m->wbuf = req->tcall->sdata;
+		m->wsize = req->tcall->size;
+		m->wpos = 0;
+		spin_unlock(&m->lock);
+	}
+
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p pos %d size %d\n", m, m->wpos, m->wsize);
+	clear_bit(Wpending, &m->wsched);
+	err = m->trans->write(m->trans, m->wbuf + m->wpos, m->wsize - m->wpos);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p sent %d bytes\n", m, err);
+	if (err == -EAGAIN) {
+		clear_bit(Wworksched, &m->wsched);
+		return;
+	}
+
+	if (err <= 0)
+		goto error;
+
+	m->wpos += err;
+	if (m->wpos == m->wsize)
+		m->wpos = m->wsize = 0;
+
+	if (m->wsize == 0 && !list_empty(&m->unsent_req_list)) {
+		if (test_and_clear_bit(Wpending, &m->wsched))
+			n = POLLOUT;
+		else
+			n = m->trans->poll(m->trans, NULL);
+
+		if (n & POLLOUT) {
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->wq);
+		} else
+			clear_bit(Wworksched, &m->wsched);
+	} else
+		clear_bit(Wworksched, &m->wsched);
+
+	return;
+
+      error:
+	p9_conn_cancel(m, err);
+	clear_bit(Wworksched, &m->wsched);
+}
+
+static void process_request(struct p9_conn *m, struct p9_req *req)
+{
+	int ecode;
+	struct p9_str *ename;
+
+	if (!req->err && req->rcall->id == P9_RERROR) {
+		ecode = req->rcall->params.rerror.errno;
+		ename = &req->rcall->params.rerror.error;
+
+		P9_DPRINTK(P9_DEBUG_MUX, "Rerror %.*s\n", ename->len, ename->str);
+
+		if (*m->extended)
+			req->err = -ecode;
+
+		if (!req->err) {
+			req->err = p9_errstr2errno(ename->str, ename->len);
+
+			if (!req->err) {	/* string match failed */
+				PRINT_FCALL_ERROR("unknown error", req->rcall);
+			}
+
+			if (!req->err)
+				req->err = -ESERVERFAULT;
+		}
+	} else if (req->tcall && req->rcall->id != req->tcall->id + 1) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "fcall mismatch: expected %d, got %d\n",
+			req->tcall->id + 1, req->rcall->id);
+		if (!req->err)
+			req->err = -EIO;
+	}
+}
+
+/**
+ * p9_read_work - called when there is some data to be read from a transport
+ */
+static void p9_read_work(struct work_struct *work)
+{
+	int n, err;
+	struct p9_conn *m;
+	struct p9_req *req, *rptr, *rreq;
+	struct p9_fcall *rcall;
+	char *rbuf;
+
+	m = container_of(work, struct p9_conn, rq);
+
+	if (m->err < 0)
+		return;
+
+	rcall = NULL;
+	P9_DPRINTK(P9_DEBUG_MUX, "start mux %p pos %d\n", m, m->rpos);
+
+	if (!m->rcall) {
+		m->rcall =
+		    kmalloc(sizeof(struct p9_fcall) + m->msize, GFP_KERNEL);
+		if (!m->rcall) {
+			err = -ENOMEM;
+			goto error;
+		}
+
+		m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
+		m->rpos = 0;
+	}
+
+	clear_bit(Rpending, &m->wsched);
+	err = m->trans->read(m->trans, m->rbuf + m->rpos, m->msize - m->rpos);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p got %d bytes\n", m, err);
+	if (err == -EAGAIN) {
+		clear_bit(Rworksched, &m->wsched);
+		return;
+	}
+
+	if (err <= 0)
+		goto error;
+
+	m->rpos += err;
+	while (m->rpos > 4) {
+		n = le32_to_cpu(*(__le32 *) m->rbuf);
+		if (n >= m->msize) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+				"requested packet size too big: %d\n", n);
+			err = -EIO;
+			goto error;
+		}
+
+		if (m->rpos < n)
+			break;
+
+		err =
+		    p9_deserialize_fcall(m->rbuf, n, m->rcall, *m->extended);
+		if (err < 0) {
+			goto error;
+		}
+
+#ifdef CONFIG_NET_9P_DEBUG
+		if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+			char buf[150];
+
+			p9_printfcall(buf, sizeof(buf), m->rcall,
+				*m->extended);
+			printk(KERN_NOTICE ">>> %p %s\n", m, buf);
+		}
+#endif
+
+		rcall = m->rcall;
+		rbuf = m->rbuf;
+		if (m->rpos > n) {
+			m->rcall = kmalloc(sizeof(struct p9_fcall) + m->msize,
+					   GFP_KERNEL);
+			if (!m->rcall) {
+				err = -ENOMEM;
+				goto error;
+			}
+
+			m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
+			memmove(m->rbuf, rbuf + n, m->rpos - n);
+			m->rpos -= n;
+		} else {
+			m->rcall = NULL;
+			m->rbuf = NULL;
+			m->rpos = 0;
+		}
+
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p fcall id %d tag %d\n", m, rcall->id,
+			rcall->tag);
+
+		req = NULL;
+		spin_lock(&m->lock);
+		list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
+			if (rreq->tag == rcall->tag) {
+				req = rreq;
+				if (req->flush != Flushing)
+					list_del(&req->req_list);
+				break;
+			}
+		}
+		spin_unlock(&m->lock);
+
+		if (req) {
+			req->rcall = rcall;
+			process_request(m, req);
+
+			if (req->flush != Flushing) {
+				if (req->cb)
+					(*req->cb) (req, req->cba);
+				else
+					kfree(req->rcall);
+
+				wake_up(&m->equeue);
+			}
+		} else {
+			if (err >= 0 && rcall->id != P9_RFLUSH)
+				P9_DPRINTK(P9_DEBUG_ERROR,
+					"unexpected response mux %p id %d tag %d\n",
+					m, rcall->id, rcall->tag);
+			kfree(rcall);
+		}
+	}
+
+	if (!list_empty(&m->req_list)) {
+		if (test_and_clear_bit(Rpending, &m->wsched))
+			n = POLLIN;
+		else
+			n = m->trans->poll(m->trans, NULL);
+
+		if (n & POLLIN) {
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->rq);
+		} else
+			clear_bit(Rworksched, &m->wsched);
+	} else
+		clear_bit(Rworksched, &m->wsched);
+
+	return;
+
+      error:
+	p9_conn_cancel(m, err);
+	clear_bit(Rworksched, &m->wsched);
+}
+
+/**
+ * p9_send_request - send 9P request
+ * The function can sleep until the request is scheduled for sending.
+ * The function can be interrupted. Return from the function is not
+ * a guarantee that the request is sent successfully. Can return errors
+ * that can be retrieved by PTR_ERR macros.
+ *
+ * @m: mux data
+ * @tc: request to be sent
+ * @cb: callback function to call when response is received
+ * @cba: parameter to pass to the callback function
+ */
+static struct p9_req *p9_send_request(struct p9_conn *m,
+					  struct p9_fcall *tc,
+					  p9_conn_req_callback cb, void *cba)
+{
+	int n;
+	struct p9_req *req;
+
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p task %p tcall %p id %d\n", m, current,
+		tc, tc->id);
+	if (m->err < 0)
+		return ERR_PTR(m->err);
+
+	req = kmalloc(sizeof(struct p9_req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	if (tc->id == P9_TVERSION)
+		n = P9_NOTAG;
+	else
+		n = p9_mux_get_tag(m);
+
+	if (n < 0)
+		return ERR_PTR(-ENOMEM);
+
+	p9_set_tag(tc, n);
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), tc, *m->extended);
+		printk(KERN_NOTICE "<<< %p %s\n", m, buf);
+	}
+#endif
+
+	spin_lock_init(&req->lock);
+	req->tag = n;
+	req->tcall = tc;
+	req->rcall = NULL;
+	req->err = 0;
+	req->cb = cb;
+	req->cba = cba;
+	req->flush = None;
+
+	spin_lock(&m->lock);
+	list_add_tail(&req->req_list, &m->unsent_req_list);
+	spin_unlock(&m->lock);
+
+	if (test_and_clear_bit(Wpending, &m->wsched))
+		n = POLLOUT;
+	else
+		n = m->trans->poll(m->trans, NULL);
+
+	if (n & POLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
+		queue_work(p9_mux_wq, &m->wq);
+
+	return req;
+}
+
+static void p9_mux_free_request(struct p9_conn *m, struct p9_req *req)
+{
+	p9_mux_put_tag(m, req->tag);
+	kfree(req);
+}
+
+static void p9_mux_flush_cb(struct p9_req *freq, void *a)
+{
+	p9_conn_req_callback cb;
+	int tag;
+	struct p9_conn *m;
+	struct p9_req *req, *rreq, *rptr;
+
+	m = a;
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p rc %p err %d oldtag %d\n", m,
+		freq->tcall, freq->rcall, freq->err,
+		freq->tcall->params.tflush.oldtag);
+
+	spin_lock(&m->lock);
+	cb = NULL;
+	tag = freq->tcall->params.tflush.oldtag;
+	req = NULL;
+	list_for_each_entry_safe(rreq, rptr, &m->req_list, req_list) {
+		if (rreq->tag == tag) {
+			req = rreq;
+			list_del(&req->req_list);
+			break;
+		}
+	}
+	spin_unlock(&m->lock);
+
+	if (req) {
+		spin_lock(&req->lock);
+		req->flush = Flushed;
+		spin_unlock(&req->lock);
+
+		if (req->cb)
+			(*req->cb) (req, req->cba);
+		else
+			kfree(req->rcall);
+
+		wake_up(&m->equeue);
+	}
+
+	kfree(freq->tcall);
+	kfree(freq->rcall);
+	p9_mux_free_request(m, freq);
+}
+
+static int
+p9_mux_flush_request(struct p9_conn *m, struct p9_req *req)
+{
+	struct p9_fcall *fc;
+	struct p9_req *rreq, *rptr;
+
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p tag %d\n", m, req, req->tag);
+
+	/* if a response was received for a request, do nothing */
+	spin_lock(&req->lock);
+	if (req->rcall || req->err) {
+		spin_unlock(&req->lock);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p response already
received\n", m, req);
+		return 0;
+	}
+
+	req->flush = Flushing;
+	spin_unlock(&req->lock);
+
+	spin_lock(&m->lock);
+	/* if the request is not sent yet, just remove it from the list */
+	list_for_each_entry_safe(rreq, rptr, &m->unsent_req_list, req_list) {
+		if (rreq->tag == req->tag) {
+			P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p request is not sent yet\n", m, req);
+			list_del(&rreq->req_list);
+			req->flush = Flushed;
+			spin_unlock(&m->lock);
+			if (req->cb)
+				(*req->cb) (req, req->cba);
+			return 0;
+		}
+	}
+	spin_unlock(&m->lock);
+
+	clear_thread_flag(TIF_SIGPENDING);
+	fc = p9_create_tflush(req->tag);
+	p9_send_request(m, fc, p9_mux_flush_cb, m);
+	return 1;
+}
+
+static void
+p9_conn_rpc_cb(struct p9_req *req, void *a)
+{
+	struct p9_mux_rpc *r;
+
+	P9_DPRINTK(P9_DEBUG_MUX, "req %p r %p\n", req, a);
+	r = a;
+	r->rcall = req->rcall;
+	r->err = req->err;
+
+	if (req->flush!=None && !req->err)
+		r->err = -ERESTARTSYS;
+
+	wake_up(&r->wqueue);
+}
+
+/**
+ * p9_mux_rpc - sends 9P request and waits until a response is available.
+ *	The function can be interrupted.
+ * @m: mux data
+ * @tc: request to be sent
+ * @rc: pointer where a pointer to the response is stored
+ */
+int
+p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc,
+	     struct p9_fcall **rc)
+{
+	int err, sigpending;
+	unsigned long flags;
+	struct p9_req *req;
+	struct p9_mux_rpc r;
+
+	r.err = 0;
+	r.tcall = tc;
+	r.rcall = NULL;
+	r.m = m;
+	init_waitqueue_head(&r.wqueue);
+
+	if (rc)
+		*rc = NULL;
+
+	sigpending = 0;
+	if (signal_pending(current)) {
+		sigpending = 1;
+		clear_thread_flag(TIF_SIGPENDING);
+	}
+
+	req = p9_send_request(m, tc, p9_conn_rpc_cb, &r);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
+		return err;
+	}
+
+	err = wait_event_interruptible(r.wqueue, r.rcall != NULL || r.err < 0);
+	if (r.err < 0)
+		err = r.err;
+
+	if (err == -ERESTARTSYS && m->trans->status == Connected && m->err == 0) {
+		if (p9_mux_flush_request(m, req)) {
+			/* wait until we get response of the flush message */
+			do {
+				clear_thread_flag(TIF_SIGPENDING);
+				err = wait_event_interruptible(r.wqueue,
+					r.rcall || r.err);
+			} while (!r.rcall && !r.err && err==-ERESTARTSYS &&
+				m->trans->status==Connected && !m->err);
+
+			err = -ERESTARTSYS;
+		}
+		sigpending = 1;
+	}
+
+	if (sigpending) {
+		spin_lock_irqsave(&current->sighand->siglock, flags);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	}
+
+	if (rc)
+		*rc = r.rcall;
+	else
+		kfree(r.rcall);
+
+	p9_mux_free_request(m, req);
+	if (err > 0)
+		err = -EIO;
+
+	return err;
+}
+EXPORT_SYMBOL(p9_conn_rpc);
+
+#if 0
+/**
+ * p9_conn_rpcnb - sends 9P request without waiting for response.
+ * @m: mux data
+ * @tc: request to be sent
+ * @cb: callback function to be called when response arrives
+ * @cba: value to pass to the callback function
+ */
+int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
+		   p9_conn_req_callback cb, void *a)
+{
+	int err;
+	struct p9_req *req;
+
+	req = p9_send_request(m, tc, cb, a);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
+		return PTR_ERR(req);
+	}
+
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p tag %d\n", m, tc, req->tag);
+	return 0;
+}
+EXPORT_SYMBOL(p9_conn_rpcnb);
+#endif  /*  0  */
+
+/**
+ * p9_conn_cancel - cancel all pending requests with error
+ * @m: mux data
+ * @err: error code
+ */
+void p9_conn_cancel(struct p9_conn *m, int err)
+{
+	struct p9_req *req, *rtmp;
+	LIST_HEAD(cancel_list);
+
+	P9_DPRINTK(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
+	m->err = err;
+	spin_lock(&m->lock);
+	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
+		list_move(&req->req_list, &cancel_list);
+	}
+	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
+		list_move(&req->req_list, &cancel_list);
+	}
+	spin_unlock(&m->lock);
+
+	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
+		list_del(&req->req_list);
+		if (!req->err)
+			req->err = err;
+
+		if (req->cb)
+			(*req->cb) (req, req->cba);
+		else
+			kfree(req->rcall);
+	}
+
+	wake_up(&m->equeue);
+}
+EXPORT_SYMBOL(p9_conn_cancel);
+
+static u16 p9_mux_get_tag(struct p9_conn *m)
+{
+	int tag;
+
+	tag = p9_idpool_get(m->tagpool);
+	if (tag < 0)
+		return P9_NOTAG;
+	else
+		return (u16) tag;
+}
+
+static void p9_mux_put_tag(struct p9_conn *m, u16 tag)
+{
+	if (tag != P9_NOTAG && p9_idpool_check(tag, m->tagpool))
+		p9_idpool_put(tag, m->tagpool);
+}
diff --git a/net/9p/sysctl.c b/net/9p/sysctl.c
new file mode 100644
index 0000000..e7fe706
--- /dev/null
+++ b/net/9p/sysctl.c
@@ -0,0 +1,86 @@
+/*
+ *  net/9p/sysctl.c
+ *
+ *  9P sysctl interface
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sysctl.h>
+#include <linux/init.h>
+#include <net/9p/9p.h>
+
+enum {
+	P9_SYSCTL_NET = 487,
+	P9_SYSCTL_DEBUG = 1,
+};
+
+static ctl_table p9_table[] = {
+#ifdef CONFIG_NET_9P_DEBUG
+	{
+		.ctl_name       = P9_SYSCTL_DEBUG,
+		.procname       = "debug",
+		.data           = &p9_debug_level,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec
+	},
+#endif
+	{	.ctl_name	= 0 },
+};
+
+static ctl_table p9_net_table[] = {
+	{
+		.ctl_name	= P9_SYSCTL_NET,
+		.procname	= "9p",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= p9_table,
+	},
+	{	.ctl_name	= 0 },
+};
+
+static ctl_table p9_ctl_table[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= p9_net_table,
+	},
+	{	.ctl_name	= 0 },
+};
+
+static struct ctl_table_header *p9_table_header;
+
+int __init p9_sysctl_register(void)
+{
+	p9_table_header = register_sysctl_table(p9_ctl_table);
+	if (!p9_table_header)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void __exit p9_sysctl_unregister(void)
+{
+	 unregister_sysctl_table(p9_table_header);
+}
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
new file mode 100644
index 0000000..cd33885
--- /dev/null
+++ b/net/9p/trans_fd.c
@@ -0,0 +1,354 @@
+/*
+ * linux/fs/9p/trans_fd.c
+ *
+ * Fd transport layer.  Includes deprecated socket layer.
+ *
+ *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
+ *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004-2005 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/in.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/un.h>
+#include <asm/uaccess.h>
+#include <linux/inet.h>
+#include <linux/idr.h>
+#include <linux/file.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+
+#define P9_PORT 564
+
+struct p9_trans_fd {
+	struct file *rd;
+	struct file *wr;
+};
+
+static int p9_socket_open(struct p9_transport *trans, struct socket *csocket);
+static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd);
+static int p9_fd_read(struct p9_transport *trans, void *v, int len);
+static int p9_fd_write(struct p9_transport *trans, void *v, int len);
+static unsigned int p9_fd_poll(struct p9_transport *trans,
+	struct poll_table_struct *pt);
+static void p9_fd_close(struct p9_transport *trans);
+
+struct p9_transport *p9_trans_create_tcp(const char *addr, int port)
+{
+	int err;
+	struct p9_transport *trans;
+	struct socket *csocket;
+	struct sockaddr_in sin_server;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	sin_server.sin_family = AF_INET;
+	sin_server.sin_addr.s_addr = in_aton(addr);
+	sin_server.sin_port = htons(port);
+	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
+
+	if (!csocket) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
+		err = -EIO;
+		goto error;
+	}
+
+	err = csocket->ops->connect(csocket,
+				    (struct sockaddr *)&sin_server,
+				    sizeof(struct sockaddr_in), 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_tcp: problem connecting socket to %s\n",
+			addr);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_tcp);
+
+struct p9_transport *p9_trans_create_unix(const char *addr)
+{
+	int err;
+	struct socket *csocket;
+	struct sockaddr_un sun_server;
+	struct p9_transport *trans;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	if (strlen(addr) > UNIX_PATH_MAX) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
+			addr);
+		err = -ENAMETOOLONG;
+		goto error;
+	}
+
+	sun_server.sun_family = PF_UNIX;
+	strcpy(sun_server.sun_path, addr);
+	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
+	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
+			sizeof(struct sockaddr_un) - 1, 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_unix: problem connecting socket: %s: %d\n",
+			addr, err);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_unix);
+
+struct p9_transport *p9_trans_create_fd(int rfd, int wfd)
+{
+	int err;
+	struct p9_transport *trans;
+
+	if (rfd == ~0 || wfd == ~0) {
+		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
+		return ERR_PTR(-ENOPROTOOPT);
+	}
+
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	err = p9_fd_open(trans, rfd, wfd);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_fd);
+
+static int p9_socket_open(struct p9_transport *trans, struct socket *csocket)
+{
+	int fd, ret;
+
+	csocket->sk->sk_allocation = GFP_NOIO;
+	fd = sock_map_fd(csocket);
+	if (fd < 0) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
+		return fd;
+	}
+
+	ret = p9_fd_open(trans, fd, fd);
+	if (ret < 0) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
+		sockfd_put(csocket);
+		return ret;
+	}
+
+	((struct p9_trans_fd *)trans->priv)->rd->f_flags |= O_NONBLOCK;
+
+	return 0;
+}
+
+static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd)
+{
+	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
+					   GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->rd = fget(rfd);
+	ts->wr = fget(wfd);
+	if (!ts->rd || !ts->wr) {
+		if (ts->rd)
+			fput(ts->rd);
+		if (ts->wr)
+			fput(ts->wr);
+		kfree(ts);
+		return -EIO;
+	}
+
+	trans->priv = ts;
+	trans->status = Connected;
+
+	return 0;
+}
+
+/**
+ * p9_fd_read- read from a fd
+ * @v9ses: session information
+ * @v: buffer to receive data into
+ * @len: size of receive buffer
+ *
+ */
+static int p9_fd_read(struct p9_transport *trans, void *v, int len)
+{
+	int ret;
+	struct p9_trans_fd *ts;
+
+	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
+		return -EREMOTEIO;
+
+	if (!(ts->rd->f_flags & O_NONBLOCK))
+		P9_DPRINTK(P9_DEBUG_ERROR, "blocking read ...\n");
+
+	ret = kernel_read(ts->rd, ts->rd->f_pos, v, len);
+	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
+		trans->status = Disconnected;
+	return ret;
+}
+
+/**
+ * p9_fd_write - write to a socket
+ * @v9ses: session information
+ * @v: buffer to send data from
+ * @len: size of send buffer
+ *
+ */
+static int p9_fd_write(struct p9_transport *trans, void *v, int len)
+{
+	int ret;
+	mm_segment_t oldfs;
+	struct p9_trans_fd *ts;
+
+	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
+		return -EREMOTEIO;
+
+	if (!(ts->wr->f_flags & O_NONBLOCK))
+		P9_DPRINTK(P9_DEBUG_ERROR, "blocking write ...\n");
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	ret = vfs_write(ts->wr, (void __user *)v, len, &ts->wr->f_pos);
+	set_fs(oldfs);
+
+	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
+		trans->status = Disconnected;
+	return ret;
+}
+
+static unsigned int
+p9_fd_poll(struct p9_transport *trans, struct poll_table_struct *pt)
+{
+	int ret, n;
+	struct p9_trans_fd *ts;
+	mm_segment_t oldfs;
+
+	if (!trans || trans->status != Connected || !(ts = trans->priv))
+		return -EREMOTEIO;
+
+	if (!ts->rd->f_op || !ts->rd->f_op->poll)
+		return -EIO;
+
+	if (!ts->wr->f_op || !ts->wr->f_op->poll)
+		return -EIO;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+
+	ret = ts->rd->f_op->poll(ts->rd, pt);
+	if (ret < 0)
+		goto end;
+
+	if (ts->rd != ts->wr) {
+		n = ts->wr->f_op->poll(ts->wr, pt);
+		if (n < 0) {
+			ret = n;
+			goto end;
+		}
+		ret = (ret & ~POLLOUT) | (n & ~POLLIN);
+	}
+
+      end:
+	set_fs(oldfs);
+	return ret;
+}
+
+/**
+ * p9_sock_close - shutdown socket
+ * @trans: private socket structure
+ *
+ */
+static void p9_fd_close(struct p9_transport *trans)
+{
+	struct p9_trans_fd *ts;
+
+	if (!trans)
+		return;
+
+	ts = xchg(&trans->priv, NULL);
+
+	if (!ts)
+		return;
+
+	trans->status = Disconnected;
+	if (ts->rd)
+		fput(ts->rd);
+	if (ts->wr)
+		fput(ts->wr);
+	kfree(ts);
+}
+
diff --git a/net/9p/util.c b/net/9p/util.c
new file mode 100644
index 0000000..22077b7
--- /dev/null
+++ b/net/9p/util.c
@@ -0,0 +1,125 @@
+/*
+ *  net/9p/util.c
+ *
+ *  This file contains some helper functions
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/parser.h>
+#include <linux/idr.h>
+#include <net/9p/9p.h>
+
+struct p9_idpool {
+	struct semaphore lock;
+	struct idr pool;
+};
+
+struct p9_idpool *p9_idpool_create(void)
+{
+	struct p9_idpool *p;
+
+	p = kmalloc(sizeof(struct p9_idpool), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	init_MUTEX(&p->lock);
+	idr_init(&p->pool);
+
+	return p;
+}
+EXPORT_SYMBOL(p9_idpool_create);
+
+void p9_idpool_destroy(struct p9_idpool *p)
+{
+	idr_destroy(&p->pool);
+	kfree(p);
+}
+EXPORT_SYMBOL(p9_idpool_destroy);
+
+/**
+ * p9_idpool_get - allocate numeric id from pool
+ * @p - pool to allocate from
+ *
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
+ *            the lock included in struct idr?
+ */
+
+int p9_idpool_get(struct p9_idpool *p)
+{
+	int i = 0;
+	int error;
+
+retry:
+	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
+		return 0;
+
+	if (down_interruptible(&p->lock) == -EINTR) {
+		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
+		return -1;
+	}
+
+	/* no need to store exactly p, we just need something non-null */
+	error = idr_get_new(&p->pool, p, &i);
+	up(&p->lock);
+
+	if (error == -EAGAIN)
+		goto retry;
+	else if (error)
+		return -1;
+
+	return i;
+}
+EXPORT_SYMBOL(p9_idpool_get);
+
+/**
+ * p9_idpool_put - release numeric id from pool
+ * @p - pool to allocate from
+ *
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
+ *            the lock included in struct idr?
+ */
+
+void p9_idpool_put(int id, struct p9_idpool *p)
+{
+	if (down_interruptible(&p->lock) == -EINTR) {
+		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
+		return;
+	}
+	idr_remove(&p->pool, id);
+	up(&p->lock);
+}
+EXPORT_SYMBOL(p9_idpool_put);
+
+/**
+ * p9_idpool_check - check if the specified id is available
+ * @id - id to check
+ * @p - pool
+ */
+int p9_idpool_check(int id, struct p9_idpool *p)
+{
+	return idr_find(&p->pool, id) != NULL;
+}
+EXPORT_SYMBOL(p9_idpool_check);
diff --git a/net/Kconfig b/net/Kconfig
index caeacd1..b1267cd 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -226,6 +226,7 @@ source "net/ieee80211/Kconfig"
 endmenu

 source "net/rfkill/Kconfig"
+source "net/9p/Kconfig"

 endif   # if NET
 endmenu # Networking
diff --git a/net/Makefile b/net/Makefile
index 34e5b2d..4037678 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_RFKILL)		+= rfkill/
+obj-$(CONFIG_NET_9P)		+= 9p/

 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
-- 
1.4.4.2
