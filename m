Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYHMRim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYHMRim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYHMRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:38:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYHMRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:38:24 -0400
Date: Wed, 13 Aug 2008 19:38:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
Message-ID: <20080813173812.GB30911@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <200808131209.57534.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131209.57534.mark.langsdorf@amd.com>
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

> > to make sure the compiler doesnt ever insert something into this 
> > codepath? [ And note the double cli which would be further 
> > robustification - in theory we could get a spurious interrupt 
> > straight after the wbinvd. ] Hm?
> 
> I don't think it's necessary.  I can submit a delta patch later if you 
> think it's really necessary.

this sequence:

> diff -r 1e74a821dd00 arch/x86/kernel/process_32.c
> --- a/arch/x86/kernel/process_32.c	Tue Aug 12 12:04:12 2008 -0500
> +++ b/arch/x86/kernel/process_32.c	Wed Aug 13 06:40:00 2008 -0500
> @@ -95,11 +95,11 @@ static inline void play_dead(void)
>  {
>  	/* This must be done before dead CPU ack */
>  	cpu_exit_clear();
> -	wbinvd();
>  	mb();
>  	/* Ack it */
>  	__get_cpu_var(cpu_state) = CPU_DEAD;
>  
> +	wbinvd();
>  	/*
>  	 * With physical CPU hotplug, we should halt the cpu
>  	 */

is still unsafe somewhat, as the cli only comes afterwards:

        local_irq_disable();
        while (1)
                halt();

so there's a small race open for some stray irq to come before the CLI.

Also, any of the primitives could be instrumented in theory and more 
code could be inserted - it's really the best approach to unify them 
into a single primitive, like the wbinvd_halt() API i suggested in the 
previous mail.

And it deserves a few comments as well.

	Ingo
