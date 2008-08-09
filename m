Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYHISWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYHISWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYHISWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:22:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58873 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYHISWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:22:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Aug 2008 20:22:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: fix another small generation access bug
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.afa750d9dd6f8ee6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queuecommand() looked at the remote and local node IDs before it read
the bus generation.  The corresponding race with sbp2_reconnect updating
these data was probably impossible to happen though because the current
code blocks the SCSI layer during reconnection.  However, better safe
than sorry, especially if someone later improves the code to not block
the SCSI layer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc2/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.27-rc2/drivers/firewire/fw-sbp2.c
@@ -1430,7 +1430,7 @@ static int sbp2_scsi_queuecommand(struct
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
 	unsigned int max_payload;
-	int retval = SCSI_MLQUEUE_HOST_BUSY;
+	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
@@ -1474,6 +1474,9 @@ static int sbp2_scsi_queuecommand(struct
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		orb->request.misc |= cpu_to_be32(COMMAND_ORB_DIRECTION);
 
+	generation = device->generation;
+	smp_rmb();    /* sbp2_map_scatterlist looks at tgt->address_high */
+
 	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
 		goto out;
 
@@ -1486,7 +1489,7 @@ static int sbp2_scsi_queuecommand(struct
 	if (dma_mapping_error(device->card->device, orb->base.request_bus))
 		goto out;
 
-	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, lu->generation,
+	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);
 	retval = 0;
  out:

-- 
Stefan Richter
-=====-==--- =--- -=--=
http://arcgraph.de/sr/

