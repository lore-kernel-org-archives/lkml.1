Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZASRZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZASRZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZASRYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:24:53 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:62887 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZASRYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SxY49qeGwM6uOpL9Llpzr7LnQZmkxYILNiMVLNIySMmC/oijCOb1Q1zeMJdBGUcgmm
         7FG/JktEpNp9YrvZbsGEjXc4CCqQkGXwS80f5mLRbyifqlbi9yTwaucc7i2jAh/92mVS
         SXv2InNRTNRRa5JS19oY+RSURETi7gOXMbTo4=
Message-ID: <74d0deb30901190924q4bc4d1ffu5211a161af3f5e6e@mail.gmail.com>
Date: Mon, 19 Jan 2009 18:24:50 +0100
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/5] regulator: Pass regulator init data as explict argument when registering
Cc: "Liam Girdwood" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 2:37 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Rather than having the regulator init data read from the platform_data
> member of the struct device that is registered for the regulator make
> the init data an explict argument passed in when registering. This
> allows drivers to use the platform data for their own purposes if they
> wish.

Good, I had a local patch that would pass bq24022_mach_info in
regulator_init_data->driver_data instead of platform_data.
Now that there is a possibility to pass platform_data, is there still
need for the driver_data field in regulator_init_data and for the
regulator_get_init_drvdata() function?

cheers
Philipp

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/bq24022.c            |    2 +-
>  drivers/regulator/core.c               |    5 +++--
>  drivers/regulator/da903x.c             |    3 ++-
>  drivers/regulator/pcf50633-regulator.c |    3 ++-
>  drivers/regulator/wm8350-regulator.c   |    2 +-
>  drivers/regulator/wm8400-regulator.c   |    2 +-
>  include/linux/regulator/driver.h       |    3 ++-
>  7 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
> index 366565a..50129b4 100644
> --- a/drivers/regulator/bq24022.c
> +++ b/drivers/regulator/bq24022.c
> @@ -105,7 +105,7 @@ static int __init bq24022_probe(struct platform_device *pdev)
>        ret = gpio_direction_output(pdata->gpio_iset2, 0);
>        ret = gpio_direction_output(pdata->gpio_nce, 1);
>
> -       bq24022 = regulator_register(&bq24022_desc, &pdev->dev, pdata);
> +       bq24022 = regulator_register(&bq24022_desc, &pdev->dev, NULL, pdata);
>        if (IS_ERR(bq24022)) {
>                dev_dbg(&pdev->dev, "couldn't register regulator\n");
>                ret = PTR_ERR(bq24022);
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 0ff95c3..314997b 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1874,17 +1874,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
>  * regulator_register - register regulator
>  * @regulator_desc: regulator to register
>  * @dev: struct device for the regulator
> + * @init_data: platform provided init data, passed through by driver
>  * @driver_data: private regulator data
>  *
>  * Called by regulator drivers to register a regulator.
>  * Returns 0 on success.
>  */
>  struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
> -       struct device *dev, void *driver_data)
> +       struct device *dev, struct regulator_init_data *init_data,
> +       void *driver_data)
>  {
>        static atomic_t regulator_no = ATOMIC_INIT(0);
>        struct regulator_dev *rdev;
> -       struct regulator_init_data *init_data = dev->platform_data;
>        int ret, i;
>
>        if (regulator_desc == NULL)
> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
> index fe77730..72b1549 100644
> --- a/drivers/regulator/da903x.c
> +++ b/drivers/regulator/da903x.c
> @@ -471,7 +471,8 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
>        if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
>                ri->desc.ops = &da9030_regulator_ldo1_15_ops;
>
> -       rdev = regulator_register(&ri->desc, &pdev->dev, ri);
> +       rdev = regulator_register(&ri->desc, &pdev->dev,
> +                                 pdev->dev.platform_data, ri);
>        if (IS_ERR(rdev)) {
>                dev_err(&pdev->dev, "failed to register regulator %s\n",
>                                ri->desc.name);
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index 4cc85ec..cd761d8 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -284,7 +284,8 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
>        /* Already set by core driver */
>        pcf = platform_get_drvdata(pdev);
>
> -       rdev = regulator_register(&regulators[pdev->id], &pdev->dev, pcf);
> +       rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
> +                                 pdev->dev.platform_data, pcf);
>        if (IS_ERR(rdev))
>                return PTR_ERR(rdev);
>
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 5056e23..510920e 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1333,9 +1333,9 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
>                break;
>        }
>
> -
>        /* register regulator */
>        rdev = regulator_register(&wm8350_reg[pdev->id], &pdev->dev,
> +                                 pdev->dev.platform_data,
>                                  dev_get_drvdata(&pdev->dev));
>        if (IS_ERR(rdev)) {
>                dev_err(&pdev->dev, "failed to register %s\n",
> diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
> index 56e23d4..6ed43b0 100644
> --- a/drivers/regulator/wm8400-regulator.c
> +++ b/drivers/regulator/wm8400-regulator.c
> @@ -294,7 +294,7 @@ static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
>        struct regulator_dev *rdev;
>
>        rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
> -               pdev->dev.driver_data);
> +               pdev->dev.platform_data, pdev->dev.driver_data);
>
>        if (IS_ERR(rdev))
>                return PTR_ERR(rdev);
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index 6e957aa..2254ad9 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -138,7 +138,8 @@ struct regulator_desc {
>  };
>
>  struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
> -       struct device *dev, void *driver_data);
> +       struct device *dev, struct regulator_init_data *init_data,
> +       void *driver_data);
>  void regulator_unregister(struct regulator_dev *rdev);
>
>  int regulator_notifier_call_chain(struct regulator_dev *rdev,
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
