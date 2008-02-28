Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYB1HVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYB1HVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYB1HUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:20:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYB1HUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:20:49 -0500
Date: Wed, 27 Feb 2008 23:09:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 2/6] Add chip driver for WM9705 touchscreen
Message-Id: <20080227230932.3e7f699c.akpm@linux-foundation.org>
In-Reply-To: <12040332181161-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181161-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 13:40:14 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> +/*
> + * Set current used for pressure measurement.
> + *
> + * Set pil = 2 to use 400uA
> + *     pil = 1 to use 200uA and
> + *     pil = 0 to disable pressure measurement.
> + *
> + * This is used to increase the range of values returned by the adc
> + * when measureing touchpanel pressure.
> + */
> +static int pil;
> +module_param(pil, int, 0);
> +MODULE_PARM_DESC(pil, "Set current used for pressure measurement.");
> +
> +/*
> + * Set threshold for pressure measurement.
> + *
> + * Pen down pressure below threshold is ignored.
> + */
> +static int pressure = DEFAULT_PRESSURE & 0xfff;
> +module_param(pressure, int, 0);
> +MODULE_PARM_DESC(pressure, "Set threshold for pressure measurement.");
> +
> +/*
> + * Set adc sample delay.
> + *
> + * For accurate touchpanel measurements, some settling time may be
> + * required between the switch matrix applying a voltage across the
> + * touchpanel plate and the ADC sampling the signal.
> + *
> + * This delay can be set by setting delay = n, where n is the array
> + * position of the delay in the array delay_table below.
> + * Long delays > 1ms are supported for completeness, but are not
> + * recommended.
> + */
> +static int delay = 4;
> +module_param(delay, int, 0);
> +MODULE_PARM_DESC(delay, "Set adc sample delay.");
> +
> +/*
> + * Pen detect comparator threshold.
> + *
> + * 0 to Vmid in 15 steps, 0 = use zero power comparator with Vmid threshold
> + * i.e. 1 =  Vmid/15 threshold
> + *      15 =  Vmid/1 threshold
> + *
> + * Adjust this value if you are having problems with pen detect not
> + * detecting any down events.
> + */
> +static int pdd = 8;
> +module_param(pdd, int, 0);
> +MODULE_PARM_DESC(pdd, "Set pen detect comparator threshold");

I guess that's all the documentation we get ;) It won't kill us - we've done
worse..

It would be rather nice if the kerneldoc system could extract the above
comments and put them in a module-parameters-documentation section, but I
don't think it can do that.

> ...
>
> +/*
> + * Read a sample from the WM9705 adc in polling mode.
> + */
> +static int wm9705_poll_sample(struct wm97xx *wm, int adcsel, int *sample)
> +{
> +	int timeout = 5 * delay;
> +
> +	if (!wm->pen_probably_down) {
> +		u16 data = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER_RD);
> +		if (!(data & WM97XX_PEN_DOWN))
> +			return RC_PENUP;
> +		wm->pen_probably_down = 1;
> +	}
> +
> +	/* set up digitiser */
> +	if (adcsel & 0x8000)
> +		adcsel = ((adcsel & 0x7fff) + 3) << 12;
> +
> +	if (wm->mach_ops && wm->mach_ops->pre_sample)
> +		wm->mach_ops->pre_sample(adcsel);
> +	wm97xx_reg_write(wm, AC97_WM97XX_DIGITISER1,
> +			 adcsel | WM97XX_POLL | WM97XX_DELAY(delay));
> +
> +	/* wait 3 AC97 time slots + delay for conversion */
> +	poll_delay(delay);
> +
> +	/* wait for POLL to go low */
> +	while ((wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER1) & WM97XX_POLL)
> +	       && timeout) {
> +		udelay(AC97_LINK_FRAME);
> +		timeout--;
> +	}
> +
> +	if (timeout <= 0) {

timeout cannot be negative here.

> +		/* If PDEN is set, we can get a timeout when pen goes up */
> +		if (is_pden(wm))
> +			wm->pen_probably_down = 0;
> +		else
> +			dev_dbg(wm->dev, "adc sample timeout");
> +		return RC_PENUP;
> +	}
> +
> +	*sample = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER_RD);
> +	if (wm->mach_ops && wm->mach_ops->post_sample)
> +		wm->mach_ops->post_sample(adcsel);
> +
> +	/* check we have correct sample */
> +	if ((*sample & WM97XX_ADCSEL_MASK) != adcsel) {
> +		dev_dbg(wm->dev, "adc wrong sample, read %x got %x", adcsel,
> +		*sample & WM97XX_ADCSEL_MASK);
> +		return RC_PENUP;
> +	}
> +
> +	if (!(*sample & WM97XX_PEN_DOWN)) {
> +		wm->pen_probably_down = 0;
> +		return RC_PENUP;
> +	}
> +
> +	return RC_VALID;
> +}
> +

