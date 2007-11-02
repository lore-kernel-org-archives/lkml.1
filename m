Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXKBRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXKBRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXKBRDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:03:04 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45958 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754115AbXKBRDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:03:01 -0400
Date: Fri, 2 Nov 2007 11:02:59 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/10] 9p: marshalling changes for in-kernel server
Message-ID: <20071102170259.GF16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements serialization/deserialization for the server-side 9P
messages.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 include/net/9p/9p.h |   16 ++
 net/9p/conv.c       |  457 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 462 insertions(+), 11 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 8de6eef..08c4dd1 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -379,6 +379,7 @@ struct p9_fcall {
 struct p9_idpool;
 extern struct kset p9_subsys;
 
+int p9_serialize_stat(struct p9_wstat *wstat, u8 *buf, int buflen, int dotu);
 int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
 	int dotu);
 int p9_deserialize_fcall(struct p9_fcall *fc, int dotu);
@@ -407,6 +408,21 @@ struct p9_fcall *p9_create_tremove(u32 fid);
 struct p9_fcall *p9_create_tstat(u32 fid);
 struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
 	int dotu);
+int p9_create_rversion(struct p9_fcall *, u32 msize, char *version);
+int p9_create_rattach(struct p9_fcall *, struct p9_qid *qid);
+int p9_create_rerror(struct p9_fcall *, char *ename, u32 ecode, int dotu);
+int p9_create_rauth(struct p9_fcall *, struct p9_qid *qid);
+int p9_create_rflush(struct p9_fcall *);
+int p9_create_rwalk(struct p9_fcall *, int nwqid, struct p9_qid *wqids);
+int p9_create_ropen(struct p9_fcall *, struct p9_qid *qid, u32 iounit);
+int p9_create_rcreate(struct p9_fcall *, struct p9_qid *qid, u32 iounit);
+int p9_init_rread(struct p9_fcall *fc);
+void p9_set_rread_count(struct p9_fcall *fc, u32 count);
+int p9_create_rwrite(struct p9_fcall *, u32 count);
+int p9_create_rclunk(struct p9_fcall *);
+int p9_create_rremove(struct p9_fcall *);
+int p9_create_rstat(struct p9_fcall *, struct p9_wstat *st, int dotu);
+int p9_create_rwstat(struct p9_fcall *);
 
 int p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int dotu);
 int p9_errstr2errno(char *errstr, int len);
diff --git a/net/9p/conv.c b/net/9p/conv.c
index 74d57c7..ed119bc 100644
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
@@ -133,6 +135,41 @@ static inline void buf_put_string(struct cbuf *buf, const char *s)
 	buf_put_stringn(buf, s, s?strlen(s):0);
 }
 
+static inline void buf_put_qid(struct cbuf *buf, struct p9_qid *qid)
+{
+	buf_put_int8(buf, qid->type);
+	buf_put_int32(buf, qid->version);
+	buf_put_int64(buf, qid->path);
+}
+
+static inline void buf_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
+								int dotu)
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
+}
+
 static u8 buf_get_int8(struct cbuf *buf)
 {
 	u8 ret = 0;
@@ -181,6 +218,15 @@ static u64 buf_get_int64(struct cbuf *buf)
 	return ret;
 }
 
+static void buf_get_data(struct cbuf *buf, u32 count, u8 **data)
+{
+	if (buf_check_size(buf, count)) {
+		*data = buf->p;
+		buf->p += count;
+	} else
+		*data = NULL;
+}
+
 static void buf_get_str(struct cbuf *buf, struct p9_str *vstr)
 {
 	vstr->len = buf_get_int16(buf);
@@ -346,17 +392,63 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
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
@@ -369,30 +461,68 @@ int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
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
+		if (dotu)
+			buf_get_str(bufp, &rcall->params.tcreate.extension);
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
-		rcall->params.rread.data = bufp->p;
-		buf_check_size(bufp, rcall->params.rread.count);
+		buf_get_data(bufp, rcall->params.rread.count,
+			&rcall->params.rread.data);
+		break;
+	case P9_TWRITE:
+		rcall->params.twrite.fid = buf_get_int32(bufp);
+		rcall->params.twrite.offset = buf_get_int64(bufp);
+		rcall->params.twrite.count = buf_get_int32(bufp);
+		buf_get_data(bufp, rcall->params.twrite.count,
+			&rcall->params.twrite.data);
 		break;
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
@@ -453,6 +583,14 @@ p9_put_str(struct cbuf *bufp, char *data, struct p9_str *str)
 	}
 }
 
+static void p9_put_qid(struct cbuf *buf, struct p9_qid *qid,
+	struct p9_qid *pqid)
+{
+	p9_put_int8(buf, qid->type, &pqid->type);
+	p9_put_int32(buf, qid->version, &pqid->version);
+	p9_put_int64(buf, qid->path, &pqid->path);
+}
+
 static int
 p9_put_data(struct cbuf *bufp, const char *data, int count,
 		   unsigned char **pdata)
@@ -498,6 +636,23 @@ p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
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
 struct p9_fcall *p9_fcall_alloc(u32 size)
 {
 	struct p9_fcall *fc;
@@ -512,23 +667,46 @@ struct p9_fcall *p9_fcall_alloc(u32 size)
 }
 EXPORT_SYMBOL(p9_fcall_alloc);
 
-static struct p9_fcall *
-p9_create_common(struct cbuf *bufp, u32 size, u8 id)
+static int p9_fcall_init(struct cbuf *bufp, struct p9_fcall *fc,
+	u32 size, u8 id)
 {
-	struct p9_fcall *fc;
-
 	size += 4 + 1 + 2;	/* size[4] id[1] tag[2] */
-	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
-	if (!fc)
-		return ERR_PTR(-ENOMEM);
-
-	fc->sdata = (char *)fc + sizeof(*fc);
+	if (fc->size < size)
+		return -ENOMEM;
 
 	buf_init(bufp, (char *)fc->sdata, size);
 	p9_put_int32(bufp, size, &fc->size);
 	p9_put_int8(bufp, id, &fc->id);
 	p9_put_int16(bufp, P9_NOTAG, &fc->tag);
 
+	return 0;
+}
+
+static inline int p9_fcall_finish(struct cbuf *bufp)
+{
+	int ret;
+
+	ret = buf_check_overflow(bufp)?-ENOMEM:0;
+	return ret;
+}
+
+static struct p9_fcall *
+p9_create_common(struct cbuf *bufp, u32 size, u8 id)
+{
+	int n, err;
+	struct p9_fcall *fc;
+
+	n = size + 4 + 1 + 2;	/* size[4] id[1] tag[2] */
+	fc = p9_fcall_alloc(n);
+	if (IS_ERR(fc))
+		return fc;
+
+	err = p9_fcall_init(bufp, fc, size, id);
+	if (err < 0) {
+		kfree(fc);
+		return ERR_PTR(err);
+	}
+
 	return fc;
 }
 
@@ -944,6 +1122,263 @@ error:
 }
 EXPORT_SYMBOL(p9_create_twstat);
 
+int p9_create_rversion(struct p9_fcall *fc, u32 msize, char *version)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 2 + strlen(version);		/* msize[4] version[s] */
+	err = p9_fcall_init(bufp, fc, size, P9_RVERSION);
+	if (err < 0)
+		return err;
+
+	p9_put_int32(bufp, msize, &fc->params.rversion.msize);
+	p9_put_str(bufp, version, &fc->params.rversion.version);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rversion);
+
+int p9_create_rattach(struct p9_fcall *fc, struct p9_qid *qid)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13;		/* qid[13] */
+	err = p9_fcall_init(bufp, fc, size, P9_RATTACH);
+	if (err < 0)
+		return err;
+
+	p9_put_qid(bufp, qid, &fc->params.rattach.qid);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rattach);
+
+int p9_create_rerror(struct p9_fcall *fc, char *ename, u32 ecode, int dotu)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 2 + strlen(ename);		/* ename[s] */
+	if (dotu)
+		size += 4;			/* ecode[4] */
+
+	err = p9_fcall_init(bufp, fc, size, P9_RERROR);
+	if (err < 0)
+		return err;
+
+	p9_put_str(bufp, ename, &fc->params.rerror.error);
+	if (dotu)
+		p9_put_int32(bufp, ecode, &fc->params.rerror.errno);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rerror);
+
+int p9_create_rauth(struct p9_fcall *fc, struct p9_qid *qid)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13;		/* qid[13] */
+	err = p9_fcall_init(bufp, fc, size, P9_RAUTH);
+	if (err < 0)
+		return err;
+
+	p9_put_qid(bufp, qid, &fc->params.rattach.qid);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rauth);
+
+int p9_create_rflush(struct p9_fcall *fc)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	err = p9_fcall_init(bufp, fc, size, P9_RFLUSH);
+	if (err < 0)
+		return err;
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rflush);
+
+int p9_create_rwalk(struct p9_fcall *fc, int nwqid, struct p9_qid *wqids)
+{
+	int i, err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 2 + nwqid * 13;		/* nwqid[2] nwqid*wqid[13] */
+	err = p9_fcall_init(bufp, fc, size, P9_RWALK);
+	if (err < 0)
+		return err;
+
+	p9_put_int16(bufp, nwqid, &fc->params.rwalk.nwqid);
+	for (i = 0; i < nwqid; i++)
+		p9_put_qid(bufp, &wqids[i], &fc->params.rwalk.wqids[i]);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rwalk);
+
+int p9_create_ropen(struct p9_fcall *fc, struct p9_qid *qid, u32 iounit)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13 + 4;		/* qid[13] iounit[4] */
+	err = p9_fcall_init(bufp, fc, size, P9_ROPEN);
+	if (err < 0)
+		return err;
+
+	p9_put_qid(bufp, qid, &fc->params.ropen.qid);
+	p9_put_int32(bufp, iounit, &fc->params.ropen.iounit);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_ropen);
+
+int p9_create_rcreate(struct p9_fcall *fc, struct p9_qid *qid, u32 iounit)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 13 + 4;		/* qid[13] iounit[4] */
+	err = p9_fcall_init(bufp, fc, size, P9_RCREATE);
+	if (err < 0)
+		return err;
+
+	p9_put_qid(bufp, qid, &fc->params.rcreate.qid);
+	p9_put_int32(bufp, iounit, &fc->params.rcreate.iounit);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rcreate);
+
+int p9_init_rread(struct p9_fcall *fc)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = fc->size - 7;
+	err = p9_fcall_init(bufp, fc, size, P9_RREAD);
+	if (err < 0)
+		return err;
+
+	p9_put_int32(bufp, 0, &fc->params.rread.count);
+	buf_get_data(bufp, fc->size - P9_IOHDRSZ, &fc->params.rread.data);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_init_rread);
+
+void p9_set_rread_count(struct p9_fcall *fc, u32 count)
+{
+	int n;
+	char *p;
+
+	n = 4 + 1 + 2 + 4 + count;/*size[4] id[1] tag[2] count[4] data[count]*/
+	fc->params.rread.count = count;
+	fc->size = n;
+	p = fc->sdata;
+	*(__le32 *) p = cpu_to_le32(n);
+	*(__le32 *) (p + 7) = cpu_to_le32(count);
+}
+EXPORT_SYMBOL(p9_set_rread_count);
+
+int p9_create_rwrite(struct p9_fcall *fc, u32 count)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4;		/* count[4] */
+	err = p9_fcall_init(bufp, fc, size, P9_RWRITE);
+	if (err < 0)
+		return err;
+
+	p9_put_int32(bufp, count, &fc->params.rwrite.count);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rwrite);
+
+int p9_create_rclunk(struct p9_fcall *fc)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	err = p9_fcall_init(bufp, fc, size, P9_RCLUNK);
+	if (err < 0)
+		return err;
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rclunk);
+
+int p9_create_rremove(struct p9_fcall *fc)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	err = p9_fcall_init(bufp, fc, size, P9_RREMOVE);
+	if (err < 0)
+		return err;
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rremove);
+
+int p9_create_rstat(struct p9_fcall *fc, struct p9_wstat *st, int dotu)
+{
+	int err, size, statsz;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	statsz = p9_size_wstat(st, dotu);
+	size = 2 + 2 + statsz;		/* stat[n] */
+	err = p9_fcall_init(bufp, fc, size, P9_RSTAT);
+	if (err < 0)
+		return err;
+
+	buf_put_int16(bufp, statsz + 2);
+	p9_put_wstat(bufp, st, &fc->params.rstat.stat, statsz, dotu);
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rstat);
+
+int p9_create_rwstat(struct p9_fcall *fc)
+{
+	int err, size;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 0;
+	err = p9_fcall_init(bufp, fc, size, P9_RWSTAT);
+	if (err < 0)
+		return err;
+
+	return p9_fcall_finish(bufp);
+}
+EXPORT_SYMBOL(p9_create_rwstat);
+
 int p9_fcall_get(char *dst, int dstlen, struct p9_fcall *fc)
 {
 	if (dstlen > fc->size)
