Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZGVTS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZGVTS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZGVTS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:18:57 -0400
Received: from d1.icnet.pl ([212.160.220.21]:49206 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZGVTS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:18:56 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad E3 (Delta) machine
Date: Wed, 22 Jul 2009 21:18:05 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>
References: <200907220523.01107.jkrzyszt@tis.icnet.pl> <4A6727D8.5080808@tis.icnet.pl> <20090722150709.GB4987@rakim.wolfsonmicro.main>
In-Reply-To: <20090722150709.GB4987@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907222118.06396.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wednesday 22 July 2009 17:07:09 Mark Brown wrote:
> On Wed, Jul 22, 2009 at 04:53:12PM +0200, Janusz Krzysztofik wrote:
> > Mark Brown wrote:
> > >>+#include <sound/jack.h>
> > >
> > >ASoC will pull that one in for you, not that it really matters.
> >
> > Maybe it should, but without <sound/jack.h> I get:
> > sound/soc/omap/ams-delta.c:184: error: 'SND_JACK_MICROPHONE'
> > undeclared here (not in a function)
>
> Hrmpf, that's no use.  I'll add it - it'd be good if you could report
> stuff like this when you find it, you've got several workarounds for
> core code in here.

But first I would have to learn how to distinguish such upper layer misses 
from my own bugs ;). I'll try to do my best.

> > >Is it possible to control all the functions of the audio mode
> > >independantly or are only certain combinations possible?
> >
> > Certain combinations only. For example, no way of turning on the
> > mouthpiece without turning on the earphone as well, turning on AGC
> > automatically selects the speakerphone and turns off the handset.
>
> OK, then this mode selection is fine.

Actually I do not support two more possible I/O constellations: speaker only 
and microphone only. But I don't think anybody would find them really 
usefull. Even that Mixed configuration (Microphone+Earpiece) could be 
probably removed, I keep it only because it matches initail state, before the 
line discipline comes into action.

> > >>+static void cx81801_timeout(unsigned long data)
> > >>+{
> > >>+	/* REVISIT - locking? */
> > >
> > >Yeah, locking is probably a good idea :)
> >
> > I'll have to learn about locking first. Could somebody point me to
> > an example code?
>
> In what sense?  For an overview of the various APIs Linux Device Drivers
> is probably still good: http://lwn.net/Kernel/LDD3

Thanks, I've already started with reading. There are several options AFAICS, 
I'll try to select the most suitable one.
As the code that requires locking belongs to the line discipline, I'll wait a 
little more for possible commemts from Alan or other serial guys, if any, 
before I try to implement any locking.

> > >>+	/* Add board specific DAPM controls */
> > >>+	if (!snd_soc_dapm_new_controls(codec, ams_delta_dapm_widgets,
> > >>+				ARRAY_SIZE(ams_delta_dapm_widgets))) {
> > >>+		if (!snd_soc_dapm_add_routes(codec, ams_delta_audio_map,
> > >>+					ARRAY_SIZE(ams_delta_audio_map))) {
> > >
> > >The error handling here is a bit odd...
> >
> > Do you mean those negations? Would be better if replaced with "== 0"?
> > I am not sure if this is acceptable, but I just tried to avoid
> > giving up with a partialy working driver in case of errors on
> > optional parts.
>
> The negations, the nesting and the lack of any reporting of failures.
> Probably just calling all the functions one after another and logging
> any errors would be OK.

Thanks, will be rewriten this way.

> > >>+#ifdef CONFIG_GPIO_SYSFS
> > >>+			/* Expose hook switch over sysfs if configured */
> > >>+			gpio_export(ams_delta_hook_switch_gpios[0].gpio, false);
> > >>+#endif
> > >
> > >The gpio_export() should be in the ASoC GPIO code rather than here, I'd
> > >expect - care to cook up a patch?
> >
> > When I tried to push a similiar code into the gpio-keys dirver,
> > Dmitry said I was wrong because my application would be limited to
> > gpio based devices only. However, it looks like there are no jacks
>
> Userspace applications are a separate issue - it looked like this was
> just for diagnostic purposes?  Obviously any user space applications
> using the GPIO interface will be limited to your device but that applies
> no matter where you put this code.
>
> > other than gpio based in ASoC, so maybe that objection does not
> > apply here. Or maybe the ASoC framework could just provide its own
> > sysfs file with actual jack state, whether gpio based or not?
>
> There's at least a driver for the WM8350 headphone detection (possibly
> others, I'd need to grep) and an awful lot of hardware which could use
> this in-codec.  TLV320AIC3x has some code that ought to be moved over to
> the standard framework too.

Mark,
After all, I am not sure what your preferences finally are. If you still think 
that exporting gpio based jack state from ASoC framework over gpiolib sysfs 
doesn't hurt and can be usefull, I'll remove the code from my driver and 
provide a patch against sound/soc/soc-jack.c. But if you would rather prefere 
exposing jack state in a more general, not gpio limited way instead, or 
depend on input layer provided EVIOCGSW ioctl, as Dmitry suggested 
(unfortunatelly, unlike generic ldattach, there is no utility ready for 
use!), I'd rather keep this gpio_export() in my driver, let's say for 
diagnostic purposes, at least until that different option is ready for use in 
a convenient way.

Thanks,
Janusz
