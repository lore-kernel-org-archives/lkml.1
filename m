Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZBJMY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZBJMY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZBJMYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:24:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZBJMYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:24:18 -0500
Date: Tue, 10 Feb 2009 13:23:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The mysterious case of struct irqaction's mask field.
Message-ID: <20090210122332.GA28817@elte.hu>
References: <200902101223.47313.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902101223.47313.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi all,
> 
>    As part of the cpumask conversion, I came across struct irqaction:
> 
> 	struct irqaction {
> 		irq_handler_t handler;
> 		unsigned long flags;
> 		cpumask_t mask;
> 		...
> 	};
> 
> Most people have been setting 'mask' to CPU_MASK_NONE, and I wondered if that
> really meant that they never want this action performed on any CPU.
> 
> But I couldn't find anyone who actually *reads* the 'mask' field.  Tracing
> back, it was converted from an unsigned long to a cpumask_t by wli around
> 2.6.7 ("as it was intended to be").  But that conversion didn't reveal anyone
> actually using the field either.
> 
> At one point, sparc64 seems to have overloaded it for some kind of irq bucket
> scheme.
> 
> Finally, I tracked it back to the creation of (then per-arch) struct irqaction
> in 1.1.82, and this hunk from linux/arch/i386/kernel/irq.c:
> 
> @@ -12,14 +12,7 @@
> 
>  /*
>   * IRQ's are in fact implemented a bit like signal handlers for the kernel.
> - * The same sigaction struct is used, and with similar semantics (ie there
> - * is a SA_INTERRUPT flag etc). Naturally it's not a 1:1 relation, but there
> - * are similarities.
> - *
> - * sa_handler(int irq_NR) is the default function called (0 if no).
> - * sa_mask is horribly ugly (I won't even mention it)
> - * sa_flags contains various info: SA_INTERRUPT etc
> - * sa_restorer is the unused
> + * Naturally it's not a 1:1 relation, but there are similarities.
>   */
> 
>  #include <linux/ptrace.h>
> 
> So, it was never a cpumask at all; just a remanent of the use of sigaction for
> interrupt handlers.  We've been happily setting it throughout the kernel since
> 1995.

Hehe, nice one :-)

> On the assumption that it has failed to coerce the spirits of our ancestors to
> land among us, I'll create a patch to remove it.

Please do.

This seems to be a classic symptom of write-mostly kernel source code :-/

	Ingo
