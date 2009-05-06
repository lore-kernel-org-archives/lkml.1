Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZEFNo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZEFNo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZEFNot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:44:49 -0400
Received: from mail-qy0-f125.google.com ([209.85.221.125]:59228 "EHLO
	mail-qy0-f125.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZEFNor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:44:47 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 09:44:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UwHL5FiTJr18ml52mqbY9y6SJiGkBKb6LnqfbVcRE1EduIYz8yD55gV5BYx3Sxrr9M
         pCB2Zq8qk9iVTIqtJ7KgjAUkUdMuntaQ7oO+guZjgePhCj6ptFxSU7sxat7yAhwzte09
         /U3SaSi06t9r7CctyP8HU0Id0IZzAiLxuYpo0=
MIME-Version: 1.0
In-Reply-To: <4A012C64.1020101@samsung.com>
References: <4A012C64.1020101@samsung.com>
Date: Wed, 6 May 2009 19:08:25 +0530
Message-ID: <5d5443650905060638l52b3c17dle0d138b689a23252@mail.gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Kim Kyuwon <q1.kim@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>, linux-i2c@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Wed, May 6, 2009 at 11:51 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
> The Maxim MAX7359 is a I2C interfaced key switch controller which provides microprocessors with management of up to 64 key switches.
> This patch adds support for the MAX7359 key switch controller.
>

Could you please restrict the commit text line to 80/72 columns? It
will look good.

> +static irqreturn_t max7359_interrupt(int irq, void *dev_id)
> +{
> +       struct max7359_keypad *keypad = (struct max7359_keypad *) dev_id;

No need of casting. Please remove.

> +
> +       if (!work_pending(&keypad->work)) {
> +               disable_irq_nosync(keypad->irq);
> +               schedule_work(&keypad->work);
> +       } else {
> +               dev_err(&keypad->client->dev,
> +                               "Another job is currently pending \n");
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +

> +
> +static int __devinit max7359_probe(struct i2c_client *client,
> +                                       const struct i2c_device_id *id)

You may want to remove __devinit as it is i2c client driver . I have
added linux-i2c for i2c
specific review.

> +static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +       /* If no keys are pressed, enter sleep mode for 8192 ms */
> +       max7359_write_reg(client, MAX7359_REG_SLEEP, 0x01);
> +
> +       return 0;
> +}
> +
> +static int max7359_resume(struct i2c_client *client)
> +{
> +       /* Restore the default setting (autosleep for 256 ms) */
> +       max7359_write_reg(client, MAX7359_REG_SLEEP, 0x07);
> +
> +       return 0;
> +}

Protect these two function with #ifdef CONFIG_PM please.

> +

> +
> +static struct i2c_driver max7359_i2c_driver = {
> +       .driver = {
> +               .name = "max7359",
> +       },
> +       .probe          = max7359_probe,
> +       .remove         = __exit_p(max7359_remove),


> +};
> +
> +
> +MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
> +MODULE_DESCRIPTION("MAX7359 Key Switch Controller Driver");
> +MODULE_LICENSE("GPL v2");

MODULE_ALIAS ??

> diff --git a/include/linux/max7359_keypad.h b/include/linux/max7359_keypad.h

> +
> +#define KEY(row, col, val)     (((row) << 28) | ((col) << 24) | (val))

Looks like this macro is highly used by many input drivers, anyone
looking at it to place it at common location?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
