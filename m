Return-Path: <linux-kernel-owner+w=401wt.eu-S1765141AbYB1T5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765141AbYB1T5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbYB1TwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:52:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60207 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbYB1TwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:52:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:51:11 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: fw-sbp2: remove usages of fw_memcpy_to_be32
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
Message-ID: <tkrat.28583f8ef62d43de@s5r6.in-berlin.de>
References: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write directly in big endian instead of byte-swapping after the fact.
This saves a few conversions, lets gcc use constant endianess
conversions where possible, and enables deeper endianess annotation.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   96 ++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 52 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -223,8 +223,8 @@ struct sbp2_status {
 };
 
 struct sbp2_pointer {
-	u32 high;
-	u32 low;
+	__be32 high;
+	__be32 low;
 };
 
 struct sbp2_orb {
@@ -252,8 +252,8 @@ struct sbp2_management_orb {
 	struct {
 		struct sbp2_pointer password;
 		struct sbp2_pointer response;
-		u32 misc;
-		u32 length;
+		__be32 misc;
+		__be32 length;
 		struct sbp2_pointer status_fifo;
 	} request;
 	__be32 response[4];
@@ -262,13 +262,10 @@ struct sbp2_management_orb {
 	struct sbp2_status status;
 };
 
-#define LOGIN_RESPONSE_GET_LOGIN_ID(v)	((v).misc & 0xffff)
-#define LOGIN_RESPONSE_GET_LENGTH(v)	(((v).misc >> 16) & 0xffff)
-
 struct sbp2_login_response {
-	u32 misc;
+	__be32 misc;
 	struct sbp2_pointer command_block_agent;
-	u32 reconnect_hold;
+	__be32 reconnect_hold;
 };
 #define COMMAND_ORB_DATA_SIZE(v)	((v))
 #define COMMAND_ORB_PAGE_SIZE(v)	((v) << 16)
@@ -284,7 +281,7 @@ struct sbp2_command_orb {
 	struct {
 		struct sbp2_pointer next;
 		struct sbp2_pointer data_descriptor;
-		u32 misc;
+		__be32 misc;
 		u8 command_block[12];
 	} request;
 	struct scsi_cmnd *cmd;
@@ -453,8 +450,7 @@ sbp2_send_orb(struct sbp2_orb *orb, stru
 	unsigned long flags;
 
 	orb->pointer.high = 0;
-	orb->pointer.low = orb->request_bus;
-	fw_memcpy_to_be32(&orb->pointer, &orb->pointer, sizeof(orb->pointer));
+	orb->pointer.low = cpu_to_be32(orb->request_bus);
 
 	spin_lock_irqsave(&device->card->lock, flags);
 	list_add_tail(&orb->link, &lu->orb_list);
@@ -530,31 +526,31 @@ sbp2_send_management_orb(struct sbp2_log
 	if (dma_mapping_error(orb->response_bus))
 		goto fail_mapping_response;
 
-	orb->request.response.high    = 0;
-	orb->request.response.low     = orb->response_bus;
+	orb->request.response.high = 0;
+	orb->request.response.low  = cpu_to_be32(orb->response_bus);
 
-	orb->request.misc =
+	orb->request.misc = cpu_to_be32(
 		MANAGEMENT_ORB_NOTIFY |
 		MANAGEMENT_ORB_FUNCTION(function) |
-		MANAGEMENT_ORB_LUN(lun_or_login_id);
-	orb->request.length =
-		MANAGEMENT_ORB_RESPONSE_LENGTH(sizeof(orb->response));
-
-	orb->request.status_fifo.high = lu->address_handler.offset >> 32;
-	orb->request.status_fifo.low  = lu->address_handler.offset;
+		MANAGEMENT_ORB_LUN(lun_or_login_id));
+	orb->request.length = cpu_to_be32(
+		MANAGEMENT_ORB_RESPONSE_LENGTH(sizeof(orb->response)));
+
+	orb->request.status_fifo.high =
+		cpu_to_be32(lu->address_handler.offset >> 32);
+	orb->request.status_fifo.low  =
+		cpu_to_be32(lu->address_handler.offset);
 
 	if (function == SBP2_LOGIN_REQUEST) {
 		/* Ask for 2^2 == 4 seconds reconnect grace period */
-		orb->request.misc |=
+		orb->request.misc |= cpu_to_be32(
 			MANAGEMENT_ORB_RECONNECT(2) |
-			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login);
+			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login));
 		timeout = lu->tgt->mgt_orb_timeout;
 	} else {
 		timeout = SBP2_ORB_TIMEOUT;
 	}
 
-	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));
-
 	init_completion(&orb->done);
 	orb->base.callback = complete_management_orb;
 
@@ -599,8 +595,7 @@ sbp2_send_management_orb(struct sbp2_log
 			 sizeof(orb->response), DMA_FROM_DEVICE);
  fail_mapping_response:
 	if (response)
-		fw_memcpy_from_be32(response,
-				    orb->response, sizeof(orb->response));
+		memcpy(response, orb->response, sizeof(orb->response));
 	kref_put(&orb->base.kref, free_orb);
 
 	return retval;
@@ -855,11 +850,10 @@ static void sbp2_login(struct work_struc
 	tgt->address_high = local_node_id << 16;
 	sbp2_set_generation(lu, generation);
 
-	/* Get command block agent offset and login id. */
 	lu->command_block_agent_address =
-		((u64) (response.command_block_agent.high & 0xffff) << 32) |
-		response.command_block_agent.low;
-	lu->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
+		((u64)(be32_to_cpu(response.command_block_agent.high) & 0xffff)
+		      << 32) | be32_to_cpu(response.command_block_agent.low);
+	lu->login_id = be32_to_cpu(response.misc) & 0xffff;
 
 	fw_notify("%s: logged in to LUN %04x (%d retries)\n",
 		  tgt->bus_id, lu->lun, lu->retries);
@@ -1338,9 +1332,12 @@ sbp2_map_scatterlist(struct sbp2_command
 	 * tables.
 	 */
 	if (count == 1 && sg_dma_len(sg) < SBP2_MAX_SG_ELEMENT_LENGTH) {
-		orb->request.data_descriptor.high = lu->tgt->address_high;
-		orb->request.data_descriptor.low  = sg_dma_address(sg);
-		orb->request.misc |= COMMAND_ORB_DATA_SIZE(sg_dma_len(sg));
+		orb->request.data_descriptor.high =
+			cpu_to_be32(lu->tgt->address_high);
+		orb->request.data_descriptor.low  =
+			cpu_to_be32(sg_dma_address(sg));
+		orb->request.misc |=
+			cpu_to_be32(COMMAND_ORB_DATA_SIZE(sg_dma_len(sg)));
 		return 0;
 	}
 
@@ -1361,16 +1358,14 @@ sbp2_map_scatterlist(struct sbp2_command
 				goto fail_page_table;
 			}
 			l = min(sg_len, SBP2_MAX_SG_ELEMENT_LENGTH);
-			orb->page_table[j].low = sg_addr;
-			orb->page_table[j].high = (l << 16);
+			orb->page_table[j].low = cpu_to_be32(sg_addr);
+			orb->page_table[j].high = cpu_to_be32(l << 16);
 			sg_addr += l;
 			sg_len -= l;
 			j++;
 		}
 	}
 
-	fw_memcpy_to_be32(orb->page_table, orb->page_table,
-			  sizeof(orb->page_table[0]) * j);
 	orb->page_table_bus =
 		dma_map_single(device->card->device, orb->page_table,
 			       sizeof(orb->page_table), DMA_TO_DEVICE);
@@ -1384,11 +1379,10 @@ sbp2_map_scatterlist(struct sbp2_command
 	 * initiator (i.e. us), but data_descriptor can refer to data
 	 * on other nodes so we need to put our ID in descriptor.high.
 	 */
-	orb->request.data_descriptor.high = lu->tgt->address_high;
-	orb->request.data_descriptor.low  = orb->page_table_bus;
-	orb->request.misc |=
-		COMMAND_ORB_PAGE_TABLE_PRESENT |
-		COMMAND_ORB_DATA_SIZE(j);
+	orb->request.data_descriptor.high = cpu_to_be32(lu->tgt->address_high);
+	orb->request.data_descriptor.low  = cpu_to_be32(orb->page_table_bus);
+	orb->request.misc |= cpu_to_be32(COMMAND_ORB_PAGE_TABLE_PRESENT |
+					 COMMAND_ORB_DATA_SIZE(j));
 
 	return 0;
 
@@ -1434,7 +1428,7 @@ static int sbp2_scsi_queuecommand(struct
 	orb->done = done;
 	orb->cmd  = cmd;
 
-	orb->request.next.high   = SBP2_ORB_NULL;
+	orb->request.next.high   = cpu_to_be32(SBP2_ORB_NULL);
 	orb->request.next.low    = 0x0;
 	/*
 	 * At speed 100 we can do 512 bytes per packet, at speed 200,
@@ -1444,23 +1438,21 @@ static int sbp2_scsi_queuecommand(struct
 	 */
 	max_payload = min(device->max_speed + 7,
 			  device->card->max_receive - 1);
-	orb->request.misc =
+	orb->request.misc = cpu_to_be32(
 		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
 		COMMAND_ORB_SPEED(device->max_speed) |
-		COMMAND_ORB_NOTIFY;
+		COMMAND_ORB_NOTIFY);
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
-		orb->request.misc |=
-			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_FROM_MEDIA);
+		orb->request.misc |= cpu_to_be32(
+			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_FROM_MEDIA));
 	else if (cmd->sc_data_direction == DMA_TO_DEVICE)
-		orb->request.misc |=
-			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA);
+		orb->request.misc |= cpu_to_be32(
+			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA));
 
 	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
 		goto out;
 
-	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));
-
 	memset(orb->request.command_block,
 	       0, sizeof(orb->request.command_block));
 	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));

-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

