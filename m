Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbZFLWkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbZFLWkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbZFLWkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:40:07 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57868 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbZFLWkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DFKb8ys6PQw3w7miDgsR/vkBeH0OnP7A4lTjMRXklztXCGKz9954h4APUNMQYDzmgL
         C5fDENquVWL7kQ1VyyECBJm3SOJEhQSdjgZDMEbhvW+vAII0Dw6UTX2trwjI0pst+PK7
         E9S+LC1Au+gYJIcqCqYyUpQ4uRYp7XkaVCTqA=
MIME-Version: 1.0
In-Reply-To: <1244219467-32136-7-git-send-email-philipp.zabel@gmail.com>
References: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
	 <1244219467-32136-7-git-send-email-philipp.zabel@gmail.com>
Date: Sat, 13 Jun 2009 00:40:06 +0200
Message-ID: <74d0deb30906121540j738739d4t221b2a2224967227@mail.gmail.com>
Subject: Re: [PATCH 6/7] MFD: ASIC3: enable DS1WM cell.
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 6:31 PM, Philipp Zabel<philipp.zabel@gmail.com> wrote:
> This enables the ASIC3's DS1WM MFD cell, supported by the ds1wm driver.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  drivers/mfd/asic3.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ee3927a..9e6d5ee 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -30,6 +30,7 @@ config MFD_SM501_GPIO
>  config MFD_ASIC3
>        bool "Support for Compaq ASIC3"
>        depends on GENERIC_HARDIRQS && GPIOLIB && ARM
> +       select MFD_CORE
>         ---help---
>          This driver supports the ASIC3 multifunction chip found on many
>          PDAs (mainly iPAQ and HTC based ones)
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index d5dd0df..3fadd02 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -17,6 +17,7 @@
>  */
>
>  #include <linux/kernel.h>
> +#include <linux/delay.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
>  #include <linux/io.h>
> @@ -24,6 +25,8 @@
>  #include <linux/platform_device.h>
>
>  #include <linux/mfd/asic3.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ds1wm.h>
>
>  enum {
>        ASIC3_CLOCK_SPI,
> @@ -616,6 +619,99 @@ static void asic3_clk_disable(struct asic3 *asic, struct asic3_clk *clk)
>        spin_unlock_irqrestore(&asic->lock, flags);
>  }
>
> +/* MFD cells (SPI, PWM, LED, DS1WM, MMC) */
> +static struct ds1wm_driver_data ds1wm_pdata = {
> +       .active_high = 1,
> +};
> +
> +static struct resource ds1wm_resources[] = {
> +       {
> +               .flags = IORESOURCE_MEM,
> +       },
> +       {
> +               .start = ASIC3_IRQ_OWM,
> +               .start = ASIC3_IRQ_OWM,
> +               .flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
> +       },
> +};
> +
> +static int ds1wm_enable(struct platform_device *pdev)
> +{
> +       struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> +
> +       /* Turn on external clocks and the OWM clock */
> +       asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_EX0]);
> +       asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_EX1]);
> +       asic3_clk_enable(asic, &asic->clocks[ASIC3_CLOCK_OWM]);
> +       msleep(1);
> +
> +       /* Reset and enable DS1WM */
> +       asic3_set_register(asic, ASIC3_OFFSET(EXTCF, RESET),
> +                          ASIC3_EXTCF_OWM_RESET, 1);
> +       msleep(1);
> +       asic3_set_register(asic, ASIC3_OFFSET(EXTCF, RESET),
> +                          ASIC3_EXTCF_OWM_RESET, 0);
> +       msleep(1);
> +       asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
> +                          ASIC3_EXTCF_OWM_EN, 1);
> +       msleep(1);
> +
> +       return 0;
> +}
> +
> +static int ds1wm_disable(struct platform_device *pdev)
> +{
> +       struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> +
> +       asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
> +                          ASIC3_EXTCF_OWM_EN, 0);
> +
> +       asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_OWM]);
> +       asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_EX0]);
> +       asic3_clk_disable(asic, &asic->clocks[ASIC3_CLOCK_EX1]);
> +
> +       return 0;
> +}
> +
> +static struct mfd_cell asic3_cell_ds1wm = {
> +       .name          = "ds1wm",
> +       .enable        = ds1wm_enable,
> +       .disable       = ds1wm_disable,
> +       .driver_data   = &ds1wm_pdata,
> +       .num_resources = ARRAY_SIZE(ds1wm_resources),
> +       .resources     = ds1wm_resources,
> +};
> +
> +static int __init asic3_mfd_probe(struct platform_device *pdev,
> +                                 struct resource *mem)
> +{
> +       struct asic3 *asic = platform_get_drvdata(pdev);
> +       int ret;
> +
> +       /* DS1WM */
> +       asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
> +                          ASIC3_EXTCF_OWM_SMB, 0);
> +
> +       ds1wm_resources[0].start = ASIC3_OWM_BASE >> asic->bus_shift;
> +       ds1wm_resources[0].end = ds1wm_resources[0].start
> +                                + (5 << (2 - asic->bus_shift)) - 1;
> +
> +       asic3_cell_ds1wm.platform_data = &asic3_cell_ds1wm;
> +       asic3_cell_ds1wm.data_size = sizeof(asic3_cell_ds1wm);
> +
> +       ret = mfd_add_devices(&pdev->dev, pdev->id,
> +                       &asic3_cell_ds1wm, 1, mem, asic->irq_base);
> +
> +       return ret;
> +}
> +
> +static void asic3_mfd_remove(struct platform_device *pdev)
> +{
> +       struct asic3 *asic = platform_get_drvdata(pdev);
> +
> +       mfd_remove_devices(&pdev->dev);
> +}

I've just noticed that the following hunk got squashed into 7/7 instead of 6/7:

--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -737,8 +737,6 @@ static int __init asic3_mfd_probe(struct platform_device *pd

 static void asic3_mfd_remove(struct platform_device *pdev)
 {
-       struct asic3 *asic = platform_get_drvdata(pdev);
-
        mfd_remove_devices(&pdev->dev);
 }

Please consider replacing those two with the fixed versions I'll send.

> +
>  /* Core */
>  static int __init asic3_probe(struct platform_device *pdev)
>  {
> @@ -683,6 +779,8 @@ static int __init asic3_probe(struct platform_device *pdev)
>         */
>        memcpy(asic->clocks, asic3_clk_init, sizeof(asic3_clk_init));
>
> +       asic3_mfd_probe(pdev, mem);
> +
>        dev_info(asic->dev, "ASIC3 Core driver\n");
>
>        return 0;
> @@ -704,6 +802,8 @@ static int asic3_remove(struct platform_device *pdev)
>        int ret;
>        struct asic3 *asic = platform_get_drvdata(pdev);
>
> +       asic3_mfd_remove(pdev);
> +
>        ret = asic3_gpio_remove(pdev);
>        if (ret < 0)
>                return ret;
> --
> 1.6.3.1
>
>

regards
Philipp
