Return-Path: <linux-kernel-owner+w=401wt.eu-S935298AbXJPSbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298AbXJPSbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXJPSbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:31:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37002 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbXJPSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:31:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Oct 2007 20:30:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: avoid an atomic allocation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <tkrat.ee2f970ab4b4ccbd@s5r6.in-berlin.de>
Message-ID: <tkrat.ee2011f98a2490f3@s5r6.in-berlin.de>
References: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
 <4714F652.1060007@s5r6.in-berlin.de>
 <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
 <tkrat.ee2f970ab4b4ccbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All of the buffers which are allocated during fw-ohci's pci_probe can be
allocated with GFP_KERNEL.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.23-rc6/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.23-rc6.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.23-rc6/drivers/firewire/fw-ohci.c
@@ -242,14 +242,14 @@ ohci_update_phy_reg(struct fw_card *card
 	return 0;
 }
 
-static int ar_context_add_page(struct ar_context *ctx)
+static int ar_context_add_page(struct ar_context *ctx, gfp_t gfp_mask)
 {
 	struct device *dev = ctx->ohci->card.device;
 	struct ar_buffer *ab;
 	dma_addr_t ab_bus;
 	size_t offset;
 
-	ab = (struct ar_buffer *) __get_free_page(GFP_ATOMIC);
+	ab = (struct ar_buffer *) __get_free_page(gfp_mask);
 	if (ab == NULL)
 		return -ENOMEM;
 
@@ -397,7 +397,7 @@ static void ar_context_tasklet(unsigned 
 			buffer = handle_ar_packet(ctx, buffer);
 
 		free_page((unsigned long)buffer);
-		ar_context_add_page(ctx);
+		ar_context_add_page(ctx, GFP_ATOMIC);
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =
@@ -418,8 +418,8 @@ ar_context_init(struct ar_context *ctx, 
 	ctx->last_buffer = &ab;
 	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
 
-	ar_context_add_page(ctx);
-	ar_context_add_page(ctx);
+	ar_context_add_page(ctx, GFP_KERNEL);
+	ar_context_add_page(ctx, GFP_KERNEL);
 	ctx->current_buffer = ab.next;
 	ctx->pointer = ctx->current_buffer->data;
 

-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/

