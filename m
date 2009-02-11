Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZBKKOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZBKKOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZBKKOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:14:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48281 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZBKKOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:14:05 -0500
Date: Wed, 11 Feb 2009 11:13:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: Use pt_regs pointer in
	do_device_not_available()
Message-ID: <20090211101359.GG20518@elte.hu>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-2-git-send-email-brgerst@gmail.com> <499281B5.2070502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499281B5.2070502@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Brian.
> 
> Brian Gerst wrote:
> > The generic exception handler (error_code) passes in the pt_regs
> > pointer and the error code (unused in this case).  The commit
> > "x86: fix math_emu register frame access" changed this to pass by
> > value, which doesn't work correctly with stack protector enabled.
> > Change it back to use the pt_regs pointer.
> > 
> > Signed-off-by: Brian Gerst <brgerst@gmail.com>
> > ---
> >  arch/x86/include/asm/traps.h |    2 +-
> >  arch/x86/kernel/traps.c      |    9 +++++----
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> > index cf3bb05..0d53425 100644
> > --- a/arch/x86/include/asm/traps.h
> > +++ b/arch/x86/include/asm/traps.h
> > @@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
> >  dotraplinkage void do_overflow(struct pt_regs *, long);
> >  dotraplinkage void do_bounds(struct pt_regs *, long);
> >  dotraplinkage void do_invalid_op(struct pt_regs *, long);
> > -dotraplinkage void do_device_not_available(struct pt_regs);
> > +dotraplinkage void do_device_not_available(struct pt_regs *, long);
> >  dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
> >  dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
> >  dotraplinkage void do_segment_not_present(struct pt_regs *, long);
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index 3b7b2e1..71a8f87 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -905,19 +905,20 @@ void math_emulate(struct math_emu_info *info)
> >  }
> >  #endif /* CONFIG_MATH_EMULATION */
> >  
> > -dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
> > +dotraplinkage void __kprobes
> > +do_device_not_available(struct pt_regs *regs, long error_code)
> 
> What do you think about just taking pt_regs and accessing
> regs->orig_eax instead of having separate call convention for pt_regs
> ones and trap ones?  Too much work without enough benefit?

Looks worthwile to me. [ Cleanups rarely have clear benefits of their own,
it's the sheer mass of them that makes a difference in the end. Like the
many snowflakes that can bend a tree ;-) ]

There's one small namespace complication here: it's pt_regs->orig_eax on
32-bit and pt_regs->orig_rax on 64-bit.

So i'd suggest the introduction of an anonymous union "error_code" field
which overlays orig_eax and that can be used just fine from unified code too.
That would also be more readable.

Or we could rename orig_eax/orig_rax to error_code. (it might be a bit
confusing in the syscall entry context though.)

	Ingo
