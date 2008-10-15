Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYJOA5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYJOA5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYJOA4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:30 -0400
Received: from gw.goop.org ([64.81.55.164]:36863 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYJOA42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] xen-netfront: Avoid unaligned accesses to IP
	header
X-Mercurial-Node: d3d2ad0d95db689f77abec9af20b271f30ad3910
Message-Id: <d3d2ad0d95db689f77ab.1224031842@abulafia.goop.org>
In-Reply-To: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>,
       NetDev <netdev@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Align ip header to a 16 byte boundary to avoid unaligned
access like other drivers.
Without this patch, xen-netfront doesn't work well on ia64.

[ Jeff, this is the only patch in the series which is in your
  territory. -J ]

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/net/xen-netfront.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -239,10 +239,13 @@
 	 */
 	batch_target = np->rx_target - (req_prod - np->rx.rsp_cons);
 	for (i = skb_queue_len(&np->rx_batch); i < batch_target; i++) {
-		skb = __netdev_alloc_skb(dev, RX_COPY_THRESHOLD,
+		skb = __netdev_alloc_skb(dev, RX_COPY_THRESHOLD + NET_IP_ALIGN,
 					 GFP_ATOMIC | __GFP_NOWARN);
 		if (unlikely(!skb))
 			goto no_skb;
+
+		/* Align ip header to a 16 bytes boundary */
+		skb_reserve(skb, NET_IP_ALIGN);
 
 		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
 		if (!page) {


