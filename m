Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYCQXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYCQXdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYCQXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:33:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52289 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYCQXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:33:40 -0400
Date: Mon, 17 Mar 2008 16:32:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] Add a "show workqueues" SYSRQ knob.
Message-Id: <20080317163225.479069ce.randy.dunlap@oracle.com>
In-Reply-To: <1205795950.15714.39.camel@bobble.smo.corp.google.com>
References: <1205795950.15714.39.camel@bobble.smo.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 16:19:10 -0700 Frank Mayhar wrote:

> This patch adds a convenient function to show all workqueues using the
> magic SYSRQ handling.  It uses the 'z' key to invoke the function as the
> 'w' key was already gone.
> 
> I've found this very useful in debugging; hopefully others will find it
> as useful.

Missing update to Documentation/sysrq.txt.

Patch description, diffstat, & sob should come before the patch.

And I propose that we reserve sysrq-j for extending sysrq keys in the
(probably near) future.


> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index de60e1e..733d625 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -243,6 +243,18 @@ static struct sysrq_key_op sysrq_showmem_op = {
>  	.enable_mask	= SYSRQ_ENABLE_DUMP,
>  };
>  
> +static void sysrq_handle_showwq(int key, struct pt_regs *pt_regs,
> +				   struct tty_struct *tty)
> +{
> +	show_workqueues();
> +}
> +static struct sysrq_key_op sysrq_showwq_op = {
> +	.handler	= sysrq_handle_showwq,
> +	.help_msg	= "showworkqueueZ",
> +	.action_msg	= "Show Workqueues",
> +	.enable_mask	= SYSRQ_ENABLE_DUMP,
> +};
> +
>  /*
>   * Signal sysrq helper function.  Sends a signal to all user processes.
>   */
> @@ -358,7 +370,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	NULL,				/* x */
>  	NULL,				/* y */
> -	NULL				/* z */
> +	&sysrq_showwq_op		/* z */
>  };
>  
>  /* key2index calculation, -1 on invalid index */
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 542526c..6ae9ebb 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -195,6 +195,7 @@ extern int schedule_on_each_cpu(work_func_t func);
>  extern int current_is_keventd(void);
>  extern int keventd_up(void);
>  
> +extern void show_workqueues(void);
>  extern void init_workqueues(void);
>  int execute_in_process_context(work_func_t fn, struct execute_work *);
>  
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index ff06611..c97d35d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -33,6 +33,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/debug_locks.h>
>  #include <linux/lockdep.h>
> +#include <linux/kallsyms.h>
>  
>  /*
>   * The per-CPU workqueue (if single thread, we always use the first
> @@ -867,6 +868,31 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> +void show_workqueues(void)
> +{
> +	struct workqueue_struct *wq;
> +	int cpu;
> +
> +	spin_lock(&workqueue_lock);
> +	list_for_each_entry(wq, &workqueues, list) {
> +		printk("\n");
> +		printk("Workqueue %s:\n", wq->name);
> +		for_each_online_cpu(cpu) {
> +			struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> +			struct work_struct *work;
> +
> +			printk("\tCPU %d ", cpu);
> +			list_for_each_entry(work, &(cwq->worklist), entry) {
> +				print_symbol("function %s", (unsigned long)work->func);
> +			}
> +			printk("\n");
> +		}
> +	}
> +	spin_unlock(&workqueue_lock);
> +	
> +}
> +EXPORT_SYMBOL(show_workqueues);
> +
>  void __init init_workqueues(void)
>  {
>  	cpu_populated_map = cpu_online_map;
> ---
> 
> diffstat wq.patch 
>  drivers/char/sysrq.c      |   14 +++++++++++++-
>  include/linux/workqueue.h |    1 +
>  kernel/workqueue.c        |   26 ++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
> Signed-off-by:  Frank Mayhar <fmayhar@google.com>

---
~Randy
