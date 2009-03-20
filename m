Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZCTOAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZCTOAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCTOAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:00:16 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59867 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZCTOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:00:15 -0400
Date: Fri, 20 Mar 2009 15:00:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       "lkml," <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockdep: fix deadlock in lockdep_trace_alloc
Message-ID: <20090320150010.054fa8fc@osiris.boeblingen.de.ibm.com>
In-Reply-To: <1237556700.24626.100.camel@twins>
References: <1237544000.24626.52.camel@twins>
	<1237544798.24626.54.camel@twins>
	<20090320140753.307a3c7d@osiris.boeblingen.de.ibm.com>
	<1237556700.24626.100.camel@twins>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 14:45:00 +0100
Peter Zijlstra <peterz@infradead.org> wrote:
> Subject: lockdep: fix deadlock in lockdep_trace_alloc
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Mar 20 11:24:21 CET 2009
> 
> Heiko reported that we grab the graph lock with irqs enabled.
> 
> Fix this by providing the same wrapper as all other lockdep entry
> functions have.
> 
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2258,7 +2258,7 @@ void trace_softirqs_off(unsigned long ip
>  		debug_atomic_inc(&redundant_softirqs_off);
>  }
> 
> -void lockdep_trace_alloc(gfp_t gfp_mask)
> +static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
>  {
>  	struct task_struct *curr = current;
> 
> @@ -2277,12 +2277,29 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
>  	if (!(gfp_mask & __GFP_FS))
>  		return;
> 
> -	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> +	if (DEBUG_LOCKS_WARN_ON(raw_irqs_disabled_flags(flags)))
>  		return;
> 
>  	mark_held_locks(curr, RECLAIM_FS);
>  }
> 
> +static void check_flags(unsigned long flags);
> +
> +void lockdep_trace_alloc(gfp_t gfp_mask)
> +{
> +	unsigned long flags;
> +
> +	if (unlikely(current->lockdep_recursion))
> +		return;
> +
> +	raw_local_irq_save(flags);
> +	check_flags(flags);
> +	current->lockdep_recursion = 1;
> +	__lockdep_trace_alloc(gfp_mask, flags);
> +	current->lockdep_recursion = 0;
> +	raw_local_irq_restore(flags);
> +}
> +

This one works ;)

Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
