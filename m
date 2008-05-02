Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbYEBFUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbYEBFUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYEBFTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:19:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:32934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYEBFTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d0ZWEpaEMC9KEiZq14SWwBIuTni7z9Jh5hdak2QfXvTK9m/raqqjcV0fqoxLnsFJdImUG+zgLtiwBUJ9JlSY+xSbJpsZUCl4/OW0TWcBYfCBLR6LHadPFmiK2is9MllGb/TvrcwQM6tfJi1DdRTOz8b5C+TpDhOOcUEr3FGvRYY=
Subject: [PATCH 4/6] bluetooth: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:19:33 -0700
Message-Id: <1209705573.22362.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/bluetooth/bnep/core.c |    8 ++++----
 net/bluetooth/hci_event.c |    9 ++++-----
 net/bluetooth/hci_sock.c  |    2 +-
 net/bluetooth/l2cap.c     |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 347e935..f85d946 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -135,7 +135,7 @@ static int bnep_ctrl_set_netfilter(struct bnep_session *s, __be16 *data, int len
 	if (len < 2)
 		return -EILSEQ;
 
-	n = ntohs(get_unaligned(data));
+	n = get_unaligned_be16(data);
 	data++; len -= 2;
 
 	if (len < n)
@@ -150,8 +150,8 @@ static int bnep_ctrl_set_netfilter(struct bnep_session *s, __be16 *data, int len
 		int i;
 
 		for (i = 0; i < n; i++) {
-			f[i].start = ntohs(get_unaligned(data++));
-			f[i].end   = ntohs(get_unaligned(data++));
+			f[i].start = get_unaligned_be16(data++);
+			f[i].end   = get_unaligned_be16(data++);
 
 			BT_DBG("proto filter start %d end %d",
 				f[i].start, f[i].end);
@@ -180,7 +180,7 @@ static int bnep_ctrl_set_mcfilter(struct bnep_session *s, u8 *data, int len)
 	if (len < 2)
 		return -EILSEQ;
 
-	n = ntohs(get_unaligned((__be16 *) data));
+	n = get_unaligned_be16(data);
 	data += 2; len -= 2;
 
 	if (len < n)
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 46df2e4..6aef8f2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -129,8 +129,7 @@ static void hci_cc_write_link_policy(struct hci_dev *hdev, struct sk_buff *skb)
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(rp->handle));
 	if (conn) {
-		__le16 policy = get_unaligned((__le16 *) (sent + 2));
-		conn->link_policy = __le16_to_cpu(policy);
+		conn->link_policy = get_unaligned_le16(sent + 2);
 	}
 
 	hci_dev_unlock(hdev);
@@ -313,7 +312,7 @@ static void hci_cc_write_voice_setting(struct hci_dev *hdev, struct sk_buff *skb
 		return;
 
 	if (!status) {
-		__u16 setting = __le16_to_cpu(get_unaligned((__le16 *) sent));
+		__u16 setting = get_unaligned_le16(sent);
 
 		if (hdev->voice_setting != setting) {
 			hdev->voice_setting = setting;
@@ -1152,8 +1151,8 @@ static inline void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *s
 		struct hci_conn *conn;
 		__u16  handle, count;
 
-		handle = __le16_to_cpu(get_unaligned(ptr++));
-		count  = __le16_to_cpu(get_unaligned(ptr++));
+		handle = get_unaligned_le16(ptr++);
+		count  = get_unaligned_le16(ptr++);
 
 		conn = hci_conn_hash_lookup_handle(hdev, handle);
 		if (conn) {
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 1d36c09..747fabd 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -440,7 +440,7 @@ static int hci_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
 	skb->dev = (void *) hdev;
 
 	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT) {
-		u16 opcode = __le16_to_cpu(get_unaligned((__le16 *) skb->data));
+		u16 opcode = get_unaligned_le16(skb->data);
 		u16 ogf = hci_opcode_ogf(opcode);
 		u16 ocf = hci_opcode_ocf(opcode);
 
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index a4849f2..6e180d2 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1827,7 +1827,7 @@ static inline int l2cap_information_rsp(struct l2cap_conn *conn, struct l2cap_cm
 	del_timer(&conn->info_timer);
 
 	if (type == L2CAP_IT_FEAT_MASK)
-		conn->feat_mask = __le32_to_cpu(get_unaligned((__le32 *) rsp->data));
+		conn->feat_mask = get_unaligned_le32(rsp->data);
 
 	l2cap_conn_start(conn);
 
-- 
1.5.5.1.350.gbbbf


