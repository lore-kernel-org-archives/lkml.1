Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYC2DJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYC2DJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYC2DIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49878 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbYC2DIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:08:39 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] net/rxrpc trivial annotations
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1JfRQs-0002h4-JV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/rxrpc/ar-internal.h |    2 +-
 net/rxrpc/rxkad.c       |   27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 1aaa2e8..126ca77 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -23,7 +23,7 @@
 struct rxrpc_crypt {
 	union {
 		u8	x[FCRYPT_BSIZE];
-		u32	n[2];
+		__be32	n[2];
 	};
 } __attribute__((aligned(8)));
 
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index f48434a..d1c296f 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -261,6 +261,7 @@ static int rxkad_secure_packet(const struct rxrpc_call *call,
 		__be32 x[2];
 	} tmpbuf __attribute__((aligned(8))); /* must all be in same page */
 	__be32 x;
+	u32 y;
 	int ret;
 
 	sp = rxrpc_skb(skb);
@@ -292,11 +293,11 @@ static int rxkad_secure_packet(const struct rxrpc_call *call,
 	sg_init_one(&sg[1], &tmpbuf, sizeof(tmpbuf));
 	crypto_blkcipher_encrypt_iv(&desc, &sg[0], &sg[1], sizeof(tmpbuf));
 
-	x = ntohl(tmpbuf.x[1]);
-	x = (x >> 16) & 0xffff;
-	if (x == 0)
-		x = 1; /* zero checksums are not permitted */
-	sp->hdr.cksum = htons(x);
+	y = ntohl(tmpbuf.x[1]);
+	y = (y >> 16) & 0xffff;
+	if (y == 0)
+		y = 1; /* zero checksums are not permitted */
+	sp->hdr.cksum = htons(y);
 
 	switch (call->conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
@@ -314,7 +315,7 @@ static int rxkad_secure_packet(const struct rxrpc_call *call,
 		break;
 	}
 
-	_leave(" = %d [set %hx]", ret, x);
+	_leave(" = %d [set %hx]", ret, y);
 	return ret;
 }
 
@@ -492,6 +493,7 @@ static int rxkad_verify_packet(const struct rxrpc_call *call,
 		__be32 x[2];
 	} tmpbuf __attribute__((aligned(8))); /* must all be in same page */
 	__be32 x;
+	u16 y;
 	__be16 cksum;
 	int ret;
 
@@ -526,12 +528,12 @@ static int rxkad_verify_packet(const struct rxrpc_call *call,
 	sg_init_one(&sg[1], &tmpbuf, sizeof(tmpbuf));
 	crypto_blkcipher_encrypt_iv(&desc, &sg[0], &sg[1], sizeof(tmpbuf));
 
-	x = ntohl(tmpbuf.x[1]);
-	x = (x >> 16) & 0xffff;
-	if (x == 0)
-		x = 1; /* zero checksums are not permitted */
+	y = ntohl(tmpbuf.x[1]);
+	y = (y >> 16) & 0xffff;
+	if (y == 0)
+		y = 1; /* zero checksums are not permitted */
 
-	cksum = htons(x);
+	cksum = htons(y);
 	if (sp->hdr.cksum != cksum) {
 		*_abort_code = RXKADSEALEDINCON;
 		_leave(" = -EPROTO [csum failed]");
@@ -1001,7 +1003,8 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	struct rxrpc_crypt session_key;
 	time_t expiry;
 	void *ticket;
-	u32 abort_code, version, kvno, ticket_len, csum, level;
+	u32 abort_code, version, kvno, ticket_len, level;
+	__be32 csum;
 	int ret;
 
 	_enter("{%d,%x}", conn->debug_id, key_serial(conn->server_key));
-- 
1.5.3.GIT


