Return-Path: <linux-kernel-owner+w=401wt.eu-S637768AbXECPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637768AbXECPr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637772AbXECPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:47:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S637768AbXECPr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:47:57 -0400
Date: Thu, 3 May 2007 11:47:36 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       kernel list <linux-kernel@vger.kernel.org>, andi@lisas.de
Subject: Re: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Message-ID: <20070503154736.GA23922@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@ucw.cz>,
	Andreas Mohr <andi@rhlx01.fht-esslingen.de>,
	Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	kernel list <linux-kernel@vger.kernel.org>, andi@lisas.de
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070501145947.GA19953@rhlx01.hs-esslingen.de> <20070502101718.GC10245@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502101718.GC10245@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:17:18PM +0200, Pavel Machek wrote:

 > >  #define INTEL_I820_RDCR		0x51
 > > @@ -664,7 +671,7 @@
 > >  	if ((pg_start + mem->page_count) > num_entries)
 > >  		goto out_err;
 > >  
 > > -	/* The i830 can't check the GTT for entries since its read only,
 > > +	/* The i830 can't check the GTT for entries since it's read-only,
 > >  	 * depend on the caller to make the correct offset decisions.
 > >  	 */
 > >  
 > > @@ -787,7 +794,7 @@
 > >  	if ((pg_start + mem->page_count) > num_entries)
 > >  		goto out_err;
 > >  
 > > -	/* The i915 can't check the GTT for entries since its read only,
 > > +	/* The i915 can't check the GTT for entries since it's read-only,
 > >  	 * depend on the caller to make the correct offset decisions.
 > >  	 */
 > 
 > You should not do cleanups at the same time as code changes.

Indeed.

 > > @@ -1103,8 +1110,8 @@
 > >  	/* attbase - aperture base */
 > >  	/* the Intel 815 chipset spec. says that bits 29-31 in the
 > >  	* ATTBASE register are reserved -> try not to write them */
 > > -	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
 > > -		printk (KERN_EMERG PFX "gatt bus addr too high");
 > > +	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
 > > +		printk (KERN_EMERG PFX "gatt bus addr too high\n");
 > >  		return -EINVAL;
 > >  	}
 > >  
 > > @@ -1119,7 +1126,7 @@
 > >  	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 > >  
 > >  	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
 > > -	addr &= INTEL_815_ATTBASE_MASK;
 > > +	addr &= I815_ATTBASE_MASK;
 > >  	addr |= agp_bridge->gatt_bus_addr;
 > >  	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
 > 
 > And I guess macro search&replace counts as cleanup, too. It would be
 > nice to submit them separately and first.

I'm not a big fan of the s/INTEL_/I_/ change to be honest.
I'd prefer we didn't change this, as a) there may be additional
patches in flight which touch intel-agp.c depending on those defines,
b) it'll make future changes to intel-agp.c harder to backport to
-stable releases, and c) it doesn't really add any value.

 > > @@ -1355,7 +1362,7 @@
 > >  	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
 > >  
 > >  	/* agpctrl */
 > > -	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
 > > +	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x00000000);
 > 
 > Huh?

harmless, but ok.

 > > +			pci_read_config_dword(pdev, p->reg, &p->value);
 > > +	}
 > > +	return 1;
 > > +}
 > 
 > Should this betwo functions, one for save, one for restore, with "to
 > save" array being global?

yes.

 > > +/*
 > > + * set DEBUG_AGP_PM to 1 if your AGP chipset has issues resuming
 > > + * (machine lockups due to non-restored hardware registered values),
 > > + * then figure out from the log which registers have to be restored manually,
 > > + * then add specific support for your chipset, similar to what already exists
 > 
 > Can we get debugging stuff separately?

ACK.

 > > @@ -2106,6 +2282,12 @@
 > >  {
 > >  	if (agp_off)
 > >  		return -EINVAL;
 > > +	/* let people know that this is an important place to investigate at in case of resume lockups */
 > > +	printk(KERN_INFO PFX
 > > +		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n"
 > > +		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) active,\n"
 > > +		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to investigate)\n"
 > > +	);
 > 
 > I'm not sure if we want such big/ugly warnings. Can you get it to one
 > line, at least?

I'd drop this completely. The majority of users will never see it anyway,
and the boot process already spews so much stuff that it'll just get lost
in the noise.

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
