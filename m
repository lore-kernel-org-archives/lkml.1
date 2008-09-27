Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYI0PAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYI0PAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYI0PA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:00:29 -0400
Received: from hs-out-0708.google.com ([64.233.178.246]:34003 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYI0PA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H8/ZAFN5x3eWhoP8OEpo9mAWyNi5TJiuDalykhLd+F5JFnfxmFnF+iJTvfoQMy0eqw
         6R/37oH1GkpmJTRHJEbRONnPTa+JEimltiTi4WuOcImqkNJ9aWhA34zQtbkRvobdktLf
         GsCQZ15oVT+mZj/vQQX9wUO1Ca/cQfowsuOEQ=
Message-ID: <aec7e5c30809270800y7a4b59eem8af480d5899a791a@mail.gmail.com>
Date: Sun, 28 Sep 2008 00:00:24 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.27-rc7] gpiolib: request/free hooks
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200809241508.11091.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809241508.11091.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Sep 25, 2008 at 7:08 AM, David Brownell <david-b@pacbell.net> wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
>
> Add a new internal mechanism to gpiolib to support low power
> operations by letting gpio_chip instances see when their GPIOs
> are in use.  When no GPIOs are active, chips may be able to
> enter lower powered runtime states by disabling clocks and/or
> power domains.
>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Looking good. I'm currently hacking on some pinmuxed gpio code for
SuperH, and I'd like to use these request/free callbacks to select
proper pinmux state.

I have one comment below though:

> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -781,6 +785,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>  int gpio_request(unsigned gpio, const char *label)
>  {
>        struct gpio_desc        *desc;
> +       struct gpio_chip        *chip;
>        int                     status = -EINVAL;
>        unsigned long           flags;
>
> @@ -789,22 +794,31 @@ int gpio_request(unsigned gpio, const ch
>        if (!gpio_is_valid(gpio))
>                goto done;
>        desc = &gpio_desc[gpio];
> -       if (desc->chip == NULL)
> +       chip = desc->chip;
> +       if (chip == NULL)
>                goto done;
>
> -       if (!try_module_get(desc->chip->owner))
> +       if (!try_module_get(chip->owner))
>                goto done;
>
>        /* NOTE:  gpio_request() can be called in early boot,
> -        * before IRQs are enabled.
> +        * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
>         */
>
> +       if (chip->request) {
> +               status = chip->request(chip, gpio - chip->base);
> +               if (status < 0) {
> +                       module_put(chip->owner);
> +                       goto done;
> +               }
> +       }
> +
>        if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
>                desc_set_label(desc, label ? : "?");
>                status = 0;
>        } else {
>                status = -EBUSY;
> -               module_put(desc->chip->owner);
> +               module_put(chip->owner);
>        }
>
>  done:

The code above doesn't catch double gpio_request() user calls
properly. Or rather, the user will receive an error but the
chip->request() callback may get called twice.

What about modifying the gpiolib code to handle that? I think that
sounds like a better idea than cover ing that case in the chip code...

Thanks!

/ magnus
