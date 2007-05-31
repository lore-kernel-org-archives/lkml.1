Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXEaQrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXEaQrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXEaQq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:46:56 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:64206 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbXEaQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:46:55 -0400
Date: Thu, 31 May 2007 09:46:38 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/22] 2.6.22-rc3 perfmon2 : new x86_64 files
Message-ID: <20070531164638.GB23939@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmZrR019866@frankl.hpl.hp.com> <p73myzlcb2b.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73myzlcb2b.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 04:38:52PM +0200, Andi Kleen wrote:
> Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> 
> > +	/* test IA32_PMC0, IA32_PMC1 */
> > +	for (i=4; i < 6; i++) {
> > +		if (avail_to_resrv_perfctr_nmi(pfm_core_pmd_desc[i].hw_addr))
> > +			continue;
> > +		if (disabled != -1) {
> > +			PFM_INFO("more than one counter used by NMI, not supported");
> > +			return -1;
> > +		}
> > +		PFM_INFO("NMI watchdog using %s/%s, disabling them for perfmon",
> 
> 
> There could be other users of perfctrs too, message is a bit misleading.
> 
Yes, this is temprary until we come up with a better PMU register allocator.
The function is explicitly checking for NMI.

> And why are multiple reserved counters not supported? 
> 
BEcause it knows there are only 2 counters on Core 2 Duo. That goes with
the implicit knowledge of NMI and of the CPU model (see your argument below).


> > +			pfm_core_pmd_desc[i].desc,
> > +			pfm_core_pmc_desc[i].desc);
> > +
> > +		pfm_core_pmc_desc[i].type = PFM_REG_NA;
> > +		pfm_core_pmu_info.pmc_addrs[i].reg_type = PFM_REGT_EN;
> > +
> > +		pfm_core_pmd_desc[i].type = PFM_REG_NA;
> > +		pfm_core_pmu_info.pmd_addrs[i].reg_type = PFM_REGT_NA;
> > +		disabled = i;
> > +	}
> > +	/*
> > +	 * if NMI uses IA32_PMC0 or IA32_PMC1, we cannot use global controls
> > +	 * to start stop all counters. We disabled the global controls and
> > +	 * mark generic counters as each having enbale bits
> > +	 */
> 
> Hmm you're trying to detect what the main kernel does? But if it's
> merged it should know. So trying to detect it dynamically doesn't 
> seem appropiate.

Yes, except that this code is not part of the main kernel but lives
in a kernel module and will stay that way even if perfmon is merged.

> 
> 
> > +static int pfm_core_probe_pmu(void)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * only works on Intel processors
> > +	 */
> > +	if (cpu_data->x86_vendor != X86_VENDOR_INTEL) {
> > +		PFM_INFO("not running on Intel processor");
> > +		return -1;
> > +	}
> > +
> > +	if (cpu_data->x86 != 6 || cpu_data->x86_model != 15)
> > +		return -1;
> 
> It seems a bit ingenious that when Intel does all the trouble
> to define cpuid bits for them and then you do such checks anyways. 
> 
Yes, The issue comes from pure architected perfmon, such as Core Duo,
and  architected perfmon + extensions (e.g., PEBS), such as Core 2 Duo.

I have a module for pure architected perfmon (perfmon_gen_ia32.c). It is
able to cope with a variable number of counters. Yet it cannot cope with
PEBS MSRs. That is why I have a Core 2 Duo specific module where the
5 counters are hardcoded and so is PEBS.


> There should be probably two levels: simple support for the 
> architected counters using only cpuid capability bits 
> and then an exnteded check for known models etc
> (probably table driven)
> 
The idea with architected PMU is that you write a module once, and it
is guaranteed to work on future PMU models. When new hardware shows up
it may have extended features, but it may take some time for the new 
specific perfmon module to find its way into the Linux distros. Then,
in the meantime, the architected module could provide basic functionalities.
This is how this works on Itanium, for instance. Some tools may only
care about basic features, so the model specific perfmon module must somehow
be compatible with the architected generic module, i.e., registers should
not change positions in the namespace.


> > +#ifdef CONFIG_SMP
> > +	proc_id = topology_physical_package_id(smp_processor_id());
> > +#else
> > +	proc_id = 0;
> > +#endif
> 
> That's not necessarily true for !SMP.  e.g. consider the kdump
> case.
> 
I am not sure I understand your point here. For UP kernel, I just
need to grab an index, it does not have to match any actual physical id.

> > +
> > +	if (ctx->flags.system)
> > +		entry = &pfm_nb_sys_owners[proc_id];
> > +	else
> > +		entry = &pfm_nb_task_owner;
> > +
> > +	old = cmpxchg(entry, NULL, ctx);	
> 
> 
> Non blocking way to aquire a resource? Looks unreliable.

I think it is better to fail here than to block.

> 
> > +/*
> > + * detect if we need to active NorthBridge event access control
> > + */
> 
> Can you please explain what this complex northbridge access control
> logic is good for? There are a few shared counters, but normally
> this can be easier handled by limitting access to one of the cores.

Are you suggesting affinity enforcement?

> 
> > +		if (cpu_data[c].phys_proc_id > max_phys)
> > +			max_phys = cpu_data[c].phys_proc_id;
> 
> But we don't necessarily know the phys_proc_id of all possible CPUs.
> So that seems broken for the cpu hotplug case.

What about I scan on for_each_possible_cpu as you suggested?

> > +
> > +	if (current_cpu_data.x86 != 15) {
> > +		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
> > +		return -1;
> > +	}
> 
> Already obsolete with Barcelona and Griffin (16 and 17) but very similar
> counters. 
> 
Yes, but those will get new description modules.

Thanks for your comments.

-- 

-Stephane
