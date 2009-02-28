Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZB1FEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZB1FEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZB1FDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:03:51 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45716 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZB1FDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:03:49 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] bluetooth: use L2CAP_CID_* macros
Date: Sat, 28 Feb 2009 02:02:27 -0300
Message-Id: <1235797347-1816-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235797347-1816-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1235797347-1816-2-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macros instead of hardcoded numbers

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 net/bluetooth/l2cap.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 355f375..6181fc8 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -161,9 +161,9 @@ static inline struct sock *l2cap_get_chan_by_ident(struct l2cap_chan_list *l, u8
 
 static u16 l2cap_alloc_cid(struct l2cap_chan_list *l)
 {
-	u16 cid = 0x0040;
+	u16 cid = L2CAP_CID_DYN_START;
 
-	for (; cid < 0xffff; cid++) {
+	for (; cid < L2CAP_CID_DYN_END; cid++) {
 		if(!__l2cap_get_chan_by_scid(l, cid))
 			return cid;
 	}
@@ -217,13 +217,13 @@ static void __l2cap_chan_add(struct l2cap_conn *conn, struct sock *sk, struct so
 		l2cap_pi(sk)->scid = l2cap_alloc_cid(l);
 	} else if (sk->sk_type == SOCK_DGRAM) {
 		/* Connectionless socket */
-		l2cap_pi(sk)->scid = 0x0002;
-		l2cap_pi(sk)->dcid = 0x0002;
+		l2cap_pi(sk)->scid = L2CAP_CID_CONN_LESS;
+		l2cap_pi(sk)->dcid = L2CAP_CID_CONN_LESS;
 		l2cap_pi(sk)->omtu = L2CAP_DEFAULT_MTU;
 	} else {
 		/* Raw socket can send/recv signalling messages only */
-		l2cap_pi(sk)->scid = 0x0001;
-		l2cap_pi(sk)->dcid = 0x0001;
+		l2cap_pi(sk)->scid = L2CAP_CID_SIGNALING;
+		l2cap_pi(sk)->dcid = L2CAP_CID_SIGNALING;
 		l2cap_pi(sk)->omtu = L2CAP_DEFAULT_MTU;
 	}
 
@@ -1600,7 +1600,7 @@ static struct sk_buff *l2cap_build_cmd(struct l2cap_conn *conn,
 
 	lh = (struct l2cap_hdr *) skb_put(skb, L2CAP_HDR_SIZE);
 	lh->len = cpu_to_le16(L2CAP_CMD_HDR_SIZE + dlen);
-	lh->cid = cpu_to_le16(0x0001);
+	lh->cid = cpu_to_le16(L2CAP_CID_SIGNALING);
 
 	cmd = (struct l2cap_cmd_hdr *) skb_put(skb, L2CAP_CMD_HDR_SIZE);
 	cmd->code  = code;
@@ -2422,11 +2422,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
 	BT_DBG("len %d, cid 0x%4.4x", len, cid);
 
 	switch (cid) {
-	case 0x0001:
+	case L2CAP_CID_SIGNALING:
 		l2cap_sig_channel(conn, skb);
 		break;
 
-	case 0x0002:
+	case L2CAP_CID_CONN_LESS:
 		psm = get_unaligned((__le16 *) skb->data);
 		skb_pull(skb, 2);
 		l2cap_conless_channel(conn, psm, skb);
-- 
1.6.0.6

