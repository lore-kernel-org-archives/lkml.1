Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZJIIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZJIIa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758682AbZJIIa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:30:26 -0400
Received: from mail-yw0-f182.google.com ([209.85.211.182]:40238 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbZJIIaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WNqLOBfG0wNSEq7li1lWF7T2HUJ/hP5Lxb8FL4VGsPVH7wftPaBU0yCMSJ+twZp+cR
         LlqeDO1qFCEqATmG4/Pi7txDtuoFHL3vaaHV+p08ZHgo0NQRIrwTqu6IASUbmq33en9s
         MryJMEjfq5dTVhPAMmAIDJsV3uUMRBcND+S4M=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 6/8] sparc: Use bitmap_find_next_zero_area
Date: Fri,  9 Oct 2009 17:29:19 +0900
Message-Id: <1255076961-21325-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1255076961-21325-5-git-send-email-akinobu.mita@gmail.com>
References: <>
 <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/sparc/kernel/ldc.c |   16 ++++------------
 arch/sparc/mm/sun4c.c   |   17 +++++------------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index adf5f27..aa27d26 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/init.h>
+#include <linux/bitmap.h>
 
 #include <asm/hypervisor.h>
 #include <asm/iommu.h>
@@ -1875,7 +1876,7 @@ EXPORT_SYMBOL(ldc_read);
 static long arena_alloc(struct ldc_iommu *iommu, unsigned long npages)
 {
 	struct iommu_arena *arena = &iommu->arena;
-	unsigned long n, i, start, end, limit;
+	unsigned long n, start, end, limit;
 	int pass;
 
 	limit = arena->limit;
@@ -1883,7 +1884,7 @@ static long arena_alloc(struct ldc_iommu *iommu, unsigned long npages)
 	pass = 0;
 
 again:
-	n = find_next_zero_bit(arena->map, limit, start);
+	n = bitmap_find_next_zero_area(arena->map, limit, start, npages, 0);
 	end = n + npages;
 	if (unlikely(end >= limit)) {
 		if (likely(pass < 1)) {
@@ -1896,16 +1897,7 @@ again:
 			return -1;
 		}
 	}
-
-	for (i = n; i < end; i++) {
-		if (test_bit(i, arena->map)) {
-			start = i + 1;
-			goto again;
-		}
-	}
-
-	for (i = n; i < end; i++)
-		__set_bit(i, arena->map);
+	bitmap_set(arena->map, n, npages);
 
 	arena->hint = end;
 
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index 2ffacd6..a89baf0 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
+#include <linux/bitmap.h>
 
 #include <asm/sections.h>
 #include <asm/page.h>
@@ -1021,20 +1022,12 @@ static char *sun4c_lockarea(char *vaddr, unsigned long size)
 	npages = (((unsigned long)vaddr & ~PAGE_MASK) +
 		  size + (PAGE_SIZE-1)) >> PAGE_SHIFT;
 
-	scan = 0;
 	local_irq_save(flags);
-	for (;;) {
-		scan = find_next_zero_bit(sun4c_iobuffer_map,
-					  iobuffer_map_size, scan);
-		if ((base = scan) + npages > iobuffer_map_size) goto abend;
-		for (;;) {
-			if (scan >= base + npages) goto found;
-			if (test_bit(scan, sun4c_iobuffer_map)) break;
-			scan++;
-		}
-	}
+	base = bitmap_find_next_zero_area(sun4c_iobuffer_map, iobuffer_map_size,
+						0, npages, 0);
+	if (base >= iobuffer_map_size)
+		goto abend;
 
-found:
 	high = ((base + npages) << PAGE_SHIFT) + sun4c_iobuffer_start;
 	high = SUN4C_REAL_PGDIR_ALIGN(high);
 	while (high > sun4c_iobuffer_high) {
-- 
1.5.4.3

