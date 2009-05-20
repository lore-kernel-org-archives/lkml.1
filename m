Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZETSQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZETSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZETSQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:16:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZETSQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:16:19 -0400
Date: Wed, 20 May 2009 18:15:46 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix context removal deadlock
Message-ID: <tip-34adc8062227f41b04ade0ff3fbd1dbe3002669e@git.kernel.org>
Git-Commit-ID: 34adc8062227f41b04ade0ff3fbd1dbe3002669e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 18:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34adc8062227f41b04ade0ff3fbd1dbe3002669e
Gitweb:     http://git.kernel.org/tip/34adc8062227f41b04ade0ff3fbd1dbe3002669e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 20 May 2009 20:13:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 May 2009 20:12:54 +0200

perf_counter: Fix context removal deadlock

Disable the PMU globally before removing a counter from a
context. This fixes the following lockup:

[22081.741922] ------------[ cut here ]------------
[22081.746668] WARNING: at arch/x86/kernel/cpu/perf_counter.c:803 intel_pmu_handle_irq+0x9b/0x24e()
[22081.755624] Hardware name: X8DTN
[22081.758903] perfcounters: irq loop stuck!
[22081.762985] Modules linked in:
[22081.766136] Pid: 11082, comm: perf Not tainted 2.6.30-rc6-tip #226
[22081.772432] Call Trace:
[22081.774940]  <NMI>  [<ffffffff81019aed>] ? intel_pmu_handle_irq+0x9b/0x24e
[22081.781993]  [<ffffffff81019aed>] ? intel_pmu_handle_irq+0x9b/0x24e
[22081.788368]  [<ffffffff8104505c>] ? warn_slowpath_common+0x77/0xa3
[22081.794649]  [<ffffffff810450d3>] ? warn_slowpath_fmt+0x40/0x45
[22081.800696]  [<ffffffff81019aed>] ? intel_pmu_handle_irq+0x9b/0x24e
[22081.807080]  [<ffffffff814d1a72>] ? perf_counter_nmi_handler+0x3f/0x4a
[22081.813751]  [<ffffffff814d2d09>] ? notifier_call_chain+0x58/0x86
[22081.819951]  [<ffffffff8105b250>] ? notify_die+0x2d/0x32
[22081.825392]  [<ffffffff814d1414>] ? do_nmi+0x8e/0x242
[22081.830538]  [<ffffffff814d0f0a>] ? nmi+0x1a/0x20
[22081.835342]  [<ffffffff8117e102>] ? selinux_file_free_security+0x0/0x1a
[22081.842105]  [<ffffffff81018793>] ? x86_pmu_disable_counter+0x15/0x41
[22081.848673]  <<EOE>>  [<ffffffff81018f3d>] ? x86_pmu_disable+0x86/0x103
[22081.855512]  [<ffffffff8108fedd>] ? __perf_counter_remove_from_context+0x0/0xfe
[22081.862926]  [<ffffffff8108fcbc>] ? counter_sched_out+0x30/0xce
[22081.868909]  [<ffffffff8108ff36>] ? __perf_counter_remove_from_context+0x59/0xfe
[22081.876382]  [<ffffffff8106808a>] ? smp_call_function_single+0x6c/0xe6
[22081.882955]  [<ffffffff81091b96>] ? perf_release+0x86/0x14c
[22081.888600]  [<ffffffff810c4c84>] ? __fput+0xe7/0x195
[22081.893718]  [<ffffffff810c213e>] ? filp_close+0x5b/0x62
[22081.899107]  [<ffffffff81046a70>] ? put_files_struct+0x64/0xc2
[22081.905031]  [<ffffffff8104841a>] ? do_exit+0x1e2/0x6ef
[22081.910360]  [<ffffffff814d0a60>] ? _spin_lock_irqsave+0x9/0xe
[22081.916292]  [<ffffffff8104898e>] ? do_group_exit+0x67/0x93
[22081.921953]  [<ffffffff810489cc>] ? sys_exit_group+0x12/0x16
[22081.927759]  [<ffffffff8100baab>] ? system_call_fastpath+0x16/0x1b
[22081.934076] ---[ end trace 3a3936ce3e1b4505 ]---

And could potentially also fix the lockup reported by Marcelo Tosatti.

Also, print more debug info in case of a detected lockup.

[ Impact: fix lockup ]

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    1 +
 kernel/perf_counter.c              |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index c109819..6cc1660 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -740,6 +740,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 again:
 	if (++loops > 100) {
 		WARN_ONCE(1, "perfcounters: irq loop stuck!\n");
+		perf_counter_print_debug();
 		return 1;
 	}
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 69d4de8..08584c1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -208,18 +208,17 @@ static void __perf_counter_remove_from_context(void *info)
 		return;
 
 	spin_lock_irqsave(&ctx->lock, flags);
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level.
+	 */
+	perf_disable();
 
 	counter_sched_out(counter, cpuctx, ctx);
 
 	counter->task = NULL;
 
-	/*
-	 * Protect the list operation against NMI by disabling the
-	 * counters on a global level. NOP for non NMI based counters.
-	 */
-	perf_disable();
 	list_del_counter(counter, ctx);
-	perf_enable();
 
 	if (!ctx->task) {
 		/*
@@ -231,6 +230,7 @@ static void __perf_counter_remove_from_context(void *info)
 			    perf_max_counters - perf_reserved_percpu);
 	}
 
+	perf_enable();
 	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
