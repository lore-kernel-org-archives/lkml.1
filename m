Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZJVWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZJVWLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbZJVWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:11:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55062 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbZJVWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:11:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bhmmzMmesebtEe8VtAye9
Subject: [PATCH 02/10] omap: SDMA: Fix omap_stop_dma() API for channel linking
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Venkatraman S <svenkatr@ti.com>, linux-kernel@vger.kernel.org,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Jarkko Nikula <jhnikula@gmail.com>, Hari n <hari.zoom@gmail.com>,
       linux-omap@vger.kernel.org
Date: Thu, 22 Oct 2009 15:11:37 -0700
Message-ID: <20091022221136.27408.73433.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

OMAP sDMA driver API omap_stop_dma() doesn't really stop the dma when used
in linking scenario.

The DMA channel needs to be disabled before resetting the chain.
Also fix clearing of the OMAP_DMA_ACTIVE status in the linked case.

Cc: Hari n <hari.zoom@gmail.com>
Cc: Jarkko Nikula <jhnikula@gmail.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/dma.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 0eb676d..b53125f 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -978,6 +978,14 @@ void omap_stop_dma(int lch)
 {
 	u32 l;
 
+	/* Disable all interrupts on the channel */
+	if (cpu_class_is_omap1())
+		dma_write(0, CICR(lch));
+
+	l = dma_read(CCR(lch));
+	l &= ~OMAP_DMA_CCR_EN;
+	dma_write(l, CCR(lch));
+
 	if (!omap_dma_in_1510_mode() && dma_chan[lch].next_lch != -1) {
 		int next_lch, cur_lch = lch;
 		char dma_chan_link_map[OMAP_DMA4_LOGICAL_DMA_CH_COUNT];
@@ -995,18 +1003,8 @@ void omap_stop_dma(int lch)
 			next_lch = dma_chan[cur_lch].next_lch;
 			cur_lch = next_lch;
 		} while (next_lch != -1);
-
-		return;
 	}
 
-	/* Disable all interrupts on the channel */
-	if (cpu_class_is_omap1())
-		dma_write(0, CICR(lch));
-
-	l = dma_read(CCR(lch));
-	l &= ~OMAP_DMA_CCR_EN;
-	dma_write(l, CCR(lch));
-
 	dma_chan[lch].flags &= ~OMAP_DMA_ACTIVE;
 }
 EXPORT_SYMBOL(omap_stop_dma);

