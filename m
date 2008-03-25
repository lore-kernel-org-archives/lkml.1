Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYCYUrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYCYUrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYCYUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:47:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYCYUr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:47:26 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
Date: Tue, 25 Mar 2008 16:47:16 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251647.16227.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a nasty memory leak in firewire-ohci's ar_context_tasklet(), in that
we're not freeing up some of the memory we use for each ar_buffer, due to a
moving pointer. The problem has been there for a while, but didn't start
to be noticed until we were doing a coherent allocation for the ar_buffer --
meaning we have a smaller pool of memory to work with now, so the problem
crops up sooner. The manifestation of this comes after doing a bunch of I/O to
a firewire disk, which eventually stalls, and this starts spewing to the
console:

PCI-DMA: Out of IOMMU space for 53248 bytes at device 0000:04:09.0

The device there is one of my FireWire controllers trying to do I/O. The host
is a fairly new rev. opteron.

Just need to make sure we're freeing the correct memory range is pass through
ar_context_tasklet to fix it. Probably something we ought to sneak into 2.6.25
if its still doable...

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
