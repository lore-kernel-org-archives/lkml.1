Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZJAH4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZJAH4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZJAH4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:56:10 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33487 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbZJAH4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xk3VDDKvmQnGRdi3uEQmsKS7ugowUv9GuPwoGG0ogXA78YjxBuLK881KG4yXfP77j+
         hPVHz1FV5vAynktTDsHXDIo5giTSfC5VyjTknJ8HnOjhnpNnwj84unKSLBzESPFYPM8Y
         kUXoLFLRbF1Xe254u+I2G5rV0h2gubkzZXt8c=
MIME-Version: 1.0
In-Reply-To: <1254382570-4611-1-git-send-email-ext-roger.quadros@nokia.com>
References: <1254382570-4611-1-git-send-email-ext-roger.quadros@nokia.com>
Date: Thu, 1 Oct 2009 10:56:12 +0300
Message-ID: <b90c0690910010056l499a5978tc1ac47690e835c00@mail.gmail.com>
Subject: Re: [PATCH] twl4030: Fix boot with twl4030 usb transceiver enabled
From: Roger Quadros <quadros.roger@gmail.com>
To: Roger Quadros <ext-roger.quadros@nokia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

Please ignore this patch. I mistakenly deleted the MMC regulators.
thanks to Felipe Balbi for pointing this out.
Will resend a v2.

cheers,
-roger.

On Thu, Oct 1, 2009 at 10:36 AM, Roger Quadros
<ext-roger.quadros@nokia.com> wrote:
> The usb regulator supplies (usb1v5, usb1v8 & usb3v1) must be available
> before adding the twl4030_usb child, else twl4030_usb_ldo_init() will
> always fail thus causing boot lock-up.
>
> This patch fixes boot on OMAP systems using the twl4030 usb transceiver.
> CONFIG_TWL4030_USB=y
>
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> ---
>  drivers/mfd/twl4030-core.c |  112 ++++++++++++++++++--------------------------
>  1 files changed, 46 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index e424cf6..dcd27be 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -480,7 +480,6 @@ static int
>  add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  {
>        struct device   *child;
> -       struct device   *usb_transceiver = NULL;
>
>        if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
>                child = add_child(3, "twl4030_bci",
> @@ -532,16 +531,61 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>        }
>
>        if (twl_has_usb() && pdata->usb) {
> +
> +               static struct regulator_consumer_supply usb1v5 = {
> +                       .supply =       "usb1v5",
> +               };
> +               static struct regulator_consumer_supply usb1v8 = {
> +                       .supply =       "usb1v8",
> +               };
> +               static struct regulator_consumer_supply usb3v1 = {
> +                       .supply =       "usb3v1",
> +               };
> +
> +       /* First add the regulators so that they can be used by transceiver */
> +               if (twl_has_regulator()) {
> +                       /* this is a template that gets copied */
> +                       struct regulator_init_data usb_fixed = {
> +                               .constraints.valid_modes_mask =
> +                                       REGULATOR_MODE_NORMAL
> +                                       | REGULATOR_MODE_STANDBY,
> +                               .constraints.valid_ops_mask =
> +                                       REGULATOR_CHANGE_MODE
> +                                       | REGULATOR_CHANGE_STATUS,
> +                       };
> +
> +                       child = add_regulator_linked(TWL4030_REG_VUSB1V5,
> +                                                     &usb_fixed, &usb1v5, 1);
> +                       if (IS_ERR(child))
> +                               return PTR_ERR(child);
> +
> +                       child = add_regulator_linked(TWL4030_REG_VUSB1V8,
> +                                                     &usb_fixed, &usb1v8, 1);
> +                       if (IS_ERR(child))
> +                               return PTR_ERR(child);
> +
> +                       child = add_regulator_linked(TWL4030_REG_VUSB3V1,
> +                                                     &usb_fixed, &usb3v1, 1);
> +                       if (IS_ERR(child))
> +                               return PTR_ERR(child);
> +
> +               }
> +
>                child = add_child(0, "twl4030_usb",
>                                pdata->usb, sizeof(*pdata->usb),
>                                true,
>                                /* irq0 = USB_PRES, irq1 = USB */
>                                pdata->irq_base + 8 + 2, pdata->irq_base + 4);
> +
>                if (IS_ERR(child))
>                        return PTR_ERR(child);
>
>                /* we need to connect regulators to this transceiver */
> -               usb_transceiver = child;
> +               if (twl_has_regulator() && child) {
> +                       usb1v5.dev = child;
> +                       usb1v8.dev = child;
> +                       usb3v1.dev = child;
> +               }
>        }
>
>        if (twl_has_watchdog()) {
> @@ -557,70 +601,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>                        return PTR_ERR(child);
>        }
>
> -       if (twl_has_regulator()) {
> -               /*
> -               child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -               */
> -
> -               child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -
> -               child = add_regulator(TWL4030_REG_VDAC, pdata->vdac);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -
> -               child = add_regulator((features & TWL4030_VAUX2)
> -                                       ? TWL4030_REG_VAUX2_4030
> -                                       : TWL4030_REG_VAUX2,
> -                               pdata->vaux2);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -       }
> -
> -       if (twl_has_regulator() && usb_transceiver) {
> -               static struct regulator_consumer_supply usb1v5 = {
> -                       .supply =       "usb1v5",
> -               };
> -               static struct regulator_consumer_supply usb1v8 = {
> -                       .supply =       "usb1v8",
> -               };
> -               static struct regulator_consumer_supply usb3v1 = {
> -                       .supply =       "usb3v1",
> -               };
> -
> -               /* this is a template that gets copied */
> -               struct regulator_init_data usb_fixed = {
> -                       .constraints.valid_modes_mask =
> -                                 REGULATOR_MODE_NORMAL
> -                               | REGULATOR_MODE_STANDBY,
> -                       .constraints.valid_ops_mask =
> -                                 REGULATOR_CHANGE_MODE
> -                               | REGULATOR_CHANGE_STATUS,
> -               };
> -
> -               usb1v5.dev = usb_transceiver;
> -               usb1v8.dev = usb_transceiver;
> -               usb3v1.dev = usb_transceiver;
> -
> -               child = add_regulator_linked(TWL4030_REG_VUSB1V5, &usb_fixed,
> -                               &usb1v5, 1);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -
> -               child = add_regulator_linked(TWL4030_REG_VUSB1V8, &usb_fixed,
> -                               &usb1v8, 1);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -
> -               child = add_regulator_linked(TWL4030_REG_VUSB3V1, &usb_fixed,
> -                               &usb3v1, 1);
> -               if (IS_ERR(child))
> -                       return PTR_ERR(child);
> -       }
> -
>        /* maybe add LDOs that are omitted on cost-reduced parts */
>        if (twl_has_regulator() && !(features & TPS_SUBSET)) {
>                child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
