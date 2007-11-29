Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXK2SKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXK2SKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761861AbXK2SKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:10:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763627AbXK2SKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:10:37 -0500
Date: Thu, 29 Nov 2007 10:09:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: <474EF824.3020806@redhat.com>
Message-ID: <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Chuck seems to have caught a bug, although the wrong one:

On Thu, 29 Nov 2007, Chuck Ebbert wrote:
>
> On 11/28/2007 07:42 PM, Roland McGrath wrote:
> > --- a/arch/x86/ia32/ptrace32.c
> > +++ b/arch/x86/ia32/ptrace32.c
> > ...
> > +		if (child == current)
> > +			load_gs_index(child->thread.gsindex);

This is correct.

But the ones that do the same thing for fs/es/ds are *not*. Those three 
registers are kernel mode registers (ds/es are the regular kernel data 
segment, fs is the per-cpu data segment), and restored on return to user 
space from the stack.

For similar reasons, this is wrong:

> > @@ -129,15 +137,23 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
> >  	switch (regno) {
> >  	case offsetof(struct user32, regs.fs):
> >  		*val = child->thread.fsindex;
> > +		if (child == current)
> > +			asm("movl %%fs,%0" : "=r" (*val));
> >  		break;

That %fs is the kernel per-cpu thing, not the user %fs.

But this one is correct:

> >  	case offsetof(struct user32, regs.gs):
> >  		*val = child->thread.gsindex;
> > +		if (child == current)
> > +			asm("movl %%gs,%0" : "=r" (*val));
> 
> Won't this return the kernel's GS instead of the user's?

No, %gs is untouched by the kernel, so it contains user space version, and 
getting the value directly from %gs looks correct.

		Linus
