Return-Path: <linux-kernel-owner+w=401wt.eu-S934269AbXHHODe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269AbXHHODe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbXHHODX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:03:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435AbXHHODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:03:22 -0400
Date: Wed, 8 Aug 2007 16:03:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Message-ID: <20070808140319.GF14419@one.firstfloor.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com> <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com> <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com> <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com> <20070808133001.GD14419@one.firstfloor.org> <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 09:47:05AM -0400, Steven Rostedt wrote:
> /me working very hard to get lguest64 ready for public display
> 
> Here's a snippet from my version of core.c.  I've been thinking of ways to
> optimize it, but for now it works fine. This was done for both ring 3 and
> ring 1 lguest versions (this is the host running):
> 
> 
> 	/*
> 	 * Update the LSTAR to point to the HV syscall handler.
> 	 * Also update the fsbase if the guest uses one.
> 	 */
> 	wrmsrl(MSR_LSTAR, (unsigned long)HV_OFFSET(&lguest_syscall_trampoline));
> 
> [...]
> 	asm volatile ("pushq %2; pushq %%rsp; pushfq; pushq %3; call *%6;"
> 		      /* The stack we pushed is off by 8, due to the
> previous pushq */
> 		      "addq $8, %%rsp"

Weird stack inbalance, i'm surprised that works. %6 must be doing strange
things.

> 	/* Need to read manual, does rdmsr clear
> 	 * the top 32 bits of rax? */
> 	xor	%rax, %rax
> 
> 	movl  	$MSR_GS_BASE,%ecx
> 	rdmsr


This seems incredibly slow. Since GS changes are controlled in 
the kernel why don't you just cache them in the per cpu area? 
The only case where user can reload it is using segment
selector changes, which can be also handled.

Also why do you need the guest gs value anyways? 

You could just use your own stack and let the guest
switch to its own.

-Andi
