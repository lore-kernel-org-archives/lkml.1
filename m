Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYH0NxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYH0NxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbYH0Nsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4121 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbYH0Nsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:35 -0400
Date: Wed, 27 Aug 2008 14:48:31 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: perex@perex.cz, lrg@kernel.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
Message-ID: <20080827134830.GC10834@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, perex@perex.cz,
	lrg@kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219829968-6431-2-git-send-email-cooloney@kernel.org>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:39:25PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

As with the other patches in the series this looks good but it has been
affected by changes in the ASoC APIs and needs to be updated to reflect
current ALSA.  The topic/asoc branch of Takashi's tree:

    git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

is what's currently queued for 2.6.28.

Other than that, checkpatch-style things and a few more minor issues the
main things are the register write interface in /proc and the hardware
parameters for the I2S driver.  I've not flagged all the checkpatch
stuff here.

Can I also suggest splitting this up into a series of patches for easier
review - for example, adding the SPORT support first, followed by the
AC97 and I2S drivers and then the machine drivers?  I'd certainly have
appreciated having seen the SPORT support (which appears at the end of
the patch) before looking at the AC97 and I2S stuff.

> +	depends on BLACKFIN && SND_SOC
> +	help
> +	  Say Y or M if you want to add support for codecs attached to
> +	  the Blackfin SPORT (synchronous serial ports) interface in slot 16 
> +	  mode (pseudo AC97 interface).
> +	  You will also need to select the audio interfaces to support below.
> +
> +	  Note:
> +	  AC'97 codecs which do not implment the slot-16 mode will not function
> +	  properly with this driver. This driver is known to work with the
> +	  Analog Devices line of AC97 codecs.

Your spelling of AC97 isn't consistent here.  The kernel seems to prefer
AC97, as do you.

> + * File:         sound/soc/blackfin/bf5xx-ac97-pcm.c
> + * Author:       Cliff Cai <Cliff.Cai@analog.com>
> + *
> + * Created:      Tue June 06 2008
> + * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC

Hopefully the driver is more generic than that?

> +static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
> +	struct snd_pcm_hw_params *params)
> +{
> +	size_t size = bf5xx_pcm_hardware.buffer_bytes_max * sizeof(struct ac97_frame)/4;

Checkpatch picks up on this and quite a few other places being over 80
columns.

> +static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct sport_device *sport = runtime->private_data;
> +	int ret = 0;
> +
> +	pr_debug("%s %s\n", substream->stream?"Capture":"Playback", \
> +			cmd?" start":" stop");

This looks wrong - there's rather more options for cmd, for example, and
you're making assumptions about the value of SNDRV_PMC_STREAM_PLAYBACK.

> +/*Need to allocate local buffer when enable MMAP for SPORT working in TMD mode(include AC97).*/

Indentation?

> diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.h b/sound/soc/blackfin/bf5xx-ac97-pcm.h
> new file mode 100644
> index 0000000..5831300
> --- /dev/null
> +++ b/sound/soc/blackfin/bf5xx-ac97-pcm.h

> +struct bf5xx_gpio {
> +	u32 sys;
> +	u32	rx;
> +	u32 tx;
> +	u32 clk;
> +	u32 frm;
> +};

That should be a space before rx, not a tab.

> diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
> new file mode 100644
> index 0000000..685a494
> --- /dev/null
> +++ b/sound/soc/blackfin/bf5xx-ac97.c

> +#include <sound/driver.h>

This header is obsolte and should be removed.

> +static unsigned short bf5xx_ac97_read(struct snd_ac97 *ac97,
> +	unsigned short reg)
> +{
> +	struct ac97_frame out_frame[2], in_frame[2];
> +
> +	pr_debug("%s enter 0x%x\n", __func__, reg);
> +
> +	/* When dma descriptor is enabled, the register should not be read */
> +	if (sport_handle->tx_run || sport_handle->rx_run) {
> +		printk(KERN_ERR "Could you send a mail to author "
> +				"to report this?\n");
> +		return -EFAULT;
> +	}

Might be nice to say what to report and who the author is - by itself
the printout is going to be rather obscure :)

> +static int bf5xx_ac97_resume(struct platform_device *pdev,
> +	struct snd_soc_cpu_dai *dai)

struct snd_soc_cpu_dai and struct snd_soc_codec_dai have been merged
into a single struct snd_soc_dai in current versions.

> +	ret = sport_config_rx(sport_handle, IRFS, 0xF, 0, (16*16-1));
> +
> +	if (ret) {
> +		printk(KERN_ERR "SPORT is busy!\n");
> +		return -EBUSY;
> +	}
> +	ret = sport_config_tx(sport_handle, ITFS, 0xF, 0, (16*16-1));
> +
> +	if (ret) {
> +		printk(KERN_ERR "SPORT is busy!\n");
> +		return -EBUSY;
> +	}

Shouldn't this undo the previous sport_confix_rx() on error?

Also, the use of blank lines is a bit funny here - I'd expect the blank
before rather than after the function calls.

> +static struct proc_dir_entry *ac_entry;
> +
> +/* For test purpose, read a register from codec */
> +static int proc_write(struct file *file, const char __user *buffer,
> +		unsigned long count, void *data)
> +{

I think it's probably better to drop this from mainline - it doesn't
seem like something that we should be supporting long term and obviously
it could do damage if used.

If you do want to put it in mainline then it ought to go in debugfs
rather than proc.

> +	/*SPORT works in TDM mode to simulate AC97 transfers*/
> +	ret = sport_set_multichannel(sport_handle, 16, 0x1F, 1);
> +
> +	if (ret) {
> +		printk(KERN_ERR "SPORT is busy!\n");
> +		return -EBUSY;
> +	}
> +	ret = sport_config_rx(sport_handle, IRFS, 0xF, 0, (16*16-1));
> +
> +	if (ret) {
> +		printk(KERN_ERR "SPORT is busy!\n");
> +		return -EBUSY;
> +	}

Again, odd blank lines and presumably there needs to be something to
undo things on error?

> + * File:         sound/soc/blackfin/bf5xx-ad1980.c
> + * Author:       Cliff Cai <Cliff.Cai@analog.com>
> + *
> + * Created:      Tue June 06 2008
o> + * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC

This comment is wrong - it's for the AD1980.

> +static int bf5xx_board_startup(struct snd_pcm_substream *substream)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct snd_soc_cpu_dai *cpu_dai = rtd->dai->cpu_dai;
> +
> +	pr_debug("%s enter\n", __func__);
> +	cpu_dai->private_data = sport_handle;
> +	return 0;
> +}

> --- /dev/null
> +++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
> @@ -0,0 +1,293 @@
> +/*
> + * File:         sound/soc/blackfin/bf5xx-i2s-pcm.c
> + * Author:       Cliff Cai <Cliff.Cai@analog.com>
> + *
> + * Created:      Tue June 06 2008
> + * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC

This comment is wrong too :)

> +#include <sound/driver.h>

Obsolete.

> +	pr_debug("%s %s\n", substream->stream?"Capture":"Playback", \
> +			cmd?" start":" stop");

Same comment as for AC97.  Shouldn't more of this code be shared with
the AC97 DMA driver?

> +static int bf5xx_pcm_close(struct snd_pcm_substream *substream)
> +{
> +	pr_debug("%s enter\n", __func__);
> +	/*Nothing need to be cleared here*/
> +
> +	return 0;
> +}

You should just be able to remove this if it's empty.

> +#include <sound/driver.h>

Obsolete.

> +	/*  TX and RX are not independent,they are enabled at the same time,
> +	 *  even if only one side is running.So,we need to configure both of them in advance.
> +	 *  CPU DAI format:I2S,word length:32 bit,slave mode.
> +	 */

Are the RX and TX clocks independant?  If not you should probably tell
user space about the constraint in startup(), forcing the second stream
that's opened to use the same configuration as the first - take a look
at the fsl_ssi driver or the wm8903 driver for examples of how to do
this.

I'm also not seeing the code that configures the sample rate anywhere -
but then it looks like the driver only support slave mode ATM?  That's
what the machine driver is using.  There should still be a set_fmt() to
document what's supported if nothing else.

> +void decfrag(struct sport_device *sport, int *frag, int tx)
> +{
> +	--(*frag);
> +	if (tx == 1 && *frag == 0)
> +		*frag = sport->tx_frags;
> +
> +	if (tx == 0 && *frag == 0)
> +		*frag = sport->rx_frags;
> +}
> +EXPORT_SYMBOL(decfrag);

This symbol should be namespaced.

> diff --git a/sound/soc/blackfin/bf5xx-ssm2602.c b/sound/soc/blackfin/bf5xx-ssm2602.c
> new file mode 100644
> index 0000000..41e161f
> --- /dev/null
> +++ b/sound/soc/blackfin/bf5xx-ssm2602.c

This driver needs to follow the ssm2602 codec driver so either the
series needs reordering or at least this bit needs to be split out into
another patch.

> +#include <sound/driver.h>

Obsolete.

> +	 * WARNING - TODO
> +	 *
> +	 * This code assumes there is a variable clocksource for the SSM2602.
> +	 * i.e. it supplies MCLK depending on rate.
> +	 *
> +	 * If you are using a crystal source then modify the below case
> +	 * statement with a static frequency.
> +	 *
> +	 * If you are using the SPORT to generate clocking then this is
> +	 * where to do it.
> +	 */
> +
> +	switch (params_rate(params)) {
> +	case 8000:
> +	case 16000:
> +	case 48000:
> +	case 96000:
> +	case 11025:
> +	case 22050:
> +	case 44100:
> +		clk = 12000000;
> +		break;
> +	}

I'm not sure that comment quite agrees with the code here...
