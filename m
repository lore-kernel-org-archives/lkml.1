Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZEQHnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZEQHnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZEQHn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:43:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZEQHn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:43:26 -0400
Date: Sun, 17 May 2009 09:43:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, vatsa@in.ibm.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Fix counter inheritance
Message-ID: <20090517074310.GA12268@elte.hu>
References: <tip-856d56b9e5de650a64a6c41c17aaed702b55d578@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-856d56b9e5de650a64a6c41c17aaed702b55d578@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Commit-ID:  856d56b9e5de650a64a6c41c17aaed702b55d578
> Gitweb:     http://git.kernel.org/tip/856d56b9e5de650a64a6c41c17aaed702b55d578
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 15 May 2009 20:45:59 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 17 May 2009 07:52:24 +0200
> 
> perf_counter: Fix counter inheritance
> 
> Srivatsa Vaddagiri reported that a Java workload triggers this
> warning in kernel/exit.c:
> 
>    WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
> 
> Add the inherited counter propagation on self-detach, this could
> cause counter leaks and incomplete stats in threaded code like
> the below:
> 
>   #include <pthread.h>
>   #include <unistd.h>
> 
>   void *thread(void *arg)
>   {
>           sleep(5);
>           return NULL;
>   }
> 
>   void main(void)
>   {
>           pthread_t thr;
>           pthread_create(&thr, NULL, thread, NULL);
>   }
> 
> Reported-by: Srivatsa Vaddagiri <vatsa@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/exit.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 4741376..16d74f1 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -128,6 +128,12 @@ static void __exit_signal(struct task_struct *tsk)
>  		sig = NULL; /* Marker for below. */
>  	}
>  
> +	/*
> +	 * Flush inherited counters to the parent - before the parent
> +	 * gets woken up by child-exit notifications.
> +	 */
> +	perf_counter_exit_task(tsk);

Causes:

[  447.882292] BUG: sleeping function called from invalid context at kernel/mutex.c:94
[  447.890094] in_atomic(): 0, irqs_disabled(): 1, pid: 23597, name: hackbench_pth
[  447.897587] Pid: 23597, comm: hackbench_pth Not tainted 2.6.30-rc6-tip #188
[  447.904678] Call Trace:
[  447.907158]  [<ffffffff814cdd0b>] ? mutex_lock+0x15/0x37
[  447.912518]  [<ffffffff8108f1e3>] ? perf_counter_exit_task+0x170/0x1e9
[  447.919134]  [<ffffffff81046182>] ? release_task+0x22c/0x402
[  447.924859]  [<ffffffff8104789d>] ? do_exit+0x655/0x6e7
[  447.930144]  [<ffffffff810479ea>] ? complete_and_exit+0x0/0x16
[  447.936054]  [<ffffffff8100baab>] ? system_call_fastpath+0x16/0x1b

when running:

   perf stat ./hackbench_pth 20

release_task() is a deep-atomic context, we cannot acquire a mutex 
there. I'm not sure we can change that lock to a spinlock straight 
away.

	Ingo
