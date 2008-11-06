Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYKFNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYKFNqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYKFNqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:46:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYKFNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:46:42 -0500
Date: Thu, 6 Nov 2008 08:46:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
In-Reply-To: <20081106075754.GE8459@elte.hu>
Message-ID: <alpine.DEB.1.10.0811060845340.31011@gandalf.stny.rr.com>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com> <20081105130113.GB29548@elte.hu> <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com> <20081106075754.GE8459@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Nov 2008, Ingo Molnar wrote:
> 
> * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> 
> > > is this some special warning you added? The stock kernel certainly 
> > > does not emit this warning.
> > 
> > Yes - it's my personal debug checker that tries to watch wether irq 
> > & irqsafe are running in pair. So it shows a warning if there is a 
> > call of spin_lock_irq and irq is already dissabled.
> 
> btw., i have added lockdep instrumentation for this two years ago, 
> it's in the upstream kernel:
> 
> /proc/lockdep_stats: redundant hardirq ons:                7744
> /proc/lockdep_stats: redundant hardirq offs:            1873736
> /proc/lockdep_stats: redundant softirq ons:                   0
> /proc/lockdep_stats: redundant softirq offs:                  0
> 
> you could extend the code to trace it. See 
> kernel/lockdep.c:trace_hardirqs_on_caller(). This bit does it:
> 
>         if (unlikely(curr->hardirqs_enabled)) {
>                 debug_atomic_inc(&redundant_hardirqs_on);
>                 return;
>         }
> 
> you could add a ftrace_printk("redundant hardirq") call right there, 
> enable ftrace, and enable stack tracing of each trace entry:

Quick note. Currently ftrace_printk only shows up if it is set in the 
iter_ctrl.

  echo trace_printk > /debug/tracing/iter_ctrl

I'll send out a patch to have it on by default.

-- Steve

> 
>  echo stacktrace > /debug/tracing/iter_ctrl
> 
> then you should see all the call sites in /debug/tracing/trace.
> 
> 	Ingo
> 
> 
