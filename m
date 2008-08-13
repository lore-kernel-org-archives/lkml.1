Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYHMQr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYHMQr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYHMQru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:47:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYHMQrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:47:49 -0400
Date: Wed, 13 Aug 2008 18:47:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
Message-ID: <20080813164728.GD5720@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131141.18003.mark.langsdorf@amd.com>
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


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> When a CPU core is shut down, all of its caches need to be flushed to 
> prevent stale data from causing errors if the core is resumed. Current 
> Linux suspend code performs an assignment after the flush, which can 
> add dirty data back to the cache.  On some AMD platforms, additional 
> speculative reads have caused crashes on resume because of this dirty 
> data.
> 
> Relocate the cache flush to be the very last thing done before 
> halting.

nice catch! Applied to x86/urgent.

I'm really curious: how did you find this bug? Did you see a CPU come up 
as !CPU_DEAD?

> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Acked-by: Mark Borden <mark.borden@amd.com>
> Acked-by: Michael Hohmuth <michael.hohmuth@amd.com>
> 
> diff -r f3f819497a68 arch/x86/kernel/process_64.c
> --- a/arch/x86/kernel/process_64.c	Thu Aug 07 04:24:53 2008 -0500
> +++ b/arch/x86/kernel/process_64.c	Tue Aug 12 07:11:36 2008 -0500
> @@ -93,11 +93,11 @@ static inline void play_dead(void)
>  static inline void play_dead(void)
>  {
>  	idle_task_exit();
> -	wbinvd();
>  	mb();
>  	/* Ack it */
>  	__get_cpu_var(cpu_state) = CPU_DEAD;
>  
> +	wbinvd();
>  	local_irq_disable();
>  	while (1)
>  		halt();

please send a patch for the 32-bit side too, it has the same bug.

also, we might be safer if the wbinvd(), the CLI and the halt was in a 
single assembly sequence:

	if (cpu >= i486)
		asm ("cli; wbinvd; cli; 1: hlt; jmp 1b")
	else
		asm ("cli; 1: hlt; jmp 1b")

to make sure the compiler doesnt ever insert something into this 
codepath? [ And note the double cli which would be further 
robustification - in theory we could get a spurious interrupt straight 
after the wbinvd. ] Hm?

	Ingo
