Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZHKTmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZHKTmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZHKTmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:42:37 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33473 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbZHKTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:42:37 -0400
Date: Tue, 11 Aug 2009 21:46:22 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.com, davem@redhat.com
Subject: [PATCH] 8139cp : balance dma_map_single vs dma_unmap_single pair
Message-ID: <20090811194622.GA4268@electric-eye.fr.zoreil.com>
References: <c4e36d110908110621o75ff063ex6d42570ce635a243@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110908110621o75ff063ex6d42570ce635a243@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver always:
1. allocate cp->rx_buf_sz + NET_IP_ALIGN
2. map cp->rx_buf_sz

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/8139cp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index 07919d0..4a8995a 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -515,7 +515,7 @@ rx_status_loop:
 		dma_addr_t mapping;
 		struct sk_buff *skb, *new_skb;
 		struct cp_desc *desc;
-		unsigned buflen;
+		const unsigned buflen = cp->rx_buf_sz;
 
 		skb = cp->rx_skb[rx_tail];
 		BUG_ON(!skb);
@@ -549,8 +549,7 @@ rx_status_loop:
 			pr_debug("%s: rx slot %d status 0x%x len %d\n",
 			       dev->name, rx_tail, status, len);
 
-		buflen = cp->rx_buf_sz + NET_IP_ALIGN;
-		new_skb = netdev_alloc_skb(dev, buflen);
+		new_skb = netdev_alloc_skb(dev, buflen + NET_IP_ALIGN);
 		if (!new_skb) {
 			dev->stats.rx_dropped++;
 			goto rx_next;
-- 
1.6.2.5

