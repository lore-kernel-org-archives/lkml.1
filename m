Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZKBR1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZKBR1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZKBR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:27:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46716 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756505AbZKBR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:27:18 -0500
Date: Mon, 2 Nov 2009 17:27:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com, linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH 5/5] ASoC: TWL4030: Do not modify the APLL_CTL register
Message-ID: <20091102172720.GA8546@rakim.wolfsonmicro.main>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-3-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-5-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-6-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257165295-9352-6-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Humpty Dumpty was pushed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 02:34:55PM +0200, Peter Ujfalusi wrote:
> APLL_CTL register is configured by the twl4030-codec MFD
> driver.
> Remove code, which makes changes in the APLL_CTL register,
> and replace those with checks against the configured
> audio_mclk configuration done in the MFD driver.

This all looks mostly OK.  It might be nice to combine this patch with
the change to the MFD driver, simply because when the previous patch
said "move" but didn't remove anything from the CODEC driver it seemed a
bit surprising.  The MFD part of this is queued in ASoC ATM so it
shouldn't cause cross tree issues.

> -	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
> +	if ((freq / 1000) != twl4030->sysclk) {
> +		dev_err(codec->dev,
> +			"Mismatch in APLL infrequency %u (configred: %u)\n",
> +			freq, twl4030->sysclk * 1000);

Typos in the log message here (and similarly for the other DAI).

> -	if (infreq != TWL4030_APLL_INFREQ_26000KHZ) {
> +	if (twl4030->sysclk != 26000) {
>  		printk(KERN_ERR "TWL4030 voice startup: "
>  			"MCLK is not 26MHz, call set_sysclk() on init\n");
>  		return -EINVAL;

Is that advice still appropriate if things are specified via the
codec device now?

> @@ -2233,6 +2215,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
>  	twl4030_codec = codec;
>  
>  	/* Set the defaults, and power up the codec */
> +	twl4030->sysclk = twl4030_codec_get_mclk() / 1000;
>  	twl4030_init_chip(codec);
>  	codec->bias_level = SND_SOC_BIAS_OFF;
>  	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);

twl4030_codec_get_mclk() feels like it ought to take a parameter saying
which twl4030, though the chances of having multiple twl4030s in one
system are remote so it's not a real issue.
