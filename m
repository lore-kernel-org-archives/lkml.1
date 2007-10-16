Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbXJPRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbXJPRZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760389AbXJPRZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:25:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35083 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXJPRZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:25:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Oct 2007 19:25:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: fix DMA mapping for ar context
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU must not touch the buffer after it was DMA-mapped.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -253,12 +253,6 @@ static int ar_context_add_page(struct ar
 	if (ab == NULL)
 		return -ENOMEM;
 
-	ab_bus = dma_map_single(dev, ab, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(ab_bus)) {
-		free_page((unsigned long) ab);
-		return -ENOMEM;
-	}
-
 	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
 						    DESCRIPTOR_STATUS |
@@ -269,7 +263,11 @@ static int ar_context_add_page(struct ar
 	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
 	ab->descriptor.branch_address = 0;
 
-	dma_sync_single_for_device(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	ab_bus = dma_map_single(dev, ab, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(ab_bus)) {
+		free_page((unsigned long) ab);
+		return -ENOMEM;
+	}
 
 	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
 	ctx->last_buffer->next = ab;

-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/

