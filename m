Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZEKOen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZEKOen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZEKOec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:34:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:45532 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZEKOeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B+YBcJdUXeCreMI7h4aI7+W62DjSD+4OSpt6frvGAoPaL9jK/lWTp0GrzX2wqjtXe8
         0jM0Ohh7wnuGTDPOygLiVEojdalqCwHDAJmrjhXdYHZ4fskdf+7Dvs36EmYI9oq6Khtc
         uQodlBjXAISm8rSaXM5ZzupxlPIIYctzmr7Ow=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905110928410.10720@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110928410.10720@venus.araneidae.co.uk>
Date: Mon, 11 May 2009 22:34:31 +0800
Message-ID: <f17812d70905110734o3bbb716fjabc61c748904b1ec@mail.gmail.com>
Subject: Re: [PATCH] XCEP PXA255 Processor Board
From: Eric Miao <eric.y.miao@gmail.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 5:04 PM, Michael Abbott <michael@araneidae.co.uk> wrote:
> This is an update of a new architecture patch submitted last week.
> Although this is mailed to the linux-arm-kernel mailing list, my
> subscription seems to be stuck pending moderator approval, so this won't
> actually make it to the list for a bit.  If anybody on that list fancys
> forwarding this mail, that might be helpful.
>
> The main change to this version of the patch is that I've now eliminated
> the obsolescent pxa gpio interface in favour of pxa2xx_mfp_config.  I've
> also added a suitable _defconfig file.
>
> I've also rebased the patch onto current git (at least, as of last
> Friday).
>
> Please cc any replies to me.
>
>
> Date: Wed, 18 Mar 2009 13:42:08 +0000
> Subject: [PATCH] XCEP PXA255 Processor Board
>
> Adds support for the XCEP processor from IskraTel.  This is a small
> single board computer with an ARM XScale PXA255 processor, 32M flash,
> 64M RAM and an SMSC LAN91C111 network device.
>
> This board is used in a series of electron beam position monitors used
> in synchrotron light sources world wide.
>
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> ---
>  arch/arm/configs/xcep_defconfig | 1089 +++++++++++++++++++++++++++++++++++++++

Please, separate the _defconfig into another patch. This makes
code review difficult. (And relevant content removed from this mail)

> +
> +/* SMC LAN91C111 network controller. */
> +
> +static struct resource smc91x_resources[] = {
> +       [0] = {
> +               .name   = "smc91x-regs",
> +               .start  = XCEP_ETH_PHYS,
> +               .end    = XCEP_ETH_END,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +       [1] = {
> +               .start  = IRQ_GPIO(XCEP_ETH_IRQ),
> +               .end    = IRQ_GPIO(XCEP_ETH_IRQ),
> +               .flags  = IORESOURCE_IRQ,

I'd suggest gpio_to_irq(XCEP_ETH_GPIO) - thus defining XCEP_ETH_GPIO
instead of XCEP_ETH_IRQ, which is confusing.

> +       },
> +       [2] = {
> +               .name   = "smc91x-attrib",
> +               .start  = 0x0e000000,
> +               .end    = 0x0e0fffff,
> +               .flags  = IORESOURCE_MEM,
> +       },
> +};
> +
> +static struct platform_device smc91x_device = {
> +       .name           = "smc91x",
> +       .id             = -1,
> +       .num_resources  = ARRAY_SIZE(smc91x_resources),
> +       .resource       = smc91x_resources,
> +};
> +
> +
> +static struct map_desc xcep_io_desc[] __initdata = {
> +       {       /* CPLD */
> +               .virtual        = XCEP_CPLD_BASE,
> +               .pfn            = __phys_to_pfn(0x10000000),

You may want a PXA_CSx_... macro here for this magic number.

> +               .length         = 0x00000100,
> +               .type           = MT_DEVICE
> +       }
> +};
> +
> +
> +static struct platform_device *devices[] __initdata = {
> +       &flash_device,
> +       &smc91x_device,
> +};
> +
> +
> +/* We have to state that there are HWMON devices on the I2C bus on XCEP.
> + * Drivers for HWMON verify capabilities of the adapter when loading and
> + * refuse to attach if the adapter doesn't support HWMON class of devices.
> + * See also Documentation/i2c/porting-clients. */
> +static struct i2c_pxa_platform_data xcep_i2c_platform_data  = {
> +       .class = I2C_CLASS_HWMON
> +};
> +
> +
> +static mfp_cfg_t xcep_pin_config[] __initdata = {
> +    GPIO79_nCS_3       /* SMC 91C111 chip select. */

I'm seeing the CPLD connected to one of the chip-select, which you
may also add it here?

> +};
> +
> +
> +static void __init xcep_init(void)
> +{
> +       /* See Intel XScale Developer's Guide for details */
> +       /* Set RDF and RDN to appropriate values (chip select 3 (smc91x)) */
> +       MSC1 = (MSC1 & 0xffff) | 0xD5540000;
> +       /* Set RDF and RDN to appropriate values (chip select 5 (fpga)) */
> +       MSC2 = (MSC2 & 0xffff) | 0x72A00000;
> +
> +       platform_add_devices(ARRAY_AND_SIZE(devices));
> +       pxa_set_i2c_info(&xcep_i2c_platform_data);
> +}
> +
> +static void __init xcep_map_io(void)
> +{
> +       pxa_map_io();
> +       iotable_init(ARRAY_AND_SIZE(xcep_io_desc));
> +       pxa2xx_mfp_config(ARRAY_AND_SIZE(xcep_pin_config));

I'm not sure if the MFP needs to be initialized this early, moving this
to xcep_init() would be better, at least to align with other platforms
from my POV.

> +}
> +
> +MACHINE_START(XCEP, "Iskratel XCEP")
> +       .phys_io        = 0x80000000,
> +       .io_pg_offst    = 0xf8000000,

...... you sure this is correct? Please have a reference to other platforms.

> +       .boot_params    = 0xa0000100,
> +       .init_machine   = xcep_init,
> +       .map_io         = xcep_map_io,
> +       .init_irq       = pxa25x_init_irq,
> +       .timer          = &pxa_timer,
> +MACHINE_END
> diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> index 329f890..a9d20bc 100644
> --- a/drivers/net/smc91x.h
> +++ b/drivers/net/smc91x.h
> @@ -400,6 +400,11 @@ static inline void LPD7_SMC_outsw (unsigned char* a, int r,
>
>  #endif
>
> +#if defined(CONFIG_MACH_XCEP)
> +#define SMC_USE_PXA_DMA                1
> +#endif
> +

OK, this should be now encoded into the smc91x_platfdata, see
zylonite.c or other boards for example.
