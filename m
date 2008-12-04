Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYLDX0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYLDX0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLDX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:26:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYLDX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:26:45 -0500
Date: Thu, 4 Dec 2008 18:26:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/ftrace: don't insert TRACE_PRINT during
 selftests
In-Reply-To: <c62985530812041503g4e6f8fa8uc9b7a1166fd3a907@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812041826210.32726@gandalf.stny.rr.com>
References: <49385E07.7050304@gmail.com>  <alpine.DEB.1.10.0812041752210.32726@gandalf.stny.rr.com> <c62985530812041503g4e6f8fa8uc9b7a1166fd3a907@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 5 Dec 2008, Fr?d?ric Weisbecker wrote:
> >
> > Enable this in the mutex lock, and we could make it a normal int.
> >
> 
> 
> But ftrace_printk can be called from interrupt context. I think we can loose
> some TRACE_PRINT entries at the selftests time since the tracer are not enabled
> by the user at this time, except the boot tracer...

I mean, move it down farther after we acquire the mutex. Should be fine.

-- Steve

> 
> >>               /*
> >>                * Run a selftest on this tracer.
> >>                * Here we reset the trace buffer, and set the current
> >> @@ -603,6 +613,7 @@ int register_tracer(struct tracer *type)
> >>               /* the test is responsible for initializing and enabling */
> >>               pr_info("Testing tracer %s: ", type->name);
> >>               ret = type->selftest(type, tr);
> >> +             atomic_set(&tracing_selftest_running, 0);
> >>               /* the test is responsible for resetting too */
> >>               current_trace = saved_tracer;
> >>               if (ret) {
> >> @@ -3594,7 +3605,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
> >>       unsigned long flags, irq_flags;
> >>       int cpu, len = 0, size, pc;
> >>
> >> -     if (tracing_disabled)
> >> +     if (tracing_disabled || atomic_read(&tracing_selftest_running))
> >>               return 0;
> >>
> >>       pc = preempt_count();
> >> --
> >
> > -- Steve
> >
> >
> 
> 
