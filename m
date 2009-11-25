Return-Path: <linux-kernel-owner+w=401wt.eu-S934999AbZKYVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999AbZKYVko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbZKYVjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58039 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759152AbZKYVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 1/8] Blackfin: fix suspend/resume failure with some on-chip ROMs
Date: Wed, 25 Nov 2009 16:39:00 -0500
Message-Id: <1259185147-31999-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Some Blackfin on-chip ROMs utilize some MDMA channels during the suspend
and resume process, but don't clean up after themselves.  So manually
clear all DMA channels when resuming since no DMA could have been running
at this point in time.  Now Linux should be able to work regardless of any
laziness on the part of the on-chip ROM or boot loader.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 1f17021..3946aff 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -225,8 +225,13 @@ int blackfin_dma_suspend(void)
 void blackfin_dma_resume(void)
 {
 	int i;
-	for (i = 0; i < MAX_DMA_SUSPEND_CHANNELS; ++i)
-		dma_ch[i].regs->peripheral_map = dma_ch[i].saved_peripheral_map;
+
+	for (i = 0; i < MAX_DMA_CHANNELS; ++i) {
+		dma_ch[i].regs->cfg = 0;
+
+		if (i < MAX_DMA_SUSPEND_CHANNELS)
+			dma_ch[i].regs->peripheral_map = dma_ch[i].saved_peripheral_map;
+	}
 }
 #endif
 
-- 
1.6.5.3

