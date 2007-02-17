Return-Path: <linux-kernel-owner+w=401wt.eu-S965057AbXBQIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057AbXBQIgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965058AbXBQIgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:36:00 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:36850 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057AbXBQIf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:35:59 -0500
Date: Sat, 17 Feb 2007 00:35:52 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <20070216102206.343e0b0d.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <20070215205658.56096f97.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152134190.12571@montezuma.fsmlabs.com>
 <20070215214506.f795acc4.akpm@linux-foundation.org>
 <20070215215125.9161e3dc.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702152158210.12571@montezuma.fsmlabs.com>
 <20070215230243.515ec6b3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702160500210.31650@montezuma.fsmlabs.com>
 <20070216102206.343e0b0d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Andrew Morton wrote:

> On Fri, 16 Feb 2007 06:39:45 -0800 (PST) Zwane Mwaikambo <zwane@infradead.org> wrote:
> 
> > On Thu, 15 Feb 2007, Andrew Morton wrote:
> > 
> > > It's not an X problem - the screen is black immediately upon loading the
> > > kernel.
> > > 
> > > But I guess you knew that and you're just after display info:
> > > http://userweb.kernel.org/~akpm/Xorg.0.log.txt
> > 
> > Thanks, the X log told me your VBE version. I tried to reproduce it on my 
> > thinkpad which seems to have a very similar video setup to no avail, Could 
> > you test the following on the VAIO? If this isn't the case, i suspect i'm 
> > corrupting your modelist.
> 
> It's still all black.

Ok it looks like i was corrupting the modelist. The following should take 
care of your VAIO, but i haven't tested the failure case as Tobias is away 
this weekend.

Index: linux-2.6.20-mm1/arch/i386/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/i386/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/i386/boot/video.S	15 Feb 2007 17:35:57 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/i386/boot/video.S	17 Feb 2007 08:29:11 -0000
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+	
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
Index: linux-2.6.20-mm1/arch/x86_64/boot/video.S
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/arch/x86_64/boot/video.S,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 video.S
--- linux-2.6.20-mm1/arch/x86_64/boot/video.S	15 Feb 2007 17:36:18 -0000	1.1.1.1
+++ linux-2.6.20-mm1/arch/x86_64/boot/video.S	17 Feb 2007 08:29:11 -0000
@@ -571,6 +571,16 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
+#ifdef CONFIG_FIRMWARE_EDID
+	leaw	modelist+1024, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	jnz	setbad
+	
+	movw	4(%di), %ax
+	movw	%ax, vbe_version
+#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1945,6 +1955,9 @@ store_edid:
 	rep
 	stosl
 
+	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
+	jl	no_edid
+
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
 	pushw   %di
@@ -1987,6 +2000,7 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
+vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "
