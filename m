Return-Path: <linux-kernel-owner+w=401wt.eu-S938263AbXHHVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938263AbXHHVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934637AbXHHVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:16:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39183 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934577AbXHHVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:16:35 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RT] Only run softirqs from the irq thread if the irq affinity is set to 1 CPU
Date: Wed, 8 Aug 2007 14:16:27 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
References: <1186605752.29097.18.camel@localhost.localdomain>
In-Reply-To: <1186605752.29097.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081416.27500.dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 13:42:32 you wrote:
> Ingo and Thomas,
>
> John and I have been discussing all the "run softirq from IRQ thread"
> lately and discovered something nasty.
>
> Now it is a nice optimization to run softirqs from the IRQ thread, but
> it may not be feasible because of the semantics of the IRQ thread
> compared with the softirq thread. Namely, the softirq thread is bound to
> a single CPU and the IRQ thread is not.
>
> We use to think that it would be fine to simply bind an IRQ thread to a
> single CPU, either at the start of the IRQ thread code, or just while it
> is running the softirq code.  But this has a major flaw as John Stultz
> discovered.
>
> If a RT hog that is of higher priority than the IRQ thread preempts the
> IRQ thread while it is bound to the CPU (more likely with the latest
> code that always binds the IRQ thread to 1 CPU), then that IRQ is, in
> essence, masked.  That means no more actions will be taken place by that
> IRQ while the RT thread is running.  Normally, one would expect, that if
> the IRQ has its affinity set to all CPUS, if a RT thread were to preempt
> the IRQ thread and run for a long time, it would be expected that the
> IRQ thread would migrate to another CPU and finish. Letting more
> interrupts from the IRQ line in (remember that the IRQ line is masked
> until the IRQ finishes its handler).
>
> This patch will only run the softirq functions if the IRQ thread and the
> softirq thread have the same priority **and** the IRQ thread is already
> bound to a single CPU.  If we are running on UP or the IRQ thread is
> bound to a single CPU, we already have the possibility of having a RT
> hog starve the IRQ.  But we should not add that scenario when the IRQ
> thread has its affinity set to run on other CPUS that don't have RT hogs
> on them.

It seems to me that this patch will reduce the frequency of irqd/softirqd 
starvation, but the core problem still exists: softirq tasks can't migrate to 
other CPUs to perform their work if a higher priority task preempts them.  
I'm wondering if we want to keep special casing things to minimize the 
problem or not - seems to me the worst case is still the same - and isn't the 
worst case the only case that matters (for -rt)?

-- 
Darren Hart
IBM Linux Technology Center
Realtime Linux Team
