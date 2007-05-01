Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXEAQMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXEAQMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXEAQMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:12:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40285 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXEAQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:12:23 -0400
Date: Tue, 1 May 2007 09:15:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-Id: <20070501091538.c14b1cf9.randy.dunlap@oracle.com>
In-Reply-To: <20070430223859.3513d498.akpm@linux-foundation.org>
References: <20070429220132.951cdf7f.randy.dunlap@oracle.com>
	<20070429222354.63265e3f.akpm@linux-foundation.org>
	<20070430081653.60fab0a5.randy.dunlap@oracle.com>
	<20070430165101.6463fee1.randy.dunlap@oracle.com>
	<20070430171229.d514ba19.akpm@linux-foundation.org>
	<46368DC3.5070503@oracle.com>
	<20070430180821.eb269fe3.akpm@linux-foundation.org>
	<20070501034330.GJ25929@bingen.suse.de>
	<20070430221624.dcc7346b.randy.dunlap@oracle.com>
	<20070430222348.de258c98.akpm@linux-foundation.org>
	<20070501062456.GS25929@bingen.suse.de>
	<20070430223859.3513d498.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 22:38:59 -0700 Andrew Morton wrote:

> On Tue, 1 May 2007 08:24:56 +0200 Andi Kleen <ak@suse.de> wrote:
> 
> > > The bug is in firstfloor only, and the fix (if present) will be there too.
> > > 
> > > <checks>
> > > 
> > > Nope,
> > > 
> > > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
> > > 
> > > is identical to
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-sched-clock-share.patch
> > 
> > Or perhaps the deadlock is in the cpufrequency handler. Does it happen without CONFIG_CPUFREQ
> > too?
> > 
> > [cpufreq handler calls ktime_get which might take xtime lock for reading] 
> > 
> 
> Sounds right.  That's what was happening to me for a while.
> 
> Randy, it'd be interesting to try:
> 
> --- a/arch/x86_64/kernel/tsc.c~a
> +++ a/arch/x86_64/kernel/tsc.c
> @@ -84,8 +84,8 @@ static int time_cpufreq_notifier(struct 
>  		cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
>  
>  		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
> -		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> -			mark_tsc_unstable("cpufreq changes");
> +//		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> +//			mark_tsc_unstable("cpufreq changes");
>  	}
>  
>  	return 0;
> _

I don't have CPU_FREQ enabled, so that didn't change anything.


> and if that "fixes" it, disable netconsole and do
> 
> --- a/arch/x86_64/kernel/tsc.c~a
> +++ a/arch/x86_64/kernel/tsc.c
> @@ -85,7 +85,7 @@ static int time_cpufreq_notifier(struct 
>  
>  		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
>  		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> -			mark_tsc_unstable("cpufreq changes");
> +			dump_stack();
>  	}
>  
>  	return 0;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
