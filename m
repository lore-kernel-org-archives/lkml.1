Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZF2Nv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZF2Nv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZF2Nvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:51:50 -0400
Received: from d1.icnet.pl ([212.160.220.21]:49559 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZF2Nvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:51:48 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer callback
Date: Mon, 29 Jun 2009 15:51:07 +0200
User-Agent: KMail/1.9.10
Cc: Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl> <200906290008.59640.jkrzyszt@tis.icnet.pl> <200906290937.58786.peter.ujfalusi@nokia.com>
In-Reply-To: <200906290937.58786.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906291551.08437.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009 08:37:58 Peter Ujfalusi wrote:
> On Monday 29 June 2009 01:08:59 ext Janusz Krzysztofik wrote:
> > For capture, reading CPC, that follows destination port address progress,
> > just works fine (for both old and new driver). For playback, similar
> > hardware functionality seems to be missing, so it has to be emulated in
> > software if required.
>
> Hmmm, I had taken a look at the 2.4.21 kernel sources, which I have laying
> around in my disk from an old project which used OMAP1510. The OSS audio
> code does use the CPC register for determining the DMA progress both for
> playback and recording. I know that the audio was working OK on that board,
> since we had doom running there.

I am not able to find any information on how DMA can be configured for CPC to 
reflect either source or destination port address progress. Official 
documentation, even if not very clear for me, seems to suggest that it always 
follows destination port address, even if constatnt (ie 
DMA_CCR:DST_AMODE(15:14) == 0).

> The difference that I can see is that the OSS code also configured the
> CCR:SYNC(4:0) bits as well.
> Looking at the DMA_CPC register description in the OMAP1510 TRM: it list
> two cases on how it behaves and both require the DMA_CCR:SYNC != 0...

Not exactly. According to my copy of 
http://focus.ti.com/lit/ug/spru674/spru674.pdf, the secnod case is:

	If the channel transfer is synchronized on frames
	(DMA_CCR SYNC ≠ 0 and DMA_CCR FS = 1) or not
	synchronized (DMA_CCR SYNC = 0), the register is
	updated with 16 LSB of the address each time the
	destination port issues the last request for a frame.

Anyway, that seems to be irrelevant in our case.

> The current DMA code for OMAP1510 just plain ignores the DMA_CCR:SYNC for
> some reason.

Not exactly. Even if not touched inside any of omap_set_dma_transfer_params(), 
omap_set_dma_src_params() nor omap_set_dma_dest_params(), these bits are 
already set by arch/arm/plat-omap/dma.c:omap_request_dma(int dev_id, ...):

 765         } else if (cpu_is_omap7xx() || cpu_is_omap15xx()) {
 766                 dma_write(dev_id, CCR(free_ch));
 
> Can you try the following patch:

Sure. I remember we already talk about this before. That time, I had only 
verified that the change you proposed did not help in solving a different 
problem I used to have before. Then I found the above explanation, but never 
got an idea to let you know.

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

BTW, here the code tries to read (and than write) an address (CCR2) that is 
not supported on OMAP1510. I have not noticed any side effects, neither 
negative nor positive, but can provide a patch if OMAP guys ever find 
patching this as desired.

> Than can you print out in case of playback both the destination and source
> addresses supplied to the DMA, than in the pointer callback also print out
> the value returned by the omap_get_dma_src_pos function to see if this
> actually helps?

Here you are. Same figures wheather with or without your patch. I also printed 
a value that CCR is written with, so you can verify those SYNC(4:0) bits are 
set correctly.

root@amsdelta:~# aplay -f S16_LE -t raw -d 1 </dev/urandom
Playing raw data 'stdin' : Signed 16 bit Little Endian, Rate 8000 Hz, Mono
[  116.780000] omap_pcm_prepare(): dma_params.src_start = 0x11d80000
[  116.780000] omap_pcm_prepare(): dma_params.dst_start = 0xe1011806
[  116.790000] omap_set_dma_src_params(): dma_write(0x11d8, CSSA_U(0x0)
[  116.800000] omap_set_dma_src_params(): dma_write(0x0000, CSSA_L(0x0)
[  116.810000] omap_set_dma_dest_params(): dma_write(0x1008, CCR(0x0))
[  116.820000] omap_set_dma_dest_params(): dma_write(0xe101, CDSA_U(0x0)
[  116.830000] omap_set_dma_dest_params(): dma_write(0x1806, CDSA_L(0x0)
[  116.900000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  116.900000] omap_pcm_pointer(): offset = 0x0c03
[  116.920000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  116.920000] omap_pcm_pointer(): offset = 0x0c03
[  116.950000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  116.950000] omap_pcm_pointer(): offset = 0x0c03
[  116.980000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  116.980000] omap_pcm_pointer(): offset = 0x0c03
[  116.990000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  116.990000] omap_pcm_pointer(): offset = 0x0c03
[  117.010000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  117.010000] omap_pcm_pointer(): offset = 0x0c03
[  117.140000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  117.140000] omap_pcm_pointer(): offset = 0x0c03
underrun!!! (at least 1799126512.681 ms long)
[  117.150000] omap_pcm_prepare(): dma_params.src_start = 0x11d80000
[  117.170000] omap_pcm_prepare(): dma_params.dst_start = 0xe1011806
[  117.170000] omap_set_dma_src_params(): dma_write(0x11d8, CSSA_U(0x0)
[  117.180000] omap_set_dma_src_params(): dma_write(0x0000, CSSA_L(0x0)
[  117.190000] omap_set_dma_dest_params(): dma_write(0x1008, CCR(0x0))
[  117.200000] omap_set_dma_dest_params(): dma_write(0xe101, CDSA_U(0x0)
[  117.210000] omap_set_dma_dest_params(): dma_write(0x1806, CDSA_L(0x0)
[  117.340000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  117.340000] omap_pcm_pointer(): offset = 0x0c03
root@amsdelta:~#

And here, the same with capture, just for reference:

root@amsdelta:~# arecord -f S16_LE -t raw -d 1 >/dev/null
Recording raw data 'stdin' : Signed 16 bit Little Endian, Rate 8000 Hz, Mono
[  316.530000] omap_pcm_prepare(): dma_params.src_start = 0xe1011802
[  316.540000] omap_pcm_prepare(): dma_params.dst_start = 0x11da0000
[  316.550000] omap_set_dma_src_params(): dma_write(0xe101, CSSA_U(0x0)
[  316.550000] omap_set_dma_src_params(): dma_write(0x1802, CSSA_L(0x0)
[  316.560000] omap_set_dma_dest_params(): dma_write(0x4009, CCR(0x0))
[  316.570000] omap_set_dma_dest_params(): dma_write(0x11da, CDSA_U(0x0)
[  316.580000] omap_set_dma_dest_params(): dma_write(0x0000, CDSA_L(0x0)
[  316.590000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x01c2
[  316.590000] omap_pcm_pointer(): offset = 0x00e1
[  316.610000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x00dc
[  316.610000] omap_pcm_pointer(): offset = 0x006e
[  316.620000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x01b8
[  316.620000] omap_pcm_pointer(): offset = 0x00dc
[  316.630000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x0294
[  316.630000] omap_pcm_pointer(): offset = 0x014a
[  316.650000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x037e
[  316.650000] omap_pcm_pointer(): offset = 0x01bf
...

Now, playback with my workaround applied, slightly modified for always 
reporting dma_read(CPC(0x0)) result, even if not used for offset calculation:

root@amsdelta:~# aplay -f S16_LE -t raw -d 1 </dev/urandom
Playing raw data 'stdin' : Signed 16 bit Little Endian, Rate 8000 Hz, Mono
[  182.990000] omap_pcm_prepare(): dma_params.src_start = 0x11d80000
[  183.000000] omap_pcm_prepare(): dma_params.dst_start = 0xe1011806
[  183.010000] omap_set_dma_src_params(): dma_write(0x11d8, CSSA_U(0x0)
[  183.020000] omap_set_dma_src_params(): dma_write(0x0000, CSSA_L(0x0)
[  183.030000] omap_set_dma_dest_params(): dma_write(0x1008, CCR(0x0))
[  183.040000] omap_set_dma_dest_params(): dma_write(0xe101, CDSA_U(0x0)
[  183.050000] omap_set_dma_dest_params(): dma_write(0x1806, CDSA_L(0x0)
[  183.120000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.120000] omap_pcm_pointer(): offset = 0x0000
[  183.230000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.230000] omap_pcm_pointer(): offset = 0x03e8
[  183.260000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.260000] omap_pcm_pointer(): offset = 0x03e8
[  183.360000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.360000] omap_pcm_pointer(): offset = 0x07d0
[  183.380000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.380000] omap_pcm_pointer(): offset = 0x07d0
[  183.480000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.480000] omap_pcm_pointer(): offset = 0x0bb8
[  183.510000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.510000] omap_pcm_pointer(): offset = 0x0bb8
[  183.610000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.610000] omap_pcm_pointer(): offset = 0x0000
[  183.730000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.730000] omap_pcm_pointer(): offset = 0x03e8
[  183.860000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.860000] omap_pcm_pointer(): offset = 0x07d0
[  183.980000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  183.980000] omap_pcm_pointer(): offset = 0x0bb8
[  184.110000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
[  184.110000] omap_pcm_pointer(): offset = 0x0000
root@amsdelta:~#

Peter,
I have really no idea how the old 2.4 code could do the job with just reading 
CPC for both capture and playback, but if you think that with my ams-delta 
machine on hand I can still help you in finding that out, please let me know.

Cheers,
Janusz
