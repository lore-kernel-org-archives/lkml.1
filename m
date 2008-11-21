Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYKUPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYKUPjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKUPjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:39:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYKUPjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:39:09 -0500
Date: Fri, 21 Nov 2008 15:38:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Radford <radford@galvanix.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: mcount record based dynamic tracing for ARM
Message-ID: <20081121153827.GA8433@flint.arm.linux.org.uk>
References: <20081118231525.GA16081@blackbean.org> <alpine.DEB.1.10.0811201734050.14652@gandalf.stny.rr.com> <20081120224903.GA3244@blackbean.org> <alpine.DEB.1.10.0811202114560.4464@gandalf.stny.rr.com> <20081121035509.GA5266@blackbean.org> <alpine.DEB.1.10.0811210917380.6447@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811210917380.6447@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 09:27:17AM -0500, Steven Rostedt wrote:
> On Thu, 20 Nov 2008, Jim Radford wrote:
> > -	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> > +	select HAVE_FTRACE_MCOUNT_RECORD
> > +	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
> 
> Russell mentioned something about the code not being compatible with 
> Thumb2, is the above if statement enough?

I think I said (or should've said) "upcoming Thumb 2" - it's not yet in
the kernel but there's a patch series floating around for it.  We've
started on merging some of the pre-requisits, and it will mean that
the instruction length is no longer constant.  (It may be a 16bit or
32bit instruction.)

I suspect that ftrace won't be able to handle that, so it may have to
depend on !THUMB2_KERNEL for the time being.

> > diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> > index 06269ea..06216af 100644
> > --- a/arch/arm/kernel/entry-common.S
> > +++ b/arch/arm/kernel/entry-common.S
> > @@ -104,14 +104,7 @@ ENDPROC(ret_from_fork)
> >  #ifdef CONFIG_FUNCTION_TRACER
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >  ENTRY(mcount)
> > -	stmdb sp!, {r0-r3, lr}
> > -	mov r0, lr
> > -	sub r0, r0, #MCOUNT_INSN_SIZE
> > -
> > -	.globl mcount_call
> > -mcount_call:
> > -	bl ftrace_stub
> > -	ldmia sp!, {r0-r3, pc}
> > +	mov pc, lr
> 
> This looks OK. The new mcount stub for dynamic ftrace is a simple return.
> It has been a while since I've programmed ARM (7 years ago), but I'm 
> assuming that loading the program counter with the link register is 
> a simple return.

Yes, that's all that's required.
