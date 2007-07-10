Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbXGJXkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbXGJXkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbXGJXkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:40:09 -0400
Received: from waste.org ([66.93.16.53]:39831 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbXGJXkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:40:08 -0400
Date: Tue, 10 Jul 2007 18:39:39 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070710233938.GT11166@waste.org>
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468DDD3A.6010308@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 04:12:10PM +1000, Nick Piggin wrote:
> Mathieu Desnoyers wrote:
> >Thread Migration Preemption
> >
> >This patch adds the ability to protect critical sections from migration to
> >another CPU without disabling preemption.
> >
> >This will be useful to minimize the amount of preemption disabling for the 
> >-rt
> >patch. It will help leveraging improvements brought by the local_t types in
> >asm/local.h (see Documentation/local_ops.txt). Note that the updates done 
> >to
> >variables protected by migration_disable must be either atomic or 
> >protected from
> >concurrent updates done by other threads.
> >
> >Typical use:
> >
> >migration_disable();
> >local_inc(&__get_cpu_var(&my_local_t_var));
> >migration_enable();
> >
> >Which will increment the variable atomically wrt the local CPU.
> >
> >Comments (such as how to integrate this in the already almost full
> >preempt_count) are welcome.
> 
> This seems like way too much stuff to add just for this type of thing. Why
> not just disable and reenable preempt? Surely local_inc is not going to take
> so long that disabling preemption matters.

I like this patch a lot. Even if we don't add the underlying mechanism
right now, adding migration_disable as an alias for preempt_disable
will much better document quite a number of the users.
 
> The task struct is not something we should just be carefree putting crap
> into because it is seemingly free :(

Sadly, it is free at the moment. We can only fit 3 task_structs in an order-1 SLAB,
with lots of slop.

-- 
Mathematics is the supreme nostalgia of our time.
