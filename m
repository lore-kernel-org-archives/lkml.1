Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYICEKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYICEKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYICEKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:10:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49600 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYICEKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:10:22 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="58944432"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
Date: Wed, 3 Sep 2008 12:09:49 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA02A26AC0@chinexm1.ad.analog.com>
In-Reply-To: <20080827134830.GC10834@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
Thread-Index: AckIS6Bu2fLm89TtQg+0wwk2enEVCwFJrA2Q
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-2-git-send-email-cooloney@kernel.org> <20080827134830.GC10834@sirena.org.uk>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Mark Brown" <broonie@sirena.org.uk>, "Bryan Wu" <cooloney@kernel.org>
Cc: <perex@perex.cz>, <lrg@kernel.org>, <alsa-devel@alsa-project.org>,
       <linux-kernel@vger.kernel.org>, "Cliff Cai" <cliff.cai@analog.com>
X-OriginalArrivalTime: 03 Sep 2008 04:10:18.0932 (UTC) FILETIME=[FA106740:01C90D7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Mark Brown [mailto:broonie@sirena.org.uk] 
Sent: Wednesday, August 27, 2008 9:49 PM
To: Bryan Wu
Cc: perex@perex.cz; lrg@kernel.org; alsa-devel@alsa-project.org;
linux-kernel@vger.kernel.org; Cliff Cai
Subject: Re: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework

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
> +	  the Blackfin SPORT (synchronous serial ports) interface in
slot 16 
> +	  mode (pseudo AC97 interface).
> +	  You will also need to select the audio interfaces to support
below.
> +
> +	  Note:
> +	  AC'97 codecs which do not implment the slot-16 mode will not
function
> +	  properly with this driver. This driver is known to work with
the
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
> +	size_t size = bf5xx_pcm_hardware.buffer_bytes_max *
sizeof(struct 
> +ac97_frame)/4;

Checkpatch picks up on this and quite a few other places being over 80
columns.

> +static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int

> +cmd) {
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct sport_device *sport = runtime->private_data;
> +	int ret = 0;
> +
> +	pr_debug("%s %s\n", substream->stream?"Capture":"Playback", \
> +			cmd?" start":" stop");

This looks wrong - there's rather more options for cmd, for example, and
you're making assumptions about the value of SNDRV_PMC_STREAM_PLAYBACK.

> +/*Need to allocate local buffer when enable MMAP for SPORT working in

> +TMD mode(include AC97).*/

Indentation?


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

>Shouldn't this undo the previous sport_confix_rx() on error?

>Also, the use of blank lines is a bit funny here - I'd expect the blank
before rather than after the function calls.
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

>Again, odd blank lines and presumably there needs to be something to
undo things on error?

t's not necessary to do anything else on error, these functions only set
registers.


> +	/*  TX and RX are not independent,they are enabled at the same
time,
> +	 *  even if only one side is running.So,we need to configure
both of them in advance.
> +	 *  CPU DAI format:I2S,word length:32 bit,slave mode.
> +	 */

>Are the RX and TX clocks independant?  If not you should probably tell
user space about the constraint in startup(), forcing the second stream
that's opened to use the 
>same configuration as the first - take a look at the fsl_ssi driver or
the wm8903 driver for examples of how to do this.

TX and RX Clocks are also not independent,currently,in order to
implement full duplex,we have to enable both RX and TX side even if
there is only a steam is opened,
And make the other side running on a dummy buffer,so all registers
cann't be configured any more. when the second stream is opened we just
switch the DMA form dummy buffer to the normal data buffer.

>I'm also not seeing the code that configures the sample rate anywhere -
but then it looks like the driver only support slave mode ATM?  That's
what the machine driver is
 >using.  There should still be a set_fmt() to document what's supported
if nothing else.

Yes ,the codec runs in master mode and provides bit clock..Do you mean
just implement a dummy set_fmt() with comments for CPU DAI,
Refer to my description above,it's not possible to configure anything
for CPU DAI after a stream is opened ,that why we have to configure CPU
DAI before any stream is opened.

Cliff   
