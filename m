Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbZFEHD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbZFEHD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFEHDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:03:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbZFEHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:03:21 -0400
Date: Fri, 5 Jun 2009 00:03:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       andreas.herrmann3@amd.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-Id: <20090605000310.a5b8fa56.akpm@linux-foundation.org>
In-Reply-To: <200906050651.n556p7Vo094549@www262.sakura.ne.jp>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
	<20090605023835.GA7933@cr0.nay.redhat.com>
	<20090604201733.746928c6.akpm@linux-foundation.org>
	<200906050339.n553d684048041@www262.sakura.ne.jp>
	<20090604205103.bbfe9af2.akpm@linux-foundation.org>
	<200906050400.n5540Sx0052981@www262.sakura.ne.jp>
	<20090604212018.b9e9f354.akpm@linux-foundation.org>
	<200906050651.n556p7Vo094549@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 15:51:07 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> >but I wonder why all those things are u64.  They all hold virtual
> >addresses, don't they?  The code doesn't test highmem.  So shouldn't
> >these all be unsigned longs?
> memtest() in linux-2.6.29.4/arch/x86/mm/memtest.c is using "unsigned long".
> 2.6.30 changed to use "u64" by some reason.

No reason, really.  "consistency".  It made the code slower, larger
and, err, not compile.

And it was done as four patches in one, making reversion impossible.
Ho hum.



commit 570c9e69aaa84689fb8ed2a3a4af39ca54ba7a47
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Wed Feb 25 11:28:58 2009 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed Feb 25 12:19:46 2009 +0100

    x86: memtest: adapt log messages
    
    - print test pattern instead of pattern number,
    - show pattern as stored in memory,
    - use proper priority flags,
    - consistent use of u64 throughout the code
    
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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

