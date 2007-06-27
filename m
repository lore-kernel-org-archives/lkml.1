Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbXF0Dbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbXF0Dbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXF0Dbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:31:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3106 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751984AbXF0Dbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:31:33 -0400
Date: Tue, 26 Jun 2007 23:26:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070626204900.BA6634D05CF@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706262244100.23864-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Roland McGrath wrote:

> > Here's the next iteration.  The arch-specific parts are now completely 
> > encapsulated.  validate_settings is in a form which should be workable 
> > on all architectures.  And the address, length, and type are passed as 
> > arguments to register_{kernel,user}_hw_breakpoint().
> 
> I like it!

Good.  My earlier stubbornness was caused by a desire to allow static
initializers, but now I see that specifying the values in the
registration call really isn't all that bad.

> > I haven't tried to modify Kconfig at all.  To do it properly would
> > require making ptrace configurable, which is not something I want to
> > tackle at the moment.
> 
> You don't need to worry about that.  Under utrace, CONFIG_PTRACE is
> already separate and can be turned off.  I don't think we need really to
> finish the Kconfig stuff at all before I merge it into the utrace code.

So far this work has all been based on the vanilla kernel.  Should I 
switch over to basing it on -mm?


> Calling send_sigtrap twice during the same exception does happen to be
> harmless, but I don't think it should be presumed to be.  It is just not
> the right way to go about things that you send a signal twice when there
> is one signal you want to generate.

What happens when there are two ptrace exceptions at different points
during the same system call?  Won't we end up sending the signal twice
no matter what?

> Also, send_sigtrap is an i386-only function (not even x86_64 has the
> same).  Only x86_64 will share this actual code, but all others will be
> modelled on it.  I think it makes things simplest across the board if
> the standard form is that when there is a ptrace exception, the notifier
> does not return NOTIFY_STOP, so it falls through to the existing SIGTRAP
> arch code.
> 
> So, hmm.  In the old do_debug code, if a notifier returns NOTIFY_STOP,
> it bails immediately, before the db6 value is saved in current->thread.
> This is the normal theory of notify_die use, where NOTIFY_STOP means to
> completely swallow the event as if it never happened.  In the event
> there were some third party notifier involved, it ought to be able to
> swallow its magic exceptions as before and have no user-visible db6
> change happen at the time of that exception.  So how about this:
> 
> 	get_debugreg(condition, 6);
> 	set_debugreg(0UL, 6);		/* The CPU does not clear it.  */
> 
> 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
> 					SIGTRAP) == NOTIFY_STOP)
> 		return;
> 
> The kprobes notifier uses max priority, so it will run first.  Its
> notifier code uses my version.  For a single-step that belongs to it,
> it will return NOTIFY_STOP and nothing else happens (noone touches
> vdr6).  (I think I'm dredging up old territory by asking what happens
> when kprobes steps over an insn that hits a data breakpoint, but I
> don't recall atm.)

In theory we should get an exception with both DR_STEP and DR_TRAPn 
set, meaning that neither notifier will return NOTIFY_STOP.  But if the 
kprobes handler clears DR_STEP in the DR6 image passed to the 
hw_breakpoint handler, it should work out better.

> vdr6 belongs wholly to hw_breakpoint, no other code refers to it
> directly.  hw_breakpoint's notifier sets vdr6 with non-DR_TRAPn bits,
> if it's a user-mode exception.  If it's a ptrace exception it also
> sets the mapped DR_TRAPn bits.  If it's not a ptrace exception and
> only DR_TRAPn bits were newly set, then it returns NOTIFY_STOP.  If
> it's a spurious exception from lazy db7 setting, hw_breakpoint just
> returns NOTIFY_STOP early.

That sounds not quite right.  To a user-space debugger, a system call
should appear as an atomic operation.  If multiple ptrace exceptions
occur during a system call, all the relevant DR_TRAPn bits should be
set in vdr6 together and all the other ones reset.  How can we arrange
that?

There's also the question of whether to send the SIGTRAP.  If
extraneous bits are set in DR6 (e.g., because the CPU always sets some
extra bits) then we will never get NOTIFY_STOP.  Nevertheless, the
signal should not always be sent.

> > @@ -484,7 +495,8 @@ int copy_thread(int nr, unsigned long cl
> >  
> >  	err = 0;
> >   out:
> > -	if (err && p->thread.io_bitmap_ptr) {
> > +	if (err) {
> > +		flush_thread_hw_breakpoint(p);
> >  		kfree(p->thread.io_bitmap_ptr);
> >  		p->thread.io_bitmap_max = 0;
> >  	}
> 
> This can call kfree(NULL).  I would leave the original code alone, i.e.:
> 
> 	if (err)
> 		flush_thread_hw_breakpoint(p);
> 	if (err && p->thread.io_bitmap_ptr) {
> 		kfree(p->thread.io_bitmap_ptr);
> 		p->thread.io_bitmap_max = 0;
> 	}

I disagree.  kfree() is documented to return harmlessly when passed a
NULL pointer, and lots of places in the kernel have been changed to
remove useless tests for NULL before calls to kfree().  This is just
another example.

> > +	set_debugreg(0, 7);
> 
> You'll note in my x86-64 patch changing these to 0UL.  It matters for the
> asm in the set_debugreg macro that the argument have type long, not int
> (which plain 0 has).

I figured there was some reason like that.

Alan Stern

