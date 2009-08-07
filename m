Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZHGIPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZHGIPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZHGIPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:15:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56507 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbZHGIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:15:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1847dlb4eMcDwnYoEdJlD1h
Date: Fri, 7 Aug 2009 11:14:55 +0300
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-kernel@vger.kernel.org, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][2.6.31-rc5] ARM: OMAP: McBSP: Fix ASoC on OMAP1510 by
	fixing API of omap_mcbsp_start/stop
Message-ID: <20090807081207.GX2358@atomide.com>
References: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jarkko Nikula <jhnikula@gmail.com> [090807 09:59]:
> Simultaneous audio playback and capture on OMAP1510 can cause that second
> stream is stalled if there is enough delay between startup of the audio
> streams.
> 
> Current implementation of the omap_mcbsp_start is starting both transmitter
> and receiver at the same time and it is called only for firstly started
> audio stream from the OMAP McBSP based ASoC DAI driver.
> 
> Since DMA request lines on OMAP1510 are edge sensitive, the DMA request is
> missed if there is no DMA transfer set up at that time when the first word
> after McBSP startup is transmitted. The problem hasn't noted before since
> later OMAPs are using level sensitive DMA request lines.
> 
> Fix the problem by changing API of omap_mcbsp_start and omap_mcbsp_stop by
> allowing to start and stop individually McBSP transmitter and receiver
> logics. Then call those functions individually for both audio playback
> and capture streams. This ensures that DMA transfer is setup before
> transmitter or receiver is started.
> 
> Thanks to Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> for detailed problem
> analysis and Peter Ujfalusi <peter.ujfalusi@nokia.com> for info about DMA
> request line behavior differences between the OMAP generations.
> 
> Reported-and-tested-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Tony Lindgren <tony@atomide.com>

This seems OK to me queue via the alsa list as it's mostly audio related.

Acked-by: Tony Lindgren <tony@atomide.com>




> ---
>  arch/arm/plat-omap/include/mach/mcbsp.h |    4 +-
>  arch/arm/plat-omap/mcbsp.c              |   50 +++++++++++++++++++-----------
>  sound/soc/omap/omap-mcbsp.c             |   10 +++---
>  3 files changed, 39 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/mach/mcbsp.h b/arch/arm/plat-omap/include/mach/mcbsp.h
> index bb154ea..57249bb 100644
> --- a/arch/arm/plat-omap/include/mach/mcbsp.h
> +++ b/arch/arm/plat-omap/include/mach/mcbsp.h
> @@ -387,8 +387,8 @@ void omap_mcbsp_register_board_cfg(struct omap_mcbsp_platform_data *config,
>  void omap_mcbsp_config(unsigned int id, const struct omap_mcbsp_reg_cfg * config);
>  int omap_mcbsp_request(unsigned int id);
>  void omap_mcbsp_free(unsigned int id);
> -void omap_mcbsp_start(unsigned int id);
> -void omap_mcbsp_stop(unsigned int id);
> +void omap_mcbsp_start(unsigned int id, int tx, int rx);
> +void omap_mcbsp_stop(unsigned int id, int tx, int rx);
>  void omap_mcbsp_xmit_word(unsigned int id, u32 word);
>  u32 omap_mcbsp_recv_word(unsigned int id);
>  
> diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
> index efa0e01..a3d2313 100644
> --- a/arch/arm/plat-omap/mcbsp.c
> +++ b/arch/arm/plat-omap/mcbsp.c
> @@ -328,14 +328,15 @@ void omap_mcbsp_free(unsigned int id)
>  EXPORT_SYMBOL(omap_mcbsp_free);
>  
>  /*
> - * Here we start the McBSP, by enabling the sample
> - * generator, both transmitter and receivers,
> - * and the frame sync.
> + * Here we start the McBSP, by enabling transmitter, receiver or both.
> + * If no transmitter or receiver is active prior calling, then sample-rate
> + * generator and frame sync are started.
>   */
> -void omap_mcbsp_start(unsigned int id)
> +void omap_mcbsp_start(unsigned int id, int tx, int rx)
>  {
>  	struct omap_mcbsp *mcbsp;
>  	void __iomem *io_base;
> +	int idle;
>  	u16 w;
>  
>  	if (!omap_mcbsp_check_valid_id(id)) {
> @@ -348,32 +349,40 @@ void omap_mcbsp_start(unsigned int id)
>  	mcbsp->rx_word_length = (OMAP_MCBSP_READ(io_base, RCR1) >> 5) & 0x7;
>  	mcbsp->tx_word_length = (OMAP_MCBSP_READ(io_base, XCR1) >> 5) & 0x7;
>  
> -	/* Start the sample generator */
> -	w = OMAP_MCBSP_READ(io_base, SPCR2);
> -	OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 6));
> +	idle = !((OMAP_MCBSP_READ(io_base, SPCR2) |
> +		  OMAP_MCBSP_READ(io_base, SPCR1)) & 1);
> +
> +	if (idle) {
> +		/* Start the sample generator */
> +		w = OMAP_MCBSP_READ(io_base, SPCR2);
> +		OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 6));
> +	}
>  
>  	/* Enable transmitter and receiver */
>  	w = OMAP_MCBSP_READ(io_base, SPCR2);
> -	OMAP_MCBSP_WRITE(io_base, SPCR2, w | 1);
> +	OMAP_MCBSP_WRITE(io_base, SPCR2, w | (tx & 1));
>  
>  	w = OMAP_MCBSP_READ(io_base, SPCR1);
> -	OMAP_MCBSP_WRITE(io_base, SPCR1, w | 1);
> +	OMAP_MCBSP_WRITE(io_base, SPCR1, w | (rx & 1));
>  
>  	udelay(100);
>  
> -	/* Start frame sync */
> -	w = OMAP_MCBSP_READ(io_base, SPCR2);
> -	OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 7));
> +	if (idle) {
> +		/* Start frame sync */
> +		w = OMAP_MCBSP_READ(io_base, SPCR2);
> +		OMAP_MCBSP_WRITE(io_base, SPCR2, w | (1 << 7));
> +	}
>  
>  	/* Dump McBSP Regs */
>  	omap_mcbsp_dump_reg(id);
>  }
>  EXPORT_SYMBOL(omap_mcbsp_start);
>  
> -void omap_mcbsp_stop(unsigned int id)
> +void omap_mcbsp_stop(unsigned int id, int tx, int rx)
>  {
>  	struct omap_mcbsp *mcbsp;
>  	void __iomem *io_base;
> +	int idle;
>  	u16 w;
>  
>  	if (!omap_mcbsp_check_valid_id(id)) {
> @@ -386,15 +395,20 @@ void omap_mcbsp_stop(unsigned int id)
>  
>  	/* Reset transmitter */
>  	w = OMAP_MCBSP_READ(io_base, SPCR2);
> -	OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(1));
> +	OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(tx & 1));
>  
>  	/* Reset receiver */
>  	w = OMAP_MCBSP_READ(io_base, SPCR1);
> -	OMAP_MCBSP_WRITE(io_base, SPCR1, w & ~(1));
> +	OMAP_MCBSP_WRITE(io_base, SPCR1, w & ~(rx & 1));
>  
> -	/* Reset the sample rate generator */
> -	w = OMAP_MCBSP_READ(io_base, SPCR2);
> -	OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(1 << 6));
> +	idle = !((OMAP_MCBSP_READ(io_base, SPCR2) |
> +		  OMAP_MCBSP_READ(io_base, SPCR1)) & 1);
> +
> +	if (idle) {
> +		/* Reset the sample rate generator */
> +		w = OMAP_MCBSP_READ(io_base, SPCR2);
> +		OMAP_MCBSP_WRITE(io_base, SPCR2, w & ~(1 << 6));
> +	}
>  }
>  EXPORT_SYMBOL(omap_mcbsp_stop);
>  
> diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
> index a5d46a7..6a837ff 100644
> --- a/sound/soc/omap/omap-mcbsp.c
> +++ b/sound/soc/omap/omap-mcbsp.c
> @@ -183,21 +183,21 @@ static int omap_mcbsp_dai_trigger(struct snd_pcm_substream *substream, int cmd,
>  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
>  	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
>  	struct omap_mcbsp_data *mcbsp_data = to_mcbsp(cpu_dai->private_data);
> -	int err = 0;
> +	int err = 0, play = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK);
>  
>  	switch (cmd) {
>  	case SNDRV_PCM_TRIGGER_START:
>  	case SNDRV_PCM_TRIGGER_RESUME:
>  	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> -		if (!mcbsp_data->active++)
> -			omap_mcbsp_start(mcbsp_data->bus_id);
> +		mcbsp_data->active++;
> +		omap_mcbsp_start(mcbsp_data->bus_id, play, !play);
>  		break;
>  
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		if (!--mcbsp_data->active)
> -			omap_mcbsp_stop(mcbsp_data->bus_id);
> +		omap_mcbsp_stop(mcbsp_data->bus_id, play, !play);
> +		mcbsp_data->active--;
>  		break;
>  	default:
>  		err = -EINVAL;
> -- 
> 1.6.3.3
> 
