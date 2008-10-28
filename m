Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYJ1UnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYJ1UnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYJ1UnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:43:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYJ1UnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:43:05 -0400
Date: Tue, 28 Oct 2008 10:23:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ftrace doesn't work anymore on latest tip
In-Reply-To: <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810281015260.29482@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>  <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>  <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com> <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:

> 2008/10/28 Fr?d?ric Weisbecker <fweisbec@gmail.com>:
> > 2008/10/28 Steven Rostedt <rostedt@goodmis.org>:
> >>
> >> On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:
> >>
> >>> Hi,
> >>>
> >>> I tried to launch the function tracer with the latest -tip.
> >>> With DYNAMIC_FTRACE (I just tried one time), I set "function" to
> >>> current_trace and it blocks during writing. I can't
> >>> even switch to another console.
> >>> Without DYNAMIC_FTRACE I can set the tracer to function but it doesn't
> >>> produce any trace, even on trace or tracing_pipe.
> >>>
> >>> My config is in attachment.
> >>> I will try some revert...or some other tracers.

I've tried this with and without dynamic ftrace and can not reproduce.

> >>>
> >>
> >>
> >> You might want to update your config (make oldconfig?) The latest tip has
> >> FUNCTION_TRACER instead of FTRACE.
> >>
> >> Also, the config you sent me, does not even have FTRACE on :-/
> >>
> >> CONFIG_HAVE_FTRACE=y
> >> CONFIG_HAVE_DYNAMIC_FTRACE=y
> >> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> >> CONFIG_TRACER_MAX_TRACE=y
> >> CONFIG_RING_BUFFER=y
> >> CONFIG_TRACING=y
> >> # CONFIG_FTRACE is not set
> >> # CONFIG_IRQSOFF_TRACER is not set
> >> # CONFIG_PREEMPT_TRACER is not set
> >> # CONFIG_SYSPROF_TRACER is not set
> >> CONFIG_SCHED_TRACER=y
> >> CONFIG_CONTEXT_SWITCH_TRACER=y
> >
> > Sorry I sent a config for the mainline.
> > This new one is the right.
> >
> 
> One other point: I can't assign the sched_switch tracer.

I found the cause of this. It was:

 c2931e05ec5965597cbfb79ad332d4a29aeceb23

 ftrace: return an error when setting a nonexistent tracer

Because the write of sched_switch has more charachters than the max 
(because of the whitespace at the end), then we chop what we read from 
userspace. Since we do not cosume all what was written, the 'echo' writes 
the rest again. But this time it's just the whitespace. This fails to 
match, even though we did match before. And we return -EINVAL. But the 
funny part is that you can cat the file again, you will see that it 
succeeded!

I'll write a patch to fix this.

-- Steve


> echo sched_switch > current_tracer returns -EINVAL with
> CONFIG_DYNAMIC_FTRACE disabled (didn't tested with enabled).
> 
> I will check that more deeper when I'll have more time.
> 
> 
