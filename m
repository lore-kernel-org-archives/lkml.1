Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZAZXQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZAZXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZAZXQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:16:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZAZXQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:16:16 -0500
Date: Tue, 27 Jan 2009 00:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Swierk <eswierk@aristanetworks.com>, Oleg Nesterov <oleg@redhat.com>
Cc: rml@tech9.net, linux-kernel@vger.kernel.org,
       kpreempt-tech@lists.sourceforge.net
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
	in print_fatal_signal()
Message-ID: <20090126231555.GB6556@elte.hu>
References: <1233010818.14510.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233010818.14510.11.camel@localhost.localdomain>
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


* Ed Swierk <eswierk@aristanetworks.com> wrote:

> With print-fatal-signals=1 on a kernel with CONFIG_PREEMPT=y, sending an
> unexpected signal to a process causes a BUG: using smp_processor_id() in
> preemptible code.
> 
> get_signal_to_deliver() releases the siglock before calling
> print_fatal_signal(), which calls show_regs(), which calls
> smp_processor_id(), which is not supposed to be called from a
> preemptible thread.
> 
> Calling print_fatal_signal() before releasing the siglock avoids this
> problem.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
> 
> ---
> Index: linux-2.6.27.4/kernel/signal.c
> ===================================================================
> --- linux-2.6.27.4.orig/kernel/signal.c
> +++ linux-2.6.27.4/kernel/signal.c
> @@ -1848,6 +1848,11 @@ relock:
>  			continue;
>  		}
>  
> +		if (sig_kernel_coredump(signr) && print_fatal_signals) {
> +			/* hold lock for smp_processor_id() */
> +			print_fatal_signal(regs, info->si_signo);
> +		}
> +
>  		spin_unlock_irq(&sighand->siglock);

This trades a (harmless) debug warning against a potential deadlock or 
even a crash, because print_fatal_signal() can do this:

                        __get_user(insn, (unsigned char *)(regs->ip + i));

which will work without a fault most of the time but might also generate a 
pagefault and schedule away from atomic context.

So please add preempt_disable()+preempt_enable() calls around the 
show_regs() call instead.

	Ingo
