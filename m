Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYGMGsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYGMGsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYGMGsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:48:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYGMGsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:48:14 -0400
Date: Sun, 13 Jul 2008 08:48:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix numaq_tsc_disable calling
Message-ID: <20080713064803.GB13949@elte.hu>
References: <200807122252.55436.yhlu.kernel@gmail.com> <20080713062537.GB2534@elte.hu> <86802c440807122331t60ff315dn698e6c04bce2599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807122331t60ff315dn698e6c04bce2599@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sat, Jul 12, 2008 at 11:25 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >>       if (cpu_has_bts)
> >>               ptrace_bts_init_intel(c);
> >> +
> >> +#ifdef CONFIG_X86_NUMAQ
> >> +     numaq_tsc_disable();
> >> +#endif
> >
> > could you please one more cleanup and hide the CONFIG_X86_NUMAQ in the
> > header file, so that we can just call numaq_tsc_disable() without an
> > #ifdef?
> >
> > also, that TSC quirk should probably be turned into an explicit quirk
> > function pointer initialized by the early-init NUMAQ code and left NULL
> > by everything else - like we it on visws. See include/asm-x86/setup.h:
> >
> >  /*
> >  * Any setup quirks to be performed?
> >  */
> >  extern int (*arch_time_init_quirk)(void);
> >  extern int (*arch_pre_intr_init_quirk)(void);
> >  extern int (*arch_intr_init_quirk)(void);
> >  extern int (*arch_trap_init_quirk)(void);
> >  extern char * (*arch_memory_setup_quirk)(void);
> >  extern int (*mach_get_smp_config_quirk)(unsigned int early);
> >  extern int (*mach_find_smp_config_quirk)(unsigned int reserve);
> >
> > the goal is to offload all non-standard setup that is not a reasonable
> > deviation of some of the major vendors to such a quirk handler. Quirks
> > are a lot easier to maintain and a lot easier to think about - they can
> > be just by-line functionality to the main body of default behavior.
> 
> looks neat.
> 
> can we use one big arch_mach_quicks struct..?

yeah, good idea.

Perhaps name it x86_quirks to make it really short to check it. Then 
consolidate all of our scattered quirks into it. I bet we could get some 
of the paravirt details into this as well.

So something like:

        if (arch_time_init_quirk) {
                /*
                 * A nonzero return code does not mean failure, it means
                 * that the architecture quirk does not want any
                 * generic (timer) setup to be performed after this:
                 */
                if (arch_time_init_quirk())
                        return;
        }

Would turn into:

	if (x86_quirks.time_init) {
		if (x86_quirks.time_init())
			return;
	}
	[ ... regular init ...]

So that the return code of x86_quirks.time_init() can be used to signal 
whether a quirk wants the regular init to run or not. In the VisWS case 
this allowed further consolidation.

We dont want any chaining (i.e. dont use notifiers or anything) as these 
quirks are all exclusive anyway.

	Ingo
