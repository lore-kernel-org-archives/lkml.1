Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZCJUKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZCJUKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZCJUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:10:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48753 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753154AbZCJUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:10:37 -0400
Date: Tue, 10 Mar 2009 16:10:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
 handling code
In-Reply-To: <20090310170716.GC22897@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101537170.4325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > Speaking of switch_to_thread_hw_breakpoint(), i dont like 
> > > that function at all:
> > > 
> > > - why does it have to do a list of debug registers?
> > 
> > I'm not sure I understand the point of this question.  Are you 
> > asking why the hw_breakpoint structures are stored on a list?  
> > Because there can be an arbitrarily large number of them.
> 
> But that does not make much sense. There's just 4 hardware 
> registers. There's no sane way to overcommit them hence we 
> _should not_.

The number of hardware registers will vary according to the
architecture.  Our intention was to make the hardware breakpoint
interface architecture-neutral, as nearly as possible.  Hence we
decided to let callers register arbitrary numbers of breakpoints, and
inform them when the breakpoints actually got installed in or
uninstalled from the debug registers.

If you think this design decision is a bad one, we can discuss it.  But 
Roland should be involved, because it is in large part his design.

> > > - why does it worry about IPIs arriving when context-switches on 
> > >   x86 are always done with interrupts disabled?
> > 
> > The routine gets invoked at times other than during a context 
> > switch.  However you may be right that these times are all 
> > mutually exclusive.  If so then a good deal of complication 
> > can be removed.
> 
> Yes.

After looking through it more carefully, I think you're right -- if a
kernel breakpoint change does occur while
switch_to_thread_hw_breakpoint() is running then the IPI will arrive
immediately afterward, so there's no need to check for it explicitly.  
(When this was written I probably wasn't aware that interrupts are
disabled during context switches.)  So all the stuff involving "goto
restart" can be removed.


> > > - also, what do the ->installed() and ->uninstalled() callbacks 
> > >   do - nothing uses it!
> > 
> > What do you mean?  They do what any callback does.  And of 
> > course nothing uses them -- the code hasn't been merged yet!
> 
> No need to get testy - i'm the maintainer and you are trying to 
> get stuff into two subsystems i maintain. I ask such questions 
> when i see something added that has no immediate purpose.

Email is hopeless for conveying emotional nuances.  I didn't intend 
that statement to sound testy; if it did I apologize.

> If a later patch needs a particular facility then submit it 
> together with that use. It's not that hard to add callbacks - 
> but right now it just distracts from the immediate purpose of 
> these patches.

Prasad can take out the callback parts for now.  And if we do change
the design so that breakpoints don't get installed and uninstalled at
random times then the callbacks won't be needed at all.

> And please dont try to get stuff merged if you are not willing 
> to answer simple questions like that in a constructive way.

Wasn't the remainder of that reply (the part you omitted) constructive?

Alan Stern

