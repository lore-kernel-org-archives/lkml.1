Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbZAXSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbZAXSms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbZAXSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:42:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57544 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbZAXSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:42:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:42:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/7] firewire: sbp2: fix payload limit at S1600 and S3200
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.e9a47dac79d6739c@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1394-2008 clause 16.3.4.1 (1394b-2002 clause 16.3.1.1) defines tighter
limits than 1394-2008 clause 6.2.2.3 (1394a-2000 clause 6.2.2.3).

Our previously too large limit doesn't matter though if the controller
reports its max_receive correctly.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -168,6 +168,7 @@ struct sbp2_target {
 	int address_high;
 	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
+	unsigned int max_payload;
 
 	int dont_block;	/* counter for each logical unit */
 	int blocked;	/* ditto */
@@ -1150,6 +1151,15 @@ static int sbp2_probe(struct device *dev
 
 	sbp2_init_workarounds(tgt, model, firmware_revision);
 
+	/*
+	 * At S100 we can do 512 bytes per packet, at S200 1024 bytes,
+	 * and so on up to 4096 bytes.  The SBP-2 max_payload field
+	 * specifies the max payload size as 2 ^ (max_payload + 2), so
+	 * if we set this to max_speed + 7, we get the right value.
+	 */
+	tgt->max_payload = min(device->max_speed + 7, 10U);
+	tgt->max_payload = min(tgt->max_payload, device->card->max_receive - 1);
+
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
@@ -1426,7 +1436,6 @@ static int sbp2_scsi_queuecommand(struct
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
-	unsigned int max_payload;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
@@ -1454,17 +1463,9 @@ static int sbp2_scsi_queuecommand(struct
 	orb->done = done;
 	orb->cmd  = cmd;
 
-	orb->request.next.high   = cpu_to_be32(SBP2_ORB_NULL);
-	/*
-	 * At speed 100 we can do 512 bytes per packet, at speed 200,
-	 * 1024 bytes per packet etc.  The SBP-2 max_payload field
-	 * specifies the max payload size as 2 ^ (max_payload + 2), so
-	 * if we set this to max_speed + 7, we get the right value.
-	 */
-	max_payload = min(device->max_speed + 7,
-			  device->card->max_receive - 1);
+	orb->request.next.high = cpu_to_be32(SBP2_ORB_NULL);
 	orb->request.misc = cpu_to_be32(
-		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
+		COMMAND_ORB_MAX_PAYLOAD(lu->tgt->max_payload) |
 		COMMAND_ORB_SPEED(device->max_speed) |
 		COMMAND_ORB_NOTIFY);
 

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

