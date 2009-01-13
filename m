Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZAMKjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZAMKjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZAMKjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:51096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZAMKjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:00 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/13] x86_64: use static _cpu_pda array
Date: Tue, 13 Jan 2009 19:38:11 +0900
Message-Id: <1231843097-18003-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_cpu_pda array first uses statically allocated storage in data.init
and then switches to allocated bootmem to conserve space.  However,
after folding pda area into percpu area, _cpu_pda array will be
removed completely.  Drop the reallocation part to simplify the code
for soon-to-follow changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h     |    3 ++-
 arch/x86/kernel/cpu/common.c   |    2 +-
 arch/x86/kernel/head64.c       |   12 ------------
 arch/x86/kernel/setup_percpu.c |   14 +++-----------
 4 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index cbd3f48..2d5b49c 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/cache.h>
+#include <linux/threads.h>
 #include <asm/page.h>
 
 /* Per processor datastructure. %gs points to it while the kernel runs */
@@ -39,7 +40,7 @@ struct x8664_pda {
 	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
-extern struct x8664_pda **_cpu_pda;
+extern struct x8664_pda *_cpu_pda[NR_CPUS];
 extern void pda_init(int);
 
 #define cpu_pda(i) (_cpu_pda[i])
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 42e0853..5c3d6b3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -859,7 +859,7 @@ __setup("clearcpuid=", setup_disablecpuid);
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 #ifdef CONFIG_X86_64
-struct x8664_pda **_cpu_pda __read_mostly;
+struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 54f52cf..84b96b9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -29,20 +29,8 @@
 /* boot cpu pda, referenced by head_64.S to initialize %gs for boot CPU */
 struct x8664_pda _boot_cpu_pda __read_mostly;
 
-#ifdef CONFIG_SMP
-/*
- * We install an empty cpu_pda pointer table to indicate to early users
- * (numa_set_node) that the cpu_pda pointer table for cpus other than
- * the boot cpu is not yet setup.
- */
-static struct x8664_pda *__cpu_pda[NR_CPUS] __initdata;
-#else
-static struct x8664_pda *__cpu_pda[NR_CPUS] __read_mostly;
-#endif
-
 void __init x86_64_init_pda(void)
 {
-	_cpu_pda = __cpu_pda;
 	cpu_pda(0) = &_boot_cpu_pda;
 	cpu_pda(0)->data_offset =
 		(unsigned long)(__per_cpu_load - __per_cpu_start);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 8a22c94..bd47bbd 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -114,7 +114,6 @@ static inline void setup_cpu_pda_map(void) { }
 static void __init setup_cpu_pda_map(void)
 {
 	char *pda;
-	struct x8664_pda **new_cpu_pda;
 	unsigned long size;
 	int cpu;
 
@@ -122,28 +121,21 @@ static void __init setup_cpu_pda_map(void)
 
 	/* allocate cpu_pda array and pointer table */
 	{
-		unsigned long tsize = nr_cpu_ids * sizeof(void *);
 		unsigned long asize = size * (nr_cpu_ids - 1);
 
-		tsize = roundup(tsize, cache_line_size());
-		new_cpu_pda = alloc_bootmem(tsize + asize);
-		pda = (char *)new_cpu_pda + tsize;
+		pda = alloc_bootmem(asize);
 	}
 
 	/* initialize pointer table to static pda's */
 	for_each_possible_cpu(cpu) {
 		if (cpu == 0) {
 			/* leave boot cpu pda in place */
-			new_cpu_pda[0] = cpu_pda(0);
 			continue;
 		}
-		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
-		new_cpu_pda[cpu]->in_bootmem = 1;
+		cpu_pda(cpu) = (struct x8664_pda *)pda;
+		cpu_pda(cpu)->in_bootmem = 1;
 		pda += size;
 	}
-
-	/* point to new pointer table */
-	_cpu_pda = new_cpu_pda;
 }
 #endif
 
-- 
1.5.6

