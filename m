Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZHEUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZHEUPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZHEUPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:15:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57156 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZHEUPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LNKvmudkpIGinZeU7qnTL225TuEsK+HvQ3f096b6goo5zVRkAreXVOguHSdSh+FDdK
         WdloyNY5XLOIJsLIZpiUHak6xAgTA0vpoEuBJPs/aS/zOEnLpMVy52LFarLrjarCr64K
         Ud+U8HrlkkWDp+z4gf6SUUEjqJUqpZ0vIQY7k=
MIME-Version: 1.0
In-Reply-To: <1249496971-9019-4-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
	 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
	 <1249496971-9019-3-git-send-email-daniel@caiaq.de>
	 <1249496971-9019-4-git-send-email-daniel@caiaq.de>
Date: Wed, 5 Aug 2009 22:15:52 +0200
Message-ID: <74d0deb30908051315l43b00731yb79f7937707068ec@mail.gmail.com>
Subject: Re: [PATCH 4/5] input: gpio-keys: switch to new dev_pm_ops
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Phil Blundell <pb@handhelds.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 8:29 PM, Daniel Mack<daniel@caiaq.de> wrote:
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Phil Blundell <pb@handhelds.org>
> Cc: linux-input@vger.kernel.org
> ---
>  drivers/input/keyboard/gpio_keys.c |   28 ++++++++++++++++++----------
>  1 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index efed0c9..bfb6fc3 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -216,12 +216,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
>
>
>  #ifdef CONFIG_PM
> -static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
> +static int gpio_keys_suspend(struct device *dev)
>  {
> -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
> +       struct gpio_keys_platform_data *pdata = dev->platform_data;
>        int i;
>
> -       if (device_may_wakeup(&pdev->dev)) {
> +       if (device_may_wakeup(dev)) {
>                for (i = 0; i < pdata->nbuttons; i++) {
>                        struct gpio_keys_button *button = &pdata->buttons[i];
>                        if (button->wakeup) {
> @@ -234,12 +234,12 @@ static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
>        return 0;
>  }
>
> -static int gpio_keys_resume(struct platform_device *pdev)
> +static int gpio_keys_resume(struct device *dev)
>  {
> -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
> +       struct gpio_keys_platform_data *pdata = dev->platform_data;
>        int i;
>
> -       if (device_may_wakeup(&pdev->dev)) {
> +       if (device_may_wakeup(dev)) {
>                for (i = 0; i < pdata->nbuttons; i++) {
>                        struct gpio_keys_button *button = &pdata->buttons[i];
>                        if (button->wakeup) {
> @@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
>
>        return 0;
>  }
> +
> +static struct dev_pm_ops gpio_keys_pm_ops = {
> +       .suspend        = gpio_keys_suspend,
> +       .freeze         = gpio_keys_suspend,
> +       .resume         = gpio_keys_resume,
> +       .thaw           = gpio_keys_resume,

I'm not sure I understand hibernation correctly, but isn't
.freeze/.thaw about saving state and halting/resuming the device
operation only?
It seems to me that enabling system wakeup functionality should go
into .poweroff. (See <linux/pm.h>)

regards
Philipp
