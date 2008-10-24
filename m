Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYJXHdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYJXHdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYJXHdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:33:45 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:5486 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751090AbYJXHdo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:33:44 -0400
Message-ID: <49017A2C.5010504@tungstengraphics.com>
Date: Fri, 24 Oct 2008 09:33:00 +0200
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Peter Anvin <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Adding kmap_atomic_prot_pfn 
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>	<20081018203741.GA23396@elte.hu>	<1224366690.4384.89.camel@koto.keithp.com>	<20081018223214.GA5093@elte.hu>	<1224389697.4384.118.camel@koto.keithp.com>	<1224398496.5303.7.camel@koto.keithp.com>	<20081019175320.GA6442@elte.hu>	<1224450291.5303.23.camel@koto.keithp.com>	<20081020115810.GC10594@elte.hu>	<1224517744.5195.1.camel@koto.keithp.com>	<20081022093615.GF12453@elte.hu>	<1224793332.22877.8.camel@koto.keithp.com>	<20081023133840.d4eef579.akpm@linux-foundation.org>	<alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>	<1224813015.22877.51.camel@koto.keithp.com>	<alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org> <1224829359.22877.86.camel@koto.keithp.com>
In-Reply-To: <1224829359.22877.86.camel@koto.keithp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith,

What you actually are doing here is claiming copyright on code that 
other people have written, and tighten the export restrictions. 
kmap_atomic_prot_pfn() appeared long ago in drm git with identical code 
and purpose, but with different authors, and iounmap_atomic is identical 
to kunmap_atomic.

Pls fix.

/Thomas

Keith Packard wrote:
>
> diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
> new file mode 100644
> index 0000000..c559599
> --- /dev/null
> +++ b/arch/x86/mm/iomap_32.c
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright © 2008 Keith Packard <keithp@keithp.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + */
> +
> +#include <asm/iomap.h>
> +#include <linux/module.h>
> +
> +/* Map 'pfn' using fixed map 'type' and protections 'prot'
> + */
> +void *
> +iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
> +{
> +	enum fixed_addresses idx;
> +	unsigned long vaddr;
> +
> +	pagefault_disable();
> +
> +	idx = type + KM_TYPE_NR*smp_processor_id();
> +	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> +	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
> +	arch_flush_lazy_mmu_mode();
> +
> +	return (void*) vaddr;
> +}
> +EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
> +
> +void
> +iounmap_atomic(void *kvaddr, enum km_type type)
> +{
> +	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
> +	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
> +
> +	/*
> +	 * Force other mappings to Oops if they'll try to access this pte
> +	 * without first remap it.  Keeping stale mappings around is a bad idea
> +	 * also, in case the page changes cacheability attributes or becomes
> +	 * a protected page in a hypervisor.
> +	 */
> +	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
> +		kpte_clear_flush(kmap_pte-idx, vaddr);
> +
> +	arch_flush_lazy_mmu_mode();
> +	pagefault_enable();
> +}
> +EXPORT_SYMBOL_GPL(iounmap_atomic);
>   



