Return-Path: <linux-kernel-owner+w=401wt.eu-S2992998AbXEBKRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992998AbXEBKRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXEBKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:17:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51987 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754992AbXEBKR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:17:28 -0400
Date: Wed, 2 May 2007 12:17:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Andrew Morton <akpm@osdl.org>, davej@codemonkey.org.uk,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       kernel list <linux-kernel@vger.kernel.org>, andi@lisas.de
Subject: Re: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Message-ID: <20070502101718.GC10245@elf.ucw.cz>
References: <20070116135727.GA2831@elf.ucw.cz> <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070501145947.GA19953@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501145947.GA19953@rhlx01.hs-esslingen.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Especially the PCI video_state trick finally got me a working resume on
> > > > > 2.6.19-ck2 r128 Rage Mobility M4 AGP *WITH*(!) fully enabled and working
> > > > > (and keeping working!) DRI (3D).
> > > > 
> > > > Can we get whitelist entry for suspend.sf.net? s2ram from there can do
> > > > all the tricks you described, one letter per trick :-). We even got
> > > > PCI saving lately.
> > > 
> > > Whitelist? Let me blacklist it all the way to Timbuktu instead!
> > 
> > > I've been doing more testing, and X never managed to come back to working
> > > state without some of my couple intel-agp changes:
> > > - a proper suspend method, doing a proper pci_save_state()
> > >   or improved equivalent
> > > - a missing resume check for my i815 chipset
> > > - global cache flush in _configure
> > > - restoring AGP bridge PCI config space
> > 
> > Can you post a patch?
> 
> Took way longer than I'd have wanted it to (nice daughter and stuff ;),
> but here it is.

No problem.

Ok, I guess we'll  need a real commit log.


>  #define INTEL_I820_RDCR		0x51
> @@ -664,7 +671,7 @@
>  	if ((pg_start + mem->page_count) > num_entries)
>  		goto out_err;
>  
> -	/* The i830 can't check the GTT for entries since its read only,
> +	/* The i830 can't check the GTT for entries since it's read-only,
>  	 * depend on the caller to make the correct offset decisions.
>  	 */
>  
> @@ -787,7 +794,7 @@
>  	if ((pg_start + mem->page_count) > num_entries)
>  		goto out_err;
>  
> -	/* The i915 can't check the GTT for entries since its read only,
> +	/* The i915 can't check the GTT for entries since it's read-only,
>  	 * depend on the caller to make the correct offset decisions.
>  	 */
>  

You should not do cleanups at the same time as code changes.

> @@ -1103,8 +1110,8 @@
>  	/* attbase - aperture base */
>  	/* the Intel 815 chipset spec. says that bits 29-31 in the
>  	* ATTBASE register are reserved -> try not to write them */
> -	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
> -		printk (KERN_EMERG PFX "gatt bus addr too high");
> +	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
> +		printk (KERN_EMERG PFX "gatt bus addr too high\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1119,7 +1126,7 @@
>  	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
>  
>  	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
> -	addr &= INTEL_815_ATTBASE_MASK;
> +	addr &= I815_ATTBASE_MASK;
>  	addr |= agp_bridge->gatt_bus_addr;
>  	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);

And I guess macro search&replace counts as cleanup, too. It would be
nice to submit them separately and first.

> @@ -1355,7 +1362,7 @@
>  	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_bus_addr);
>  
>  	/* agpctrl */
> -	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
> +	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x00000000);
>  

Huh?

>  #ifdef CONFIG_PM
> +

I'd kill this empty line.

> +static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
> +{
> +	typedef struct {
> +		int reg;
> +		u32 value;
> +	} saved_regs;
> +
> +	/* Dell Inspiron 8000 BIOS rev. A23 needs the following registers saved
> +	 * to be able to successfully restore X11 when AGP 3D is enabled
> +	 * (register values given are after resume vs. before suspend):
> +	 *
> +	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global Enable) of I815_APCONT (0x51),
> +	 *              thus use I815_GMCHCFG (0x50) as 32bit base register); 0x4fdd0040 instead of 0x4fdd0240
> +	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
> +	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
> +	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
> +	 * I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
> +	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
> +	 * INTEL_APSIZE (0xb4);
> +	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
> +	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above); 0x00000000 instead of 0x00000800
> +	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
> +	 *
> +	 * Other machines/chipsets/BIOS versions may require
> +	 * a different set of registers to be properly saved.
> +	 */
> +	static saved_regs i815_saved_regs[] = {
> +		{ I815_UNKNOWN_80, 0 },
> +		{ I815_GMCHCFG, 0 },
> +		{ I815_SM_RCOMP, 0 },
> +		{ I815_SM, 0 },
> +		{ I815_AGPCMD, 0 },
> +		{ INTEL_AGPCTRL, 0 },
> +		{ INTEL_APSIZE, 0 },
> +		{ INTEL_ATTBASE, 0 },
> +		{ I815_ERRSTS, 0 },
> +		{ I815_UNKNOWN_E8, 0 },
> +		{ 0, 0 }, /* DELIMITER */
> +	};
> +	saved_regs *p;
> +
> +	if (restore) {
> +		u32 val;
> +		for (p = i815_saved_regs; (p->reg != 0); p++)
> +		{

This goes to previous line. ";p->reg ;" is enough.

> +			pci_read_config_dword(pdev, p->reg, &val);
> +			if (val != p->value) {
> +				printk(KERN_DEBUG "AGP: Writing back config space on "
> +					"device %s at offset %x (was %x, writing %x)\n",
> +					pci_name(pdev), p->reg,
> +					val, p->value);
> +				pci_write_config_dword(pdev, p->reg,
> +					p->value);
> +			}
> +		}	
> +	} else {
> +		for (p = i815_saved_regs; (p->reg != 0); p++)

Same here.

> +			pci_read_config_dword(pdev, p->reg, &p->value);
> +	}
> +	return 1;
> +}

Should this betwo functions, one for save, one for restore, with "to
save" array being global?

> +/*
> + * set DEBUG_AGP_PM to 1 if your AGP chipset has issues resuming
> + * (machine lockups due to non-restored hardware registered values),
> + * then figure out from the log which registers have to be restored manually,
> + * then add specific support for your chipset, similar to what already exists

Can we get debugging stuff separately?

> @@ -2106,6 +2282,12 @@
>  {
>  	if (agp_off)
>  		return -EINVAL;
> +	/* let people know that this is an important place to investigate at in case of resume lockups */
> +	printk(KERN_INFO PFX
> +		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n"
> +		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) active,\n"
> +		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to investigate)\n"
> +	);

I'm not sure if we want such big/ugly warnings. Can you get it to one
line, at least?

Otherwise it looks ok.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
