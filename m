Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0BITij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:38:39 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54634 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 25/35] x86: add find_fw_memmap_area
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could move early_res up

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/early_res.h |    1 +
 arch/x86/kernel/e820.c           |    4 ++++
 arch/x86/kernel/early_res.c      |   17 +++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/early_res.h b/arch/x86/include/asm/early_res.h
index 5a4d2eb..9758f3d 100644
--- a/arch/x86/include/asm/early_res.h
+++ b/arch/x86/include/asm/early_res.h
@@ -12,6 +12,7 @@ u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 			 u64 *sizep, u64 align);
+u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
 #include <linux/range.h>
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 86cbbd0..2c3b090 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -750,6 +750,10 @@ u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
 	return -1ULL;
 }
 
+u64 __init find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
+{
+	return find_e820_area(start, end, size, align);
+}
 /*
  * Find next free range after *start
  */
diff --git a/arch/x86/kernel/early_res.c b/arch/x86/kernel/early_res.c
index 38a0c61..e209fc4 100644
--- a/arch/x86/kernel/early_res.c
+++ b/arch/x86/kernel/early_res.c
@@ -7,16 +7,14 @@
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 
-#include <asm/e820.h>
 #include <asm/early_res.h>
-#include <asm/proto.h>
 
 /*
  * Early reserved memory areas.
  */
 /*
  * need to make sure this one is bigger enough before
- * find_e820_area could be used
+ * find_fw_memmap_area could be used
  */
 #define MAX_EARLY_RES_X 32
 
@@ -180,6 +178,13 @@ void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
 	__reserve_early(start, end, name, 1);
 }
 
+u64 __init __weak find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
+{
+	panic("should have find_fw_memmap_area defined with arch");
+
+	return -1ULL;
+}
+
 static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
 {
 	u64 start, end, size, mem;
@@ -198,13 +203,13 @@ static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
 		start = early_res[0].end;
 	end = ex_start;
 	if (start + size < end)
-		mem = find_e820_area(start, end, size,
+		mem = find_fw_memmap_area(start, end, size,
 					 sizeof(struct early_res));
 	if (mem == -1ULL) {
 		start = ex_end;
 		end = max_pfn_mapped << PAGE_SHIFT;
 		if (start + size < end)
-			mem = find_e820_area(start, end, size,
+			mem = find_fw_memmap_area(start, end, size,
 						 sizeof(struct early_res));
 	}
 	if (mem == -1ULL)
@@ -343,7 +348,7 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 		start = MAX_DMA32_PFN << PAGE_SHIFT;
 #endif
 	end = max_pfn_mapped << PAGE_SHIFT;
-	mem = find_e820_area(start, end, size, sizeof(struct range));
+	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
 	if (mem == -1ULL)
 		panic("can not find more space for range free");
 
-- 
1.6.4.2

