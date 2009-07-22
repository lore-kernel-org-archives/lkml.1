Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbZGVPHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbZGVPHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGVPHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:07:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33001 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751265AbZGVPHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:07:11 -0400
Date: Wed, 22 Jul 2009 16:07:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad
 E3 (Delta) machine
Message-ID: <20090722150709.GB4987@rakim.wolfsonmicro.main>
References: <200907220523.01107.jkrzyszt@tis.icnet.pl>
 <20090722110328.GB7622@sirena.org.uk>
 <4A6727D8.5080808@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6727D8.5080808@tis.icnet.pl>
X-Cookie: IOT trap -- core dumped
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 04:53:12PM +0200, Janusz Krzysztofik wrote:
> Mark Brown wrote:

> >>+#include <sound/jack.h>

> >ASoC will pull that one in for you, not that it really matters.

> Maybe it should, but without <sound/jack.h> I get:
> sound/soc/omap/ams-delta.c:184: error: 'SND_JACK_MICROPHONE'
> undeclared here (not in a function)

Hrmpf, that's no use.  I'll add it - it'd be good if you could report
stuff like this when you find it, you've got several workarounds for
core code in here.

> >Is it possible to control all the functions of the audio mode
> >independantly or are only certain combinations possible?

> Certain combinations only. For example, no way of turning on the
> mouthpiece without turning on the earphone as well, turning on AGC
> automatically selects the speakerphone and turns off the handset.

OK, then this mode selection is fine.

> >names that make the paring a bit clearer, or possibly just put a comment
> >in there.

> With my limited English skills, I can only replace Earphone with
> Earpiece and add a comment. Please someone suggest better namings if
> not enough.

Prefixes of "Headset" on the ones that apply to that?  Or the comment,
this is only really visible internally.

> >>+static void cx81801_timeout(unsigned long data)
> >>+{
> >>+	/* REVISIT - locking? */

> >Yeah, locking is probably a good idea :)

> I'll have to learn about locking first. Could somebody point me to
> an example code?

In what sense?  For an overview of the various APIs Linux Device Drivers
is probably still good: http://lwn.net/Kernel/LDD3

> >>+	/* Add board specific DAPM controls */
> >>+	if (!snd_soc_dapm_new_controls(codec, ams_delta_dapm_widgets,
> >>+				ARRAY_SIZE(ams_delta_dapm_widgets))) {
> >>+		if (!snd_soc_dapm_add_routes(codec, ams_delta_audio_map,
> >>+					ARRAY_SIZE(ams_delta_audio_map))) {

> >The error handling here is a bit odd...

> Do you mean those negations? Would be better if replaced with "== 0"?
> I am not sure if this is acceptable, but I just tried to avoid
> giving up with a partialy working driver in case of errors on
> optional parts.

The negations, the nesting and the lack of any reporting of failures.
Probably just calling all the functions one after another and logging
any errors would be OK.

> >>+#ifdef CONFIG_GPIO_SYSFS
> >>+			/* Expose hook switch over sysfs if configured */
> >>+			gpio_export(ams_delta_hook_switch_gpios[0].gpio, false);
> >>+#endif

> >The gpio_export() should be in the ASoC GPIO code rather than here, I'd
> >expect - care to cook up a patch?

> When I tried to push a similiar code into the gpio-keys dirver,
> Dmitry said I was wrong because my application would be limited to
> gpio based devices only. However, it looks like there are no jacks

Userspace applications are a separate issue - it looked like this was
just for diagnostic purposes?  Obviously any user space applications
using the GPIO interface will be limited to your device but that applies
no matter where you put this code.

> other than gpio based in ASoC, so maybe that objection does not
> apply here. Or maybe the ASoC framework could just provide its own
> sysfs file with actual jack state, whether gpio based or not?

There's at least a driver for the WM8350 headphone detection (possibly
others, I'd need to grep) and an awful lot of hardware which could use
this in-codec.  TLV320AIC3x has some code that ought to be moved over to
the standard framework too.

> BTW, I decided to reuse already existing jack/input event types
> instead of inventing new. Anyway, should I CC: linux-input?

No need if you're not changing it.
