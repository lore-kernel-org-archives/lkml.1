Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZA1NCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZA1NCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZA1NCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:02:38 -0500
Received: from ozlabs.org ([203.10.76.45]:40385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZA1NCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:02:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Wed, 28 Jan 2009 23:32:28 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901271735.12034.rusty@rustcorp.com.au> <20090126232519.44f2943c.akpm@linux-foundation.org>
In-Reply-To: <20090126232519.44f2943c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901282332.29429.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0SD30wM003667

On Tuesday 27 January 2009 17:55:19 Andrew Morton wrote:[ lots of good stuff ]
> Making work_on_cu() truly generic is quite hard!
Yes.  What do you think of this workqueue-less approach?
Subject: work_on_cpu: non-workqueue solution.
work_on_cpu was designed to replace the meme of:
	cpumask_t saved = current->cpus_allowed;	set_cpus_allowed(cpumask_of(dst));	    ... do something on cpu dst ...	set_cpus_allowed(saved);
It should have been a trivial routine, and a trivial conversion.
The original version did a get_online_cpus(), then put the work on thekevent queue, called flush_work(), then put_online_cpus().  See2d3854a37e8b767a51aba38ed6d22817b0631e33.
Several locking warnings resulted from different users being convertedover the months this patch was used leading up to 2.6.29.  One wasfixed to use smp_call_function_single(b2bb85549134c005e997e5a7ed303bda6a1ae738), but it's always risky toconvert code which was running in user context into interrupt context.When another one was reported, we dropped the get_online_cpus() andrelied on the callers to do that (as they should have been doingbefore) as seen in 31ad9081200c06ccc350625d41d1f8b2d1cef29f.
But there was still a locking issue witharch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c, so that conversion wasreverted in Ingo's tree.  Turns out that it the conversion causedwork_on_cpu to be called from inside keventd in some paths.
The obvious solution was to change to using our own workqueue, so wecould use it in ACPI and so it would actually be a generically usefulfunction as intended.
Andrew Morton complained about NR_CPUS new threads.  Which I happen toagree with.  (He also bitched about the comment being too short, sothis one is a fucking novel).
While I was at linux.conf.au and avoiding reading my mail, a longdiscussion ensued (See lkml "[PATCH 2/3] work_on_cpu: Use our ownworkqueue."), including useful advice such as not ever grabbing a lockinside a work function.  Or something; it gets a bit confusing.
To make the pain stop, this attempts to create work_on_cpu withoutusing workqueues at all.  It does create one new thread.  But as longas you don't call work_on_cpu inside work_on_cpu, or create normallocking inversions, it should work just peachy.
FIXME: It includes work_on_cpu.h from workqueue.h to avoid chasing allthe users, but they should include it directly.
I tested it lightly (as seen in this patch), but my test machinedoesn't hit any work_on_cpu paths.
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
diff --git a/include/linux/work_on_cpu.h b/include/linux/work_on_cpu.hnew file mode 100644--- /dev/null+++ b/include/linux/work_on_cpu.h@@ -0,0 +1,13 @@+#ifndef _LINUX_WORK_ON_CPU_H+#define _LINUX_WORK_ON_CPU_H++#ifndef CONFIG_SMP+static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)+{+	return fn(arg);+}+#else+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);+#endif /* CONFIG_SMP */++#endif /* _LINUX_WORK_ON_CPU_H */diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h--- a/include/linux/workqueue.h+++ b/include/linux/workqueue.h@@ -9,6 +9,7 @@ #include <linux/linkage.h> #include <linux/bitops.h> #include <linux/lockdep.h>+#include <linux/work_on_cpu.h> #include <asm/atomic.h>  struct workqueue_struct;@@ -251,13 +252,4 @@ void cancel_rearming_delayed_work(struct { 	cancel_delayed_work_sync(work); }--#ifndef CONFIG_SMP-static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)-{-	return fn(arg);-}-#else-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);-#endif /* CONFIG_SMP */ #endifdiff --git a/kernel/Makefile b/kernel/Makefile--- a/kernel/Makefile+++ b/kernel/Makefile@@ -92,6 +92,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/ obj-$(CONFIG_FUNCTION_TRACER) += trace/ obj-$(CONFIG_TRACING) += trace/ obj-$(CONFIG_SMP) += sched_cpupri.o+obj-$(CONFIG_SMP) += work_on_cpu.o  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y) # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer isdiff --git a/kernel/work_on_cpu.c b/kernel/work_on_cpu.cnew file mode 100644--- /dev/null+++ b/kernel/work_on_cpu.c@@ -0,0 +1,108 @@+#include <linux/work_on_cpu.h>+#include <linux/kthread.h>+#include <linux/mutex.h>+#include <linux/completion.h>+#include <linux/cpumask.h>+#include <linux/module.h>++/* The thread waits for new work on this waitqueue. */+static DECLARE_WAIT_QUEUE_HEAD(woc_wq);+/* The lock ensures only one job is done at a time. */+static DEFINE_MUTEX(woc_mutex);++/* The details of the current job. */+struct work_for_cpu {+	unsigned int cpu;+	long (*fn)(void *);+	void *arg;+	long ret;+	struct completion done;+};++/* The pointer to the current job.  NULL if nothing pending. */+static struct work_for_cpu *current_work;++/* We leave our thread on whatever cpu it was on last.  We can get+ * batted onto another CPU by move_task_off_dead_cpu if that cpu goes+ * down, but the caller of work_on_cpu() was supposed to ensure that+ * doesn't happen, so it should only happen when idle. */+static int do_work_on_cpu(void *unused)+{+	for (;;) {+		struct completion *done;++		wait_event(woc_wq, current_work != NULL);++		set_cpus_allowed_ptr(current, cpumask_of(current_work->cpu));+		WARN_ON(smp_processor_id() != current_work->cpu);++		current_work->ret = current_work->fn(current_work->arg);+		/* Make sure ret is set before we complete().  Paranoia. */+		wmb();++		/* Reset current_work so we don't spin. */+		done = &current_work->done;+		current_work = NULL;++		/* Reset current_work for next work_on_cpu(). */+		complete(done);+	}+}++/**+ * work_on_cpu - run a function in user context on a particular cpu+ * @cpu: the cpu to run on+ * @fn: the function to run+ * @arg: the function arg+ *+ * This will return the value @fn returns.+ * It is up to the caller to ensure that the cpu doesn't go offline.+ */+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)+{+	struct work_for_cpu work;++	work.cpu = cpu;+	work.fn = fn;+	work.arg = arg;+	init_completion(&work.done);++	mutex_lock(&woc_mutex);+	/* Make sure all is in place before it sees fn set. */+	wmb();+	current_work = &work;+	wake_up(&woc_wq);++	wait_for_completion(&work.done);+	BUG_ON(current_work);+	mutex_unlock(&woc_mutex);++	return work.ret;+}+EXPORT_SYMBOL_GPL(work_on_cpu);++#if 1+static long test_fn(void *arg)+{+	printk("%u: %lu\n", smp_processor_id(), (long)arg);+	return (long)arg + 100;+}+#endif++static int __init init(void)+{+	unsigned int i;++	kthread_run(do_work_on_cpu, NULL, "kwork_on_cpu");++#if 1+	for_each_online_cpu(i) {+		long ret = work_on_cpu(i, test_fn, (void *)i);+		printk("CPU %i returned %li\n", i, ret);+		BUG_ON(ret != i + 100);+	}+#endif++	return 0;+}+module_init(init);diff --git a/kernel/workqueue.c b/kernel/workqueue.c--- a/kernel/workqueue.c+++ b/kernel/workqueue.c@@ -970,47 +970,6 @@ undo: 	return ret; } -#ifdef CONFIG_SMP-static struct workqueue_struct *work_on_cpu_wq __read_mostly;--struct work_for_cpu {-	struct work_struct work;-	long (*fn)(void *);-	void *arg;-	long ret;-};--static void do_work_for_cpu(struct work_struct *w)-{-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);--	wfc->ret = wfc->fn(wfc->arg);-}--/**- * work_on_cpu - run a function in user context on a particular cpu- * @cpu: the cpu to run on- * @fn: the function to run- * @arg: the function arg- *- * This will return the value @fn returns.- * It is up to the caller to ensure that the cpu doesn't go offline.- */-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)-{-	struct work_for_cpu wfc;--	INIT_WORK(&wfc.work, do_work_for_cpu);-	wfc.fn = fn;-	wfc.arg = arg;-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);-	flush_work(&wfc.work);--	return wfc.ret;-}-EXPORT_SYMBOL_GPL(work_on_cpu);-#endif /* CONFIG_SMP */- void __init init_workqueues(void) { 	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);@@ -1021,8 +980,4 @@ void __init init_workqueues(void) 	hotcpu_notifier(workqueue_cpu_callback, 0); 	keventd_wq = create_workqueue("events"); 	BUG_ON(!keventd_wq);-#ifdef CONFIG_SMP-	work_on_cpu_wq = create_workqueue("work_on_cpu");-	BUG_ON(!work_on_cpu_wq);-#endif } ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
