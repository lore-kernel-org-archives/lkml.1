Return-Path: <linux-kernel-owner+w=401wt.eu-S1031810AbXEHUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031810AbXEHUBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031864AbXEHUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:01:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031833AbXEHUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:01:08 -0400
Date: Tue, 8 May 2007 13:00:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-Id: <20070508130004.25cb5363.akpm@linux-foundation.org>
In-Reply-To: <20070508183232.GA13225@mailshack.com>
References: <20070505104452.GA30944@mailshack.com>
	<20070508032817.e4734798.akpm@linux-foundation.org>
	<20070508183232.GA13225@mailshack.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 20:32:32 +0200
Alexander van Heukelum <heukelum@mailshack.com> wrote:

> On Tue, May 08, 2007 at 03:28:17AM -0700, Andrew Morton wrote:
> > On Sat, 5 May 2007 12:44:52 +0200 Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > > --- a/arch/i386/boot/bootsect.S
> > > +++ b/arch/i386/boot/bootsect.S
> > > @@ -44,7 +44,7 @@ #endif
> > >  _start:
> > >  
> > >  	# Normalize the start address
> > > -	jmpl	$BOOTSEG, $start2
> > > +	jmpw	$BOOTSEG, $start2
> > 
> > Sigh, another blow struck in the ongoing struggle between my Vaio and the
> > rest of the world.
> > 
> > Stone-cold black-screen lockup immediately upon boot.
> > 
> > Stock FC5 install, config at
> > http://userweb.kernel.org/~akpm/config-sony.txt
> 
> Sigh... sounds impossible.
> 
> I assume this is repeatable?

100%

> And this patch changes behaviour?

Yup.

> What do you mean by immediate?

Basically the last thing I see is grub.

> Before or after decompression?

Not sure - things happen pretty quickly and I suspect info is getting lost
when the display is changing modes.

> Fishy... As Andi and Peter have mentioned, this code is not executed.
> There is only one user of the same memory area this early... video.S
> uses it to store some collected data, but as far as I can see only the
> 'CONFIG_VIDEO_RETAIN' code also reads it back. If it happens before
> decompression, could you see if changing
> 	#define CONFIG_VIDEO_RETAIN -> #undef CONFIG_VIDEO_RETAIN
> in arch/i386/boot/video.S changes anything?
> 
> Do you select a non-standard textmode?

yep.

> Does vga=ask show up?

no.

> *looks around some*
> 
> Oh! A padding hole in a struct! That could be a problem. If the freeze
> is after decompression, could you test if this makes it work again?

I shall try that later in the day.

> 
> ---
> 
> Commit 89ec4c238e7a3d7e660291f3f1a8181381baad77 introduced a discrepancy
> between the struct screen_info which is used by the C code, and the
> PARAM_* offsets which are used in the real-mode kernel. This is an
> attempt to rectify the situation, but I have no way to test it.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
> 
> ---
> 
> diff --git a/arch/i386/boot/bootsect.S b/arch/i386/boot/bootsect.S
> diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> index 8143c95..8e404cb 100644
> --- a/arch/i386/boot/video.S
> +++ b/arch/i386/boot/video.S
> @@ -95,7 +95,8 @@ #define PARAM_VESAPM_SEG	0x2e
>  #define PARAM_VESAPM_OFF	0x30
>  #define PARAM_LFB_PAGES		0x32
>  #define PARAM_VESA_ATTRIB	0x34
> -#define PARAM_CAPABILITIES	0x36
> +#define PARAM_VESA_PAD		0x36
> +#define PARAM_CAPABILITIES	0x38
>  
>  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
>  #ifdef CONFIG_VIDEO_RETAIN
> diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
> index b02308e..0a2e892 100644
> --- a/include/linux/screen_info.h
> +++ b/include/linux/screen_info.h
> @@ -41,8 +41,8 @@ struct screen_info {
>  	u16 vesapm_off;		/* 0x30 */
>  	u16 pages;		/* 0x32 */
>  	u16 vesa_attributes;	/* 0x34 */
> -	u32 capabilities;       /* 0x36 */
> -				/* 0x3a -- 0x3b reserved for future expansion */
> +	u16 vesa_pad;		/* 0x36 */
> +	u32 capabilities;       /* 0x38 */
>  				/* 0x3c -- 0x3f micro stack for relocatable kernels */
>  };
>  
