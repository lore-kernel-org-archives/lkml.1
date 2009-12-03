Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZLCSWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZLCSWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZLCSWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:22:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40986 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbZLCSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:22:08 -0500
Date: Thu, 3 Dec 2009 19:21:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [GIT PULL] core/ipi changes for v2.6.33
Message-ID: <20091203182155.GA3082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-ipi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-ipi-for-linus

Thanks,

	Ingo

------------------>
Rusty Russell (1):
      generic-ipi: Add smp_call_function_any()

Sheng Yang (1):
      generic-ipi: Fix misleading smp_call_function*() description


 include/linux/smp.h |   11 +++++++++-
 kernel/smp.c        |   56 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 39c64ba..7a0570e 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -76,6 +76,9 @@ void smp_call_function_many(const struct cpumask *mask,
 void __smp_call_function_single(int cpuid, struct call_single_data *data,
 				int wait);
 
+int smp_call_function_any(const struct cpumask *mask,
+			  void (*func)(void *info), void *info, int wait);
+
 /*
  * Generic and arch helpers
  */
@@ -137,9 +140,15 @@ static inline void smp_send_reschedule(int cpu) { }
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_many(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-static inline void init_call_single_data(void)
+static inline void init_call_single_data(void) { }
+
+static inline int
+smp_call_function_any(const struct cpumask *mask, void (*func)(void *info),
+		      void *info, int wait)
 {
+	return smp_call_function_single(0, func, info, wait);
 }
+
 #endif /* !SMP */
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index c9d1c78..a8c7606 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -265,9 +265,7 @@ static DEFINE_PER_CPU(struct call_single_data, csd_data);
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Note that @wait
- * will be implicitly turned on in case of allocation failures, since
- * we fall back to on-stack allocation.
+ * Returns 0 on success, else a negative status code.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int wait)
@@ -321,6 +319,51 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+/*
+ * smp_call_function_any - Run a function on any of the given cpus
+ * @mask: The mask of cpus it can run on.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait until function has completed.
+ *
+ * Returns 0 on success, else a negative status code (if no cpus were online).
+ * Note that @wait will be implicitly turned on in case of allocation failures,
+ * since we fall back to on-stack allocation.
+ *
+ * Selection preference:
+ *	1) current cpu if in @mask
+ *	2) any cpu of current node if in @mask
+ *	3) any other online cpu in @mask
+ */
+int smp_call_function_any(const struct cpumask *mask,
+			  void (*func)(void *info), void *info, int wait)
+{
+	unsigned int cpu;
+	const struct cpumask *nodemask;
+	int ret;
+
+	/* Try for same CPU (cheapest) */
+	cpu = get_cpu();
+	if (cpumask_test_cpu(cpu, mask))
+		goto call;
+
+	/* Try for same node. */
+	nodemask = cpumask_of_node(cpu);
+	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
+	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
+		if (cpu_online(cpu))
+			goto call;
+	}
+
+	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
+	cpu = cpumask_any_and(mask, cpu_online_mask);
+call:
+	ret = smp_call_function_single(cpu, func, info, wait);
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smp_call_function_any);
+
 /**
  * __smp_call_function_single(): Run a function on another CPU
  * @cpu: The CPU to run on.
@@ -355,9 +398,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
  * @wait: If true, wait (atomically) until function has completed
  *        on other CPUs.
  *
- * If @wait is true, then returns once @func has returned. Note that @wait
- * will be implicitly turned on in case of allocation failures, since
- * we fall back to on-stack allocation.
+ * If @wait is true, then returns once @func has returned.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
@@ -443,8 +484,7 @@ EXPORT_SYMBOL(smp_call_function_many);
  * Returns 0.
  *
  * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func. In case of allocation
- * failure, @wait will be implicitly turned on.
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
