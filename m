Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYJMUJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYJMUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYJMUFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:55 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:53415 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYJMUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:41 -0400
Message-Id: <20081013195917.925107374@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:56 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/18] m68k: Add missing dma_sync_single_range_for_{cpu,device}()
Content-Disposition: inline; filename=m68k-add-dma_sync_single_range_for_cpu-device.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

| include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_range_for_cpu':
| include/linux/ssb/ssb.h:517: error: implicit declaration of function 'dma_sync_single_range_for_cpu'
| include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_range_for_device':
| include/linux/ssb/ssb.h:538: error: implicit declaration of function 'dma_sync_single_range_for_device'

Add the missing dma_sync_single_range_for_{cpu,device}(), and remove the
`inline' for the non-static function dma_sync_single_for_device().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/dma.c         |    4 ++--
 include/asm-m68k/dma-mapping.h |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -66,8 +66,8 @@ void dma_free_coherent(struct device *de
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-inline void dma_sync_single_for_device(struct device *dev, dma_addr_t handle, size_t size,
-				       enum dma_data_direction dir)
+void dma_sync_single_for_device(struct device *dev, dma_addr_t handle,
+				size_t size, enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
--- a/include/asm-m68k/dma-mapping.h
+++ b/include/asm-m68k/dma-mapping.h
@@ -74,6 +74,14 @@ extern void dma_sync_single_for_device(s
 extern void dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
 				   enum dma_data_direction);
 
+static inline void dma_sync_single_range_for_device(struct device *dev,
+		dma_addr_t dma_handle, unsigned long offset, size_t size,
+		enum dma_data_direction direction)
+{
+	/* just sync everything for now */
+	dma_sync_single_for_device(dev, dma_handle, offset + size, direction);
+}
+
 static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
 					   size_t size, enum dma_data_direction dir)
 {
@@ -84,6 +92,14 @@ static inline void dma_sync_sg_for_cpu(s
 {
 }
 
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+		dma_addr_t dma_handle, unsigned long offset, size_t size,
+		enum dma_data_direction direction)
+{
+	/* just sync everything for now */
+	dma_sync_single_for_cpu(dev, dma_handle, offset + size, direction);
+}
+
 static inline int dma_mapping_error(struct device *dev, dma_addr_t handle)
 {
 	return 0;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

