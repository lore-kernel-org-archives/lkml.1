Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZG2Xbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZG2Xbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZG2Xbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:31:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247AbZG2Xbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:31:42 -0400
Date: Wed, 29 Jul 2009 16:31:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, jens.axboe@oracle.com, nickpiggin@yahoo.com.au,
       peterz@infradead.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 -mm] generic-ipi: fix the race between
 generic_smp_call_function_*() and hotplug_cfd()
Message-Id: <20090729163120.2e27be41.akpm@linux-foundation.org>
In-Reply-To: <4A7000FF.6040402@cn.fujitsu.com>
References: <4A6983D8.8090805@cn.fujitsu.com>
	<4A6FFFE9.5070204@cn.fujitsu.com>
	<4A7000FF.6040402@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 15:57:51 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> It have race between generic_smp_call_function_*() and hotplug_cfd()
> in many cases, see below examples:
> 
> 1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
>    cpu's cfd still in the call_function list:
>   
>   
>       CPU A:                         CPU B
>    
>  smp_call_function_many()	    ......
>    cpu_down()                      ......
>   hotplug_cfd() ->                 ......
>  free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
>                                 /* read cfd->cpumask */           
>                           generic_smp_call_function_interrupt() ->
>                          cpumask_test_and_clear_cpu(cpu, data->cpumask)
> 
>                          	CRASH!!!
> 
> 2: It's not handle call_function list when cpu down, It's will lead to
>    dead-wait if other path is waiting this cpu to execute function
>    
>     CPU A:                           CPU B
> 
>  smp_call_function_many(wait=0)					
>         ......			    CPU B down
>    smp_call_function_many() -->  (cpu down before recevie function
>     csd_lock(&data->csd);         IPI interrupte)
> 
>     DEAD-WAIT!!!!
>        
>   So, CPU A will dead-wait in csd_lock(), the same as
>   smp_call_function_single()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/smp.c |  140 ++++++++++++++++++++++++++++++++-------------------------
>  1 files changed, 79 insertions(+), 61 deletions(-)
> 

It was unfortunate that this patch moved a screenful of code around and
changed that code at the same time - it makes it hard to see what the
functional change was.

So I split this patch into two.  The first patch simply moves
hotplug_cfd() to the end of the file and the second makes the
functional changes.  The second patch is below, for easier review.

Do we think that this patch should be merged into 2.6.31?  2.6.30.x?



From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

There is a race between generic_smp_call_function_*() and hotplug_cfd() in
many cases, see below examples:

1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
   cpu's cfd still in the call_function list:


      CPU A:                         CPU B

 smp_call_function_many()	    ......
   cpu_down()                      ......
  hotplug_cfd() ->                 ......
 free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
                                /* read cfd->cpumask */
                          generic_smp_call_function_interrupt() ->
                         cpumask_test_and_clear_cpu(cpu, data->cpumask)

                         	CRASH!!!

2: It's not handle call_function list when cpu down, It's will lead to
   dead-wait if other path is waiting this cpu to execute function

    CPU A:                           CPU B

 smp_call_function_many(wait=0)
        ......			    CPU B down
   smp_call_function_many() -->  (cpu down before recevie function
    csd_lock(&data->csd);         IPI interrupte)

    DEAD-WAIT!!!!

  So, CPU A will dead-wait in csd_lock(), the same as
  smp_call_function_single()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff -puN kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd
+++ a/kernel/smp.c
@@ -116,14 +116,10 @@ void generic_exec_single(int cpu, struct
 		csd_lock_wait(data);
 }
 
-/*
- * Invoked by arch to handle an IPI for call function. Must be called with
- * interrupts disabled.
- */
-void generic_smp_call_function_interrupt(void)
+static void
+__generic_smp_call_function_interrupt(int cpu, int run_callbacks)
 {
 	struct call_function_data *data;
-	int cpu = smp_processor_id();
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -169,12 +165,18 @@ void generic_smp_call_function_interrupt
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+ * Invoked by arch to handle an IPI for call function. Must be called with
+ * interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void generic_smp_call_function_interrupt(void)
+{
+	__generic_smp_call_function_interrupt(smp_processor_id(), 1);
+}
+
+static void
+__generic_smp_call_function_single_interrupt(int cpu, int run_callbacks)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = &per_cpu(call_single_queue, cpu);
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
@@ -205,6 +207,15 @@ void generic_smp_call_function_single_in
 	}
 }
 
+/*
+ * Invoked by arch to handle an IPI for call function single. Must be
+ * called from the arch with interrupts disabled.
+ */
+void generic_smp_call_function_single_interrupt(void)
+{
+	__generic_smp_call_function_single_interrupt(smp_processor_id(), 1);
+}
+
 static DEFINE_PER_CPU(struct call_single_data, csd_data);
 
 /*
@@ -456,6 +467,7 @@ static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	unsigned long flags;
 	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
 
 	switch (action) {
@@ -472,6 +484,12 @@ hotplug_cfd(struct notifier_block *nfb, 
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		local_irq_save(flags);
+		__generic_smp_call_function_interrupt(cpu, 0);
+		__generic_smp_call_function_single_interrupt(cpu, 0);
+		local_irq_restore(flags);
+
+		csd_lock_wait(&cfd->csd);
 		free_cpumask_var(cfd->cpumask);
 		break;
 #endif
_

