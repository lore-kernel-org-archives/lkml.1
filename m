Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYARBQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYARBQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYARBPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:15:54 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:62688 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYARBPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ckj2bitdPv6FNHD9woPvWH2bTo7/NjnEhZAgy+u78xUL8oBDS4tRYnXv93ctkxOhSUt5kF/Ii8e47I8IrxPy/tlbMODnL9doLn/13weck32X43/D+N0BC8nUz35vu4MjwsYVGroaEw93KnmxBKhhbOIWH7XAn/11eU39yUJhmfA=
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <478FF9F3.9030604@zytor.com>
References: <1200611078.5724.46.camel@brick>  <478FDE76.3070309@zytor.com>
	 <1200612389.5724.63.camel@brick>  <478FF9F3.9030604@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 17:15:52 -0800
Message-Id: <1200618952.5724.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland actually put on CC this time.

On Thu, 2008-01-17 at 19:59 -0500, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > 
> > Sorry, missed that detail in ptrace.h, I notice now.
> > 
> > Is there some better way this could be organized, would the following
> > be an improvement, as opposed to two long ifdef sections?
> > 
> > Patch will follow if you think it's a good idea.
> 
> It is actually quite a bit easier to read.

I'll send along a patch along soon, any thoughts on how to order it in
the file?

> 
> > 
> > static inline unsigned long stack_pointer(struct pt_regs *regs)
> > {
> > #ifdef CONFIG_X86_32
> > 	return (unsigned long)regs;
> > #else
> > 	return regs->sp;
> > #endif
> > }
> 
> This one is kind of strange.  In particular, the 32-bit definition isn't 
> exactly what one would expect.  It makes me concerned that it actually 
> refers to two different kinds of stack pointers?

This tripped up the kprobes unification as well, see the stack_addr()
helper that was introduced there.  Would be good to figure this out
and put a big fat comment on it.

kprobes.c

#ifdef CONFIG_X86_64
#define stack_addr(regs) ((unsigned long *)regs->sp)
#else
/*
 * "&regs->sp" looks wrong, but it's correct for x86_32.  x86_32 CPUs
 * don't save the ss and esp registers if the CPU is already in kernel
 * mode when it traps.  So for kprobes, regs->sp and regs->ss are not
 * the [nonexistent] saved stack pointer and ss register, but rather
 * the top 8 bytes of the pre-int3 stack.  So &regs->sp happens to
 * point to the top of the pre-int3 stack.
 */
#define stack_addr(regs) ((unsigned long *)&regs->sp)
#endif

> > /* still need a define here, as one is long and one is unsigned long.
> >  * but this is another target for unification I guess. */
> > #define regs_return_value(regs) ((regs)->ax)
> 
> Indeed...

I think this comes out of Roland's patches unifying some names eip/rip,
eax/rax, etc.

CC'd in case he felt like more work ;-)

Harvey

