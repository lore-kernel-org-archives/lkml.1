Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbXBSMd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbXBSMd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXBSMd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:33:26 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:13462 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbXBSMdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:33:25 -0500
Date: Mon, 19 Feb 2007 04:32:46 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [PATCH] Don't probe for DDC on VBE1.2
In-reply-to: <200702191137.21516.ak@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tobias Hain <tobias.hain@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <Pine.LNX.4.64.0702190430470.26450@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <Pine.LNX.4.64.0702132145460.28458@montezuma.fsmlabs.com>
 <200702182253.10423.ak@suse.de>
 <Pine.LNX.4.64.0702181636420.26450@montezuma.fsmlabs.com>
 <200702191137.21516.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Andi Kleen wrote:

> 
> > I tested the x86_64 VBE3 case (similar to Andrew's VAIO), so we just need 
> > a VBE1.2 on x86_64 test.
> 
> Does this mean you want to have an updated patch or not? 

Nope, i'm happy with the last patch i sent (below to reconfirm).

Thanks

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
