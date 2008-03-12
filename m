Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYCLVnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYCLVnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYCLVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:43:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYCLVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:43:33 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
Date: Wed, 12 Mar 2008 17:43:29 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121743.29438.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per DMA API docs, when using dma_map_single(), DMA_TO_DEVICE synchronization
must be done after the last modification of the memory region by software
before it can be handed off to the device and safely read. Such a sync is
currently missing from firewire_ohci:at_context_queue_packet().

At least on my setup, where I could within seconds reliably reproduce a panic
in handle_at_packet() by simply dd'ing from two drives on different controllers,
the panic is gone.

See http://bugzilla.kernel.org/show_bug.cgi?id=9617

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

---

 drivers/firewire/fw-ohci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 081a434..fc45868 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -780,6 +780,10 @@ at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 
 	context_append(ctx, d, z, 4 - z);
 
+	/* Sync the DMA buffer up for the device to read from */
+	dma_sync_single_for_device(ohci->card.device, payload_bus,
+				   packet->payload_length, DMA_TO_DEVICE);
+
 	/* If the context isn't already running, start it up. */
 	reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
 	if ((reg & CONTEXT_RUN) == 0)

-- 
Jarod Wilson
jwilson@redhat.com
