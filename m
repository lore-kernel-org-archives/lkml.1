Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbXLTXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbXLTXur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760937AbXLTXu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:50:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760770AbXLTXu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:50:27 -0500
Date: Fri, 21 Dec 2007 00:47:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071220234759.GA29776@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220145415.f737e7f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Yes - I don't know why the smp_processor_id() test has suddenly 
> started triggering in there.

it's a "must not happen".

here:

>  		__raw_spin_lock(&die.lock);
>  		raw_local_save_flags(flags);
> -		die.lock_owner = smp_processor_id();
> +		die.lock_owner = raw_smp_processor_id();

we just disabled irqs with raw_local_save_flags().


here:

>  mem_parity_error(unsigned char reason, struct pt_regs * regs)
>  {
>  	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
> -		"CPU %d.\n", reason, smp_processor_id());
> +		"CPU %d.\n", reason, raw_smp_processor_id());
>  	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");

we are straight into an NMI which has hardirqs disabled.


>  	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
> -		"CPU %d.\n", reason, smp_processor_id());
> +		"CPU %d.\n", reason, raw_smp_processor_id());

ditto.

> @@ -708,7 +708,7 @@ void __kprobes die_nmi(struct pt_regs *r
>  	bust_spinlocks(1);
>  	printk(KERN_EMERG "%s", msg);
>  	printk(" on CPU%d, ip %08lx, registers:\n",
> -		smp_processor_id(), regs->ip);
> +		raw_smp_processor_id(), regs->ip);

same.

it needs to be found out why the preempt_count suddenly went to zero. Is 
task struct corruption out of question?

	Ingo
