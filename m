Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZH2RdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZH2RdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 13:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZH2RdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 13:33:12 -0400
Received: from www.tglx.de ([62.245.132.106]:59427 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZH2RdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 13:33:12 -0400
Date: Sat, 29 Aug 2009 19:31:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Subject: Re: [RFC PATCH 7/7] x86: add more platform_setup functions
In-Reply-To: <43F901BD926A4E43B106BF17856F07556A5EA87A@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908291923350.19335@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org> <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain> <43F901BD926A4E43B106BF17856F07556A5EA87A@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Pan, Jacob jun wrote:

> >From fbfe65d64e4dbb31940d31a59e080bfa15d121bb Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Wed, 8 Jul 2009 16:51:42 -0700
> Subject: [PATCH] x86: RFC add more platform_setup functions
> 
> check_timer can be abstracted so that we don't have to do the complicated
> checks for platform timer for all platforms.

Well, if it's necessary then we replace it, but the code you showed in
an earlier patch is just adding debug cruft. So what's the point ?

> pci irq enable/disable can also
> benefit from the platform setup layer, but this part is not complete in this
> patch, should be able to include visws. e.g.

Please provide one patch per feature / change.
 
> pcibios_enable_irq = &pci_visws_enable_irq;
> pcibios_disable_irq = &pci_visws_disable_irq;

No, this is patently wrong. You abstract at the wrong point. If
abstraction of the pci init is necessary then the various #ifdeffed
function calls in legacy.c:pci_subsys_init() have to be platformized.
 
>  extern int __init pci_mmcfg_arch_init(void);
> diff --git a/arch/x86/include/asm/platform.h b/arch/x86/include/asm/platform.h
> index 1cea28c..d698f68 100644
> --- a/arch/x86/include/asm/platform.h
> +++ b/arch/x86/include/asm/platform.h
> @@ -6,6 +6,7 @@
>  struct mpc_bus;
>  struct mpc_cpu;
>  struct mpc_table;
> +struct pci_dev;
>  
>  /**
>   * struct platform_setup_quirks - platform specific quirks
> @@ -62,6 +63,11 @@ struct platform_setup_irqs {
>  	void (*pre_vector_init)(void);
>  	void (*intr_init)(void);
>  	void (*trap_init)(void);
> +
> +#ifdef CONFIG_PCI
> +	int (*pci_enable_irq)(struct pci_dev *dev);
> +	void (*pci_disable_irq)(struct pci_dev *dev);
> +#endif

PCI stuff does not belong to irq. It needs a separate data
structure. Also using the function pointers just to assign them later
to some other function pointer is pointless. The code can be
restructured so you can just tweak the existing function pointer.
Also I avoided #ifdefs in the platform code on purpose. The few bytes
you spare in the init structure are not worth the #ifdef mess which is
needed all over the place.

Thanks,

	tglx
