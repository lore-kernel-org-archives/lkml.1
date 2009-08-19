Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbZHSBBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbZHSBBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZHSBBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:01:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbZHSBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:01:36 -0400
Date: Tue, 18 Aug 2009 18:01:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Rendezvous all the cpu's for MTRR/PAT init
Message-Id: <20090818180107.29d3f39b.akpm@linux-foundation.org>
In-Reply-To: <1250641835.2744.56.camel@sbs-t61.sc.intel.com>
References: <1250641835.2744.56.camel@sbs-t61.sc.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 17:30:35 -0700 Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Please consider applying this patch after the clockevents bugfix posted
> yesterday http://marc.info/?l=linux-kernel&m=125054497316006&w=2
> 
> thanks,
> suresh
> ---
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: Rendezvous all the cpu's for MTRR/PAT init
> 
> SDM Vol 3a section titled "MTRR considerations in MP systems" specifies
> the need for synchronizing the logical cpu's while initializing/updating
> MTRR.
> 
> Currently Linux kernel does the synchronization of all cpu's only when
> a single MTRR register is programmed/updated. During an AP online
> (during boot/cpu-online/resume)  where we initialize all the MTRR/PAT registers,
> we don't follow this synchronization algorithm.
> 
> This can lead to scenarios where during a dynamic cpu online, that logical cpu
> is initializing MTRR/PAT with cache disabled (cr0.cd=1) etc while other logical
> HT sibling continue to run (also with cache disabled because of cr0.cd=1
> on its sibling).
> 
> Starting from Westmere, VMX transitions with cr0.cd=1 don't work properly
> (because of some VMX performance optimizations) and the above scenario
> (with one logical cpu doing VMX activity and another logical cpu coming online)
> can result in system crash.
> 
> Fix the MTRR initialization by doing rendezvous of all the cpus. During
> boot and resume, we delay the MTRR/PAT init for APs till all the
> logical cpu's come online and the rendezvous process at the end of AP's bringup,
> will initialize the MTRR/PAT for all AP's.
> 
> For dynamic single cpu online, we synchronize all the logical cpus and
> do the MTRR/PAT init on the AP that is coming online.
> 
> ...
>
> @@ -880,7 +880,12 @@ void __cpuinit identify_secondary_cpu(st
>  #ifdef CONFIG_X86_32
>  	enable_sep_cpu();
>  #endif
> +	/*
> +	 * mtrr_ap_init() uses smp_call_function. Enable interrupts.
> +	 */
> +	local_irq_enable();
>  	mtrr_ap_init();
> +	local_irq_disable();
>  }

Ick.

It's quite unobvious (to me) that this function is reliably called with
local interrupts disabled.

If it _is_ reliably called with interrupts disabled then why is it safe
to randomly reenable them here?  Why not just stop disabling interrupts
at the top level?

>
> ...
>
> +void mtrr_aps_init(void)
> +{
> +	if (!use_intel())
> +		return;
> +
> +	/*
> +	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
> +	 * but this routine will be called in cpu boot time, holding the lock
> +	 * breaks it. This routine is called in two cases: 1.very earily time
> +	 * of software resume, when there absolutely isn't mtrr entry changes;
> +	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
> +	 * prevent mtrr entry changes
> +	 */

That's a tantalising little comment.  What does "breaks it" mean?  How
can reviewers and later code-readers possibly suggest alternative fixes
to this breakage if they aren't told what it is?

> +	set_mtrr(~0U, 0, 0, 0);
> +	mtrr_aps_delayed_init = 0;
> +}
> +
> +void mtrr_bp_restore(void)
> +{
> +	if (!use_intel())
> +		return;
> +
> +	mtrr_if->set_all();
> +}
> +
>
> ...
>
> --- tip.orig/kernel/cpu.c
> +++ tip/kernel/cpu.c
> @@ -413,6 +413,14 @@ int disable_nonboot_cpus(void)
>  	return error;
>  }
>  
> +void __attribute__((weak)) arch_enable_nonboot_cpus_begin(void)
> +{
> +}
> +
> +void __attribute__((weak)) arch_enable_nonboot_cpus_end(void)
> +{
> +}

Please use __weak.


