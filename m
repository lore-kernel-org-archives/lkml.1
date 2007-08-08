Return-Path: <linux-kernel-owner+w=401wt.eu-S933363AbXHHRJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbXHHRJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXHHRIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:08:53 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:39081 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXHHRIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:08:52 -0400
Date: Wed, 8 Aug 2007 13:07:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <20070808140319.GF14419@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0708081228570.7744@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
 <20070808133001.GD14419@one.firstfloor.org> <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
 <20070808140319.GF14419@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 8 Aug 2007, Andi Kleen wrote:

> On Wed, Aug 08, 2007 at 09:47:05AM -0400, Steven Rostedt wrote:
> >
> > [...]
> > 	asm volatile ("pushq %2; pushq %%rsp; pushfq; pushq %3; call *%6;"
> > 		      /* The stack we pushed is off by 8, due to the
> > previous pushq */
> > 		      "addq $8, %%rsp"
>
> Weird stack inbalance, i'm surprised that works. %6 must be doing strange
> things.

Heh, no it's very subtle. We do the "push %rsp" after the "push %2". So on
return from the call, the stack that was pushed, is really 8 bytes off.
Because we didn't save the stack pointer from the entry of the asm, we
saved it after doing that "push %2". :-)

We get back to this call via a retq from the HV switcher code. So that rsp
that was pushed will be the stack.


>
> > 	/* Need to read manual, does rdmsr clear
> > 	 * the top 32 bits of rax? */
> > 	xor	%rax, %rax
> >
> > 	movl  	$MSR_GS_BASE,%ecx
> > 	rdmsr
>
>
> This seems incredibly slow. Since GS changes are controlled in
> the kernel why don't you just cache them in the per cpu area?
> The only case where user can reload it is using segment
> selector changes, which can be also handled.
>
> Also why do you need the guest gs value anyways?

I did a swapgs here, so we have the HV GS value. I don't know of an easy
way to read the GS value to put it into the RSP.

>
> You could just use your own stack and let the guest
> switch to its own.

Well, it is quite complex, since we can't save anything in the writable
section that the guest can't also write to. Remember, we are in ring 1 for
the guest kernel, so we have no protection. All the host related stuff is
in read only sections when we are using the guest cr3.

What I would like to do is have the GS point to the read only section, and
load the RSP from a value there. But first we need to store the old value
of RSP.  The problem is, where do you store it. Hmm, I guess I can create
my own "big" offset from the read only section :)

OK this gives me an idea, I *can* point the kernel GS to the vcpu read
only section, and have a way to store the value with the GS offset. The
read only section is always mapped before the read write section, so it
should be easy to calculate the diff!

Thanks for the comment, you guided me to this great idea!

-- Steve

