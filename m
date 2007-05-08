Return-Path: <linux-kernel-owner+w=401wt.eu-S966405AbXEHRcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966405AbXEHRcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXEHRcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:32:14 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:36784 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965528AbXEHRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:32:13 -0400
Date: Tue, 8 May 2007 21:31:45 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070508213145.328cf5f4@localhost.localdomain>
In-Reply-To: <774F0168-051E-4C6B-9292-8EE731E6D889@kernel.crashing.org>
References: <20070508095001.20018.85403.stgit@localhost.localdomain>
	<20070508095038.20018.60060.stgit@localhost.localdomain>
	<774F0168-051E-4C6B-9292-8EE731E6D889@kernel.crashing.org>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.11; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 09:04:22 -0500
Kumar Gala wrote:

> 
> On May 8, 2007, at 4:50 AM, Vitaly Bordug wrote:
> 
> >
> > Adds support for PowerQuicc on-chip PCMCIA. The driver is  
> > implemented as
> > of_device, so only arch/powerpc stuff is capable to use it, which
> > now implies only mpc885ads reference board.
> >
> > To cope with the code that should be hooked inside driver, but is  
> > really
> > board specific (like set_voltage), global structure
> > mpc8xx_pcmcia_ops holds necessary function pointers that are filled
> > in the BSP code.
> >
> > Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Acked-by: Olof Johansson <olof@lixom.net>
> >
> > ---
> >
> >  arch/powerpc/boot/dts/mpc885ads.dts          |   12 +
> >  arch/powerpc/platforms/8xx/m8xx_setup.c      |    5
> >  arch/powerpc/platforms/8xx/mpc885ads.h       |    8 +
> >  arch/powerpc/platforms/8xx/mpc885ads_setup.c |   72 +++++
> >  arch/powerpc/sysdev/fsl_soc.c                |   13 +
> >  arch/powerpc/sysdev/mpc8xx_pic.h             |    2
> >  drivers/pcmcia/Kconfig                       |    1
> >  drivers/pcmcia/m8xx_pcmcia.c                 |  351 +++++++++++ 
> > +--------------
> >  include/asm-powerpc/mpc8xx.h                 |    4
> >  include/linux/fsl_devices.h                  |    5
> >  10 files changed, 287 insertions(+), 186 deletions(-)
> >
> > diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/ 
> > boot/dts/mpc885ads.dts
> > index 110bf61..0786ac1 100644
> > --- a/arch/powerpc/boot/dts/mpc885ads.dts
> > +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> > @@ -112,6 +112,18 @@
> >  			compatible = "CPM";
> >  		};
> >
> > +		pcmcia@0080 {
> > +			#address-cells = <3>;
> > +			#interrupt-cells = <1>;
> > +			#size-cells = <2>;
> > +			compatible = "fsl,pq-pcmcia";
> 
> should this be fsl,pq1-pcmcia or fsl,8xx-pcmcia?
>

there were a note that eventually fsl may create some 8xx that is not cpm...
I really think pq and pq1 is the same, for pq2, 3 etc number passed explicitly. 
> > +			device_type = "pcmcia";
> > +			reg = <80 80>;
> > +			clock-frequency = <2faf080>;
> 
> is the clock-freq fixed?
> 
gotta check, will follow-up.

> > +			interrupt-parent = <&mpc8xx-pic>;
> > +			interrupts = <d 1>;
> > +		};
> > +
> >  		cpm@ff000000 {
> >  			linux,phandle = <ff000000>;
> >  			#address-cells = <1>;
> > diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c
> > b/arch/powerpc/ platforms/8xx/m8xx_setup.c
> > index 0901dba..f169355 100644
> > --- a/arch/powerpc/platforms/8xx/m8xx_setup.c
> > +++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/root_dev.h>
> >  #include <linux/time.h>
> >  #include <linux/rtc.h>
> > +#include <linux/fsl_devices.h>
> >
> >  #include <asm/mmu.h>
> >  #include <asm/reg.h>
> > @@ -49,6 +50,10 @@
> >
> >  #include "sysdev/mpc8xx_pic.h"
> >
> > +#ifdef CONFIG_PCMCIA_M8XX
> > +struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
> > +#endif
> > +
> >  void m8xx_calibrate_decr(void);
> >  extern void m8xx_wdt_handler_install(bd_t *bp);
> >  extern int cpm_pic_init(void);
> > diff --git a/arch/powerpc/platforms/8xx/mpc885ads.h b/arch/powerpc/ 
> > platforms/8xx/mpc885ads.h
> > index 7c31aec..932b59a 100644
> > --- a/arch/powerpc/platforms/8xx/mpc885ads.h
> > +++ b/arch/powerpc/platforms/8xx/mpc885ads.h
> > @@ -91,5 +91,13 @@
> >  #define SICR_ENET_MASK	((uint)0x00ff0000)
> >  #define SICR_ENET_CLKRT	((uint)0x002c0000)
> >
> > +/*
> > + * Some internal interrupt registers use an 8-bit mask for the  
> > interrupt
> > + * level instead of a number.
> > + */
> > +static inline uint mk_int_int_mask(uint mask) {
> > +	return (1 << (7 - (mask/2)));
> > +}
> 
> would this be better off in sysdev/mpc8xx_pic.h?
> 
hmm, maybe.
> > +
> >  #endif /* __ASM_MPC885ADS_H__ */
> >  #endif /* __KERNEL__ */
> > diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/ 
> > powerpc/platforms/8xx/mpc885ads_setup.c
> > index a57b577..80e7214 100644
> > --- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> > +++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> > @@ -22,6 +22,7 @@
> >
> >  #include <linux/fs_enet_pd.h>
> >  #include <linux/fs_uart_pd.h>
> > +#include <linux/fsl_devices.h>
> >  #include <linux/mii.h>
> >
> >  #include <asm/delay.h>
> > @@ -51,6 +52,70 @@ static void init_smc1_uart_ioports(struct  
> > fs_uart_platform_info* fpi);
> >  static void init_smc2_uart_ioports(struct fs_uart_platform_info*  
> > fpi);
> >  static void init_scc3_ioports(struct fs_platform_info* ptr);
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
> > +		break;
> > +	case 33:
> > +	case 50:
> > +	if(vcc == vpp)
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
> 
> seems like formatting is of (but that could just me my email reader)
> 

darn it, I'll better Lindent this whole file too in 2-nd patch. plenty of whitespace, spacetabs, formatting issues...

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
> >  void __init mpc885ads_board_setup(void)
> >  {
> >  	cpm8xx_t *cp;
> > @@ -115,6 +180,12 @@ void __init mpc885ads_board_setup(void)
> >  	immr_unmap(io_port);
> >
> >  #endif
> > +
> > +#ifdef CONFIG_PCMCIA_M8XX
> > +	/*Set up board specific hook-ups*/
> > +	m8xx_pcmcia_ops.hw_ctrl = pcmcia_hw_setup;
> > +	m8xx_pcmcia_ops.voltage_set = pcmcia_set_voltage;
> > +#endif
> >  }
> >
> >
> > @@ -322,6 +393,7 @@ void init_smc_ioports(struct  
> > fs_uart_platform_info *data)
> >  	}
> >  }
> >
> > +
> 
> extra whitespace?
yes, ok.

[snip]
-- 
Sincerely, Vitaly

