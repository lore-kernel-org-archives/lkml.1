Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZBUNhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZBUNhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZBUNgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:36:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39655 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZBUNgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:36:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JIHopQXVBMSi+WC9lFXfnjHZMPGg+3rFAWZkGRu6Jxh64GSOm8TWCKu3ZFjj9WQzWq
         lc89lM1ioX3ADT6oQwxXP79/FTkrjcw4CTCNwz1VIwIIe/imgSZgpUqP2zBkpspwbQ9p
         zuKYY8RuRRyjDvlnfwxRXD9mSCYVB9JoX/iBI=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] kmemcheck: add hooks for page- and sg-dma-mappings
Date: Sat, 21 Feb 2009 14:36:03 +0100
Message-Id: <1235223364-2097-4-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for page allocator support to prevent false positives
when accessing pages which are dma-mapped.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/include/asm/dma-mapping.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 830bb0e..713a002 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -117,7 +117,12 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	struct scatterlist *s;
+	int i;
+
 	BUG_ON(!valid_dma_direction(direction));
+	for_each_sg(sg, s, nents, i)
+		kmemcheck_mark_initialized(sg_virt(s), s->length);
 	return ops->map_sg(hwdev, sg, nents, direction);
 }
 
@@ -215,6 +220,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(direction));
+	kmemcheck_mark_initialized(page_address(page) + offset, size);
 	return ops->map_single(dev, page_to_phys(page) + offset,
 			       size, direction);
 }
-- 
1.6.0.6

