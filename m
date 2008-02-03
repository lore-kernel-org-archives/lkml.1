Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYBCWKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYBCWKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYBCWKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:10:01 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47837 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYBCWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:10:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:09:50 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/9] firewire: fw-sbp2: log bus_id at management request
 failures
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.4fc5a11f66e8358c@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for easier readable logs if more than one SBP-2 device is present.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   66 ++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -149,6 +149,7 @@ struct sbp2_target {
 	struct kref kref;
 	struct fw_unit *unit;
 	struct list_head lu_list;
+	const char *bus_id;
 
 	u64 management_agent_address;
 	int directory_id;
@@ -566,20 +567,20 @@ sbp2_send_management_orb(struct sbp2_log
 
 	retval = -EIO;
 	if (sbp2_cancel_orbs(lu) == 0) {
-		fw_error("orb reply timed out, rcode=0x%02x\n",
-			 orb->base.rcode);
+		fw_error("%s: orb reply timed out, rcode=0x%02x\n",
+			 lu->tgt->bus_id, orb->base.rcode);
 		goto out;
 	}
 
 	if (orb->base.rcode != RCODE_COMPLETE) {
-		fw_error("management write failed, rcode 0x%02x\n",
-			 orb->base.rcode);
+		fw_error("%s: management write failed, rcode 0x%02x\n",
+			 lu->tgt->bus_id, orb->base.rcode);
 		goto out;
 	}
 
 	if (STATUS_GET_RESPONSE(orb->status) != 0 ||
 	    STATUS_GET_SBP_STATUS(orb->status) != 0) {
-		fw_error("error status: %d:%d\n",
+		fw_error("%s: error status: %d:%d\n", lu->tgt->bus_id,
 			 STATUS_GET_RESPONSE(orb->status),
 			 STATUS_GET_SBP_STATUS(orb->status));
 		goto out;
@@ -664,7 +665,7 @@ static void sbp2_release_target(struct k
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	fw_notify("released %s\n", tgt->unit->device.bus_id);
+	fw_notify("released %s\n", tgt->bus_id);
 
 	put_device(&tgt->unit->device);
 	scsi_host_put(shost);
@@ -693,12 +694,11 @@ static void sbp2_login(struct work_struc
 {
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
-	struct Scsi_Host *shost =
-		container_of((void *)lu->tgt, struct Scsi_Host, hostdata[0]);
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
+	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
 	struct scsi_lun eight_bytes_lun;
-	struct fw_unit *unit = lu->tgt->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
@@ -715,14 +715,14 @@ static void sbp2_login(struct work_struc
 		if (lu->retries++ < 5)
 			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 		else
-			fw_error("failed to login to %s LUN %04x\n",
-				 unit->device.bus_id, lu->lun);
+			fw_error("%s: failed to login to LUN %04x\n",
+				 tgt->bus_id, lu->lun);
 		goto out;
 	}
 
-	lu->generation        = generation;
-	lu->tgt->node_id      = node_id;
-	lu->tgt->address_high = local_node_id << 16;
+	lu->generation    = generation;
+	tgt->node_id	  = node_id;
+	tgt->address_high = local_node_id << 16;
 
 	/* Get command block agent offset and login id. */
 	lu->command_block_agent_address =
@@ -730,8 +730,8 @@ static void sbp2_login(struct work_struc
 		response.command_block_agent.low;
 	lu->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
 
-	fw_notify("logged in to %s LUN %04x (%d retries)\n",
-		  unit->device.bus_id, lu->lun, lu->retries);
+	fw_notify("%s: logged in to LUN %04x (%d retries)\n",
+		  tgt->bus_id, lu->lun, lu->retries);
 
 #if 0
 	/* FIXME: The linux1394 sbp2 does this last step. */
@@ -747,6 +747,7 @@ static void sbp2_login(struct work_struc
 	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
 	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
 	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
+	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
@@ -791,7 +792,7 @@ static void sbp2_login(struct work_struc
 	 */
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
  out:
-	sbp2_target_put(lu->tgt);
+	sbp2_target_put(tgt);
 }
 
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
@@ -874,7 +875,7 @@ static int sbp2_scan_unit_dir(struct sbp
 			if (timeout > tgt->mgt_orb_timeout)
 				fw_notify("%s: config rom contains %ds "
 					  "management ORB timeout, limiting "
-					  "to %ds\n", tgt->unit->device.bus_id,
+					  "to %ds\n", tgt->bus_id,
 					  timeout / 1000,
 					  tgt->mgt_orb_timeout / 1000);
 			break;
@@ -902,7 +903,7 @@ static void sbp2_init_workarounds(struct
 	if (w)
 		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
 			  "if you need the workarounds parameter for %s\n",
-			  tgt->unit->device.bus_id);
+			  tgt->bus_id);
 
 	if (w & SBP2_WORKAROUND_OVERRIDE)
 		goto out;
@@ -924,8 +925,7 @@ static void sbp2_init_workarounds(struct
 	if (w)
 		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
-			  tgt->unit->device.bus_id,
-			  w, firmware_revision, model);
+			  tgt->bus_id, w, firmware_revision, model);
 	tgt->workarounds = w;
 }
 
@@ -949,6 +949,7 @@ static int sbp2_probe(struct device *dev
 	tgt->unit = unit;
 	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
+	tgt->bus_id = unit->device.bus_id;
 
 	if (fw_device_enable_phys_dma(device) < 0)
 		goto fail_shost_put;
@@ -999,8 +1000,8 @@ static void sbp2_reconnect(struct work_s
 {
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
-	struct fw_unit *unit = lu->tgt->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
@@ -1015,8 +1016,7 @@ static void sbp2_reconnect(struct work_s
 				     SBP2_RECONNECT_REQUEST,
 				     lu->login_id, NULL) < 0) {
 		if (lu->retries++ >= 5) {
-			fw_error("failed to reconnect to %s\n",
-				 unit->device.bus_id);
+			fw_error("%s: failed to reconnect\n", tgt->bus_id);
 			/* Fall back and try to log in again. */
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
@@ -1025,17 +1025,17 @@ static void sbp2_reconnect(struct work_s
 		goto out;
 	}
 
-	lu->generation        = generation;
-	lu->tgt->node_id      = node_id;
-	lu->tgt->address_high = local_node_id << 16;
+	lu->generation    = generation;
+	tgt->node_id      = node_id;
+	tgt->address_high = local_node_id << 16;
 
-	fw_notify("reconnected to %s LUN %04x (%d retries)\n",
-		  unit->device.bus_id, lu->lun, lu->retries);
+	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
+		  tgt->bus_id, lu->lun, lu->retries);
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
  out:
-	sbp2_target_put(lu->tgt);
+	sbp2_target_put(tgt);
 }
 
 static void sbp2_update(struct fw_unit *unit)
@@ -1377,7 +1377,7 @@ static int sbp2_scsi_abort(struct scsi_c
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 
-	fw_notify("sbp2_scsi_abort\n");
+	fw_notify("%s: sbp2_scsi_abort\n", lu->tgt->bus_id);
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
 

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

