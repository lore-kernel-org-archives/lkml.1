Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZLBDjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZLBDjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZLBDjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:39:14 -0500
Received: from ozlabs.org ([203.10.76.45]:44054 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZLBDjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:39:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anton Blanchard <anton@samba.org>
Subject: [PATCH] sched: Fix isolcpus boot option
Date: Wed, 2 Dec 2009 14:09:16 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
References: <20091130000532.GW32182@kryten>
In-Reply-To: <20091130000532.GW32182@kryten>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912021409.17013.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 10:35:32 am Anton Blanchard wrote:
> We allocate and zero cpu_isolated_map after the isolcpus __setup option
> has run. This means cpu_isolated_map always ends up empty and if
> CPUMASK_OFFSTACK is enabled we write to a cpumask that hasn't been
> allocated.

I introduced this regression in 49557e620339cb13 (sched: Fix boot
crash by zalloc()ing most of the cpu masks).

Use the bootmem allocator if they set isolcpus=, otherwise allocate
and zero like normal.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Anton Blanchard <anton@samba.org>
Cc: stable@kernel.org

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8045,6 +8045,7 @@ static cpumask_var_t cpu_isolated_map;
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	cpulist_parse(str, cpu_isolated_map);
 	return 1;
 }
@@ -9571,7 +9572,9 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	/* May be allocated at isolcpus cmdline parse time */
+	if (cpu_isolated_map == NULL)
+		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();
