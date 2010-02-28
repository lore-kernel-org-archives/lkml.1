Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032176Ab0B1WYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 17:24:23 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51790 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032129Ab0B1WYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 17:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nUExOgEpNKDC+Tv/eGHF9OecADo/FiFC/Hxi3kcyHh7FWeYyH1451bzBOqw4VgxC66
         k/MisS+RN1H6fb9i44fD8/ANpIloFT1+i8/mXFaMpLMat/Kfs0uXZi6n7oUNh2lsqsA4
         0FlSKEHNwVUM6v5NmgVCQyqs2DBWQDutyFKf8=
Date: Sun, 28 Feb 2010 23:24:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
	fast path
Message-ID: <20100228222412.GD5248@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265188475-23509-11-git-send-regression-fweisbec@gmail.com> <20100204154700.GE6676@linux.vnet.ibm.com> <4B6B84A1.60805@cn.fujitsu.com> <1265363102.22001.286.camel@laptop> <1265363441.22001.300.camel@laptop> <20100205104937.GB29515@elte.hu> <1265371808.22001.502.camel@laptop> <1265371973.22001.508.camel@laptop> <1265374915.22001.562.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265374915.22001.562.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 02:01:55PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-05 at 13:12 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-02-05 at 13:10 +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-02-05 at 11:49 +0100, Ingo Molnar wrote:
> > > > 
> > > > > That said, I'm not at all happy about removing lockdep annotations to make 
> > > > > the tracer faster, that's really counter productive.
> > > > 
> > > > Are there no dynamic techniques that could be used here?
> > > > 
> > > > Lockdep obviously wants maximum instrumentation coverage - performance be 
> > > > damned.
> > > > 
> > > > Lock profiling/tracing/visualization wants the minimum subset of events it is 
> > > > interested in - everything else is unnecessary overhead.
> > > 
> > > Well, they could start by moving the tracepoint inside the lockdep
> > > recursion check.
> > 
> > IIRC the reason its now outside is that you'd loose tracepoint on
> > lockdep_off() usage, but having the tracer folks help on removing any
> > such usage is of course a good thing.
> > 
> > The usage thereof in nmi_enter() doesn't seem like a problem, since
> > you're not supposed to be using locks from nmi context anyway, more so,
> > I'd not be adverse to putting BUG_ON(in_nmi()) in every lockdep hook.
> 
> Another nasty side effect is that it (lockdep recursion) isn't IRQ aware
> in that we don't do any tracking for IRQ's that hit while we're doing
> lockdep. We can fix that using a recursion context like we did for perf,
> that would actually improve lockdep itself too.


Actually, looking at lock_acquire/release/acquired/contended, they are
all performing their job under a raw_lock_irq_save() window, so it
doesn't seem we are losing anything.

Something that could be nice though: dropping this irq saving from the
main window, add the perf style recursion protection, and eventually
have a raw_local_irq_save only when we take internal lockdep locks.
This will let irqs happen during lockdep checks.

I just guess the irq disabled thing is also protecting something else,
something I'll probably discover after testing that :)

