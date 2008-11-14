Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYKNXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYKNXTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYKNXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:19:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbYKNXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:19:13 -0500
Date: Fri, 14 Nov 2008 15:19:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-Id: <20081114151908.0af38e4c.akpm@linux-foundation.org>
In-Reply-To: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 12:39:57 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> The voltage and current regulators on the WM8350 AudioPlus PMIC can be
> used in concert to provide a power efficient LED driver.  This driver
> implements support for this within the standard LED class.
> 
> Platform initialisation code should configure the LED hardware in the
> init callback provided by the WM8350 core driver.  The callback should
> use wm8350_isink_set_flash(), wm8350_dcdc25_set_mode() and
> wm8350_dcdc_set_slot() to configure the operating parameters of the
> regulators for their hardware and then then use wm8350_register_led() to
> instantiate the LED driver.
> 
> This driver was originally written by Liam Girdwood, though it has been
> extensively modified since then.
>
> ...
>
> +static void wm8350_led_disable(struct wm8350_led *led)
> +{
> +	int ret;
> +
> +	if (!led->enabled)
> +		return;
> +
> +	ret = regulator_disable(led->dcdc);
> +	if (ret != 0) {
> +		dev_err(led->cdev.dev, "Failed to disable DCDC: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = regulator_disable(led->isink);
> +	if (ret != 0) {
> +		dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
> +		regulator_enable(led->isink);

Should be regulator_enable(led->dcdc), yes?

> +		return;
> +	}
> +
> +	led->enabled = 0;
> +}
> +
>
> ...
>
> +static int wm8350_led_remove(struct platform_device *pdev)
> +{
> +	struct wm8350_led *led =
> +	    (struct wm8350_led *)platform_get_drvdata(pdev);

unneeded and undesirable cast of void*.

> +	led_classdev_unregister(&led->cdev);
> +	schedule_work(&led->work);
> +	flush_scheduled_work();

The schedule_work() is unexpected and I can't immediately see why it's
here.  If it is indeed correct, I'd suggest the addition of a comment.

> +	wm8350_led_disable(led);
> +	regulator_put(led->dcdc);
> +	regulator_put(led->isink);
> +	kfree(led);
> +	return 0;
> +}
> +

