Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZBGCvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZBGCvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZBGCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:51:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:60435 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZBGCvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:51:37 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <Pine.LNX.4.64.0902061248010.14011@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
	 <1233867944.4612.104.camel@pasglop>
	 <200902051433.23294.jbarnes@virtuousgeek.org>
	 <1233898836.4612.116.camel@pasglop>
	 <Pine.LNX.4.64.0902061248010.14011@blonde.anvils>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 13:51:12 +1100
Message-Id: <1233975072.31963.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I still don't understand the point of this legacy_mem file at all,
> and why X should want to mmap it, if it works so well when it's
> thus divorced from reality.  But I won't worry my pretty little
> head over it any further - please don't waste your time trying
> to explain it to me!

VGA memory hole :-) ie, text mode & fonts

Ben.

> Thanks,
> Hugh
> 
> > 
> > Index: linux-work/arch/powerpc/kernel/pci-common.c
> > ===================================================================
> > --- linux-work.orig/arch/powerpc/kernel/pci-common.c	2009-02-06 16:23:36.000000000 +1100
> > +++ linux-work/arch/powerpc/kernel/pci-common.c	2009-02-06 16:30:32.000000000 +1100
> > @@ -561,8 +561,21 @@ int pci_mmap_legacy_page_range(struct pc
> >  		 (unsigned long long)(offset + size - 1));
> >  
> >  	if (mmap_state == pci_mmap_mem) {
> > -		if ((offset + size) > hose->isa_mem_size)
> > -			return -ENXIO;
> > +		/* Hack alert !
> > +		 *
> > +		 * Because X is lame and can fail starting if it gets an error trying
> > +		 * to mmap legacy_mem (instead of just moving on without legacy memory
> > +		 * access) we fake it here by giving it anonymous memory, effectively
> > +		 * behaving just like /dev/zero
> > +		 */
> > +		if ((offset + size) > hose->isa_mem_size) {
> > +			printk(KERN_DEBUG
> > +			       "Process %s (pid:%d) mapped non-existing PCI legacy memory for 0%04x:%02x\n",
> > +			       current->comm, current->pid, pci_domain_nr(bus), bus->number);
> > +			if (vma->vm_flags & VM_SHARED)
> > +				return shmem_zero_setup(vma);
> > +			return 0;
> > +		}
> >  		offset += hose->isa_mem_phys;
> >  	} else {
> >  		unsigned long io_offset = (unsigned long)hose->io_base_virt - _IO_BASE;

