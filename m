Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYH0LYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYH0LYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYH0LYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:24:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4011 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYH0LYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:24:35 -0400
Date: Wed, 27 Aug 2008 11:54:58 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: perex@perex.cz, lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/4] ASOC codec: add support for SSM2602 audio codec in ALSA SoC framework
Message-ID: <20080827105456.GA10834@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, perex@perex.cz,
	lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219829968-6431-3-git-send-email-cooloney@kernel.org>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:39:26PM +0800, Bryan Wu wrote:

This looks basically good, thanks - I've picked up a few things below
but they are mostly either minor or reflect the fact that the patch
looks like it's been developed against current release kernels but
there's been some churn recently in the ASoC APIs which need updates.

>  #define I2C_DRIVERID_CS5345	96	/* cs5345 audio processor	*/
> +#define I2C_DRIVERID_SSM2602	97	/* BF52xC built in audio codec */

It should be possible to just remove this - it shouldn't be needed.

> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig

Current kernels have a Kconfig option SND_SOC_ALL_CODECS which should
have your codec added - this allows codec drivers to be built without
boards for test purposes.

> +#define SSM2602_DEBUG 0
> +
> +#ifdef SSM2602_DEBUG
> +#define dbg(format, arg...) \
> +	printk(KERN_DEBUG AUDIO_NAME ": " format "\n" , ## arg)
> +#else
> +#define dbg(format, arg...) do {} while (0)
> +#endif
> +#define err(format, arg...) \
> +	printk(KERN_ERR AUDIO_NAME ": " format "\n" , ## arg)
> +#define info(format, arg...) \
> +	printk(KERN_INFO AUDIO_NAME ": " format "\n" , ## arg)
> +#define warn(format, arg...) \
> +	printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)

Please convert these to use the standard pr_ macros (or ideally the dev_
ones where possible) for debug prints.

> +
> +#define ssm2602_reset(c)	ssm2602_write(c, SSM2602_RESET, 0)
> +/*Appending several "None"s just for OSS mixer use*/
> +static const char *ssm2602_input_select[] = {"Line", "Mic", "None", "None", "None",
> +		"None", "None", "None"};
> +static const char *ssm2602_deemph[] = {"None", "32Khz", "44.1Khz", "48Khz"};

Please keep the lines under 80 characters where reasonable.  A little
more while space (blank lines and at the start and end of comments)
would be nice too.

> +static const char *intercon[][3] = {

This should be converted to an array of struct snd_soc_dapm_route -
there's a new bulk registration API been added which saves everything
open coding all these and improves the error checking.

> +static int ssm2602_add_widgets(struct snd_soc_codec *codec)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ssm2602_dapm_widgets); i++)
> +		snd_soc_dapm_new_control(codec, &ssm2602_dapm_widgets[i]);

There's now a snd_soc_dapm_new_controls() for registering DAPM controls
en masse as well.

> +	/* set up audio path interconnects */
> +	for (i = 0; intercon[i][0] != NULL; i++) {
> +		snd_soc_dapm_connect_input(codec, intercon[i][0],
> +			intercon[i][1], intercon[i][2]);
> +	}

This can be replaced with snd_soc_dapm_add_routes().

> +static int ssm2602_mute(struct snd_soc_codec_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	u16 mute_reg = ssm2602_read_reg_cache(codec, SSM2602_APDIGI) & 0xfff7;
> +	if (mute)
> +		ssm2602_write(codec, SSM2602_APDIGI, mute_reg | ENABLE_DAC_MUTE);
> +	else
> +		ssm2602_write(codec, SSM2602_APDIGI, mute_reg);
> +	return 0;
> +}

More blank lines would be nice here and elsewhere but it's not critical.

> +static int ssm2602_dapm_event(struct snd_soc_codec *codec, int event)
> +{
> +	u16 reg = ssm2602_read_reg_cache(codec, SSM2602_PWR) & 0xff7f;
> +
> +	switch (event) {
> +	case SNDRV_CTL_POWER_D0: /* full On */

This won't compile with current kernels.  The dapm_event() interface has
been replaced by the very similar but hopefully clearer set_bias_level()
interface which use a different set of constants.

> +static int ssm2602_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
> +	struct snd_soc_codec *codec = socdev->codec;
> +
> +	ssm2602_write(codec, SSM2602_ACTIVE, 0);

That *should* be redundant - ALSA should stop the playback streams
before suspending - but equally well it shouldn't hurt.

> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE) && !defined(CONFIG_SND_SOC_SSM2602_SPI)

Hrm.  Why does the SPI support disable the I2C support?  I'd expect to
be able to build a kernel with the chip supported on both (for use on
multiple boards).

> +
> +/*
> + * ssm2602 2 wire address is determined by GPIO5
> + * state during powerup.
> + *    low  = 0x1a
> + *    high = 0x1b
> + */
> +static unsigned short normal_i2c[] = { 0, I2C_CLIENT_END };
> +
> +/* Magic definition of all other variables and things */
> +I2C_CLIENT_INSMOD;

Jean Delvare is currently in the process of convering all the ASoC codec
drivers to new style I2C drivers so we probably shouldn't add any more
old style I2C codec drivers.  The update is fairly straightforward - see
his patches yesterday for WM8731 and WM8750 for example conversions.

> +#elif defined(CONFIG_SPI_MASTER) && defined(CONFIG_SND_SOC_SSM2602_SPI)
> +	codec->hw_write = (hw_write_t)ssm2602_spi_write;
> +	ret = spi_register_driver(&ssm2602_spi_driver);
> +	if (ret != 0)
> +		printk(KERN_ERR "can't add spi driver");

You could add a flag in the device data to identify if the device is on
SPI here (that's what the check for i2c_address is intended for).
