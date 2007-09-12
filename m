Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXILWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXILWdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXILWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:33:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39161 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbXILWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:33:11 -0400
Date: Wed, 12 Sep 2007 15:33:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] local_t protection (critical section)
In-Reply-To: <20070905130411.GB11880@Krystal>
Message-ID: <Pine.LNX.4.64.0709121530220.3835@schroedinger.engr.sgi.com>
References: <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
 <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
 <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
 <20070827222715.GA16982@Krystal> <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
 <20070904200429.GD8157@Krystal> <Pine.LNX.4.64.0709041344040.6376@schroedinger.engr.sgi.com>
 <20070905130411.GB11880@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Mathieu Desnoyers wrote:

> Index: linux-2.6-lttng/include/asm-generic/local.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-generic/local.h	2007-09-04 15:32:02.000000000 -0400
> +++ linux-2.6-lttng/include/asm-generic/local.h	2007-09-05 08:50:47.000000000 -0400
> @@ -46,6 +46,15 @@ typedef struct
>  #define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
>  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
>  
> +#define local_enter_save(flags) local_irq_save(flags)
> +#define local_exit_restore(flags) local_irq_restore(flags)
> +#define local_enter() local_irq_disable()
> +#define local_exit() local_irq_enable()
> +#define local_nest_irq_save(flags) (flags)
> +#define local_nest_irq_restore(flags) (flags)
> +#define local_nest_irq_disable()
> +#define local_nest_irq_enable()
> +

This list is going to increase with RT support in SLUB? Argh.


> Index: linux-2.6-lttng/include/asm-i386/local.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-i386/local.h	2007-09-04 15:28:52.000000000 -0400
> +++ linux-2.6-lttng/include/asm-i386/local.h	2007-09-05 08:49:19.000000000 -0400
> @@ -194,6 +194,23 @@ static __inline__ long local_sub_return(
>  })
>  #define local_inc_not_zero(l) local_add_unless((l), 1, 0)
>  
> +#define local_enter_save(flags) \
> +	do { \
> +		(flags); \
> +		preempt_disable(); \
> +	} while (0)


> +#define local_exit_restore(flags) \
> +	do { \
> +		(flags); \
> +		preempt_enable(); \
> +	} while (0)


This does not result in warnings because a variable is not used or used 
uninitialized?
