Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZA3XN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZA3XN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZA3XNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:13:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZA3XNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:13:11 -0500
Date: Sat, 31 Jan 2009 00:12:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] core kernel fixes
Message-ID: <20090130231258.GA11961@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ed Swierk (1):
      signals, debug: fix BUG: using smp_processor_id() in preemptible code in print_fatal_signal()

Rusty Russell (1):
      cpumask: convert lib/smp_processor_id to new cpumask ops

Steven Rostedt (1):
      generic-ipi: use per cpu data for single cpu ipi calls


 kernel/signal.c        |    2 ++
 kernel/smp.c           |   36 +++++++++++++++++++++++++++++++++---
 lib/smp_processor_id.c |    2 +-
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index e737597..b6b3676 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -909,7 +909,9 @@ static void print_fatal_signal(struct pt_regs *regs, int signr)
 	}
 #endif
 	printk("\n");
+	preempt_disable();
 	show_regs(regs);
+	preempt_enable();
 }
 
 static int __init setup_print_fatal_signals(char *str)
diff --git a/kernel/smp.c b/kernel/smp.c
index 5cfa0e5..bbedbb7 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -18,6 +18,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
 enum {
 	CSD_FLAG_WAIT		= 0x01,
 	CSD_FLAG_ALLOC		= 0x02,
+	CSD_FLAG_LOCK		= 0x04,
 };
 
 struct call_function_data {
@@ -186,6 +187,9 @@ void generic_smp_call_function_single_interrupt(void)
 			if (data_flags & CSD_FLAG_WAIT) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_WAIT;
+			} else if (data_flags & CSD_FLAG_LOCK) {
+				smp_wmb();
+				data->flags &= ~CSD_FLAG_LOCK;
 			} else if (data_flags & CSD_FLAG_ALLOC)
 				kfree(data);
 		}
@@ -196,6 +200,8 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
+static DEFINE_PER_CPU(struct call_single_data, csd_data);
+
 /*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
@@ -224,14 +230,38 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		func(info);
 		local_irq_restore(flags);
 	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		struct call_single_data *data = NULL;
+		struct call_single_data *data;
 
 		if (!wait) {
+			/*
+			 * We are calling a function on a single CPU
+			 * and we are not going to wait for it to finish.
+			 * We first try to allocate the data, but if we
+			 * fail, we fall back to use a per cpu data to pass
+			 * the information to that CPU. Since all callers
+			 * of this code will use the same data, we must
+			 * synchronize the callers to prevent a new caller
+			 * from corrupting the data before the callee
+			 * can access it.
+			 *
+			 * The CSD_FLAG_LOCK is used to let us know when
+			 * the IPI handler is done with the data.
+			 * The first caller will set it, and the callee
+			 * will clear it. The next caller must wait for
+			 * it to clear before we set it again. This
+			 * will make sure the callee is done with the
+			 * data before a new caller will use it.
+			 */
 			data = kmalloc(sizeof(*data), GFP_ATOMIC);
 			if (data)
 				data->flags = CSD_FLAG_ALLOC;
-		}
-		if (!data) {
+			else {
+				data = &per_cpu(csd_data, me);
+				while (data->flags & CSD_FLAG_LOCK)
+					cpu_relax();
+				data->flags = CSD_FLAG_LOCK;
+			}
+		} else {
 			data = &d;
 			data->flags = CSD_FLAG_WAIT;
 		}
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 0f8fc22..4689cb0 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
+	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
 		goto out;
 
 	/*
