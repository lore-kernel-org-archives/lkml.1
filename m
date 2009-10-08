Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZJHMvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZJHMvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbZJHMvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:51:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:34273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZJHMvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:51:40 -0400
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
In-Reply-To: <20091008124456.GA13307@Krystal>
References: <20091006233733.153341605@gentwo.org>
	 <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins>
	 <20091007124628.GB27363@Krystal>
	 <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
	 <20091007150257.GA8508@Krystal>
	 <alpine.DEB.1.10.0910071102590.9984@gentwo.org>
	 <20091007151940.GA10052@Krystal>
	 <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
	 <1254988350.26976.256.camel@twins>  <20091008124456.GA13307@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 14:53:55 +0200
Message-Id: <1255006435.26976.309.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 08:44 -0400, Mathieu Desnoyers wrote:
> Even if only done with interrupt off, and check resched is called after
> each irq enable following this critical section ? I'd like to understand
> the reason behind your rejection for this specific case.

No, the thing you proposed:

> preempt disable()
> fast path attempt
>   if (fast path already taken) {
>     local_irq_save();
>     preempt_enable_no_resched();
>     slow path {
>       if (!flags & GFP_ATOMIC) {
>         local_irq_enable();
>         preempt_check_resched();
>         ...
>         local_irq_disable();
>       }
>     }
>     local_irq_restore();
>     preempt_check_resched();
>     return;
>   }
> preempt_enable()

Seems ok.

I just don't get why Christoph is getting all upset about the
need_resched() check in preempt_enable(), its still cheaper than poking
at the interrupt flags.
