Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZCPRF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZCPRF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZCPRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:05:44 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:11523
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759918AbZCPRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:05:43 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGLZH3-02-R4X-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] dma-debug: add checks for kernel text and rodata
Date: Mon, 16 Mar 2009 18:05:28 +0100
Message-ID: <1237223130-26519-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Mar 2009 17:05:30.0540 (UTC) FILETIME=[69480EC0:01C9A659]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: get notified if a device dma maps illegal areas

This patch adds a check to print a warning message when a device driver
tries to map a memory area from the kernel text segment or rodata.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 128d9de..b6a303f 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -29,6 +29,8 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 
+#include <asm/sections.h>
+
 #define HASH_SIZE       1024ULL
 #define HASH_FN_SHIFT   13
 #define HASH_FN_MASK    (HASH_SIZE - 1)
@@ -549,6 +551,24 @@ static void check_for_stack(struct device *dev, void *addr)
 				"stack [addr=%p]\n", addr);
 }
 
+static inline bool overlap(void *addr, u64 size, void *start, void *end)
+{
+	void *addr2 = (char *)addr + size;
+
+	return ((addr >= start && addr < end) ||
+		(addr2 >= start && addr2 < end) ||
+		((addr < start) && (addr2 >= end)));
+}
+
+static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
+{
+	if (overlap(addr, size, _text, _etext) ||
+	    overlap(addr, size, __start_rodata, __end_rodata))
+		err_printk(dev, NULL, "DMA-API: device driver maps "
+				"memory from kernel text or rodata "
+				"[addr=%p] [size=%llu]\n", addr, size);
+}
+
 static void check_sync(struct device *dev, dma_addr_t addr,
 		       u64 size, u64 offset, int direction, bool to_cpu)
 {
@@ -645,8 +665,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	entry->direction = direction;
 
 	if (map_single) {
+		void *addr = ((char *)page_address(page)) + offset;
+
 		entry->type = dma_debug_single;
-		check_for_stack(dev, page_address(page) + offset);
+		check_for_stack(dev, addr);
+		check_for_illegal_area(dev, addr, size);
 	}
 
 	add_dma_entry(entry);
@@ -699,6 +722,7 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_mapped_ents = mapped_ents;
 
 		check_for_stack(dev, sg_virt(s));
+		check_for_illegal_area(dev, sg_virt(s), s->length);
 
 		add_dma_entry(entry);
 	}
-- 
1.5.6.4


