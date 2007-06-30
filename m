Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXF3WoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXF3WoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 18:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXF3WoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 18:44:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbXF3WoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 18:44:04 -0400
Date: Sat, 30 Jun 2007 15:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
Message-Id: <20070630154230.4ad373fa.akpm@linux-foundation.org>
In-Reply-To: <4686D85B.6090803@gentoo.org>
References: <4678191D.76E4.0078.0@novell.com>
	<4686D85B.6090803@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 18:25:31 -0400 Daniel Drake <dsd@gentoo.org> wrote:

> Jan Beulich wrote:
> > The code to retrieve this information was (a) inside a CONFIG_VIDEO_SELECT
> > section and (b) protected by a check of a variable (vbe_version) that
> > would get initialized only when a VESA mode was selected on the command
> > line.
> 
> This patch solves a 2.6.20.11 (and 2.6.21) regression added by the patch 
> titled "x86: Don't probe for DDC on VBE1.2"
> 
> The regression caused the screen resolution to be incorrectly adjusted 
> by 6 pixels. This patch makes it go back to normal again.
> 
> https://bugs.gentoo.org/show_bug.cgi?id=181067
> 
> Please apply this patch or discuss further :)

Well drat.  I didn't merge the patch because it conflicts with
git-newsetup, and Peter believes that git-newsetup already contains an
equivalent fix.  Testing 2.6.22-rc6-mm1 would confirm that.  Please.

So what do we think?  Should we merge Jan's patch into 2.6.22?  And 2.6.21?
And do we feel that it is safe enough for this?

Or can we afford to leave this bug in place in 2.6.22, which would suck a
bit?


> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > 
> >  arch/i386/boot/video.S |   28 ++++++++++++++++++----------
> >  1 files changed, 18 insertions(+), 10 deletions(-)
> > 
> > --- linux-2.6.22-rc5/arch/i386/boot/video.S	2007-04-26 05:08:32.000000000 +0200
> > +++ 2.6.22-rc5-edid-no-vesa-mode/arch/i386/boot/video.S	2007-06-19 14:34:50.000000000 +0200
> > @@ -96,6 +96,7 @@
> >  #define PARAM_LFB_PAGES		0x32
> >  #define PARAM_VESA_ATTRIB	0x34
> >  #define PARAM_CAPABILITIES	0x36
> > +#define PARAM_EDID_INFO		0x140
> >  
> >  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
> >  #ifdef CONFIG_VIDEO_RETAIN
> > @@ -132,8 +133,8 @@ vid1:
> >  #ifdef CONFIG_VIDEO_RETAIN
> >  	call	restore_screen			# Restore screen contents
> >  #endif /* CONFIG_VIDEO_RETAIN */
> > -	call	store_edid
> >  #endif /* CONFIG_VIDEO_SELECT */
> > +	call	store_edid
> >  	call	mode_params			# Store mode parameters
> >  	popw	%ds				# Restore original DS
> >  	ret
> > @@ -571,16 +572,12 @@ setr1:	lodsw
> >  	jmp	_m_s
> >  
> >  check_vesa:
> > -#ifdef CONFIG_FIRMWARE_EDID
> >  	leaw	modelist+1024, %di
> >  	movw	$0x4f00, %ax
> >  	int	$0x10
> >  	cmpw	$0x004f, %ax
> >  	jnz	setbad
> >  
> > -	movw	4(%di), %ax
> > -	movw	%ax, vbe_version
> > -#endif
> >  	leaw	modelist+1024, %di
> >  	subb	$VIDEO_FIRST_VESA>>8, %bh
> >  	movw	%bx, %cx			# Get mode information structure
> > @@ -1935,6 +1932,7 @@ skip10:	movb	%ah, %al
> >  	popw	%cx
> >  	popw	%ax
> >  	ret
> > +#endif /* CONFIG_VIDEO_SELECT */
> >  
> >  store_edid:
> >  #ifdef CONFIG_FIRMWARE_EDID
> > @@ -1945,18 +1943,28 @@ store_edid:
> >  	pushw	%dx
> >  	pushw   %di
> >  
> > +	pushw	%ds
> > +	popw    %es
> > +	leaw	modelist, %di
> > +	movw	$0x4f00, %ax
> > +	int	$0x10
> > +	cmpw	$0x004f, %ax
> > +	setne	%dl
> > +	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
> > +	adc	%dl, %dl
> > +
> >  	pushw	%fs
> >  	popw    %es
> >  
> >  	movl	$0x13131313, %eax		# memset block with 0x13
> >  	movw    $32, %cx
> > -	movw	$0x140, %di
> > +	movw	$PARAM_EDID_INFO, %di
> >  	cld
> >  	rep
> >  	stosl
> >  
> > -	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
> > -	jl	no_edid
> > +	testb	%dl, %dl
> > +	jnz	no_edid
> >  
> >  	pushw   %es				# save ES
> >  	xorw    %di, %di                        # Report Capability
> > @@ -1978,7 +1986,7 @@ store_edid:
> >  	movw	$0x01, %bx
> >  	movw	$0x00, %cx
> >  	movw    $0x00, %dx
> > -	movw	$0x140, %di
> > +	movw	$PARAM_EDID_INFO, %di
> >  	int	$0x10
> >  
> >  no_edid:
> > @@ -1991,6 +1999,7 @@ no_edid:
> >  #endif
> >  	ret
> >  
> > +#ifdef CONFIG_VIDEO_SELECT
> >  # VIDEO_SELECT-only variables
> >  mt_end:		.word	0	# End of video mode table if built
> >  edit_buf:	.space	6	# Line editor buffer
> > @@ -2000,7 +2009,6 @@ do_restore:	.byte	0	# Screen contents al
> >  svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
> >  graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
> >  dac_size:	.byte	6	# DAC bit depth
> > -vbe_version:	.word	0	# VBE bios version
> >  
> >  # Status messages
> >  keymsg:		.ascii	"Press <RETURN> to see video modes available, "
> > 
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
