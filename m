Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbXFYKxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbXFYKxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXFYKxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:53:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXFYKxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:53:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Tuesday, 19 June 2007 16:35:29 -0400 <Pine.LNX.4.44L0.0706191517260.2672-200000@iolanthe.rowland.org>
X-Windows: you'd better sit down.
Message-Id: <20070625105249.EB5E3D0002@magilla.localdomain>
Date: Mon, 25 Jun 2007 03:52:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "A waste to store one"?  Waste of what?  It isn't a waste of space; the 
> space would otherwise be unused.  Waste of an instruction, perhaps.

Yes.  

> It is now possible for an implementation to store things in a 
> machine-dependent fashion; I have added accessor routines as you 
> suggested.  But I also left the fields as they were; the documentation 
> mentions that they won't necessarily contain any particular values.

People usually read the documentation after the fields named like they can
guess what they contain have values that confuse them, not before.

> You might want to examine the check in validate_settings() for address 
> alignment; it might not be valid if other values get stored in the 
> low-order bits of the address.  This is a tricky point; it's not safe 
> to mix bits around unless you know that the data values are correct, 
> but in validate_settings() you don't yet know that.

This is why I didn't bring up encoded addresses earlier on. :-)  

These kinds of issues are why I prefer unambiguously opaque arch-specific
encodings.  validate_settings is indeed wrong for the natural ppc encoding.

The values must be set by a call that can return an error.  That means you
can't really have a static initializer macro, unless it's intended to mean
"unspecified garbage if not used exactly right".  I favor just going back
to passing three more args to register_kernel_hw_breakpoint.

> Tests show that my CPU does not clear DR_STEP when a data breakpoint is
> hit.  Conversely, the DR_TRAPn bits are cleared even when a single-step 
> exception occurs.

Ok, this is pretty consistent with what the newest Intel manuals say.

> If you're interested, I can send you the code I used to do this testing
> so you can try it on your machine.

Ok.

> > I still think it's the proper thing to make it conditional, not always
> > built in.  But it's a pedantic point.
> 
> We have three things to consider: ptrace, utrace, and hw-breakpoint.  
> Ultimately hw-breakpoint should become part of utrace; we might not
> want to bother with a standalone version.

It is not hard to make it a separate option, so there is no reason not to.

> Furthermore, hw-breakpoint takes over the ptrace's mechanism for
> breakpoint handling.  If we want to allow a configuration where ptrace
> is present and hw-breakpoint isn't, then I would have to add an
> alternate implementation containing only support for the legacy
> interface.

I was not suggesting that.  CONFIG_PTRACE would require HW_BREAKPOINT on
machines where arch ptrace code uses it.

> I made a few other changes to do_debug.  For instance, it no longer 
> checks whether notify_die() returns NOTIFY_STOP.  That check was a 
> mistake to begin with; NOTIFY_STOP merely means to cut the notifier 
> chain short -- it doesn't mean that the debug exception can be ignored.  

This is incorrect.  The usage of notify_die in all other cases, at least of
machine exceptions on x86, is to test for == NOTIFY_STOP and when true
short-circuit the normal effect of the exception (signal, oops).  The
notifiers should return NOTIFY_STOP if they consumed the exception wholly.
If none uses NOTIFY_STOP, then the normal user signal should happen.

> Also it sends the SIGTRAP when any of the DR_STEP or DR_TRAPn bits are 
> set in vdr6; this is now the appropriate condition.

>From what you've said, DR_STEP will remain set on a later debug exception.
So if a non-ptrace hw breakpoint consumed the exception and left no
DR_TRAPn bits set, the thread would generate a second SIGTRAP from the
prior single-step.  Currently userland expects to have to clear DR_STEP in
dr6 via ptrace itself, but does not expect it can get a duplicate SIGTRAP
if it doesn't.


Thanks,
Roland
