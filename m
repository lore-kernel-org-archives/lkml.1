Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYKDMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYKDMnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYKDMne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:43:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYKDMnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:43:33 -0500
Date: Tue, 4 Nov 2008 13:42:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104124242.GA6795@elte.hu>
References: <20081104122839.GA22864@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104122839.GA22864@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Hi all,
> 
> An x86 processor handles an interrupt (from an external source, 
> software generated or due to an exception), depending on the 
> contents if the IDT. Normally the IDT contains mostly interrupt 
> gates. Linux points each interrupt gate to a unique function. Some 
> are specific to some task (handling traps, IPI's, ...), the others 
> are stubs that push the interrupt number to the stack and jump to 
> 'common_interrupt'.
> 
> This patch removes the need for the stubs.

hm, the cost would be this new code:

> +.p2align
> +ENTRY(maininterrupt)
>  	RING0_INT_FRAME
> -vector=0
> -.rept NR_VECTORS
> -	ALIGN
> - .if vector
> -	CFI_ADJUST_CFA_OFFSET -4
> - .endif
> -1:	pushl $~(vector)
> -	CFI_ADJUST_CFA_OFFSET 4
> +	push %eax
> +	push %eax
> +	mov %cs,%eax
> +	shr $3,%eax
> +	and $0xff,%eax
> +	not %eax
> +	mov %eax,4(%esp)
> +	pop %eax
>  	jmp common_interrupt

.. which we were able to avoid before. A couple of segment register 
accesses, shifts, etc to calculate the vector - each of which can be 
quite costly (especially the segment register access - this is a 
relatively rare instruction pattern).

I'm not unconvicable, but we need to be conservative here: could you 
try to measure the full before/after cost of IRQ entry, to the cycle 
level? I'm curious what the performance impact is.

Also, this makes life probably a bit harder for Xen, which assumes 
that the GDT of the guest OS is small-ish. (Jeremy Cc:-ed)

	Ingo
