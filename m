Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbXKFWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbXKFWnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbXKFWnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:43:16 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:44954 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXKFWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:43:16 -0500
Message-ID: <4730EE00.8040809@tiscali.nl>
Date: Tue, 06 Nov 2007 23:43:12 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix writing to unintended memory in pkt_generic_packet();
 drivers/block/pktcdvd.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CDROM_PACKET_SIZE is added as an offset to the pointer to unsigned char cmd[16].
The adjusted pointer is then used as a destination address in a call to
memset(). However, when CDROM_PACKET_SIZE is added to the pointer, it is
automatically scaled by the size of cmd, which is 16. This results in the call
to memset() writing to unintended memory.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a8130a4..548efcf 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -767,7 +767,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
-		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
+		memset((char *)rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
 
 	rq->timeout = 60*HZ;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
