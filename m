Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbYBAVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbYBAVeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYBAVe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:34:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48385 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbYBAVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:34:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 1 Feb 2008 22:31:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix bogus s/g access change
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.29809d64b9426d9a@s5r6.in-berlin.de>
Message-ID: <tkrat.4c8ccf852a2999af@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
 <472BA567.8040301@s5r6.in-berlin.de>
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
 <20071104130315.GL28340@kernel.dk> <472DC6DE.6050402@s5r6.in-berlin.de>
 <20071104132621.GM28340@kernel.dk>
 <tkrat.4947ae1f5baa964f@s5r6.in-berlin.de>
 <tkrat.2a470664250af864@s5r6.in-berlin.de>
 <tkrat.29809d64b9426d9a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_dma_len(sg) is invalid before the s/g list is DMA-mapped.

This fixes a post 2.6.24 regression which prevents access to SBP-2
devices on several architectures, introduced by "ieee1394: sbp2: s/g
list access cosmetics", commit 825f1df545ab0289185373b0eaf06fb0b3487422.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.24/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.24.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.24/drivers/ieee1394/sbp2.c
@@ -1465,10 +1465,9 @@ static void sbp2_prep_command_orb_sg(str
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
 
 	/* special case if only one element (and less than 64KB in size) */
-	if ((scsi_use_sg == 1) &&
-	    (sg_dma_len(sg) <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
+	if (scsi_use_sg == 1 && sg->length <= SBP2_MAX_SG_ELEMENT_LENGTH) {
 
-		cmd->dma_size = sg_dma_len(sg);
+		cmd->dma_size = sg->length;
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
 					    sg_page(sg), sg->offset,

-- 
Stefan Richter
-=====-==--- --=- ----=
http://arcgraph.de/sr/

