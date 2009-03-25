Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbZCYROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbZCYROT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZCYROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:14:08 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55428 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZCYROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w5+INZfziXyzJFGWIb03lepwjODI52acJApy79rFexpQIGuTWRn4xhCzlElQbL8T+y
         S511aucRkJpSkikPtfYqjnWpfaziPuR2hzl0risJiLNXz7UrrinA4qkP6SshkiFPl4Q8
         P05jN7yCBmsrm1+R5tTiGqTROJz57wJhX4mSA=
Date: Wed, 25 Mar 2009 18:13:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325171357.GB5932@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 12:00:24PM -0400, Steven Rostedt wrote:
> 
> On Tue, 24 Mar 2009, Frederic Weisbecker wrote:
> 
> > On Tue, Mar 24, 2009 at 10:48:46PM +0100, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Well it's a very naive listing, there are sometimes some problems. 
> > > > For example on x86-64, I had to save even some non-scratch 
> > > > registers before calling the return hook, I still don't know why.
> > > 
> > > btw., which are those registers?
> > > 
> > > 	Ingo
> > 
> > 
> > I would expect to only save rax,rdi,rsi,rdx,rcx,r8,r9 which
> > are used for parameters.
> > And I had some crashes until I append r10 and r11 which actually are
> > scratch if I'm not wrong, but since they are scratch and are not used for
> > arguments, I thought they didn't need to be saved.
> > 
> > Well, I think there were some code flow cases I was missing.
> > 
> > 
> > The complete code is:
> > 
> > 	movq %rax, (%rsp)
> > 	movq %rcx, 8(%rsp)
> > 	movq %rdx, 16(%rsp)
> > 	movq %rsi, 24(%rsp)
> > 	movq %rdi, 32(%rsp)
> > 	movq %r8, 40(%rsp)
> > 	movq %r9, 48(%rsp)
> > 	movq %r10, 56(%rsp)
> > 	movq %r11, 64(%rsp)
> > 
> > 	call ftrace_return_to_handler
> > 
> > 	movq %rax, 72(%rsp) <-- get original return value
> > 	movq 64(%rsp), %r11
> > 	movq 56(%rsp), %r10
> > 	movq 48(%rsp), %r9
> > 	movq 40(%rsp), %r8
> > 	movq 32(%rsp), %rdi
> > 	movq 24(%rsp), %rsi
> > 	movq 16(%rsp), %rdx
> > 	movq 8(%rsp), %rcx
> > 	movq (%rsp), %rax
> > 	addq $72, %rsp
> 
> This bothers me. In PowerPC 64, all I have is:
> 
> _GLOBAL(return_to_handler)
> 	/* need to save return values */
> 	std	r4,  -24(r1)
> 	std	r3,  -16(r1)
> 	std	r31, -8(r1)
> 	mr	r31, r1
> 	stdu	r1, -112(r1)
> 
> 	bl	.ftrace_return_to_handler
> 	nop
> 
> 	/* return value has real return address */
> 	mtlr	r3
> 
> 	ld	r1, 0(r1)
> 	ld	r4,  -24(r1)
> 	ld	r3,  -16(r1)
> 	ld	r31, -8(r1)
> 
> 	/* Jump back to real return address */
> 	blr
> 
> All I save is the return values (and I'm paranoid with that, by saving 
> both r3 and r4 and not just r3) as well as saving the stack. There should 
> be no reason to save any other registers.
> 
> This is not the same as mcount. mcount varies differently from arch to 
> arch. But this is the return of a function. This is not a mcount call, and 
> really has nothing to do with mcount.
> 
> If you think about it, the return is coming back from a function that 
> should have already saved all the registers that it modifies. The caller 
> of that function (the one we will return to) should have saved any 
> registers that are allowed to be modified by the callee.
> 
> When we call our ftrace_return_to_handler function it too will save any 
> register that it must for callees and restore it on return.
> 
> Perhaps the issue you had with x86_64 was that you did not set up the 
> stack frame properly? And by saving all those registers, it just happen to 
> do it for you?


I don't know. It seems to me that the stack frame is well set.
This is weird.

 
> -- Steve
> 

