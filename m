Return-Path: <linux-kernel-owner+w=401wt.eu-S938457AbXHHVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938457AbXHHVqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbXHHVql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:46:41 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63541 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652AbXHHVqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:46:40 -0400
Subject: Re: [PATCH RT] Only run softirqs from the irq thread if the irq
	affinity is set to 1 CPU
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <200708081416.27500.dvhltc@us.ibm.com>
References: <1186605752.29097.18.camel@localhost.localdomain>
	 <200708081416.27500.dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 17:45:29 -0400
Message-Id: <1186609529.14769.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 14:16 -0700, Darren Hart wrote:

> It seems to me that this patch will reduce the frequency of irqd/softirqd 
> starvation, but the core problem still exists: softirq tasks can't migrate to 
> other CPUs to perform their work if a higher priority task preempts them.  
> I'm wondering if we want to keep special casing things to minimize the 
> problem or not - seems to me the worst case is still the same - and isn't the 
> worst case the only case that matters (for -rt)?
> 

softirq tasks should never migrate to other CPUs. A softirq exists in
every CPU. So if you trigger a softirq on CPU1 it will only run on CPU1.
If a high priority task preempts it, that same softirq can still run on
other CPUS. Only the thread that was preempted wont switch. But that's
the characteristic of softirqs, and that's how people who use them in
development expect them to work.

The problem with the IRQ thread, is that there exists only one. If you
preempt it, it will not run anywhere. Even if we tried to do something
like the softirqs where we put one on every CPU, you still have the IRQ
itself masked, and if the IRQ thread gets preempted, that IRQ wont
happen again on another CPU.

Now, I can see a problem with softirqs still being on one CPU, because
we basically have the same problem if a softirq gets preempted while
holding a mutex.  Other softirqs must wait for the RT task that
preempted a softirq finishes. This could cause problems as well.
Especially if the designer of the RT app doesn't understand this.

/me will make a note of this in his RT chapter on "Building Embedded
Linux Systems".

-- Steve


