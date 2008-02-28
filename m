Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYB1HMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYB1HMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYB1HMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:12:01 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYB1HMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:12:00 -0500
Date: Wed, 27 Feb 2008 23:09:41 -0800
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
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode on
 Mainstone
Message-Id: <20080227230941.f0885763.akpm@linux-foundation.org>
In-Reply-To: <12040332181746-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181161-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181394-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332182008-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181746-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 13:40:17 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> +#ifdef CONFIG_PXA27x
> +static void wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);
> +
> +	while (MISR & (1 << 2))
> +		MODR;
> +}
> +#else
> +static void wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	int count = 16;
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);
> +
> +	while (count < 16) {
> +		MODR;
> +		count--;
> +	}
> +}
> +#endif

Can use schedule_timeout_interruptible() here.

If the calling process happens to have a signal pending then the
schedule_timeout() becomes a no-op.  Will the driver still function
correctly?

> +static int wm97xx_acc_pen_down(struct wm97xx *wm)
> +{
> +	u16 x, y, p = 0x100 | WM97XX_ADCSEL_PRES;
> +	int reads = 0;
> +
> +	/* data is never immediately available after pen down irq */
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);

dittoes.

> +	if (tries > 5) {
> +		tries = 0;
> +		return RC_PENUP;
> +	}
> +
> +	x = MODR;
> +	if (x == last) {
> +		tries++;
> +		return RC_AGAIN;
> +	}
> +	last = x;
> +	do {
> +		if (reads)
> +			x = MODR;
> +		y = MODR;
> +		if (pressure)
> +			p = MODR;
> +
> +		/* are samples valid */
> +		if ((x & 0x7000) != WM97XX_ADCSEL_X ||
> +			(y & 0x7000) != WM97XX_ADCSEL_Y ||
> +			(p & 0x7000) != WM97XX_ADCSEL_PRES)
> +			goto up;
> +
> +		/* coordinate is good */
> +		tries = 0;
> +		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
> +		input_sync(wm->input_dev);
> +		reads++;
> +	} while (reads < cinfo[sp_idx].reads);
> +up:
> +	return RC_PENDOWN | RC_AGAIN;
> +}
> +

