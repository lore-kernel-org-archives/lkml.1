Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYE0TlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYE0TlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYE0TlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:41:11 -0400
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3422 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYE0TlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:41:10 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 15:41:09 EDT
Date: Tue, 27 May 2008 21:33:04 +0200
From: thunder7@xs4all.nl
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vt/fbcon: fix background color on line feed
Message-ID: <20080527193304.GA21560@amd64.of.nowhere>
References: <alpine.LNX.1.10.0805101015110.19952@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805101015110.19952@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even with the patch below in 2.6.26-rc4, I can still report a bad
regression against 2.6.25-rc5-mm1, starting with 2.6.26-rc1 and still in
2.6.26-rc4.

I have a framebuffer console:


Console: colour VGA+ 80x25
console [tty0] enabled
nvidiafb: Device ID: 10de0392 
nvidiafb: CRTC0 analog not found
nvidiafb: CRTC1 analog not found
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
nvidiafb: EDID found from BUS2
nvidiafb: CRTC 0 is currently programmed for DFP
nvidiafb: Using DFP on CRTC 0
nvidiafb: Panel size is 2560 x 1600
nvidiafb: Panel is TMDS
nvidiafb: MTRR set to ON
nvidiafb: Flat panel dithering disabled
Console: switching to colour frame buffer device 256x88
nvidiafb: PCI nVidia NV39 framebuffer (64MB @ 0xC0000000)

I used to force my console to black-on-white by the command 'setterm
inversescreen on'. This worked well. In 2.6.26-rc4, I get lots of black
background characters. Something as simple as typing 'ls' multiple times
until the screen scrolls gives black characters. I see them at the end
of lines, I see spaces changed in black characters, I see lots of black. 


Kind regards,
Jurriaan

> 
> commit 181afd9c4e2168f59761fd3d153b46a0c32810a3
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sat May 10 10:16:56 2008 +0200
> 
> vt/fbcon: fix background color on line feed
> 
> Addendum to commit c9e587ab.
> fbcon still was not doing the right thing (read: continued to do old
> behavior). fbcon_clear() seems to clear the new line (e.g. where your
> new prompt appears after doing echo -en "\e[42mfoo\n"), while
> scr_memsetw clears the previous one only (where "foo" appears). So
> just temporarily set the video_erase_char to the scrl_erase_char so
> that fbcon_clear does the right thing.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  drivers/video/console/fbcon.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 774f803..c77c2fd 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -1854,6 +1854,8 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
>  	struct display *p = &fb_display[vc->vc_num];
>  	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
> +	unsigned short saved_ec;
> +	int ret;
>  
>  	if (fbcon_is_inactive(vc, info))
>  		return -EINVAL;
> @@ -1866,6 +1868,11 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  	 *           whole screen (prevents flicker).
>  	 */
>  
> +	saved_ec = vc->vc_video_erase_char;
> +	vc->vc_video_erase_char = vc->vc_scrl_erase_char;
> +
> +	ret = 0;
> +
>  	switch (dir) {
>  	case SM_UP:
>  		if (count > vc->vc_rows)	/* Maximum realistic size */
> @@ -1884,7 +1891,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  							(b - count)),
>  				    vc->vc_scrl_erase_char,
>  				    vc->vc_size_row * count);
> -			return 1;
> +			ret = 1;
>  			break;
>  
>  		case SCROLL_WRAP_MOVE:
> @@ -1956,7 +1963,8 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  							(b - count)),
>  				    vc->vc_scrl_erase_char,
>  				    vc->vc_size_row * count);
> -			return 1;
> +			ret = 1;
> +			break;
>  		}
>  		break;
>  
> @@ -1975,7 +1983,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  							t),
>  				    vc->vc_scrl_erase_char,
>  				    vc->vc_size_row * count);
> -			return 1;
> +			ret = 1;
>  			break;
>  
>  		case SCROLL_WRAP_MOVE:
> @@ -2045,10 +2053,13 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
>  							t),
>  				    vc->vc_scrl_erase_char,
>  				    vc->vc_size_row * count);
> -			return 1;
> +			ret = 1;
> +			break;
>  		}
> +		break;
>  	}
> -	return 0;
> +	vc->vc_video_erase_char = saved_ec;
> +	return ret;
>  }
>  
-- 
When God is on the Bodhran
The atoms want to dance
	Oysterband - In your eyes
Debian (Unstable) GNU/Linux 2.6.26-rc1 2x2010 bogomips load 0.75
the Jack Vance Integral Edition: http://www.integralarchive.org
