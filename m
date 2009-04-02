Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZDBSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZDBSeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbZDBSeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:34:07 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2720 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754828AbZDBSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:34:04 -0400
Date: Thu, 2 Apr 2009 22:33:57 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] QE USB Host Integration for MPC832x
Message-ID: <20090402183357.GA29050@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1238622396-9768-1-git-send-email-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1238622396-9768-1-git-send-email-marcel@ziswiler.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc'ing linuxppc-dev and Timur Tabi ]

On Wed, Apr 01, 2009 at 11:46:36PM +0200, Marcel Ziswiler wrote:
> Open issues:
> - MPC832x_MDS seems to lie about BCSR12_USMODE bit.
> - How to use qe_setbrg() with an external clock pin? Hard-coded for now.
> - How to properly allocate USB pram on MPC832x as standard layout won't work.
> - Detects USB device plugged in but then hangs.
> 
> Please CC me personally when answering/commenting my posting, thanks.

Wow, considering erratas, I'm quite surprised that QE USB works on
MPC832x. Well, I see that the USB hangs after all... Does it "work"
with QE microcode update or bare MPC832x can "work" too?

FWIW, I don't see any USB microcode updates on Freescale site
(http://opensource.freescale.com/firmware/), but I recalling some
QE USB firmwares in FSL BSPs...

Some comments down below.

> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> ---
>  arch/powerpc/boot/dts/mpc832x_mds.dts           |   74 ++++-
>  arch/powerpc/configs/83xx/mpc832x_mds_defconfig |  361 ++++++++++++-----------
>  arch/powerpc/platforms/83xx/Kconfig             |    1 +
>  arch/powerpc/platforms/83xx/mpc832x_mds.c       |   66 ++++
>  arch/powerpc/sysdev/qe_lib/qe.c                 |   10 +-
>  drivers/usb/host/fhci-hcd.c                     |    9 +
>  6 files changed, 336 insertions(+), 185 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/mpc832x_mds.dts b/arch/powerpc/boot/dts/mpc832x_mds.dts
> index 57c595b..f306edf 100644
> --- a/arch/powerpc/boot/dts/mpc832x_mds.dts
> +++ b/arch/powerpc/boot/dts/mpc832x_mds.dts
> @@ -59,9 +59,36 @@
>  		reg = <0x00000000 0x08000000>;
>  	};
>  
> -	bcsr@f8000000 {
> -		compatible = "fsl,mpc8323mds-bcsr";
> -		reg = <0xf8000000 0x8000>;
> +	localbus@e0005000 {
> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +		compatible = "fsl,mpc8323-localbus", "fsl,pq2pro-localbus",
> +			     "simple-bus";
> +		reg = <0xe0005000 0xd8>;
> +		ranges = <0 0 0xfe000000 0x02000000
> +		          1 0 0xf8000000 0x00008000>;
> +
> +		flash@0,0 {
> +			compatible = "cfi-flash";
> +			reg = <0 0 0x2000000>;
> +			bank-width = <2>;
> +			device-width = <1>;
> +		};
> +
> +		bcsr@1,0 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> + 			compatible = "fsl,mpc8323mds-bcsr";
> +			reg = <1 0 0x8000>;
> +			ranges = <0 1 0 0x8000>;
> +
> +			bcsr12: gpio-controller@c {
> +				#gpio-cells = <2>;
> +				compatible = "fsl,mpc8323mds-bcsr-gpio";
> +				reg = <0xc 1>;
> +				gpio-controller;
> +			};
> +		};
>  	};
>  
>  	soc8323@e0000000 {
> @@ -238,6 +265,14 @@
>  			};
>  
>  		};
> +
> +		qe_pio_a: gpio-controller@1400 {
> +			#gpio-cells = <2>;
> +			compatible = "fsl,mpc8360-qe-pario-bank",

fsl,mpc8360-qe-pario-bank doesn't fit here, just delete it.

> +				     "fsl,mpc8323-qe-pario-bank";
> +			reg = <0x1400 0x18>;
> +			gpio-controller;
> +		};
>  	};
>  
>  	qe@e0100000 {
> @@ -282,11 +317,25 @@
>  		};
>  
>  		usb@6c0 {
> -			compatible = "qe_udc";
> -			reg = <0x6c0 0x40 0x8b00 0x100>;
> -			interrupts = <11>;
> +			compatible = "fsl,mpc8360-qe-usb",

Ditto. No need for mpc8360 compatible.

> +				     "fsl,mpc8323-qe-usb";
> +			/* QUICC Engine Parameter RAM Base Addresses (Suggested
> +			   Value for User Configuration) Table 19-2 page 778 */
> +			reg = <0x6c0 0x40 0x700 0x100>;
> +			interrupts = <11>; /* Encoding the Interrupt Vector
> +					      Table 18-12 page 760 */
>  			interrupt-parent = <&qeic>;
> -			mode = "slave";
> +			/* Clock Source Options - Internal Clock Generators
> +			   Table 20-2 page 804 */
> +			fsl,fullspeed-clock = "brg10";
> +			fsl,lowspeed-clock = "brg10";
> +			gpios = <&qe_pio_a  8 0   /* USBOE */
> +				 &qe_pio_a  1 0   /* USBTXP */
> +				 &qe_pio_a  0 0   /* USBTXN */
> +				 &qe_pio_a  4 0   /* USBRXP */
> +				 &qe_pio_a  5 0   /* USBRXN */
> +				 &bcsr12    5 0   /* SPEED */
> +				 &bcsr12    4 1>; /* POWER */
>  		};
>  
>  		enet0: ucc@2200 {
> @@ -335,7 +384,6 @@
>  			pio-handle = < &pio5 >;
>  		};
>  
> -
>  		mdio@2320 {
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> @@ -366,6 +414,16 @@
>  			interrupts = <32 0x8 33 0x8>; //high:32 low:33
>  			interrupt-parent = <&ipic>;
>  		};
> +
> +		timer@440 {
> +			compatible = "fsl,mpc8323-qe-gtm",
> +				     "fsl,qe-gtm", "fsl,gtm";
> +			reg = <0x440 0x40>;
> +			interrupts = <12 13 14 15>;
> +			interrupt-parent = <&qeic>;
> +			/* filled by u-boot */
> +			clock-frequency = <0>;
> +		};
>  	};
>  
>  	pci0: pci@e0008500 {

[...defconfig changes snipped..]

> diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
> index 83c664a..68a2aeb 100644
> --- a/arch/powerpc/platforms/83xx/Kconfig
> +++ b/arch/powerpc/platforms/83xx/Kconfig
> @@ -20,6 +20,7 @@ config MPC832x_MDS
>  	bool "Freescale MPC832x MDS"
>  	select DEFAULT_UIMAGE
>  	select PPC_MPC832x
> +	select FSL_LBC

Unless you use UPM NAND driver you don't need this.

>  	help
>  	  This option enables support for the MPC832x MDS evaluation board.
>  
> diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
> index ec0b401..e9baae5 100644
> --- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
> +++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/stddef.h>
>  #include <linux/kernel.h>
> +#include <linux/compiler.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/reboot.h>
> @@ -37,6 +38,7 @@
>  #include <asm/udbg.h>
>  #include <sysdev/fsl_soc.h>
>  #include <sysdev/fsl_pci.h>
> +#include <sysdev/simple_gpio.h>
>  #include <asm/qe.h>
>  #include <asm/qe_ic.h>
>  
> @@ -86,6 +88,16 @@ static void __init mpc832x_sys_setup_arch(void)
>  
>  		for (np = NULL; (np = of_find_node_by_name(np, "ucc")) != NULL;)
>  			par_io_of_config(np);
> +#ifdef CONFIG_QE_USB
> +		/* Must fixup Par IO before QE GPIO chips are registered. */
> +		par_io_config_pin(0,  8, 1, 0, 3, 0);   /* PA8 for USBOE */
> +		par_io_config_pin(0,  1, 1, 0, 3, 0);   /* PA1 for USBTP */
> +		par_io_config_pin(0,  0, 1, 0, 3, 0);   /* PA0 for USBTN */
> +		par_io_config_pin(0,  6, 2, 0, 3, 0);   /* PA6 for USBRXD */
> +		par_io_config_pin(0,  4, 2, 1, 3, 0);   /* PA4 for USBRP */
> +		par_io_config_pin(0,  5, 2, 1, 3, 0);   /* PA5 for USBRN */
> +		par_io_config_pin(0, 14, 2, 0, 1, 0);   /* PA14 for BRG10/CLK11*/
> +#endif /* CONFIG_QE_USB */
>  	}
>  
>  	if ((np = of_find_compatible_node(NULL, "network", "ucc_geth"))
> @@ -119,6 +131,60 @@ static int __init mpc832x_declare_of_platform_devices(void)
>  }
>  machine_device_initcall(mpc832x_mds, mpc832x_declare_of_platform_devices);
>  
> +#ifdef CONFIG_QE_USB
> +static int __init mpc832x_usb_cfg(void)
> +{
> +	u8 __iomem *bcsr;
> +	struct device_node *np;
> +	const char *mode;
> +	int ret = 0;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,mpc8323mds-bcsr");
> +	if (!np)
> +		return -ENODEV;
> +
> +	bcsr = of_iomap(np, 0);
> +	of_node_put(np);
> +	if (!bcsr)
> +		return -ENOMEM;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,mpc8323-qe-usb");
> +	if (!np) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +#define BCSR12_USBMASK	0x0f
> +#define BCSR12_nUSBEN	0x08 /* 1 - Disable, 0 - Enable			*/
> +#define BCSR12_USBSPEED	0x04 /* 1 - Full, 0 - Low			*/
> +#define BCSR12_USBMODE	0x02 /* 1 - Host, 0 - Function			*/
> +#define BCSR12_nUSBVCC	0x01 /* 1 - gets VBUS, 0 - supplies VBUS 	*/
> +
> +	clrsetbits_8(&bcsr[12], BCSR12_USBMASK, BCSR12_USBSPEED);
> +
> +	mode = of_get_property(np, "mode", NULL);
> +	if (mode && !strcmp(mode, "peripheral")) {
> +		setbits8(&bcsr[12], BCSR12_nUSBVCC);
> +		qe_usb_clock_set(QE_CLK21, 48000000);

I see that the actual USB clock input is BRG10, while here you
specify CLK21...

> +	} else {
> +//Userguide lies about this!
> +//		setbits8(&bcsr[12], BCSR12_USBMODE);

Please use canonical comments, i.e.

/*
 * Userguide lies about this!
 * setbits8(&bcsr[12], BCSR12_USBMODE);
 */

> +		/*
> +		 * The BCSR GPIOs are used to control power and
> +		 * speed of the USB transceiver. This is needed for
> +		 * the USB Host only.
> +		 */
> +		simple_gpiochip_init("fsl,mpc8323mds-bcsr-gpio");
> +	}
> +
> +	of_node_put(np);
> +err:
> +	iounmap(bcsr);
> +	return ret;
> +}
> +machine_arch_initcall(mpc832x_mds, mpc832x_usb_cfg);
> +#endif /* CONFIG_QE_USB */
> +
>  static void __init mpc832x_sys_init_IRQ(void)
>  {
>  	struct device_node *np;
> diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
> index 01bce37..3342f77 100644
> --- a/arch/powerpc/sysdev/qe_lib/qe.c
> +++ b/arch/powerpc/sysdev/qe_lib/qe.c
> @@ -200,7 +200,11 @@ int qe_setbrg(enum qe_clock brg, unsigned int rate, unsigned int multiplier)
>  	if ((brg < QE_BRG1) || (brg > QE_BRG16))
>  		return -EINVAL;
>  
> -	divisor = qe_get_brg_clk() / (rate * multiplier);
> +#define USB_CLOCK      48000000
> +	if(brg == QE_BRG10) 
> +		divisor = USB_CLOCK / (rate * multiplier);
> +	else
> +		divisor = qe_get_brg_clk() / (rate * multiplier);
[...]
> +#define BRGC_EXTC_CLK11 0x00004000
> +	if(brg == QE_BRG10)
> +		tempval |= BRGC_EXTC_CLK11;
> +
>  	out_be32(&qe_immr->brg.brgc[brg - QE_BRG1], tempval);

Yes, these two changes don't look good, but I'm not sure how to
make them better. Maybe Timur would suggest.

>  	return 0;
> diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
> index ba622cc..ba26d19 100644
> --- a/drivers/usb/host/fhci-hcd.c
> +++ b/drivers/usb/host/fhci-hcd.c
> @@ -620,12 +620,21 @@ static int __devinit of_fhci_probe(struct of_device *ofdev,
>  		goto err_pram;
>  	}
>  
> +#ifdef CONFIG_MPC832x_MDS
> +	pram_addr = qe_muram_alloc(FHCI_PRAM_SIZE, 64);
> +#else
>  	pram_addr = cpm_muram_alloc_fixed(iprop[2], FHCI_PRAM_SIZE);
> +#endif

Default (0x8b00) pram location doesn't work on MPC832x? Let's look
into reference manual...

  "As the default values are not in the first 16KB memory space of
  the Multi-user RAM, the user has to modify the page addresses
  using the assign page host command as part of the initialization
  process."

Hm.. So MPC832x has only 16 KB of muram. :-/

I just checked on MPC8360 board: dynamic allocation + assign page
works here. So, please don't introduce the #ifdefs, just replace
the fixed allocations with dynamic.

Ah, and don't use "qe_muram_alloc", use cpm_ prefix (qe_ and cpm_
muram functions are identical).

>  	if (IS_ERR_VALUE(pram_addr)) {
>  		dev_err(dev, "failed to allocate usb pram\n");
>  		ret = -ENOMEM;
>  		goto err_pram;
>  	}
> +#ifdef CONFIG_MPC832x_MDS

And simply remove this #ifdef.

> +	/* Section 19.3.1.1.1 Assign page Command */

Please remove this comment. Section "19.3.1.1.1" may point
to some completely unrelated stuff if we look into RM for
another processor.

> +	qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, QE_CR_SUBBLOCK_USB,
> +		     QE_CR_PROTOCOL_UNSPECIFIED, pram_addr);
> +#endif
>  	fhci->pram = cpm_muram_addr(pram_addr);


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
