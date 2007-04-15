Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXDOT5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXDOT5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXDOT5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:57:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3839 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753528AbXDOT5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:57:34 -0400
Date: Sun, 15 Apr 2007 19:40:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 6/7] [RFC] ds2760 battery driver
Message-ID: <20070415194001.GF10097@ucw.cz>
References: <20070411232522.GF20095@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411232522.GF20095@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is driver for batteries with ds2760 chip inside. Such batteries
> used in almost every HP iPaq and HTC PDAs/phones.

Looks nice to me. It even knows about dependency between temperature
and remaining power :-).


> +	di->update_time = jiffies;
> +
> +	/* DS2760 reports voltage in units of 4.88mV, but the battery class
> +	 * reports in units of mV, so convert by multiplying by 4.875.
> +	 * We approximate because integer math is cheap, and close enough. */
> +	di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
> +	                  (di->raw[DS2760_VOLTAGE_LSB] >> 5);
> +	di->voltage_mV = (di->voltage_raw * 5) - (di->voltage_raw / 8);

Hmm, not sure if such tricks re really worth it... should not compiler
be doing this?


> +	/* Calculate the empty level at the present temperature. */
> +	scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
> +	for (i = 3; i >= 0; i--)
> +		scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
> +
> +	di->empty_mAh = battery_interpolate(scale, di->temp_C / 10);

Wow.

> +static struct platform_driver ds2760_battery_driver = {
> +	.driver = {
> +		.name = "ds2760-battery",
> +	},
> +	.probe	  = ds2760_battery_probe,
> +	.remove   = ds2760_battery_remove,
> +	#ifdef CONFIG_PM
> +	.suspend  = ds2760_battery_suspend,
> +	.resume	  = ds2760_battery_resume,
> +	#endif

I thought ifdefs need to be at column 0?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
