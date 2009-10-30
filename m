Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZJ3CBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZJ3CBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbZJ3CBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 22:01:35 -0400
Received: from mga05.intel.com ([192.55.52.89]:22255 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756506AbZJ3CBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 22:01:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,650,1249282800"; 
   d="scan'208";a="509093642"
Subject: Re: [patch] Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256807691.7158.54.camel@marge.simson.net>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
	 <1256722141.16282.20.camel@ymzhang>
	 <1256739779.7503.59.camel@marge.simson.net>
	 <1256777448.16282.21.camel@ymzhang>
	 <1256795190.7048.63.camel@marge.simson.net>
	 <1256797608.16282.28.camel@ymzhang>
	 <1256807691.7158.54.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Oct 2009 10:02:27 +0800
Message-Id: <1256868147.16282.32.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 10:14 +0100, Mike Galbraith wrote:
> On Thu, 2009-10-29 at 14:26 +0800, Zhang, Yanmin wrote: 
> > On Thu, 2009-10-29 at 06:46 +0100, Mike Galbraith wrote:
> 
> > > SD_PREFER_LOCAL is still on in rc1 though (double checks;), so you'll go
> > > through the power saving code until you reach a domain containing both
> > > waker's cpu and wakee's previous cpu even if that code already found
> > > that a higher domain wasn't overloaded.  Looks to me like that block
> > > wants a want_sd && qualifier. 
> > > 
> > > Even it you turn SD_PREFER_LOCAL off, you can still hit the overhead if
> > > SD_POWERSAVINGS_BALANCE is set, so I'd make sure both are off and see if
> > > that's the source (likely, since the rest is already off).
> > Yes. ﻿SD_POWERSAVINGS_BALANCE is disabled by default. I applied Peter's patch which
> > turning ﻿SD_PREFER_LOCAL off for MC and cpu domain and it doesn't help.
> > perf counter shows ﻿select_task_rq_fair still consumes about 5% cpu time. Eventually,
> > I found for_each_cpu in for_each_domain consumes the 5% cpu time, because Peter's
> > patch doesn't turn off ﻿SD_PREFER_LOCAL for node domain.
> > I turned it off for node domain against the latest tips tree and tbench regression
> > disappears on a Nehalem machine and becomes about 2% on another one.
> > 
> > Can we turn it off for node domain by default?
> 
> If it's hurting fast path overhead to the tune of an order of magnitude,
> I guess there's no choice but to either fix it or turn it off.  Since
> SD_BALANCE_WAKE is off globally, I don't see any point in keeping
> SD_PREFER_LOCAL at any level.
> 
> (That said, what we need is for this to not be so expensive that we
> can't afford it in the fast path).
> 
> sched: Disable SD_PREFER_LOCAL at node level.
> 
> Yanmin Zhang reported that SD_PREFER_LOCAL induces an order of magnitude
> increase in select_task_rq_fair() overhead while running heavy wakeup
> benchmarks (tbench and vmark).  Since SD_BALANCE_WAKE is off at node level,
> turn SD_PREFER_LOCAL off as well pending further investigation. 
Mike,

Thanks a lot! With the patch, we do see much improvement on tbench and volanoMark.

For exmaple, volanoMark has about 8% improvement with tips+the_patch, comparing with
Kernel 2.6.31.

Yanmin

> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> LKML-Reference: <new-submission>
> 
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index d823c24..40e37b1 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -143,7 +143,7 @@ extern unsigned long node_remap_size[];
>  				| 1*SD_BALANCE_FORK			\
>  				| 0*SD_BALANCE_WAKE			\
>  				| 1*SD_WAKE_AFFINE			\
> -				| 1*SD_PREFER_LOCAL			\
> +				| 0*SD_PREFER_LOCAL			\
>  				| 0*SD_SHARE_CPUPOWER			\
>  				| 0*SD_POWERSAVINGS_BALANCE		\
>  				| 0*SD_SHARE_PKG_RESOURCES		\
> 
> 
> 

