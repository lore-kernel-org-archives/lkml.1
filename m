Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYCZXuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYCZXuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYCZXub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:50:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51556 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYCZXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:50:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 27 Mar 2008 00:50:09 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47E9F6BB.4010601@s5r6.in-berlin.de>
Message-ID: <tkrat.82d28d7bc55f2a9b@s5r6.in-berlin.de>
References: <200803251647.16227.jwilson@redhat.com>
 <47E9F6BB.4010601@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Jarod Wilson wrote:
>> @@ -605,7 +606,7 @@ static void ar_context_tasklet(unsigned long data)
>>  			buffer = handle_ar_packet(ctx, buffer);
>>  
>>  		dma_free_coherent(ohci->card.device, PAGE_SIZE,
>> -				  buffer, buffer_bus);
>> +				  start, start_bus);
>>  		ar_context_add_page(ctx);
> 
> On the other hand, why do we free a page + allocate a page?
> Why don't we re-initialize and re-add the old page?


Meanwhile I tried a simple modification to ar_context_add_page and its
callers which results in _add_page simply re-adding the old page. I must
do something fundamentally wrong though.

After plugging in a FW disk and starting hdparm -tT, I get the modified
_add_page called for the ar_request_ctx, then for the ar_response_ctx,
then for the ar_request_ctx again, then everything stalls in one of
these modes:
  - No status write request reception is logged anymore, or
  - status write request reception with evt_no_status is logged.
The number of _add_page calls for ar_request_ctx until failure
corresponds to the number of pages added in ar_context_init.
(Normally two, I also tried three and four.)

Just FYI, here is basically what I tested, with a debug printk in it.
---
 drivers/firewire/fw-ohci.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -451,14 +451,19 @@ ohci_update_phy_reg(struct fw_card *card
 	return 0;
 }
 
-static int ar_context_add_page(struct ar_context *ctx)
+static int ar_context_add_page(struct ar_context *ctx, struct ar_buffer *ab)
 {
 	struct device *dev = ctx->ohci->card.device;
-	struct ar_buffer *ab;
 	dma_addr_t uninitialized_var(ab_bus);
-	size_t offset;
+	size_t offset = offsetof(struct ar_buffer, data);
 
-	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
+	if (ab == NULL)
+		ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_KERNEL);
+	else {
+		ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		fw_notify("=== %s ===\n",
+			  ctx == &ctx->ohci->ar_request_ctx  ? "Req " : "Resp");
+	}
 	if (ab == NULL)
 		return -ENOMEM;
 
@@ -466,7 +471,6 @@ static int ar_context_add_page(struct ar
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
 						    DESCRIPTOR_STATUS |
 						    DESCRIPTOR_BRANCH_ALWAYS);
-	offset = offsetof(struct ar_buffer, data);
 	ab->descriptor.req_count      = cpu_to_le16(PAGE_SIZE - offset);
 	ab->descriptor.data_address   = cpu_to_le32(ab_bus + offset);
 	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
@@ -569,8 +573,7 @@ static __le32 *handle_ar_packet(struct a
 static void ar_context_tasklet(unsigned long data)
 {
 	struct ar_context *ctx = (struct ar_context *)data;
-	struct fw_ohci *ohci = ctx->ohci;
-	struct ar_buffer *ab;
+	struct ar_buffer *ab, *old_ab;
 	struct descriptor *d;
 	void *buffer, *end;
 
@@ -578,9 +581,7 @@ static void ar_context_tasklet(unsigned 
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
-		dma_addr_t start_bus;
-		void *start;
+		size_t size, rest;
 
 		/*
 		 * This descriptor is finished and we may have a
@@ -588,10 +589,7 @@ static void ar_context_tasklet(unsigned 
 		 * reuse the page for reassembling the split packet.
 		 */
 
-		offset = offsetof(struct ar_buffer, data);
-		start = buffer = ab;
-		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
-
+		buffer = old_ab = ab;
 		ab = ab->next;
 		d = &ab->descriptor;
 		size = buffer + PAGE_SIZE - ctx->pointer;
@@ -605,9 +603,7 @@ static void ar_context_tasklet(unsigned 
 		while (buffer < end)
 			buffer = handle_ar_packet(ctx, buffer);
 
-		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  start, start_bus);
-		ar_context_add_page(ctx);
+		ar_context_add_page(ctx, old_ab);
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =
@@ -628,8 +624,8 @@ ar_context_init(struct ar_context *ctx, 
 	ctx->last_buffer = &ab;
 	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
 
-	ar_context_add_page(ctx);
-	ar_context_add_page(ctx);
+	ar_context_add_page(ctx, NULL);
+	ar_context_add_page(ctx, NULL);
 	ctx->current_buffer = ab.next;
 	ctx->pointer = ctx->current_buffer->data;
 

-- 
Stefan Richter
-=====-==--- --== ==-==
http://arcgraph.de/sr/

