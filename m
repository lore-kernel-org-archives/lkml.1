Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXDJDvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXDJDvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXDJDvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:51:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXDJDvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:51:47 -0400
Date: Mon, 9 Apr 2007 20:51:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Preemption Broken:  centrino_target busted under SMP on
 2.6.20.4
Message-Id: <20070409205136.75709d3e.akpm@linux-foundation.org>
In-Reply-To: <20070410030823.GA16229@redhat.com>
References: <46155CFF.70701@wolfmountaingroup.com>
	<20070405205034.GB3605@redhat.com>
	<20070409172651.9bc619d6.akpm@linux-foundation.org>
	<20070410023108.GA14081@redhat.com>
	<20070409194142.88f0a5e5.akpm@linux-foundation.org>
	<20070410030500.GA15509@redhat.com>
	<20070410030823.GA16229@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 23:08:23 -0400 Dave Jones <davej@redhat.com> wrote:

>  > This whole file is going away in .22, and we have a viable alternative in
>  > .21 (acpi-cpufreq), so I'm not overly worried about fixing this up
>  > given it only shows up in debug kernels, especially at this stage in -rc.
>  > 
>  > (Yeah, it's a cop-out, but unless someone with more interest in this problem
>  >  steps up, I've bigger fishes to fry).
> 
> One last try...
> (I didn't think too long about this, so this might be equally busted,
>  but if so, see comment above).
> 
> 	Dave
> 
> diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
> index f43b987..38e31ce 100644
> --- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
> +++ b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
> @@ -720,11 +720,13 @@ static int centrino_target (struct cpufreq_policy *policy,
>  			cpu_set(j, set_mask);
>  
>  		set_cpus_allowed(current, set_mask);
> +		preempt_disable();
>  		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
>  			dprintk("couldn't limit to CPUs in this domain\n");
>  			retval = -EAGAIN;
>  			if (first_cpu) {
>  				/* We haven't started the transition yet. */
> +				preempt_enable();
>  				goto migrate_end;
>  			}
>  			break;
> @@ -765,6 +767,7 @@ static int centrino_target (struct cpufreq_policy *policy,
>  			break;
>  
>  		cpu_set(j, covered_cpus);
> +		preempt_enable();
>  	}
>  

Yes, I expect that should squish the warnings.  It looks all racy wrt cpu hotplug
and against async set_cpus_allowed(), but if those are our worst problems, we're
good.
