Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYJ3Uhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYJ3Uhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYJ3Uhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:37:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:18811 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYJ3Uhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:37:32 -0400
Message-ID: <fa686aa40810301337p21ac8785gb74b12904bbd08e7@mail.gmail.com>
Date: Thu, 30 Oct 2008 14:37:31 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 1/3] powerpc: Add mmc-spi-slot bindings
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>
In-Reply-To: <20081030195630.GA13640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
	 <20081030195630.GA13640@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 1:56 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> The bindings describes a case where MMC/SD/SDIO slot directly connected
> to a SPI bus. Such setups are widely used on embedded PowerPC boards.
>
> The patch also adds the mmc-spi-slot entry to the OpenFirmware modalias
> table.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Mostly looks good to me.  A few comments below.

> ---
>  .../powerpc/dts-bindings/mmc-spi-slot.txt          |   23 ++++++++++++++++++++
>  drivers/of/base.c                                  |    1 +
>  2 files changed, 24 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
>
> diff --git a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt b/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
> new file mode 100644
> index 0000000..c39ac28
> --- /dev/null
> +++ b/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
> @@ -0,0 +1,23 @@
> +MMC/SD/SDIO slot directly connected to a SPI bus
> +
> +Required properties:
> +- compatible : should be "mmc-spi-slot".
> +- reg : should specify SPI address (chip-select number).
> +- spi-max-frequency : maximum frequency for this device (Hz).
> +- voltage-ranges : two cells are required, first cell specifies minimum
> +  slot voltage (mV), second cell specifies maximum slot voltage (mV).
> +  Several ranges could be specified.
> +- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
> +  Write-Protect GPIO.

I wonder if we're following the example of irq mappings too closely
for the gpios property.  I like the layout of the property
(<controller> <specifier>), but I think the 'gpios' name is getting
too overloaded.  In this case a single property 'gpios' is being used
to encode 2 unrelated bits of information; the write protect pin and
the card detect pins.

In this particular case I think it is better to use 2 properties in
this case; something like 'spi-writeprotect-gpio' and
'spi-carddetect-gpio' using the same specifier format.  Doing so adds
a bit more clarity to the purpose of the properties.

I my mind I differentiate this from other examples (for instance a
series of CS pins) based on how closely related the pin functions are.
 So I would say for the following examples...
1) GPIO data bus (SPI, MDIO and I2C are great examples); all pins must
be present - single gpio property
2) This MMC case (pins are optional and unrelated); separate gpio properties
3) LCD with backlight and contrast control pins; one gpio property for
backlight pins, one for constrast pins.

Thoughts?

> +
> +Example:
> +
> +       mmc-slot@0 {
> +               compatible = "fsl,mpc8323rdb-mmc-slot",
> +                            "mmc-spi-slot";
> +               reg = <0>;
> +               gpios = <&qe_pio_d 14 1
> +                        &qe_pio_d 15 0>;
> +               voltage-ranges = <3300 3300>;
> +               spi-max-frequency = <50000000>;
> +       };
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 7c79e94..c6797ca 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -411,6 +411,7 @@ struct of_modalias_table {
>  };
>  static struct of_modalias_table of_modalias_table[] = {
>        { "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
> +       { "mmc-spi-slot", "mmc_spi" },
>  };
>
>  /**
> --
> 1.5.6.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
