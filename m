Return-Path: <linux-kernel-owner+w=401wt.eu-S1765192AbZFLRk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765192AbZFLRk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZFLRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:40:48 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:51205 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZFLRkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WI4N3lyG6N7FMAa++nUPMJgEfSvwgmdGFWom/RgJ8qvDD71QSyfj+2Q4CQm5YFNXbS
         +df3SlA8Fh0DYhwH3AwzmArNGTJhDiHI6AuymecvoFV/VluQsa/QkZyw2m4X99zyyYFj
         UrCOfVXLvf/R+GiRXTtQ00KEsr1RcCM0DU2RY=
MIME-Version: 1.0
In-Reply-To: <20090608152420.0e76c302@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
Date: Fri, 12 Jun 2009 23:10:48 +0530
Message-ID: <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys 
	driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Alek Du <alek.du@intel.com>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       ben-linux@fluff.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alek,

>
> From 35101ecc80cfc638ac80a2cea590ab86135be395 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Fri, 8 May 2009 12:25:34 +0800
> Subject: [PATCH] input: Change timer function to workqueue for gpio_keys driver
>
> The gpio_get_value function of I2C/SPI GPIO expander may sleep thus this
> function call can not be called in a timer function.
>
> Signed-off-by: Alek Du <alek.du@intel.com>
> ---
>  drivers/input/keyboard/gpio_keys.c |   32 ++++++++++++++------------------
>  1 files changed, 14 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index ad67d76..9205ac6 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -22,13 +22,17 @@
>  #include <linux/platform_device.h>
>  #include <linux/input.h>
>  #include <linux/gpio_keys.h>
> +#include <linux/workqueue.h>
>
>  #include <asm/gpio.h>
>
>  struct gpio_button_data {
>        struct gpio_keys_button *button;
>        struct input_dev *input;
> -       struct timer_list timer;
> +/* Change timer func to workqueue func due to the fact that gpio_get_value
> + * may sleep for some i2c and spi GPIO expander
> + */

This is anyway goes into commit text and git history, so I don't see
any additional value in keeping this comment here. Patch looks good
otherwise, but it is better if someone can verify this driver having
direct gpio keys.

> +       struct delayed_work work;
>  };
>
>  struct gpio_keys_drvdata {
> @@ -36,8 +40,10 @@ struct gpio_keys_drvdata {
>        struct gpio_button_data data[0];
>  };
>
> -static void gpio_keys_report_event(struct gpio_button_data *bdata)
> +static void gpio_keys_report_event(struct work_struct *work)
>  {
> +       struct gpio_button_data *bdata = container_of(work,
> +                       struct gpio_button_data, work.work);
>        struct gpio_keys_button *button = bdata->button;
>        struct input_dev *input = bdata->input;
>        unsigned int type = button->type ?: EV_KEY;
> @@ -47,13 +53,6 @@ static void gpio_keys_report_event(struct gpio_button_data *bdata)
>        input_sync(input);
>  }
>
> -static void gpio_check_button(unsigned long _data)
> -{
> -       struct gpio_button_data *data = (struct gpio_button_data *)_data;
> -
> -       gpio_keys_report_event(data);
> -}
> -
>  static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>  {
>        struct gpio_button_data *bdata = dev_id;
> @@ -62,10 +61,10 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>        BUG_ON(irq != gpio_to_irq(button->gpio));
>
>        if (button->debounce_interval)
> -               mod_timer(&bdata->timer,
> -                       jiffies + msecs_to_jiffies(button->debounce_interval));
> +               schedule_delayed_work(&bdata->work,
> +                       msecs_to_jiffies(button->debounce_interval));
>        else
> -               gpio_keys_report_event(bdata);
> +               schedule_work(&bdata->work.work);
>
>        return IRQ_HANDLED;
>  }
> @@ -112,8 +111,7 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
>
>                bdata->input = input;
>                bdata->button = button;
> -               setup_timer(&bdata->timer,
> -                           gpio_check_button, (unsigned long)bdata);
> +               INIT_DELAYED_WORK(&bdata->work, gpio_keys_report_event);
>
>                error = gpio_request(button->gpio, button->desc ?: "gpio_keys");
>                if (error < 0) {
> @@ -173,8 +171,7 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
>  fail2:
>        while (--i >= 0) {
>                free_irq(gpio_to_irq(pdata->buttons[i].gpio), &ddata->data[i]);
> -               if (pdata->buttons[i].debounce_interval)
> -                       del_timer_sync(&ddata->data[i].timer);
> +               cancel_delayed_work_sync(&ddata->data[i].work);
>                gpio_free(pdata->buttons[i].gpio);
>        }
>
> @@ -198,8 +195,7 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
>        for (i = 0; i < pdata->nbuttons; i++) {
>                int irq = gpio_to_irq(pdata->buttons[i].gpio);
>                free_irq(irq, &ddata->data[i]);
> -               if (pdata->buttons[i].debounce_interval)
> -                       del_timer_sync(&ddata->data[i].timer);
> +               cancel_delayed_work_sync(&ddata->data[i].work);
>                gpio_free(pdata->buttons[i].gpio);
>        }
>
> --
> 1.6.0.4
>


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
