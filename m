Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZCKLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZCKLxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZCKLxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:53:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZCKLxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:53:31 -0400
Date: Wed, 11 Mar 2009 12:53:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090311115300.GH2282@elte.hu>
References: <20090310170716.GC22897@elte.hu> <Pine.LNX.4.44L0.0903101537170.4325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101537170.4325-100000@iolanthe.rowland.org>
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


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > * Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > > Speaking of switch_to_thread_hw_breakpoint(), i dont like 
> > > > that function at all:
> > > > 
> > > > - why does it have to do a list of debug registers?
> > > 
> > > I'm not sure I understand the point of this question.  Are you 
> > > asking why the hw_breakpoint structures are stored on a list?  
> > > Because there can be an arbitrarily large number of them.
> > 
> > But that does not make much sense. There's just 4 hardware 
> > registers. There's no sane way to overcommit them hence we 
> > _should not_.
> 
> The number of hardware registers will vary according to the 
> architecture.  Our intention was to make the hardware 
> breakpoint interface architecture-neutral, as nearly as 
> possible.  Hence we decided to let callers register arbitrary 
> numbers of breakpoints, and inform them when the breakpoints 
> actually got installed in or uninstalled from the debug 
> registers.

This may sound as handwaving, but the thing is, it's best to do 
these kinds of things gradually. Keep it clean, design for sane 
hardware first (and x86, as a rare exception i guess, is rather 
sane when it comes to hw debug features), add quirks on an 
as-needed basis.

That principle is _especially_ true when a feature with 
borderline utility is merged. We had to do that with KGDB: had 
to strip down a decade of cruft and it really helped.

> If you think this design decision is a bad one, we can discuss 
> it.  But Roland should be involved, because it is in large 
> part his design.

Sure.

> > > > - why does it worry about IPIs arriving when context-switches on 
> > > >   x86 are always done with interrupts disabled?
> > > 
> > > The routine gets invoked at times other than during a 
> > > context switch.  However you may be right that these times 
> > > are all mutually exclusive.  If so then a good deal of 
> > > complication can be removed.
> > 
> > Yes.
> 
> After looking through it more carefully, I think you're right 
> -- if a kernel breakpoint change does occur while 
> switch_to_thread_hw_breakpoint() is running then the IPI will 
> arrive immediately afterward, so there's no need to check for 
> it explicitly.  (When this was written I probably wasn't aware 
> that interrupts are disabled during context switches.)  So all 
> the stuff involving "goto restart" can be removed.

Good - that certainly makes the code we execute during 
context-switch a lot more palatable.

	Ingo
