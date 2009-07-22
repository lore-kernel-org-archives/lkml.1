Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZGVLDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZGVLDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZGVLDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:03:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46751 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZGVLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:03:33 -0400
Date: Wed, 22 Jul 2009 12:03:28 +0100
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
Message-ID: <20090722110328.GB7622@sirena.org.uk>
References: <200907220523.01107.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907220523.01107.jkrzyszt@tis.icnet.pl>
X-Cookie: One size fits all.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 05:22:59AM +0200, Janusz Krzysztofik wrote:

> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> CPU DAI parameters best matching the codec DAI has been selected out
> empirically for best user experience.

Again, all the documentation you've got here could quite happily go in
the commit message and there's a bunch of checkpatch issues.

> +#include <sound/soc-dapm.h>
> +#include <sound/jack.h>

ASoC will pull that one in for you, not that it really matters.

> +	/* Setup pins after corresponding bits if changed */
> +	if ((bool)snd_soc_dapm_get_pin_status(codec, "Speaker") !=
> +			(bool)(function & (1 << AMS_DELTA_SPEAKER))) {

Don't like these casts...  why are they needed?

> +static const struct snd_kcontrol_new ams_delta_audio_controls[] = {
> +	SOC_ENUM_EXT("Audio Function", ams_delta_audio_enum[0],
> +			ams_delta_get_audio_mode, ams_delta_set_audio_mode),
> +};

Is it possible to control all the functions of the audio mode
independantly or are only certain combinations possible?

> +static struct snd_soc_jack_gpio ams_delta_hook_switch_gpios[];
> +static struct snd_soc_jack_pin ams_delta_hook_switch_pins[] = {
> +	{
> +		.pin = "Mouthpiece",
> +		.mask = SND_JACK_MICROPHONE,
> +	},
> +	{
> +		.pin = "Earphone",
> +		.mask = SND_JACK_HEADPHONE,
> +	},
> +	{
> +		.pin = "Speaker",
> +		.mask = SND_JACK_HEADPHONE,
> +		.invert = 1,
> +	},
> +	{
> +		.pin = "Microphone",
> +		.mask = SND_JACK_MICROPHONE,
> +		.invert = 1,
> +	},
> +};

I guess microphone and speaker are for speakerphone mode while
mouthpiece and earpiece are a headset?  Might be nice to come up with
names that make the paring a bit clearer, or possibly just put a comment
in there.

> +/* To actually apply any modem controlled configuration changes to the codec,
> + * we must connect codec DAI pins to the modem for a moment.  Be carefull
> + * not to interfere with digital mute function that shares the same hardware. */
> +static struct timer_list cx81801_timer;
> +static bool cx81801_cmd_pending = 0;
> +static bool ams_delta_muted;
> +
> +static void cx81801_timeout(unsigned long data)
> +{
> +	/* REVISIT - locking? */

Yeah, locking is probably a good idea :)

> +		/* Set DAPM pins after hook switch present state */
> +#if 0
> +		/* Fails for switch state matching initial gpio->state = 0 */
> +		snd_soc_jack_report(&ams_delta_ams_delta_hook_switch, 
> +			gpio_get_value(ams_delta_hook_switch_gpios[0].gpio) ?
> +					0 : SND_JACK_HEADSET, SND_JACK_HEADSET);

Hrm.  We should just fix that so that adding a pin forces a sync rather
than just doing a report.  The GPIO jack wrapper ought to just do
everything you need without any code in the machine driver.

> +
> +	/* REVISIT - Don't know how to do that */
> +	/*
> +	 * Remove controls that we expose when over the modem control available:
> +	 * - virtual audio mode switch,
> +	 * - hook switch to DAPM pins links
> +	 */

You can't do that.  Rather than adding and removing the controls
dynamically I'd suggest hiding the controls from applications while
they're inactive - this will also avoid any renumbering which might
confuse them.  However, that API isn't in mainline yet.

Takashi, there is a patch adding a snd_ctl_activate_id() call in your
unstable tree which hasn't made it into mainline and should help here -
would there be any problem merging it?  I've got another use case for it
in ASoC that I'm hoping to find time to look at soon.

> +	/* Add board specific DAPM controls */
> +	if (!snd_soc_dapm_new_controls(codec, ams_delta_dapm_widgets,
> +				ARRAY_SIZE(ams_delta_dapm_widgets))) {
> +		if (!snd_soc_dapm_add_routes(codec, ams_delta_audio_map,
> +					ARRAY_SIZE(ams_delta_audio_map))) {

The error handling here is a bit odd...

> +	/* Add hook switch */
> +	if (!snd_soc_jack_new(&ams_delta_audio_card, "hook_switch",
> +				SND_JACK_HEADSET, &ams_delta_hook_switch)) {
> +		if (!snd_soc_jack_add_gpios(&ams_delta_hook_switch,
> +					ARRAY_SIZE(ams_delta_hook_switch_gpios),
> +					ams_delta_hook_switch_gpios)) {
> +#ifdef CONFIG_GPIO_SYSFS
> +			/* Expose hook switch over sysfs if configured */
> +			gpio_export(ams_delta_hook_switch_gpios[0].gpio, false);
> +#endif

The gpio_export() should be in the ASoC GPIO code rather than here, I'd
expect - care to cook up a patch?
