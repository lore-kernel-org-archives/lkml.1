Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbZGPRz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbZGPRz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbZGPRz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:55:56 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:33133 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbZGPRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:55:55 -0400
Date: Thu, 16 Jul 2009 10:55:54 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] edac: mpc85xx add mpc83xx support
Message-ID: <20090716175554.GE4791@ovro.caltech.edu>
References: <4a5e1429.oPkJ51dGVScq0izk%dougthompson@xmission.com> <20090715125249.e746496f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715125249.e746496f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 16 Jul 2009 10:55:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:52:49PM -0700, Andrew Morton wrote:
> On Wed, 15 Jul 2009 11:38:49 -0600
> dougthompson@xmission.com wrote:
> 
> > 
> > Add support for the Freescale MPC83xx memory controller to the existing
> > driver for the Freescale MPC85xx memory controller. The only difference
> > between the two processors are in the CS_BNDS register parsing code, which
> > has been changed so it will work on both processors.
> > 
> > The L2 cache controller does not exist on the MPC83xx, but the OF subsystem
> > will not use the driver if the device is not present in the OF device tree.
> > 
> > 
> > Kumar, I had to change the nr_pages calculation to make the math work
> > out. I checked it on my board and did the math by hand for a 64GB 85xx
> > using 64K pages. In both cases, nr_pages * PAGE_SIZE comes out to the
> > correct value. Thanks for the help.
> > 
> > v1 -> v2:
> >   * Use PAGE_SHIFT to parse cs_bnds regardless of board type
> >   * Remove special-casing for the 83xx processor
> > 
> > ...
> >
> > @@ -789,19 +791,20 @@ static void __devinit mpc85xx_init_csrow
> >  		csrow = &mci->csrows[index];
> >  		cs_bnds = in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
> >  				  (index * MPC85XX_MC_CS_BNDS_OFS));
> > -		start = (cs_bnds & 0xfff0000) << 4;
> > -		end = ((cs_bnds & 0xfff) << 20);
> > -		if (start)
> > -			start |= 0xfffff;
> > -		if (end)
> > -			end |= 0xfffff;
> > +
> > +		start = (cs_bnds & 0xffff0000) >> 16;
> > +		end   = (cs_bnds & 0x0000ffff);
> >  
> >  		if (start == end)
> >  			continue;	/* not populated */
> >  
> > +		start <<= (24 - PAGE_SHIFT);
> > +		end   <<= (24 - PAGE_SHIFT);
> > +		end    |= (1 << (24 - PAGE_SHIFT)) - 1;
> 
> <stares for a while>
> 
> That looks like the original code was really really wrong.
> 

Looking at the original code again, I agree. It does look wrong. For the
new code, I've run the math by hand for a number of different cases:
83xx, 256MB of RAM, 4K pages (I've tested this on my board too)
85xx, 64GB of RAM, 4K pages
85xx, 64GB of RAM, 64K pages

Let me describe the CS_BNDS register layout for you:
85xx: 0x0XXX0YYY

X's: start address for chip select N: the 12msb's of the 36-bit address
Y's: end address for chip select N: the 12msb's of the 36-bit address

83xx: 0x00XX00YY

X's: start address for chip select N: the 8 msb's of the 32-bit address
Y's: end address for chip select N: the 8 msb's of the 32-bit address

So, on an 83xx with 256MB of RAM in a single bank:
CS_BNDS0 is 0x0000000f. 83xx uses 4K pages, so PAGE_SHIFT = 12

start = 0x0;
end = 0xf;

/* Now the shifts happen */
start == 0x0;
end == 0xffff;

The pfn for the csrow->first_page and csrow->last_page seem correct to
me. The csrow->nr_pages seems correct too: 0x10000 pages * 4K == 256MB.

> The setting of all the lower bits in `end' is funny-looking.  What's
> happening here?  Should it be commented?
> 

That's exactly what's happening, the lower bits are all set. That's so
you can get the end address of the memory bank.

> 
> >  		csrow->first_page = start >> PAGE_SHIFT;
> >  		csrow->last_page = end >> PAGE_SHIFT;
> > -		csrow->nr_pages = csrow->last_page + 1 - csrow->first_page;
> > +		csrow->nr_pages = end + 1 - start;
> >  		csrow->grain = 8;
> >  		csrow->mtype = mtype;
> >  		csrow->dtype = DEV_UNKNOWN;
> > @@ -985,6 +988,7 @@ static struct of_device_id mpc85xx_mc_er
> >  	{ .compatible = "fsl,mpc8560-memory-controller", },
> >  	{ .compatible = "fsl,mpc8568-memory-controller", },
> >  	{ .compatible = "fsl,mpc8572-memory-controller", },
> > +	{ .compatible = "fsl,mpc8349-memory-controller", },
> >  	{ .compatible = "fsl,p2020-memory-controller", },
> >  	{},
> >  };
> > @@ -1001,13 +1005,13 @@ static struct of_platform_driver mpc85xx
> >  		   },
> >  };
> >  
> > -
> > +#ifdef CONFIG_MPC85xx
> >  static void __init mpc85xx_mc_clear_rfxe(void *data)
> >  {
> >  	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
> >  	mtspr(SPRN_HID1, (orig_hid1[smp_processor_id()] & ~0x20000));
> >  }
> > -
> > +#endif
> >  
> >  static int __init mpc85xx_mc_init(void)
> >  {
> > @@ -1040,26 +1044,32 @@ static int __init mpc85xx_mc_init(void)
> >  		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
> >  #endif
> >  
> > +#ifdef CONFIG_MPC85xx
> >  	/*
> >  	 * need to clear HID1[RFXE] to disable machine check int
> >  	 * so we can catch it
> >  	 */
> >  	if (edac_op_state == EDAC_OPSTATE_INT)
> >  		on_each_cpu(mpc85xx_mc_clear_rfxe, NULL, 0);
> > +#endif
> >  
> >  	return 0;
> >  }
> 
> The patch adds lots of ifdefs :(
> 

Yeah, it does. The HID1 register is a processor model specific register.
It isn't valid on the 83xx. The register exists, but the bits in it have
different meanings. I would have moved this code to the mc_probe()
routine, but I was advised against it.

> >  module_init(mpc85xx_mc_init);
> >  
> > +#ifdef CONFIG_MPC85xx
> >  static void __exit mpc85xx_mc_restore_hid1(void *data)
> >  {
> >  	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
> >  }
> > +#endif
> 
> afacit this will run smp_processor_id() from within preemptible code,
> which is often buggy on preemptible kernels and will cause runtime
> warnings on at least some architectures.
> 

I don't know much about smp_processor_id(). You'll have to talk with
Kumar/Dave Jiang about the reasons for this code.

Hopefully that helps to clear up some of the concerns about the patch.

Thanks,
Ira
