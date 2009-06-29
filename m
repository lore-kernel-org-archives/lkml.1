Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZF2GjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZF2GjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZF2GjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:39:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59671 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZF2GjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:39:03 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer callback
Date: Mon, 29 Jun 2009 09:37:58 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.29-gentoo-r5; KDE/4.2.4; i686; ; )
Cc: Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl> <20090628223732.53954402.jhnikula@gmail.com> <200906290008.59640.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200906290008.59640.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906290937.58786.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 29 Jun 2009 06:38:02.0490 (UTC) FILETIME=[26AB45A0:01C9F884]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009 01:08:59 ext Janusz Krzysztofik wrote:
>
> AFAIK, both CSSA_L and CDSA_L DMA registers are static. Loaded by CPU with
> 16 LSB of initial source and destination port addresses respectively, they
> are never updated by the DMA engine itself. That's why they can't be used
> for transfer progress indication unless updated by CPU.
>
> The old omap-alsa driver was just updating them, intentionally or not, by
> reprogramming and restarting DMA every PCM period. That's why calculating
> PCM pointers from CSSA_L/CDSA_L worked.
>
> ASoC OMAP driver transfers whole PCM buffer with single DMA transfer, so it
> doesn't need to update DMA source/destination port address after initial
> playback/capture setup, even if restarting DMA, and actually never does
> this. Calculating PCM pointers from CSSA_L/CDSA_L registers without
> updating them every period would then be wrong.
>
> For capture, reading CPC, that follows destination port address progress,
> just works fine (for both old and new driver). For playback, similar
> hardware functionality seems to be missing, so it has to be emulated in
> software if required.

Hmmm, I had taken a look at the 2.4.21 kernel sources, which I have laying 
around in my disk from an old project which used OMAP1510. The OSS audio code 
does use the CPC register for determining the DMA progress both for playback 
and recording. I know that the audio was working OK on that board, since we 
had doom running there.
The difference that I can see is that the OSS code also configured the 
CCR:SYNC(4:0) bits as well.
Looking at the DMA_CPC register description in the OMAP1510 TRM: it list two 
cases on how it behaves and both require the DMA_CCR:SYNC != 0...

The current DMA code for OMAP1510 just plain ignores the DMA_CCR:SYNC for some 
reason.
Can you try the following patch:

iff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 7fc8c04..38874e4 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -266,6 +266,8 @@ void omap_set_dma_transfer_params(int lch, int data_type, 
int elem_count,
                ccr &= ~(1 << 5);
                if (sync_mode == OMAP_DMA_SYNC_FRAME)
                        ccr |= 1 << 5;
+               if (dma_trigger)
+                       ccr |= dma_trigger & 0x1f;
                dma_write(ccr, CCR(lch));

                ccr = dma_read(CCR2(lch));

Than can you print out in case of playback both the destination and source 
addresses supplied to the DMA, than in the pointer callback also print out the 
value returned by the omap_get_dma_src_pos function to see if this actually 
helps?

-- 
Péter
