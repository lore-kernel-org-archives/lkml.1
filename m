Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbZASNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbZASNST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZASNSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:18:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZASNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:18:04 -0500
Date: Mon, 19 Jan 2009 08:18:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace based hard lockup detector
In-Reply-To: <20090119130442.GA6876@elte.hu>
Message-ID: <alpine.DEB.1.10.0901190815400.27726@gandalf.stny.rr.com>
References: <4973cff5.05a0660a.650c.2f54@mx.google.com> <alpine.DEB.1.10.0901190757330.17050@gandalf.stny.rr.com> <20090119130442.GA6876@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 19 Jan 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Sun, 18 Jan 2009, Frederic Weisbecker wrote:
> > 
> > > Like the NMI watchdog, this feature try to detect hard lockups by
> > > lurking at the non-progress of the timer interrupts.
> > > 
> > > You can enable it at boot time by passing the ftrace_hardlockup parameter.
> > > I plan to add a debugfs file to enable/disable at runtime.
> > > 
> > > When a hardlockup is detected, it will print a backtrace. Perhaps it
> > > would be good to print the locks held from lockdep too?
> > > 
> > > It only support x86 for the moment, because a kind of generic timer interrupt
> > > counter is needed on all archs to have it generic.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Hi Frederic,
> > 
> > This seems like a rewrite of the NMI lockup code. In my debugging, I 
> > simply put ftrace_dump in the NMI lockup, which gives me a ftrace dump 
> > as soon as NMI detects a lockup. I'm a bit confused at what this gives 
> > us over that?
> 
> this is different from the NMI watchdog in a number of ways:
> 
>  - it works on all platforms and in all situations where the NMI watchdog 
>    does not work.
> 
>  - in theory it can detect hard lockups in situations where the NMI 
>    watchdog is disabled, such as suspend/resume or early bootup. 
>    (especially early bootup lockups are nasty and the NMI watchdog is 
>     enabled relatively late)
> 
>  - it could be extended to detect 'soft' lockups too - i.e. we could have 
>    a one-stop facility to detect all kinds of "kernel does not seem to 
>    progress" lockups.
> 
> But it's not as complete as the NMI watchdog: it relies on instrumented 
> function calls rolling on and on during the lockup - that's not the case 
> when we get a hard lockup due to a tight, infinite loop somewhere.

Ah, OK, the check is in the function tracer. Hmm, my logdev code had an 
option to enable tracing at early bootup. Instead of using the normal 
memory alloction for the ring buffer, it needed to use alloc_bootmem. I 
wonder if it would be worth it to allow for a tracer to do the same if it 
needs to be allocated early on (before memory is initialized)?

--Steve

