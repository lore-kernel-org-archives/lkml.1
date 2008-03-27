Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYC0Uic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYC0Uic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbYC0UiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:38:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43222 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbYC0UiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:38:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 27 Mar 2008 21:37:25 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.2374baeb26921d92@s5r6.in-berlin.de>
Message-ID: <tkrat.85f36e56e03746e3@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
 <tkrat.948f418ebe464164@s5r6.in-berlin.de>
 <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
 <tkrat.2374baeb26921d92@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following update for the firewire subsystem.

 drivers/firewire/fw-ohci.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

Jarod Wilson (1):
      firewire: fw-ohci: plug dma memory leak in AR handler


commit 6b84236d37ef602d1e4f52b27162c20394e83359
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Tue Mar 25 16:47:16 2008 -0400

    firewire: fw-ohci: plug dma memory leak in AR handler
    
    There's an ugly little memory leak in firewire-ohci's
    ar_context_tasklet(), where we're not freeing up some of the memory we
    use for each ar_buffer, due to a moving pointer. The problem has been
    there for a while, but didn't get noticed until after converting the AR
    routines over to use coherent DMA and I started running into I/O stall-
    outs with the following message output repeatedly to the console:
    
    PCI-DMA: Out of IOMMU space for 53248 bytes at device 0000:04:09.0
    
    Plugging this leak is definitely necessary, but unfortunately, isn't the
    entire answer to my problem, it only increases the amount of I/O that I
    can do before hitting the problem. Still working on tracking down the
    root cause..
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 996d61f..ca6d51e 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -401,7 +401,8 @@ static void ar_context_tasklet(unsigned long data)
 
 	if (d->res_count == 0) {
 		size_t size, rest, offset;
-		dma_addr_t buffer_bus;
+		dma_addr_t start_bus;
+		void *start;
 
 		/*
 		 * This descriptor is finished and we may have a
@@ -410,9 +411,9 @@ static void ar_context_tasklet(unsigned long data)
 		 */
 
 		offset = offsetof(struct ar_buffer, data);
-		buffer_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		start = buffer = ab;
+		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
 
-		buffer = ab;
 		ab = ab->next;
 		d = &ab->descriptor;
 		size = buffer + PAGE_SIZE - ctx->pointer;
@@ -427,7 +428,7 @@ static void ar_context_tasklet(unsigned long data)
 			buffer = handle_ar_packet(ctx, buffer);
 
 		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  buffer, buffer_bus);
+				  start, start_bus);
 		ar_context_add_page(ctx);
 	} else {
 		buffer = ctx->pointer;

Thanks,
-- 
Stefan Richter
-=====-==--- --== ==-==
http://arcgraph.de/sr/

