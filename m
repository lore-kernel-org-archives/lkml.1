Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZFCQeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZFCQeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZFCQd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:33:59 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62966 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZFCQd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:33:58 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19goHOL9xlloXmxA3uUvl+N
Date: Wed, 3 Jun 2009 09:33:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Singh, Vimal" 
	<IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "dedekind@infradead.org" <dedekind@infradead.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] [MTD] [NAND] Add prefetch and dma support for omap2/3
	NAND driver
Message-ID: <20090603163344.GC5026@atomide.com>
References: <20090602203629.GM27332@atomide.com> <19F8576C6E063C45BE387C64729E739404321C6096@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739404321C6096@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Singh, Vimal <IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com> [090602 23:46]:
> 
> On Wed, Jun 3, 2009 at 2:06 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * vimal singh <vimalsingh@ti.com> [090602 05:40]:
> >> This patch adds prefetch support to access nand flash in both mpu and dma mode.
> >> This patch also adds 8-bit nand support (omap_read/write_buf8).
> >> Prefetch can be used for both 8- and 16-bit devices.
> >
> > This should be reviewed on the linux-omap@vger.kernel.org list for sure.
> > One other comment below.
> >
> >> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
> >> ---
> >> I prepared this patch on top of "OMAP2 / OMAP3 NAND driver" patch:
> >> http://lists.infradead.org/pipermail/linux-mtd/2009-May/025562.html
> >>
> >> ---
> >>  arch/arm/mach-omap2/gpmc.c             |  102 ++++++++++
> >>  arch/arm/plat-omap/include/mach/gpmc.h |    4
> >>  drivers/mtd/nand/Kconfig               |   17 +
> >>  drivers/mtd/nand/omap2.c               |  308 ++++++++++++++++++++++++++++++++-
> >>  4 files changed, 422 insertions(+), 9 deletions(-)
> >>
> >> Index: mtd-2.6/arch/arm/mach-omap2/gpmc.c
> >> ===================================================================
> >> --- mtd-2.6.orig/arch/arm/mach-omap2/gpmc.c
> >> +++ mtd-2.6/arch/arm/mach-omap2/gpmc.c
> >> @@ -54,6 +54,12 @@
> >>  #define GPMC_CHUNK_SHIFT     24              /* 16 MB */
> >>  #define GPMC_SECTION_SHIFT   28              /* 128 MB */
> >>
> >> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
> >> +#define CS_NUM_SHIFT         24
> >> +#define ENABLE_PREFETCH              7
> >> +#define DMA_MPU_MODE         2
> >> +#endif
> >> +
> >>  static struct resource       gpmc_mem_root;
> >>  static struct resource       gpmc_cs_mem[GPMC_CS_NUM];
> >>  static DEFINE_SPINLOCK(gpmc_mem_lock);
> >> @@ -383,6 +389,99 @@ void gpmc_cs_free(int cs)
> >>  }
> >>  EXPORT_SYMBOL(gpmc_cs_free);
> >>
> >> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
> >> +/**
> >> + * gpmc_prefetch_init - configures default configuration for prefetch engine
> >> + */
> >> +static void gpmc_prefetch_init(void)
> >> +{
> >> +     /* Setting the default threshold to 64 */
> >> +     gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0x0);
> >> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG1, 0x40  << 8);
> >> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG2, 0x0);
> >> +}
> >
> > Why would you want to have NAND specific init code int gpmc.c?
> >
> > The purpose if gpmc.c is to provide access to configuring the
> > General Purpose Memory Controller (GPMC). You should just provide
> > functions in gpmc.c for the platform init code to use, and then
> > the drivers can stay platform independent.
> 
> In my understanding, this 'prefetch' engine is part of GPMC itself, it is a
> kind of feature provided by GPMC which can be utilized by NAND driver.
> So, to me, it makes sens to get initialized prefetch by GPMC itself so that 
> NAND driver can use it.

But it should not have a dependency to NAND. 
 
> Another reason was that all read / write to GPMC register are done by 
> functions 'gpmc_read_reg' / 'gpmc_write_reg', which have been made
> 'static' in nature.

That's why you need to provide a generic function in gpmc.c to enable
prefetch that the platform code for any driver can use.

Tony
