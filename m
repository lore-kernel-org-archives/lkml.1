Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbZHSJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbZHSJXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZHSJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:23:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:60902 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZHSJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:23:00 -0400
Message-Id: <20090819092023.728070630@chello.nl>
References: <20090819091823.916851355@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 19 Aug 2009 11:18:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf_counter: Default to higher paranoia level
Content-Disposition: inline; filename=perf-sekure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the default permissions on perf counters.

The new default will disallow regular users to create cpu-wide
counters, and will anonymize kernel IPs for task samples.

This will allow a user to profile his own applications and still know
the proportion of the kernel events, but does not expose kernel IPs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    6 ++++++
 include/linux/perf_counter.h       |    1 +
 kernel/perf_counter.c              |   27 ++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -2153,7 +2153,13 @@ static const struct stacktrace_ops backt
 static void
 perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
+	u64 anon_ip = perf_paranoid_anon_ip();
+
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	if (anon_ip) {
+		callchain_store(entry, anon_ip);
+		return;
+	}
 	callchain_store(entry, regs->ip);
 
 	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -754,6 +754,7 @@ static inline void perf_counter_mmap(str
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
+extern unsigned long perf_paranoid_anon_ip(void);
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -48,18 +48,29 @@ static atomic_t nr_task_counters __read_
  * perf counter paranoia level:
  *  0 - not paranoid
  *  1 - disallow cpu counters to unpriv
- *  2 - disallow kernel profiling to unpriv
+ *  2 - anonymize kernel RIPs to unpriv
+ *  3 - disallow kernel profiling to unpriv
  */
-int sysctl_perf_counter_paranoid __read_mostly;
+int sysctl_perf_counter_paranoid __read_mostly = 2;
 
 static inline bool perf_paranoid_cpu(void)
 {
-	return sysctl_perf_counter_paranoid > 0;
+	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 0;
+}
+
+static inline bool perf_paranoid_anon(void)
+{
+	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
 }
 
 static inline bool perf_paranoid_kernel(void)
 {
-	return sysctl_perf_counter_paranoid > 1;
+	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 2;
+}
+
+unsigned long perf_paranoid_anon_ip(void)
+{
+	return perf_paranoid_anon() ? _THIS_IP_ : 0;
 }
 
 int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
@@ -1571,7 +1582,7 @@ static struct perf_counter_context *find
 	 */
 	if (cpu != -1) {
 		/* Must be root to operate on a CPU counter: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu())
 			return ERR_PTR(-EACCES);
 
 		if (cpu < 0 || cpu > num_possible_cpus())
@@ -2841,7 +2852,9 @@ void perf_counter_output(struct perf_cou
 	header.misc |= perf_misc_flags(data->regs);
 
 	if (sample_type & PERF_SAMPLE_IP) {
-		ip = perf_instruction_pointer(data->regs);
+		ip = perf_paranoid_anon_ip();
+		if (!ip || user_mode(data->regs))
+			ip = perf_instruction_pointer(data->regs);
 		header.size += sizeof(ip);
 	}
 
@@ -4227,7 +4240,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 		return ret;
 
 	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_kernel())
 			return -EACCES;
 	}
 

-- 

