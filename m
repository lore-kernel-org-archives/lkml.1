Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbYC0DJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbYC0DJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYC0DJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:09:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYC0DJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:09:37 -0400
To: linux1394-devel@lists.sourceforge.net
Subject: [PATCH update] firewire: fw-ohci: plug dma memory leak in AR handler
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
Date: Wed, 26 Mar 2008 23:09:33 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803262309.33705.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's an ugly little memory leak in firewire-ohci's ar_context_tasklet(), where
we're not freeing up some of the memory we use for each ar_buffer, due to a
moving pointer. The problem has been there for a while, but didn't get noticed
until after converting the AR routines over to use coherent DMA and I started
running into I/O stall-outs with the following message output repeatedly to the
console:

PCI-DMA: Out of IOMMU space for 53248 bytes at device 0000:04:09.0

Plugging this leak is definitely necessary, but unfortunately, isn't the entire
answer to my problem, it only increases the amount of I/O that I can do before
hitting the problem. Still working on tracking down the root cause..

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

---

 drivers/firewire/fw-ohci.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 8ff9059..e1d50f7 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -579,7 +579,8 @@ static void ar_context_tasklet(unsigned long data)
 
 	if (d->res_count == 0) {
 		size_t size, rest, offset;
-		dma_addr_t buffer_bus;
+		dma_addr_t start_bus;
+		void *start;
 
 		/*
 		 * This descriptor is finished and we may have a
@@ -588,9 +589,9 @@ static void ar_context_tasklet(unsigned long data)
 		 */
 
 		offset = offsetof(struct ar_buffer, data);
-		buffer_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		start = buffer = ab;
+		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
 
-		buffer = ab;
 		ab = ab->next;
 		d = &ab->descriptor;
 		size = buffer + PAGE_SIZE - ctx->pointer;
@@ -605,7 +606,7 @@ static void ar_context_tasklet(unsigned long data)
 			buffer = handle_ar_packet(ctx, buffer);
 
 		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  buffer, buffer_bus);
+				  start, start_bus);
 		ar_context_add_page(ctx);
 	} else {
 		buffer = ctx->pointer;

-- 
Jarod Wilson
jwilson@redhat.com
