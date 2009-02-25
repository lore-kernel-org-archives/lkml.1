Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZBYK2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZBYK2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZBYK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:28:08 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9304 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbZBYK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:28:06 -0500
X-BigFish: VPS3(z34a4jzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KFMAEH-01-2JP-01
Date: Wed, 25 Feb 2009 11:27:27 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] x86: memtest: introduce array to select memtest
	patterns
Message-ID: <20090225102727.GR6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:27:55.0127 (UTC) FILETIME=[B87FA870:01C99733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: code cleanup

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   65 +++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 00b8bdc..827f940 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,48 +9,25 @@
 
 #include <asm/e820.h>
 
-#define _MAX_MEM_PATTERNS 4
+static u64 patterns[] __initdata = {
+	0,
+	0xffffffffffffffffULL,
+	0x5555555555555555ULL,
+	0xaaaaaaaaaaaaaaaaULL,
+};
 
 static void __init memtest(unsigned long start_phys, unsigned long size,
-				 unsigned pattern)
+			   u64 pattern)
 {
 	unsigned long i;
-	unsigned long *start;
+	u64 *start;
 	unsigned long start_bad;
 	unsigned long last_bad;
-	unsigned long val;
 	unsigned long start_phys_aligned;
 	unsigned long count;
 	unsigned long incr;
 
-	pattern = pattern % _MAX_MEM_PATTERNS;
-
-	switch (pattern) {
-	case 0:
-		val = 0UL;
-		break;
-	case 1:
-		val = -1UL;
-		break;
-	case 2:
-#ifdef CONFIG_X86_64
-		val = 0x5555555555555555UL;
-#else
-		val = 0x55555555UL;
-#endif
-		break;
-	case 3:
-#ifdef CONFIG_X86_64
-		val = 0xaaaaaaaaaaaaaaaaUL;
-#else
-		val = 0xaaaaaaaaUL;
-#endif
-		break;
-	default:
-		return;
-	}
-
-	incr = sizeof(unsigned long);
+	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
 	count = (size - (start_phys_aligned - start_phys))/incr;
 	start = __va(start_phys_aligned);
@@ -58,15 +35,16 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	last_bad = 0;
 
 	for (i = 0; i < count; i++)
-		start[i] = val;
+		start[i] = pattern;
 	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start != val) {
+		if (*start != pattern) {
 			if (start_phys_aligned == last_bad + incr) {
 				last_bad += incr;
 			} else {
 				if (start_bad) {
-					printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-						val, start_bad, last_bad + incr);
+					printk(KERN_CONT "\n  %016llx bad mem addr %010lx - %010lx reserved",
+					       (unsigned long long) pattern,
+					       start_bad, last_bad + incr);
 					reserve_early(start_bad, last_bad + incr, "BAD RAM");
 				}
 				start_bad = last_bad = start_phys_aligned;
@@ -74,8 +52,9 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 		}
 	}
 	if (start_bad) {
-		printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-			val, start_bad, last_bad + incr);
+		printk(KERN_CONT "\n  %016llx bad mem addr %010lx - %010lx reserved",
+		       (unsigned long long) pattern, start_bad,
+		       last_bad + incr);
 		reserve_early(start_bad, last_bad + incr, "BAD RAM");
 	}
 }
@@ -95,13 +74,16 @@ early_param("memtest", parse_memtest);
 void __init early_memtest(unsigned long start, unsigned long end)
 {
 	u64 t_start, t_size;
-	unsigned pattern;
+	unsigned int i;
+	u64 pattern;
 
 	if (!memtest_pattern)
 		return;
 
 	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
-	for (pattern = 0; pattern < memtest_pattern; pattern++) {
+	for (i = 0; i < memtest_pattern; i++) {
+		unsigned int idx = i % ARRAY_SIZE(patterns);
+		pattern = patterns[idx];
 		t_start = start;
 		t_size = 0;
 		while (t_start < end) {
@@ -115,8 +97,7 @@ void __init early_memtest(unsigned long start, unsigned long end)
 
 			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
 			       (unsigned long long)t_start,
-			       (unsigned long long)t_start + t_size,
-			       pattern % _MAX_MEM_PATTERNS);
+			       (unsigned long long)t_start + t_size, idx);
 
 			memtest(t_start, t_size, pattern);
 
-- 
1.6.1.3



