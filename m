Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYHHRtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYHHRtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbYHHRtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:49:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbYHHRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:49:22 -0400
Date: Fri, 8 Aug 2008 10:48:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>  <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>  <1206382547.6437.131.camel@lappy>  <20080324115738.85c72bb5.akpm@linux-foundation.org>  <1218202249.8625.106.camel@twins> 
 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>  <1218215454.8625.133.camel@twins>  <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:
> +
> +	local_irq_save(flags);
> +	kws = &__get_cpu_var(kws);
> +	if (!kws->pending) {
> +		call_rcu(&kws->head, __wake_up_klogd);
> +		kws->pending = 1;

In case we have a recursive oops in the RCU paths, I'd think we'd be 
*much* better off with

	if (!kws->pending) {  
		kws->pending = 1;
		call_rcu(&kws->head, __wake_up_klogd);
	}

in order to not re-enter the RCU paths again and causing endless oopses 
along with list corruption.

Hmm?

Oh, and I don't see the point of the irqsave/restore in __wake_up_klogd(). 
Or the BUG_ON(), for that matter (even if it ever were to trigger, we'd be 
better off _not_ triggering it - I agree with it in a "verifying the new 
implementation works at all" sense, but not in a "this is actually for 
merging" kind of patch).

			Linus
