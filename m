Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXHYQYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXHYQYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXHYQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:24:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35025 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXHYQYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:24:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 25 Aug 2007 18:24:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.762675fb3b50d134@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following fixes for the new and old 1394 subsystems:

Kristian Høgsberg (1):
      firewire: Add ref-counting for sbp2 orbs (fix command abortion)

Stefan Richter (2):
      ieee1394: sbp2: fix sbp2_remove_device for error cases
      firewire: fix unloading of fw-ohci while devices are attached


 drivers/firewire/fw-card.c |    6 +++-
 drivers/firewire/fw-sbp2.c |   49 +++++++++++++++++++++++++++++------
 drivers/ieee1394/sbp2.c    |   14 +++++-----
 3 files changed, 51 insertions(+), 18 deletions(-)


commit e57d2011a6276d55a87f26653a0395f302ce0d51
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Fri Aug 24 18:59:58 2007 -0400

    firewire: Add ref-counting for sbp2 orbs (fix command abortion)
    
    This handles the case where we get the status write before getting the
    complete_transaction callback ("status write for unknown orb").  In
    this case, we just assume that the initial orb pointer transaction
    succeeded and finish the orb.  To prevent the transaction callback
    from touching freed memory, we ref-count the orb structures.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index ba816ef..238730f 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -159,6 +159,7 @@ struct sbp2_pointer {
 
 struct sbp2_orb {
 	struct fw_transaction t;
+	struct kref kref;
 	dma_addr_t request_bus;
 	int rcode;
 	struct sbp2_pointer pointer;
@@ -280,6 +281,14 @@ static const struct {
 };
 
 static void
+free_orb(struct kref *kref)
+{
+	struct sbp2_orb *orb = container_of(kref, struct sbp2_orb, kref);
+
+	kfree(orb);
+}
+
+static void
 sbp2_status_write(struct fw_card *card, struct fw_request *request,
 		  int tcode, int destination, int source,
 		  int generation, int speed,
@@ -312,8 +321,8 @@ sbp2_status_write(struct fw_card *card, struct fw_request *request,
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(orb, &sd->orb_list, link) {
 		if (STATUS_GET_ORB_HIGH(status) == 0 &&
-		    STATUS_GET_ORB_LOW(status) == orb->request_bus &&
-		    orb->rcode == RCODE_COMPLETE) {
+		    STATUS_GET_ORB_LOW(status) == orb->request_bus) {
+			orb->rcode = RCODE_COMPLETE;
 			list_del(&orb->link);
 			break;
 		}
@@ -325,6 +334,8 @@ sbp2_status_write(struct fw_card *card, struct fw_request *request,
 	else
 		fw_error("status write for unknown orb\n");
 
+	kref_put(&orb->kref, free_orb);
+
 	fw_send_response(card, request, RCODE_COMPLETE);
 }
 
@@ -335,13 +346,27 @@ complete_transaction(struct fw_card *card, int rcode,
 	struct sbp2_orb *orb = data;
 	unsigned long flags;
 
-	orb->rcode = rcode;
-	if (rcode != RCODE_COMPLETE) {
-		spin_lock_irqsave(&card->lock, flags);
+	/*
+	 * This is a little tricky.  We can get the status write for
+	 * the orb before we get this callback.  The status write
+	 * handler above will assume the orb pointer transaction was
+	 * successful and set the rcode to RCODE_COMPLETE for the orb.
+	 * So this callback only sets the rcode if it hasn't already
+	 * been set and only does the cleanup if the transaction
+	 * failed and we didn't already get a status write.
+	 */
+	spin_lock_irqsave(&card->lock, flags);
+
+	if (orb->rcode == -1)
+		orb->rcode = rcode;
+	if (orb->rcode != RCODE_COMPLETE) {
 		list_del(&orb->link);
-		spin_unlock_irqrestore(&card->lock, flags);
 		orb->callback(orb, NULL);
 	}
+
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	kref_put(&orb->kref, free_orb);
 }
 
 static void
@@ -360,6 +385,10 @@ sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
 	list_add_tail(&orb->link, &sd->orb_list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
+	/* Take a ref for the orb list and for the transaction callback. */
+	kref_get(&orb->kref);
+	kref_get(&orb->kref);
+
 	fw_send_request(device->card, &orb->t, TCODE_WRITE_BLOCK_REQUEST,
 			node_id, generation, device->max_speed, offset,
 			&orb->pointer, sizeof(orb->pointer),
@@ -416,6 +445,7 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	if (orb == NULL)
 		return -ENOMEM;
 
+	kref_init(&orb->base.kref);
 	orb->response_bus =
 		dma_map_single(device->card->device, &orb->response,
 			       sizeof(orb->response), DMA_FROM_DEVICE);
@@ -490,7 +520,7 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	if (response)
 		fw_memcpy_from_be32(response,
 				    orb->response, sizeof(orb->response));
-	kfree(orb);
+	kref_put(&orb->base.kref, free_orb);
 
 	return retval;
 }
@@ -886,7 +916,6 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 
 	orb->cmd->result = result;
 	orb->done(orb->cmd);
-	kfree(orb);
 }
 
 static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
@@ -1005,6 +1034,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 
 	/* Initialize rcode to something not RCODE_COMPLETE. */
 	orb->base.rcode = -1;
+	kref_init(&orb->base.kref);
 
 	orb->unit = unit;
 	orb->done = done;
@@ -1051,10 +1081,11 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	sbp2_send_orb(&orb->base, unit, sd->node_id, sd->generation,
 		      sd->command_block_agent_address + SBP2_ORB_POINTER);
 
+	kref_put(&orb->base.kref, free_orb);
 	return 0;
 
  fail_mapping:
-	kfree(orb);
+	kref_put(&orb->base.kref, free_orb);
  fail_alloc:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }

commit 8a2d9ed3210464d22fccb9834970629c1c36fa36
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Aug 21 01:05:14 2007 +0200

    firewire: fix unloading of fw-ohci while devices are attached
    
    Fix panic in run_timer_softirq right after "modprobe -r firewire-ohci"
    if a FireWire disk was attached and firewire-sbp2 loaded.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 0aeab32..3e97199 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -510,9 +510,11 @@ fw_core_remove_card(struct fw_card *card)
 	/* Set up the dummy driver. */
 	card->driver = &dummy_driver;
 
-	fw_flush_transactions(card);
-
 	fw_destroy_nodes(card);
+	flush_scheduled_work();
+
+	fw_flush_transactions(card);
+	del_timer_sync(&card->flush_timer);
 
 	fw_card_put(card);
 }

commit a2ee3f9bbb0ce57102dad8928d54f59acdc4b8f7
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 11 11:51:16 2007 +0200

    ieee1394: sbp2: fix sbp2_remove_device for error cases
    
    Bug found by Olaf Hering <olh@suse.de>:
    sbp2util_remove_command_orb_pool requires a valid lu->hi pointer.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 47dbe8f..a81ba8f 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -513,9 +513,9 @@ static int sbp2util_create_command_orb_pool(struct sbp2_lu *lu)
 	return 0;
 }
 
-static void sbp2util_remove_command_orb_pool(struct sbp2_lu *lu)
+static void sbp2util_remove_command_orb_pool(struct sbp2_lu *lu,
+					     struct hpsb_host *host)
 {
-	struct hpsb_host *host = lu->hi->host;
 	struct list_head *lh, *next;
 	struct sbp2_command_info *cmd;
 	unsigned long flags;
@@ -922,15 +922,16 @@ static void sbp2_remove_device(struct sbp2_lu *lu)
 
 	if (!lu)
 		return;
-
 	hi = lu->hi;
+	if (!hi)
+		goto no_hi;
 
 	if (lu->shost) {
 		scsi_remove_host(lu->shost);
 		scsi_host_put(lu->shost);
 	}
 	flush_scheduled_work();
-	sbp2util_remove_command_orb_pool(lu);
+	sbp2util_remove_command_orb_pool(lu, hi->host);
 
 	list_del(&lu->lu_list);
 
@@ -971,9 +972,8 @@ static void sbp2_remove_device(struct sbp2_lu *lu)
 
 	lu->ud->device.driver_data = NULL;
 
-	if (hi)
-		module_put(hi->host->driver->owner);
-
+	module_put(hi->host->driver->owner);
+no_hi:
 	kfree(lu);
 }
 

-- 
Stefan Richter
-=====-=-=== =--- ==--=
http://arcgraph.de/sr/

