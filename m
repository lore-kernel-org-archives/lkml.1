Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZFDP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZFDP2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZFDP2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:28:35 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62583 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZFDP2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:28:34 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/HeTH3uAszghjTYGOXIBQh
Date: Thu, 4 Jun 2009 08:28:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: vimal singh <vimalsingh@ti.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, dedekind@infradead.org,
       david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH] [MTD] [NAND] Add prefetch and dma support for omap2/3
	NAND      driver
Message-ID: <20090604152823.GB7428@atomide.com>
References: <54851.192.168.10.89.1243946277.squirrel@dbdmail.itg.ti.com> <47286.192.168.10.89.1244108023.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47286.192.168.10.89.1244108023.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* vimal singh <vimalsingh@ti.com> [090604 02:34]:
> On Wed, Jun 3, 2009 at 10:03 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Singh, Vimal
> <IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com> [090602
> 23:46]:
> >>
> >> On Wed, Jun 3, 2009 at 2:06 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> > * vimal singh <vimalsingh@ti.com> [090602 05:40]:
> >> >> This patch adds prefetch support to access nand flash in both mpu and dma
> mode.
> >> >> This patch also adds 8-bit nand support (omap_read/write_buf8).
> >> >> Prefetch can be used for both 8- and 16-bit devices.
> >> >
> >> > This should be reviewed on the linux-omap@vger.kernel.org list for sure.
> >> > One other comment below.
> >> >
> >> >> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
> >> >> ---
> >> >> I prepared this patch on top of "OMAP2 / OMAP3 NAND driver" patch:
> >> >> http://lists.infradead.org/pipermail/linux-mtd/2009-May/025562.html
> >> >>
> >> >> ---
> >> >>  arch/arm/mach-omap2/gpmc.c             |  102 ++++++++++
> >> >>  arch/arm/plat-omap/include/mach/gpmc.h |    4
> >> >>  drivers/mtd/nand/Kconfig               |   17 +
> >> >>  drivers/mtd/nand/omap2.c               |  308
> ++++++++++++++++++++++++++++++++-
> >> >>  4 files changed, 422 insertions(+), 9 deletions(-)
> >> >>
> >> >> Index: mtd-2.6/arch/arm/mach-omap2/gpmc.c
> >> >> ===================================================================
> >> >> --- mtd-2.6.orig/arch/arm/mach-omap2/gpmc.c
> >> >> +++ mtd-2.6/arch/arm/mach-omap2/gpmc.c
> >> >> @@ -54,6 +54,12 @@
> >> >>  #define GPMC_CHUNK_SHIFT     24              /* 16 MB */
> >> >>  #define GPMC_SECTION_SHIFT   28              /* 128 MB */
> >> >>
> >> >> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
> >> >> +#define CS_NUM_SHIFT         24
> >> >> +#define ENABLE_PREFETCH              7
> >> >> +#define DMA_MPU_MODE         2
> >> >> +#endif
> >> >> +
> >> >>  static struct resource       gpmc_mem_root;
> >> >>  static struct resource       gpmc_cs_mem[GPMC_CS_NUM];
> >> >>  static DEFINE_SPINLOCK(gpmc_mem_lock);
> >> >> @@ -383,6 +389,99 @@ void gpmc_cs_free(int cs)
> >> >>  }
> >> >>  EXPORT_SYMBOL(gpmc_cs_free);
> >> >>
> >> >> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
> >> >> +/**
> >> >> + * gpmc_prefetch_init - configures default configuration for prefetch
> engine
> >> >> + */
> >> >> +static void gpmc_prefetch_init(void)
> >> >> +{
> >> >> +     /* Setting the default threshold to 64 */
> >> >> +     gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0x0);
> >> >> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG1, 0x40  << 8);
> >> >> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG2, 0x0);
> >> >> +}
> >> >
> >> > Why would you want to have NAND specific init code int gpmc.c?
> >> >
> >> > The purpose if gpmc.c is to provide access to configuring the
> >> > General Purpose Memory Controller (GPMC). You should just provide
> >> > functions in gpmc.c for the platform init code to use, and then
> >> > the drivers can stay platform independent.
> >>
> >> In my understanding, this 'prefetch' engine is part of GPMC itself, it is a
> >> kind of feature provided by GPMC which can be utilized by NAND driver.
> >> So, to me, it makes sens to get initialized prefetch by GPMC itself so that
> >> NAND driver can use it.
> >
> > But it should not have a dependency to NAND.
> 
> This engine, in GPMC, is dedicated for NAND devices only.
> 
> >
> >> Another reason was that all read / write to GPMC register are done by
> >> functions 'gpmc_read_reg' / 'gpmc_write_reg', which have been made
> >> 'static' in nature.
> >
> > That's why you need to provide a generic function in gpmc.c to enable
> > prefetch that the platform code for any driver can use.
> 
> Exactly, and whenever a platform code uses gpmc init call, gpmc initializes
> this engine too. Since prefetch engine is the part of GPMC, IMHOP, it should
> get initialized as part of GPMC initialization.

No, the driver needing it should initialize it. There should not be any
ifdefs needed in the gpmc.c for that.
 
> And then there are prefetch start, stop and status functions calls have been
> provided to be used by NAND driver.

These should really be done in the platform init code for the NAND driver.
The NAND driver really should be generic, not omap specific.

Tony
