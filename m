Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZFYToC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZFYToC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbZFYTnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:43:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:45304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759544AbZFYTnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:43:31 -0400
Date: Thu, 25 Jun 2009 19:43:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Add mmap counter read support
Message-ID: <tip-194002b274e9169a04beb1b23dcc132159bb566c@git.kernel.org>
Git-Commit-ID: 194002b274e9169a04beb1b23dcc132159bb566c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:43:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  194002b274e9169a04beb1b23dcc132159bb566c
Gitweb:     http://git.kernel.org/tip/194002b274e9169a04beb1b23dcc132159bb566c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Jun 2009 16:35:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:06 +0200

perf_counter, x86: Add mmap counter read support

Update the mmap control page with the needed information to
use the userspace RDPMC instruction for self monitoring.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/perf_counter.h |    2 ++
 arch/x86/include/asm/perf_counter.h     |    3 +++
 arch/x86/kernel/cpu/perf_counter.c      |    6 ++++++
 kernel/perf_counter.c                   |   10 +++++++++-
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 8ccd4e1..0ea0639 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -61,6 +61,8 @@ struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
+#define PERF_COUNTER_INDEX_OFFSET	1
+
 /*
  * Only override the default definitions in include/linux/perf_counter.h
  * if we have hardware PMU support.
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 5fb33e1..fa64e40 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -87,6 +87,9 @@ union cpuid10_edx {
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
+
+#define PERF_COUNTER_INDEX_OFFSET			0
+
 #else
 static inline void init_hw_perf_counters(void)		{ }
 static inline void perf_counters_lapic_init(void)	{ }
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a310d19..b83474b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -912,6 +912,8 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	err = checking_wrmsrl(hwc->counter_base + idx,
 			     (u64)(-left) & x86_pmu.counter_mask);
 
+	perf_counter_update_userpage(counter);
+
 	return ret;
 }
 
@@ -1034,6 +1036,8 @@ try_generic:
 	x86_perf_counter_set_period(counter, hwc, idx);
 	x86_pmu.enable(hwc, idx);
 
+	perf_counter_update_userpage(counter);
+
 	return 0;
 }
 
@@ -1126,6 +1130,8 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	x86_perf_counter_update(counter, hwc, idx);
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
+
+	perf_counter_update_userpage(counter);
 }
 
 /*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 23614ad..02994a7 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1753,6 +1753,14 @@ int perf_counter_task_disable(void)
 	return 0;
 }
 
+static int perf_counter_index(struct perf_counter *counter)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return 0;
+
+	return counter->hw.idx + 1 - PERF_COUNTER_INDEX_OFFSET;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -1777,7 +1785,7 @@ void perf_counter_update_userpage(struct perf_counter *counter)
 	preempt_disable();
 	++userpg->lock;
 	barrier();
-	userpg->index = counter->hw.idx;
+	userpg->index = perf_counter_index(counter);
 	userpg->offset = atomic64_read(&counter->count);
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
