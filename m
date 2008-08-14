Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYHNHMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYHNHMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 03:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYHNHMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 03:12:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39684 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYHNHMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 03:12:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 14 Aug 2008 09:12:01 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: grundler@google.com, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080814095549S.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <tkrat.84add1a51a966d30@s5r6.in-berlin.de>
References: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
 <20080813084514K.fujita.tomonori@lab.ntt.co.jp>
 <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
 <20080814095549S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Aug, FUJITA Tomonori wrote:
> On Wed, 13 Aug 2008 12:19:59 +0200 (CEST)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I keep the original scsi_sg_count to call dma_unmap_sg with it
>> later.
> 
> You need to keep it? You can access to it via scsi_sg_count when
> calling dma_unmap_sg? Seems that firewire code does.

Yes, I can easily do it this way; fixed below.

[...nents in dma_unmap_sg...]
> This is from Documentation/DMA-mapping.txt

Right.  How did I forget about that?



From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: remove redundant struct members

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   14 +++++---------
 drivers/ieee1394/sbp2.h |    4 ----
 2 files changed, 5 insertions(+), 13 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -656,11 +656,11 @@ static struct sbp2_command_info *sbp2uti
 static void sbp2util_mark_command_completed(struct sbp2_lu *lu,
 					    struct sbp2_command_info *cmd)
 {
-	if (cmd->sg_buffer) {
-		dma_unmap_sg(lu->ud->ne->host->device.parent, cmd->sg_buffer,
-			     cmd->sg_count, cmd->sg_dir);
-		cmd->sg_buffer = NULL;
-	}
+	if (scsi_sg_count(cmd->Current_SCpnt) > 0)
+		dma_unmap_sg(lu->ud->ne->host->device.parent,
+			     scsi_sglist(cmd->Current_SCpnt),
+			     scsi_sg_count(cmd->Current_SCpnt),
+			     cmd->Current_SCpnt->sc_data_direction);
 	list_move_tail(&cmd->list, &lu->cmd_orb_completed);
 }
 
@@ -1505,10 +1505,6 @@ static int sbp2_prep_command_orb_sg(stru
 	if (n == 0)
 		return -ENOMEM;
 
-	cmd->sg_buffer = sg;
-	cmd->sg_count = sg_count;
-	cmd->sg_dir = dma_dir;
-
 	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
 
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -252,10 +252,6 @@ struct sbp2_command_info {
 	struct sbp2_unrestricted_page_table
 		scatter_gather_element[SG_ALL] __attribute__((aligned(8)));
 	dma_addr_t sge_dma;
-
-	struct scatterlist *sg_buffer;
-	int sg_count;
-	enum dma_data_direction sg_dir;
 };
 
 /* Per FireWire host */


-- 
Stefan Richter
-=====-==--- =--- -===-
http://arcgraph.de/sr/

