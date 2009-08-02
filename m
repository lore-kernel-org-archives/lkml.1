Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZHBRtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZHBRtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZHBRty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:49:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:32951 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZHBRtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tMPCC1d5iUsCr9jEB+6E1ChnuPm2OCxs5LXQ/Jtqp31UNBo7mzf3maBoVPAmPfABT4
         rSTClcbvkqrWn+La8h0ahKhIccXn2WMEqVzaTV9xx2w0YNJ+pQj2cv4k+x9AeILYDke8
         Jq6cwD7e3FOVQN2Fj8zAu5/QKGlIrRIAh/fk8=
MIME-Version: 1.0
In-Reply-To: <1249232208-22274-1-git-send-email-quadros.roger@gmail.com>
References: <quadros.roger@gmail.com>
	 <1249232208-22274-1-git-send-email-quadros.roger@gmail.com>
Date: Sun, 2 Aug 2009 19:49:52 +0200
Message-ID: <74d0deb30908021049u191b3f9fj5230193535965ff7@mail.gmail.com>
Subject: Re: [PATCH v3] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: broonie@sirena.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 6:56 PM, Roger Quadros<quadros.roger@gmail.com> wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
>
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.
>
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> ---
>  drivers/regulator/fixed.c       |   75 +++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   21 +++++++++++
>  2 files changed, 94 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index cdc674f..0888cb7 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
[...]
> @@ -85,12 +111,51 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
>        drvdata->desc.n_voltages = 1;
>
>        drvdata->microvolts = config->microvolts;
> +       drvdata->gpio = config->gpio;
> +
> +       if (gpio_is_valid(config->gpio)) {
> +               drvdata->enable_high = config->enable_high;
> +
> +               /* FIXME: Remove this print warning */
> +               if (!config->gpio)
> +                       dev_warn(&pdev->dev,
> +                               "using GPIO 0 for regulator enable control\n");
> +
> +               ret = gpio_request(config->gpio, config->supply_name);
> +               if (ret) {
> +                       dev_err(&pdev->dev,
> +                          "Could not obtain regulator enable GPIO %d: %d\n",
> +                                                       config->gpio, ret);
> +                       goto err_name;
> +               }
> +
> +               /* set output direction without changing state
> +                * to prevent glitch
> +                */
> +               drvdata->is_enabled = config->enabled_at_boot;
> +               if (!config->enable_high)
> +                       drvdata->is_enabled = !drvdata->is_enabled;

Assume .enabled_at_boot = 1, .enable_high = 0. In this case we end up
with .is_enabled = 0, which does not represent the real state after
the following call:

> +               ret = gpio_direction_output(config->gpio, drvdata->is_enabled);

Maybe use a local variable here or (drvdata->is_enabled ?
config->enable_high : !config->enable_high).

regards
Philipp
