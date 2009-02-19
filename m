Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZBSRmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZBSRmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZBSRmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:42:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:49601 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZBSRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QTtHL16j2gNRNHLYseG4mb1hLvtdDbWJL6e1Y5h3VnuBPYiaankVJxUBs9pgGehkbq
         BTU1Fq0kvV3XAaQ6EusQZyoN20L7PLQgIiJPM0ejKnxUPha6WzDYwmEf6wAARULUjLmj
         zOeppjwM6HB04b/l+dCE42yMYPZCfNaolKEv0=
MIME-Version: 1.0
In-Reply-To: <1235045654-29025-1-git-send-email-me@felipebalbi.com>
References: <1235045654-29025-1-git-send-email-me@felipebalbi.com>
Date: Thu, 19 Feb 2009 23:12:07 +0530
Message-ID: <5d5443650902190942v5adf0a26l6d5d6600b759f2b1@mail.gmail.com>
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Flipe,

> diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
> new file mode 100644
> index 0000000..27da93c
> --- /dev/null
> +++ b/drivers/input/keyboard/lm8323.c
> @@ -0,0 +1,913 @@
> +/*
> + * drivers/i2c/chips/lm8323.c
> + *
> + * Copyright (C) 2007 Nokia Corporation

You might want to update this if you have updated some code before
submitting to kernel list.

> +
> +       err = request_irq(client->irq, lm8323_irq,
> +                         IRQF_TRIGGER_FALLING | IRQF_DISABLED |
> +                         IRQF_SAMPLE_RANDOM, "lm8323", lm);

No need to add IRQF_SAMPLE_RANDOM, it is done input subsystem. Please
check input_report_event.

> +
> +       set_irq_wake(client->irq, 1);

Shall we move to device_init_wakup + enable_irq_wake friends ?

> +
> +       lm->kp_enabled = 1;
> +       err = device_create_file(&client->dev, &dev_attr_disable_kp);
> +       if (err < 0)
> +               goto fail7;
> +
> +       idev = input_allocate_device();
> +       if (!idev) {
> +               err = -ENOMEM;
> +               goto fail8;
> +       }
> +
> +       if (pdata->name)
> +               idev->name = pdata->name;
> +       else
> +               idev->name = "LM8323 keypad";
> +       snprintf(lm->phys, sizeof(lm->phys), "%s/input-kp", client->dev.bus_id);
> +       idev->phys = lm->phys;
> +
> +       lm->keys_down = 0;
> +       idev->evbit[0] = BIT(EV_KEY);
> +       for (i = 0; i < LM8323_KEYMAP_SIZE; i++) {
> +               if (pdata->keymap[i] > 0)
> +                       set_bit(pdata->keymap[i], idev->keybit);

No difference but better to use __set_bit, as atomicity is not required here.

> +
> +               lm->keymap[i] = pdata->keymap[i];
> +       }
> +
> +       if (pdata->repeat)
> +               set_bit(EV_REP, idev->evbit);

Ditto.

Also in lm8323_remove we need to set_irq_wake(..., 0) right?

> +
> diff --git a/include/linux/i2c/lm8323.h b/include/linux/i2c/lm8323.h
> new file mode 100644
> index 0000000..5eae5cc
> --- /dev/null
> +++ b/include/linux/i2c/lm8323.h
> @@ -0,0 +1,35 @@
> +/*
> + * include/lm8323.h

Path problem...better to remove it.




---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
