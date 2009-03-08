Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZCHPxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZCHPxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCHPwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:52:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbZCHPww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:52:52 -0400
Date: Sun, 8 Mar 2009 15:52:06 GMT
From: Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, jaswinder@kernel.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236508459.22914.3645.camel@twins>
References: <1236508459.22914.3645.camel@twins>
Subject: [tip:perfcounters/core] x86: perf_counter cleanup
Message-ID: <tip-184fe4ab1f2e4dfa45584889bb3820031648386b@git.kernel.org>
Git-Commit-ID: 184fe4ab1f2e4dfa45584889bb3820031648386b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:52:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  184fe4ab1f2e4dfa45584889bb3820031648386b
Gitweb:     http://git.kernel.org/tip/184fe4ab1f2e4dfa45584889bb3820031648386b
Author:     "Peter Zijlstra" <peterz@infradead.org>
AuthorDate: Sun, 8 Mar 2009 11:34:19 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 16:24:49 +0100

x86: perf_counter cleanup

Use and actual unsigned long bitmap instead of casting our way around.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
LKML-Reference: <1236508459.22914.3645.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f585371..1df4210 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -37,7 +37,7 @@ struct cpu_hw_counters {
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	u64			throttle_ctrl;
-	u64			active_mask;
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 };
 
@@ -291,7 +291,7 @@ static void pmc_amd_restore_all(u64 ctrl)
 		return;
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		if (test_bit(idx, (unsigned long *)&cpuc->active_mask)) {
+		if (test_bit(idx, cpuc->active_mask)) {
 			u64 val;
 
 			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
@@ -377,7 +377,7 @@ static void pmc_amd_enable(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	set_bit(idx, (unsigned long *)&cpuc->active_mask);
+	set_bit(idx, cpuc->active_mask);
 	if (cpuc->enabled)
 		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
@@ -401,7 +401,7 @@ static void pmc_amd_disable(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	clear_bit(idx, (unsigned long *)&cpuc->active_mask);
+	clear_bit(idx, cpuc->active_mask);
 	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
 
 }
