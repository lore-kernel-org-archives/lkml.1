Return-Path: <linux-kernel-owner+w=401wt.eu-S935385AbXG0M63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935385AbXG0M63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933706AbXG0M53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:57:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45191 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760547AbXG0M51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:57:27 -0400
To: davem@davemloft.net
Subject: [PATCH 3/4] pass (host-endian) cmd length as explicit argument to l2cap_conf_req()
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, marcel@holtmann.org
Message-Id: <E1IEPNm-0005Sn-7z@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 27 Jul 2007 13:57:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bluetooth/l2cap.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 09126bf..03309d2 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1530,7 +1530,7 @@ static inline int l2cap_connect_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hd
 	return 0;
 }
 
-static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u16 cmd_len, u8 *data)
 {
 	struct l2cap_conf_req *req = (struct l2cap_conf_req *) data;
 	u16 dcid, flags;
@@ -1550,7 +1550,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 		goto unlock;
 
 	/* Reject if config buffer is too small. */
-	len = cmd->len - sizeof(*req);
+	len = cmd_len - sizeof(*req);
 	if (l2cap_pi(sk)->conf_len + len > sizeof(l2cap_pi(sk)->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(sk, rsp,
@@ -1748,15 +1748,17 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn, struct sk_buff *sk
 	l2cap_raw_recv(conn, skb);
 
 	while (len >= L2CAP_CMD_HDR_SIZE) {
+		u16 cmd_len;
 		memcpy(&cmd, data, L2CAP_CMD_HDR_SIZE);
 		data += L2CAP_CMD_HDR_SIZE;
 		len  -= L2CAP_CMD_HDR_SIZE;
 
-		cmd.len = __le16_to_cpu(cmd.len);
+		cmd_len = le16_to_cpu(cmd.len);
+		cmd.len = cmd_len;
 
-		BT_DBG("code 0x%2.2x len %d id 0x%2.2x", cmd.code, cmd.len, cmd.ident);
+		BT_DBG("code 0x%2.2x len %d id 0x%2.2x", cmd.code, cmd_len, cmd.ident);
 
-		if (cmd.len > len || !cmd.ident) {
+		if (cmd_len > len || !cmd.ident) {
 			BT_DBG("corrupted command");
 			break;
 		}
@@ -1775,7 +1777,7 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn, struct sk_buff *sk
 			break;
 
 		case L2CAP_CONF_REQ:
-			err = l2cap_config_req(conn, &cmd, data);
+			err = l2cap_config_req(conn, &cmd, cmd_len, data);
 			break;
 
 		case L2CAP_CONF_RSP:
@@ -1791,7 +1793,7 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn, struct sk_buff *sk
 			break;
 
 		case L2CAP_ECHO_REQ:
-			l2cap_send_cmd(conn, cmd.ident, L2CAP_ECHO_RSP, cmd.len, data);
+			l2cap_send_cmd(conn, cmd.ident, L2CAP_ECHO_RSP, cmd_len, data);
 			break;
 
 		case L2CAP_ECHO_RSP:
@@ -1820,8 +1822,8 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn, struct sk_buff *sk
 			l2cap_send_cmd(conn, cmd.ident, L2CAP_COMMAND_REJ, sizeof(rej), &rej);
 		}
 
-		data += cmd.len;
-		len  -= cmd.len;
+		data += cmd_len;
+		len  -= cmd_len;
 	}
 
 	kfree_skb(skb);
-- 
1.5.3.GIT

