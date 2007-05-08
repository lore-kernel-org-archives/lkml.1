Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXEHHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXEHHZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbXEHHZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:25:38 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:40446 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933913AbXEHHZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:25:37 -0400
Date: Tue, 8 May 2007 11:23:35 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: olof@lixom.net (Olof Johansson)
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070508112335.4a8d6635@localhost.localdomain>
In-Reply-To: <20070507135609.GA8513@lixom.net>
References: <20070506011004.12695.41514.stgit@localhost.localdomain>
	<20070506012619.12695.37601.stgit@localhost.localdomain>
	<20070507135609.GA8513@lixom.net>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 08:56:09 -0500
Olof Johansson wrote:

> Hi,
> 
> Some minor nitpicks below. Overall it looks good.
> 
> 
> -Olof
> 
> On Sun, May 06, 2007 at 05:26:33AM +0400, Vitaly Bordug wrote:
> > @@ -322,6 +334,70 @@ void init_smc_ioports(struct
> > fs_uart_platform_info *data) }
> >  }
> >  
> > +#ifdef CONFIG_PCMCIA_M8XX
> > +static void pcmcia_hw_setup(int slot, int enable)
> > +{
> > +	unsigned *bcsr_io;
> > +
> > +	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
> > +	if (enable)
> > +		clrbits32(bcsr_io, BCSR1_PCCEN);
> > +	else
> > +		setbits32(bcsr_io, BCSR1_PCCEN);
> > +
> > +	iounmap(bcsr_io);
> > +}
> 
> If you move this (and next) function up, you don't have to do the
> prototypes in the beginning of the file. One less #ifdef that way.
> 
ok.
> > +
> > +static int pcmcia_set_voltage(int slot, int vcc, int vpp)
> > +{
> > +	u32 reg = 0;
> > +	unsigned *bcsr_io;
> > +
> > +	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
> > +
> > +	switch(vcc) {
> > +	case 0:
> > +		break;
> > +	case 33:
> > +		reg |= BCSR1_PCCVCC0;
> > +		break;
> > +	case 50:
> > +		reg |= BCSR1_PCCVCC1;
> > +		break;
> > +	default:
> > +		return 1;
> > +	}
> > +
> > +	switch(vpp) {
> > +	case 0:
> > +       	break;
> > +	case 33:
> > +	case 50:
> > +       	if(vcc == vpp)
> > +			reg |= BCSR1_PCCVPP1;
> > +		else
> > +			return 1;
> > +		break;
> > +	case 120:
> > +	if ((vcc == 33) || (vcc == 50))
> > +		reg |= BCSR1_PCCVPP0;
> > +	else
> > +		return 1;
> > +	default:
> > +		return 1;
> > +	}
> > +
> > +	/* first, turn off all power */
> > +	clrbits32(bcsr_io, 0x00610000);
> > +
> > +	/* enable new powersettings */
> > +	setbits32(bcsr_io, reg);
> > +
> > +	iounmap(bcsr_io);
> > +	return 0;
> > +}
> > +#endif
> > +
> >  int platform_device_skip(const char *model, int id)
> >  {
> >  #ifdef CONFIG_MPC8xx_SECOND_ETH_SCC3
> > diff --git a/arch/powerpc/sysdev/fsl_soc.c
> > b/arch/powerpc/sysdev/fsl_soc.c index 8a123c7..880e45f 100644
> > --- a/arch/powerpc/sysdev/fsl_soc.c
> > +++ b/arch/powerpc/sysdev/fsl_soc.c
> > @@ -1028,6 +1028,19 @@ err:
> >  
> >  arch_initcall(fs_enet_of_init);
> >  
> > +static int __init fsl_pcmcia_of_init(void)
> > +{
> > +	struct device_node *np = NULL;
> > +	/*
> > +	 * Register all the devices which type is "pcmcia"
> > +	 */
> > +	while ((np = of_find_compatible_node(np, 
> > +			"pcmcia", "fsl,pq-pcmcia")) != NULL)
> > +			    of_platform_device_create(np,
> > "m8xx-pcmcia", NULL);
> 
> Do you really need this now that you have the device table in the
> driver?
> 
Want to keep this one for now... 

> > +	return 0;
> > +}
> > +
> > +arch_initcall(fsl_pcmcia_of_init);
> >  
> >  static const char *smc_regs = "regs";
> >  static const char *smc_pram = "pram";
> > diff --git a/arch/powerpc/sysdev/mpc8xx_pic.h
> > b/arch/powerpc/sysdev/mpc8xx_pic.h index afa2ee6..07be061 100644
> > --- a/arch/powerpc/sysdev/mpc8xx_pic.h
> > +++ b/arch/powerpc/sysdev/mpc8xx_pic.h
> > @@ -4,7 +4,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/interrupt.h>
> >  
> > -extern struct hw_interrupt_type mpc8xx_pic;
> > +/*extern struct hw_interrupt_type mpc8xx_pic;*/
> 
> Take it out or leave it in, but don't comment it out, please
> 
ok
> >  
> >  int mpc8xx_pic_init(void);
> >  unsigned int mpc8xx_get_irq(void);
> > diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> > index 35f8864..c3fd55d 100644
> > --- a/drivers/pcmcia/Kconfig
> > +++ b/drivers/pcmcia/Kconfig
> > @@ -183,6 +183,7 @@ config PCMCIA_M8XX
> >          tristate "MPC8xx PCMCIA support"
> >          depends on PCMCIA && PPC && 8xx 
> >          select PCCARD_IODYN
> > +	select PCCARD_NONSTATIC
> 
> I was going to say "whitespace!", but seems like this added line is
> the only one that's actually using tabs. :-) (Yes, I saw 2/2 that
> fixes this).
> 
> >          help
> >          Say Y here to include support for PowerPC 8xx series PCMCIA
> >          controller.


-- 
Sincerely, Vitaly

