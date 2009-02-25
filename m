Return-Path: <linux-kernel-owner+w=401wt.eu-S1762369AbZBYKa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762369AbZBYKa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbZBYKau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:30:50 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4643 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653AbZBYKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:30:48 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KFMAIW-01-2MI-01
Date: Wed, 25 Feb 2009 11:30:04 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] x86: memtest: wipe out test pattern from memory
Message-ID: <20090225103004.GU6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:30:31.0605 (UTC) FILETIME=[15C44E50:01C99734]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   56 ++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 3232397..9c52ef1 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -57,6 +57,29 @@ static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 		reserve_bad_mem(pattern, start_bad, last_bad + incr);
 }
 
+static void __init do_one_pass(u64 pattern, u64 start, u64 end)
+{
+	u64 size = 0;
+
+	while (start < end) {
+		start = find_e820_area_size(start, &size, 1);
+
+		/* done ? */
+		if (start >= end)
+			break;
+		if (start + size > end)
+			size = end - start;
+
+		printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+		       (unsigned long long) start,
+		       (unsigned long long) start + size,
+		       (unsigned long long) cpu_to_be64(pattern));
+		memtest(pattern, start, size);
+
+		start += size;
+	}
+}
+
 /* default is disabled */
 static int memtest_pattern __initdata;
 
@@ -71,35 +94,22 @@ early_param("memtest", parse_memtest);
 
 void __init early_memtest(unsigned long start, unsigned long end)
 {
-	u64 t_start, t_size;
 	unsigned int i;
-	u64 pattern;
+	unsigned int idx = 0;
 
 	if (!memtest_pattern)
 		return;
 
 	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
 	for (i = 0; i < memtest_pattern; i++) {
-		unsigned int idx = i % ARRAY_SIZE(patterns);
-		pattern = patterns[idx];
-		t_start = start;
-		t_size = 0;
-		while (t_start < end) {
-			t_start = find_e820_area_size(t_start, &t_size, 1);
-
-			/* done ? */
-			if (t_start >= end)
-				break;
-			if (t_start + t_size > end)
-				t_size = end - t_start;
-
-			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
-			       (unsigned long long) t_start,
-			       (unsigned long long) t_start + t_size,
-			       (unsigned long long) cpu_to_be64(pattern));
-			memtest(pattern, t_start, t_size);
-
-			t_start += t_size;
-		}
+		idx = i % ARRAY_SIZE(patterns);
+		do_one_pass(patterns[idx], start, end);
+	}
+
+	if (idx > 0) {
+		printk(KERN_INFO "early_memtest: wipe out "
+		       "test pattern from memory\n");
+		/* additional test with pattern 0 will do this */
+		do_one_pass(0, start, end);
 	}
 }
-- 
1.6.1.3



