Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZF2HOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZF2HOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZF2HOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:14:30 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:47229 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZF2HO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=GoO7lAAe4MRCz+0EN+vu+lnWXFfG2lwZe5EYtcXoBiQ7xjuKffhN/D6lsFqvrA0ZvR
         XoBtJ1AoVpZKeN+NJobW30JuAtw0ImDVmymaQyzog8S9lSN70Ede7lPSZ9SKPinn9UxG
         RQynp304pmsH5jy2KVkkronIeOdEdISCp+g38=
Date: Mon, 29 Jun 2009 10:15:12 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: ext Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer
 callback
Message-Id: <20090629101512.38ebaaee.jhnikula@gmail.com>
In-Reply-To: <200906290937.58786.peter.ujfalusi@nokia.com>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl>
	<20090628223732.53954402.jhnikula@gmail.com>
	<200906290008.59640.jkrzyszt@tis.icnet.pl>
	<200906290937.58786.peter.ujfalusi@nokia.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 09:37:58 +0300
Peter Ujfalusi <peter.ujfalusi@nokia.com> wrote:

> Hmmm, I had taken a look at the 2.4.21 kernel sources, which I have
> laying around in my disk from an old project which used OMAP1510. The
> OSS audio code does use the CPC register for determining the DMA
> progress both for playback and recording. I know that the audio was
> working OK on that board, since we had doom running there.
> The difference that I can see is that the OSS code also configured
> the CCR:SYNC(4:0) bits as well.
> Looking at the DMA_CPC register description in the OMAP1510 TRM: it
> list two cases on how it behaves and both require the DMA_CCR:SYNC !=
> 0...
> 
> The current DMA code for OMAP1510 just plain ignores the DMA_CCR:SYNC
> for some reason.
> Can you try the following patch:
> 
> iff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index 7fc8c04..38874e4 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -266,6 +266,8 @@ void omap_set_dma_transfer_params(int lch, int
> data_type, int elem_count,
>                 ccr &= ~(1 << 5);
>                 if (sync_mode == OMAP_DMA_SYNC_FRAME)
>                         ccr |= 1 << 5;
> +               if (dma_trigger)
> +                       ccr |= dma_trigger & 0x1f;
>                 dma_write(ccr, CCR(lch));
> 
>                 ccr = dma_read(CCR2(lch));
> 
> Than can you print out in case of playback both the destination and
> source addresses supplied to the DMA, than in the pointer callback
> also print out the value returned by the omap_get_dma_src_pos
> function to see if this actually helps?
> 
Thanks for info Peter. So, Mark, put the workaround patch and my
acked-by on hold until this is also tried.


-- 
Jarkko
