Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZJFJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZJFJG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZJFJG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZJFJGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:06:25 -0400
Message-ID: <4ACB0833.2050203@redhat.com>
Date: Tue, 06 Oct 2009 11:04:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com> <1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 02:50 AM, Jeremy Fitzhardinge wrote:
> This patch allows the pvclock mechanism to be used in usermode.  To
> do this, we map an extra page into usermode containing an array of
> pvclock_vcpu_time_info structures which give the information required
> to compute a global system clock from the tsc.  With this, we can
> implement pvclock_clocksource_vread().
>
> One complication is that usermode is subject to two levels of scheduling:
> kernel scheduling of tasks onto vcpus, and hypervisor scheduling of
> vcpus onto pcpus.  In either case the underlying pcpu changed, and with
> it, the correct set of parameters to compute tsc->system clock.  To
> address this we install a preempt notifier on sched_out to increment
> that vcpu's version number.  Usermode can then check the version number
> is unchanged while computing the time and retry if it has (the only
> difference from the kernel's version of the algorithm is that the vcpu
> may have changed, so we may need to switch pvclock_vcpu_time_info
> structures.
>
> To use this feature, hypervisor-specific code is required
> to call pvclock_init_vsyscall(), and if successful:
>   - cause the pvclock_vcpu_time_info structure at
>     pvclock_get_vsyscall_time_info(cpu) to be updated appropriately for
>     each vcpu.
>   - use pvclock_clocksource_vread as the implementation of clocksource
>     .vread.
>
> +
> +cycle_t __vsyscall_fn pvclock_clocksource_vread(void)
> +{
> +	const struct pvclock_vcpu_time_info *pvti_base;
> +	const struct pvclock_vcpu_time_info *pvti;
> +	cycle_t ret;
> +	u32 version;
> +
> +	pvti_base = (struct pvclock_vcpu_time_info *)fix_to_virt(FIX_PVCLOCK_TIME_INFO);
> +
> +	/*
> +	 * When looping to get a consistent (time-info, tsc) pair, we
> +	 * also need to deal with the possibility we can switch vcpus,
> +	 * so make sure we always re-fetch time-info for the current vcpu.
> +	 */
> +	do {
> +		unsigned cpu;
> +
> +		vgetcpu(&cpu, NULL, NULL);
> +		pvti =&pvti_base[cpu];
> +
> +		version = __pvclock_read_cycles(pvti,&ret);
> +	} while (unlikely(pvti->version != version));
> +
> +	return ret;
> +}
>    

Instead of using vgetcpu() and rdtsc() independently, you can use rdtscp 
to read both atomically.  This removes the need for the preempt notifier.

> +
> +/*
> + * Initialize the generic pvclock vsyscall state.  This will allocate
> + * a/some page(s) for the per-vcpu pvclock information, set up a
> + * fixmap mapping for the page(s)
> + */
> +int __init pvclock_init_vsyscall(void)
> +{
> +	int cpu;
> +
> +	/* Just one page for now */
> +	if (nr_cpu_ids * sizeof(struct vcpu_time_info)>  PAGE_SIZE) {
> +		printk(KERN_WARNING "pvclock_vsyscall: too many CPUs to fit time_info into a single page\n");
> +		return -ENOSPC;
> +	}
> +
> +	pvclock_vsyscall_time_info =
> +		(struct pvclock_vcpu_time_info *)get_zeroed_page(GFP_KERNEL);
> +	if (pvclock_vsyscall_time_info == NULL)
> +		return -ENOMEM;
> +
>    

Need to align the vcpu_time_infos on a cacheline boundary.

> +	for (cpu = 0; cpu<  nr_cpu_ids; cpu++)
> +		pvclock_vsyscall_time_info[cpu].version = ~0;
> +
> +	__set_fixmap(FIX_PVCLOCK_TIME_INFO, __pa(pvclock_vsyscall_time_info),
> +		     PAGE_KERNEL_VSYSCALL);
> +
> +	preempt_notifier_init(&pvclock_vsyscall_notifier,
> +			&pvclock_vsyscall_preempt_ops);
> +	preempt_notifier_register(&pvclock_vsyscall_notifier);
> +
>    

preempt notifiers are per-thread, not global, and will upset the cycle 
counters.  I'd drop them and use rdtscp instead (and give up if the 
processor doesn't support it).

-- 
error compiling committee.c: too many arguments to function

