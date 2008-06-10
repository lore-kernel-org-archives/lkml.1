Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbYFJKCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbYFJKCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYFJKCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:02:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52402 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYFJKCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:02:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 GART: Add resume handling (was: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard Disk Corruption)
Date: Tue, 10 Jun 2008 12:03:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, the arch/x86 maintainers <x86@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080609124630.GA28799@elte.hu> <200806100010.49194.rjw@sisk.pl>
In-Reply-To: <200806100010.49194.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101203.01836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 10 of June 2008, Rafael J. Wysocki wrote:
> On Monday, 9 of June 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > Looks ok to me.
> > > 
> > > Still, it may be improved. :-)
> > > 
> > > First, we shouldn't mix the "early PCI config access" thing with the 
> > > "normal" method.  Second, we don't have to check for the K8 north 
> > > bridges on resume, because we already know where they are in the 
> > > configuration space and we can use this information.
> > > 
> > > Updated patch follows.  It has been tested a little on my new 4 GB 
> > > test box on which 2.6.26-rc4 failed miserably with severe 
> > > consequences.  More testing welcome, but please be careful.
> > 
> > Rafael, could we try this against the tip/x86/gart tree perhaps? It 
> > already has a couple of fixes from Pavel and your patch collides with 
> > them in a non-obvious way.
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> 
> Okay, appended is the patch rebased on tip/x86/gart with (mainline) commit
> cd76374e9de4501acc74f833dc6cb5e7a5dca115 "suspend-vs-iommu: prevent suspend if
> we could not resume" (which appears to be missing from tip/x86/gart) applied.
> 
> This version of the patch doesn't break compilation, but it hasn't been really
> tested yet.

Now it has been (successfully) tested too. :-)

Thanks,
Rafael

 
> ---
> Add resume handling to GART IOMMU.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/aperture_64.c |    2 +
>  arch/x86/kernel/pci-gart_64.c |   57 ++++++++++++++++++++++++++++++++++++++----
>  include/asm-x86/gart.h        |    1 
>  3 files changed, 55 insertions(+), 5 deletions(-)
> 
> Index: tip.git/arch/x86/kernel/aperture_64.c
> ===================================================================
> --- tip.git.orig/arch/x86/kernel/aperture_64.c
> +++ tip.git/arch/x86/kernel/aperture_64.c
> @@ -496,4 +496,6 @@ out:
>  			write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
>  		}
>  	}
> +
> +	set_up_gart_resume(aper_order, aper_alloc);
>  }
> Index: tip.git/arch/x86/kernel/pci-gart_64.c
> ===================================================================
> --- tip.git.orig/arch/x86/kernel/pci-gart_64.c
> +++ tip.git/arch/x86/kernel/pci-gart_64.c
> @@ -549,14 +549,63 @@ static __init unsigned read_aperture(str
>  	return aper_base;
>  }
>  
> +static void enable_gart_translations(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_k8_northbridges; i++) {
> +		struct pci_dev *dev = k8_northbridges[i];
> +
> +		enable_gart_translation(dev, __pa(agp_gatt_table));
> +	}
> +}
> +
> +/*
> + * If fix_up_north_bridges is set, the north bridges have to be fixed up on
> + * resume in the same way as they are handled in gart_iommu_hole_init().
> + */
> +static bool fix_up_north_bridges;
> +static u32 aperture_order;
> +static u32 aperture_alloc;
> +
> +void set_up_gart_resume(u32 aper_order, u32 aper_alloc)
> +{
> +	fix_up_north_bridges = true;
> +	aperture_order = aper_order;
> +	aperture_alloc = aper_alloc;
> +}
> +
>  static int gart_resume(struct sys_device *dev)
>  {
> +	printk(KERN_INFO "PCI-DMA: Resuming GART IOMMU\n");
> +
> +	if (fix_up_north_bridges) {
> +		int i;
> +
> +		printk(KERN_INFO "PCI-DMA: Restoring GART aperture settings\n");
> +
> +		for (i = 0; i < num_k8_northbridges; i++) {
> +			struct pci_dev *dev = k8_northbridges[i];
> +
> +			/*
> +			 * Don't enable translations just yet.  That is the next
> +			 * step.  Restore the pre-suspend aperture settings.
> +			 */
> +			pci_write_config_dword(dev, AMD64_GARTAPERTURECTL,
> +						aperture_order << 1);
> +			pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE,
> +						aperture_alloc >> 25);
> +		}
> +	}
> +
> +	enable_gart_translations();
> +
>  	return 0;
>  }
>  
>  static int gart_suspend(struct sys_device *dev, pm_message_t state)
>  {
> -	return -EINVAL;
> +	return 0;
>  }
>  
>  static struct sysdev_class gart_sysdev_class = {
> @@ -614,16 +663,14 @@ static __init int init_k8_gatt(struct ag
>  	memset(gatt, 0, gatt_size);
>  	agp_gatt_table = gatt;
>  
> -	for (i = 0; i < num_k8_northbridges; i++) {
> -		dev = k8_northbridges[i];
> -		enable_gart_translation(dev, __pa(gatt));
> -	}
> +	enable_gart_translations();
>  
>  	error = sysdev_class_register(&gart_sysdev_class);
>  	if (!error)
>  		error = sysdev_register(&device_gart);
>  	if (error)
>  		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
> +
>  	flush_gart();
>  
>  	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
> Index: tip.git/include/asm-x86/gart.h
> ===================================================================
> --- tip.git.orig/include/asm-x86/gart.h
> +++ tip.git/include/asm-x86/gart.h
> @@ -14,6 +14,7 @@ extern void gart_iommu_shutdown(void);
>  extern void __init gart_parse_options(char *);
>  extern void early_gart_iommu_check(void);
>  extern void gart_iommu_hole_init(void);
> +extern void set_up_gart_resume(u32, u32);
>  extern int fallback_aper_order;
>  extern int fallback_aper_force;
>  extern int gart_iommu_aperture;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
