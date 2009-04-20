Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZDTEe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZDTEe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZDTEdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:33:52 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45653 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZDTEdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:33:51 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Bluetooth: create macros for channels identifiers
Date: Mon, 20 Apr 2009 01:31:05 -0300
Message-Id: <1240201868-1396-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macros instead of hardcoded numbers to get a code more readable.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 include/net/bluetooth/l2cap.h |    6 ++++++
 net/bluetooth/l2cap.c         |   18 +++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index f566aa1..ed4ba91 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -106,6 +106,12 @@ struct l2cap_conn_rsp {
 	__le16     status;
 } __attribute__ ((packed));
 
+/* channel indentifier */
+#define L2CAP_CID_SIGNALING	0x0001
+#define L2CAP_CID_CONN_LESS	0x0002
+#define L2CAP_CID_DYN_START	0x0040
+#define L2CAP_CID_DYN_END	0xffff
+
 /* connect result */
 #define L2CAP_CR_SUCCESS    0x0000
 #define L2CAP_CR_PEND       0x0001
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index ca4d3b4..ff1744e 100644
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
@@ -215,13 +215,13 @@ static void __l2cap_chan_add(struct l2cap_conn *conn, struct sock *sk, struct so
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
 
@@ -1598,7 +1598,7 @@ static struct sk_buff *l2cap_build_cmd(struct l2cap_conn *conn,
 
 	lh = (struct l2cap_hdr *) skb_put(skb, L2CAP_HDR_SIZE);
 	lh->len = cpu_to_le16(L2CAP_CMD_HDR_SIZE + dlen);
-	lh->cid = cpu_to_le16(0x0001);
+	lh->cid = cpu_to_le16(L2CAP_CID_SIGNALING);
 
 	cmd = (struct l2cap_cmd_hdr *) skb_put(skb, L2CAP_CMD_HDR_SIZE);
 	cmd->code  = code;
@@ -2420,11 +2420,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
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

