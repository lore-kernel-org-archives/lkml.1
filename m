Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZJ1In5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZJ1In5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932708AbZJ1In4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:43:56 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60692 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbZJ1Inq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jFUUx/Z7EbJdBfMbU79JHWyb2lzBsxfJfPfZC+zajuCv9XuOnEz6/w3b5bQxdF5G5U
         /1Bqh9WFRy/6ABODTuzJoBVtIMCxSAe39rCVxE/bpavwXJhqXd5Hq726qrpcQEYnYDjF
         5W3qkIEULhcpxoEUAR46QL8rOUerGiQgp5dBg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, sparclinux@vger.kernel.org
Subject: [PATCH 5/7] sparc: Use bitmap_find_next_zero_area
Date: Wed, 28 Oct 2009 17:43:15 +0900
Message-Id: <1256719397-4258-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
References: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/ldc.c |   16 ++++------------
 arch/sparc/mm/sun4c.c   |   17 +++++------------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index cb3c72c..cefd05e 100644
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
1.6.5.1

