Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZIUHeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZIUHeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZIUHeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:34:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:37468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZIUHeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:34:18 -0400
Date: Mon, 21 Sep 2009 07:33:40 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, sachinp@in.ibm.com,
       davem@davemloft.net, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       sachinp@in.ibm.com, davem@davemloft.net, markus.t.metzger@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter, powerpc, sparc: Fix compilation after perf_counter_overflow() change
Message-ID: <tip-cd74c86bdf705f824d494a2bbda393d1d562b40a@git.kernel.org>
Git-Commit-ID: cd74c86bdf705f824d494a2bbda393d1d562b40a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 07:33:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd74c86bdf705f824d494a2bbda393d1d562b40a
Gitweb:     http://git.kernel.org/tip/cd74c86bdf705f824d494a2bbda393d1d562b40a
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 21 Sep 2009 16:44:32 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 09:28:40 +0200

perf_counter, powerpc, sparc: Fix compilation after perf_counter_overflow() change

Commit 5622f295 ("x86, perf_counter, bts: Optimize BTS overflow
handling") removed the regs field from struct perf_sample_data and
added a regs parameter to perf_counter_overflow().  This breaks the
build on powerpc (and Sparc) as reported by Sachin Sant:

  arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
  arch/powerpc/kernel/perf_counter.c:1165: error: unknown field 'regs' specified in initializer

This adjusts arch/powerpc/kernel/perf_counter.c to correspond with the
new struct perf_sample_data and perf_counter_overflow().

[ v2: also fix Sparc, Markus Metzger <markus.t.metzger@intel.com> ]

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    3 +--
 arch/sparc/kernel/perf_counter.c   |    3 +--
 include/linux/perf_counter.h       |   17 -----------------
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 7ceefaf..5ccf9bc 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1162,7 +1162,6 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 	 */
 	if (record) {
 		struct perf_sample_data data = {
-			.regs	= regs,
 			.addr	= 0,
 			.period	= counter->hw.last_period,
 		};
@@ -1170,7 +1169,7 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_counter_overflow(counter, nmi, &data)) {
+		if (perf_counter_overflow(counter, nmi, &data, regs)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
 			 * by setting the counter to 0, so it will be
diff --git a/arch/sparc/kernel/perf_counter.c b/arch/sparc/kernel/perf_counter.c
index 09de403..b1265ce 100644
--- a/arch/sparc/kernel/perf_counter.c
+++ b/arch/sparc/kernel/perf_counter.c
@@ -493,7 +493,6 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -513,7 +512,7 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 		if (!sparc_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			sparc_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index bd34100..740caad 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -849,23 +849,6 @@ static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
 
-static inline int
-perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
-		  unsigned int size, int nmi, int sample)		{ }
-static inline void perf_output_end(struct perf_output_handle *handle)	{ }
-static inline void
-perf_output_copy(struct perf_output_handle *handle,
-		 const void *buf, unsigned int len)			{ }
-static inline void
-perf_output_sample(struct perf_output_handle *handle,
-		   struct perf_event_header *header,
-		   struct perf_sample_data *data,
-		   struct perf_counter *counter)			{ }
-static inline void
-perf_prepare_sample(struct perf_event_header *header,
-		    struct perf_sample_data *data,
-		    struct perf_counter *counter,
-		    struct pt_regs *regs)				{ }
 #endif
 
 #define perf_output_put(handle, x) \
