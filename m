Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbZEKBv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbZEKBv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZEKBvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:51:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60796 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZEKBvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:51:47 -0400
Date: Mon, 11 May 2009 10:51:32 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
In-reply-to: <20090509200118.GB1617@dtor-d630.eng.vmware.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4A0784A4.1010703@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
References: <4A04E5EA.7000103@samsung.com>
 <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
 <20090509200118.GB1617@dtor-d630.eng.vmware.com>
X-OriginalArrivalTime: 11 May 2009 01:51:32.0640 (UTC)
 FILETIME=[027A9200:01C9D1DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 5:01 AM, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> P.S. I made a bunch of random changes, mostly to streamline the probe
> code (below), hopfully I did not break anything.
>
> diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
> index 918386c..280edc3 100644
> --- a/drivers/input/keyboard/max7359_keypad.c
> +++ b/drivers/input/keyboard/max7359_keypad.c
> @@ -204,71 +198,59 @@ static int __devinit max7359_probe(struct i2c_client *client,
>                                        const struct i2c_device_id *id)
>  {
>        struct max7359_keypad *keypad;
> -       struct max7359_keypad_platform_data *pdata;
> +       struct max7359_keypad_platform_data *pdata = client->dev.platform_data;
>        struct input_dev *input_dev;
>        int ret;
> +       int error;
>
> -       keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
> -       if (keypad == NULL) {
> -               dev_err(&client->dev, "failed to allocate driver data\n");
> -               return -ENOMEM;
> +       if (!client->irq) {
> +               dev_err(&client->dev, "The irq number should not be zero\n");
> +               return -EINVAL;
>        }
>
> -       keypad->client = client;
> -       pdata = keypad->pdata = client->dev.platform_data;
> -       i2c_set_clientdata(client, keypad);
> -
>        /* Detect MAX7359: The initial Keys FIFO value is '0x3F' */
>        ret = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
>        if (ret < 0) {
>                dev_err(&client->dev, "failed to detect device\n");
> -               goto failed_free;
> -       } else {
> -               dev_info(&client->dev, "keys FIFO is 0x%02x"
> -                               ", succeeded in detecting device\n", ret);
> +               return -ENODEV;
>        }
>
> -       /* Initialize MAX7359 */
> -       max7359_initialize(client);
> +       dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", ret);
>
> -       /* Create and register the input driver. */
> +       keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
>        input_dev = input_allocate_device();
> -       if (!input_dev) {
> -               dev_err(&client->dev, "failed to allocate input device\n");
> -               ret = -ENOMEM;
> -               goto failed_free;
> +       if (!keypad || !input_dev) {
> +               dev_err(&client->dev, "failed to allocate memory\n");
> +               error = -ENOMEM;
> +               goto failed_free_mem;
>        }

Hi Dmitry,

Thank you for streamlining this driver. I confirmed this streamlined driver
is nicely working on my S3C6410 board and of course I mostly like your
changes. But I'm afraid this 'error' variable is not used at the final
return statement in the probe function.

Thanks & Regards,
Kyuwon

P.S. You may need this kind of patch.
--
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index 280edc3..6e09e0d 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -200,7 +200,6 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	struct max7359_keypad *keypad;
 	struct max7359_keypad_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input_dev;
-	int ret;
 	int error;
 
 	if (!client->irq) {
@@ -209,13 +208,13 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	}
 
 	/* Detect MAX7359: The initial Keys FIFO value is '0x3F' */
-	ret = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
-	if (ret < 0) {
+	error = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
+	if (error < 0) {
 		dev_err(&client->dev, "failed to detect device\n");
 		return -ENODEV;
 	}
 
-	dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", ret);
+	dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", error);
 
 	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
 	input_dev = input_allocate_device();
@@ -254,8 +253,8 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	}
 
 	/* Register the input device */
-	ret = input_register_device(input_dev);
-	if (ret) {
+	error = input_register_device(input_dev);
+	if (error) {
 		dev_err(&client->dev, "failed to register input device\n");
 		goto failed_free_irq;
 	}
@@ -273,7 +272,7 @@ failed_free_irq:
 failed_free_mem:
 	input_free_device(input_dev);
 	kfree(keypad);
-	return ret;
+	return error;
 }
 
 static int __devexit max7359_remove(struct i2c_client *client)

