Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100Ab0A2CC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0A2CC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762Ab0A2CC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:02:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:49811 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0A2CC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:02:56 -0500
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1264721088.10385.1.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:23:05 +1100
Message-ID: <1264728185.20211.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 17:24 -0600, Joel Schopp wrote:
> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> there is performance benefit to idling the higher numbered threads in
> the core.  
> 
> This patch implements arch_scale_smt_power to dynamically update smt
> thread power in these idle cases in order to prefer threads 0,1 over
> threads 2,3 within a core.

Almost there :-) Joel, Peter, can you help me figure something out tho ?

On machine that don't have SMT, I would like to avoid calling
arch_scale_smt_power() at all if possible (in addition to not compiling
it in if SMT is not enabled in .config).

Now, I must say I'm utterly confused by how the domains are setup and I
haven't quite managed to sort it out... it looks to me that
SD_SHARE_CPUPOWER is always going to be set on all CPUs when the config
option is set (though each CPU will have its own domain) or am I
misguided ? IE. Is there any sense in having at least a fast exit path
out of arch_scale_smt_power() for non-SMT CPUs ?

Joel, can you look at compiling it out when SMT is not set ? We don't
want to bloat SMP kernels for 32-bit non-SMT embedded platforms.

Oh, and one minor nit:

> Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
> ---
> Version 2 addresses style and optimization, same basic functionality
> Version 3 adds a comment, resent due to mailing format error
> Index: linux-2.6.git/arch/powerpc/kernel/smp.c
> ===================================================================
> --- linux-2.6.git.orig/arch/powerpc/kernel/smp.c
> +++ linux-2.6.git/arch/powerpc/kernel/smp.c
> @@ -620,3 +620,59 @@ void __cpu_die(unsigned int cpu)
>  		smp_ops->cpu_die(cpu);
>  }
>  #endif

 ^^^ Please add the /* CONFIG_CPU_HOTPLUG */ (or whatever it is) that's
missing after that #endif :-)

Cheers,
Ben.


