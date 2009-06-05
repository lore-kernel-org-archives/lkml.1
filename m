Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZFEIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZFEIXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZFEIHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37487 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbZFEIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 50/62] Blackfin: add SSYNC to set_dma_sg() for descriptor fetching
Date: Fri,  5 Jun 2009 04:04:59 -0400
Message-Id: <1244189111-19639-51-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Make sure the internal core buffers are flushed before telling the DMA
engine to fetch the descriptor structure so that it gets the right values.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/dma.h b/arch/blackfin/include/asm/dma.h
index 46c5618..c9a5962 100644
--- a/arch/blackfin/include/asm/dma.h
+++ b/arch/blackfin/include/asm/dma.h
@@ -206,10 +206,16 @@ static inline unsigned long get_dma_curr_addr(unsigned int channel)
 
 static inline void set_dma_sg(unsigned int channel, struct dmasg *sg, int ndsize)
 {
+	/* Make sure the internal data buffers in the core are drained
+	 * so that the DMA descriptors are completely written when the
+	 * DMA engine goes to fetch them below.
+	 */
+	SSYNC();
+
+	dma_ch[channel].regs->next_desc_ptr = sg;
 	dma_ch[channel].regs->cfg =
 		(dma_ch[channel].regs->cfg & ~(0xf << 8)) |
 		((ndsize & 0xf) << 8);
-	dma_ch[channel].regs->next_desc_ptr = sg;
 }
 
 static inline int dma_channel_active(unsigned int channel)
-- 
1.6.3.1

