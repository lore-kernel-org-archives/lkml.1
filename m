Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZCMEzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZCMEzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZCMEzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:55:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZCMEze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:55:34 -0400
Date: Fri, 13 Mar 2009 05:55:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090313045516.GA27326@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903131316.26455.rusty@rustcorp.com.au> <20090313032015.GD18760@elte.hu> <200903131504.09388.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903131504.09388.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 13 March 2009 13:50:15 Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > On Friday 13 March 2009 11:27:43 Ingo Molnar wrote:
> > > > 
> > > > * Rusty Russell <rusty@rustcorp.com.au> wrote: 
> > > > > Missing a core patch (it even got a compile warning with that 
> > > > > config).
> > > > So it's manual work and sometimes i notice them amongst a 
> > > > boatload of other warnings, sometimes i dont.
> > > 
> > > Me too :( I thought you were starting a de-warning tree?  I'd 
> > > be happy to send you patches (particularly, exporting 
> > > deprecated symbols should not give a warning!).
> > 
> > Yeah - i have a de-warning tree, but it's not yet fully up and 
> > running for -tip qa automation.
> > 
> > > > > But there's something else wrong.  Firing up my 64-bit 
> > > > > test box now.
> > > > 
> > > > Great - so you can reproduce. Thanks,
> > > 
> > > Yep, and I'm running some stress tests as well now.
> > > 
> > > Perhaps throw away that tree, and I'll feed you a new one (the 
> > > core patch needs to go at the front), but I can work either 
> > > way.
> > 
> > Ok, i dropped it back to d95c357.
> > 
> > Suggestion for future workflow: we wouldnt have these somewhat 
> > stressful (and stressful to you mostly!), large hickups and 
> > history-less trees if you sent stuff more gradually and not so 
> > close to the merge window. You exposed some of your changes to 
> > linux-next but that's not nearly enough testing in practice for 
> > x86-affecting patches.
> 
> Yes, I wanted to complete the patchset to make sure I wasn't going to hit
> some subtle problem.
> 
> OK, please check the first patch (it's a new addition, I *think* using
> the topology_* macros is right here), and the other change is:
> 
> Here's the other change: it's a little ugly (AFAICT boot_cpu_data isn't
> even *used* on 64 bit, so a cleanup may be in order):
> 
> +++ b/arch/x86/kernel/smpboot.c
> @@ -329,6 +329,23 @@ notrace static void __cpuinit start_seco
>  	cpu_idle();
>  }
>  
> +#ifdef CONFIG_CPUMASK_OFFSTACK
> +/* In this case, llc_shared_map is a pointer to a cpumask. */
> +static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
> +				    const struct cpuinfo_x86 *src)
> +{
> +	struct cpumask *llc = dst->llc_shared_map;
> +	*dst = *src;
> +	dst->llc_shared_map = llc;
> +}
> +#else
> +static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
> +				    const struct cpuinfo_x86 *src)
> +{
> +	*dst = *src;
> +}
> +#endif /* CONFIG_CPUMASK_OFFSTACK */
> +
>  /*
>   * The bootstrap kernel entry code has set these up. Save them for
>   * a given CPU
> @@ -338,7 +355,7 @@ void __cpuinit smp_store_cpu_info(int id
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(id);
>  
> -	*c = boot_cpu_data;
> +	copy_cpuinfo_x86(c, &boot_cpu_data);
>  	c->cpu_index = id;
>  	if (id != 0)
>  		identify_secondary_cpu(c);
> 
> BTW, these didn't go thru linux-next: your testing is better and your
> tree is too different or me to ask Stephen to merge.
> 
> Thanks!
> Rusty.
> 
> The following changes since commit d95c3578120e5bc4784069439f00ccb1b5f87717:
>   Ingo Molnar (1):
>         Merge branch 'x86/core' into cpus4096
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86.git cpus4096

Pulled, thanks Rusty!

Will let you know if something breaks.

	Ingo
