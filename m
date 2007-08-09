Return-Path: <linux-kernel-owner+w=401wt.eu-S939458AbXHIMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939458AbXHIMjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbXHIMjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:39:14 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:48430 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbXHIMjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:39:13 -0400
Date: Thu, 9 Aug 2007 08:38:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert de Vries <robert.h.de.vries@gmail.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RT] Only run softirqs from the irq thread if the irq
 affinity is set to 1 CPU
In-Reply-To: <47db5b910708090249k2c80e3e8tdc062d89ed4359fc@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0708090832070.29847@gandalf.stny.rr.com>
References: <1186605752.29097.18.camel@localhost.localdomain> 
 <200708081416.27500.dvhltc@us.ibm.com>  <1186609529.14769.8.camel@localhost.localdomain>
 <47db5b910708090249k2c80e3e8tdc062d89ed4359fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 9 Aug 2007, Robert de Vries wrote:
> On 8/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Wouldn't a developer of a real-time system configure the system so
> that interrupts do not interfere with the real-time tasks running on a
> specific CPU?

You would think. But that's something that the Linux kernel should expect.
This can happen on a system where it's not no RT, but more soft RT (God I
hate that term). Meaning, the "optimization" of running softirqs as
threads can actually cause longer latencies to the interrupt. Since any
time an RT task preempts the IRQ while running bounded to a CPU, it will
be like masking that interrupt for the full time the RT task is running.

> In other words, is this problem not simply a misconfiguration of the system?
> I personally redirect all interrupts away from the CPU's where my
> real-time tasks run and only allow the interrupts that I want to
> handle in my application on the CPU's where I handle them so as to
> minimize latency.

This can't always be done. Say you only have two CPUS, and there's two RT
tasks that run at high priorities, on each. But it could be period that
the two don't always run at the same time. You don't want to stop
an IRQ when it gets preempted by one of the RT tasks.

So my answer to you is, no, it is not just a misconfiguration of the
system. By making an optimization, we just added a latency that would not
be there without that optimization. And it wouldn't be something that one
would expect.

-- Steve

