Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZCBOfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZCBOfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZCBOet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:34:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:30563 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZCBOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fDdszuPIXwhwNXg0qvuCUlg/HIAecJzMYODltUsgvOm+ZhdMIwRtDjmC3BD4ayClOJ
         7KqsXu/GQXRDNZoZJ/cUs2DDGziuJxs22V2MCaExJRZ+PBG5LPT3FGZ0JuExsE37aEqq
         kurkVEETzEeCHynMzQjDGR1eIcPPMNHG5Xs64=
Message-ID: <49ABEE83.904@gmail.com>
Date: Mon, 02 Mar 2009 15:34:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 2/2] Input: add wm97xx accelerated driver for AVR32 AT32AP700X
 microprocessors
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1236000228-13025-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1236000228-13025-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- /dev/null
> +++ b/drivers/input/touchscreen/at32-wm97xx.c
> +static void at32_wm97xx_pen_timer(unsigned long data)

Wouldn't be delayed_work more appropriate (and convenient) here?

> +{
> +	struct at32_wm97xx *at32_wm97xx = (struct at32_wm97xx *)data;
> +	struct wm97xx *wm = at32_wm97xx->wm;
> +	int pen_down = gpio_get_value(at32_wm97xx->gpio_pen);
> +
> +	if (pen_down != 0) {
> +		mod_timer(&at32_wm97xx->pen_timer, jiffies
> +				+ msecs_to_jiffies(1));
> +	} else {
> +		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
> +		input_sync(wm->input_dev);
> +	}
> +}

> +static int __init at32_wm97xx_probe(struct platform_device *pdev)
> +{
[...]
> +	at32_wm97xx->regs	= (void *)AT32_WM97XX_AC97C_IOMEM;

(void __iomem *)?
Did you feed it through sparse?

> +	ret = request_irq(at32_wm97xx->ac97c_irq,
> +			at32_wm97xx_channel_b_interrupt,
> +			IRQF_SHARED, "at32-wm97xx-ch-b", at32_wm97xx);
[...]
> +	return wm97xx_register_mach_ops(wm,&at32_mach_ops);

In case it fails, irq remains set up.

> +#ifdef CONFIG_PM
> +static int at32_wm97xx_suspend(struct platform_device *pdev, pm_message_t msg)
> +{
> +	struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(pdev);
> +
> +	ac97c_writel(at32_wm97xx, IDR, AC97C_INT_CBEVT);
> +	disable_irq(at32_wm97xx->gpio_irq);

Here, you should call disable_irq_sync() (that's what I meant by _sync 
in the last post).
