Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbXJ1Pv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbXJ1Pv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXJ1PvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:51:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59995 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751240AbXJ1PvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:51:20 -0400
Date: Sun, 28 Oct 2007 16:51:32 +0100
From: Adrian Bunk <bunk@kernel.org>
To: krh@redhat.com, stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ieee1394_transactions.c: remove dead code
Message-ID: <20071028155132.GA7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Intel C Compiler.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ieee1394/ieee1394_transactions.c |    2 --
 1 file changed, 2 deletions(-)

0df395c3e17cd6ac7176707a33580a1836db8bdf 
diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index c39c70a..6779893 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -208,108 +208,106 @@ void hpsb_free_tlabel(struct hpsb_packet *packet)
 /**
  * hpsb_packet_success - Make sense of the ack and reply codes
  *
  * Make sense of the ack and reply codes and return more convenient error codes:
  * 0 = success.  -%EBUSY = node is busy, try again.  -%EAGAIN = error which can
  * probably resolved by retry.  -%EREMOTEIO = node suffers from an internal
  * error.  -%EACCES = this transaction is not allowed on requested address.
  * -%EINVAL = invalid address at node.
  */
 int hpsb_packet_success(struct hpsb_packet *packet)
 {
 	switch (packet->ack_code) {
 	case ACK_PENDING:
 		switch ((packet->header[1] >> 12) & 0xf) {
 		case RCODE_COMPLETE:
 			return 0;
 		case RCODE_CONFLICT_ERROR:
 			return -EAGAIN;
 		case RCODE_DATA_ERROR:
 			return -EREMOTEIO;
 		case RCODE_TYPE_ERROR:
 			return -EACCES;
 		case RCODE_ADDRESS_ERROR:
 			return -EINVAL;
 		default:
 			HPSB_ERR("received reserved rcode %d from node %d",
 				 (packet->header[1] >> 12) & 0xf,
 				 packet->node_id);
 			return -EAGAIN;
 		}
-		BUG();
 
 	case ACK_BUSY_X:
 	case ACK_BUSY_A:
 	case ACK_BUSY_B:
 		return -EBUSY;
 
 	case ACK_TYPE_ERROR:
 		return -EACCES;
 
 	case ACK_COMPLETE:
 		if (packet->tcode == TCODE_WRITEQ
 		    || packet->tcode == TCODE_WRITEB) {
 			return 0;
 		} else {
 			HPSB_ERR("impossible ack_complete from node %d "
 				 "(tcode %d)", packet->node_id, packet->tcode);
 			return -EAGAIN;
 		}
 
 	case ACK_DATA_ERROR:
 		if (packet->tcode == TCODE_WRITEB
 		    || packet->tcode == TCODE_LOCK_REQUEST) {
 			return -EAGAIN;
 		} else {
 			HPSB_ERR("impossible ack_data_error from node %d "
 				 "(tcode %d)", packet->node_id, packet->tcode);
 			return -EAGAIN;
 		}
 
 	case ACK_ADDRESS_ERROR:
 		return -EINVAL;
 
 	case ACK_TARDY:
 	case ACK_CONFLICT_ERROR:
 	case ACKX_NONE:
 	case ACKX_SEND_ERROR:
 	case ACKX_ABORTED:
 	case ACKX_TIMEOUT:
 		/* error while sending */
 		return -EAGAIN;
 
 	default:
 		HPSB_ERR("got invalid ack %d from node %d (tcode %d)",
 			 packet->ack_code, packet->node_id, packet->tcode);
 		return -EAGAIN;
 	}
-	BUG();
 }
 
 struct hpsb_packet *hpsb_make_readpacket(struct hpsb_host *host, nodeid_t node,
 					 u64 addr, size_t length)
 {
 	struct hpsb_packet *packet;
 
 	if (length == 0)
 		return NULL;
 
 	packet = hpsb_alloc_packet(length);
 	if (!packet)
 		return NULL;
 
 	packet->host = host;
 	packet->node_id = node;
 
 	if (hpsb_get_tlabel(packet)) {
 		hpsb_free_packet(packet);
 		return NULL;
 	}
 
 	if (length == 4)
 		fill_async_readquad(packet, addr);
 	else
 		fill_async_readblock(packet, addr, length);
 
 	return packet;
 }
 

