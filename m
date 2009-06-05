Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZFEXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZFEXdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZFEXd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:33:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:55244 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZFEXdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:33:25 -0400
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
 [drivers/staging/comedi/drivers.o]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Michael Ellerman <michael@ellerman.id.au>
In-Reply-To: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Jun 2009 09:32:29 +1000
Message-Id: <1244244749.31984.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I tried this. But, with some catch. ‘PAGE_KERNEL_NOCACHE’ seems to be the
> choice for majority of architectures like frv, m32r, sh, x86, etc, as Geert
> mentions below. However, i believe POWERPC defines it as ‘PAGE_KERNEL_NC‘
> found at arch/powerpc/include/asm/pte-common.h.
> 
> Paul/Banjamin,
> Can you please confirm this ?

Read my reply to Greg. Why the heck are you trying to map memory
non-cacheable in the first place ?

Cheers
Ben.

> The below patch fixes the build error.
> 
> Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> ---
> 
> --- linux-2.6.30-rc8/drivers/staging/comedi/drivers.c.orig	2009-06-05 12:46:35.000000000 -0500
> +++ linux-2.6.30-rc8/drivers/staging/comedi/drivers.c	2009-06-05 13:03:31.000000000 -0500
> @@ -43,9 +43,13 @@
>  #include <linux/vmalloc.h>
>  #include <linux/cdev.h>
>  #include <linux/dma-mapping.h>
> -
>  #include <asm/io.h>
>  #include <asm/system.h>
> +#ifdef __powerpc64__
> +#include <asm/pte-common.h>
> +#else
> +#include <asm/pgtable.h>
> +#endif
>  
>  static int postconfig(struct comedi_device *dev);
>  static int insn_rw_emulate_bits(struct comedi_device *dev, struct comedi_subdevice *s,
> @@ -492,8 +496,13 @@ int comedi_buf_alloc(struct comedi_devic
>  		}
>  		if (i == n_pages) {
>  			async->prealloc_buf =
> +#ifdef __powerpc64__
> +				vmap(pages, n_pages, VM_MAP,
> +				PAGE_KERNEL_NC);
> +#else
>  				vmap(pages, n_pages, VM_MAP,
>  				PAGE_KERNEL_NOCACHE);
> +#endif
>  		}
>  		if (pages) {
>  			vfree(pages);
> 
> ---
> Regards--
> Subrata
> 
> > PAGE_KERNEL_NOCACHE is defined on a few architectures only, namely
> > frv, m32r, mn10300, sh, and x86[*]. On all others, it will fail.
> > 
> > [*] Interestingly, sparc refers to it in one of its include files,
> > without providing a
> >     definition, Probably that code is unused.
> > 
> > Gr{oetje,eeting}s,
> > 
> > 						Geert
> > 
> > --
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> > 

