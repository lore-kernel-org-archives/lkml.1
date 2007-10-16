Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbXJPR7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbXJPR7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbXJPR65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:58:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35940 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbXJPR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:58:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Oct 2007 19:58:46 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: optimize initialization of ar context
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
Message-ID: <tkrat.ee2f970ab4b4ccbd@s5r6.in-berlin.de>
References: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
 <4714F652.1060007@s5r6.in-berlin.de>
 <tkrat.c21e564719351bc6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sync only the parts for CPU which are actually accessed by the CPU.
Replace a memset by direct assignment.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -258,19 +258,21 @@ static int ar_context_add_page(struct ar
 		free_page((unsigned long) ab);
 		return -ENOMEM;
 	}
-	dma_sync_single_for_cpu(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(dev, ab_bus, sizeof(ab->descriptor),
+				DMA_BIDIRECTIONAL);
 
-	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
-	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
-						    DESCRIPTOR_STATUS |
-						    DESCRIPTOR_BRANCH_ALWAYS);
 	offset = offsetof(struct ar_buffer, data);
-	ab->descriptor.req_count      = cpu_to_le16(PAGE_SIZE - offset);
-	ab->descriptor.data_address   = cpu_to_le32(ab_bus + offset);
-	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
-	ab->descriptor.branch_address = 0;
+	ab->descriptor.req_count       = cpu_to_le16(PAGE_SIZE - offset);
+	ab->descriptor.control         = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
+						     DESCRIPTOR_STATUS |
+						     DESCRIPTOR_BRANCH_ALWAYS);
+	ab->descriptor.data_address    = cpu_to_le32(ab_bus + offset);
+	ab->descriptor.branch_address  = 0;
+	ab->descriptor.res_count       = cpu_to_le16(PAGE_SIZE - offset);
+	ab->descriptor.transfer_status = 0;
 
-	dma_sync_single_for_device(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_sync_single_for_device(dev, ab_bus, sizeof(ab->descriptor),
+				   DMA_BIDIRECTIONAL);
 
 	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
 	ctx->last_buffer->next = ab;

-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/

