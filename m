Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYKSUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYKSUK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYKSUKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:10:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYKSUKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:10:18 -0500
Date: Wed, 19 Nov 2008 21:09:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, heukelum@fastmail.fm,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081119200959.GA31867@elte.hu>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain> <20081119103415.GA16516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119103415.GA16516@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> What _clearly_ sucks is the current mess of:
> 
>         CFI_ADJUST_CFA_OFFSET   8
>         /*CFI_REL_OFFSET        ss,0*/
>         pushq %rax /* rsp */
>         CFI_ADJUST_CFA_OFFSET   8
>         CFI_REL_OFFSET  rsp,0
>         pushq $(1<<9) /* eflags - interrupts on */
>         CFI_ADJUST_CFA_OFFSET   8
>         /*CFI_REL_OFFSET        rflags,0*/
>         pushq $__KERNEL_CS /* cs */
>         CFI_ADJUST_CFA_OFFSET   8
>         /*CFI_REL_OFFSET        cs,0*/
>         pushq \child_rip /* rip */
>         CFI_ADJUST_CFA_OFFSET   8
>         CFI_REL_OFFSET  rip,0
>         pushq   %rax /* orig rax */
>         CFI_ADJUST_CFA_OFFSET   8
> 
> Compared to what we could have (stupid mockup):
> 
>         pushq_cf1 %rax			/* rsp */
>         pushq_cf1 $(1<<9)		/* eflags - interrupts on */
>         pushq_cf1 $__KERNEL_CS		/* cs */
>         pushq_cf2 \child_rip		/* rip */
>         pushq_cf1 %rax			/* orig rax */
> 
> Whoever claims that this cannot be automated in _large_ part isnt 
> thinking it through really. Those CFI annotations should never have 
> been added in this form.

Something like this would be a lot cleaner equivalent replacement:

         PUSHQ %rax			/* rsp 			  */
         PUSHQ $(1<<9)			/* eflags - interrupts on */
         PUSHQ $__KERNEL_CS		/* cs 			  */
         PUSHQ \child_rip		/* rip			  */
          cfi_map rip, 0
         PUSHQ %rax			/* orig rax		  */

as most of the really annoying CFI annotations in entry_64.S that 
obscruct code reading are just plain CFA offset modifications related 
to stack shuffling.

[ Sidenote: trying to connect up RIP like that in the FAKE_STACK_FRAME
  is pretty wrong to begin with - the annotation is incomplete up to
  this point. ]

The problems are not caused by the prologue or epilogue annotations, 
nor by any of the trickier stack shuffling annotations we do around 
syscall/sysret and around exception frames. A lot of the frame formats 
we use are special, controlled by hw details and we do have to map 
those details to the debuginfo - it's an inevitably manual piece of 
work.

It's the plain crappy:

        pushq %rdi
        CFI_ADJUST_CFA_OFFSET 8
        call schedule
        popq  %rdi
        CFI_ADJUST_CFA_OFFSET -8

annotation spam that hurts readability the most. The "+8" and "-8" 
CFA-offset lines are completely uninformative and they obsctruct the 
reading of this already very trick type of source code (assembly 
language).

It should be something like this:

        PUSHQ %rdi
        call schedule
        POPQ %rdi

instead.

	Ingo
