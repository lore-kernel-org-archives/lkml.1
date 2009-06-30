Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZF3FVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZF3FVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZF3FVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:21:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:63559 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZF3FVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:21:45 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer callback
Date: Tue, 30 Jun 2009 08:20:08 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.29-gentoo-r5; KDE/4.2.4; i686; ; )
Cc: ext Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl> <200906290937.58786.peter.ujfalusi@nokia.com> <200906291551.08437.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200906291551.08437.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906300820.09414.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 30 Jun 2009 05:20:16.0083 (UTC) FILETIME=[73AFD230:01C9F942]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009 16:51:07 ext Janusz Krzysztofik wrote:
> I am not able to find any information on how DMA can be configured for CPC
> to reflect either source or destination port address progress. Official
> documentation, even if not very clear for me, seems to suggest that it
> always follows destination port address, even if constatnt (ie
> DMA_CCR:DST_AMODE(15:14) == 0).

Yeah, the CPC register only mentioned in the register description. I think the 
description suggests that it should have the LSB of the source (in contrast 
what it actually contains), since it states that the content will be updated 
when the destination port issued a request for an element/frame. To my 
knowledge only - static - ports can issue DMA requests.

>
> > The difference that I can see is that the OSS code also configured the
> > CCR:SYNC(4:0) bits as well.
> > Looking at the DMA_CPC register description in the OMAP1510 TRM: it list
> > two cases on how it behaves and both require the DMA_CCR:SYNC != 0...
>
> Not exactly. According to my copy of
> http://focus.ti.com/lit/ug/spru674/spru674.pdf, the secnod case is:
>
> 	If the channel transfer is synchronized on frames
> 	(DMA_CCR SYNC ≠ 0 and DMA_CCR FS = 1) or not
> 	synchronized (DMA_CCR SYNC = 0), the register is
> 	updated with 16 LSB of the address each time the
> 	destination port issues the last request for a frame.
>
> Anyway, that seems to be irrelevant in our case.

Yes, that's true, but we are using element mode.

> Not exactly. Even if not touched inside any of
> omap_set_dma_transfer_params(), omap_set_dma_src_params() nor
> omap_set_dma_dest_params(), these bits are already set by
> arch/arm/plat-omap/dma.c:omap_request_dma(int dev_id, ...):
>
>  765         } else if (cpu_is_omap7xx() || cpu_is_omap15xx()) {
>  766                 dma_write(dev_id, CCR(free_ch));

Correct, I have missed this one.

> Here you are. Same figures wheather with or without your patch. I also
> printed a value that CCR is written with, so you can verify those SYNC(4:0)
> bits are set correctly.
>
> root@amsdelta:~# aplay -f S16_LE -t raw -d 1 </dev/urandom
> Playing raw data 'stdin' : Signed 16 bit Little Endian, Rate 8000 Hz, Mono
> [  116.780000] omap_pcm_prepare(): dma_params.src_start = 0x11d80000
> [  116.780000] omap_pcm_prepare(): dma_params.dst_start = 0xe1011806
> [  116.790000] omap_set_dma_src_params(): dma_write(0x11d8, CSSA_U(0x0)
> [  116.800000] omap_set_dma_src_params(): dma_write(0x0000, CSSA_L(0x0)
> [  116.810000] omap_set_dma_dest_params(): dma_write(0x1008, CCR(0x0))
> [  116.820000] omap_set_dma_dest_params(): dma_write(0xe101, CDSA_U(0x0)
> [  116.830000] omap_set_dma_dest_params(): dma_write(0x1806, CDSA_L(0x0)
> [  116.900000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  116.900000] omap_pcm_pointer(): offset = 0x0c03
> [  116.920000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  116.920000] omap_pcm_pointer(): offset = 0x0c03
> [  116.950000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  116.950000] omap_pcm_pointer(): offset = 0x0c03
> [  116.980000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  116.980000] omap_pcm_pointer(): offset = 0x0c03
> [  116.990000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  116.990000] omap_pcm_pointer(): offset = 0x0c03
> [  117.010000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  117.010000] omap_pcm_pointer(): offset = 0x0c03
> [  117.140000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  117.140000] omap_pcm_pointer(): offset = 0x0c03
> underrun!!! (at least 1799126512.681 ms long)
> [  117.150000] omap_pcm_prepare(): dma_params.src_start = 0x11d80000
> [  117.170000] omap_pcm_prepare(): dma_params.dst_start = 0xe1011806
> [  117.170000] omap_set_dma_src_params(): dma_write(0x11d8, CSSA_U(0x0)
> [  117.180000] omap_set_dma_src_params(): dma_write(0x0000, CSSA_L(0x0)
> [  117.190000] omap_set_dma_dest_params(): dma_write(0x1008, CCR(0x0))
> [  117.200000] omap_set_dma_dest_params(): dma_write(0xe101, CDSA_U(0x0)
> [  117.210000] omap_set_dma_dest_params(): dma_write(0x1806, CDSA_L(0x0)
> [  117.340000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x1806
> [  117.340000] omap_pcm_pointer(): offset = 0x0c03
> root@amsdelta:~#
>
> And here, the same with capture, just for reference:
>
> root@amsdelta:~# arecord -f S16_LE -t raw -d 1 >/dev/null
> Recording raw data 'stdin' : Signed 16 bit Little Endian, Rate 8000 Hz,
> Mono [  316.530000] omap_pcm_prepare(): dma_params.src_start = 0xe1011802 [
>  316.540000] omap_pcm_prepare(): dma_params.dst_start = 0x11da0000 [ 
> 316.550000] omap_set_dma_src_params(): dma_write(0xe101, CSSA_U(0x0) [ 
> 316.550000] omap_set_dma_src_params(): dma_write(0x1802, CSSA_L(0x0) [ 
> 316.560000] omap_set_dma_dest_params(): dma_write(0x4009, CCR(0x0)) [ 
> 316.570000] omap_set_dma_dest_params(): dma_write(0x11da, CDSA_U(0x0) [ 
> 316.580000] omap_set_dma_dest_params(): dma_write(0x0000, CDSA_L(0x0) [ 
> 316.590000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x01c2 [ 
> 316.590000] omap_pcm_pointer(): offset = 0x00e1
> [  316.610000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x00dc
> [  316.610000] omap_pcm_pointer(): offset = 0x006e
> [  316.620000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x01b8
> [  316.620000] omap_pcm_pointer(): offset = 0x00dc
> [  316.630000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x0294
> [  316.630000] omap_pcm_pointer(): offset = 0x014a
> [  316.650000] omap_get_dma_src_pos(): dma_read(CPC(0x0)) == 0x037e
> [  316.650000] omap_pcm_pointer(): offset = 0x01bf
> ...

I find this whole thin amusing... It seams that the TRM is not quite written 
for the same chip. In contrast what it states for the CPC, it looks in a way, 
that the CPC is updated with the LSB of the destination at the last request 
issued by the source port (well you only need to negate the whole description 
to get to this conclusion).

> Peter,
> I have really no idea how the old 2.4 code could do the job with just
> reading CPC for both capture and playback, but if you think that with my
> ams-delta machine on hand I can still help you in finding that out, please
> let me know.

Me either now. The OSS driver uses this call to get the offset for capture and 
playback:
dma_addr_t omap_get_dma_pos(dma_regs_t * regs)
{
	return (dma_addr_t) (regs->cpc | (regs->cssa_u << 16));
}

Now this is bogus for either in case of playback or capture, but it should be 
not right for both...

It would be nice to understand how this is working, but for now I think your 
workaround is good for handling the situation.

Mark: I agree with Jarkko, this can be queued for 2.6.31.

Thanks Janusz for the debugging and figuring this out!

Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

