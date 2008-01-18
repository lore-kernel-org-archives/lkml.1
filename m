Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbYARRXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbYARRXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761637AbYARRXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:23:47 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:32437 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761171AbYARRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:23:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=syuCBU1ESYiybeBsMnc9SfkdQF1LuTxH1O+3WA+MX7ymw22m/UNB0fiqKWc+DcqWNKejI9yX/bHMIHBIe1q8z4TTcHjM/1D8iZBZQsdUoRgbBxE4trvZJu6YJYfzCNK1eYdikWiGsA/c0aEYTgMudFMPQtKBnBOMzaQ+li8cRKs=
Date: Fri, 18 Jan 2008 12:23:41 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Message-ID: <20080118120148.ZZRA012@mailhub.coreip.homeip.net>
References: <20080118162627.GA28974@rakim.wolfsonmicro.main> <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 18, 2008 at 04:27:06PM +0000, Mark Brown wrote:
> This patch series adds support for the touchscreen controllers provided
> by Wolfson Microelectronics WM97xx series chips in both polled and
> streaming modes.
>

Thank you for the patches. Some comments below.

> +static int wm97xx_ts_input_open(struct input_dev *idev)
> +{
> +	struct wm97xx *wm = (struct wm97xx *)input_get_drvdata(idev);

No need to cast.

> +
> +	mutex_lock(&wm->ts_mutex);
> +	/* first time opened ? */
> +	if (wm->ts_use_count++ == 0) {

You do not need to implement a counter here. Input core makes sure
that open and close are only called for the fist and last user
respectivly. ts_mutex can go away as well.

> +	/* set up touch configuration */
> +	wm->input_dev->name = "wm97xx touchscreen";
> +	wm->input_dev->open = wm97xx_ts_input_open;
> +	wm->input_dev->close = wm97xx_ts_input_close;
> +	set_bit(EV_ABS, wm->input_dev->evbit);
> +	set_bit(ABS_X, wm->input_dev->absbit);
> +	set_bit(ABS_Y, wm->input_dev->absbit);
> +	set_bit(ABS_PRESSURE, wm->input_dev->absbit);
> +	wm->input_dev->absmax[ABS_X] = abs_x[1];
> +	wm->input_dev->absmax[ABS_Y] = abs_y[1];
> +	wm->input_dev->absmax[ABS_PRESSURE] = abs_p[1];
> +	wm->input_dev->absmin[ABS_X] = abs_x[0];
> +	wm->input_dev->absmin[ABS_Y] = abs_y[0];
> +	wm->input_dev->absmin[ABS_PRESSURE] = abs_p[0];
> +	wm->input_dev->absfuzz[ABS_X] = abs_x[2];
> +	wm->input_dev->absfuzz[ABS_Y] = abs_y[2];
> +	wm->input_dev->absfuzz[ABS_PRESSURE] = abs_p[2];

input_set-abs_params(wm->input_dev, ABS_X, ...);
input_set-abs_params(wm->input_dev, ABS_Y, ...);
input_set-abs_params(wm->input_dev, ABS_X, ...);

I'd also recoomend using a temp for wm->input_dev, shoudl save a couple
of bytes.

> +	input_set_drvdata(wm->input_dev, wm);

Also wm->input_dev->dev.parent = &dev; to put it in the proper place
in sysfs hierarchy.

> +	ret = input_register_device(wm->input_dev);
> +	if (ret < 0) {

Add input_free_device(); here.

> +		kfree(wm);
> +		return -ENOMEM;
> +	}

I will need some more time to review and understand the need for the new bus
in the driver.

Thanks.

-- 
Dmitry
