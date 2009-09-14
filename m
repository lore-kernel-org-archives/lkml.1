Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZINGRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZINGRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZINGRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:17:50 -0400
Received: from centrinvest.ru ([94.25.115.130]:35600 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZINGRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:17:50 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 14 Sep 2009 10:17:48 +0400
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] input/keyboard: new OpenCores Keyboard Controller
 driver
Message-ID: <20090914061748.GA13139@centrinvest.ru>
Mail-Followup-To: Mike Frysinger <vapier@gentoo.org>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Javier Herrero <jherrero@hvsistemas.es>,
	Bryan Wu <cooloney@kernel.org>
References: <1252894678-26929-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252894678-26929-1-git-send-email-vapier@gentoo.org>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 256, 09 13, 2009 at 10:17:58 -0400, Mike Frysinger wrote:
> From: Javier Herrero <jherrero@hvsistemas.es>
> 
> Driver for the keyboard hardware documented here:
> 	http://www.opencores.org/project,keyboardcontroller
> 
> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---

> +static int __devinit opencores_kbd_probe(struct platform_device *pdev)
> +{
> +	struct input_dev *input;
> +	struct opencores_kbd *opencores_kbd;
> +	int i, error;
> +
> +	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
> +	if (!opencores_kbd)
> +		return -ENOMEM;
> +
> +	opencores_kbd->keycode = kmalloc(NUM_KEYS * sizeof(unsigned short), GFP_KERNEL);
> +	if (!opencores_kbd->keycode) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	platform_set_drvdata(pdev, opencores_kbd);
> +
> +	opencores_kbd->addr_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	opencores_kbd->irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +
> +	if (opencores_kbd->addr_res == NULL || opencores_kbd->irq_res == NULL) {
> +		printk(KERN_ERR "insufficient resources\n");
> +		error = -ENOENT;
> +		goto out1;
> +	}
> +
> +	error = request_irq(opencores_kbd->irq_res->start, &opencores_kbd_isr, IRQF_TRIGGER_RISING, pdev->name, pdev);

What if interrupt will trigger right here ? It's common pattern for input drivers to
request irq after input_allocate_device().

> +	if (error) {
> +		printk(KERN_ERR DRV_NAME ": Unable to claim irq %d; error %d\n", opencores_kbd->irq_res->start, error);
> +		goto out2;

Looks like out1 should be used here, otherwise you will try to free irq which
was not registered yet.

> +	}
> +
> +	input = input_allocate_device();
> +	if (!input) {
> +		error = -ENOMEM;
> +		goto out3;

out2 ?

> +	}
> +
> +	opencores_kbd->input = input;
> +
> +	input->name = pdev->name;
> +	input->phys = "opencores-kbd/input0";
> +	input->dev.parent = &pdev->dev;
> +
> +	input_set_drvdata(input, opencores_kbd);
> +
> +	input->id.bustype = BUS_HOST;
> +	input->id.vendor = 0x0001;
> +	input->id.product = 0x0001;
> +	input->id.version = 0x0100;
> +
> +	input->keycodesize = sizeof(*opencores_kbd->keycode);
> +	input->keycodemax = NUM_KEYS;
> +	input->keycode = opencores_kbd->keycode;
> +
> +	__set_bit(EV_KEY, input->evbit);
> +
> +	for (i = 0; i < input->keycodemax; i++) {
> +		opencores_kbd->keycode[i] = i;
> +		__set_bit(opencores_kbd->keycode[i] & KEY_MAX, input->keybit);
> +	}
> +	__clear_bit(KEY_RESERVED, input->keybit);
> +
> +	error = input_register_device(opencores_kbd->input);
> +	if (error) {
> +		printk(KERN_ERR DRV_NAME ": Unable to register input device (%d)\n", error);
> +		goto out2;

out3 ?

> +	}
> +
> +	return 0;
> +
> +out3:
> +	input_free_device(input);
> +out2:
> +	free_irq(opencores_kbd->irq_res->start, pdev);
> +out1:
> +	kfree(opencores_kbd->keycode);
> +out:
> +	kfree(opencores_kbd);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return error;
> +}
