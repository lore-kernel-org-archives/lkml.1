Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbZA2Kjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbZA2Kjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZA2Kje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:39:34 -0500
Received: from ozlabs.org ([203.10.76.45]:60621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZA2Kjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:39:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Thu, 29 Jan 2009 21:09:23 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <4980939C.6010102@sgi.com> <498096BA.2000301@sgi.com>
In-Reply-To: <498096BA.2000301@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901292109.24160.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 04:02:42 Mike Travis wrote:
> Mike Travis wrote:
> > Hi Rusty,
> > 
> > I'm testing this now on x86_64 and one question comes up.  The
> > initialization of the woc_wq thread happens quite late.  Might it
> > be better to initialize it earlier?
> 
> Umm, definitely needed earlier...  A bug catcher caught this.  Work_on_cpu
> is being called before it's initialized.
>
> [   16.541297] calling  microcode_init+0x0/0x13a @ 1

OK, core_initcall will be sufficient to call before this one.

I also want to change the code so that the affinity is set from work_on_cpu rather than the thread itself; it's slightly more efficient.

Here's a patch-on-top.

work_on_cpu: bug fix and enhancements

Make it a core_initcall, since a module_initcall needs it.

Also, make the caller set the affinity of the worker thread: this is
more efficient than setting our own affinity (which requires the
migration thread's help).

This has two side effects:
1) We will oops if work_on_cpu is called too early,
2) We can WARN_ON and just run on the wrong cpu rather than locking up if
   they ask for an offline cpu (bug compatible old method of calling
   set_cpus_allowed).

Test code exercises WARN_ON; you probably want to remove it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/work_on_cpu.c b/kernel/work_on_cpu.c
--- a/kernel/work_on_cpu.c
+++ b/kernel/work_on_cpu.c
@@ -5,6 +5,10 @@
 #include <linux/cpumask.h>
 #include <linux/module.h>
 
+#define DEBUG
+
+/* The thread which actually does the work. */
+static struct task_struct *woc_thread;
 /* The thread waits for new work on this waitqueue. */
 static DECLARE_WAIT_QUEUE_HEAD(woc_wq);
 /* The lock ensures only one job is done at a time. */
@@ -12,7 +16,9 @@ static DEFINE_MUTEX(woc_mutex);
 
 /* The details of the current job. */
 struct work_for_cpu {
+#ifdef DEBUG
 	unsigned int cpu;
+#endif
 	long (*fn)(void *);
 	void *arg;
 	long ret;
@@ -33,8 +39,9 @@ static int do_work_on_cpu(void *unused)
 
 		wait_event(woc_wq, current_work != NULL);
 
-		set_cpus_allowed_ptr(current, cpumask_of(current_work->cpu));
+#ifdef DEBUG
 		WARN_ON(smp_processor_id() != current_work->cpu);
+#endif
 
 		current_work->ret = current_work->fn(current_work->arg);
 		/* Make sure ret is set before we complete().  Paranoia. */
@@ -62,12 +69,21 @@ long work_on_cpu(unsigned int cpu, long 
 {
 	struct work_for_cpu work;
 
+#ifdef DEBUG
 	work.cpu = cpu;
+#endif
 	work.fn = fn;
 	work.arg = arg;
 	init_completion(&work.done);
 
 	mutex_lock(&woc_mutex);
+	if (set_cpus_allowed_ptr(woc_thread, cpumask_of(cpu)) != 0) {
+		WARN(1, "work_on_cpu on offline cpu %i?\n", cpu);
+#ifdef DEBUG
+		/* Avoids the additional WARN_ON in the thread. */
+		work.cpu = task_cpu(woc_thread);
+#endif
+	}
 	/* Make sure all is in place before it sees fn set. */
 	wmb();
 	current_work = &work;
@@ -81,7 +97,7 @@ long work_on_cpu(unsigned int cpu, long 
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
 
-#if 1
+#ifdef DEBUG
 static long test_fn(void *arg)
 {
 	printk("%u: %lu\n", smp_processor_id(), (long)arg);
@@ -93,16 +109,16 @@ static int __init init(void)
 {
 	unsigned int i;
 
-	kthread_run(do_work_on_cpu, NULL, "kwork_on_cpu");
+	woc_thread = kthread_run(do_work_on_cpu, NULL, "kwork_on_cpu");
 
-#if 1
-	for_each_online_cpu(i) {
+#ifdef DEBUG
+	for_each_possible_cpu(i) {
 		long ret = work_on_cpu(i, test_fn, (void *)i);
 		printk("CPU %i returned %li\n", i, ret);
-		BUG_ON(ret != i + 100);
+		BUG_ON(cpu_online(i) && ret != i + 100);
 	}
 #endif
 
 	return 0;
 }
-module_init(init);
+core_initcall(init);
