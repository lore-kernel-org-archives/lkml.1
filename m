Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXFLLPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXFLLPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXFLLO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:14:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:5680 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXFLLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tl3YqQdJrKJiFsm+WTle/Jmb2zJORpkABw1eFtdfBzQlipgB+rqLBqcw+pCGAk6a0nevsx65IXKUREcBAy72EUugpCrPenLvCwLwriEyN2q0nBFty14Qpwl8lvIOvLVZNPcC4iV3UWMi+sEmzkVXykRpSgNGYCylyjaz4mtg80s=
Message-ID: <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
Date: Tue, 12 Jun 2007 16:44:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, "Sam Ravnborg" <sam@ravnborg.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <466E6BDF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E6BDF.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> .. which modpost is warning about.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
>  arch/i386/kernel/cpu/intel_cacheinfo.c    |    6 +++---
>  arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  arch/i386/kernel/cpu/mtrr/generic.c       |    2 +-
>  arch/i386/kernel/cpu/mtrr/main.c          |    2 +-
>  arch/i386/kernel/smpboot.c                |    2 +-
>  arch/x86_64/kernel/mce.c                  |    6 +++---
>  arch/x86_64/mm/init.c                     |    2 +-
>  7 files changed, 11 insertions(+), 11 deletions(-)

> +++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/intel_cacheinfo.c
>
>  /* will only be called once; __init is safe here */
> -static int __init find_num_cache_leaves(void)
> +static int noinline __init_refok find_num_cache_leaves(void)

Same __init_refok semantics confusion here ...

This time the actual issue is a __cpuinit -> __init transition in the call
chain, so the proper fix would be to mark find_num_cache_leaves() as
__cpuinit also. Also, the comment above it must be kept consistent
with the function's annotation.

> @@ -448,7 +448,7 @@ static void __cpuinit cache_shared_cpu_m
> -static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
> +static void __cpuexit cache_remove_shared_cpu_map(unsigned int cpu, int index)

You might've done this because the caller of
cache_remove_shared_cpu_map() is cache_remove_dev()
which is __cpuexit. However, cache_remove_dev() itself is called
from cacheinfo_cpu_callback() which is ... __cpuinit, because it's
caller cache_sysfs_init() is *definitely* __cpuinit. What a mess ...

device_initcall(cache_sysfs_init):

__cpuinit cache_sysfs_init
  -> __cpuinit cacheinfo_cpu_callback  <======== PROBLEM
    -> __cpuexit cache_remove_dev  <======== PROBLEM
      -> __cpuinit cache_remove_shared_cpu_map

Where cacheinfo_cpu_callback() itself is the callback for the
cacheinfo_cpu_notifier notifier, which is itself marked __cpuinitdata.

I suspect the __cpuexit-marking of cache_remove_dev() here is totally
bogus. When !CONFIG_HOTPLUG_CPU, __cpuexit == __exit, and
__exit simply means that the function can be discarded and ignored
from being linked in for non-modular (built-in) build of that particular
module. I'm not sure how the code in question here can ever be built
as a module, so cache_remove_dev shouldn't be a __cpuexit in the
first place. But not marking it anything would take us back to the
modpost warnings. So ... something needs to be done about the
logic in this whole place ...

I did some more code inspection and found:

The cacheinfo_cpu_notifier itself is called out from _cpu_down() which
is ... yep, *not* __cpuinit (and obviously *cannot* be so). _cpu_down()
is called from cpu_down() which is (thankfully!) protected inside
#ifdef CONFIG_HOTPLUG_CPU, so we've /just about/ escaped trouble
so far, but another of it's callers is disable_nonboot_cpus() which does
*not* depend on HOTPLUG_CPU, but is #ifdef'ed inside SUSPEND_SMP
(gargh!) instead, and ... is _not_ __cpuinit either (obviously, again).

I got tired at that point, and stopped following the code around :-)

[ Crazy suggestion: why not just simply do away with this whole
init-section-freeing-after-initcalls / exit-section-not-linked-if-built-in
business itself?!?! I mean, it's 2007, memory is cheap, and we
only save a few 100KB at most but get so many kernel developer
man-hours totally wasted on all of this in return, which could
instead be better utilized, definitely. Anybody listening? ]

> @@ -461,7 +461,7 @@ static void __cpuinit cache_remove_share
>  }
>  #else
>  static void __init cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
> -static void __init cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
> +static void __exit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}

So this shouldn't be __exit either. BTW you could continue to use
__cpu{init, exit} variants for consistency's sake here too. Note that
!SMP => !HOTPLUG_CPU => __cpu{init, exit} become just the same
as the {__init, __exit} automatically.

> --- linux-2.6.22-rc4/arch/i386/kernel/cpu/mcheck/therm_throt.c
> +++ 2.6.22-rc4-x86-init-attribs/arch/i386/kernel/cpu/mcheck/therm_throt.c
> @@ -150,7 +150,7 @@ static __cpuinit int thermal_throttle_cp
>         return NOTIFY_OK;
>  }
>
> -static struct notifier_block thermal_throttle_cpu_notifier =
> +static __cpuinitdata struct notifier_block thermal_throttle_cpu_notifier =
>  {
>         .notifier_call = thermal_throttle_cpu_callback,
>  };

If this is made __cpuinitdata, then thermal_throttle_init_device()
that references it must also be made __cpuinit (it is presently
simply __init). These patches are on 22-rc4, right?

Note that this is another cpu_chain notifier callback, and called
out from non-__{cpu}init functions (as discussed above) so could
be problematic.


> -void get_mtrr_state(void)
> +void __init get_mtrr_state(void)

> -void mtrr_bp_init(void)
> +void __init mtrr_bp_init(void)

These two changes seem to be OK.
Should've been a separate patch, IMHO.

> --- linux-2.6.22-rc4/arch/x86_64/kernel/mce.c
>
> -static void mce_remove_device(unsigned int cpu)
> +static __cpuexit void mce_remove_device(unsigned int cpu)

Again, __cpuexit might not be what we want here ...

>  /* Get notified when a cpu comes on/off. Be hotplug friendly. */
> -static int
> +static __cpuinit int
>  mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)

> -static struct notifier_block mce_cpu_notifier = {
> +static __cpuinitdata struct notifier_block mce_cpu_notifier = {
>         .notifier_call = mce_cpu_callback,
>  };

It's the same (problematic) notifier / remove_dev idiom all over again ...

> --- linux-2.6.22-rc4/arch/x86_64/mm/init.c
>
> -void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
> +void *__init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)

This one's correct again.

Satyam
