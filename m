Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbXFZVCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbXFZVCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbXFZVCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:02:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbXFZVB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:01:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Monday, 25 June 2007 11:36:47 -0400 <Pine.LNX.4.44L0.0706251054360.4207-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070626204900.BA6634D05CF@magilla.localdomain>
Date: Tue, 26 Jun 2007 13:49:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> All right, I'll change it.  And I'll encapsulate those fields.  I still 
> think it will accomplish nothing more than hiding some implementation 
> details which don't really need to be hidden.

It makes me a little happier, and I at least consider that a substantial
accomplishment.  ;-)

> It's below.  The patch logs the value of DR6 when each debug interrupt 
> occurs, and it adds another sysfs attribute to the bptest driver.  The 
> attribute is named "test", and it contains the value that the IRQ 
> handler will write back to DR6.  Combine this with the Alt-SysRq-P 
> change already submitted, and you can get a clear view of what's going 
> on.

Thanks.  I haven't played with this.

> I see.  So I could add a CONFIG_HW_BREAKPOINT option and make 
> CONFIG_PTRACE depend on it.  That will be simple enough.

Right.  

> Do you think it would make sense to allow utrace without hw-breakpoint?

Sure.  There's no special reason to want to turn hw-breakpoint off, but
it is a naturally separable option.

> Here's the next iteration.  The arch-specific parts are now completely 
> encapsulated.  validate_settings is in a form which should be workable 
> on all architectures.  And the address, length, and type are passed as 
> arguments to register_{kernel,user}_hw_breakpoint().

I like it!

> I haven't tried to modify Kconfig at all.  To do it properly would
> require making ptrace configurable, which is not something I want to
> tackle at the moment.

You don't need to worry about that.  Under utrace, CONFIG_PTRACE is
already separate and can be turned off.  I don't think we need really to
finish the Kconfig stuff at all before I merge it into the utrace code.

> I changed the Kprobes single-step routine along the lines you 
> suggested, but added a little extra.  See what you think.
[...]
> The test for early termination of the exception handler is now back the
> way it was.  However I didn't change the test for deciding whether to 
> send a SIGTRAP.  Under the current circumstances I don't see how it 
> could ever be wrong.  (On the other hand, the code will end up calling 
> send_sigtrap() twice when a ptrace exception occurs: once in the ptrace 
> trigger routine and once in do_debug.  That won't matter will it?  I 
> would expect send_sigtrap() to be idempotent.)

Calling send_sigtrap twice during the same exception does happen to be
harmless, but I don't think it should be presumed to be.  It is just not
the right way to go about things that you send a signal twice when there
is one signal you want to generate.

Also, send_sigtrap is an i386-only function (not even x86_64 has the
same).  Only x86_64 will share this actual code, but all others will be
modelled on it.  I think it makes things simplest across the board if
the standard form is that when there is a ptrace exception, the notifier
does not return NOTIFY_STOP, so it falls through to the existing SIGTRAP
arch code.

So, hmm.  In the old do_debug code, if a notifier returns NOTIFY_STOP,
it bails immediately, before the db6 value is saved in current->thread.
This is the normal theory of notify_die use, where NOTIFY_STOP means to
completely swallow the event as if it never happened.  In the event
there were some third party notifier involved, it ought to be able to
swallow its magic exceptions as before and have no user-visible db6
change happen at the time of that exception.  So how about this:

	get_debugreg(condition, 6);
	set_debugreg(0UL, 6);		/* The CPU does not clear it.  */

	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
					SIGTRAP) == NOTIFY_STOP)
		return;

The kprobes notifier uses max priority, so it will run first.  Its
notifier code uses my version.  For a single-step that belongs to it,
it will return NOTIFY_STOP and nothing else happens (noone touches
vdr6).  (I think I'm dredging up old territory by asking what happens
when kprobes steps over an insn that hits a data breakpoint, but I
don't recall atm.)

vdr6 belongs wholly to hw_breakpoint, no other code refers to it
directly.  hw_breakpoint's notifier sets vdr6 with non-DR_TRAPn bits,
if it's a user-mode exception.  If it's a ptrace exception it also
sets the mapped DR_TRAPn bits.  If it's not a ptrace exception and
only DR_TRAPn bits were newly set, then it returns NOTIFY_STOP.  If
it's a spurious exception from lazy db7 setting, hw_breakpoint just
returns NOTIFY_STOP early.

The rest of the old do_debug code stays as it is, only clear_dr7 goes.

> Are you going to the Ottawa Linux Symposium?

I am not.

> @@ -484,7 +495,8 @@ int copy_thread(int nr, unsigned long cl
>  
>  	err = 0;
>   out:
> -	if (err && p->thread.io_bitmap_ptr) {
> +	if (err) {
> +		flush_thread_hw_breakpoint(p);
>  		kfree(p->thread.io_bitmap_ptr);
>  		p->thread.io_bitmap_max = 0;
>  	}

This can call kfree(NULL).  I would leave the original code alone, i.e.:

	if (err)
		flush_thread_hw_breakpoint(p);
	if (err && p->thread.io_bitmap_ptr) {
		kfree(p->thread.io_bitmap_ptr);
		p->thread.io_bitmap_max = 0;
	}

> +	set_debugreg(0, 7);

You'll note in my x86-64 patch changing these to 0UL.  It matters for the
asm in the set_debugreg macro that the argument have type long, not int
(which plain 0 has).


Thanks,
Roland
