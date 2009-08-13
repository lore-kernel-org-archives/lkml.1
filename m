Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZHMIks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZHMIks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZHMIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:40:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:33431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZHMIkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:40:39 -0400
Date: Thu, 13 Aug 2009 08:39:53 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Provide hw_perf_counter_setup_online() APIs
Message-ID: <tip-28402971d869e26271b25301011f667d3a5640c3@git.kernel.org>
Git-Commit-ID: 28402971d869e26271b25301011f667d3a5640c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 08:40:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28402971d869e26271b25301011f667d3a5640c3
Gitweb:     http://git.kernel.org/tip/28402971d869e26271b25301011f667d3a5640c3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 13 Aug 2009 10:13:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 10:13:22 +0200

perf_counter: Provide hw_perf_counter_setup_online() APIs

Provide weak aliases for hw_perf_counter_setup_online(). This is
used by the BTS patches (for v2.6.32), but it interacts with
fixes so propagate this upstream. (it has no effect as of yet)

Also export perf_counter_output() to architecture code.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a9d823a..2b36afe 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -694,6 +694,8 @@ struct perf_sample_data {
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
 				 struct perf_sample_data *data);
+extern void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b0b20a0..e26d2fc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -88,6 +88,7 @@ void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
+void __weak hw_perf_counter_setup_online(int cpu)	{ barrier(); }
 
 int __weak
 hw_perf_group_sched_in(struct perf_counter *group_leader,
@@ -2630,7 +2631,7 @@ static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
 	return task_pid_nr_ns(p, counter->ns);
 }
 
-static void perf_counter_output(struct perf_counter *counter, int nmi,
+void perf_counter_output(struct perf_counter *counter, int nmi,
 				struct perf_sample_data *data)
 {
 	int ret;
@@ -4592,6 +4593,11 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 		perf_counter_init_cpu(cpu);
 		break;
 
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		hw_perf_counter_setup_online(cpu);
+		break;
+
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		perf_counter_exit_cpu(cpu);
@@ -4616,6 +4622,8 @@ void __init perf_counter_init(void)
 {
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
+			(void *)(long)smp_processor_id());
 	register_cpu_notifier(&perf_cpu_nb);
 }
 
