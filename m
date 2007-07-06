Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbXGFOfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbXGFOfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXGFOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:35:26 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:52784 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXGFOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:35:25 -0400
Subject: Re: [RFC] Thread Migration Preemption
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <468DDD3A.6010308@yahoo.com.au>
References: <20070705215152.GA4865@Krystal>  <468DDD3A.6010308@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 10:34:55 -0400
Message-Id: <1183732495.17319.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 16:12 +1000, Nick Piggin wrote:
> Mathieu Desnoyers wrote:

> > migration_disable();
> > local_inc(&__get_cpu_var(&my_local_t_var));
> > migration_enable();
> > 

[...]

> This seems like way too much stuff to add just for this type of thing. Why
> not just disable and reenable preempt? Surely local_inc is not going to take
> so long that disabling preemption matters.

For this given example, it may be too much fine tuning. But there are
other things (at least in RT) where this would be very helpful. One
thing is that in RT an IRQ thread might service a softirq if that
softirq thread is of the same priority as the IRQ thread. The difference
between an IRQ thread and a softirq thread is that the IRQ thread may
migrate but the softirq thread may not. So to do this performance
enhancement, we need to temporarily pin the IRQ thread to the CPU, which
is expensive (set_cpus_allowed).  This would make it much simpler and
light weight to implement.

> 
> The task struct is not something we should just be carefree putting crap
> into because it is seemingly free :(
> 

Agreed, but as the subject says "RFC".  Perhaps we can make it a bit
more complex and put this as one of the most significant bits in the
preempt_count. We would just need to mask off that bit in all the archs
when determining if we should preempt or not.  That's more complex, but
keeps the task struct free from more luggage.

-- Steve


