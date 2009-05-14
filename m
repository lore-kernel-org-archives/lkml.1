Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZENK2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZENK2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZENK2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:28:21 -0400
Received: from mail-qy0-f133.google.com ([209.85.221.133]:56360 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZENK2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jQBIkWcG3qoW4eExDZKkXTdXhzU5158Hn3IIT2CSswfmNVc15CobCHLCRysAK+dHun
         8ML7xu2i586F50EAdnI3cTAFIoeu8M4QMGXT5dM69S6UfPS4N+gwMUPHE5mtyapjpaPZ
         zyUaFX+ihS9aHSQYm8/uv2iFywjHvGuckCju4=
MIME-Version: 1.0
In-Reply-To: <20090514100909.GA23626@roarinelk.homelinux.net>
References: <20090514100909.GA23626@roarinelk.homelinux.net>
Date: Thu, 14 May 2009 15:58:19 +0530
Message-ID: <5d5443650905140328v319e673o2f7b865e21619486@mail.gmail.com>
Subject: Re: [PATCH] TSC2007: private data for platform callbacks.
From: Trilok Soni <soni.trilok@gmail.com>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Kwangwoo Lee <kwlee@mtekvision.com>, linux-kernel@vger.kernel.org,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manuel,

CCing linux-input mailing list, so not deleting any code from this
e-mail while replying.

On Thu, May 14, 2009 at 3:39 PM, Manuel Lauss
<mano@roarinelk.homelinux.net> wrote:
> Add a private data field to the tsc2007 platform data and pass this
> to the callbacks.

I hope that you have created this patch on top of two recently posted
patches by Kwangwoo Lee
to merge changes from Thierry.

>
> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> ---
>  drivers/input/touchscreen/tsc2007.c |   52 +++++++++++++++++++++++-----------
>  include/linux/i2c/tsc2007.h         |   10 ++++---
>  2 files changed, 41 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
> index 948e167..5c4242d 100644
> --- a/drivers/input/touchscreen/tsc2007.c
> +++ b/drivers/input/touchscreen/tsc2007.c
> @@ -83,10 +83,35 @@ struct tsc2007 {
>        unsigned                pendown;
>        int                     irq;
>
> -       int                     (*get_pendown_state)(void);
> -       void                    (*clear_penirq)(void);
> +       struct tsc2007_platform_data *pd;
>  };
>
> +/* ask platform for pendown state */
> +static inline int ts_get_pendown_state(struct tsc2007 *ts)
> +{
> +       return ts->pd->get_pendown_state(ts->pd->priv);

So, we don't need check here, like this:

if (ts->pd->get_pendown_state)
          ret =  ts->pd->get_pendown_state(ts->pd->priv);

> +}
> +
> +/* ask platform to clear pendown irq if available */
> +static inline void ts_clear_penirq(struct tsc2007 *ts)
> +{
> +       if (ts->pd->clear_penirq)
> +               ts->pd->clear_penirq(ts->pd->priv);
> +}
> +
> +static inline void ts_init_platform_hw(struct tsc2007 *ts)
> +{
> +       if (ts->pd->init_platform_hw)
> +               ts->pd->init_platform_hw(ts->pd->priv);
> +}
> +
> +static inline void ts_exit_platform_hw(struct tsc2007 *ts)
> +{
> +       if (ts->pd->exit_platform_hw)
> +               ts->pd->exit_platform_hw(ts->pd->priv);
> +}
> +
> +
>  static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
>  {
>        s32 data;
> @@ -129,7 +154,7 @@ static void tsc2007_send_event(void *tsc)
>                rt = z2;
>                rt -= z1;
>                rt *= x;
> -               rt *= ts->x_plate_ohms;
> +               rt *= ts->pd->x_plate_ohms;
>                rt /= z1;
>                rt = (rt + 2047) >> 12;
>        } else
> @@ -204,7 +229,7 @@ static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
>
>        spin_lock_irqsave(&ts->lock, flags);
>
> -       if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
> +       if (unlikely(!ts_get_pendown_state(ts) && ts->pendown)) {
>                struct input_dev *input = ts->input;
>
>                dev_dbg(&ts->client->dev, "UP\n");
> @@ -235,14 +260,13 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
>
>        spin_lock_irqsave(&ts->lock, flags);
>
> -       if (likely(ts->get_pendown_state())) {
> +       if (likely(ts_get_pendown_state(ts))) {
>                disable_irq_nosync(ts->irq);
>                hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
>                                        HRTIMER_MODE_REL);
>        }
>
> -       if (ts->clear_penirq)
> -               ts->clear_penirq();
> +       ts_clear_penirq(ts);
>
>        spin_unlock_irqrestore(&ts->lock, flags);
>
> @@ -253,7 +277,7 @@ static int tsc2007_probe(struct i2c_client *client,
>                        const struct i2c_device_id *id)
>  {
>        struct tsc2007 *ts;
> -       struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
> +       struct tsc2007_platform_data *pdata = client->dev.platform_data;

This change shows that you need to rebase based on two patches
submitted by Lee recently.

>        struct input_dev *input_dev;
>        int err;
>
> @@ -283,12 +307,8 @@ static int tsc2007_probe(struct i2c_client *client,
>
>        spin_lock_init(&ts->lock);
>
> -       ts->model             = pdata->model;
> -       ts->x_plate_ohms      = pdata->x_plate_ohms;
> -       ts->get_pendown_state = pdata->get_pendown_state;
> -       ts->clear_penirq      = pdata->clear_penirq;
> -
> -       pdata->init_platform_hw();
> +       ts->pd = pdata;
> +       ts_init_platform_hw(ts);
>
>        snprintf(ts->phys, sizeof(ts->phys),
>                 "%s/input0", dev_name(&client->dev));
> @@ -335,10 +355,8 @@ static int tsc2007_probe(struct i2c_client *client,
>  static int tsc2007_remove(struct i2c_client *client)
>  {
>        struct tsc2007  *ts = i2c_get_clientdata(client);
> -       struct tsc2007_platform_data *pdata;
>
> -       pdata = client->dev.platform_data;
> -       pdata->exit_platform_hw();
> +       ts_exit_platform_hw(ts);
>
>        free_irq(ts->irq, ts);
>        hrtimer_cancel(&ts->timer);
> diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
> index c6361fb..45582b3 100644
> --- a/include/linux/i2c/tsc2007.h
> +++ b/include/linux/i2c/tsc2007.h
> @@ -7,11 +7,13 @@ struct tsc2007_platform_data {
>        u16     model;                          /* 2007. */
>        u16     x_plate_ohms;
>
> -       int     (*get_pendown_state)(void);
> -       void    (*clear_penirq)(void);          /* If needed, clear 2nd level
> +       int     (*get_pendown_state)(void *priv);
> +       void    (*clear_penirq)(void *priv);    /* If needed, clear 2nd level
>                                                   interrupt source */
> -       int     (*init_platform_hw)(void);
> -       void    (*exit_platform_hw)(void);
> +       int     (*init_platform_hw)(void *priv);
> +       void    (*exit_platform_hw)(void *priv);
> +
> +       void    *priv;                          /* passed to callbacks */
>  };
>
>  #endif
> --
> 1.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
