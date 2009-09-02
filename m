Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZIBQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZIBQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZIBQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:30:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55759 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZIBQaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:30:24 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'kishore kadiyala'" <kishore.kadiyala@ti.com>,
       <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <jarkko.lavinen@nokia.com>
References: <34590.192.168.10.89.1251897877.squirrel@dbdmail.itg.ti.com> <41963.192.168.10.89.1251898214.squirrel@dbdmail.itg.ti.com>
Subject: RE: [PATCH] OMAP4: MMC driver support on OMAP4
Date: Wed, 2 Sep 2009 11:30:15 -0500
Message-ID: <004801ca2bea$a6f92d50$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acor0YJvlOQIcSWQSlGLKbuZ4s09aQAE8yEw
In-Reply-To: <41963.192.168.10.89.1251898214.squirrel@dbdmail.itg.ti.com>
x-mimeole: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kishore kadiyala [mailto:kishore.kadiyala@ti.com]
> Sent: Wednesday, September 02, 2009 8:30 AM
> To: linux-kernel@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; jarkko.lavinen@nokia.com; madhu.cr@ti.com
> Subject: Re: [PATCH] OMAP4: MMC driver support on OMAP4
> 
> Resending the patch, CC'ing LO.
> 
> --Kishore
> 
> This Patch adds basic support for all 5 MMC controllers on OMAP4.
> 
> Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
> ---
> This patch doesn't include mmc-regulator support

What is the specific reason? How are MMC4 and MMC5 powered up then?
Does MMC1 and MMC2 work with mmctwl4030 wrapper?

> 
>  arch/arm/mach-omap2/devices.c          |   42
> +++++++++++++++++++++++++++++----
>  arch/arm/plat-omap/include/mach/irqs.h |    2 +
>  arch/arm/plat-omap/include/mach/mmc.h  |    9 ++++++-
>  drivers/mmc/host/Kconfig               |    6 ++--
>  drivers/mmc/host/omap_hsmmc.c          |   10 +++++++
>  5 files changed, 60 insertions(+), 9 deletions(-)
> 
> Index: kernel-omap4-base/arch/arm/mach-omap2/devices.c
> ===================================================================
> --- kernel-omap4-base.orig/arch/arm/mach-omap2/devices.c
> +++ kernel-omap4-base/arch/arm/mach-omap2/devices.c
> @@ -397,7 +397,7 @@ static inline void omap_init_sha1_md5(vo
> 
>  /*-----------------------------------------------------------------------
> --*/
> 
> -#ifdef CONFIG_ARCH_OMAP3
> +#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
> 
>  #define MMCHS_SYSCONFIG			0x0010
>  #define MMCHS_SYSCONFIG_SWRESET		(1 << 1)
> @@ -424,8 +424,8 @@ static struct platform_device dummy_pdev
>   **/
>  static void __init omap_hsmmc_reset(void)
>  {
> -	u32 i, nr_controllers = cpu_is_omap34xx() ? OMAP34XX_NR_MMC :
> -		OMAP24XX_NR_MMC;
> +	u32 i, nr_controllers = cpu_is_omap44xx() ? OMAP44XX_NR_MMC :
> +		(cpu_is_omap34xx() ? OMAP34XX_NR_MMC : OMAP24XX_NR_MMC);
> 
>  	for (i = 0; i < nr_controllers; i++) {
>  		u32 v, base = 0;
> @@ -442,8 +442,21 @@ static void __init omap_hsmmc_reset(void
>  		case 2:
>  			base = OMAP3_MMC3_BASE;
>  			break;
> +		case 3:
> +			if (!cpu_is_omap44xx())
> +				return;
> +			base = OMAP4_MMC4_BASE;
> +			break;
> +		case 4:
> +			if (!cpu_is_omap44xx())
> +				return;
> +			base = OMAP4_MMC5_BASE;
> +			break;
>  		}
> 
> +		if (cpu_is_omap44xx())
> +			base += OMAP4_MMC_REG_OFFSET;
> +
>  		dummy_pdev.id = i;
>  		dev_set_name(&dummy_pdev.dev, "mmci-omap-hs.%d", i);
>  		iclk = clk_get(dev, "ick");
> @@ -540,11 +553,23 @@ void __init omap2_init_mmc(struct omap_m
>  			irq = INT_24XX_MMC2_IRQ;
>  			break;
>  		case 2:
> -			if (!cpu_is_omap34xx())
> +			if (!cpu_is_omap44xx() && !cpu_is_omap34xx())
>  				return;
>  			base = OMAP3_MMC3_BASE;
>  			irq = INT_34XX_MMC3_IRQ;
>  			break;
> +		case 3:
> +			if (!cpu_is_omap44xx())
> +				return;
> +			base = OMAP4_MMC4_BASE + OMAP4_MMC_REG_OFFSET;

The reset fn sets up the base as "OMAP4_MMC4_BASE". Why add the OFFSET here?

> +			irq = INT_44XX_MMC4_IRQ;
> +			break;
> +		case 4:
> +			if (!cpu_is_omap44xx())
> +				return;
> +			base = OMAP4_MMC5_BASE + OMAP4_MMC_REG_OFFSET;
Ditto
> +			irq = INT_44XX_MMC5_IRQ;
> +			break;
>  		default:
>  			continue;
>  		}
> @@ -552,8 +577,15 @@ void __init omap2_init_mmc(struct omap_m
>  		if (cpu_is_omap2420()) {
>  			size = OMAP2420_MMC_SIZE;
>  			name = "mmci-omap";
> +		} else if (cpu_is_omap44xx()) {
> +			if (i < 3) {
> +				base += OMAP4_MMC_REG_OFFSET;
> +				irq += IRQ_GIC_START;
Why base is updated at multiple places within this fn?
> +			}
> +			size = OMAP4_HSMMC_SIZE;
> +			name = "mmci-omap-hs";
>  		} else {
> -			size = HSMMC_SIZE;
> +			size = OMAP3_HSMMC_SIZE;
>  			name = "mmci-omap-hs";
>  		}
>  		omap_mmc_add(name, i, base, size, irq, mmc_data[i]);
> Index: kernel-omap4-base/arch/arm/plat-omap/include/mach/irqs.h
> ===================================================================
> --- kernel-omap4-base.orig/arch/arm/plat-omap/include/mach/irqs.h
> +++ kernel-omap4-base/arch/arm/plat-omap/include/mach/irqs.h
> @@ -503,6 +503,7 @@
>  #define INT_44XX_FPKA_READY_IRQ	(50 + IRQ_GIC_START)
>  #define INT_44XX_SHA1MD51_IRQ	(51 + IRQ_GIC_START)
>  #define INT_44XX_RNG_IRQ	(52 + IRQ_GIC_START)
> +#define INT_44XX_MMC5_IRQ	(59 + IRQ_GIC_START)
>  #define INT_44XX_I2C3_IRQ	(61 + IRQ_GIC_START)
>  #define INT_44XX_FPKA_ERROR_IRQ	(64 + IRQ_GIC_START)
>  #define INT_44XX_PBIAS_IRQ	(75 + IRQ_GIC_START)
> @@ -511,6 +512,7 @@
>  #define INT_44XX_TLL_IRQ	(78 + IRQ_GIC_START)
>  #define INT_44XX_PARTHASH_IRQ	(79 + IRQ_GIC_START)
>  #define INT_44XX_MMC3_IRQ	(94 + IRQ_GIC_START)
> +#define INT_44XX_MMC4_IRQ	(96 + IRQ_GIC_START)
> 
> 
>  /* Max. 128 level 2 IRQs (OMAP1610), 192 GPIOs (OMAP730/850) and
> Index: kernel-omap4-base/arch/arm/plat-omap/include/mach/mmc.h
> ===================================================================
> --- kernel-omap4-base.orig/arch/arm/plat-omap/include/mach/mmc.h
> +++ kernel-omap4-base/arch/arm/plat-omap/include/mach/mmc.h
> @@ -25,11 +25,18 @@
> 
>  #define OMAP24XX_NR_MMC		2
>  #define OMAP34XX_NR_MMC		3
> +#define OMAP44XX_NR_MMC		5
>  #define OMAP2420_MMC_SIZE	OMAP1_MMC_SIZE
> -#define HSMMC_SIZE		0x200
> +#define OMAP3_HSMMC_SIZE	0x200
> +#define OMAP4_HSMMC_SIZE	0x1000
>  #define OMAP2_MMC1_BASE		0x4809c000
>  #define OMAP2_MMC2_BASE		0x480b4000
>  #define OMAP3_MMC3_BASE		0x480ad000
> +#define OMAP4_MMC4_BASE		0x480d1000
> +#define OMAP4_MMC5_BASE		0x480d5000
> +#define OMAP4_MMC_REG_OFFSET	0x100
> +#define HSMMC5			(1 << 4)
> +#define HSMMC4			(1 << 3)
>  #define HSMMC3			(1 << 2)
>  #define HSMMC2			(1 << 1)
>  #define HSMMC1			(1 << 0)
> Index: kernel-omap4-base/drivers/mmc/host/Kconfig
> ===================================================================
> --- kernel-omap4-base.orig/drivers/mmc/host/Kconfig
> +++ kernel-omap4-base/drivers/mmc/host/Kconfig
> @@ -132,11 +132,11 @@ config MMC_OMAP
> 
>  config MMC_OMAP_HS
>  	tristate "TI OMAP High Speed Multimedia Card Interface support"
> -	depends on ARCH_OMAP2430 || ARCH_OMAP3
> +	depends on ARCH_OMAP2430 || ARCH_OMAP3 || ARCH_OMAP4
>  	help
>  	  This selects the TI OMAP High Speed Multimedia card Interface.
> -	  If you have an OMAP2430 or OMAP3 board with a Multimedia Card
> slot,
> -	  say Y or M here.
> +	  If you have an OMAP2430 or OMAP3 board or OMAP4 board with a
> +	  Multimedia Card slot, say Y or M here.
> 
>  	  If unsure, say N.
> 
> Index: kernel-omap4-base/drivers/mmc/host/omap_hsmmc.c
> ===================================================================
> --- kernel-omap4-base.orig/drivers/mmc/host/omap_hsmmc.c
> +++ kernel-omap4-base/drivers/mmc/host/omap_hsmmc.c

Does changes here conflict with Adrian's patches lined up for merge
upstream? From a merge perspective as well as functionality?

> @@ -101,6 +101,8 @@
>  #define OMAP_MMC1_DEVID		0
>  #define OMAP_MMC2_DEVID		1
>  #define OMAP_MMC3_DEVID		2
> +#define OMAP_MMC4_DEVID		3
> +#define OMAP_MMC5_DEVID		4
> 
>  #define MMC_TIMEOUT_MS		20
>  #define OMAP_MMC_MASTER_CLOCK	96000000
> @@ -1096,6 +1098,14 @@ static int __init omap_mmc_probe(struct
>  		host->dma_line_tx = OMAP34XX_DMA_MMC3_TX;
>  		host->dma_line_rx = OMAP34XX_DMA_MMC3_RX;
>  		break;
> +	case OMAP_MMC4_DEVID:
> +		host->dma_line_tx = OMAP44XX_DMA_MMC4_TX;
> +		host->dma_line_rx = OMAP44XX_DMA_MMC4_RX;
> +		break;
> +	case OMAP_MMC5_DEVID:
> +		host->dma_line_tx = OMAP44XX_DMA_MMC5_TX;
> +		host->dma_line_rx = OMAP44XX_DMA_MMC5_RX;
> +		break;
>  	default:
>  		dev_err(mmc_dev(host->mmc), "Invalid MMC id\n");
>  		goto err_irq;
> 


