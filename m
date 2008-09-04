Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYIDKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYIDKcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYIDKcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:32:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1574 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYIDKcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:32:07 -0400
Date: Thu, 4 Sep 2008 11:32:02 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: khali@linux-fr.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 1/1] ASoC codec: SSM2602 audio codec driver (v2)
Message-ID: <20080904103201.GC13828@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, khali@linux-fr.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220511557-12140-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220511557-12140-1-git-send-email-cooloney@kernel.org>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 02:59:17PM +0800, Bryan Wu wrote:

Looks good - most of this is minor stuff here that shouldn't be an
obstacle to merging, but there does look to be an issue with DAPM
and the bias configuration.

> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -92,3 +92,6 @@ config SND_SOC_TLV320AIC26
>  config SND_SOC_TLV320AIC3X
>  	tristate
>  	depends on I2C
> +
> +config SND_SOC_SSM2602
> +	tristate

Please also add the codec to SND_SOC_ALL_CODECS.

> +#define ssm2602_reset(c)	ssm2602_write(c, SSM2602_RESET, 0)
> +/*Appending several "None"s just for OSS mixer use*/

Very minor but a blank line between these two would help.

> +	/* terminator */
> +	{NULL, NULL, NULL},

This terminator is not needed with the bulk registration API.

> +static inline int get_coeff(int mclk, int rate)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(coeff_div); i++) {
> +		if (coeff_div[i].rate == rate && coeff_div[i].mclk == mclk)
> +			return i;
> +	}
> +	return 0;
> +}

Zero is a valid return value but is also returned if no match is found.
Is this intended?

> +static void ssm2602_shutdown(struct snd_pcm_substream *substream)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_device *socdev = rtd->socdev;
> +	struct snd_soc_codec *codec = socdev->codec;
> +	/* deactivate */
> +	if (!codec->active) {
> +		udelay(50);
> +		ssm2602_write(codec, SSM2602_ACTIVE, 0);
> +	}

Hrm.  That udelay() looks suspicious - what's it there for?  There's no
previous activity in this function for it to leave an interval from.  If
it's delaying from some previous activity then might the udelay() break
if the time between that activity and this being called changes for some
reason.

> +static int ssm2602_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	u16 mute_reg = ssm2602_read_reg_cache(codec, SSM2602_APDIGI) & 0xfff7;
> +	if (mute)
> +		ssm2602_write(codec, SSM2602_APDIGI,
> +				mute_reg | ENABLE_DAC_MUTE);
> +	else
> +		ssm2602_write(codec, SSM2602_APDIGI, mute_reg);
> +	return 0;
> +}

Might be slightly clearer to use ~ENABLE_DAC_MUTE rather than 0xfff7.

> +static int ssm2602_set_bias_level(struct snd_soc_codec *codec,
> +				 enum snd_soc_bias_level level)
> +{
> +	u16 reg = ssm2602_read_reg_cache(codec, SSM2602_PWR) & 0xff7f;
> +
> +	switch (level) {
> +	case SND_SOC_BIAS_ON:
> +		/* vref/mid, osc on, dac unmute */
> +		ssm2602_write(codec, SSM2602_PWR, 0);
> +		break;

This looks like it's going to override DAPM - when the driver goes to
bias on this will overwrite the DAPM power configuration.  This will
mean that, for example, the ADC will be powered up during playback.  The
bias configuration should be leaving the power bits controlled by
DAPM as they are when changing bias levels.

> +/*Left ADC Volume Control (SSM2602_REG_LEFT_ADC_VOL)*/
> +#define     LIN_VOL                0x01F   /* Left Channel PGA Volume control                      */
> +#define     LIN_ENABLE_MUTE        0x080   /* Left Channel Input Mute                              */
> +#define     LRIN_BOTH              0x100   /* Left Channel Line Input Volume update                */

Sorry, didn't pick this up last time but the register bit defines in the
header may benefit from namespacing.  It's not such a big deal since
only machine drivers and this codec driver should be using this header
but it'd be nice.
