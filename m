Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZJEIVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZJEIVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZJEIVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:21:19 -0400
Received: from msr14.hinet.net ([168.95.4.114]:35226 "EHLO msr14.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZJEIVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:21:19 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 04:20:43 EDT
From: Thomas Chou <thomas@wytron.com.tw>
To: thierry.reding@avionic-design.de
Cc: Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 3/4] ethoc: align received packet to make IP header at word boundary
Date: Mon,  5 Oct 2009 15:43:04 +0800
Message-Id: <1254728585-31964-3-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254728585-31964-2-git-send-email-thomas@wytron.com.tw>
References: <1254728585-31964-1-git-send-email-thomas@wytron.com.tw>
 <1254728585-31964-2-git-send-email-thomas@wytron.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The packet buffer is allocated at 4 bytes boundary, but the IP header
length and version bits is located at byte 14. These bit fields access
as 32 bits word and caused exception on processors that do not support
unaligned access.

The patch adds 2 bytes offset to make the bit fields word aligned.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/net/ethoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index f92747f..0c6c7f4 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -399,6 +399,10 @@ static int ethoc_rx(struct net_device *dev, int limit)
 		if (ethoc_update_rx_stats(priv, &bd) == 0) {
 			int size = bd.stat >> 16;
 			struct sk_buff *skb = netdev_alloc_skb(dev, size);
+
+			size -= 4; /* strip the CRC */
+			skb_reserve(skb, 2); /* align TCP/IP header */
+
 			if (likely(skb)) {
 				void *src = phys_to_virt(bd.addr);
 				memcpy_fromio(skb_put(skb, size), src, size);
-- 
1.6.2.5

