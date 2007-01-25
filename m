Return-Path: <linux-kernel-owner+w=401wt.eu-S965599AbXAYGkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965599AbXAYGkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXAYGkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:40:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965599AbXAYGkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:40:22 -0500
Date: Wed, 24 Jan 2007 22:37:45 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: krh@redhat.com
Cc: zaitcev@redhat.com, linux-kernel@vger.kernel.org
Subject: Juju
Message-Id: <20070124223745.33278eb4.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kristian:

I only looked briefly at SBP-2, and at submit/callback paths it pulled,
because I do not understand most of the other issues.

Executive summary: please implement proper ORB cancellation. This is
how you verify that your locking model is worth anything: by interaction
of normal transactions with ->remove, ->suspend and SCSI aborts.
Currently, there's no telling if the code is sane or not.

I see that ORBs are always allocated with a call (like SKB) and not
embedded into drivers (like URBs). It's great, keep it up. Also,
never allow drivers to pass DMA-mapped buffers into fw_send_request
and friends. We made both of these mistakes in USB, and it hurts.

Now, about small things:

diff --git a/fw-sbp2.c b/fw-sbp2.c
index 8888f27..3a65095 100644
--- a/fw-sbp2.c
+++ b/fw-sbp2.c
@@ -303,7 +303,7 @@ complete_transaction(struct fw_card *card, int rcode,
 	unsigned long flags;
 
 	orb->rcode = rcode;
-	if (rcode != RCODE_COMPLETE) {
+	if (rcode != RCODE_COMPLETE) {		/* Huh? */
 		spin_lock_irqsave(&card->lock, flags);
 		list_del(&orb->link);
 		spin_unlock_irqrestore(&card->lock, flags);

This looks like an inverted test. Who does remove ORB from the list
if it's completed normally?

@@ -320,8 +320,7 @@ sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
 	unsigned long flags;
 
 	orb->pointer.high = 0;
-	orb->pointer.low = orb->request_bus;
-	fw_memcpy_to_be32(&orb->pointer, &orb->pointer, sizeof orb->pointer);
+	orb->pointer.low = cpu_to_be32(orb->request_bus);
 
 	spin_lock_irqsave(&device->card->lock, flags);
 	list_add_tail(&orb->link, &sd->orb_list);

I'll whine later about this

@@ -347,6 +346,7 @@ static void sbp2_cancel_orbs(struct fw_unit *unit)
 	list_splice_init(&sd->orb_list, &list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
+	/* XXX Notify the hardware -- show-stopper. */
 	list_for_each_entry_safe(orb, next, &list, link) {
 		orb->rcode = RCODE_CANCELLED;
 		orb->callback(orb, NULL);
@@ -364,6 +364,9 @@ complete_management_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 	complete(&orb->done);
 }
 
+/*
+ * This function must be called from a process context.
+ */
 static int
 sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 			 int function, int lun, void *response)
@@ -374,9 +377,9 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	unsigned long timeout;
 	int retval = -ENOMEM;
 
-	orb = kzalloc(sizeof *orb, GFP_ATOMIC);
+	orb = kzalloc(sizeof *orb, GFP_KERNEL);
 	if (orb == NULL)
-		return -ENOMEM;
+		goto out_orballoc;
 
 	/* The sbp2 device is going to send a block read request to
 	 * read out the request from host memory, so map it for

No reason to use the atomic pool, this function sleeps later anyway.

@@ -384,17 +387,22 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof orb->request, DMA_TO_DEVICE);
-	if (orb->base.request_bus == 0)
-		goto out;
+	if (dma_mapping_error(orb->base.request_bus))
+		goto out_orbreq;
 
 	orb->response_bus =
 		dma_map_single(device->card->device, &orb->response,
 			       sizeof orb->response, DMA_FROM_DEVICE);
-	if (orb->response_bus == 0)
-		goto out;
+	if (dma_mapping_error(orb->response_bus))
+		goto out_orbresp;
 
 	orb->request.response.high    = 0;
 	orb->request.response.low     = orb->response_bus;
+	/*
+	 * XXX Kristian, what exactly makes you think that DMA address
+	 * is 32 bits wide above? This is only guaranteed if device->
+	 * card->device has mask 0xffffffff. Where is that set?
+	 */
 
 	orb->request.misc =
 		management_orb_notify |

Obvious.

@@ -450,16 +458,18 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 
 	retval = 0;
  out:
-	dma_unmap_single(device->card->device, orb->base.request_bus,
-			 sizeof orb->request, DMA_TO_DEVICE);
 	dma_unmap_single(device->card->device, orb->response_bus,
 			 sizeof orb->response, DMA_FROM_DEVICE);
+ out_orbresp:
+	dma_unmap_single(device->card->device, orb->base.request_bus,
+			 sizeof orb->request, DMA_TO_DEVICE);
+ out_orbreq:
 
 	if (response)
 		fw_memcpy_from_be32(response,
 				    orb->response, sizeof orb->response);
 	kfree(orb);
-
+ out_orballoc:
 	return retval;
 }
 

This is how to use "out" labels properly, kernel style.

@@ -746,6 +756,7 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 	struct fw_unit *unit = orb->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
+	struct scsi_cmnd *cmd;
 	int result;
 
 	if (status != NULL) {
@@ -798,10 +809,11 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 				 sizeof orb->request_buffer_bus,
 				 DMA_FROM_DEVICE);
 
-	orb->cmd->result = result << 16;
-	orb->done(orb->cmd);
-
+	cmd = orb->cmd;
 	kfree(orb);
+
+	cmd->result = result << 16;
+	cmd->done(cmd);
 }
 
 static void sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)

Just a stylistic sugar.

@@ -896,6 +908,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_device *sd = unit->device.driver_data;
 	struct sbp2_command_orb *orb;
+	u32 misc;
 
 	/* Bidirectional commands are not yet implemented, and unknown
 	 * transfer direction not handled. */
@@ -917,28 +930,32 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof orb->request, DMA_TO_DEVICE);
+	if (dma_mapping_error(orb->base.request_bus)) {
+		kfree(orb);
+		cmd->result = DID_ERROR << 16;	/* XXX Better error? */
+		done(cmd);
+		return 0;
+	}
 
 	orb->unit = unit;
-	orb->done = done;
 	orb->cmd  = cmd;
 
-	orb->request.next.high   = SBP2_ORB_NULL;
+	orb->request.next.high   = cpu_to_be32(SBP2_ORB_NULL);
 	orb->request.next.low    = 0x0;
 	/* At speed 100 we can do 512 bytes per packet, at speed 200,
 	 * 1024 bytes per packet etc.  The SBP-2 max_payload field
 	 * specifies the max payload size as 2 ^ (max_payload + 2), so
 	 * if we set this to max_speed + 7, we get the right value. */
-	orb->request.misc =
+	misc =
 		command_orb_max_payload(device->node->max_speed + 7) |
 		command_orb_speed(device->node->max_speed) |
 		command_orb_notify;
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
-		orb->request.misc |=
-			command_orb_direction(SBP2_DIRECTION_FROM_MEDIA);
+		misc |= command_orb_direction(SBP2_DIRECTION_FROM_MEDIA);
 	else if (cmd->sc_data_direction == DMA_TO_DEVICE)
-		orb->request.misc |=
-			command_orb_direction(SBP2_DIRECTION_TO_MEDIA);
+		misc |= command_orb_direction(SBP2_DIRECTION_TO_MEDIA);
+	orb->request.misc = cpu_to_be32(misc);
 
 	if (cmd->use_sg) {
 		sbp2_command_orb_map_scatterlist(orb);
@@ -947,6 +964,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 		 * could we get the scsi or blk layer to do that by
 		 * reporting our max supported block size? */
 		fw_error("command > 64k\n");
+		kfree(orb);
 		cmd->result = DID_ERROR << 16;
 		done(cmd);
 		return 0;
@@ -954,11 +972,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 		sbp2_command_orb_map_buffer(orb);
 	}
 
-	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof orb->request);
-
-	memset(orb->request.command_block,
-	       0, sizeof orb->request.command_block);
-	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
+	memcpy(orb->request.command_block, cmd->cmnd, 12);
 
 	orb->base.callback = complete_command_orb;
 

The way you byteswap irks me. You make the job of static analisys
tools harder, for no benefit. The sensible rule of thumb is, use wire
order for untyped arrays of bytes (you do that), use CPU order when
kernel knows structures (you kinda do it, but in a very messy way
by swapping 32-bit values; now all you need is one 16-bit value for
the whole idea to unravel), and never mix them! Alas, this is how
fw_send_request is designed: the payload can be header, or can be data.

But like I said, it's small bananas.

Cheers,
-- Pete

P.S. If I were using git, I would clone a Linus git tree and work
there. All this out-of-tree module stuff is just a waste of time.
You even wrote an RPM spec! What for? Not to mention that the
blacklists that you install interfere with non-jujufied kernels.
If you work with a cloned repo, your pre-integration history will
also be available post-integration. I presume you want to integrate
into mainline eventually, don't you?
