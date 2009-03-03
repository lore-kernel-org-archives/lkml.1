Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZCCUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZCCUaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCCU3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:29:50 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:65063 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZCCU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:29:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IPINZowCX891xkuQDz2PtcfIh3FxdEPdTp+OP/Bhnmr8fgeuB1MEGyiGZHZLf4DltA
         60+tlOu9cgNO7rqOGo5441CItkFJ0d//SCVoj4MC/nlWz1LyWFjGa7om41ycgC2CZ5qo
         t6mQerOYHlHKdhp5hWXjBF+NKLyuO0P/dXz58=
Message-ID: <49AD9336.6070209@gmail.com>
Date: Tue, 03 Mar 2009 21:29:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 5/5] Input: add wm97xx accelerated driver for AVR32 AT32AP700X
 microprocessors
References: <20090303182402.GA29542@rakim.wolfsonmicro.main> <1236104684-30214-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1236104684-30214-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1236104684-30214-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1236104684-30214-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1236104684-30214-5-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1236104684-30214-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.3.2009 19:24, Mark Brown wrote:
> +static irqreturn_t at32_wm97xx_channel_b_interrupt(int irq, void *dev_id)
> +{
> +	struct at32_wm97xx *at32_wm97xx = dev_id;
> +	struct wm97xx *wm = at32_wm97xx->wm;
> +	int status = ac97c_readl(at32_wm97xx, CBSR);
> +	int retval = IRQ_NONE;

Just a nit, irqreturn_t will become enum one day AFAIK. Use irqreturn_t 
which is guaranteed to be the proper type instead. This rather a 
suggestion for followup fixup.

> +static int __init at32_wm97xx_probe(struct platform_device *pdev)
> +{
> +	struct wm97xx *wm = platform_get_drvdata(pdev);
> +	struct at32_wm97xx *at32_wm97xx;
> +	int ret;
> +
> +	at32_wm97xx = kzalloc(sizeof(struct at32_wm97xx), GFP_KERNEL);
> +	if (!at32_wm97xx) {
> +		dev_dbg(&pdev->dev, "out of memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	at32_wm97xx->wm		= wm;
> +	at32_wm97xx->regs	= (void *)AT32_WM97XX_AC97C_IOMEM;
> +	at32_wm97xx->ac97c_irq	= AT32_WM97XX_AC97C_IRQ;
> +	at32_wm97xx->gpio_pen	= at32_gpio_line;
> +	at32_wm97xx->gpio_irq	= gpio_to_irq(at32_wm97xx->gpio_pen);
> +
> +	setup_timer(&at32_wm97xx->pen_timer, at32_wm97xx_pen_timer,
> +			(unsigned long)at32_wm97xx);
> +
> +	ret = request_irq(at32_wm97xx->ac97c_irq,
> +			at32_wm97xx_channel_b_interrupt,
> +			IRQF_SHARED, "at32-wm97xx-ch-b", at32_wm97xx);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "could not request ac97c irq\n");

at32_wm97xx leak. I didn't notice last time.

> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, at32_wm97xx);
> +
> +	return wm97xx_register_mach_ops(wm,&at32_mach_ops);

On failure, this will still "leak" irq, I suppose this is what you 
referred as "fix later" in 0/5.
