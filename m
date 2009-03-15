Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZCOGBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZCOGBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCOGBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:01:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOGBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:01:07 -0400
Date: Sun, 15 Mar 2009 07:00:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090315060044.GE20949@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903132342.42813.rusty@rustcorp.com.au> <20090313152742.GA11800@elte.hu> <200903151326.34114.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903151326.34114.rusty@rustcorp.com.au>
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

> On Saturday 14 March 2009 01:57:42 Ingo Molnar wrote:
> > Note, it might have crashed in a cpu hotplug test i'm conducting 
> > during bootup:
> > 
> > echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> Indeed, thanks!
> 
> Subject: cpumask: fix crash when offlining cpus
> 
> Impact: Fix cpu offline when CONFIG_MAXSMP=y
> 
> Changeset bc9b83dd1f66402b870301c3c7117b9c1484abb4 "cpumask: convert c1e_mask
> in arch/x86/kernel/process.c to cpumask_var_t" contained a bug: c1e_mask is
> manipulated even if C1E isn't detected (and hence not allocated).  This is
> simply fixed by checking for NULL (which gcc optimizes out anyway of
> CONFIG_CPUMASK_OFFSTACK=n, since it knows ce1_mask can never be NULL).
> 
> In addition, fix a leak where select_idle_routine re-allocates (and re-clears)
> c1e_mask on every cpu init.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index cad5431..91a8c26 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -479,7 +479,8 @@ static int c1e_detected;
>  
>  void c1e_remove_cpu(int cpu)
>  {
> -	cpumask_clear_cpu(cpu, c1e_mask);
> +	if (c1e_mask != NULL)
> +		cpumask_clear_cpu(cpu, c1e_mask);
>  }
>  
>  /*
> @@ -556,8 +557,11 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  		pm_idle = mwait_idle;
>  	} else if (check_c1e_idle(c)) {
>  		printk(KERN_INFO "using C1E aware idle routine\n");
> -		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
> -		cpumask_clear(c1e_mask);
> +		/* c1e_mask can only be NULL during boot of first cpu. */
> +		if (c1e_mask == NULL) {
> +			alloc_cpumask_var(&c1e_mask, GFP_KERNEL);

Sigh, there are two bugs here:

   1) what if the GFP_KERNEL allocation fails?

   2) this code is called with interrupts disabled, so a 
      GFP_KERNEL allocation can be lethal.

c1e_mask should stay a static cpumask...

Why do we convert static, standalone masks to cpumask_var?

	Ingo
