Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYJ2W7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYJ2W7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYJ2Wqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:32 -0400
Received: from kroah.org ([198.145.64.141]:56282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756065AbYJ2WqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:15 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/49] Staging: poch: Fine grained locking
Date: Wed, 29 Oct 2008 15:40:11 -0700
Message-Id: <1225320016-21803-44-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Lock only the portion of code that does register access.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index 3ecbd7c..1f14792 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -485,27 +485,30 @@ static void channel_dma_init(struct channel_info *channel)
 	/* The DMA address page register is shared between the RX and
 	 * TX channels, so acquire lock.
 	 */
-	spin_lock(channel->iomem_lock);
 	for (i = 0; i < channel->group_count; i++) {
 		page = i / 32;
 		group_in_page = i % 32;
 
 		group_reg = group_regs_base + (group_in_page * 4);
 
+		spin_lock(channel->iomem_lock);
 		iowrite32(page, fpga + FPGA_DMA_ADR_PAGE_REG);
 		iowrite32(channel->groups[i].dma_addr, fpga + group_reg);
+		spin_unlock(channel->iomem_lock);
 	}
+
 	for (i = 0; i < channel->group_count; i++) {
 		page = i / 32;
 		group_in_page = i % 32;
 
 		group_reg = group_regs_base + (group_in_page * 4);
 
+		spin_lock(channel->iomem_lock);
 		iowrite32(page, fpga + FPGA_DMA_ADR_PAGE_REG);
 		printk(KERN_INFO PFX "%ld: read dma_addr: 0x%x\n", i,
 		       ioread32(fpga + group_reg));
+		spin_unlock(channel->iomem_lock);
 	}
-	spin_unlock(channel->iomem_lock);
 
 }
 
-- 
1.6.0.2

