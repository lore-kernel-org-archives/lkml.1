Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757931AbYLPVu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYLPVu4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYLPVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:50:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYLPVup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:50:45 -0500
Date: Tue, 16 Dec 2008 22:50:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace
	in ring_buffer_time_stamp()
Message-ID: <20081216215033.GV14787@elte.hu>
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu> <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/16 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Impact: prevent a trace recursion
> >>
> >> After some tests with function graph tracer under x86-32, I saw some recursions
> >> caused by ring_buffer_time_stamp() that calls preempt_enable_no_notrace() which
> >> calls preempt_schedule() which is traced itself.
> >>
> >> This patch re-enables preemption without rescheduling.
> >>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >> ---
> >>  kernel/trace/ring_buffer.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > applied to tip/tracing/ftrace, thanks Frederic!
> >
> > Does this explain+fix the weird crashes/reboots you were seeing?
> >
> >        Ingo
> >
> 
> No, actually the functions tracers are protected against recursion,
> but rescheduling attempts
> during all trace insertions (and moreover a call to
> prepare_ftrace_return with cancelled insertion)
> is a useless payload.
> 
> The hard reboots I've seen are related to x86-64 while 
> disabling/reenabling a CPU through /sys/device/system/cpu No tracer was 
> enabled at these times (the problem still remains with latest updates on 
> -tip for half an hour).
> 
> One other thing: I've seen these pointless calls to preempt_schedule 
> while testing the function graph tracer on VirtualBox. Since it provides 
> virtual serial lines, it was more easy to debug than usual (I haven't 
> any serial line on my box). The function graph tracer hangs on 
> VirtualBox with a x86-32 -tip. It seems that the tracing is too slow and 
> so hrtimer_interrupt() does an eternal loop, assuming that a new time 
> update has to be done (because too much time elapsed during th tracing) 
> after each iteration. I'm not sure what to do...disabling tracing for 
> hrtimers or....

reduce HZ?

	Ingo
