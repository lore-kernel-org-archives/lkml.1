Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZAEVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZAEVDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZAEVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:02:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:53512 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753274AbZAEVCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:02:49 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1//1gx8Apn/sqUU5d5MTmMqEraHe6o64fcC/x0VHQ
	ZfMZCZK9khzLRt
Date: Mon, 5 Jan 2009 22:02:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
In-Reply-To: <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901052139400.8605@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Dan Williams wrote:

> On Fri, Dec 26, 2008 at 10:11 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi,
> >
> > This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> >
> 
> Tha drivers/dma/ bits look ok to me minus the new warnings:
> 
> drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_fn':
> drivers/dma/ipu/ipu_irq.c:328: warning: 'irq' may be used
> uninitialized in this function
> drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_err':
> drivers/dma/ipu/ipu_irq.c:290: warning: 'irq' may be used
> uninitialized in this function

Wow... with what gcc version? My 4.1.2 correctly recognises, that it 
_doesn't_ get used uninitialised.

> I can take patches 1 and 2 through the async_tx tree, or if you would
> rather, add my Acked-by to those and take 1-4 through the MXC tree.
> I'll be sending the async_tx pull request for 2.6.29 in the next few
> days.

Thanks, great! Don't know what's better, let's see what Sascha says. But 
there's one small problem with the patch 2/4: it breaks compilation on 
i.MX31 if IPU is _not_ set, so, default imx31 configs would break:-( The 
problem is, that I use CONFIG_MX3_IPU_IRQS unconditionally in calculation 
of NR_IRQ. The easiest for me is to fix it in mx31.h like

#ifdef CONFIG_MX3_IPU_IRQS
#define MX3_IPU_IRQS CONFIG_MX3_IPU_IRQS
#else
#define MX3_IPU_IRQS 0
#endif

but that's less than elegant:-) A probably better solution would be to fix 
this in Kconfig, best would be to show

config MX3_IPU_IRQS
	int "..."

if MX3_IPU is set and hide it otherwise, setting to 0... But I don't know 
off hand how to do this properly. Hm, looks like the following works:

config MX3_IPU_IRQS
	int "Number of dynamically mapped interrupts for IPU"
	depends on MX3_IPU
	range 2 137
	default 4
	help
	  Out of 137 interrupt sources on i.MX31 IPU only very few are used.
	  To avoid bloating the irq_desc[] array we allocate a sufficient
	  number of IRQ slots and map them dynamically to specific sources.

config MX3_IPU_IRQS
	int
	default 0
	depends on !MX3_IPU

Would it be considered a proper Kbuild (ab)use?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
