Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYLKVq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYLKVq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbYLKVqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:46:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbYLKVqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:46:18 -0500
Date: Thu, 11 Dec 2008 13:45:24 -0800
From: Greg KH <gregkh@suse.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <alokkataria1@gmail.com>,
       "bruno.premont@restena.lu" <bruno.premont@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27, 2.6.28 kernels
Message-ID: <20081211214524.GA31581@suse.de>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com> <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com> <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com> <49405CB6.6010006@kernel.org> <20081211033105.GA31972@suse.de> <1229034191.8766.63.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229034191.8766.63.camel@bodhitayantram.eng.vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 02:23:11PM -0800, Zachary Amsden wrote:
> On Wed, 2008-12-10 at 19:31 -0800, Greg KH wrote:
> 
> > > +#ifdef CONFIG_VMI
> > > +	/* VMI may relocate the fixmap; do this before touching ioremap area */
> > > +	vmi_init();
> > > +#endif
> > 
> > Shouldn't the #ifdef not be needed here if the .h files are set up
> > properly for the vmi_init prototype?  Please try to keep them out of .c
> > files wherever possible.
> 
> Yes, they should.  Judging by setup.c though, you would think the
> opposite... in any case I fixed it.  Please apply - and yes, I tested
> compile both ways.

> VMI initialiation can relocate the fixmap, causing early_ioremap
> to malfunction if it is initialized before the relocation.
> To fix this, VMI activation is split into two phases; the detection,
> which must happen before setting up ioremap, and the activation,
> which must happen after parsing early boot parameters.
> 
> This fixes a crash on boot when VMI is enabled under VMware.
> 
> Signed-off-by: Zachary Amsden <zach@vmware.com>
> 
> diff --git a/arch/x86/include/asm/vmi.h b/arch/x86/include/asm/vmi.h
> index b7c0dea..128958a 100644
> --- a/arch/x86/include/asm/vmi.h
> +++ b/arch/x86/include/asm/vmi.h
> @@ -223,9 +223,15 @@ struct pci_header {
>  } __attribute__((packed));
>  
>  /* Function prototypes for bootstrapping */
> +#ifdef CONFIG_VMI
>  extern void vmi_init(void);
> +extern void vmi_activate(void);
>  extern void vmi_bringup(void);
> -extern void vmi_apply_boot_page_allocations(void);
> +#else
> +#define vmi_init()
> +#define vmi_activate()
> +#define vmi_bringup()
> +#endif

static inline please, don't use #defines for function prototypes, it's
not nice.  See Andrew's previous rants about this for details :)

thanks,

greg k-h
