Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZDAExT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZDAExT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 00:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZDAExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 00:53:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:36338 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZDAExE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 00:53:04 -0400
Message-ID: <49D2F2D4.9090008@oracle.com>
Date: Tue, 31 Mar 2009 21:51:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       andreas.herrmann3@amd.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 boot hang
References: <49D280EF.1080507@oracle.com> <200904011012.11527.rusty@rustcorp.com.au>
In-Reply-To: <200904011012.11527.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49D2F2DF.013D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 01 April 2009 07:15:35 Randy Dunlap wrote:
>> On a 4-proc x86_64 (HP BladeCenter, AMD CPUs) system, booting 2.6.29
>> (or earlier, back to 2.6.28-6921-g873392c) hangs during boot.
>>
>> git bisect says:
>> 873392ca514f87eae39f53b6944caf85b1a047cb is first bad commit
>> commit 873392ca514f87eae39f53b6944caf85b1a047cb
>> Author: Rusty Russell <rusty@rustcorp.com.au>
>> Date:   Wed Dec 31 23:54:56 2008 +1030
>>
>>     PCI: work_on_cpu: use in drivers/pci/pci-driver.c
> 
> ...
> 
>> If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
>> the kernel boots successfully.
> 
> How very very odd.  My first thought was a deadlock with keventd used
> by work_on_cpu (changed in latest Linus tree), but the microcode code at
> that version doesn't use work_on_cpu.

Yep, I thought it a bit odd also.

> So I don't think that's it, but this patch should canonically eliminate it:
> 
> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> From: Andrew Morton <akpm@linux-foundation.org>

This patch doesn't apply to 2.6.29-final, but it does apply to 2.6.29-git8,
so I applied/tested it there.  with surprising results (at least to me).

2.6.29-git8 works for me without any patches applied.  After applying
this patch, I get the same boot hang that I was seeing with 2.6.29-final.

Make sense to you??

Thanks for your help.

> The various implemetnations and proposed implemetnations of work_on_cpu()
> are vulnerable to various deadlocks because they all used queues of some
> form.
> 
> Unrelated pieces of kernel code thus gained dependencies wherein if one
> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
> also takes, the kernel could rarely deadlock.
> 
> Fix this by creating a short-lived kernel thread for each work_on_cpu()
> invokation.
> 
> This is not terribly fast, but the only current caller of work_on_cpu() is
> pci_call_probe().
> 
> It would be nice to find some other way of doing the node-local
> allocations in the PCI probe code so that we can zap work_on_cpu()
> altogether.  The code there is rather nasty.  I can't think of anything
> simple at this time...
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/workqueue.c |   36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff -puN kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand kernel/workqueue.c
> --- a/kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand
> +++ a/kernel/workqueue.c
> @@ -985,20 +985,20 @@ undo:
>  }
>  
>  #ifdef CONFIG_SMP
> -static struct workqueue_struct *work_on_cpu_wq __read_mostly;
>  
>  struct work_for_cpu {
> -	struct work_struct work;
> +	struct completion completion;
>  	long (*fn)(void *);
>  	void *arg;
>  	long ret;
>  };
>  
> -static void do_work_for_cpu(struct work_struct *w)
> +static int do_work_for_cpu(void *_wfc)
>  {
> -	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
> -
> +	struct work_for_cpu *wfc = _wfc;
>  	wfc->ret = wfc->fn(wfc->arg);
> +	complete(&wfc->completion);
> +	return 0;
>  }
>  
>  /**
> @@ -1009,17 +1009,23 @@ static void do_work_for_cpu(struct work_
>   *
>   * This will return the value @fn returns.
>   * It is up to the caller to ensure that the cpu doesn't go offline.
> + * The caller must not hold any locks which would prevent @fn from completing.
>   */
>  long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
>  {
> -	struct work_for_cpu wfc;
> -
> -	INIT_WORK(&wfc.work, do_work_for_cpu);
> -	wfc.fn = fn;
> -	wfc.arg = arg;
> -	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
> -	flush_work(&wfc.work);
> -
> +	struct task_struct *sub_thread;
> +	struct work_for_cpu wfc = {
> +		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
> +		.fn = fn,
> +		.arg = arg,
> +	};
> +
> +	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
> +	if (IS_ERR(sub_thread))
> +		return PTR_ERR(sub_thread);
> +	kthread_bind(sub_thread, cpu);
> +	wake_up_process(sub_thread);
> +	wait_for_completion(&wfc.completion);
>  	return wfc.ret;
>  }
>  EXPORT_SYMBOL_GPL(work_on_cpu);
> @@ -1035,8 +1041,4 @@ void __init init_workqueues(void)
>  	hotcpu_notifier(workqueue_cpu_callback, 0);
>  	keventd_wq = create_workqueue("events");
>  	BUG_ON(!keventd_wq);
> -#ifdef CONFIG_SMP
> -	work_on_cpu_wq = create_workqueue("work_on_cpu");
> -	BUG_ON(!work_on_cpu_wq);
> -#endif
>  }
> _



-- 
~Randy
