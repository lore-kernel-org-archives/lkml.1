Return-Path: <linux-kernel-owner+w=401wt.eu-S1764993AbYEHPFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764993AbYEHPFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763290AbYEHPFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:05:07 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43840 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764256AbYEHPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:05:01 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0K1VX-03-QWS-01
Date: Thu, 8 May 2008 09:06:53 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       linux-geode@bombadil.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, torvalds@linux-foundation.org
Subject: Re: lxfb driver regression
Message-ID: <20080508150653.GA18117@cosmic.amd.com>
References: <20080507210836.1eb61b8f@ephemeral> <48230694.5010505@LiPPERT-AT.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48230694.5010505@LiPPERT-AT.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 08 May 2008 15:04:39.0398 (UTC) FILETIME=[D6619860:01C8B11C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/08 15:56 +0200, Jens Rottmann wrote:
> Hi Andres,
> 
> > Without this patch, I get the following (correct) output from the lxfb
> > and console code:
> > [    0.939827] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
> > [    1.009194] Console: switching to colour frame buffer device 150x56     
> 
> > Without it, the cols/width is screwy (and I get a blank white screen):
> > [   20.706836] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
> > [   20.788538] Console: switching to colour frame buffer device 100x40          
> 
> I've searched all morning, but I don't get it. The only place the (changed)
> pll_table[] gets used is lx_set_clock(), and this doesn't return anything at
> all. lx_set_clock() gets told which dotclock to configure and it does its best
> to comply, but it doesn't report back, which clock it actually was able to
> select. So how on earth can changing this table cause fbcon or lxfb to decide
> for a completely different videomode?? Without the patch it seems to use the
> special 1200x900 OLPC DCON mode. With the patch it looks like it switches to
> some 800x640 mode. No idea where this mode might come from.
> 
> And why does the lxfb init take place 20 sec later with the patch? Is there
> some initrd manually setting a different mode? Is this offending 800x640 mode
> maybe not coming from the kernel, but from some startup script via "fbset" and
> "/etc/fb.modes"?
> 
> I don't have an OLPC, so could you please run "fbset -i -v" with and without
> my patch. Hopefully this gives some clues...
> 
> I have also attached a cut down version of my patch. It still adds all the PLL
> settings for < 25 MHz dotclocks, but it no longer supplements the > 25 MHz
> clocks with intermediate steps. I'm only guessing here, I don't see what big
> difference this would make, but still ... could you please give it a try if
> you have time?

Part of what was happening here was that one of the DIV4 generated frequencies
( 0x00014170, 57375) was a closer match for the OLPC intended frequency
(57.273) then the original value (56.250), which in retrospect is probably
a better choice for ths display.

The DIV4 bit was really only intended to provide frequencies less then what
it could cleanly generate on its own.  The datasheet says '
This bit is intended for generating frequencies below the PLL spec limit
of 15Mhz'.  I don't think we really need divided signals > 24Mhz.
The new patch you sent out was good, and I'll ack it.

That said, Andres has some interesting behaviors in his report that
probably need to be looked at, but the different clock could
explain the white screen, especially with the LCD situation on the XO.

Thanks,
Jordan

> =============X8=================X8==============================
> lxfb: extend PLL table to support dotclocks below 25 MHz
> 
> Extends the PLL frequency table of the AMD Geode-LX frame buffer
> driver to make use of the DIV4 bit, thus adding support for
> dotclocks between 6 and 24 MHz.  These are needed for small LCDs
> (e.g. 320x240).
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>

> ---
> 
> --- linux-2.6.25/drivers/video/geode/lxfb_ops.c
> +++ lxfb_clocks_added/drivers/video/geode/lxfb_ops.c
> @@ -34,35 +34,63 @@ static const struct {
>    unsigned int pllval;
>    unsigned int freq;
>  } pll_table[] = {
> -  { 0x000031AC, 24923 },
> -  { 0x0000215D, 25175 },
> -  { 0x00001087, 27000 },
> -  { 0x0000216C, 28322 },
> -  { 0x0000218D, 28560 },
> -  { 0x000010C9, 31200 },
> -  { 0x00003147, 31500 },
> -  { 0x000010A7, 33032 },
> -  { 0x00002159, 35112 },
> -  { 0x00004249, 35500 },
> -  { 0x00000057, 36000 },
> -  { 0x0000219A, 37889 },
> -  { 0x00002158, 39168 },
> -  { 0x00000045, 40000 },
> -  { 0x00000089, 43163 },
> -  { 0x000010E7, 44900 },
> -  { 0x00002136, 45720 },
> -  { 0x00003207, 49500 },
> -  { 0x00002187, 50000 },
> -  { 0x00004286, 56250 },
> -  { 0x000010E5, 60065 },
> -  { 0x00004214, 65000 },
> -  { 0x00001105, 68179 },
> -  { 0x000031E4, 74250 },
> -  { 0x00003183, 75000 },
> -  { 0x00004284, 78750 },
> -  { 0x00001104, 81600 },
> -  { 0x00006363, 94500 },
> -  { 0x00005303, 97520 },
> +  { 0x000131AC,   6231 },
> +  { 0x0001215D,   6294 },
> +  { 0x00011087,   6750 },
> +  { 0x0001216C,   7081 },
> +  { 0x0001218D,   7140 },
> +  { 0x000110C9,   7800 },
> +  { 0x00013147,   7875 },
> +  { 0x000110A7,   8258 },
> +  { 0x00012159,   8778 },
> +  { 0x00014249,   8875 },
> +  { 0x00010057,   9000 },
> +  { 0x0001219A,   9472 },
> +  { 0x00012158,   9792 },
> +  { 0x00010045,  10000 },
> +  { 0x00010089,  10791 },
> +  { 0x000110E7,  11225 },
> +  { 0x00012136,  11430 },
> +  { 0x00013207,  12375 },
> +  { 0x00012187,  12500 },
> +  { 0x00014286,  14063 },
> +  { 0x000110E5,  15016 },
> +  { 0x00014214,  16250 },
> +  { 0x00011105,  17045 },
> +  { 0x000131E4,  18563 },
> +  { 0x00013183,  18750 },
> +  { 0x00014284,  19688 },
> +  { 0x00011104,  20400 },
> +  { 0x00016363,  23625 },
> +  { 0x000031AC,  24923 },
> +  { 0x0000215D,  25175 },
> +  { 0x00001087,  27000 },
> +  { 0x0000216C,  28322 },
> +  { 0x0000218D,  28560 },
> +  { 0x000010C9,  31200 },
> +  { 0x00003147,  31500 },
> +  { 0x000010A7,  33032 },
> +  { 0x00002159,  35112 },
> +  { 0x00004249,  35500 },
> +  { 0x00000057,  36000 },
> +  { 0x0000219A,  37889 },
> +  { 0x00002158,  39168 },
> +  { 0x00000045,  40000 },
> +  { 0x00000089,  43163 },
> +  { 0x000010E7,  44900 },
> +  { 0x00002136,  45720 },
> +  { 0x00003207,  49500 },
> +  { 0x00002187,  50000 },
> +  { 0x00004286,  56250 },
> +  { 0x000010E5,  60065 },
> +  { 0x00004214,  65000 },
> +  { 0x00001105,  68179 },
> +  { 0x000031E4,  74250 },
> +  { 0x00003183,  75000 },
> +  { 0x00004284,  78750 },
> +  { 0x00001104,  81600 },
> +  { 0x00006363,  94500 },
> +  { 0x00005303,  97520 },
>    { 0x00002183, 100187 },
>    { 0x00002122, 101420 },
>    { 0x00001081, 108000 },
> @@ -137,7 +165,7 @@ static void lx_set_clock(struct fb_info
>  	unsigned int diff, min, best = 0;
>  	unsigned int freq, i;
> 
> -	freq = (unsigned int) (0x3b9aca00 / info->var.pixclock);
> +	freq = (unsigned int) (1000000000 / info->var.pixclock);
> 
>  	min = abs(pll_table[0].freq - freq);
> 
> @@ -149,7 +177,7 @@ static void lx_set_clock(struct fb_info
>  		}
>  	}
> 
> -	lx_set_dotpll(pll_table[best].pllval & 0x7FFF);
> +	lx_set_dotpll(pll_table[best].pllval & 0x00017FFF);
>  }
> 
>  static void lx_graphics_disable(struct fb_info *info)
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

