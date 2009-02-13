Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZBMOwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZBMOwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZBMOvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:51:54 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30951 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbZBMOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:51:53 -0500
X-BigFish: VPS1(zzzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KF0ELU-02-IZU-01
Date: Fri, 13 Feb 2009 15:51:24 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] x86: memtest: introduce array to store memtest patterns
Message-ID: <20090213145124.GB13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:51:34.0753 (UTC) FILETIME=[90C60510:01C98DEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code cleanup

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   61 ++++++++++++++++++------------------------------
 1 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 00b8bdc..a8a6c51 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,47 +9,29 @@
 
 #include <asm/e820.h>
 
-#define _MAX_MEM_PATTERNS 4
+static unsigned long patterns[] = {
+	0UL,
+	-1UL,
+#ifdef CONFIG_X86_64
+	0x5555555555555555UL,
+	0xaaaaaaaaaaaaaaaaUL,
+#else
+	0x55555555UL,
+	0xaaaaaaaaUL,
+#endif
+};
 
 static void __init memtest(unsigned long start_phys, unsigned long size,
-				 unsigned pattern)
+			   unsigned long pattern)
 {
 	unsigned long i;
 	unsigned long *start;
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
 	incr = sizeof(unsigned long);
 	start_phys_aligned = ALIGN(start_phys, incr);
 	count = (size - (start_phys_aligned - start_phys))/incr;
@@ -58,15 +40,16 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
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
 					printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-						val, start_bad, last_bad + incr);
+					       pattern, start_bad,
+					       last_bad + incr);
 					reserve_early(start_bad, last_bad + incr, "BAD RAM");
 				}
 				start_bad = last_bad = start_phys_aligned;
@@ -75,7 +58,7 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 	}
 	if (start_bad) {
 		printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
-			val, start_bad, last_bad + incr);
+		       pattern, start_bad, last_bad + incr);
 		reserve_early(start_bad, last_bad + incr, "BAD RAM");
 	}
 }
@@ -95,13 +78,16 @@ early_param("memtest", parse_memtest);
 void __init early_memtest(unsigned long start, unsigned long end)
 {
 	u64 t_start, t_size;
-	unsigned pattern;
+	unsigned int i;
+	unsigned long pattern;
 
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
@@ -115,8 +101,7 @@ void __init early_memtest(unsigned long start, unsigned long end)
 
 			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
 			       (unsigned long long)t_start,
-			       (unsigned long long)t_start + t_size,
-			       pattern % _MAX_MEM_PATTERNS);
+			       (unsigned long long)t_start + t_size, idx);
 
 			memtest(t_start, t_size, pattern);
 
-- 
1.6.1.2



