Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZFSHnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZFSHnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSHnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:43:00 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:20487 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750728AbZFSHm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:42:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=frqtDKqcrAvVA9KyBFLL8UXqBDq+g6dOR1jfMsOG5eOMw3mLAJnSehHAbTPxJkdCH+2TJ7efu+ntfXBY4Gb73UE9b6yaNFYO/A0XBKw/MjTgJFMoro8H0qX3gInCmx9/NtY0DLjEfVNWTWhYk2j2OYduKGX8DqEKlV3RF6reLws=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: p81KszEVM1nnAzFA5RBjn_JFvdcYchumfxtrLNriTvBu57A4bXVgyeyyLiBZGTJV3qiLo4wf5fCpW3fT3Z8Ji5_u7Ayn9hmfP0X1p8Vz5MV6n3Be04a1z2UX5Zu.t_9R.9kn2CjwVuLL2fvMFW6Ee5.lI75D_298axO1fMxApzQR.xdwoPwwwP2JOFg.HS12m8pdvZvviEtbujB2VojO1bpKLJc2gD0yji4Qb.yuw5C67HaT9kY4jzSizgXQXYuvpCHDP4KrnHGkhz4JwDXNWeGYDmuo1L2Q1.zZbJz543COv_qfUwqqeGnd9.SF8d3wTu3sj_.fwAUQDnjGeyBq1Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
Date: Fri, 19 Jun 2009 00:43:00 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com> <1244547493-19654-2-git-send-email-nicolas.ferre@atmel.com> <1244547493-19654-3-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244547493-19654-3-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906190043.00428.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, Nicolas Ferre wrote:
> This is the at91 specific part of USB host integration. The EHCI high speed
> controller has a companion OHCI controller to manage USB full and low speed.
> They are sharing the same IRQ line and vbus pin.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

My only issue here is with the GPIO stuff; see below.


> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c |   56 ++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-sam9m10g45ek.c  |    1 +
>  arch/arm/mach-at91/include/mach/board.h  |    1 +
>  3 files changed, 58 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index d746e86..c2ecbb6 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -83,6 +83,62 @@ void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data) {}
>  
>  
>  /* --------------------------------------------------------------------
> + *  USB Host HS (EHCI)
> + *  Needs an OHCI host for low and full speed management
> + * -------------------------------------------------------------------- */
> +
> +#if defined(CONFIG_USB_EHCI_HCD) || defined(CONFIG_USB_EHCI_HCD_MODULE)
> +static u64 ehci_dmamask = DMA_BIT_MASK(32);
> +static struct at91_usbh_data usbh_ehci_data;
> +
> +static struct resource usbh_ehci_resources[] = {
> +	[0] = {
> +		.start	= AT91SAM9G45_EHCI_BASE,
> +		.end	= AT91SAM9G45_EHCI_BASE + SZ_1M - 1,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start	= AT91SAM9G45_ID_UHPHS,
> +		.end	= AT91SAM9G45_ID_UHPHS,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device at91_usbh_ehci_device = {
> +	.name		= "atmel-ehci",
> +	.id		= -1,
> +	.dev		= {
> +				.dma_mask		= &ehci_dmamask,
> +				.coherent_dma_mask	= DMA_BIT_MASK(32),
> +				.platform_data		= &usbh_ehci_data,
> +	},
> +	.resource	= usbh_ehci_resources,
> +	.num_resources	= ARRAY_SIZE(usbh_ehci_resources),
> +};
> +
> +void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data)
> +{
> +	int i;
> +
> +	if (!data)
> +		return;
> +
> +	/* Enable VBus control for UHP ports */
> +	for (i = 0; i < data->ports; i++) {
> +		if (data->vbus_pin[i])
> +			at91_set_gpio_output(data->vbus_pin[i], 0);

This should gpio_request() and gpio_direction_output().

Don't use AT91-specific GPIO calls except for things that
the generic calls don't support ... like enabling open-drain
outputs, the deglitching support, or input pullups.


> +	}
> +
> +	usbh_ehci_data = *data;
> +	at91_clock_associate("uhphs_clk", &at91_usbh_ehci_device.dev, "ehci_clk");
> +	platform_device_register(&at91_usbh_ehci_device);
> +}
> +#else
> +void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data) {}
> +#endif
> +
> +
> +/* --------------------------------------------------------------------
>   *  USB HS Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index b8558ea..d7251b7 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -358,6 +358,7 @@ static void __init ek_board_init(void)
>  	at91_add_device_serial();
>  	/* USB HS Host */
>  	at91_add_device_usbh_ohci(&ek_usbh_hs_data);
> +	at91_add_device_usbh_ehci(&ek_usbh_hs_data);
>  	/* USB HS Device */
>  	at91_add_device_usba(&ek_usba_udc_data);
>  	/* SPI */
> diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
> index 74801d2..13640b0 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -92,6 +92,7 @@ struct at91_usbh_data {
>  };
>  extern void __init at91_add_device_usbh(struct at91_usbh_data *data);
>  extern void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data);
> +extern void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data);
>  
>   /* NAND / SmartMedia */
>  struct atmel_nand_data {
> -- 
> 1.5.3.7
> 
> 


