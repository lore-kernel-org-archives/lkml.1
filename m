Return-Path: <linux-kernel-owner+w=401wt.eu-S934100AbZAPBIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbZAPBIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZAPBII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:08:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756441AbZAPBIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:08:07 -0500
Date: Thu, 15 Jan 2009 17:07:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       oleg@redhat.com
Subject: Re: [PATCH] getrusage: fill ru_ixrss, ru_idrss and ru_isrss values
Message-Id: <20090115170746.1f851488.akpm@linux-foundation.org>
In-Reply-To: <20090115153827.459ec787@psychotron.englab.brq.redhat.com>
References: <20090115153827.459ec787@psychotron.englab.brq.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 15:38:27 +0100
Jiri Pirko <jpirko@redhat.com> wrote:

> This patch makes three values in rusage structure filled in getrusage
> syscall. These values are in KB units so as the ->ru_maxrss value. They
> are ru_ixrss, ru_idrss and ru_isrss. Note that also these values are
> wrongly converted from pages to KBs by GNU time application (patch
> posted to app. maintainer).
> 
> These three values are actually accumulated memory usages. It means
> that each (in the ideal case) jiffy we need to add appropriate mm->xxx
> value to the counter. For this I'm using acct_update_integrals()
> function that is already accumulating total_vm and rss accumulated
> values for taskstats. I've extended this function to accumulate also
> vm_shared and vm_stack values from mm->. In the same fashion the
> task_struct is extended. I've also changed the accumulation time
> measure interval from USECs to jiffies. That's correct because there
> can't by lesser time interval then jiffy and we also achieve later
> potential u64 overflow (I do not see why this was not done this way in
> the first place). Three macros are added under the tast_struct
> definition in sched.h (I'm not sure this is the right place). These
> macros are actually getting appropriate i[xds]rss values from fields
> added to task_struct.
> 
> The struct signal_struct was extended by six fields. These refer to
> i[xds]rss values and i[xds]rss of childs. These are filled up in the
> similar way as other near fields in __exit_signal() and
> wait_task_zombie().
> 
> Note that taskstats can be possibly extended to pass accumulated
> vm_shared and vm_stack too.
> 
> 
> Please review and comment this patch - all comments are highly welcomed.
> 
> Btw wouldn't it be nice to have macro like K() (PAGEs->KBs) globally
> defined instead of defining it on each spot in kernel where we need it?
> FreeBSD has this - pgtok().
> 
> ...
>
>  include/linux/sched.h |   22 +++++++++++++++++++---
>  kernel/exit.c         |    9 +++++++++
>  kernel/fork.c         |    1 +
>  kernel/sys.c          |   17 ++++++++++++++++-
>  kernel/tsacct.c       |   24 ++++++++++++------------
>  5 files changed, 57 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4da3b86..9303bc0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -561,6 +561,7 @@ struct signal_struct {
>  	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
>  	unsigned long inblock, oublock, cinblock, coublock;
>  	unsigned long maxrss, cmaxrss;
> +	unsigned long ixrss, idrss, isrss, cixrss, cidrss, cisrss;
>  	struct task_io_accounting ioac;
>  
>  	/*
> @@ -1327,9 +1328,11 @@ struct task_struct {
>  	siginfo_t *last_siginfo; /* For ptrace use.  */
>  	struct task_io_accounting ioac;
>  #if defined(CONFIG_TASK_XACCT)
> -	u64 acct_rss_mem1;	/* accumulated rss usage */
> -	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
> -	cputime_t acct_timexpd;	/* stime + utime since last update */
> +	u64 acct_rss_mem1;		/* accumulated rss usage */
> +	u64 acct_total_vm_mem1;		/* accumulated virtual memory usage */
> +	u64 acct_shared_vm_mem1;	/* accumulated shared virtual memory usage */
> +	u64 acct_stack_vm_mem1;		/* accumulated stack virtual memory usage */
> +	cputime_t acct_timexpd;		/* stime + utime since last update */
>  #endif
>  #ifdef CONFIG_CPUSETS
>  	nodemask_t mems_allowed;
> @@ -1399,6 +1402,19 @@ struct task_struct {
>  #endif
>  };

This adds, what?  40 or 64 bytes to the task_struct?  Consuming more memory
and worsening the kernel's cache hit rate.

It would be nice if the changelog were to contain comforting words
which allow us to believe that this is all worthwhile.

Perhaps it is time to allocate all this accounting stuff separately
from the task_struct?

Can ixrss ... cisrss be placed inside #ifdef CONFIG_TASK_XACCT?

> +#if defined(CONFIG_TASK_XACCT)
> +#define get_task_ixrss(tsk) jiffies_to_clock_t((tsk)->acct_shared_vm_mem1)
> +#define get_task_idrss(tsk) jiffies_to_clock_t( \
> +			(tsk)->acct_total_vm_mem1 - \
> +			(tsk)->acct_shared_vm_mem1 - \
> +			(tsk)->acct_stack_vm_mem1)
> +#define get_task_isrss(tsk) jiffies_to_clock_t((tsk)->acct_stack_vm_mem1)
> +#else
> +#define get_task_ixrss(tsk) 0UL
> +#define get_task_idrss(tsk) 0UL
> +#define get_task_isrss(tsk) 0UL
> +#endif

erk.  Please implement all these in C.  It's nicer to read, doesn't
evaluate the same expression multiple times and provides compile-time
typechecking.

Only implement in macros those things which *must* be implemented in
macros.

> +/* convert pages to KBs */
> +#define K(x) ((x) << (PAGE_SHIFT - 10))
> +	r->ru_maxrss = K(maxrss);
> +	r->ru_ixrss = K(r->ru_ixrss);
> +	r->ru_idrss = K(r->ru_idrss);
> +	r->ru_isrss = K(r->ru_isrss);

Yes, K() is a bit silly.

Perhaps this is a sufficiently common operation to justify implementing
it in printk() itself.

	printk("%pK", &r->ru_ixrss))

(I think).

This would require that the passed-in number be consistently either
32-bit or 64-bit, and we'd have no compile-time checking for this, so
maybe not do this.


