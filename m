Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbXFYAWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbXFYAWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFYAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:22:32 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:50005 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXFYAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AiX84hZvkGIfzKfT4mWDC+eLvF5RUg0qICqvJwWP3oyAnaNzFBBnBFek+5p4VdMykH4ObRQgBeF36Z4TXVZU6B6rlk7XWc1hGx1oM1I18UQB6y00KvasZ/Ceha19Pu/OkLoG7oVKfQEmd6WHjTAUqUV8Mmnwth0R0mchhnuSVzI=
Message-ID: <86802c440706241722o6d18d4acsf3293eb2a83c4688@mail.gmail.com>
Date: Sun, 24 Jun 2007 17:22:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Cc: ak@suse.de, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com,
       muli@il.ibm.com, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070623095209.248684e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
	 <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com>
	 <200706221934.59966.yinghai.lu@sun.com>
	 <20070623095209.248684e7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >  void __init gart_iommu_init(void)
> >  {
> >       struct agp_kern_info info;
> > diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
> > index 9f80aad..64f2ab3 100644
> > --- a/arch/x86_64/kernel/pci-dma.c
> > +++ b/arch/x86_64/kernel/pci-dma.c
> > @@ -322,6 +322,13 @@ static int __init pci_iommu_init(void)
> >       return 0;
> >  }
> >
> > +void pci_iommu_shutdown(void)
> > +{
> > +#ifdef CONFIG_IOMMU
> > +     gart_iommu_shutdown();
> > +#endif
> > +}
>
> It'd be better to avoid the ifdef-in-C by providing a stub function in a
> header file if !CONFIG_IOMMU.  That's quite standard kernel practice and
> might help avoid some other problems...

move ifdef into gart_iommu_shudown()?

>
> >  #ifdef CONFIG_PCI
> >  /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
> >
> > diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
> > index 7503068..e6e65c2 100644
> > --- a/arch/x86_64/kernel/reboot.c
> > +++ b/arch/x86_64/kernel/reboot.c
> > @@ -16,6 +16,7 @@
> >  #include <asm/pgtable.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/apic.h>
> > +#include <asm/proto.h>
> >
> >  /*
> >   * Power off function, if any
> > @@ -81,6 +82,7 @@ static inline void kb_wait(void)
> >  void machine_shutdown(void)
> >  {
> >       unsigned long flags;
> > +
> >       /* Stop the cpus and apics */
> >  #ifdef CONFIG_SMP
> >       int reboot_cpu_id;
> > @@ -111,6 +113,8 @@ void machine_shutdown(void)
> >       disable_IO_APIC();
> >
> >       local_irq_restore(flags);
> > +
> > +     pci_iommu_shutdown();
> >  }
>
> And does the kernel work OK if CONFIG_PCI=n?  I think so from inspection,
> by luck.

x86_64 always have that PCI enabled?

>
> >  void machine_emergency_restart(void)
> > diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
> > index 85255db..fb9f73e 100644
> > --- a/include/asm-x86_64/proto.h
> > +++ b/include/asm-x86_64/proto.h
> > @@ -85,11 +85,13 @@ extern int exception_trace;
> >  extern unsigned cpu_khz;
> >  extern unsigned tsc_khz;
> >
> > +extern void pci_iommu_shutdown(void);
>
> This is the only pci-related function which is declared in proto.h.  I
> suspect you chose the wrong header file for this declaration.
i tried to put that into dma_mapping.h, but htat will need more header
files before that to make the compiler happy, may need to find another
header file for it.

YH
