Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbYETSJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbYETSJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbYETSGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:31 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765592AbYETSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jGlTaojdQSydN7wCuP3W6LmtW9geNdLdEzocANiErDNdunVlEfaKPpSV2+MwGVjgtjhooraw87IUxADkOclJGoVrA5rx5ypmgKvh1JNC9KgKCG6rI4R9SOAvenL83vZC93VAcsdOBAAieh3sVZjraPckvaQ+9kM+HYKLn3Q2DdY=
Subject: [PATCH 06/21] net: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:14 -0700
Message-Id: <1211306774.5915.175.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/9p/conv.c          |   14 +++++++-------
 net/9p/trans_fd.c      |    2 +-
 net/9p/trans_virtio.c  |    2 +-
 net/decnet/af_decnet.c |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/9p/conv.c b/net/9p/conv.c
index 4454720..e1dfb73 100644
--- a/net/9p/conv.c
+++ b/net/9p/conv.c
@@ -92,7 +92,7 @@ static void buf_put_int8(struct cbuf *buf, u8 val)
 static void buf_put_int16(struct cbuf *buf, u16 val)
 {
 	if (buf_check_size(buf, 2)) {
-		*(__le16 *) buf->p = cpu_to_le16(val);
+		put_le16(val, buf->p);
 		buf->p += 2;
 	}
 }
@@ -100,7 +100,7 @@ static void buf_put_int16(struct cbuf *buf, u16 val)
 static void buf_put_int32(struct cbuf *buf, u32 val)
 {
 	if (buf_check_size(buf, 4)) {
-		*(__le32 *)buf->p = cpu_to_le32(val);
+		put_le32(val, buf->p);
 		buf->p += 4;
 	}
 }
@@ -108,7 +108,7 @@ static void buf_put_int32(struct cbuf *buf, u32 val)
 static void buf_put_int64(struct cbuf *buf, u64 val)
 {
 	if (buf_check_size(buf, 8)) {
-		*(__le64 *)buf->p = cpu_to_le64(val);
+		put_le64(val, buf->p);
 		buf->p += 8;
 	}
 }
@@ -145,7 +145,7 @@ static u16 buf_get_int16(struct cbuf *buf)
 	u16 ret = 0;
 
 	if (buf_check_size(buf, 2)) {
-		ret = le16_to_cpu(*(__le16 *)buf->p);
+		ret = get_le16(buf->p);
 		buf->p += 2;
 	}
 
@@ -157,7 +157,7 @@ static u32 buf_get_int32(struct cbuf *buf)
 	u32 ret = 0;
 
 	if (buf_check_size(buf, 4)) {
-		ret = le32_to_cpu(*(__le32 *)buf->p);
+		ret = get_le32(buf->p);
 		buf->p += 4;
 	}
 
@@ -169,7 +169,7 @@ static u64 buf_get_int64(struct cbuf *buf)
 	u64 ret = 0;
 
 	if (buf_check_size(buf, 8)) {
-		ret = le64_to_cpu(*(__le64 *)buf->p);
+		ret = get_le64(buf->p);
 		buf->p += 8;
 	}
 
@@ -520,7 +520,7 @@ p9_create_common(struct cbuf *bufp, u32 size, u8 id)
 void p9_set_tag(struct p9_fcall *fc, u16 tag)
 {
 	fc->tag = tag;
-	*(__le16 *) (fc->sdata + 5) = cpu_to_le16(tag);
+	put_le16(tag, fc->sdata + 5);
 }
 EXPORT_SYMBOL(p9_set_tag);
 
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 4507f74..a805edb 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -771,7 +771,7 @@ static void p9_read_work(struct work_struct *work)
 
 	m->rpos += err;
 	while (m->rpos > 4) {
-		n = le32_to_cpu(*(__le32 *) m->rbuf);
+		n = get_le32(m->rbuf);
 		if (n >= m->msize) {
 			P9_DPRINTK(P9_DEBUG_ERROR,
 				"requested packet size too big: %d\n", n);
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 42adc05..8968039 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -339,7 +339,7 @@ p9_virtio_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
 
 	wait_event(*req->wq, req->status == REQ_STATUS_RCVD);
 
-	size = le32_to_cpu(*(__le32 *) rdata);
+	size = get_le32(rdata);
 
 	err = p9_deserialize_fcall(rdata, size, *rc, t->extended);
 	if (err < 0) {
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index fc2efe8..be2f3d0 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1129,8 +1129,8 @@ static int dn_accept(struct socket *sock, struct socket *newsock, int flags)
 
 	skb_pull(skb, dn_username2sockaddr(skb->data, skb->len, &(DN_SK(newsk)->addr), &type));
 	skb_pull(skb, dn_username2sockaddr(skb->data, skb->len, &(DN_SK(newsk)->peer), &type));
-	*(__le16 *)(DN_SK(newsk)->peer.sdn_add.a_addr) = cb->src;
-	*(__le16 *)(DN_SK(newsk)->addr.sdn_add.a_addr) = cb->dst;
+	put_le16(cb->src, DN_SK(newsk)->peer.sdn_add.a_addr);
+	put_le16(cb->dst, DN_SK(newsk)->addr.sdn_add.a_addr);
 
 	menuver = *skb->data;
 	skb_pull(skb, 1);
-- 
1.5.5.1.570.g26b5e


