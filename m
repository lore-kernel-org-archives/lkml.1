Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbYDHQdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbYDHQdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbYDHQ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991AbYDHQ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:09 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 22/28] x86: use a fallback dev for i386
Date: Tue,  8 Apr 2008 13:21:04 -0300
Message-Id: <12076718132980-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use a fallback dev for cases of a NULL device being passed (mostly ISA)
This comes from x86_64 implementation.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index f6cf434..0e9ec11 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -14,6 +14,16 @@
 #include <linux/module.h>
 #include <asm/io.h>
 
+/* Dummy device used for NULL arguments (normally ISA). Better would
+   be probably a smaller DMA mask, but this is bug-to-bug compatible
+   to i386. */
+struct device fallback_dev = {
+	.bus_id = "fallback device",
+	.coherent_dma_mask = DMA_32BIT_MASK,
+	.dma_mask = &fallback_dev.coherent_dma_mask,
+};
+
+
 static int dma_alloc_from_coherent_mem(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret)
 {
@@ -77,6 +87,9 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
+	if (!dev)
+		dev = &fallback_dev;
+
 	dma_mask = dev->coherent_dma_mask;
 	if (dma_mask == 0)
 		dma_mask = DMA_32BIT_MASK;
-- 
1.5.0.6

