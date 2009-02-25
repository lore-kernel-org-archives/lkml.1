Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbZBYK3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbZBYK3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762491AbZBYK3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:29:38 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:30700 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762482AbZBYK3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:29:37 -0500
X-BigFish: VPS1(zzzzzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KFMAH1-02-5K0-01
Date: Wed, 25 Feb 2009 11:28:58 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] x86: memtest: adapt log messages
Message-ID: <20090225102858.GT6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:29:26.0273 (UTC) FILETIME=[EED36F10:01C99733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* print test pattern instead of pattern number,
* show pattern as stored in memory,
* use proper priority flags,
* consistent use of u64 throughout the code

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 01a72d6..3232397 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -16,25 +16,22 @@ static u64 patterns[] __initdata = {
 	0xaaaaaaaaaaaaaaaaULL,
 };
 
-static void __init reserve_bad_mem(u64 pattern, unsigned long start_bad,
-			    unsigned long end_bad)
+static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 {
-	printk(KERN_CONT "\n  %016llx bad mem addr "
-	       "%010lx - %010lx reserved",
-	       (unsigned long long) pattern, start_bad, end_bad);
+	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
+	       (unsigned long long) pattern,
+	       (unsigned long long) start_bad,
+	       (unsigned long long) end_bad);
 	reserve_early(start_bad, end_bad, "BAD RAM");
 }
 
-static void __init memtest(unsigned long start_phys, unsigned long size,
-			   u64 pattern)
+static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 {
-	unsigned long i;
+	u64 i, count;
 	u64 *start;
-	unsigned long start_bad;
-	unsigned long last_bad;
-	unsigned long start_phys_aligned;
-	unsigned long count;
-	unsigned long incr;
+	u64 start_bad, last_bad;
+	u64 start_phys_aligned;
+	size_t incr;
 
 	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
@@ -81,7 +78,7 @@ void __init early_memtest(unsigned long start, unsigned long end)
 	if (!memtest_pattern)
 		return;
 
-	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
+	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
 	for (i = 0; i < memtest_pattern; i++) {
 		unsigned int idx = i % ARRAY_SIZE(patterns);
 		pattern = patterns[idx];
@@ -96,14 +93,13 @@ void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
-			       (unsigned long long)t_start,
-			       (unsigned long long)t_start + t_size, idx);
-
-			memtest(t_start, t_size, pattern);
+			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+			       (unsigned long long) t_start,
+			       (unsigned long long) t_start + t_size,
+			       (unsigned long long) cpu_to_be64(pattern));
+			memtest(pattern, t_start, t_size);
 
 			t_start += t_size;
 		}
 	}
-	printk(KERN_CONT "\n");
 }
-- 
1.6.1.3



