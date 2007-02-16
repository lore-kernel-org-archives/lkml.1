Return-Path: <linux-kernel-owner+w=401wt.eu-S1161740AbXBPEJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161740AbXBPEJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161738AbXBPEJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:09:47 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:23727 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423132AbXBPEJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:09:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgeALK81EVKhRO4UGdsb2JhbACHHodKAQEqknMBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Subject: Re: [PATCH] Add Cobalt button interface driver support
Date: Thu, 15 Feb 2007 23:09:43 -0500
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152309.44563.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 22:36, Yoichi Yuasa wrote:
> Hi,
> 
> This patch adds support for the back panel buttons on Cobalt server.
> It's tested on the Cobalt Qube2.
> 

Hi,

Thank you for your patch. Couple of comments:

> +
> +		button++;
> +	}
> +
> +	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);

May I suggest using msecs_to_jiffies() to avoid direct computations on HZ?

> +
> +	bdev->input = input;
> +	bdev->reg = ioremap(res->start, res->end - res->start + 1);
> +	dev_set_drvdata(&pdev->dev, bdev);
> +
> +	setup_timer(&buttons_timer, handle_buttons, (unsigned long)bdev);
> +	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);

Please implement cobalt_buttons_open() and cobalt_buttons_close() methods
and start/stop timer from there - there is no point in polling hardware
if noone is listening to the events.

> +
> +	return retval;
> +}
> +
> +static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct buttons_dev *bdev = dev_get_drvdata(dev);
> +
> +	del_timer(&buttons_timer);

del_timer_sync? Is there any possibility it may run SMP?

> +
> +static void __exit cobalt_buttons_exit(void)
> +{
> +	platform_driver_unregister(&cobalt_buttons_driver);

You are not allowed to unregister statically allocated devices -
if there are references left and your module goes away then
these references become invalid and kernel goes boom.

Please convert to platform_device_alloc/platform_device_add.

Is there a point of moving platform device creation code into
platform-specific code? Is there a possibility of this driver
being used elsewhere?

> +	platform_device_unregister(&cobalt_buttons_device);
> +}
> +
> +module_init(cobalt_buttons_init);
> +module_exit(cobalt_buttons_exit);
> 

-- 
Dmitry
