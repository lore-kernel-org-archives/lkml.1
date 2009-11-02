Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZKBKIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZKBKIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZKBKIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:08:20 -0500
Received: from ozlabs.org ([203.10.76.45]:42344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZKBKHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: zalloc most of the cpu masks
Date: Mon, 2 Nov 2009 20:37:20 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911022037.21282.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a boot crash when forcing cpumasks offstack on 32 bit, because
find_new_ilb() returned 3 on my UP system (nohz.cpu_mask wasn't zeroed).

AFAICT the others need to be zeroed too: only nohz.ilb_grp_nohz_mask is
initialized before use.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9532,13 +9541,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();
