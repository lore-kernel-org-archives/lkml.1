Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZKBQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZKBQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZKBQRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:53616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721AbZKBQRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:11 -0500
Date: Mon, 2 Nov 2009 16:16:25 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200911022037.21282.rusty@rustcorp.com.au>
References: <200911022037.21282.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix boot crash by zalloc()ing most of the cpu masks
Message-ID: <tip-49557e620339cb134127b5bfbcfecc06b77d0232@git.kernel.org>
Git-Commit-ID: 49557e620339cb134127b5bfbcfecc06b77d0232
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49557e620339cb134127b5bfbcfecc06b77d0232
Gitweb:     http://git.kernel.org/tip/49557e620339cb134127b5bfbcfecc06b77d0232
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Mon, 2 Nov 2009 20:37:20 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:48:54 +0100

sched: Fix boot crash by zalloc()ing most of the cpu masks

I got a boot crash when forcing cpumasks offstack on 32 bit,
because find_new_ilb() returned 3 on my UP system (nohz.cpu_mask
wasn't zeroed).

AFAICT the others need to be zeroed too: only
nohz.ilb_grp_nohz_mask is initialized before use.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <200911022037.21282.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cae6700..bf21adb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9535,13 +9535,13 @@ void __init sched_init(void)
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
