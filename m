Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZGVOyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZGVOyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZGVOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:54:11 -0400
Received: from d1.icnet.pl ([212.160.220.21]:34396 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZGVOyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:54:10 -0400
Message-ID: <4A6727D8.5080808@tis.icnet.pl>
Date: Wed, 22 Jul 2009 16:53:12 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad
 E3 (Delta) machine
References: <200907220523.01107.jkrzyszt@tis.icnet.pl> <20090722110328.GB7622@sirena.org.uk>
In-Reply-To: <20090722110328.GB7622@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Mark Brown wrote:
> On Wed, Jul 22, 2009 at 05:22:59AM +0200, Janusz Krzysztofik wrote:
> 
>> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>> ---
>> CPU DAI parameters best matching the codec DAI has been selected out
>> empirically for best user experience.
> 
> Again, all the documentation you've got here could quite happily go in
> the commit message and there's a bunch of checkpatch issues.

OK, I promiss to remember about this for the future.

>> +#include <sound/soc-dapm.h>
>> +#include <sound/jack.h>
> 
> ASoC will pull that one in for you, not that it really matters.

Maybe it should, but without <sound/jack.h> I get:
sound/soc/omap/ams-delta.c:184: error: 'SND_JACK_MICROPHONE' undeclared 
here (not in a function)
sound/soc/omap/ams-delta.c:188: error: 'SND_JACK_HEADPHONE' undeclared 
here (not in a function)
sound/soc/omap/ams-delta.c: In function 'cx81801_close':
sound/soc/omap/ams-delta.c:336: error: 'SND_JACK_HEADSET' undeclared 
(first use in this function)
...

>> +static const struct snd_kcontrol_new ams_delta_audio_controls[] = {
>> +	SOC_ENUM_EXT("Audio Function", ams_delta_audio_enum[0],
>> +			ams_delta_get_audio_mode, ams_delta_set_audio_mode),
>> +};
> 
> Is it possible to control all the functions of the audio mode
> independantly or are only certain combinations possible?

Certain combinations only. For example, no way of turning on the 
mouthpiece without turning on the earphone as well, turning on AGC 
automatically selects the speakerphone and turns off the handset.

>> +static struct snd_soc_jack_gpio ams_delta_hook_switch_gpios[];
>> +static struct snd_soc_jack_pin ams_delta_hook_switch_pins[] = {
>> +	{
>> +		.pin = "Mouthpiece",
>> +		.mask = SND_JACK_MICROPHONE,
>> +	},
>> +	{
>> +		.pin = "Earphone",
>> +		.mask = SND_JACK_HEADPHONE,
>> +	},
>> +	{
>> +		.pin = "Speaker",
>> +		.mask = SND_JACK_HEADPHONE,
>> +		.invert = 1,
>> +	},
>> +	{
>> +		.pin = "Microphone",
>> +		.mask = SND_JACK_MICROPHONE,
>> +		.invert = 1,
>> +	},
>> +};
> 
> I guess microphone and speaker are for speakerphone mode while
> mouthpiece and earpiece are a headset?  Might be nice to come up with

Exactly.

> names that make the paring a bit clearer, or possibly just put a comment
> in there.

With my limited English skills, I can only replace Earphone with 
Earpiece and add a comment. Please someone suggest better namings if not 
enough.

>> +/* To actually apply any modem controlled configuration changes to the codec,
>> + * we must connect codec DAI pins to the modem for a moment.  Be carefull
>> + * not to interfere with digital mute function that shares the same hardware. */
>> +static struct timer_list cx81801_timer;
>> +static bool cx81801_cmd_pending = 0;
>> +static bool ams_delta_muted;
>> +
>> +static void cx81801_timeout(unsigned long data)
>> +{
>> +	/* REVISIT - locking? */
> 
> Yeah, locking is probably a good idea :)

I'll have to learn about locking first. Could somebody point me to an 
example code?

>> +	/* Add board specific DAPM controls */
>> +	if (!snd_soc_dapm_new_controls(codec, ams_delta_dapm_widgets,
>> +				ARRAY_SIZE(ams_delta_dapm_widgets))) {
>> +		if (!snd_soc_dapm_add_routes(codec, ams_delta_audio_map,
>> +					ARRAY_SIZE(ams_delta_audio_map))) {
> 
> The error handling here is a bit odd...

Do you mean those negations? Would be better if replaced with "== 0"?
I am not sure if this is acceptable, but I just tried to avoid giving up 
with a partialy working driver in case of errors on optional parts.

>> +	/* Add hook switch */
>> +	if (!snd_soc_jack_new(&ams_delta_audio_card, "hook_switch",
>> +				SND_JACK_HEADSET, &ams_delta_hook_switch)) {
>> +		if (!snd_soc_jack_add_gpios(&ams_delta_hook_switch,
>> +					ARRAY_SIZE(ams_delta_hook_switch_gpios),
>> +					ams_delta_hook_switch_gpios)) {
>> +#ifdef CONFIG_GPIO_SYSFS
>> +			/* Expose hook switch over sysfs if configured */
>> +			gpio_export(ams_delta_hook_switch_gpios[0].gpio, false);
>> +#endif
> 
> The gpio_export() should be in the ASoC GPIO code rather than here, I'd
> expect - care to cook up a patch?

When I tried to push a similiar code into the gpio-keys dirver, Dmitry 
said I was wrong because my application would be limited to gpio based 
devices only. However, it looks like there are no jacks other than gpio 
based in ASoC, so maybe that objection does not apply here. Or maybe the 
ASoC framework could just provide its own sysfs file with actual jack 
state, whether gpio based or not?

BTW, I decided to reuse already existing jack/input event types instead 
of inventing new. Anyway, should I CC: linux-input?

Thanks,
Janusz

