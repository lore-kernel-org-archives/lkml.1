Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZHUQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZHUQiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbZHUQiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:38:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbZHUQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:38:16 -0400
Subject: Re: [RFC patch] need check TSC wrap unconditionally
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <3877989d0908132115n6d8c7caej4bc4c87ae7701cac@mail.gmail.com>
References: <3877989d0908132115n6d8c7caej4bc4c87ae7701cac@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 18:37:58 +0200
Message-Id: <1250872678.7538.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 12:15 +0800, Luming Yu wrote:
> Hi there,

Hi, thanks for CC'ing the right folks.

> we disabled tsc wrap check on any platform that has NOSTOP_TSC cpu. But this
> will cause some real problem.For example, 1.CPU does has constant and
> non_stop tsc, which means different CPU ticks at same rate in same domain,but
> have been given different initial TSC value.Then at any given time,
> CPUsare unsynchronized.
> 2. if those CPUs are sit in different domain..(multi-chassis cluster system?)
> 
> Please review. If make sense, please apply.

Right, so because your machine is funny, everybody with a good machine
should suffer?

If the TSCs run at identical frequency (one time domain) but at
different offsets, you can fix that by using cyc2ns_offset.

When the machine has unsynchonized frequencies (multiple time domains),
detect that during cpu enumeration and use that to disable the
optimization.

> Signed-off-by: Yu Luming <luming.yu@intel.com>

>  arch/x86/kernel/tsc_sync.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
> index 027b5b4..312ba84 100644
> --- a/arch/x86/kernel/tsc_sync.c
> +++ b/arch/x86/kernel/tsc_sync.c
> @@ -113,11 +113,6 @@ void __cpuinit check_tsc_sync_source(int cpu)
>         if (unsynchronized_tsc())
>                 return;
> 
> -       if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
> -               pr_info("Skipping synchronization checks as TSC is
> reliable.\n");
> -               return;
> -       }
> -
>         pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
>                 smp_processor_id(), cpu);
> 
> @@ -171,7 +166,7 @@ void __cpuinit check_tsc_sync_target(void)
>  {
>         int cpus = 2;
> 
> -       if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
> +       if (unsynchronized_tsc())
>                 return;
> 
>         /*
