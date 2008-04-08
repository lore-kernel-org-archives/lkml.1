Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYDHQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYDHQfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbYDHQeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:34:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760881AbYDHQeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:34:09 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 24/28] x86: unify gfp masks
Date: Tue,  8 Apr 2008 13:21:06 -0300
Message-Id: <12076718251145-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the same gfp masks for x86_64 and i386.
It involves using HIGHMEM or DMA32 where necessary, for the sake
of code compatibility, (no real effect), and using the NORETRY
mask for i386.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |    6 ++++--
 arch/x86/kernel/pci-dma_64.c |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 11f100a..5450bd1 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -79,7 +79,7 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	unsigned long dma_mask = 0;
 
 	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
 	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &ret))
 		return ret;
@@ -91,7 +91,9 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dma_mask == 0)
 		dma_mask = DMA_32BIT_MASK;
 
- again:
+	/* Don't invoke OOM killer */
+	gfp |= __GFP_NORETRY;
+again:
 	page = dma_alloc_pages(dev, gfp, order);
 	if (page == NULL)
 		return NULL;
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 13a31a4..b956f59 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -49,6 +49,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	unsigned long dma_mask = 0;
 	u64 bus;
 
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
 	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
 		return memory;
-- 
1.5.0.6

