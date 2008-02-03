Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYBCWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYBCWN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYBCWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:13:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYBCWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:13:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:13:13 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.8110272bacc3f714@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fw-sbp2 takes the necessary time to reconnect to a logical unit
after bus reset, the SCSI core keeps sending new commands.  They are all
immediately completed with host busy status, and application clients or
filesystems will break quickly.  The SCSI device might even be taken
offline:  http://bugzilla.kernel.org/show_bug.cgi?id=9734

The only remedy seems to be to block the SCSI device until reconnect.
Alas the SCSI core has no useful API to block only one logical unit i.e.
the scsi_device, therefore we block the entire Scsi_Host.  This
currently corresponds to an SBP-2 target.  In case of targets with
multiple logical units, we need to satisfy the dependencies between
logical units by carefully tracking the blocking state of the target and
its units.  We block all logical units of a target as soon as one of
them needs to be blocked, and keep them blocked until all of them are
ready to be unblocked.

Furthermore, as the history of the old sbp2 driver has shown, the
scsi_block_requests() API is a minefield with high potential of
deadlocks.  We therefore take extra measures to keep logical units
unblocked during __scsi_add_device() and during shutdown.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   71 +++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -41,6 +41,7 @@
 #include <linux/stringify.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <asm/atomic.h>
 #include <asm/system.h>
 
 #include <scsi/scsi.h>
@@ -139,6 +140,7 @@ struct sbp2_logical_unit {
 	int generation;
 	int retries;
 	struct delayed_work work;
+	atomic_t blocked;
 };
 
 /*
@@ -157,6 +159,9 @@ struct sbp2_target {
 	int address_high;
 	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
+
+	atomic_t dont_block;
+	atomic_t blocked;
 };
 
 /*
@@ -646,6 +651,53 @@ static void sbp2_agent_reset_no_wait(str
 			&z, sizeof(z), complete_agent_reset_write_no_wait, t);
 }
 
+/*
+ * Blocks lu->tgt if all of the following conditions are met:
+ *   - Login, INQUIRY, and high-level SCSI setup of all logical units of the
+ *     target have been successfully finished (indicated by dont_block == 0).
+ *   - The lu->generation is stale.  sbp2_reconnect will unblock lu later.
+ */
+static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
+{
+	struct fw_card *card = fw_device(lu->tgt->unit->device.parent)->card;
+
+	if (!atomic_read(&lu->tgt->dont_block) &&
+	    lu->generation != card->generation &&
+	    atomic_cmpxchg(&lu->blocked, 0, 1) == 0) {
+
+		/* raise the block count of the target */
+		if (atomic_inc_return(&lu->tgt->blocked) == 1) {
+			scsi_block_requests(lu->sdev->host);
+			fw_notify("blocked %s\n", lu->tgt->bus_id);
+		}
+	}
+}
+
+/* Unblocks lu->tgt as soon as all its logical units can be unblocked. */
+static void sbp2_conditionally_unblock(struct sbp2_logical_unit *lu)
+{
+	if (atomic_cmpxchg(&lu->blocked, 1, 0) == 1) {
+
+		/* lower the block count of the target */
+		if (atomic_dec_and_test(&lu->tgt->blocked)) {
+			scsi_unblock_requests(lu->sdev->host);
+			fw_notify("unblocked %s\n", lu->tgt->bus_id);
+		}
+	}
+}
+
+
+/* Prevents future blocking of tgt and then unblocks it. */
+static void sbp2_unblock(struct sbp2_target *tgt)
+{
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+
+	atomic_inc(&tgt->dont_block);
+	smp_wmb();
+	scsi_unblock_requests(shost);
+}
+
 static void sbp2_release_target(struct kref *kref)
 {
 	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
@@ -653,6 +705,12 @@ static void sbp2_release_target(struct k
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 
+	/*
+	 * Make sure that the target is unblocked and won't be blocked anymore
+	 * before scsi_remove_device() is called.  Else it will deadlock.
+	 */
+	sbp2_unblock(tgt);
+
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
@@ -717,11 +775,14 @@ static void sbp2_login(struct work_struc
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
-		if (lu->retries++ < 5)
+		if (lu->retries++ < 5) {
 			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
-		else
+		} else {
 			fw_error("%s: failed to login to LUN %04x\n",
 				 tgt->bus_id, lu->lun);
+			/* Let any waiting I/O fail from now on. */
+			sbp2_unblock(lu->tgt);
+		}
 		goto out;
 	}
 
@@ -749,6 +810,7 @@ static void sbp2_login(struct work_struc
 	/* This was a re-login. */
 	if (lu->sdev) {
 		sbp2_cancel_orbs(lu);
+		sbp2_conditionally_unblock(lu);
 		goto out;
 	}
 
@@ -786,6 +848,8 @@ static void sbp2_login(struct work_struc
 		 * Can you believe it?  Everything went well.
 		 */
 		lu->sdev = sdev;
+		smp_wmb();  /* We need lu->sdev when we want to block lu. */
+		atomic_dec(&lu->tgt->dont_block);
 		scsi_device_put(sdev);
 		goto out;
 	}
@@ -828,6 +892,7 @@ static int sbp2_add_logical_unit(struct 
 	lu->sdev = NULL;
 	lu->lun  = lun_entry & 0xffff;
 	lu->retries = 0;
+	atomic_inc(&tgt->dont_block);
 	INIT_LIST_HEAD(&lu->orb_list);
 	INIT_DELAYED_WORK(&lu->work, sbp2_login);
 
@@ -1053,6 +1118,7 @@ static void sbp2_reconnect(struct work_s
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
+	sbp2_conditionally_unblock(lu);
  out:
 	sbp2_target_put(tgt);
 }
@@ -1172,6 +1238,7 @@ complete_command_orb(struct sbp2_orb *ba
 		 * or when sending the write (less likely).
 		 */
 		result = DID_BUS_BUSY << 16;
+		sbp2_conditionally_block(orb->lu);
 	}
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

