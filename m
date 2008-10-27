Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbYJ0FP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbYJ0FP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYJ0FPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:15:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbYJ0FPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:15:12 -0400
Date: Sun, 26 Oct 2008 22:14:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-Id: <20081026221431.7100bbf7.akpm@linux-foundation.org>
In-Reply-To: <1224531318-10349-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081020193328.GA10272@rakim.wolfsonmicro.main>
	<1224531318-10349-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1224531318-10349-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 20:35:18 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> +static int wm8350_rtc_stop_alarm(struct wm8350 *wm8350)
> +{
> +	int retries = WM8350_SET_ALM_RETRIES;
> +	u16 rtc_ctrl;
> +	int ret;
> +
> +	/* Set RTC_SET to stop the clock */
> +	ret = wm8350_set_bits(wm8350, WM8350_RTC_TIME_CONTROL,
> +			      WM8350_RTC_ALMSET);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Wait until confirmation of stopping */
> +	do {
> +		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
> +		schedule_timeout_interruptible(msecs_to_jiffies(1));

If the calling process has signal_pending() (eg: someone typed ^C) then
schedule_timeout_interruptible() will return immediately.

> +	} while (retries-- && !(rtc_ctrl & WM8350_RTC_ALMSTS));
> +
> +	if (!(rtc_ctrl & WM8350_RTC_ALMSTS))
> +		return -ETIMEDOUT;

And the driver will incorrectly return -ETIMEDOUT.

> +	return 0;
> +}
> +
> +static int wm8350_rtc_start_alarm(struct wm8350 *wm8350)
> +{
> +	int ret;
> +	int retries = WM8350_SET_ALM_RETRIES;
> +	u16 rtc_ctrl;
> +
> +	ret = wm8350_clear_bits(wm8350, WM8350_RTC_TIME_CONTROL,
> +				WM8350_RTC_ALMSET);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Wait until confirmation */
> +	do {
> +		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
> +		schedule_timeout_interruptible(msecs_to_jiffies(1));
> +	} while (retries-- && rtc_ctrl & WM8350_RTC_ALMSTS);
> +
> +	if (rtc_ctrl & WM8350_RTC_ALMSTS)
> +		return -ETIMEDOUT;

ditto.

> +	return 0;
> +}

I'll switch those to schedule_timeout_uninterruptible(), OK?
