Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZLBKq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZLBKq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZLBKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:46:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:45052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZLBKqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:46:23 -0500
Date: Wed, 2 Dec 2009 10:45:22 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200912021409.17013.rusty@rustcorp.com.au>
References: <200912021409.17013.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix isolcpus boot option
Message-ID: <tip-bdddd2963c0264c56f18043f6fa829d3c1d3d1c0@git.kernel.org>
Git-Commit-ID: bdddd2963c0264c56f18043f6fa829d3c1d3d1c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdddd2963c0264c56f18043f6fa829d3c1d3d1c0
Gitweb:     http://git.kernel.org/tip/bdddd2963c0264c56f18043f6fa829d3c1d3d1c0
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 2 Dec 2009 14:09:16 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:27:16 +0100

sched: Fix isolcpus boot option

Anton Blanchard wrote:

> We allocate and zero cpu_isolated_map after the isolcpus
> __setup option has run. This means cpu_isolated_map always
> ends up empty and if CPUMASK_OFFSTACK is enabled we write to a
> cpumask that hasn't been allocated.

I introduced this regression in 49557e620339cb13 (sched: Fix
boot crash by zalloc()ing most of the cpu masks).

Use the bootmem allocator if they set isolcpus=, otherwise
allocate and zero like normal.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
LKML-Reference: <200912021409.17013.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Anton Blanchard <anton@samba.org>
---
 kernel/sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1031cae..4883fee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8061,6 +8061,7 @@ static cpumask_var_t cpu_isolated_map;
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	cpulist_parse(str, cpu_isolated_map);
 	return 1;
 }
@@ -9609,7 +9610,9 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	/* May be allocated at isolcpus cmdline parse time */
+	if (cpu_isolated_map == NULL)
+		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();
