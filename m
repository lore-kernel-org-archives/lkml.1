Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXKBRQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXKBRQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbXKBRQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:16:04 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:56107 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754174AbXKBRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:16:01 -0400
Date: Fri, 2 Nov 2007 10:57:10 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] 9p: fcall deserialization changes
Message-ID: <20071102165710.GC16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modify p9_deserialize_fcall to read from p9_fcall's internal buffer instead
of specifying an external one. Add functions that copy raw data to and from
a fcall.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 include/net/9p/9p.h |    4 +++-
 net/9p/conv.c       |   34 ++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 86fee63..8de6eef 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -381,9 +381,11 @@ extern struct kset p9_subsys;
 
 int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
 	int dotu);
-int p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *fc, int dotu);
+int p9_deserialize_fcall(struct p9_fcall *fc, int dotu);
 void p9_set_tag(struct p9_fcall *fc, u16 tag);
 struct p9_fcall *p9_fcall_alloc(u32 size);
+int p9_fcall_get(char *dst, int dstlen, struct p9_fcall *fc);
+int p9_fcall_put(struct p9_fcall *fc, char *src, int srclen);
 struct p9_fcall *p9_create_tversion(u32 msize, char *version);
 struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname,
 	char *aname, u32 n_uname, int dotu);
diff --git a/net/9p/conv.c b/net/9p/conv.c
index 3627753..74d57c7 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -322,18 +322,20 @@ EXPORT_SYMBOL(p9_deserialize_stat);
  *
  */
 
-int
-p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
-		       int dotu)
+int p9_deserialize_fcall(struct p9_fcall *rcall, int dotu)
 {
-
+	u32 size;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;
 	int i = 0;
 
-	buf_init(bufp, buf, buflen);
+	buf_init(bufp, rcall->sdata, rcall->size);
 
-	rcall->size = buf_get_int32(bufp);
+	size = buf_get_int32(bufp);
+	if (size > rcall->size)
+		return -EPROTO;
+
+	rcall->size = size;
 	rcall->id = buf_get_int8(bufp);
 	rcall->tag = buf_get_int16(bufp);
 
@@ -941,3 +943,23 @@ error:
 	return fc;
 }
 EXPORT_SYMBOL(p9_create_twstat);
+
+int p9_fcall_get(char *dst, int dstlen, struct p9_fcall *fc)
+{
+	if (dstlen > fc->size)
+		dstlen = fc->size;
+
+	memmove(dst, fc->sdata, dstlen);
+	return dstlen;
+}
+EXPORT_SYMBOL(p9_fcall_get);
+
+int p9_fcall_put(struct p9_fcall *fc, char *src, int srclen)
+{
+	if (srclen > fc->size)
+		return -ENOMEM;
+
+	memmove(fc->sdata, src, srclen);
+	return srclen;
+}
+EXPORT_SYMBOL(p9_fcall_put);
