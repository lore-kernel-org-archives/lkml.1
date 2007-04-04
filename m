Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXDDG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXDDG2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992706AbXDDG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:30 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10515 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992710AbXDDG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:15 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="33682534:sNHT23024372"
Subject: [PATCH] USB gadget rndis: fix bug skb_push function may return an
	unaligned pointer bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:28:33 +0800
Message-Id: <1175668113.10608.41.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

USB gadget rndis: skb_push function may return a pointer which is not
aligned as required by struct rndis_packet_msg_type.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/usb/gadget/rndis.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 6ec8cf1..48335bb 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -1211,18 +1211,23 @@ int rndis_set_param_medium (u8 configNr, u32 medium, u32 speed)
 	return 0;
 }
 
+/* The pointer of header is not aligned, it will cause alignment exception.
+ * Use a temporary variable to avoid it.
+ */
 void rndis_add_hdr (struct sk_buff *skb)
 {
-	struct rndis_packet_msg_type	*header;
+	void *buf;
+	struct rndis_packet_msg_type *header;
 
 	if (!skb)
 		return;
-	header = (void *) skb_push (skb, sizeof *header);
-	memset (header, 0, sizeof *header);
-	header->MessageType = __constant_cpu_to_le32(REMOTE_NDIS_PACKET_MSG);
-	header->MessageLength = cpu_to_le32(skb->len);
-	header->DataOffset = __constant_cpu_to_le32 (36);
-	header->DataLength = cpu_to_le32(skb->len - sizeof *header);
+	buf = (void *) skb_push (skb, sizeof *header);
+	memset (buf, 0, sizeof *header);
+	header = (struct rndis_packet_msg_type *)buf;
+	put_unaligned(__constant_cpu_to_le32(REMOTE_NDIS_PACKET_MSG), &header->MessageType);
+	put_unaligned(cpu_to_le32(skb->len), &header->MessageLength);
+	put_unaligned(__constant_cpu_to_le32(36), &header->DataOffset);
+	put_unaligned(cpu_to_le32(skb->len - sizeof *header), &header->DataLength);
 }
 
 void rndis_free_response (int configNr, u8 *buf)
-- 
1.5.0.5

