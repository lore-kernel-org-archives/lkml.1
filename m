Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZA0REO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZA0REO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZA0RD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:03:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49583 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZA0RD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:03:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Jan 2009 18:03:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: swiotlb default size (64 MB) too small?
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20090127183723W.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de>
References: <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
 <4976D52F.5090109@s5r6.in-berlin.de>
 <20090127165508L.fujita.tomonori@lab.ntt.co.jp>
 <20090127183723W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jan, FUJITA Tomonori wrote at LSML and LKML:
[I wrote]
>> > *) The report does not sound like there was a DMA mappig leak caused by
>> > copying between usb-storage and firewire-sbp2.  Else he would have hit
>> > the problem again even with increased swiotlb default size.

> Hmm, we don't have leak here?
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] fw-sbp2: fix dma mapping leak on the failure path
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/firewire/fw-sbp2.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> index e88d506..d40910d 100644
> --- a/drivers/firewire/fw-sbp2.c
> +++ b/drivers/firewire/fw-sbp2.c
> @@ -1491,8 +1491,18 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
>  	orb->base.request_bus =
>  		dma_map_single(device->card->device, &orb->request,
>  			       sizeof(orb->request), DMA_TO_DEVICE);
> -	if (dma_mapping_error(device->card->device, orb->base.request_bus))
> +	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
> +		if (scsi_sg_count(cmd)) {
> +			dma_unmap_sg(device->card->device, scsi_sglist(cmd),
> +				     scsi_sg_count(cmd),
> +				     cmd->sc_data_direction);
> +			dma_unmap_single(device->card->device,
> +					 orb->page_table_bus,
> +					 sizeof(orb->page_table),
> +					 DMA_TO_DEVICE);
> +		}
>  		goto out;
> +	}
>  
>  	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
>  		      lu->command_block_agent_address + SBP2_ORB_POINTER);

Yes, we do have a leak there.  Thanks a lot for checking the code.

There is one thing missing in the fix:  Even with scsi_sg_count(cmd) !=
0, there is sometimes no orb->page_table to unmap.  It's when the
scatterlist was mapped into a single physical segment.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: sbp2: fix DMA mapping leak on the failure path

Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
who also provided a first version of the fix.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1323,6 +1323,19 @@ static unsigned int sbp2_status_to_sense
 	}
 }
 
+static void sbp2_unmap_scatterlist(struct device *card_device,
+				   struct sbp2_command_orb *orb)
+{
+	if (scsi_sg_count(orb->cmd))
+		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
+			     scsi_sg_count(orb->cmd),
+			     orb->cmd->sc_data_direction);
+
+	if (orb->page_table_bus)
+		dma_unmap_single(card_device, orb->page_table_bus,
+				 sizeof(orb->page_table), DMA_TO_DEVICE);
+}
+
 static void complete_command_orb(struct sbp2_orb *base_orb,
 				 struct sbp2_status *status)
 {
@@ -1364,15 +1377,7 @@ static void complete_command_orb(struct 
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
-
-	if (scsi_sg_count(orb->cmd) > 0)
-		dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
-			     scsi_sg_count(orb->cmd),
-			     orb->cmd->sc_data_direction);
-
-	if (orb->page_table_bus != 0)
-		dma_unmap_single(device->card->device, orb->page_table_bus,
-				 sizeof(orb->page_table), DMA_TO_DEVICE);
+	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
 	orb->done(orb->cmd);
@@ -1493,8 +1498,10 @@ static int sbp2_scsi_queuecommand(struct
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(device->card->device, orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
+		sbp2_unmap_scatterlist(device->card->device, orb);
 		goto out;
+	}
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);


-- 
Stefan Richter
-=====-==--= ---= ==-==
http://arcgraph.de/sr/

