Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673Ab0AXVJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0AXVJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 16:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517Ab0AXVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 16:09:10 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51649 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0AXVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 16:09:08 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in .init.text
References: <20100122173846.GA11057@suse.de>
	<1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Mon, 25 Jan 2010 06:09:01 +0900
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
	("Uwe =?iso-8859-1?Q?Kleine-K=F6nig=22's?= message of "Fri, 22 Jan 2010
 20:49:18 +0100")
Message-ID: <87y6jnw6qa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> +int platform_driver_register(struct platform_driver *drv)
> +{
> +	int ret = __platform_driver_register(drv);
> +
> +#if defined(CONFIG_HOTPLUG)
> +	/*
> +	 * drivers that are registered by platform_driver_register
> +	 * should not have their probe function in .init.text.  The
> +	 * reason is that a probe can happen after .init.text is
> +	 * discarded which then results in an oops.  The alternatives
> +	 * are using .devinit.text for the probe function or "register"
> +	 * with platform_driver_probe.
> +	 */
> +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> +		pr_warning("oops-warning: probe function of platform driver %s"
> +			       " lives in .init.text\n", drv->driver.name);
> +#else
> +	/*
> +	 * without HOTPLUG probe functions can be discarded after the driver is
> +	 * loaded.
> +	 * There is a little chance for false positives, namely if the driver is
> +	 * registered after the .init sections are discarded.
> +	 */
> +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> +		pr_info("probably the probe function of platform driver %s can"
> +				" be moved to .init.text\n", drv->driver.name);
> +#endif
> +	return ret;
> +}

Um..., can't we extend modpost or such one for this? I think the static
analysis is better (assume the changing ->probe dynamically is really
rare).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
