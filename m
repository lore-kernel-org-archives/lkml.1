Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284Ab0ADDKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0ADDKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271Ab0ADDJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:09:47 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56492 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0ADDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:05:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 24/29] x86: move back find_e820_area to e820.c
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make early_res.c more clean, so later could move it to /kernel

Signed-off: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h      |    2 +
 arch/x86/include/asm/early_res.h |    4 +-
 arch/x86/kernel/e820.c           |   57 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/early_res.c      |   56 -------------------------------------
 4 files changed, 61 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index efad699..a8299e1 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -109,6 +109,8 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 
 extern unsigned long end_user_pfn;
 
+extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
+extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 #include <asm/early_res.h>
 
diff --git a/arch/x86/include/asm/early_res.h b/arch/x86/include/asm/early_res.h
index 2d43b16..5a4d2eb 100644
--- a/arch/x86/include/asm/early_res.h
+++ b/arch/x86/include/asm/early_res.h
@@ -2,8 +2,6 @@
 #define _ASM_X86_EARLY_RES_H
 #ifdef __KERNEL__
 
-extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
-extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
@@ -12,6 +10,8 @@ extern void early_res_to_bootmem(u64 start, u64 end);
 void reserve_early_without_check(u64 start, u64 end, char *name);
 u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
+u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align);
 #include <linux/range.h>
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 27a756e..acd7be6 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -715,6 +715,63 @@ core_initcall(e820_mark_nvs_memory);
 #endif
 
 /*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 addr;
+		u64 ei_start, ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+
+		ei_last = ei->addr + ei->size;
+		ei_start = ei->addr;
+		addr = find_early_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr == -1ULL)
+			continue;
+
+		return addr;
+	}
+	return -1ULL;
+}
+
+/*
+ * Find next free range after *start
+ */
+u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 addr;
+		u64 ei_start, ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+
+		ei_last = ei->addr + ei->size;
+		ei_start = ei->addr;
+		addr = find_early_area_size(ei_start, ei_last, start,
+					 sizep, align);
+
+		if (addr == -1ULL)
+			continue;
+
+		return addr;
+	}
+
+	return -1ULL;
+}
+
+/*
  * pre allocated 4k and reserved it in e820
  */
 u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
diff --git a/arch/x86/kernel/early_res.c b/arch/x86/kernel/early_res.c
index aba02f2..d0a70cc 100644
--- a/arch/x86/kernel/early_res.c
+++ b/arch/x86/kernel/early_res.c
@@ -499,60 +499,4 @@ out:
 	return -1ULL;
 }
 
-/*
- * Find a free area with specified alignment in a specific range.
- */
-u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-
-		ei_last = ei->addr + ei->size;
-		ei_start = ei->addr;
-		addr = find_early_area(ei_start, ei_last, start, end,
-					 size, align);
-
-		if (addr == -1ULL)
-			continue;
-
-		return addr;
-	}
-	return -1ULL;
-}
-
-/*
- * Find next free range after *start
- */
-u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-
-		ei_last = ei->addr + ei->size;
-		ei_start = ei->addr;
-		addr = find_early_area_size(ei_start, ei_last, start,
-					 sizep, align);
-
-		if (addr == -1ULL)
-			continue;
-
-		return addr;
-	}
-
-	return -1ULL;
-}
 
-- 
1.6.4.2

