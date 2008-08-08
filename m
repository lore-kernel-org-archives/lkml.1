Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbYHHUUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbYHHUUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYHHUUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:20:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51477 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYHHUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:20:32 -0400
Date: Fri, 8 Aug 2008 13:20:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>, josht@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080808202028.GF6760@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org> <1206382547.6437.131.camel@lappy> <20080324115738.85c72bb5.akpm@linux-foundation.org> <1218202249.8625.106.camel@twins> <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org> <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 08:14:28PM +0200, Peter Zijlstra wrote:
> Avoid deadlocks against rq->lock and xtime_lock by using RCU to defer
> the klogd wakeup.

Longer term, I will have one of the people here (who just happens to have
made the mistake of expressing an interest in hacking on RCU) look into
permitting invocation of RCU earlier during boot, as in before rcu_init()
has been called.  Should be possible, in fact should be possible without
common-case performance penalty.  ;-)

In the meantime, looks good, so:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> ---
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b51b156..8870c2e 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -32,6 +32,7 @@
>  #include <linux/security.h>
>  #include <linux/bootmem.h>
>  #include <linux/syscalls.h>
> +#include <linux/rcupdate.h>
> 
>  #include <asm/uaccess.h>
> 
> @@ -982,10 +983,37 @@ int is_console_locked(void)
>  	return console_locked;
>  }
> 
> +struct klogd_wakeup_state {
> +	struct rcu_head head;
> +	int pending;
> +};
> +
> +DEFINE_PER_CPU(struct klogd_wakeup_state, kws);
> +
> +void __wake_up_klogd(struct rcu_head *head)
> +{
> +	struct klogd_wakeup_state *kws = 
> +		container_of(head, struct klogd_wakeup_state, head);
> +
> +	wake_up_interruptible(&log_wait);
> +	kws->pending = 0;
> +}
> +
>  void wake_up_klogd(void)
>  {
> -	if (!oops_in_progress && waitqueue_active(&log_wait))
> -		wake_up_interruptible(&log_wait);
> +	unsigned long flags;
> +	struct klogd_wakeup_state *kws;
> +
> +	if (!waitqueue_active(&log_wait))
> +		return;
> +
> +	local_irq_save(flags);
> +	kws = &__get_cpu_var(kws);
> +	if (!kws->pending) {
> +		kws->pending = 1;
> +		call_rcu(&kws->head, __wake_up_klogd);
> +	}
> +	local_irq_restore(flags);
>  }
> 
>  /**
> 
> 
