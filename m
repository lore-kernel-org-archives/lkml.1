Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbXEaNmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbXEaNmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXEaNmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:42:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXEaNmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:42:14 -0400
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 20/22] 2.6.22-rc3 perfmon2 : new x86_64 files
References: <200705291348.l4TDmZrR019866@frankl.hpl.hp.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 16:38:52 +0200
In-Reply-To: <200705291348.l4TDmZrR019866@frankl.hpl.hp.com>
Message-ID: <p73myzlcb2b.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@frankl.hpl.hp.com> writes:

> +	/* test IA32_PMC0, IA32_PMC1 */
> +	for (i=4; i < 6; i++) {
> +		if (avail_to_resrv_perfctr_nmi(pfm_core_pmd_desc[i].hw_addr))
> +			continue;
> +		if (disabled != -1) {
> +			PFM_INFO("more than one counter used by NMI, not supported");
> +			return -1;
> +		}
> +		PFM_INFO("NMI watchdog using %s/%s, disabling them for perfmon",


There could be other users of perfctrs too, message is a bit misleading.

And why are multiple reserved counters not supported? 

> +			pfm_core_pmd_desc[i].desc,
> +			pfm_core_pmc_desc[i].desc);
> +
> +		pfm_core_pmc_desc[i].type = PFM_REG_NA;
> +		pfm_core_pmu_info.pmc_addrs[i].reg_type = PFM_REGT_EN;
> +
> +		pfm_core_pmd_desc[i].type = PFM_REG_NA;
> +		pfm_core_pmu_info.pmd_addrs[i].reg_type = PFM_REGT_NA;
> +		disabled = i;
> +	}
> +	/*
> +	 * if NMI uses IA32_PMC0 or IA32_PMC1, we cannot use global controls
> +	 * to start stop all counters. We disabled the global controls and
> +	 * mark generic counters as each having enbale bits
> +	 */

Hmm you're trying to detect what the main kernel does? But if it's
merged it should know. So trying to detect it dynamically doesn't 
seem appropiate.


> +static int pfm_core_probe_pmu(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * only works on Intel processors
> +	 */
> +	if (cpu_data->x86_vendor != X86_VENDOR_INTEL) {
> +		PFM_INFO("not running on Intel processor");
> +		return -1;
> +	}
> +
> +	if (cpu_data->x86 != 6 || cpu_data->x86_model != 15)
> +		return -1;

It seems a bit ingenious that when Intel does all the trouble
to define cpuid bits for them and then you do such checks anyways. 

There should be probably two levels: simple support for the 
architected counters using only cpuid capability bits 
and then an exnteded check for known models etc
(probably table driven)

> +#ifdef CONFIG_SMP
> +	proc_id = topology_physical_package_id(smp_processor_id());
> +#else
> +	proc_id = 0;
> +#endif

That's not necessarily true for !SMP.  e.g. consider the kdump
case.

> +
> +	if (ctx->flags.system)
> +		entry = &pfm_nb_sys_owners[proc_id];
> +	else
> +		entry = &pfm_nb_task_owner;
> +
> +	old = cmpxchg(entry, NULL, ctx);	


Non blocking way to aquire a resource? Looks unreliable.

> +/*
> + * detect if we need to active NorthBridge event access control
> + */

Can you please explain what this complex northbridge access control
logic is good for? There are a few shared counters, but normally
this can be easier handled by limitting access to one of the cores.
I suspect this could be done much simpler.

> +static int pfm_k8_setup_nb_event_control(void)
> +{
> +	unsigned int c, n = 0;
> +	unsigned int max_phys = 0;
> +
> +#ifdef CONFIG_SMP
> +	for_each_present_cpu(c) {

possible cpus

> +		if (cpu_data[c].phys_proc_id > max_phys)
> +			max_phys = cpu_data[c].phys_proc_id;

But we don't necessarily know the phys_proc_id of all possible CPUs.
So that seems broken for the cpu hotplug case.

> +	/*
> +	 * assume NMI watchdog is initialized before PMU description module
> +	 * auto-detect which perfctr/eventsel is used by NMI watchdog
> +	 */

See earlier comment for core2

> +
> +	if (current_cpu_data.x86 != 15) {
> +		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
> +		return -1;
> +	}

Already obsolete with Barcelona and Griffin (16 and 17) but very similar
counters. 

> --- linux-2.6.22.base/include/asm-x86_64/perfmon.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22/include/asm-x86_64/perfmon.h	2007-05-29 03:24:14.000000000 -0700
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
> + * Contributed by Stephane Eranian <eranian@hpl.hp.com>
> + *
> + * This file contains X86-64 Processor Family specific definitions
> + * for the perfmon interface.
> + *
> + * This file MUST never be included directly. Use linux/perfmon.h.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307 USA
> +  */
> +#include <asm-i386/perfmon.h>

Lots of copyright for a single line


-Andi
