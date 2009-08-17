Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZHQNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZHQNEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZHQNEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:04:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZHQNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:04:22 -0400
Subject: [PATCH] perf_counter: Default to higher paranoia level
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Aug 2009 15:03:44 +0200
Message-Id: <1250514224.5241.1743.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the default permissions on perf counters.

The new default will disallow regular users to create cpu-wide
counters, and will anonymize kernel IPs for task samples.

This will allow a user to profile his own applications and still know
the proportion of the kernel events, but does not expose kernel IPs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    6 ++++++
 include/linux/perf_counter.h       |    1 +
 kernel/perf_counter.c              |   27 ++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 396e35d..0fe1126 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -2153,7 +2153,13 @@ static const struct stacktrace_ops backtrace_ops = {
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
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9ba1822..b74b1c3 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -754,6 +754,7 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
+extern unsigned long perf_paranoid_anon_ip(void);
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b8fe739..8daf760 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -48,18 +48,29 @@ static atomic_t nr_task_counters __read_mostly;
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
@@ -1571,7 +1582,7 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 	 */
 	if (cpu != -1) {
 		/* Must be root to operate on a CPU counter: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_cpu())
 			return ERR_PTR(-EACCES);
 
 		if (cpu < 0 || cpu > num_possible_cpus())
@@ -2841,7 +2852,9 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
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
 

