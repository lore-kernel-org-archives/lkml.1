Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbZBXR0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbZBXR0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbZBXR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:26:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbZBXR01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:26:27 -0500
Date: Tue, 24 Feb 2009 17:26:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: greg@kroah.com, s.hauer@pengutronix.de,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mxc: move serial driver init()/exit() to platform_device
Message-ID: <20090224172606.GA22390@n2100.arm.linux.org.uk>
References: <20090224155737.28880.3945.stgit@Programuotojas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224155737.28880.3945.stgit@Programuotojas>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 05:57:37PM +0200, Paulius Zaleckas wrote:
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> ---
> 
>  arch/arm/mach-mx1/devices.c |   43 ++++++++++++++
>  arch/arm/mach-mx1/mx1ads.c  |   45 ---------------
>  arch/arm/mach-mx2/mx27ads.c |  131 -------------------------------------------
>  arch/arm/mach-mx2/pcm038.c  |   64 ---------------------
>  arch/arm/mach-mx2/serial.c  |  127 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 170 insertions(+), 240 deletions(-)
> 
> 
> diff --git a/arch/arm/mach-mx1/devices.c b/arch/arm/mach-mx1/devices.c
> index a956441..5fd4ee3 100644
> --- a/arch/arm/mach-mx1/devices.c
> +++ b/arch/arm/mach-mx1/devices.c
> @@ -26,6 +26,7 @@
>  
>  #include <mach/irqs.h>
>  #include <mach/hardware.h>
> +#include <mach/iomux-mx1-mx2.h>
>  
>  static struct resource imx_csi_resources[] = {
>  	[0] = {
> @@ -96,11 +97,32 @@ static struct resource imx_uart1_resources[] = {
>  	},
>  };
>  
> +static int mxc_uart1_pins[] = {
> +	PC9_PF_UART1_CTS,
> +	PC10_PF_UART1_RTS,
> +	PC11_PF_UART1_TXD,
> +	PC12_PF_UART1_RXD,
> +};
> +
> +static int uart1_mxc_init(struct platform_device *pdev)
> +{
> +	return mxc_gpio_setup_multiple_pins(mxc_uart1_pins,
> +			ARRAY_SIZE(mxc_uart1_pins), "UART1");
> +}
> +
> +static void uart1_mxc_exit(struct platform_device *pdev)
> +{
> +	mxc_gpio_release_multiple_pins(mxc_uart1_pins,
> +			ARRAY_SIZE(mxc_uart1_pins));
> +}
> +
>  struct platform_device imx_uart1_device = {
>  	.name		= "imx-uart",
>  	.id		= 0,
>  	.num_resources	= ARRAY_SIZE(imx_uart1_resources),
>  	.resource	= imx_uart1_resources,
> +	.init		= uart1_mxc_init,
> +	.exit		= uart1_mxc_exit,

I really don't like this approach to controlling multiplex pins, which
is to setup the SoC pin configuration when the driver is being bound and
to remove it when the driver is unbound.

Let's take the issue of a serial driver.

The outputs of a serial port have defined inactive levels - for TXD, RTS
and DTR, that's logic one.  If a driver is not loaded and you have a
peripheral connected to this port, you probably don't want them to see
a break level on TXD, or active RTS or DTR signal.

However, by hooking the SoC pin configuration into the binding and
unbinding of the driver, the state of the pins are indeterminent until
the driver is initialised.

I can think of other cases in hardware I've dealt with which required
careful handling of SSP signals to ensure that a flip-flop in a FPGA is
correctly set to ensure that left/right channels aren't swapped.

Basically, my point is that for 99.9% of the time, SoC pin configuration
is determined by the platform board layout, and the right place to set
this configuration up is in the board support file, just like we do on
PXA platforms.

For the 0.1% of cases where a board needs to manipulate the SoC pin
configuration depending on which drivers are loaded, doing so at driver
probe time _may_ make sense, but it feels all together cumbersome,
especially as unloading drivers has historically had question marks
over it.

Surely, for this 0.1% of cases, the right solution would be to have an
interface which allows a platform device to be unregistered, the SoC pin
mux settings changed by platform code, and the new device registered?

Finally, note that the approach of putting init/exit into struct
platform_device doesn't cater for all cases - we're still going to need
to have init/exit pointers in platform data for some platform devices,
such as MMC drivers, which have to pass parameters to those hooks.
