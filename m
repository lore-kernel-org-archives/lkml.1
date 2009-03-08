Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZCHKfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZCHKfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZCHKfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:35:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZCHKe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:34:59 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236507232.28127.2.camel@localhost.localdomain>
References: <1236507232.28127.2.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Mar 2009 11:34:19 +0100
Message-Id: <1236508459.22914.3645.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


An actual cleanup would be:

---
Subject: perf_counters: cleanup amd64 code a little
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Mar 05 21:18:49 CET 2009

Use and actual unsigned long bitmap instead of casting our way around.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -37,7 +37,7 @@ struct cpu_hw_counters {
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	u64			throttle_ctrl;
-	u64			active_mask;
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 };
 
@@ -291,7 +291,7 @@ static void pmc_amd_restore_all(u64 ctrl
 		return;
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		if (test_bit(idx, (unsigned long *)&cpuc->active_mask)) {
+		if (test_bit(idx, cpuc->active_mask)) {
 			u64 val;
 
 			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
@@ -377,7 +377,7 @@ static void pmc_amd_enable(int idx, u64 
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	set_bit(idx, (unsigned long *)&cpuc->active_mask);
+	set_bit(idx, cpuc->active_mask);
 	if (cpuc->enabled)
 		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
@@ -401,7 +401,7 @@ static void pmc_amd_disable(int idx, u64
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	clear_bit(idx, (unsigned long *)&cpuc->active_mask);
+	clear_bit(idx, cpuc->active_mask);
 	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
 
 }

