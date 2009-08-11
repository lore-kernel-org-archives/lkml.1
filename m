Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZHKL5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZHKL5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZHKL5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:57:42 -0400
Received: from d1.icnet.pl ([212.160.220.21]:56664 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZHKL5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:57:39 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [RFC][PATCH 3/3 v2] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter
Date: Tue, 11 Aug 2009 11:30:20 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl> <200908110107.11485.jkrzyszt@tis.icnet.pl> <20090811094248.3b869f09.jhnikula@gmail.com>
In-Reply-To: <20090811094248.3b869f09.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908111130.21935.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarkko,

Tuesday 11 August 2009 08:42:48 Jarkko Nikula wrote:
> On Tue, 11 Aug 2009 01:07:10 +0200
> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:
> > Enhance period index accuracy, particularly just before buffer rewind, by
> > making use of DMA interrupt status flags in addition to simply counting
> > up interrupts.
> >
> > Corrections since v1:
> > 1. Fix buggy DMA interrupt handling in case of multiple status flags set
> > in parallel.
> > 2. Enable OMAP_DMA_LAST_IRQ only for playback on OMAP1510.
> >
> > -	}
> > +	} else if (stat == OMAP_DMA_LAST_IRQ)
> > +		return;
>
> Is this test needed? This interrupt is set only for playback on
> omap1510 so this looks null-op.

You're right, I have put it here before limiting the flag request to playback 
on OMAP1510 only. So it can be omitted, but only if we assume we are always 
called exactly as requested. It is not needed unless the flag is ever 
requested (by mistake?) by other arch/arm/plat-omap/dma.c bits and passed on 
by omap1_dma_handle_ch() that passes all flags without checking if requested. 
But then, shouldn't we start from always checking for OMAP_DMA_FRAME_IRQ set?

> > -	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
> > +	if ((cpu_is_omap1510()) &&
> > +			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK))
> > +		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
> > +							OMAP_DMA_LAST_IRQ);
>
> Indent OMAP_DMA_LAST_IRQ with tab(s) and spaces to the same column
> than OMAP_DMA_FRAME_IRQ. Looks nicer then.

OK, will fix it.

> Should the 
> OMAP_DMA_BLOCK_IRQ to be set since it is handled in omap_pcm_dma_irq?

This one is already requested from inside omap_request_dma() and used inside 
omap1_dma_handle_ch() in addition to passing it to us.

Cheers,
Janusz
