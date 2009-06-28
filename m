Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZF1WKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZF1WKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZF1WKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:10:08 -0400
Received: from d1.icnet.pl ([212.160.220.21]:58803 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZF1WKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:10:07 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer callback
Date: Mon, 29 Jun 2009 00:08:59 +0200
User-Agent: KMail/1.9.10
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <200906280021.05931.jkrzyszt@tis.icnet.pl> <20090628223732.53954402.jhnikula@gmail.com>
In-Reply-To: <20090628223732.53954402.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906290008.59640.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 21:37:32 Jarkko Nikula wrote:
> On Sun, 28 Jun 2009 00:21:05 +0200
> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:
> > This patch tries to work around the problem of broken OMAP1510 PCM
> > playback pointer calculation by replacing DMA function call that
> > incorrectly tries to read the value form DMA hardware with a value
> > computed locally from an already maintained variable
> > omap_runtime_data.period_index.
> >
> > Tested on OMAP5910 based Amstrad Delta (E3) using work in progress
> > ASoC driver.
> >
> > Based on linux-2.6-asoc.git v2.6.31-rc1.
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> > It seems that on OMAP1510, DMA Channel Progress Counter registers
> > (DMA_CPC_CH[0-8]) always contain values derived from DMA channels
> > destination port address, even if constant, and there are no DMA
> > registers available that would follow DMA channels source port
> > address. Because of this limitation, current implementation of
> > omap_get_dma_src_pos() for OMAP1510 is broken and doesn't seem to be
> > easy correctable.
>
> Hi
>
> Before going into workaround, did you try to change function
> omap_get_dma_src_pos to read CSSA_L instead of CPC in
> arch/arm/plat-omap/dma.c that I was speculating in mail below?
>
> http://mailman.alsa-project.org/pipermail/alsa-devel/2009-June/018569.html
>
> While CPC seems to be correct [1], you mentioned before that patch below
> broke the older ALSA driver so it's worth to find out if the problem
> can be corrected by simple one line fix (or two if omap_get_dma_dst_pos
> need to be fixed as well).
>
> http://marc.info/?l=linux-omap&m=121280267705523

Jarkko,

AFAIK, both CSSA_L and CDSA_L DMA registers are static. Loaded by CPU with 16 
LSB of initial source and destination port addresses respectively, they are 
never updated by the DMA engine itself. That's why they can't be used for 
transfer progress indication unless updated by CPU.

The old omap-alsa driver was just updating them, intentionally or not, by 
reprogramming and restarting DMA every PCM period. That's why calculating PCM 
pointers from CSSA_L/CDSA_L worked.

ASoC OMAP driver transfers whole PCM buffer with single DMA transfer, so it 
doesn't need to update DMA source/destination port address after initial 
playback/capture setup, even if restarting DMA, and actually never does this. 
Calculating PCM pointers from CSSA_L/CDSA_L registers without updating them 
every period would then be wrong.

For capture, reading CPC, that follows destination port address progress, just 
works fine (for both old and new driver). For playback, similar hardware 
functionality seems to be missing, so it has to be emulated in software if 
required.

Thanks,
Janusz
