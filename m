Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXI3XGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXI3XGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXI3XFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:24 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57195 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048AbXI3XFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:13 -0400
Date: Sun, 30 Sep 2007 16:37:43 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 1/6] 9p: 9P server low-level 9P messages support
Message-ID: <20070930223743.GA25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

Implement support for the 9P messages required by the server side.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 include/net/9p/9p.h |   19 ++
 net/9p/conv.c       |  508 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 net/9p/fcprint.c    |    2 +
 3 files changed, 525 insertions(+), 4 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 686425a..eaa2385 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -65,6 +65,7 @@ do { \
 
 /* Message Types */
 enum {
+	P9_FIRST = 100,
 	P9_TVERSION = 100,
 	P9_RVERSION,
 	P9_TAUTH = 102,
@@ -93,6 +94,7 @@ enum {
 	P9_RSTAT,
 	P9_TWSTAT = 126,
 	P9_RWSTAT,
+	P9_LAST,
 };
 
 /* open modes */
@@ -381,6 +383,7 @@ struct p9_idpool;
 int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
 	int dotu);
 int p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *fc, int dotu);
+int p9_serialize_stat(struct p9_wstat *wstat, u8 *buf, int buflen, int dotu);
 void p9_set_tag(struct p9_fcall *fc, u16 tag);
 struct p9_fcall *p9_create_tversion(u32 msize, char *version);
 struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname,
@@ -403,6 +406,22 @@ struct p9_fcall *p9_create_tremove(u32 fid);
 struct p9_fcall *p9_create_tstat(u32 fid);
 struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
 	int dotu);
+struct p9_fcall *p9_create_rversion(u32 msize, char *version);
+struct p9_fcall *p9_create_rattach(struct p9_qid *qid);
+struct p9_fcall *p9_create_rerror(char *ename, u32 ecode, int dotu);
+struct p9_fcall *p9_create_rauth(struct p9_qid *qid);
+struct p9_fcall *p9_create_rflush(void);
+struct p9_fcall *p9_create_rwalk(int nwqid, struct p9_qid *wqids);
+struct p9_fcall *p9_create_ropen(struct p9_qid *qid, u32 iounit);
+struct p9_fcall *p9_create_rcreate(struct p9_qid *qid, u32 iounit);
+struct p9_fcall *p9_create_rread(u32 count, u8 *data);
+struct p9_fcall *p9_create_rwrite(u32 count);
+struct p9_fcall *p9_create_rclunk(void);
+struct p9_fcall *p9_create_rremove(void);
+struct p9_fcall *p9_create_rstat(struct p9_wstat *st, int dotu);
+struct p9_fcall *p9_create_rwstat(void);
+struct p9_fcall *p9_alloc_rread(u32 count);
+void p9_set_rread_count(struct p9_fcall *fc, u32 count);
 
 int p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int dotu);
 int p9_errstr2errno(char *errstr, int len);
diff --git a/net/9p/conv.c b/net/9p/conv.c
index aa2aa98..7cb8faf 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -41,6 +41,8 @@ struct cbuf {
 	unsigned char *ep;
 };
 
+static int p9_size_wstat(struct p9_wstat *wstat, int dotu);
+
 static inline void buf_init(struct cbuf *buf, void *data, int datalen)
 {
 	buf->sp = buf->p = data;
@@ -130,9 +132,45 @@ static char *buf_put_stringn(struct cbuf *buf, const char *s, u16 slen)
 
 static inline void buf_put_string(struct cbuf *buf, const char *s)
 {
-	buf_put_stringn(buf, s, strlen(s));
+	buf_put_stringn(buf, s, s?strlen(s):0);
+}
+
+static inline void buf_put_qid(struct cbuf *buf, struct p9_qid *qid)
+{
+	buf_put_int8(buf, qid->type);
+	buf_put_int32(buf, qid->version);
+	buf_put_int64(buf, qid->path);
+}
+
+static inline void buf_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
+	int dotu)
+{
+	int statsz;
+
+	statsz = p9_size_wstat(wstat, dotu);
+	buf_put_int16(bufp, statsz);
+	buf_put_int16(bufp, wstat->type);
+	buf_put_int32(bufp, wstat->dev);
+	buf_put_qid(bufp, &wstat->qid);
+	buf_put_int32(bufp, wstat->mode);
+	buf_put_int32(bufp, wstat->atime);
+	buf_put_int32(bufp, wstat->mtime);
+	buf_put_int64(bufp, wstat->length);
+
+	buf_put_string(bufp, wstat->name);
+	buf_put_string(bufp, wstat->uid);
+	buf_put_string(bufp, wstat->gid);
+	buf_put_string(bufp, wstat->muid);
+
+	if (dotu) {
+		buf_put_string(bufp, wstat->extension);
+		buf_put_int32(bufp, wstat->n_uid);
+		buf_put_int32(bufp, wstat->n_gid);
+		buf_put_int32(bufp, wstat->n_muid);
+	}
 }
 
+
 static u8 buf_get_int8(struct cbuf *buf)
 {
 	u8 ret = 0;
@@ -344,17 +382,63 @@ p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
 	default:
 		P9_EPRINTK(KERN_ERR, "unknown message type: %d\n", rcall->id);
 		return -EPROTO;
+	case P9_TVERSION:
+		rcall->params.tversion.msize = buf_get_int32(bufp);
+		buf_get_str(bufp, &rcall->params.tversion.version);
+		break;
 	case P9_RVERSION:
 		rcall->params.rversion.msize = buf_get_int32(bufp);
 		buf_get_str(bufp, &rcall->params.rversion.version);
 		break;
+	case P9_TAUTH:
+		rcall->params.tauth.afid = buf_get_int32(bufp);
+		buf_get_str(bufp, &rcall->params.tauth.uname);
+		buf_get_str(bufp, &rcall->params.tauth.aname);
+		if (dotu)
+			rcall->params.tauth.n_uname = buf_get_int32(bufp);
+		else
+			rcall->params.tauth.n_uname = ~0;
+		break;
+	case P9_RAUTH:
+		rcall->params.rauth.qid.type = buf_get_int8(bufp);
+		rcall->params.rauth.qid.version = buf_get_int32(bufp);
+		rcall->params.rauth.qid.path = buf_get_int64(bufp);
+		break;
+	case P9_TFLUSH:
+		rcall->params.tflush.oldtag = buf_get_int16(bufp);
+		break;
 	case P9_RFLUSH:
 		break;
+	case P9_TATTACH:
+		rcall->params.tattach.fid = buf_get_int32(bufp);
+		rcall->params.tattach.afid = buf_get_int32(bufp);
+		buf_get_str(bufp, &rcall->params.tattach.uname);
+		buf_get_str(bufp, &rcall->params.tattach.aname);
+		if (dotu)
+			rcall->params.tattach.n_uname = buf_get_int32(bufp);
+		else
+			rcall->params.tattach.n_uname = ~0;
+
+		break;
 	case P9_RATTACH:
 		rcall->params.rattach.qid.type = buf_get_int8(bufp);
 		rcall->params.rattach.qid.version = buf_get_int32(bufp);
 		rcall->params.rattach.qid.path = buf_get_int64(bufp);
 		break;
+	case P9_TWALK:
+		rcall->params.twalk.fid = buf_get_int32(bufp);
+		rcall->params.twalk.newfid = buf_get_int32(bufp);
+		rcall->params.twalk.nwname = buf_get_int16(bufp);
+		if (rcall->params.twalk.nwname > P9_MAXWELEM) {
+			P9_EPRINTK(KERN_ERR,
+				"Rwalk with more than %d qids: %d\n",
+				P9_MAXWELEM, rcall->params.twalk.nwname);
+			return -EPROTO;
+		}
+
+		for (i = 0; i < rcall->params.twalk.nwname; i++)
+			buf_get_str(bufp, &rcall->params.twalk.wnames[i]);
+		break;
 	case P9_RWALK:
 		rcall->params.rwalk.nwqid = buf_get_int16(bufp);
 		if (rcall->params.rwalk.nwqid > P9_MAXWELEM) {
@@ -367,30 +451,66 @@ p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
 		for (i = 0; i < rcall->params.rwalk.nwqid; i++)
 			buf_get_qid(bufp, &rcall->params.rwalk.wqids[i]);
 		break;
+	case P9_TOPEN:
+		rcall->params.topen.fid = buf_get_int32(bufp);
+		rcall->params.topen.mode = buf_get_int8(bufp);
+		break;
 	case P9_ROPEN:
 		buf_get_qid(bufp, &rcall->params.ropen.qid);
 		rcall->params.ropen.iounit = buf_get_int32(bufp);
 		break;
+	case P9_TCREATE:
+		rcall->params.tcreate.fid = buf_get_int32(bufp);
+		buf_get_str(bufp, &rcall->params.tcreate.name);
+		rcall->params.tcreate.perm = buf_get_int32(bufp);
+		rcall->params.tcreate.mode = buf_get_int8(bufp);
+		break;
 	case P9_RCREATE:
 		buf_get_qid(bufp, &rcall->params.rcreate.qid);
 		rcall->params.rcreate.iounit = buf_get_int32(bufp);
 		break;
+	case P9_TREAD:
+		rcall->params.tread.fid = buf_get_int32(bufp);
+		rcall->params.tread.offset = buf_get_int64(bufp);
+		rcall->params.tread.count = buf_get_int32(bufp);
+		break;
 	case P9_RREAD:
 		rcall->params.rread.count = buf_get_int32(bufp);
 		rcall->params.rread.data = bufp->p;
 		buf_check_size(bufp, rcall->params.rread.count);
 		break;
+	case P9_TWRITE:
+		rcall->params.twrite.fid = buf_get_int32(bufp);
+		rcall->params.twrite.offset = buf_get_int64(bufp);
+		rcall->params.twrite.count = buf_get_int32(bufp);
+		rcall->params.twrite.data = buf_alloc(bufp,
+			rcall->params.twrite.count);
+		break;
 	case P9_RWRITE:
 		rcall->params.rwrite.count = buf_get_int32(bufp);
 		break;
+	case P9_TCLUNK:
+		rcall->params.tclunk.fid = buf_get_int32(bufp);
+		break;
 	case P9_RCLUNK:
 		break;
+	case P9_TREMOVE:
+		rcall->params.tremove.fid = buf_get_int32(bufp);
+		break;
 	case P9_RREMOVE:
 		break;
+	case P9_TSTAT:
+		rcall->params.tstat.fid = buf_get_int32(bufp);
+		break;
 	case P9_RSTAT:
 		buf_get_int16(bufp);
 		buf_get_stat(bufp, &rcall->params.rstat.stat, dotu);
 		break;
+	case P9_TWSTAT:
+		rcall->params.twstat.fid = buf_get_int32(bufp);
+		buf_get_int16(bufp);
+		buf_get_stat(bufp, &rcall->params.twstat.stat, dotu);
+		break;
 	case P9_RWSTAT:
 		break;
 	case P9_RERROR:
@@ -468,6 +588,14 @@ p9_put_user_data(struct cbuf *bufp, const char __user *data, int count,
 	return copy_from_user(*pdata, data, count);
 }
 
+static void p9_put_qid(struct cbuf *buf, struct p9_qid *qid,
+	struct p9_qid *pqid)
+{
+	p9_put_int8(buf, qid->type, &pqid->type);
+	p9_put_int32(buf, qid->version, &pqid->version);
+	p9_put_int64(buf, qid->path, &pqid->path);
+}
+
 static void
 p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	       struct p9_stat *stat, int statsz, int dotu)
@@ -475,9 +603,7 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	p9_put_int16(bufp, statsz, &stat->size);
 	p9_put_int16(bufp, wstat->type, &stat->type);
 	p9_put_int32(bufp, wstat->dev, &stat->dev);
-	p9_put_int8(bufp, wstat->qid.type, &stat->qid.type);
-	p9_put_int32(bufp, wstat->qid.version, &stat->qid.version);
-	p9_put_int64(bufp, wstat->qid.path, &stat->qid.path);
+	p9_put_qid(bufp, &wstat->qid, &stat->qid);
 	p9_put_int32(bufp, wstat->mode, &stat->mode);
 	p9_put_int32(bufp, wstat->atime, &stat->atime);
 	p9_put_int32(bufp, wstat->mtime, &stat->mtime);
@@ -496,6 +622,23 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
 	}
 }
 
+int p9_serialize_stat(struct p9_wstat *wstat, u8 *buf, int buflen, int dotu)
+{
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+	unsigned char *p;
+
+	buf_init(bufp, buf, buflen);
+	p = bufp->p;
+	buf_put_wstat(bufp, wstat, dotu);
+
+	if (buf_check_overflow(bufp))
+		return 0;
+	else
+		return bufp->p - p;
+}
+EXPORT_SYMBOL(p9_serialize_stat);
+
 static struct p9_fcall *
 p9_create_common(struct cbuf *bufp, u32 size, u8 id)
 {
@@ -927,3 +1070,360 @@ error:
 	return fc;
 }
 EXPORT_SYMBOL(p9_create_twstat);
+
+struct p9_fcall *p9_create_rversion(u32 msize, char *version)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 2 + strlen(version);		/* msize[4] version[s] */
+	fc = p9_create_common(bufp, size, P9_RVERSION);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, msize, &fc->params.rversion.msize);
+	p9_put_str(bufp, version, &fc->params.rversion.version);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rversion);
+
+struct p9_fcall *p9_create_rattach(struct p9_qid *qid)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13;		/* qid[13] */
+	fc = p9_create_common(bufp, size, P9_RATTACH);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_qid(bufp, qid, &fc->params.rattach.qid);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rattach);
+
+struct p9_fcall *p9_create_rerror(char *ename, u32 ecode, int dotu)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 2 + strlen(ename);		/* ename[s] */
+	if (dotu)
+		size += 4;			/* ecode[4] */
+
+	fc = p9_create_common(bufp, size, P9_RERROR);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_str(bufp, ename, &fc->params.rerror.error);
+	if (dotu)
+		p9_put_int32(bufp, ecode, &fc->params.rerror.errno);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rerror);
+
+struct p9_fcall *p9_create_rauth(struct p9_qid *qid)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13;		/* qid[13] */
+	fc = p9_create_common(bufp, size, P9_RATTACH);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_qid(bufp, qid, &fc->params.rattach.qid);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rauth);
+
+struct p9_fcall *p9_create_rflush(void)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	fc = p9_create_common(bufp, size, P9_RFLUSH);
+	if (IS_ERR(fc))
+		goto error;
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rflush);
+
+struct p9_fcall *p9_create_rwalk(int nwqid, struct p9_qid *wqids)
+{
+	int i, size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 2 + nwqid * 13;		/* nwqid[2] nwqid*wqid[13] */
+	fc = p9_create_common(bufp, size, P9_RWALK);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int16(bufp, nwqid, &fc->params.rwalk.nwqid);
+	for (i = 0; i < nwqid; i++)
+		p9_put_qid(bufp, &wqids[i], &fc->params.rwalk.wqids[i]);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rwalk);
+
+struct p9_fcall *p9_create_ropen(struct p9_qid *qid, u32 iounit)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13 + 4;		/* qid[13] iounit[4] */
+	fc = p9_create_common(bufp, size, P9_ROPEN);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_qid(bufp, qid, &fc->params.ropen.qid);
+	p9_put_int32(bufp, iounit, &fc->params.ropen.iounit);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_ropen);
+
+struct p9_fcall *p9_create_rcreate(struct p9_qid *qid, u32 iounit)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13 + 4;		/* qid[13] iounit[4] */
+	fc = p9_create_common(bufp, size, P9_RCREATE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_qid(bufp, qid, &fc->params.rcreate.qid);
+	p9_put_int32(bufp, iounit, &fc->params.rcreate.iounit);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rcreate);
+
+struct p9_fcall *p9_alloc_rread(u32 count)
+{
+	int size;
+	char *p;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + count;		/* count[4] data[count] */
+	fc = p9_create_common(bufp, size, P9_RREAD);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, count, &fc->params.rread.count);
+	p = buf_alloc(bufp, count);
+	fc->params.rread.data = p;
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_alloc_rread);
+
+void p9_set_rread_count(struct p9_fcall *fc, u32 count)
+{
+	int n;
+	struct cbuf buffer;
+	struct cbuf *bufp;
+
+	n = 4 + 1 + 2 + 4 + count;/*size[4] id[1] tag[2] count[4] data[count]*/
+	bufp = &buffer;
+	buf_init(bufp, (char *) fc->sdata, n);
+	p9_put_int32(bufp, n, &fc->size);
+	buf_init(bufp, (char *) fc->sdata + 7, n - 7);
+	p9_put_int32(bufp, count, &fc->params.rread.count);
+}
+EXPORT_SYMBOL(p9_set_rread_count);
+
+struct p9_fcall *p9_create_rread(u32 count, u8 *data)
+{
+	struct p9_fcall *fc;
+
+	fc = p9_alloc_rread(count);
+	if (IS_ERR(fc))
+		return fc;
+
+	memmove(fc->params.rread.data, data, count);
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rread);
+
+struct p9_fcall *p9_create_rwrite(u32 count)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4;		/* count[4] */
+	fc = p9_create_common(bufp, size, P9_RWRITE);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, count, &fc->params.rwrite.count);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rwrite);
+
+struct p9_fcall *p9_create_rclunk(void)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	fc = p9_create_common(bufp, size, P9_RCLUNK);
+	if (IS_ERR(fc))
+		goto error;
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rclunk);
+
+struct p9_fcall *p9_create_rremove(void)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	fc = p9_create_common(bufp, size, P9_RREMOVE);
+	if (IS_ERR(fc))
+		goto error;
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rremove);
+
+struct p9_fcall *p9_create_rstat(struct p9_wstat *st, int dotu)
+{
+	int size, statsz;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	statsz = p9_size_wstat(st, dotu);
+	size = 2 + 2 + statsz;		/* stat[n] */
+	fc = p9_create_common(bufp, size, P9_RSTAT);
+	if (IS_ERR(fc))
+		goto error;
+
+	buf_put_int16(bufp, statsz + 2);
+	p9_put_wstat(bufp, st, &fc->params.rstat.stat, statsz, dotu);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rstat);
+
+struct p9_fcall *p9_create_rwstat(void)
+{
+	int size;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	fc = p9_create_common(bufp, size, P9_RWSTAT);
+	if (IS_ERR(fc))
+		goto error;
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_rwstat);
diff --git a/net/9p/fcprint.c b/net/9p/fcprint.c
index b1ae8ec..3c5cd83 100644
--- a/net/9p/fcprint.c
+++ b/net/9p/fcprint.c
@@ -347,8 +347,10 @@ p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 
 	return ret;
 }
+EXPORT_SYMBOL(p9_printfcall);
 
 #else
+
 int
 p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 {
-- 
1.5.2.4

