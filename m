Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZGTTHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZGTTHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZGTTHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:07:18 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:41861 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZGTTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:07:16 -0400
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 15:07:16 EDT
Date: Mon, 20 Jul 2009 22:07:07 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: balajitk@ti.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Rajendra Nayak <rnayak@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for twl6030 irq
 framework
Message-ID: <20090720190706.GE7984@gandalf>
Reply-To: me@felipebalbi.com
References: <1248096992-14610-1-git-send-email-balajitk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248096992-14610-1-git-send-email-balajitk@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Mon, Jul 20, 2009 at 07:06:32PM +0530, balajitk@ti.com wrote:
> diff --git a/arch/arm/plat-omap/include/mach/irqs.h b/arch/arm/plat-omap/include/mach/irqs.h
> index fb7cb77..009cf4d 100644
> --- a/arch/arm/plat-omap/include/mach/irqs.h
> +++ b/arch/arm/plat-omap/include/mach/irqs.h
> @@ -551,8 +551,20 @@
>  #endif
>  #define TWL4030_GPIO_IRQ_END	(TWL4030_GPIO_IRQ_BASE + TWL4030_GPIO_NR_IRQS)
>  
> +#define	TWL6030_IRQ_BASE	(OMAP_FPGA_IRQ_END)
> +#ifdef CONFIG_TWL6030_CORE
> +#define	TWL6030_BASE_NR_IRQS	20
> +#else
> +#define	TWL6030_BASE_NR_IRQS	0
> +#endif
> +#define TWL6030_IRQ_END		(TWL6030_IRQ_BASE + TWL6030_BASE_NR_IRQS)
> +
>  /* Total number of interrupts depends on the enabled blocks above */
> +#ifdef CONFIG_TWL4030_CORE
>  #define NR_IRQS			TWL4030_GPIO_IRQ_END
> +#else
> +#define NR_IRQS			TWL6030_IRQ_END
> +#endif

this will be tricky to make it better. Tony ? Dave ? Any suggestions ?

> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 4e9d513..17c533d 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_TPS65010)		+= tps65010.o
>  obj-$(CONFIG_MENELAUS)		+= menelaus.o
>  
>  obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o
> +obj-$(CONFIG_TWL6030_CORE)	+= twl-core.o twl6030-irq.o

this will break multi-omap builds. Tony can comment a bit more on this,
but I suggest you try to find some way to figure out if you're running
on twl4030/twl5030 or twl6030.

Maybe one way would be to add a TWL6030 flag to twl4030-core.c, just
like we have TWL4030_VAUX2 and TPS_SUBSET. And I know of one more hw
that will fall into this driver and patches shall be coming out soonish.
So another flag should be added.

> +#ifdef CONFIG_TWL6030_CORE

we have to avoid these ifdeferry.

> +#define TWL6030_MODULE_LAST TWL6030_MODULE_AUDIO
> +#define TWL_MODULE_LAST TWL6030_MODULE_LAST
> +
> +#define RTC_SUB_CHIP_ID		SUB_CHIP_ID0
> +#define REG_SUB_CHIP_ID		SUB_CHIP_ID0
> +#define USB_SUB_CHIP_ID		SUB_CHIP_ID1
> +#define MADC_SUB_CHIP_ID	SUB_CHIP_ID1
> +#define BCI_SUB_CHIP_ID		SUB_CHIP_ID1
> +#define GPIO_SUB_CHIP_ID	0 /* NOT SUPPORTED IN TWL6030 */
> +#define KEYPAD_SUB_CHIP_ID	0 /* ADDED FOR COMPILATION ONLY */

maybe passing these via platform_data or using the TWL6030 flag somehow.

> +/* subchip/slave 0 0x48 - POWER */
> +#define TWL6030_BASEADD_RTC		0x0000
> +#define TWL6030_BASEADD_MEM		0x0017
> +#define TWL6030_BASEADD_PM_MASTER	0x001F
> +#define TWL6030_BASEADD_PM_SLAVE_MISC	0x0030
> +#define TWL6030_BASEADD_PM_SLAVE_SMPS	0x0040
> +#define TWL6030_BASEADD_PM_SLAVE_LDO	0x0080
> +#define TWL6030_BASEADD_PM_SLAVE_RES	0x00AD
> +#define TWL6030_BASEADD_PM_MISC		0x00E3
> +#define TWL6030_BASEADD_PM_PUPD		0x00F0
> +
> +/* subchip/slave 1 0x49 - FEATURE */
> +#define TWL6030_BASEADD_USB		0x0000
> +#define TWL6030_BASEADD_GPADC_CTRL	0x0030
> +#define TWL6030_BASEADD_GPADC_RT	0x0035
> +#define TWL6030_BASEADD_GPADC		0x005D
> +#define TWL6030_BASEADD_AUX		0x0090
> +#define TWL6030_BASEADD_PWM		0x00BA
> +#define TWL6030_BASEADD_GASGAUGE	0x00C0
> +#define TWL6030_BASEADD_PIH		0x00D0
> +#define TWL6030_BASEADD_CHARGER		0x00E0
> +
> +/* subchip/slave 2 0x4A - DFT */
> +#define TWL6030_BASEADD_DIEID		0x00C0
> +
> +/* subchip/slave 3 0x4B - AUDIO */
> +#define TWL6030_BASEADD_AUDIO		0x0000
> +#endif /* CONFIG_TWL6030_CORE */
> +
>  /* Few power values */
>  #define R_CFG_BOOT			0x05
>  #define R_PROTECT_KEY			0x0E
> @@ -190,7 +231,7 @@
>  /* is driver active, bound to a chip? */
>  static bool inuse;
>  
> -/* Structure for each TWL4030 Slave */
> +/* Structure for each TWL4030/TWL6030 Slave */
>  struct twl_client {
>  	struct i2c_client *client;
>  	u8 address;
> @@ -212,7 +253,7 @@ struct twl_mapping {
>  };
>  
>  #ifdef CONFIG_TWL4030_CORE

avoid ifdef

> -static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
> +static struct twl_mapping twl_map[TWL4030_MODULE_LAST + 1] = {

keep the old name

> @@ -247,12 +288,45 @@ static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
>  };
>  #endif
>  
> +#ifdef CONFIG_TWL6030_CORE

avoid this

> +static struct twl_mapping twl_map[TWL6030_MODULE_LAST + 1] = {

call this oe twl6030_map, the you could use TWL6030 flag to choose which
one to use.

>  /**
> - * twl_i2c_write - Writes a n bit register in TWL4030
> + * twl_i2c_write - Writes a n bit register in TWL4030/TWL6030

TWL4030/TWL5030/TPS65920/TPS65930/TWL6030/...

this will only grow and grow.

> @@ -274,7 +348,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>  		return -EPERM;
>  	}
> -	sid = twl4030_map[mod_no].sid;
> +	sid = twl_map[mod_no].sid;

you could have something like:

	if (twl_features & TWL6030)
		sid = twl6030_map[mod_no].sid;
	else
		sid = twl4030_map[mod_no].sid;

something like that.

> @@ -292,7 +366,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  	msg->flags = 0;
>  	msg->buf = value;
>  	/* over write the first byte of buffer with the register address */
> -	*value = twl4030_map[mod_no].base + reg;
> +	*value = twl_map[mod_no].base + reg;

ditto

-- 
balbi
