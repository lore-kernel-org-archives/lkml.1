Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZKCOFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZKCOFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZKCOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:05:44 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64817 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZKCOFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:05:43 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/5] ASoC: TWL4030: Do not modify the APLL_CTL register
Date: Tue, 3 Nov 2009 16:05:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com> <1257165295-9352-6-git-send-email-peter.ujfalusi@nokia.com> <20091102172720.GA8546@rakim.wolfsonmicro.main>
In-Reply-To: <20091102172720.GA8546@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911031605.34378.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 03 Nov 2009 14:05:37.0185 (UTC) FILETIME=[B7C6C910:01CA5C8E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009 19:27:20 ext Mark Brown wrote:
> On Mon, Nov 02, 2009 at 02:34:55PM +0200, Peter Ujfalusi wrote:
> > APLL_CTL register is configured by the twl4030-codec MFD
> > driver.
> > Remove code, which makes changes in the APLL_CTL register,
> > and replace those with checks against the configured
> > audio_mclk configuration done in the MFD driver.
> 
> This all looks mostly OK.  It might be nice to combine this patch with
> the change to the MFD driver, simply because when the previous patch
> said "move" but didn't remove anything from the CODEC driver it seemed a
> bit surprising.  The MFD part of this is queued in ASoC ATM so it
> shouldn't cause cross tree issues.

I just wanted to keep patches for different subsystems separate, but I can 
either merge those two, or change the commit message in patch 3, that it will be 
not misleading. 

> 
> > -	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
> > +	if ((freq / 1000) != twl4030->sysclk) {
> > +		dev_err(codec->dev,
> > +			"Mismatch in APLL infrequency %u (configred: %u)\n",
> > +			freq, twl4030->sysclk * 1000);
> 
> Typos in the log message here (and similarly for the other DAI).

Will fix those.

> 
> > -	if (infreq != TWL4030_APLL_INFREQ_26000KHZ) {
> > +	if (twl4030->sysclk != 26000) {
> >  		printk(KERN_ERR "TWL4030 voice startup: "
> >  			"MCLK is not 26MHz, call set_sysclk() on init\n");
> >  		return -EINVAL;
> 
> Is that advice still appropriate if things are specified via the
> codec device now?

Correct, it is not correct.

> 
> > @@ -2233,6 +2215,7 @@ static int __devinit twl4030_codec_probe(struct
> > platform_device *pdev) twl4030_codec = codec;
> >
> >  	/* Set the defaults, and power up the codec */
> > +	twl4030->sysclk = twl4030_codec_get_mclk() / 1000;
> >  	twl4030_init_chip(codec);
> >  	codec->bias_level = SND_SOC_BIAS_OFF;
> >  	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> 
> twl4030_codec_get_mclk() feels like it ought to take a parameter saying
> which twl4030, though the chances of having multiple twl4030s in one
> system are remote so it's not a real issue.

We have discussed this, but, yes the chances of having more than one twl in a 
system is unlikely.



-- 
Péter
