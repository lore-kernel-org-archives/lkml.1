Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYIKObP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYIKObP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIKOa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:30:59 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45063 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYIKOa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:30:58 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Alexis Bruemmer <alexisb@us.ibm.com>, Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 1/2] x86: avoid unnecessary low zone allocation in Calgary's alloc_coherent
Date: Thu, 11 Sep 2008 23:08:47 +0900
Message-Id: <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
up the gfp flag according to the device dma_mask but Calgary doesn't
need it because of virtual mappings. This patch avoids unnecessary low
zone allocation.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86/kernel/pci-calgary_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 8415d92..fe7695e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -491,6 +491,8 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	npages = size >> PAGE_SHIFT;
 	order = get_order(size);
 
+	flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	/* alloc enough pages (and possibly more) */
 	ret = (void *)__get_free_pages(flag, order);
 	if (!ret)
-- 
1.5.4.2

