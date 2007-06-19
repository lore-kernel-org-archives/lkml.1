Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXFSQRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXFSQRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXFSQRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:17:36 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:41907
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbXFSQRe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:17:34 -0400
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 12:17:34 EDT
Message-Id: <4678191D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 19 Jun 2007 16:57:49 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] retrieve VBE EDID/DDC info independent of used video
	mode
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code to retrieve this information was (a) inside a CONFIG_VIDEO_SELECT
section and (b) protected by a check of a variable (vbe_version) that
would get initialized only when a VESA mode was selected on the command
line.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/boot/video.S |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

--- linux-2.6.22-rc5/arch/i386/boot/video.S	2007-04-26 05:08:32.000000000 +0200
+++ 2.6.22-rc5-edid-no-vesa-mode/arch/i386/boot/video.S	2007-06-19 14:34:50.000000000 +0200
@@ -96,6 +96,7 @@
 #define PARAM_LFB_PAGES		0x32
 #define PARAM_VESA_ATTRIB	0x34
 #define PARAM_CAPABILITIES	0x36
+#define PARAM_EDID_INFO		0x140
 
 /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
 #ifdef CONFIG_VIDEO_RETAIN
@@ -132,8 +133,8 @@ vid1:
 #ifdef CONFIG_VIDEO_RETAIN
 	call	restore_screen			# Restore screen contents
 #endif /* CONFIG_VIDEO_RETAIN */
-	call	store_edid
 #endif /* CONFIG_VIDEO_SELECT */
+	call	store_edid
 	call	mode_params			# Store mode parameters
 	popw	%ds				# Restore original DS
 	ret
@@ -571,16 +572,12 @@ setr1:	lodsw
 	jmp	_m_s
 
 check_vesa:
-#ifdef CONFIG_FIRMWARE_EDID
 	leaw	modelist+1024, %di
 	movw	$0x4f00, %ax
 	int	$0x10
 	cmpw	$0x004f, %ax
 	jnz	setbad
 
-	movw	4(%di), %ax
-	movw	%ax, vbe_version
-#endif
 	leaw	modelist+1024, %di
 	subb	$VIDEO_FIRST_VESA>>8, %bh
 	movw	%bx, %cx			# Get mode information structure
@@ -1935,6 +1932,7 @@ skip10:	movb	%ah, %al
 	popw	%cx
 	popw	%ax
 	ret
+#endif /* CONFIG_VIDEO_SELECT */
 
 store_edid:
 #ifdef CONFIG_FIRMWARE_EDID
@@ -1945,18 +1943,28 @@ store_edid:
 	pushw	%dx
 	pushw   %di
 
+	pushw	%ds
+	popw    %es
+	leaw	modelist, %di
+	movw	$0x4f00, %ax
+	int	$0x10
+	cmpw	$0x004f, %ax
+	setne	%dl
+	cmpw	$0x0200, 4(%di)			# only do EDID on >= VBE2.0
+	adc	%dl, %dl
+
 	pushw	%fs
 	popw    %es
 
 	movl	$0x13131313, %eax		# memset block with 0x13
 	movw    $32, %cx
-	movw	$0x140, %di
+	movw	$PARAM_EDID_INFO, %di
 	cld
 	rep
 	stosl
 
-	cmpw	$0x0200, vbe_version		# only do EDID on >= VBE2.0
-	jl	no_edid
+	testb	%dl, %dl
+	jnz	no_edid
 
 	pushw   %es				# save ES
 	xorw    %di, %di                        # Report Capability
@@ -1978,7 +1986,7 @@ store_edid:
 	movw	$0x01, %bx
 	movw	$0x00, %cx
 	movw    $0x00, %dx
-	movw	$0x140, %di
+	movw	$PARAM_EDID_INFO, %di
 	int	$0x10
 
 no_edid:
@@ -1991,6 +1999,7 @@ no_edid:
 #endif
 	ret
 
+#ifdef CONFIG_VIDEO_SELECT
 # VIDEO_SELECT-only variables
 mt_end:		.word	0	# End of video mode table if built
 edit_buf:	.space	6	# Line editor buffer
@@ -2000,7 +2009,6 @@ do_restore:	.byte	0	# Screen contents al
 svga_prefix:	.byte	VIDEO_FIRST_BIOS>>8	# Default prefix for BIOS modes
 graphic_mode:	.byte	0	# Graphic mode with a linear frame buffer
 dac_size:	.byte	6	# DAC bit depth
-vbe_version:	.word	0	# VBE bios version
 
 # Status messages
 keymsg:		.ascii	"Press <RETURN> to see video modes available, "



