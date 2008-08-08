Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYHHTQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYHHTQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYHHTPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:15:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbYHHTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:15:53 -0400
Date: Fri, 8 Aug 2008 12:14:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-Id: <20080808121428.646a8b3c.akpm@linux-foundation.org>
In-Reply-To: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
References: <20080324122424.671168000@chello.nl>
	<alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	<1206382547.6437.131.camel@lappy>
	<20080324115738.85c72bb5.akpm@linux-foundation.org>
	<1218202249.8625.106.camel@twins>
	<alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	<1218215454.8625.133.camel@twins>
	<alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	<1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 20:14:28 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

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

Note that kernel/rcupreempt.c's flavour of call_rcu() takes
RCU_DATA_ME().lock, so there are still code sites from which a printk
can deadlock.  Only now, it is config-dependent.

>From a quick look it appears that large amounts of kernel/rcupreempt.c
are now a printk-free zone.

