Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYDEBMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYDEBMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYDEBLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57914 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751715AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011101.222880000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:02 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] cpumask: add CPU_MASK_ALL_PTR macro
Content-Disposition: inline; filename=add-CPUMASK_ALL_PTR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add a static cpumask_t variable "CPU_MASK_ALL_PTR" to use as
    a pointer reference to CPU_MASK_ALL.  This reduces where possible
    the instances where CPU_MASK_ALL allocates and fills a large
    array on the stack.  Used only if NR_CPUS > BITS_PER_LONG.

  * Change init/main.c to use new set_cpus_allowed_ptr().

Depends on:
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# x86
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    6 ++++++
 init/main.c             |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- linux-2.6.x86.orig/include/linux/cpumask.h
+++ linux-2.6.x86/include/linux/cpumask.h
@@ -249,6 +249,8 @@ extern cpumask_t *cpumask_of_cpu_map;
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
+#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
+
 #else
 
 #define CPU_MASK_ALL							\
@@ -257,6 +259,10 @@ extern cpumask_t *cpumask_of_cpu_map;
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
+/* cpu_mask_all is in init/main.c */
+extern cpumask_t cpu_mask_all;
+#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
+
 #endif
 
 #define CPU_MASK_NONE							\
--- linux-2.6.x86.orig/init/main.c
+++ linux-2.6.x86/init/main.c
@@ -366,6 +366,11 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
+#if NR_CPUS > BITS_PER_LONG
+cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_mask_all);
+#endif
+
 /* Setup number of possible processor ids */
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
@@ -837,7 +842,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.

-- 
