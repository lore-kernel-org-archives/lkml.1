Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZBFM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZBFM5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 07:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZBFM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 07:57:46 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45414 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZBFM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 07:57:44 -0500
Date: Fri, 6 Feb 2009 12:56:52 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <1233898836.4612.116.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0902061248010.14011@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>  <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
  <1233867944.4612.104.camel@pasglop>  <200902051433.23294.jbarnes@virtuousgeek.org>
 <1233898836.4612.116.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Benjamin Herrenschmidt wrote:
> On Thu, 2009-02-05 at 14:33 -0800, Jesse Barnes wrote:
> 
> > One option there would be to provide the file but just use anonymous memory to 
> > back it.  X will happily think it's messing with legacy VGA memory, but it 
> > shouldn't matter that it's not actually affecting hw.
> 
> What about this (untested) patch ?
> 
> powerpc/pci: mmap anonymous memory when legacy_mem doesn't exist
> 
> The new legacy_mem file in sysfs is causing problems with X on machines
> that don't support legacy memory access. The way I initially implemented
> it, we would fail with -ENXIO when trying to mmap it, thus exposing to
> X that we do support the API but there is no legacy memory.
> 
> Unfortunately, X poor error handling is causing it to fail to start when
> it gets this error.
> 
> This implements a workaround hack that instead maps anonymous memory
> instead (using shmem if VM_SHARED is set, just like /dev/zero does).
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---

Beautiful idea, works very nicely for me.
Put a dummy in the baby's mouth to stop it crying.

I still don't understand the point of this legacy_mem file at all,
and why X should want to mmap it, if it works so well when it's
thus divorced from reality.  But I won't worry my pretty little
head over it any further - please don't waste your time trying
to explain it to me!

Thanks,
Hugh

> 
> Index: linux-work/arch/powerpc/kernel/pci-common.c
> ===================================================================
> --- linux-work.orig/arch/powerpc/kernel/pci-common.c	2009-02-06 16:23:36.000000000 +1100
> +++ linux-work/arch/powerpc/kernel/pci-common.c	2009-02-06 16:30:32.000000000 +1100
> @@ -561,8 +561,21 @@ int pci_mmap_legacy_page_range(struct pc
>  		 (unsigned long long)(offset + size - 1));
>  
>  	if (mmap_state == pci_mmap_mem) {
> -		if ((offset + size) > hose->isa_mem_size)
> -			return -ENXIO;
> +		/* Hack alert !
> +		 *
> +		 * Because X is lame and can fail starting if it gets an error trying
> +		 * to mmap legacy_mem (instead of just moving on without legacy memory
> +		 * access) we fake it here by giving it anonymous memory, effectively
> +		 * behaving just like /dev/zero
> +		 */
> +		if ((offset + size) > hose->isa_mem_size) {
> +			printk(KERN_DEBUG
> +			       "Process %s (pid:%d) mapped non-existing PCI legacy memory for 0%04x:%02x\n",
> +			       current->comm, current->pid, pci_domain_nr(bus), bus->number);
> +			if (vma->vm_flags & VM_SHARED)
> +				return shmem_zero_setup(vma);
> +			return 0;
> +		}
>  		offset += hose->isa_mem_phys;
>  	} else {
>  		unsigned long io_offset = (unsigned long)hose->io_base_virt - _IO_BASE;
