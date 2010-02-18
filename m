Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0BRMZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:25:47 -0500
Received: from mail001.aei.ca ([206.123.6.130]:55517 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092Ab0BRMZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:25:45 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [LOCKDEP] 33-rc8 Running aplay with pulse as the default
Date: Thu, 18 Feb 2010 07:25:38 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc8-crc; KDE/4.4.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain> <201002170816.33209.edt@aei.ca> <s5heikkndf2.wl%tiwai@suse.de>
In-Reply-To: <s5heikkndf2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002180725.38635.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010 09:29:37 Takashi Iwai wrote:
> At Wed, 17 Feb 2010 08:16:32 -0500,
> Ed Tomlinson wrote:
> > 
> > On Tuesday 16 February 2010 08:37:46 Takashi Iwai wrote:
> > > > Thanks for the patch.  It helps in that it eliminates the opps but lockdep still triggers and aplay still fails.  
> > > > Here is the new traceback.
> > > 
> > > Hmm, fixing this isn't so trivial.  The same problem occurs on other
> > > subsystems like NFS over years.  And it's still there, AFAIK.
> > > The mmap mutex appears suddenly in the strange code path at close.
> > > 
> > > The patch below might fix, but I'm not 100% sure whether this has no
> > > side effect.
> > > 
> > > Anyway, I doubt very much it being a regression.  There is no change
> > > in ALSA core side, and also in V4L em28xx code.  Maybe the lockdep
> > > wasn't triggered by some reason.  And, this lockdep warning is almost
> > > harmless...
> > 
> > Takashi,
> > 
> > The second patch eliminating the lock causes oppes every time (one follows just in case
> > its helpful).
> 
> Are you sure?  The patch should causes a compile error, so you must have
> patched manually in a wrong place ;)

Yes I am sure.  I fixed the compile error the same way it is fixed below.

Ed
 
> Try the patch below (again untested, though).
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
> index bd78338..c51e623 100644
> --- a/drivers/media/video/em28xx/em28xx-audio.c
> +++ b/drivers/media/video/em28xx/em28xx-audio.c
> @@ -301,23 +301,12 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
>  	/* Sets volume, mute, etc */
>  
>  	dev->mute = 0;
> -	mutex_lock(&dev->lock);
>  	ret = em28xx_audio_analog_set(dev);
> -	mutex_unlock(&dev->lock);
>  	if (ret < 0)
>  		goto err;
>  
>  	runtime->hw = snd_em28xx_hw_capture;
> -	if (dev->alt == 0 && dev->adev.users == 0) {
> -		int errCode;
> -		dev->alt = 7;
> -		errCode = usb_set_interface(dev->udev, 0, 7);
> -		dprintk("changing alternate number to 7\n");
> -	}
> -
> -	mutex_lock(&dev->lock);
>  	dev->adev.users++;
> -	mutex_unlock(&dev->lock);
>  
>  	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
>  	dev->adev.capture_pcm_substream = substream;
> @@ -336,7 +325,6 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
>  	dprintk("closing device\n");
>  
>  	dev->mute = 1;
> -	mutex_lock(&dev->lock);
>  	dev->adev.users--;
>  	em28xx_audio_analog_set(dev);
>  	if (substream->runtime->dma_area) {
> @@ -344,7 +332,6 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
>  		vfree(substream->runtime->dma_area);
>  		substream->runtime->dma_area = NULL;
>  	}
> -	mutex_unlock(&dev->lock);
>  
>  	return 0;
>  }
> @@ -352,6 +339,7 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
>  static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
>  					struct snd_pcm_hw_params *hw_params)
>  {
> +	struct em28xx *dev = snd_pcm_substream_chip(substream);
>  	unsigned int channels, rate, format;
>  	int ret;
>  
> @@ -366,6 +354,14 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
>  	/* TODO: set up em28xx audio chip to deliver the correct audio format,
>  	   current default is 48000hz multiplexed => 96000hz mono
>  	   which shouldn't matter since analogue TV only supports mono */
> +
> +	if (dev->alt == 0 && dev->adev.users == 1) {
> +		int errCode;
> +		dev->alt = 7;
> +		errCode = usb_set_interface(dev->udev, 0, 7);
> +		dprintk("changing alternate number to 7\n");
> +	}
> +
>  	return 0;
>  }
>  
> 
> 
