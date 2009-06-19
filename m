Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZFSKrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZFSKrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 06:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZFSKrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 06:47:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44430 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZFSKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 06:47:44 -0400
Date: Fri, 19 Jun 2009 11:47:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Barry Song <21cnbao@gmail.com>
Cc: lrg@slimlogic.co.uk, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Message-ID: <20090619104738.GF5270@sirena.org.uk>
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] New ASoC Drivers for ADI AD1938 codec
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 05:28:15PM +0800, Barry Song wrote:
> 1. add AD1938 codec driver                   (codec)
> 2. add blackfin SPORT-TDM DAI and PCM driver (platform)
> 3. add bf5xx board with AD1938 driver        (machine)

As Liam said you really need to submit this as a patch series rather
than as a single big patch - as your commit log here indicates you've
got several different things going on here.

> +++ b/include/sound/soc-dai.h
> @@ -30,6 +30,7 @@ struct snd_pcm_substream;
>  #define SND_SOC_DAIFMT_DSP_A		3 /* L data msb after FRM LRC */
>  #define SND_SOC_DAIFMT_DSP_B		4 /* L data msb during FRM LRC */
>  #define SND_SOC_DAIFMT_AC97		5 /* AC97 */
> +#define SND_SOC_DAIFMT_SPORT_TDM	6 /* SPORT TDM for ADI parts */

If you're going to add a new DAI format that really needs more
explanation than this explaining what the DAI format is.  It'd be very
surprising to see hardware needing a new format.

Looking at the datasheet for the ad1938 it appears that the actual
format here is just normal I2S with TDM.  This does not need a new DAI
format or new CPU DAI, you just need to add suport for TDM to the
Blackfin I2S driver.  The format is fairly standard and implemented by a
number of other devices.

See set_tdm_slot() for setting up the higher channel counts - there's
some ongoing revisions to that API so you'll want to also ensure that
the code is set up so that it can cope with specification of the sample
width for each slot in set_tdm_slot().

Given this I've only looked at the CODEC driver below.

> diff --git a/sound/soc/codecs/ad1938.c b/sound/soc/codecs/ad1938.c
> new file mode 100644
> index 0000000..9aa78e1
> --- /dev/null
> +++ b/sound/soc/codecs/ad1938.c

> + *
> + *  Revision history
> + *    4 June 2009   Initial version.

Don't include this, git provides code history for us.

> +struct snd_soc_device *ad1938_socdev;
> +
> +/* dac de-emphasis enum control */
> +static const char *ad1938_deemp[] = {"flat", "48kHz", "44.1kHz", "32kHz"};

For consistency with other drivers "flat" should be "None".

> +/* AD1938 volume/mute/de-emphasis etc. controls */
> +static const struct snd_kcontrol_new ad1938_snd_controls[] = {
> +	/* DAC volume control */
> +	SOC_SINGLE("DAC L1 Volume", AD1938_DAC_L1_VOL, 0, 0xFF, 1),
> +	SOC_SINGLE("DAC R1 Volume", AD1938_DAC_R1_VOL, 0, 0xFF, 1),

These (and the other stereo pairs below) should be SOC_DOUBLE_R().  This
allows ALSA to represent them as stereo controls to applications rather
than as two separate controls.  You should also provide TLV information
so actually SOC_DOUBLE_R_TLV() if possible.

> +	/* DAC mute control */
> +	SOC_SINGLE("DAC L1 Switch", AD1938_DAC_CHNL_MUTE, 0, 1, 1),
> +	SOC_SINGLE("DAC R1 Switch", AD1938_DAC_CHNL_MUTE, 1, 1, 1),

These should be stereo controls too - SOC_DOUBLE() since they're in the
same register.

> +	/* ADC mute control */
> +	SOC_SINGLE("ADC L1 Switch", AD1938_ADC_CTRL0, ADC0_MUTE, 1, 1),
> +	SOC_SINGLE("ADC R1 Switch", AD1938_ADC_CTRL0, ADC1_MUTE, 1, 1),

These too.

> +	/* DAC de-emphasis */
> +	SOC_ENUM("Playback Deemphasis", ad1938_enum[0]),

Don't put your enums in an array, use named variables for them.  This
makes drivers easier to maintian when you get a lot of enums.

> +static int ad1938_add_controls(struct snd_soc_codec *codec)
> +{
> +	int err, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ad1938_snd_controls); i++) {
> +		err = snd_ctl_add(codec->card,
> +				snd_soc_cnew(&ad1938_snd_controls[i], codec, NULL));

Use snd_soc_add_controls() here - you can replace the entire function
with a call to that.

> +/* dac/adc/pll poweron/off functions */
> +static int ad1938_dac_powerctrl(struct snd_soc_codec *codec, int cmd)
> +{
> +	int reg;
> +
> +	reg = codec->read(codec, AD1938_DAC_CTRL0);
> +	if (cmd)
> +		reg &= ~DAC_POWERDOWN;
> +	else
> +		reg |= DAC_POWERDOWN;
> +	codec->write(codec, AD1938_DAC_CTRL0, reg);

This should be handled by DAPM - either have a single DAC widget
representing all the channels (since you don't appear to have
independant control anyway) or have a bunch of dummy DAC widgets and a
supply widget representing the actual power control.  The same thing
applies to the ADCs.

> +static int ad1938_set_pll(struct snd_soc_dai *codec_dai,
> +		int pll_id, unsigned int freq_in, unsigned int freq_out)
> +{
> +	struct snd_soc_codec *codec = codec_dai->codec;
> +
> +	if (freq_out)
> +		ad1938_pll_powerctrl(codec, 1);
> +	else {
> +		/* playing while recording, framework will poweroff-poweron pll redundantly */
> +		if ((!codec_dai->capture.active) && (!codec_dai->playback.active))
> +			ad1938_pll_powerctrl(codec, 0);
> +	}

Hrm.  This appears to completely ignore the frequencies supplied for the
PLL and just provide power control.  I suspect that you can just handle
the PLL as a SND_SOC_DAPM_SUPPLY(), there seems to be no need to expose
the set_pll() operation and make machine drivers call it given that
there isn't any frequency configuration going on.

> +static int ad1938_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	if (!mute)
> +		codec->write(codec, AD1938_DAC_CHNL_MUTE, 0);
> +	else
> +		codec->write(codec, AD1938_DAC_CHNL_MUTE, 0xff);
> +
> +	return 0;
> +}

This isn't going to play well with the explicit mute controls you've got
above - it's writing to the same register bits without any coordination.
One or the other set of controls ought to be removed.

> +static int ad1938_tdm_set(struct snd_soc_codec *codec)
> +{
> +	codec->write(codec, AD1938_DAC_CTRL0, (codec->read(codec, AD1938_DAC_CTRL0) &
> +				(~DAC_SERFMT_MASK)) | DAC_SERFMT_TDM);
> +	codec->write(codec, AD1938_DAC_CTRL1, 0x84); /* invert bclk, 256bclk/frame, latch in mid */
> +	codec->write(codec, AD1938_ADC_CTRL1, 0x43); /* sata delay=1, adc aux mode */
> +	codec->write(codec, AD1938_ADC_CTRL2, 0x6F); /* left high, driver on rising edge */
> +
> +	return 0;
> +}

If you use set_tdm_slot() then the BCLK/frame ratio will be set by that.

Inversion of BCLK (and any other clocks) should be handled by the
set_dai_fmt() operation based on the machine driver request rather than
done unconditionally.

> +	/* bit size */
> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S16_LE:
> +		word_len = 3;
> +		break;

Once you implement set_tdm_slot() you should allow the word length to be
configured there if it's called or otherwise keep this code here - see
Daniel Ribeiro's patche "change set_tdm_slot api to allow slot_width
override" posted to the ALSA list this week.

> +static int __devinit ad1938_spi_probe(struct spi_device *spi)
> +{
> +	spi->dev.power.power_state = PMSG_ON;
> +	ad1938_socdev->card->codec->control_data = spi;
> +
> +	return 0;
> +}
> +
> +static int __devexit ad1938_spi_remove(struct spi_device *spi)
> +{
> +	return 0;
> +}

Your device probing should all be restructured so that the SPI device
for the CODEC is registered as any other SPI device rather than being
set up as part of probing the ASoC device.  See the wm8731 driver for
an example of doing this for a SPI device.

This will require that the arch code for any systems with the ad1938
do the setup of the device.

> +	.name = "AD1938",
> +	.playback = {
> +		.stream_name = "Playback",
> +		.channels_min = 2,
> +		.channels_max = 8,
> +		.rates = SNDRV_PCM_RATE_48000,
> +		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE, },

Please keep your lines to under 80 columns.

> +#define AD1938_PLL_CLK_CTRL0    0
> +#define PLL_POWERDOWN           0x01
> +#define AD1938_PLL_CLK_CTRL1    1
> +#define AD1938_DAC_CTRL0        2
> +#define DAC_POWERDOWN           0x01
> +#define DAC_SERFMT_MASK		0xC0
> +#define DAC_SERFMT_STEREO	(0 << 6)
> +#define DAC_SERFMT_TDM		(1 << 6)

These defines need namespacing if they're going to appear in the headers
- everything should have the AD1938_ prefix.
