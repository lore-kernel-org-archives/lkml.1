Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327Ab0AGQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0AGQwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AGQwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:52:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57983 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0AGQww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:52:52 -0500
Date: Thu, 7 Jan 2010 08:52:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107165249.GE6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262853855.4049.86.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:44:15AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-06 at 22:35 -0800, Josh Triplett wrote:
> > 
> > The number of threads doesn't matter nearly as much as the number of
> > threads typically running at a time compared to the number of
> > processors.  Of course, we can't measure that as easily, but I don't
> > know that your proposed heuristic would approximate it well.
> 
> Quite agreed, and not disturbing RT tasks is even more important.

OK, so I stand un-Reviewed-by twice in one morning.  ;-)

> A simple:
> 
>   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
>      if (cpu_curr(cpu)->mm == current->mm)
>         smp_call_function_single(cpu, func, NULL, 1);
>   }
> 
> seems far preferable over anything else, if you really want you can use
> a cpumask to copy cpu_vm_mask in and unset bits and use the mask with
> smp_call_function_any(), but that includes having to allocate the
> cpumask, which might or might not be too expensive for Mathieu.

This would be vulnerable to the sys_membarrier() CPU seeing an old value
of cpu_curr(cpu)->mm, and that other task seeing the old value of the
pointer we are trying to RCU-destroy, right?

							Thanx, Paul
