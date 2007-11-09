Return-Path: <linux-kernel-owner+w=401wt.eu-S1763816AbXKIPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763816AbXKIPhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763769AbXKIPgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:36:38 -0500
Received: from nic2.axis.se ([193.13.178.10]:42040 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763749AbXKIPgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:36:37 -0500
Date: Fri, 9 Nov 2007 16:36:27 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRISv32: Add cache flush operations
Message-ID: <20071109153627.GE6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add cache flush operations for CRISv32.

These are needed due to a cache bug, and can be used to make sure
that the DMA descriptors are flushed to memory and can be safely
handled by DMA.

flush_dma_descr - Flush one DMA descriptor.
flush_dma_list - Flush a complete list of DMA descriptors.
cris_flush_cache - Flush the complete cache.
cris_flush_cache_range - Flush only the specified range

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 cache.c      |   33 ++++++++++++++++++++
 cacheflush.S |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/arch/cris/arch-v32/kernel/cache.c b/arch/cris/arch-v32/kernel/cache.c
new file mode 100644
index 0000000..80da7b8
--- /dev/null
+++ b/arch/cris/arch-v32/kernel/cache.c
@@ -0,0 +1,33 @@
+#include <linux/module.h>
+#include <asm/io.h>
+#include <asm/arch/cache.h>
+#include <asm/arch/hwregs/dma.h>
+
+/* This file is used to workaround a cache bug, Guinness TR 106. */
+
+inline void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
+{
+	/* Flush descriptor to make sure we get correct in_eop and after. */
+	asm volatile ("ftagd [%0]" :: "r" (descr));
+	/* Flush buffer pointed out by descriptor. */
+	if (flush_buf)
+		cris_flush_cache_range(phys_to_virt((unsigned)descr->buf),
+				(unsigned)(descr->after - descr->buf));
+}
+EXPORT_SYMBOL(flush_dma_descr);
+
+void flush_dma_list(struct dma_descr_data *descr)
+{
+	while (1) {
+		flush_dma_descr(descr, 1);
+		if (descr->eol)
+			break;
+		descr = phys_to_virt((unsigned)descr->next);
+	}
+}
+EXPORT_SYMBOL(flush_dma_list);
+
+/* From cacheflush.S */
+EXPORT_SYMBOL(cris_flush_cache);
+/* From cacheflush.S */
+EXPORT_SYMBOL(cris_flush_cache_range);
diff --git a/arch/cris/arch-v32/kernel/cacheflush.S b/arch/cris/arch-v32/kernel/cacheflush.S
new file mode 100644
index 0000000..956e8fb
--- /dev/null
+++ b/arch/cris/arch-v32/kernel/cacheflush.S
@@ -0,0 +1,94 @@
+	.global cris_flush_cache_range
+cris_flush_cache_range:
+	move.d 1024, $r12
+	cmp.d $r11, $r12
+	bhi cris_flush_1KB
+	nop
+	add.d $r10, $r11
+	ftagd [$r10]
+cris_flush_last:
+	addq 32, $r10
+	cmp.d $r11, $r10
+	blt cris_flush_last
+	ftagd [$r10]
+	ret
+	nop
+cris_flush_1KB:
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ftagd [$r10]
+	addq 32, $r10
+	ba cris_flush_cache_range
+	sub.d $r12, $r11
+
+	.global cris_flush_cache
+cris_flush_cache:
+	moveq 0, $r10
+cris_flush_line:
+	move.d 16*1024, $r11
+	addq 16, $r10
+	cmp.d $r10, $r11
+	blt cris_flush_line
+	fidxd [$r10]
+	ret
+	nop

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
