Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXHNI3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXHNI3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbXHNI24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:28:56 -0400
Received: from mailhost.igel.co.jp ([219.106.231.130]:45742 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbXHNI2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:28:54 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 04:28:53 EDT
Date: Tue, 14 Aug 2007 17:08:16 +0900 (JST)
Message-Id: <20070814.170816.143307233.matsu@igel.co.jp>
To: lethal@linux-sh.org
Cc: linuxsh-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] sh: replace mutexes which are used in SH-4 user page
 copy/clear functions in 2.6.22.X
From: Katsuya MATSUBARA <matsu@igel.co.jp>
X-Mailer: Mew version 5.2.50 on Emacs 21.3.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


sh: replace mutexes which are used in SH-4 user page copy/clear
functions in 2.6.22.X

This patch replaces mutexes in copy_user_pages() and clear_user_pages() 
for SH-4 in 2.6.22.X. A 2.6.22.X kernel with CONFIG_PREEMPT_VOLUNTARY=y
shows the following error because mutexes are sleepable.

BUG: scheduling while atomic: rc/0x10000002/866
Stack: (0x8fcdfdf8 to 0x8fce0000)
fde0:                                                       8c214574 10000000
fe00: 8c01e8da 00499fc0 00000200 0000c000 8f95e000 8ff41000 00499fc0 8c01e8da
fe20: 8fcdfe3c 00499fc0 0f95e53e 8f95e000 8c213f20 10000000 8fcde000 8c214898
fe40: 8fcdfe50 c0001000 8c359820 8c2c1584 8c2155aa 8ff41000 8c01c8e0 8c2d8004
fe60: 8c059100 8ff2af98 00499fc0 8ff2af98 80000000 8c34dbc0 8c359820 8fcde000
fe80: 8c2b76c0 8c05aa12 8ff2af98 8fdbe004 00000264 00499fc0 8c2c9e2c 8f929264
fea0: 0ff4155c 8fdbe004 8c2b7700 0ff4155c 00000011 00000001 8c2b76c0 000000f0
fec0: 00000000 00000000 8fd31c38 00000002 295dd000 00000000 00000002 8c01bac0
fee0: 00000001 8c2b76f4 8fcdffa0 8c3a50a0 8c2b76c0 00499fc0 8ff2af98 8fcde000
ff00: 0f8a955c 8c017024 8c0170e8 0049cf14 00000000 0000000c fffffff2 00000000
ff20: 8fcdff88 8fcdff80 0049cf14 00000008 00000008 00000000 00000002 00000001
ff40: ffffff0f 295f6488 00412994 7be43748 8fcdff74 8c01c04c 8c02fc20 40008100
ff60: 00000000 00000000 c8bab6cd ffffffff 8c02ce96 00000000 8c02fc3c 00000000
ff80: 8c0170e8 7be43758 00412994 00000000 ffffff0f 40008100 00499fc0 00000001
ffa0: 00000000 000002bb 00499fc0 00000000 00000002 0049cf14 00000000 00000008
ffc0: 00000362 00000000 00493558 00413970 00000000 00412994 7be43758 7be43758
ffe0: 0042c7d0 0042c73c 00008101 00000000 00000000 c8bab6cd ffffffff 000000c0

Call trace:
[<8c213f20>] schedule+0x0/0x8c0
[<8c01e8da>] __cond_resched+0x1a/0x40
[<8c01e8da>] __cond_resched+0x1a/0x40
[<8c213f20>] schedule+0x0/0x8c0
[<8c214898>] cond_resched+0x38/0x60
[<8c2155aa>] mutex_lock+0xa/0x80
[<8c01c8e0>] copy_user_page+0x80/0x160
[<8c059100>] do_wp_page+0x120/0x5c0
[<8c2b76c0>] sci_init+0x40/0x80
[<8c05aa12>] __handle_mm_fault+0x632/0xa00
[<8c2b7700>] devices_init+0x0/0x20
[<8c2b76c0>] sci_init+0x40/0x80
[<8c01bac0>] do_page_fault+0x80/0x380
[<8c2b76f4>] sci_init+0x74/0x80
[<8c2b76c0>] sci_init+0x40/0x80
[<8c017024>] call_dpf+0x10/0x3c
[<8c0170e8>] ret_from_exception+0x0/0x14
[<8c01c04c>] __copy_user+0x120/0x134
[<8c02fc20>] sys_rt_sigprocmask+0xe0/0x120
[<8c02ce96>] sigprocmask+0xb6/0x140
[<8c02fc3c>] sys_rt_sigprocmask+0xfc/0x120
[<8c0170e8>] ret_from_exception+0x0/0x14


Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 arch/sh/mm/cache-sh4.c |    9 ---------
 arch/sh/mm/pg-sh4.c    |   11 ++++++-----
 2 files changed, 6 insertions(+), 14 deletions(-)
   
diff -uprN linux-2.6.22.2/arch/sh/mm/cache-sh4.c linux-2.6.22.2-nomutex_in_mm/arch/sh/mm/cache-sh4.c
--- linux-2.6.22.2/arch/sh/mm/cache-sh4.c	2007-08-10 06:28:15.000000000 +0900
+++ linux-2.6.22.2-nomutex_in_mm/arch/sh/mm/cache-sh4.c	2007-08-14 15:47:47.000000000 +0900
@@ -77,12 +77,6 @@ static void __init emit_cache_params(voi
 /*
  * SH-4 has virtually indexed and physically tagged cache.
  */
-
-/* Worst case assumed to be 64k cache, direct-mapped i.e. 4 synonym bits. */
-#define MAX_P3_MUTEXES 16
-
-struct mutex p3map_mutex[MAX_P3_MUTEXES];
-
 void __init p3_cache_init(void)
 {
 	int i;
@@ -109,9 +103,6 @@ void __init p3_cache_init(void)
 
 	if (ioremap_page_range(P3SEG, P3SEG + (PAGE_SIZE * 4), 0, PAGE_KERNEL))
 		panic("%s failed.", __FUNCTION__);
-
-	for (i = 0; i < current_cpu_data.dcache.n_aliases; i++)
-		mutex_init(&p3map_mutex[i]);
 }
 
 /*
diff -uprN linux-2.6.22.2/arch/sh/mm/pg-sh4.c linux-2.6.22.2-nomutex_in_mm/arch/sh/mm/pg-sh4.c
--- linux-2.6.22.2/arch/sh/mm/pg-sh4.c	2007-08-10 06:28:15.000000000 +0900
+++ linux-2.6.22.2-nomutex_in_mm/arch/sh/mm/pg-sh4.c	2007-08-14 15:49:25.000000000 +0900
@@ -7,7 +7,6 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 #include <linux/mm.h>
-#include <linux/mutex.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
@@ -37,7 +36,7 @@ void clear_user_page(void *to, unsigned 
 		unsigned long flags;
 
 		entry = pfn_pte(phys_addr >> PAGE_SHIFT, PAGE_KERNEL);
-		mutex_lock(&p3map_mutex[(address & CACHE_ALIAS)>>12]);
+		inc_preempt_count();
 		set_pte(pte, entry);
 		local_irq_save(flags);
 		flush_tlb_one(get_asid(), p3_addr);
@@ -45,7 +44,8 @@ void clear_user_page(void *to, unsigned 
 		update_mmu_cache(NULL, p3_addr, entry);
 		__clear_user_page((void *)p3_addr, to);
 		pte_clear(&init_mm, p3_addr, pte);
-		mutex_unlock(&p3map_mutex[(address & CACHE_ALIAS)>>12]);
+		dec_preempt_count();
+		preempt_check_resched();
 	}
 }
 
@@ -73,7 +73,7 @@ void copy_user_page(void *to, void *from
 		unsigned long flags;
 
 		entry = pfn_pte(phys_addr >> PAGE_SHIFT, PAGE_KERNEL);
-		mutex_lock(&p3map_mutex[(address & CACHE_ALIAS)>>12]);
+		inc_preempt_count();
 		set_pte(pte, entry);
 		local_irq_save(flags);
 		flush_tlb_one(get_asid(), p3_addr);
@@ -81,7 +81,8 @@ void copy_user_page(void *to, void *from
 		update_mmu_cache(NULL, p3_addr, entry);
 		__copy_user_page((void *)p3_addr, from, to);
 		pte_clear(&init_mm, p3_addr, pte);
-		mutex_unlock(&p3map_mutex[(address & CACHE_ALIAS)>>12]);
+		dec_preempt_count();
+		preempt_check_resched();
 	}
 }
 
