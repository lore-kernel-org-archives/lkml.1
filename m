Return-Path: <linux-kernel-owner+w=401wt.eu-S2992475AbXDYJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992475AbXDYJ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992478AbXDYJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:26:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:54776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992475AbXDYJ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:26:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 11/25] xen: Xen SMP guest support
Date: Wed, 25 Apr 2007 11:24:48 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Ingo Molnar <mingo@redhat.com>
References: <20070423215638.563901986@goop.org> <20070423215711.197402369@goop.org>
In-Reply-To: <20070423215711.197402369@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251124.48445.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>  #ifdef CONFIG_X86_LOCAL_APIC
>  static unsigned long xen_apic_read(unsigned long reg)

Can't you just make them all NULL? Crashing here should be correct.


  
> +#ifdef CONFIG_SMP
> +static const struct smp_ops xen_smp_ops __initdata = {

Why __initdata? 

> +/* VCPUs are single-cored, and have no siblings */
> +static void set_cpu_sibling_map(int cpu)

Can you put this somewhere generic and use it everywhere? Don't want
duplication of this code.

> +{
> +	struct cpuinfo_x86 *c = &cpu_data[cpu];
> +
> +	cpu_set(cpu, cpu_sibling_map[cpu]);
> +	cpu_set(cpu, c->llc_shared_map);
> +	cpu_core_map[cpu] = cpu_sibling_map[cpu];
> +	c->booted_cores = 1;
> +}
> +
> +static void remove_siblinginfo(int cpu)

Similar.

> +void __init xen_fill_possible_map(void)
> +{
> +	int i, rc;
> +
> +	for_each_possible_cpu(i)
> +	    if (i != smp_processor_id())
> +		return;

Strange check?

> +
> + * We need to reload %cr3 since the page tables may be going
> + * away from under us..
> + */
> +static inline void leave_mm (unsigned long cpu)
> +{
> +#ifdef CONFIG_SMP
> +	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
> +		BUG();
> +	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
> +#endif
> +	load_cr3(swapper_pg_dir);
>  }

Should be out of line


-Andi
