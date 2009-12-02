Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZLBSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZLBSGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZLBSGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:06:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36411 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755150AbZLBSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:06:54 -0500
Date: Wed, 2 Dec 2009 18:06:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-ID: <20091202180658.GA12292@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
X-Cookie: Look ere ye leap.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 06:40:25PM +0100, Antonio Ospite wrote:

> A doubt I had was about leaving the 'supply' variable configurable from
> platform data, or relying on some fixed value like "vled", but leaving it
> configurable covers the case when we have different regulators used for
> different LEDs or vibrators.

There's no need to do this since the regulator API matches consumers
based on struct device as well as name so you can have as many LEDs as
you like all using the same supply name mapping to different regulators.

> Should I add a note in Documentation/ about how to use it? Tell me if so.

If you wish to, it's not essential (only one existing LED driver appears
to do this) and the comment in the header file is probably adequate.

> +static inline int led_regulator_get_max_brightness(struct regulator *supply)
> +{
> +	return regulator_count_voltages(supply);
> +}

More graceful handling of regulators that don't implement list_voltage
might be nice (for simple on/off control - not all regulators have
configurable voltages).  If a regulator doesn't support list_voltage
you'll get -EINVAL.

> +	vcc = regulator_get(&pdev->dev, pdata->supply);
> +	if (IS_ERR(vcc)) {
> +		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
> +		return PTR_ERR(vcc);;
> +	}

You almost certainly want regulator_get_exclusive() here; this driver
can't function properly if something else is using the regulator and
holding the LED on or off without it.  You'll also want to check the
status of the LED on startup and update your internal status to match
that.
