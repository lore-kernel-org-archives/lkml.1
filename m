Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXEIOa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXEIOa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXEIOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:30:20 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:34137 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbXEIOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:30:19 -0400
Date: Wed, 9 May 2007 10:30:18 -0400
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-ID: <20070509143018.GH8753@csclub.uwaterloo.ca>
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178669047.4747.15.camel@daplas>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 08:04:07AM +0800, Antonino A. Daplas wrote:
> On Tue, 2007-05-08 at 20:32 +0200, Alexander van Heukelum wrote:
> > On Tue, May 08, 2007 at 03:28:17AM -0700, Andrew Morton wrote:
> > > On Sat, 5 May 2007 12:44:52 +0200 Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > > > --- a/arch/i386/boot/bootsect.S
> > > > +++ b/arch/i386/boot/bootsect.S
> > > > @@ -44,7 +44,7 @@ #endif
> > > >  _start:
> > > >  
> > > >  	# Normalize the start address
> > > > -	jmpl	$BOOTSEG, $start2
> > > > +	jmpw	$BOOTSEG, $start2
> > > 
> > > Sigh, another blow struck in the ongoing struggle between my Vaio and the
> > > rest of the world.
> > > 
> > > Stone-cold black-screen lockup immediately upon boot.
> > > 
> > > Stock FC5 install, config at
> > > http://userweb.kernel.org/~akpm/config-sony.txt
> > 
> > Sigh... sounds impossible.
> > 
> > I assume this is repeatable? And this patch changes behaviour? What do
> > you mean by immediate? Before or after decompression?
> > 
> > Fishy... As Andi and Peter have mentioned, this code is not executed.
> > There is only one user of the same memory area this early... video.S
> > uses it to store some collected data, but as far as I can see only the
> > 'CONFIG_VIDEO_RETAIN' code also reads it back. If it happens before
> > decompression, could you see if changing
> > 	#define CONFIG_VIDEO_RETAIN -> #undef CONFIG_VIDEO_RETAIN
> > in arch/i386/boot/video.S changes anything?
> > 
> > Do you select a non-standard textmode? Does vga=ask show up?
> > 
> > *looks around some*
> > 
> > Oh! A padding hole in a struct! That could be a problem. If the freeze
> > is after decompression, could you test if this makes it work again?
> > 
> > Greetings,
> > 	Alexander
> > 
> > ---
> > 
> > Commit 89ec4c238e7a3d7e660291f3f1a8181381baad77 introduced a discrepancy
> > between the struct screen_info which is used by the C code, and the
> > PARAM_* offsets which are used in the real-mode kernel. This is an
> > attempt to rectify the situation, but I have no way to test it.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
> > 
> > ---
> > 
> > diff --git a/arch/i386/boot/bootsect.S b/arch/i386/boot/bootsect.S
> > diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> > index 8143c95..8e404cb 100644
> > --- a/arch/i386/boot/video.S
> > +++ b/arch/i386/boot/video.S
> > @@ -95,7 +95,8 @@ #define PARAM_VESAPM_SEG	0x2e
> >  #define PARAM_VESAPM_OFF	0x30
> >  #define PARAM_LFB_PAGES		0x32
> >  #define PARAM_VESA_ATTRIB	0x34
> > -#define PARAM_CAPABILITIES	0x36
> > +#define PARAM_VESA_PAD		0x36
> > +#define PARAM_CAPABILITIES	0x38

Isn't this ^^^ what you are suggesting below?

> >  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
> >  #ifdef CONFIG_VIDEO_RETAIN
> > diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
> > index b02308e..0a2e892 100644
> > --- a/include/linux/screen_info.h
> > +++ b/include/linux/screen_info.h
> > @@ -41,8 +41,8 @@ struct screen_info {
> >  	u16 vesapm_off;		/* 0x30 */
> >  	u16 pages;		/* 0x32 */
> >  	u16 vesa_attributes;	/* 0x34 */
> > -	u32 capabilities;       /* 0x36 */
> > -				/* 0x3a -- 0x3b reserved for future expansion */
> > +	u16 vesa_pad;		/* 0x36 */
> > +	u32 capabilities;       /* 0x38 */
> >  				/* 0x3c -- 0x3f micro stack for relocatable kernels */
> >  };
> >  
> 
> You would also need this minor change.
> 
> Tony
> 
> diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> index 5e2280c..2d637d1 100644
> --- a/arch/i386/boot/video.S
> +++ b/arch/i386/boot/video.S
> @@ -95,7 +95,7 @@ #define PARAM_VESAPM_SEG      0x2e
>  #define PARAM_VESAPM_OFF       0x30
>  #define PARAM_LFB_PAGES                0x32
>  #define PARAM_VESA_ATTRIB      0x34
> -#define PARAM_CAPABILITIES     0x36
> +#define PARAM_CAPABILITIES     0x38
>  
>  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
>  #ifdef CONFIG_VIDEO_RETAIN

--
Len Sorensen
