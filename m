Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbZBMOzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbZBMOzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBMOzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:55:46 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:50684 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZBMOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:55:45 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KF0ESC-01-UBY-01
Date: Fri, 13 Feb 2009 15:55:17 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] x86: memtest: adapt log messages
Message-ID: <20090213145517.GD13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:55:27.0756 (UTC) FILETIME=[1BA774C0:01C98DEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt log messages to

* print test pattern instead of pattern number,
* correct format for output on 32-bit
* show pattern as stored in memory.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 82321d9..54c143b 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -24,9 +24,13 @@ static unsigned long patterns[] = {
 static void reserve_bad_mem(unsigned long pattern, unsigned long start_bad,
 			    unsigned long end_bad)
 {
-	printk(KERN_CONT "\n  %016lx bad mem addr "
-	       "%010lx - %010lx reserved",
-	       pattern, start_bad, end_bad);
+#ifdef CONFIG_X86_64
+	printk(KERN_CONT "\n  %016llx bad mem addr %010lx - %010lx reserved",
+	       cpu_to_be64(pattern), start_bad, end_bad);
+#else
+	printk(KERN_CONT "\n  %08x bad mem addr %010lx - %010lx reserved",
+	       cpu_to_be32(pattern), start_bad, end_bad);
+#endif
 	reserve_early(start_bad, end_bad, "BAD RAM");
 }
 
@@ -86,7 +90,7 @@ void __init early_memtest(unsigned long start, unsigned long end)
 	if (!memtest_pattern)
 		return;
 
-	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
+	printk(KERN_INFO "early_memtest: number of tests %d", memtest_pattern);
 	for (i = 0; i < memtest_pattern; i++) {
 		unsigned int idx = i % ARRAY_SIZE(patterns);
 		pattern = patterns[idx];
@@ -101,10 +105,13 @@ void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
-			       (unsigned long long)t_start,
-			       (unsigned long long)t_start + t_size, idx);
-
+#ifdef CONFIG_X86_64
+			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
+			       t_start, t_start + t_size, cpu_to_be64(pattern));
+#else
+			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
+			       t_start, t_start + t_size, cpu_to_be32(pattern));
+#endif
 			memtest(t_start, t_size, pattern);
 
 			t_start += t_size;
-- 
1.6.1.2



