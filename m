Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998Ab0ATKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0ATKo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762Ab0ATKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:44:25 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:35055 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752551Ab0ATKoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:44:23 -0500
X-Greylist: delayed 1993 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 05:44:23 EST
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, arnd@arndb.de, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu,
       joerg.roedel@amd.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] asm-generic: dma: Add BUG_ON for uninitialized dma_ops
Date: Wed, 20 Jan 2010 11:08:31 +0100
Message-Id: <1263982111-24123-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Check that dma_ops are initialized correctly. Without this
checking you get kernel fault and you don't know where the problem is.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-generic/dma-mapping-common.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index e694263..ca8bc25 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -15,6 +15,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(ptr, size);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, virt_to_page(ptr),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
@@ -32,6 +33,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, attrs);
@@ -48,6 +50,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 
 	for_each_sg(sg, s, nents, i)
 		kmemcheck_mark_initialized(sg_virt(s), s->length);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	debug_dma_map_sg(dev, sg, nents, ents, dir);
@@ -61,6 +64,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
 	if (ops->unmap_sg)
@@ -75,6 +79,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, page, offset, size, dir, NULL);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
@@ -87,6 +92,7 @@ static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, NULL);
@@ -125,6 +131,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_cpu) {
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
@@ -142,6 +149,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_device) {
 		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
@@ -157,6 +165,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
@@ -169,6 +178,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
+	BUG_ON(!ops);
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
-- 
1.5.5.1

