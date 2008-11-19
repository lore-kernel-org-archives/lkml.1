Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYKSKeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYKSKeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYKSKef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:34:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbYKSKef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:34:35 -0500
Date: Wed, 19 Nov 2008 11:34:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, heukelum@fastmail.fm,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081119103415.GA16516@elte.hu>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118225336.60FFA1544EB@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > but that's the exception. Most of the annotations could be
> > auto-generated.
> 
> Not really.  An implicit .cfi_undefined can be auto-generated for an 
> unannotated instruction with an output register.  An implicit 
> .cfi_register can be auto-generated for an unannotated 
> register-to-register move.  An implicit .cfi_same_value can be 
> auto-generated when you can tell a register is being written with 
> the register or stack slot tha the current CFI state says holds the 
> caller's value of that register.  Beyond that, it gets into either 
> assumptions or hairy analysis of how stack slots are being used and 
> so forth.

i dont buy that argument at all.

Yes, of course full "no changes to the current code at all" automation 
is hard.

But _at minimum_ GAS should automate a large part of this and help us 
out syntactically: make it really easy to human-annotate instructions 
in a _minimal way_. Also, automate the easy bits while at it. Plus 
warn about missing annotations - nesting errors, etc. etc.

there's a ton of easy things GAS could do here that it does not do. 

> [...] Explicit (but simple) macros in the assembly is what I favor.

Yeah. This is the second-best option - but has some limitations. Still 
it is much better than what we have now.

What _clearly_ sucks is the current mess of:

        CFI_ADJUST_CFA_OFFSET   8
        /*CFI_REL_OFFSET        ss,0*/
        pushq %rax /* rsp */
        CFI_ADJUST_CFA_OFFSET   8
        CFI_REL_OFFSET  rsp,0
        pushq $(1<<9) /* eflags - interrupts on */
        CFI_ADJUST_CFA_OFFSET   8
        /*CFI_REL_OFFSET        rflags,0*/
        pushq $__KERNEL_CS /* cs */
        CFI_ADJUST_CFA_OFFSET   8
        /*CFI_REL_OFFSET        cs,0*/
        pushq \child_rip /* rip */
        CFI_ADJUST_CFA_OFFSET   8
        CFI_REL_OFFSET  rip,0
        pushq   %rax /* orig rax */
        CFI_ADJUST_CFA_OFFSET   8

Compared to what we could have (stupid mockup):

        pushq_cf1 %rax			/* rsp */
        pushq_cf1 $(1<<9)		/* eflags - interrupts on */
        pushq_cf1 $__KERNEL_CS		/* cs */
        pushq_cf2 \child_rip		/* rip */
        pushq_cf1 %rax			/* orig rax */

Whoever claims that this cannot be automated in _large_ part isnt 
thinking it through really. Those CFI annotations should never have 
been added in this form.

	Ingo
