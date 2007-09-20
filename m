Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXITSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXITSSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXITSSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:18:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbXITSSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:18:34 -0400
Date: Thu, 20 Sep 2007 11:16:44 -0700
Message-Id: <200709201816.l8KIGiID016573@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Bolle <pebolle@tiscali.nl>, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: [GIT PULL] [x86 setup] Fix VESA mode decoding in ACPI wakeup
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the delay on this, I was waiting for feedback on a problem
which turned out to be a non-kernel problem.

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (2):
      [x86 setup] Present the canonical video mode number to the kernel
      [acpi] Correct the decoding of video mode numbers in wakeup.S

Paul Bolle (1):
      [x86 setup] Fix typo in arch/i386/boot/header.S

 arch/i386/boot/header.S          |    2 +-
 arch/i386/boot/video.c           |   14 ++++++++---
 arch/i386/kernel/acpi/wakeup.S   |   41 ++++++++-------------------------
 arch/x86_64/kernel/acpi/wakeup.S |   47 ++++++++++---------------------------
 4 files changed, 34 insertions(+), 70 deletions(-)

[Log messages and full diffs follow]

commit bbc15f46fe4dc2862325e2b4ba474a854162e1a1
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Mon Sep 10 23:39:02 2007 +0200

    [x86 setup] Fix typo in arch/i386/boot/header.S
    
    There's an obvious typo in arch/i386/boot/header.S (in your
    linux-2.6-x86setup.git) that I noticed by just studying the code.
    
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
index 7f4a2c5..f3140e5 100644
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -275,7 +275,7 @@ die:
 	hlt
 	jmp	die
 
-	.size	die, .-due
+	.size	die, .-die
 
 	.section ".initdata", "a"
 setup_corrupt:

commit 91c4b8cb5ab8cc3e8352739e35699c0487a6b6f3
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Sep 13 14:16:37 2007 -0700

    [acpi] Correct the decoding of video mode numbers in wakeup.S
    
    wakeup.S looks at the video mode number from the setup header and
    looks to see if it is a VESA mode.  Unfortunately, the decoding is
    done incorrectly and it will attempt to frob the VESA BIOS for any
    mode number 0x0200 or larger.  Correct this, and remove a bunch of #if
    0'd code.
    
    Massive thanks to Jeff Chua for reporting the bug, and suffering
    though a large number of experiments in order to track this problem
    down.
    
    Cc: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
index ed0a0f2..f22ba85 100644
--- a/arch/i386/kernel/acpi/wakeup.S
+++ b/arch/i386/kernel/acpi/wakeup.S
@@ -151,51 +151,30 @@ bogus_real_magic:
 #define VIDEO_FIRST_V7 0x0900
 
 # Setting of user mode (AX=mode ID) => CF=success
+
+# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
+# modes, we should probably compile in the video code from the boot
+# directory.
 mode_set:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
-	
-	cmpb	$VIDEO_FIRST_VESA>>8, %ah
-	jnc	check_vesa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
-	
-	decb	%ah
-#	jz	setbios				  Add bios modes later
+	subb	$VIDEO_FIRST_VESA>>8, %bh
+	cmpb	$2, %bh
+	jb	check_vesa
 
-setbad:	clc
+setbad:
+	clc
 	ret
 
 check_vesa:
-	subb	$VIDEO_FIRST_VESA>>8, %bh
 	orw	$0x4000, %bx			# Use linear frame buffer
 	movw	$0x4f02, %ax			# VESA BIOS mode set call
 	int	$0x10
 	cmpw	$0x004f, %ax			# AL=4f if implemented
-	jnz	_setbad				# AH=0 if OK
+	jnz	setbad				# AH=0 if OK
 
 	stc
 	ret
 
-_setbad: jmp setbad
-
 	.code32
 	ALIGN
 
diff --git a/arch/x86_64/kernel/acpi/wakeup.S b/arch/x86_64/kernel/acpi/wakeup.S
index 13f1480..a06f2bc 100644
--- a/arch/x86_64/kernel/acpi/wakeup.S
+++ b/arch/x86_64/kernel/acpi/wakeup.S
@@ -81,7 +81,7 @@ wakeup_code:
 	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
-	call	mode_seta
+	call	mode_set
 1:
 
  	movw	$0xb800, %ax
@@ -291,52 +291,31 @@ no_longmode:
 #define VIDEO_FIRST_V7 0x0900
 
 # Setting of user mode (AX=mode ID) => CF=success
+
+# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
+# modes, we should probably compile in the video code from the boot
+# directory.
 .code16
-mode_seta:
+mode_set:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
-	
-	cmpb	$VIDEO_FIRST_VESA>>8, %ah
-	jnc	check_vesaa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
-	
-	decb	%ah
-#	jz	setbios				  Add bios modes later
+	subb	$VIDEO_FIRST_VESA>>8, %bh
+	cmpb	$2, %bh
+	jb	check_vesa
 
-setbada:	clc
+setbad:
+	clc
 	ret
 
-check_vesaa:
-	subb	$VIDEO_FIRST_VESA>>8, %bh
+check_vesa:
 	orw	$0x4000, %bx			# Use linear frame buffer
 	movw	$0x4f02, %ax			# VESA BIOS mode set call
 	int	$0x10
 	cmpw	$0x004f, %ax			# AL=4f if implemented
-	jnz	_setbada				# AH=0 if OK
+	jnz	setbad				# AH=0 if OK
 
 	stc
 	ret
 
-_setbada: jmp setbada
-
 wakeup_stack_begin:	# Stack grows down
 
 .org	0xff0

commit 3f662b3f6e422a15fefcbaf4bdd21f97e6bcf32d
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Sep 13 14:14:29 2007 -0700

    [x86 setup] Present the canonical video mode number to the kernel
    
    Canonicalize the video mode number as presented to the kernel.  The
    video mode number may be user-entered (e.g. ASK_VGA), an alias
    (e.g. NORMAL_VGA), or a size specification, and that confuses the
    suspend wakeup code.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
index 693f20d..e4ba897 100644
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -147,7 +147,7 @@ int mode_defined(u16 mode)
 }
 
 /* Set mode (without recalc) */
-static int raw_set_mode(u16 mode)
+static int raw_set_mode(u16 mode, u16 *real_mode)
 {
 	int nmode, i;
 	struct card_info *card;
@@ -165,8 +165,10 @@ static int raw_set_mode(u16 mode)
 
 			if ((mode == nmode && visible) ||
 			    mode == mi->mode ||
-			    mode == (mi->y << 8)+mi->x)
+			    mode == (mi->y << 8)+mi->x) {
+				*real_mode = mi->mode;
 				return card->set_mode(mi);
+			}
 
 			if (visible)
 				nmode++;
@@ -178,7 +180,7 @@ static int raw_set_mode(u16 mode)
 		if (mode >= card->xmode_first &&
 		    mode < card->xmode_first+card->xmode_n) {
 			struct mode_info mix;
-			mix.mode = mode;
+			*real_mode = mix.mode = mode;
 			mix.x = mix.y = 0;
 			return card->set_mode(&mix);
 		}
@@ -223,6 +225,7 @@ static void vga_recalc_vertical(void)
 static int set_mode(u16 mode)
 {
 	int rv;
+	u16 real_mode;
 
 	/* Very special mode numbers... */
 	if (mode == VIDEO_CURRENT_MODE)
@@ -232,13 +235,16 @@ static int set_mode(u16 mode)
 	else if (mode == EXTENDED_VGA)
 		mode = VIDEO_8POINT;
 
-	rv = raw_set_mode(mode);
+	rv = raw_set_mode(mode, &real_mode);
 	if (rv)
 		return rv;
 
 	if (mode & VIDEO_RECALC)
 		vga_recalc_vertical();
 
+	/* Save the canonical mode number for the kernel, not
+	   an alias, size specification or menu position */
+	boot_params.hdr.vid_mode = real_mode;
 	return 0;
 }
 
