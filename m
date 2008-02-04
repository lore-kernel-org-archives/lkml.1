Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYBDMo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYBDMo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYBDMot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:44:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40184 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881AbYBDMoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:44:46 -0500
Date: Mon, 4 Feb 2008 13:44:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080204124446.GA7843@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz> <20080203184931.GA2648@uranus.ravnborg.org> <20080203222407.GC2799@elf.ucw.cz> <20080203222719.GB6456@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203222719.GB6456@uranus.ravnborg.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-02-03 23:27:20, Sam Ravnborg wrote:
> On Sun, Feb 03, 2008 at 11:24:07PM +0100, Pavel Machek wrote:
> > On Sun 2008-02-03 19:49:31, Sam Ravnborg wrote:
> > > On Sun, Feb 03, 2008 at 07:16:48PM +0100, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > > > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > > > > 
> > > > > 
> > > > > Do you have an updated version or is this the latest one?
> > > > 
> > > > I'm glad you ask ;-). Here's reasonably-recent version (I have
> > > > slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> > > > eventually got it to work on 64-bit, by reusing trampoline.S code.
> > > > 
> > > > 								Pavel
> > > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > Hi PAvel.
> > > 
> > > Before you submit this for real we need me to take a deper
> > > look into your Makefiles.
> > 
> > Ok, lets get this right.
> > 
> > > We do not want this duplication between boot and acpi.
> > > And the way you deal with code sharing from boot/ is not
> > > OK either.
> > 
> > Well, current version has one copy in .c, then two duplicate .S
> > version, based on older code.... so few duplicate Makefiles do not
> > seem like huge deal.
> It is more the single files that just include another .c file.
> 
> Can you drop me an updated patch sometime Monday - I already lost
> the inital mail and I guess you continue your updates.

Here's current version...
								Pavel

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8978e98..949b8eb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -192,8 +192,8 @@ drivers-$(CONFIG_PCI)            += arch
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 
-ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_PM) += arch/x86/power/
+ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_FB) += arch/x86/video/
 endif
 
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 349b81a..0a5bcd3 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -30,7 +30,7 @@ subdir- 	:= compressed
 
 setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
 setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o string.o tty.o video.o version.o
+setup-y		+= printf.o string.o tty.o video.o video-mode.o version.o
 setup-$(CONFIG_X86_APM_BOOT) += apm.o
 setup-$(CONFIG_X86_VOYAGER) += voyager.o
 
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 7822a49..0957807 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -286,6 +286,11 @@ int getchar_timeout(void);
 /* video.c */
 void set_video(void);
 
+/* video-mode.c */
+int set_mode(u16 mode);
+int mode_defined(u16 mode);
+void probe_cards(int unsafe);
+
 /* video-vesa.c */
 void vesa_store_edid(void);
 
diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index ff664a1..39e247e 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -50,6 +50,7 @@ static int set_bios_mode(u8 mode)
 	if (new_mode == mode)
 		return 0;	/* Mode change OK */
 
+#ifndef _WAKEUP
 	if (new_mode != boot_params.screen_info.orig_video_mode) {
 		/* Mode setting failed, but we didn't end up where we
 		   started.  That's bad.  Try to revert to the original
@@ -59,13 +60,18 @@ static int set_bios_mode(u8 mode)
 			     : "+a" (ax)
 			     : : "ebx", "ecx", "edx", "esi", "edi");
 	}
+#endif
 	return -1;
 }
 
 static int bios_probe(void)
 {
 	u8 mode;
+#ifdef _WAKEUP
+	u8 saved_mode = 0x03;
+#else
 	u8 saved_mode = boot_params.screen_info.orig_video_mode;
+#endif
 	u16 crtc;
 	struct mode_info *mi;
 	int nmodes = 0;
diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
new file mode 100644
index 0000000..18bacb3
--- /dev/null
+++ b/arch/x86/boot/video-mode.c
@@ -0,0 +1,173 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video-mode.c
+ *
+ * Set the video mode.  This is separated out into a different
+ * file in order to be shared with the ACPI wakeup code.
+ */
+
+#include "boot.h"
+#include "video.h"
+#include "vesa.h"
+
+/*
+ * Common variables
+ */
+int adapter;			/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
+u16 video_segment;
+int force_x, force_y;	/* Don't query the BIOS for cols/rows */
+
+int do_restore = 0;	/* Screen contents changed during mode flip */
+int graphic_mode;	/* Graphic mode with linear frame buffer */
+
+/* Probe the video drivers and have them generate their mode lists. */
+void probe_cards(int unsafe)
+{
+	struct card_info *card;
+	static u8 probed[2];
+
+	if (probed[unsafe])
+		return;
+
+	probed[unsafe] = 1;
+
+	for (card = video_cards; card < video_cards_end; card++) {
+		if (card->unsafe == unsafe) {
+			if (card->probe)
+				card->nmodes = card->probe();
+			else
+				card->nmodes = 0;
+		}
+	}
+}
+
+/* Test if a mode is defined */
+int mode_defined(u16 mode)
+{
+	struct card_info *card;
+	struct mode_info *mi;
+	int i;
+
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++) {
+			if (mi->mode == mode)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+/* Set mode (without recalc) */
+static int raw_set_mode(u16 mode, u16 *real_mode)
+{
+	int nmode, i;
+	struct card_info *card;
+	struct mode_info *mi;
+
+	/* Drop the recalc bit if set */
+	mode &= ~VIDEO_RECALC;
+
+	/* Scan for mode based on fixed ID, position, or resolution */
+	nmode = 0;
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++) {
+			int visible = mi->x || mi->y;
+
+			if ((mode == nmode && visible) ||
+			    mode == mi->mode ||
+			    mode == (mi->y << 8)+mi->x) {
+				*real_mode = mi->mode;
+				return card->set_mode(mi);
+			}
+
+			if (visible)
+				nmode++;
+		}
+	}
+
+	/* Nothing found?  Is it an "exceptional" (unprobed) mode? */
+	for (card = video_cards; card < video_cards_end; card++) {
+		if (mode >= card->xmode_first &&
+		    mode < card->xmode_first+card->xmode_n) {
+			struct mode_info mix;
+			*real_mode = mix.mode = mode;
+			mix.x = mix.y = 0;
+			return card->set_mode(&mix);
+		}
+	}
+
+	/* Otherwise, failure... */
+	return -1;
+}
+
+/*
+ * Recalculate the vertical video cutoff (hack!)
+ */
+static void vga_recalc_vertical(void)
+{
+	unsigned int font_size, rows;
+	u16 crtc;
+	u8 pt, ov;
+
+	set_fs(0);
+	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
+	rows = force_y ? force_y : rdfs8(0x484)+1; /* Text rows */
+
+	rows *= font_size;	/* Visible scan lines */
+	rows--;			/* ... minus one */
+
+	crtc = vga_crtc();
+
+	pt = in_idx(crtc, 0x11);
+	pt &= ~0x80;		/* Unlock CR0-7 */
+	out_idx(pt, crtc, 0x11);
+
+	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
+
+	ov = in_idx(crtc, 0x07); /* Overflow register */
+	ov &= 0xbd;
+	ov |= (rows >> (8-1)) & 0x02;
+	ov |= (rows >> (9-6)) & 0x40;
+	out_idx(ov, crtc, 0x07);
+}
+
+/* Set mode (with recalc if specified) */
+int set_mode(u16 mode)
+{
+	int rv;
+	u16 real_mode;
+
+	/* Very special mode numbers... */
+	if (mode == VIDEO_CURRENT_MODE)
+		return 0;	/* Nothing to do... */
+	else if (mode == NORMAL_VGA)
+		mode = VIDEO_80x25;
+	else if (mode == EXTENDED_VGA)
+		mode = VIDEO_8POINT;
+
+	rv = raw_set_mode(mode, &real_mode);
+	if (rv)
+		return rv;
+
+	if (mode & VIDEO_RECALC)
+		vga_recalc_vertical();
+
+	/* Save the canonical mode number for the kernel, not
+	   an alias, size specification or menu position */
+#ifndef _WAKEUP
+	boot_params.hdr.vid_mode = real_mode;
+#endif
+	return 0;
+}
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 662dd2f..f5cd4c1 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -160,7 +160,9 @@ static int vesa_set_mode(struct mode_inf
 		do_restore = 1;
 	} else {
 		/* Graphics mode */
+#ifndef _WAKEUP
 		vesa_store_mode_params_graphics();
+#endif
 	}
 
 	return 0;
@@ -187,6 +189,7 @@ static void vesa_dac_set_8bits(void)
 	}
 
 	/* Set the color sizes to the DAC size, and offsets to 0 */
+#ifndef _WAKEUP
 	boot_params.screen_info.red_size = dac_size;
 	boot_params.screen_info.green_size = dac_size;
 	boot_params.screen_info.blue_size = dac_size;
@@ -196,8 +199,11 @@ static void vesa_dac_set_8bits(void)
 	boot_params.screen_info.green_pos = 0;
 	boot_params.screen_info.blue_pos = 0;
 	boot_params.screen_info.rsvd_pos = 0;
+#endif
 }
 
+#ifndef _WAKEUP
+
 /* Save the VESA protected mode info */
 static void vesa_store_pm_info(void)
 {
@@ -290,6 +296,8 @@ #ifdef CONFIG_FIRMWARE_EDID
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
+#endif /* not _WAKEUP */
+
 __videocard video_vesa =
 {
 	.card_name	= "VESA",
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 7259387..330d658 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -210,6 +210,8 @@ static int vga_set_mode(struct mode_info
  */
 static int vga_probe(void)
 {
+	u16 ega_bx;
+
 	static const char *card_name[] = {
 		"CGA/MDA/HGC", "EGA", "VGA"
 	};
@@ -226,12 +228,16 @@ static int vga_probe(void)
 	u8 vga_flag;
 
 	asm(INT10
-	    : "=b" (boot_params.screen_info.orig_video_ega_bx)
+	    : "=b" (ega_bx)
 	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
 	    : "ecx", "edx", "esi", "edi");
 
+#ifndef _WAKEUP
+	boot_params.screen_info.orig_video_ega_bx = ega_bx;
+#endif
+
 	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
-	if ((u8)boot_params.screen_info.orig_video_ega_bx != 0x10) {
+	if ((u8)ega_bx != 0x10) {
 		/* EGA/VGA */
 		asm(INT10
 		    : "=a" (vga_flag)
@@ -240,7 +246,9 @@ static int vga_probe(void)
 
 		if (vga_flag == 0x1a) {
 			adapter = ADAPTER_VGA;
+#ifndef _WAKEUP
 			boot_params.screen_info.orig_video_isVGA = 1;
+#endif
 		} else {
 			adapter = ADAPTER_EGA;
 		}
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index 696d08f..c1c47ba 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -18,21 +18,6 @@ #include "boot.h"
 #include "video.h"
 #include "vesa.h"
 
-/*
- * Mode list variables
- */
-static struct card_info cards[];    /* List of cards to probe for */
-
-/*
- * Common variables
- */
-int adapter;			/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
-u16 video_segment;
-int force_x, force_y;	/* Don't query the BIOS for cols/rows */
-
-int do_restore = 0;	/* Screen contents changed during mode flip */
-int graphic_mode;	/* Graphic mode with linear frame buffer */
-
 static void store_cursor_position(void)
 {
 	u16 curpos;
@@ -107,147 +92,6 @@ static void store_mode_params(void)
 	boot_params.screen_info.orig_video_lines = y;
 }
 
-/* Probe the video drivers and have them generate their mode lists. */
-static void probe_cards(int unsafe)
-{
-	struct card_info *card;
-	static u8 probed[2];
-
-	if (probed[unsafe])
-		return;
-
-	probed[unsafe] = 1;
-
-	for (card = video_cards; card < video_cards_end; card++) {
-		if (card->unsafe == unsafe) {
-			if (card->probe)
-				card->nmodes = card->probe();
-			else
-				card->nmodes = 0;
-		}
-	}
-}
-
-/* Test if a mode is defined */
-int mode_defined(u16 mode)
-{
-	struct card_info *card;
-	struct mode_info *mi;
-	int i;
-
-	for (card = video_cards; card < video_cards_end; card++) {
-		mi = card->modes;
-		for (i = 0; i < card->nmodes; i++, mi++) {
-			if (mi->mode == mode)
-				return 1;
-		}
-	}
-
-	return 0;
-}
-
-/* Set mode (without recalc) */
-static int raw_set_mode(u16 mode, u16 *real_mode)
-{
-	int nmode, i;
-	struct card_info *card;
-	struct mode_info *mi;
-
-	/* Drop the recalc bit if set */
-	mode &= ~VIDEO_RECALC;
-
-	/* Scan for mode based on fixed ID, position, or resolution */
-	nmode = 0;
-	for (card = video_cards; card < video_cards_end; card++) {
-		mi = card->modes;
-		for (i = 0; i < card->nmodes; i++, mi++) {
-			int visible = mi->x || mi->y;
-
-			if ((mode == nmode && visible) ||
-			    mode == mi->mode ||
-			    mode == (mi->y << 8)+mi->x) {
-				*real_mode = mi->mode;
-				return card->set_mode(mi);
-			}
-
-			if (visible)
-				nmode++;
-		}
-	}
-
-	/* Nothing found?  Is it an "exceptional" (unprobed) mode? */
-	for (card = video_cards; card < video_cards_end; card++) {
-		if (mode >= card->xmode_first &&
-		    mode < card->xmode_first+card->xmode_n) {
-			struct mode_info mix;
-			*real_mode = mix.mode = mode;
-			mix.x = mix.y = 0;
-			return card->set_mode(&mix);
-		}
-	}
-
-	/* Otherwise, failure... */
-	return -1;
-}
-
-/*
- * Recalculate the vertical video cutoff (hack!)
- */
-static void vga_recalc_vertical(void)
-{
-	unsigned int font_size, rows;
-	u16 crtc;
-	u8 pt, ov;
-
-	set_fs(0);
-	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
-	rows = force_y ? force_y : rdfs8(0x484)+1; /* Text rows */
-
-	rows *= font_size;	/* Visible scan lines */
-	rows--;			/* ... minus one */
-
-	crtc = vga_crtc();
-
-	pt = in_idx(crtc, 0x11);
-	pt &= ~0x80;		/* Unlock CR0-7 */
-	out_idx(pt, crtc, 0x11);
-
-	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
-
-	ov = in_idx(crtc, 0x07); /* Overflow register */
-	ov &= 0xbd;
-	ov |= (rows >> (8-1)) & 0x02;
-	ov |= (rows >> (9-6)) & 0x40;
-	out_idx(ov, crtc, 0x07);
-}
-
-/* Set mode (with recalc if specified) */
-static int set_mode(u16 mode)
-{
-	int rv;
-	u16 real_mode;
-
-	/* Very special mode numbers... */
-	if (mode == VIDEO_CURRENT_MODE)
-		return 0;	/* Nothing to do... */
-	else if (mode == NORMAL_VGA)
-		mode = VIDEO_80x25;
-	else if (mode == EXTENDED_VGA)
-		mode = VIDEO_8POINT;
-
-	rv = raw_set_mode(mode, &real_mode);
-	if (rv)
-		return rv;
-
-	if (mode & VIDEO_RECALC)
-		vga_recalc_vertical();
-
-	/* Save the canonical mode number for the kernel, not
-	   an alias, size specification or menu position */
-	boot_params.hdr.vid_mode = real_mode;
-	return 0;
-}
-
 static unsigned int get_entry(void)
 {
 	char entry_buf[4];
@@ -486,6 +330,7 @@ void set_video(void)
 		printf("Undefined video mode number: %x\n", mode);
 		mode = ASK_VGA;
 	}
+	boot_params.hdr.vid_mode = mode;
 	vesa_store_edid();
 	store_mode_params();
 
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 19d3d6e..aff42de 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,7 +1,14 @@
+subdir-				:= realmode
+
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_rm.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
 endif
 
+$(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
+       
+$(obj)/realmode/wakeup.bin: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/realmode $@
+
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
new file mode 100644
index 0000000..2eb0e90
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -0,0 +1,55 @@
+#
+# arch/x86/kernel/acpi/rm/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+targets		:= wakeup.bin wakeup.elf
+
+wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
+
+# The link order of the video-*.o modules can matter.  In particular,
+# video-vga.o *must* be listed first, followed by video-vesa.o.
+# Hardware-specific drivers should follow in the order they should be
+# probed, and video-bios.o should typically be last.
+wakeup-y	+= video-vga.o
+wakeup-y	+= video-vesa.o
+wakeup-y	+= video-bios.o
+
+targets		+= $(wakeup-y)
+
+bootsrc		:= $(src)/../../../boot
+
+# ---------------------------------------------------------------------------
+
+# How to compile the 16-bit code.  Note we always compile for -march=i386,
+# that way we can complain to the user if the CPU is insufficient.
+# Compile with _SETUP since this is similar to the boot-time setup code.
+cflags-$(CONFIG_X86_32) :=
+cflags-$(CONFIG_X86_64) := -m32
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
+		   -I$(srctree)/$(bootsrc) \
+		   $(cflags-y) \
+		   -Wall -Wstrict-prototypes \
+		   -march=i386 -mregparm=3 \
+		   -include $(srctree)/$(bootsrc)/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+
+WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
+
+LDFLAGS_wakeup.elf	:= -T
+$(obj)/wakeup.elf: $(src)/wakeup.ld $(WAKEUP_OBJS) FORCE
+	$(call if_changed,ld)
+
+OBJCOPYFLAGS_wakeup.bin	:= -O binary
+
+$(obj)/wakeup.bin: $(obj)/wakeup.elf FORCE
+	$(call if_changed,objcopy)
diff --git a/arch/x86/kernel/acpi/realmode/copy.S b/arch/x86/kernel/acpi/realmode/copy.S
new file mode 100644
index 0000000..dc59ebe
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/copy.S
@@ -0,0 +1 @@
+#include "../../../boot/copy.S"
diff --git a/arch/x86/kernel/acpi/realmode/video-bios.c b/arch/x86/kernel/acpi/realmode/video-bios.c
new file mode 100644
index 0000000..7deabc1
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/video-bios.c
@@ -0,0 +1 @@
+#include "../../../boot/video-bios.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-mode.c b/arch/x86/kernel/acpi/realmode/video-mode.c
new file mode 100644
index 0000000..328ad20
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/video-mode.c
@@ -0,0 +1 @@
+#include "../../../boot/video-mode.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-vesa.c b/arch/x86/kernel/acpi/realmode/video-vesa.c
new file mode 100644
index 0000000..9dbb967
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/video-vesa.c
@@ -0,0 +1 @@
+#include "../../../boot/video-vesa.c"
diff --git a/arch/x86/kernel/acpi/realmode/video-vga.c b/arch/x86/kernel/acpi/realmode/video-vga.c
new file mode 100644
index 0000000..bcc8125
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/video-vga.c
@@ -0,0 +1 @@
+#include "../../../boot/video-vga.c"
diff --git a/arch/x86/kernel/acpi/realmode/wakemain.c b/arch/x86/kernel/acpi/realmode/wakemain.c
new file mode 100644
index 0000000..10673aa
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/wakemain.c
@@ -0,0 +1,26 @@
+#include "wakeup.h"
+#include "boot.h"
+
+extern volatile struct wakeup_header wakeup_header;
+
+void main(void)
+{
+	/* Kill machine if structures are wrong */
+	if (wakeup_header.real_magic != 0x12345678)
+		while(1);
+
+	if (wakeup_header.realmode_flags & 4) {
+		asm volatile("inb	$97, %al; 		outb	%al, $0x80; 		movb	$3, %al; 		outb	%al, $97; 		outb	%al, $0x80; 		movb	$-74, %al; 		outb	%al, $67; 		outb	%al, $0x80; 		movb	$-119, %al; 		outb	%al, $66; 		outb	%al, $0x80; 		movb	$15, %al; 		outb	%al, $66");
+	}
+
+	if (wakeup_header.realmode_flags & 1) {
+		asm volatile("lcallw   $0xc000,$3");
+//		("movw    %cs, %ax;	movw    %ax, %ds;	movw	%ax, %es; movw    %ax, %ss");
+	}
+
+	if (wakeup_header.realmode_flags & 2) {
+		/* Need to call BIOS */
+		probe_cards(0);
+		set_mode(wakeup_header.video_mode);
+	}
+}
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
new file mode 100644
index 0000000..bddceb9
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -0,0 +1,124 @@
+/*
+ * ACPI wakeup real mode startup stub
+ */
+#include <asm/segment.h>
+#include <asm/msr-index.h>
+#include <asm/page_64.h>
+#include <asm/pgtable_64.h>
+
+	.code16
+	.section ".header", "a"
+
+/* This should match the structure in wakeup.h */
+		.globl	wakeup_header
+wakeup_header:
+entry:		.short	_start	/* unused */
+total:		.short	_end	/* unused */
+video_mode:	.short	0	/* Video mode number */
+pmode_return:	.byte	0x66, 0xea	/* ljmpl */
+		.long	0		/* offset goes here */
+		.short	__KERNEL_CS
+pmode_cr0:	.long	0		/* Saved %cr0 */
+pmode_cr3:	.long	0		/* Saved %cr3 */
+pmode_cr4:	.long	0		/* Saved %cr4 */
+pmode_efer:	.quad	0		/* Saved EFER */
+pmode_gdt:	.quad	0
+realmode_flags:	.long	0
+real_magic:	.long	0
+trampoline_segment:	.word 0
+signature:	.long	0x51ee1111
+
+	.text
+	.globl	_start
+	.code16
+wakeup_code:
+_start:
+	cli
+	cld
+
+	/* Set up segments */
+	movw	%cs,%ax
+	movw	%ax,%ds
+	movw	%ax,%es
+	movw	%ax,%ss
+
+	movl	$wakeup_stack_end, %esp
+
+	/* Clear the EFLAGS */
+	pushl	$0
+	popfl
+
+	/* Check header signature... */
+	movl	signature, %eax
+	cmpl	$0x51ee1111, %eax
+	jne	bogus_real_magic
+
+	/* Check we really have everything... */
+	movl	end_signature, %eax
+	cmpl	$0x65a22c82, %eax
+	jne	bogus_real_magic
+
+	/* Zero the bss */
+	xorl	%eax, %eax
+	movw	$__bss_start, %di
+	movw	$__bss_end+3, %cx
+	subw	%di, %cx
+	shrw	$2, %cx
+	rep; stosl
+
+	/* Call the C code */
+	calll	main
+
+	/* Do any other stuff... */
+	
+#ifndef CONFIG_64BIT
+	/* This could also be done in C code... */
+	movl	pmode_cr3, %eax
+	movl	%eax, %cr3
+
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
+1:
+	movl	pmode_efer, %eax
+	movl	pmode_efer+4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
+	movl	$0xc0000080, %ecx
+	wrmsr
+1:
+
+	lgdtl	pmode_gdt
+
+	/* This really couldn't... */
+	movl	pmode_cr0, %eax
+	movl	%eax, %cr0
+	jmp	pmode_return
+#else
+	pushw	$0
+	pushw	trampoline_segment
+	pushw	$0
+	lret	
+#endif
+
+bogus_real_magic:
+1:
+	hlt
+	jmp	1b
+	
+	.data
+	.balign	4
+	.globl	HEAP, heap_end
+HEAP:
+	.long	wakeup_heap
+heap_end:
+	.long	wakeup_stack
+
+	.bss
+wakeup_heap:
+	.space	2048
+wakeup_stack:
+	.space	2048
+wakeup_stack_end:
+
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
new file mode 100644
index 0000000..4a26e27
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -0,0 +1,31 @@
+/*
+ * Definitions for the wakeup data structure at the head of the
+ * wakeup code.
+ */
+
+#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
+#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
+
+#include <linux/types.h>
+
+/* This must match data at wakeup.S */
+struct wakeup_header {
+	u16 entry;		/* unused */
+	u16 total;		/* unused */
+	u16 video_mode;		/* Video mode number */
+	u16 _jmp1;
+	u32 pmode_entry;	/* Protected mode resume point */
+	u16 _jmp2;
+	u32 pmode_cr0;		/* Protected mode cr0 */
+	u32 pmode_cr3;		/* Protected mode cr3 */
+	u32 pmode_cr4;		/* Protected mode cr4 */
+	u32 pmode_efer_low;	/* Protected mode EFER */
+	u32 pmode_efer_high;
+	u64 pmode_gdt;
+	u32 realmode_flags;
+	u32 real_magic;
+	u16 trampoline_segment;
+	u32 signature;		/* To check we have correct structure */
+} __attribute__((__packed__));
+
+#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.ld b/arch/x86/kernel/acpi/realmode/wakeup.ld
new file mode 100644
index 0000000..5dff2f0
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/wakeup.ld
@@ -0,0 +1,51 @@
+/*
+ * wakeup.ld
+ *
+ * Linker script for the real-mode wakeup code
+ */
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+ENTRY(_start)
+
+SECTIONS
+{
+	. = 0x3f00;
+	.header		: { *(.header) }
+
+	. = 0;
+	.text		: { *(.text*) }
+
+	. = ALIGN(16);
+	.rodata		: { *(.rodata*) }
+
+	.videocards	: {
+		video_cards = .;
+		*(.videocards)
+		video_cards_end = .;
+	}
+
+	. = ALIGN(16);
+	.data		: { *(.data*) }
+
+	.signature	: {
+		end_signature = .;
+		LONG(0x65a22c82)
+	}
+
+	. = ALIGN(16);
+	.bss		:
+	{
+		__bss_start = .;
+		*(.bss)
+		__bss_end = .;
+	}
+
+	. = ALIGN(16);
+	_end = .;
+
+	/DISCARD/ : { *(.note*) }
+
+	/* Adjust this as appropriate */
+	/* This allows 4 pages (16K) */
+	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
+}
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 6bc815c..1b282b1 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -11,29 +11,84 @@ #include <linux/dmi.h>
 #include <linux/cpumask.h>
 
 #include <asm/smp.h>
+#include "realmode/wakeup.h"
 
 /* address in low memory of the wakeup routine. */
-unsigned long acpi_wakeup_address = 0;
+static unsigned long acpi_realmode;
+unsigned long acpi_wakeup_address;
 unsigned long acpi_realmode_flags;
-extern char wakeup_start, wakeup_end;
 
+extern char wakeup_code_start, wakeup_code_end;
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
+extern unsigned long setup_trampoline(void);
+extern void wakeup_long64(void);
+
+extern unsigned long saved_video_mode;
+extern long saved_magic;
+extern volatile unsigned long init_rsp;
+extern void (*initial_code)(void);
+#ifndef CONFIG_64BIT
+extern int wakeup_pmode_return;
+extern char swsusp_pg_dir[PAGE_SIZE];
+#else
+static char temp_stack[10240];
+#endif
+
+extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
 
 /**
  * acpi_save_state_mem - save kernel state
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
+ *
+ * Note that this is too late to change acpi_wakeup_address.
  */
 int acpi_save_state_mem(void)
 {
-	if (!acpi_wakeup_address) {
-		printk(KERN_ERR "Could not allocate memory during boot, S3 disabled\n");
+	struct wakeup_header *header;
+
+	if (!acpi_realmode) {
+		printk(KERN_ERR "Could not allocate memory during boot, "
+		       "S3 disabled\n");
 		return -ENOMEM;
 	}
-	memcpy((void *)acpi_wakeup_address, &wakeup_start,
-	       &wakeup_end - &wakeup_start);
-	acpi_copy_wakeup_routine(acpi_wakeup_address);
+	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
+
+	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
+	if (header->signature != 0x51ee1111) {
+		printk(KERN_ERR "wakeup header does not match\n");
+		return -EINVAL;
+	}
+
+	header->video_mode = saved_video_mode;
+
+#ifndef CONFIG_64BIT
+	store_gdt(&header->pmode_gdt);
+
+	header->pmode_efer_low = nx_enabled;
+	if (header->pmode_efer_low & 1) {
+		/* This is strange, why not save efer, always? */
+		rdmsr(MSR_EFER, header->pmode_efer_low,
+			header->pmode_efer_high);
+	}
+#endif /* !CONFIG_64BIT */
+
+	header->pmode_cr0 = read_cr0();
+	header->pmode_cr4 = read_cr4();
+	header->realmode_flags = acpi_realmode_flags;
+	header->real_magic = 0x12345678;
+
+#ifndef CONFIG_64BIT
+	header->pmode_entry = &wakeup_pmode_return;
+	header->pmode_cr3 = swsusp_pg_dir - __PAGE_OFFSET;
+	saved_magic = 0x12345678;
+#else /* CONFIG_64BIT */
+	header->trampoline_segment = setup_trampoline() >> 4;
+	init_rsp = (unsigned long)temp_stack + 4096;
+	initial_code = wakeup_long64;
+	saved_magic = 0x123456789abcdef0;
+#endif /* CONFIG_64BIT */
 
 	return 0;
 }
@@ -56,15 +111,20 @@ void acpi_restore_state_mem(void)
  */
 void __init acpi_reserve_bootmem(void)
 {
-	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE*2) {
+	if ((&wakeup_code_end - &wakeup_code_start) > PAGE_SIZE*4) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
-	if (!acpi_wakeup_address)
+	acpi_realmode = (unsigned long)alloc_bootmem_low(PAGE_SIZE*4);
+
+	if (!acpi_realmode) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
+		return;
+	}
+
+	acpi_wakeup_address = acpi_realmode;
 }
 
 
diff --git a/arch/x86/kernel/acpi/wakeup.S b/arch/x86/kernel/acpi/wakeup.S
new file mode 100644
index 0000000..6157603
--- /dev/null
+++ b/arch/x86/kernel/acpi/wakeup.S
@@ -0,0 +1 @@
+# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index f53e327..ca9cac2 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -3,178 +3,14 @@ #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 
-#
-# wakeup_code runs in real mode, and at unknown address (determined at run-time).
-# Therefore it must only use relative jumps/calls. 
-#
-# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
-#
-# If physical address of wakeup_code is 0x12345, BIOS should call us with
-# cs = 0x1234, eip = 0x05
-#
+# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 
-#define BEEP \
-	inb	$97, %al; 	\
-	outb	%al, $0x80; 	\
-	movb	$3, %al; 	\
-	outb	%al, $97; 	\
-	outb	%al, $0x80; 	\
-	movb	$-74, %al; 	\
-	outb	%al, $67; 	\
-	outb	%al, $0x80; 	\
-	movb	$-119, %al; 	\
-	outb	%al, $66; 	\
-	outb	%al, $0x80; 	\
-	movb	$15, %al; 	\
-	outb	%al, $66;
-
-ALIGN
-	.align	4096
-ENTRY(wakeup_start)
-wakeup_code:
-	wakeup_code_start = .
-	.code16
-
-	cli
-	cld
-
-	# setup data segment
-	movw	%cs, %ax
-	movw	%ax, %ds					# Make ds:0 point to wakeup_start
-	movw	%ax, %ss
-
-	testl   $4, realmode_flags - wakeup_code
-	jz      1f
-	BEEP
-1:
-	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
-
-	pushl	$0						# Kill any dangerous flags
-	popfl
-
-	movl	real_magic - wakeup_code, %eax
-	cmpl	$0x12345678, %eax
-	jne	bogus_real_magic
-
-	testl	$1, realmode_flags - wakeup_code
-	jz	1f
-	lcall   $0xc000,$3
-	movw	%cs, %ax
-	movw	%ax, %ds					# Bios might have played with that
-	movw	%ax, %ss
-1:
-
-	testl	$2, realmode_flags - wakeup_code
-	jz	1f
-	mov	video_mode - wakeup_code, %ax
-	call	mode_set
-1:
-
-	# set up page table
-	movl	$swsusp_pg_dir-__PAGE_OFFSET, %eax
-	movl	%eax, %cr3
-
-	testl	$1, real_efer_save_restore - wakeup_code
-	jz	4f
-	# restore efer setting
-	movl	real_save_efer_edx - wakeup_code, %edx
-	movl	real_save_efer_eax - wakeup_code, %eax
-	mov     $0xc0000080, %ecx
-	wrmsr
-4:
-	# make sure %cr4 is set correctly (features, etc)
-	movl	real_save_cr4 - wakeup_code, %eax
-	movl	%eax, %cr4
-	
-	# need a gdt -- use lgdtl to force 32-bit operands, in case
-	# the GDT is located past 16 megabytes.
-	lgdtl	real_save_gdt - wakeup_code
-
-	movl	real_save_cr0 - wakeup_code, %eax
-	movl	%eax, %cr0
-	jmp 1f
-1:
-	movl	real_magic - wakeup_code, %eax
-	cmpl	$0x12345678, %eax
-	jne	bogus_real_magic
-
-	testl   $8, realmode_flags - wakeup_code
-	jz      1f
-	BEEP
-1:
-	ljmpl	$__KERNEL_CS, $wakeup_pmode_return
-
-real_save_gdt:	.word 0
-		.long 0
-real_save_cr0:	.long 0
-real_save_cr3:	.long 0
-real_save_cr4:	.long 0
-real_magic:	.long 0
-video_mode:	.long 0
-realmode_flags:	.long 0
-real_efer_save_restore:	.long 0
-real_save_efer_edx: 	.long 0
-real_save_efer_eax: 	.long 0
-
-bogus_real_magic:
-	jmp bogus_real_magic
-
-/* This code uses an extended set of video mode numbers. These include:
- * Aliases for standard modes
- *	NORMAL_VGA (-1)
- *	EXTENDED_VGA (-2)
- *	ASK_VGA (-3)
- * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
- * of compatibility when extending the table. These are between 0x00 and 0xff.
- */
-#define VIDEO_FIRST_MENU 0x0000
-
-/* Standard BIOS video modes (BIOS number + 0x0100) */
-#define VIDEO_FIRST_BIOS 0x0100
-
-/* VESA BIOS video modes (VESA number + 0x0200) */
-#define VIDEO_FIRST_VESA 0x0200
-
-/* Video7 special modes (BIOS number + 0x0900) */
-#define VIDEO_FIRST_V7 0x0900
-
-# Setting of user mode (AX=mode ID) => CF=success
-
-# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
-# modes, we should probably compile in the video code from the boot
-# directory.
-mode_set:
-	movw	%ax, %bx
-	subb	$VIDEO_FIRST_VESA>>8, %bh
-	cmpb	$2, %bh
-	jb	check_vesa
-
-setbad:
-	clc
-	ret
-
-check_vesa:
-	orw	$0x4000, %bx			# Use linear frame buffer
-	movw	$0x4f02, %ax			# VESA BIOS mode set call
-	int	$0x10
-	cmpw	$0x004f, %ax			# AL=4f if implemented
-	jnz	setbad				# AH=0 if OK
-
-	stc
-	ret
+#include "wakeup.S"
 
 	.code32
 	ALIGN
 
-.org	0x800
-wakeup_stack_begin:	# Stack grows down
-
-.org	0xff0		# Just below end of page
-wakeup_stack:
-ENTRY(wakeup_end)
-	
-.org	0x1000
-
+ENTRY(wakeup_pmode_return)
 wakeup_pmode_return:
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss
@@ -208,56 +44,13 @@ bogus_magic:
 	jmp	bogus_magic
 
 
-##
-# acpi_copy_wakeup_routine
-#
-# Copy the above routine to low memory.
-#
-# Parameters:
-# %eax:	place to copy wakeup routine to
-#
-# Returned address is location of code in low memory (past data and stack)
-#
-ENTRY(acpi_copy_wakeup_routine)
 
-	pushl	%ebx
+save_registers:
 	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
 	str	saved_tss
-
-	movl	nx_enabled, %edx
-	movl	%edx, real_efer_save_restore - wakeup_start (%eax)
-	testl	$1, real_efer_save_restore - wakeup_start (%eax)
-	jz	2f
-	# save efer setting
-	pushl	%eax
-	movl	%eax, %ebx
-	mov     $0xc0000080, %ecx
-	rdmsr
-	movl	%edx, real_save_efer_edx - wakeup_start (%ebx)
-	movl	%eax, real_save_efer_eax - wakeup_start (%ebx)
-	popl	%eax
-2:
-
-	movl    %cr3, %edx
-	movl    %edx, real_save_cr3 - wakeup_start (%eax)
-	movl    %cr4, %edx
-	movl    %edx, real_save_cr4 - wakeup_start (%eax)
-	movl	%cr0, %edx
-	movl	%edx, real_save_cr0 - wakeup_start (%eax)
-	sgdt    real_save_gdt - wakeup_start (%eax)
-
-	movl	saved_videomode, %edx
-	movl	%edx, video_mode - wakeup_start (%eax)
-	movl	acpi_realmode_flags, %edx
-	movl	%edx, realmode_flags - wakeup_start (%eax)
-	movl	$0x12345678, real_magic - wakeup_start (%eax)
-	movl	$0x12345678, saved_magic
-	popl	%ebx
-	ret
-
-save_registers:
+	
 	leal	4(%esp), %eax
 	movl	%eax, saved_context_esp
 	movl %ebx, saved_context_ebx
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 2e1b9e0..7be7609 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -7,191 +7,23 @@ #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
-#
-# wakeup_code runs in real mode, and at unknown address (determined at run-time).
-# Therefore it must only use relative jumps/calls. 
-#
-# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
-#
-# If physical address of wakeup_code is 0x12345, BIOS should call us with
-# cs = 0x1234, eip = 0x05
-#
 
-#define BEEP \
-	inb	$97, %al; 	\
-	outb	%al, $0x80; 	\
-	movb	$3, %al; 	\
-	outb	%al, $97; 	\
-	outb	%al, $0x80; 	\
-	movb	$-74, %al; 	\
-	outb	%al, $67; 	\
-	outb	%al, $0x80; 	\
-	movb	$-119, %al; 	\
-	outb	%al, $66; 	\
-	outb	%al, $0x80; 	\
-	movb	$15, %al; 	\
-	outb	%al, $66;
+#include "wakeup.S"
 
-
-ALIGN
-	.align	16
-ENTRY(wakeup_start)
-wakeup_code:
-	wakeup_code_start = .
-	.code16
-
-# Running in *copy* of this code, somewhere in low 1MB.
-
-	cli
-	cld
-	# setup data segment
-	movw	%cs, %ax
-	movw	%ax, %ds		# Make ds:0 point to wakeup_start
-	movw	%ax, %ss
-
-	# Data segment must be set up before we can see whether to beep.
-	testl   $4, realmode_flags - wakeup_code
-	jz      1f
-	BEEP
-1:
-
-					# Private stack is needed for ASUS board
-	mov	$(wakeup_stack - wakeup_code), %sp
-
-	pushl	$0			# Kill any dangerous flags
-	popfl
-
-	movl	real_magic - wakeup_code, %eax
-	cmpl	$0x12345678, %eax
-	jne	bogus_real_magic
-
-	testl	$1, realmode_flags - wakeup_code
-	jz	1f
-	lcall   $0xc000,$3
-	movw	%cs, %ax
-	movw	%ax, %ds		# Bios might have played with that
-	movw	%ax, %ss
-1:
-
-	testl	$2, realmode_flags - wakeup_code
-	jz	1f
-	mov	video_mode - wakeup_code, %ax
-	call	mode_set
-1:
-
-	mov	%ds, %ax			# Find 32bit wakeup_code addr
-	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
-	shll    $4, %esi
-						# Fix up the vectors
-	addl    %esi, wakeup_32_vector - wakeup_code
-	addl    %esi, wakeup_long64_vector - wakeup_code
-	addl    %esi, gdt_48a + 2 - wakeup_code # Fixup the gdt pointer
-
-	lidtl	%ds:idt_48a - wakeup_code
-	lgdtl	%ds:gdt_48a - wakeup_code	# load gdt with whatever is
-						# appropriate
-
-	movl	$1, %eax			# protected mode (PE) bit
-	lmsw	%ax				# This is it!
-	jmp	1f
-1:
-
-	ljmpl   *(wakeup_32_vector - wakeup_code)
-
-	.balign 4
-wakeup_32_vector:
-	.long   wakeup_32 - wakeup_code
-	.word   __KERNEL32_CS, 0
-
-	.code32
-wakeup_32:
 # Running in this code, but at low address; paging is not yet turned on.
 
-	movl	$__KERNEL_DS, %eax
-	movl	%eax, %ds
-
-	/*
-	 * Prepare for entering 64bits mode
-	 */
-
-	/* Enable PAE */
-	xorl	%eax, %eax
-	btsl	$5, %eax
-	movl	%eax, %cr4
-
-	/* Setup early boot stage 4 level pagetables */
-	leal    (wakeup_level4_pgt - wakeup_code)(%esi), %eax
-	movl	%eax, %cr3
-
-        /* Check if nx is implemented */
-        movl    $0x80000001, %eax
-        cpuid
-        movl    %edx,%edi
-
-	/* Enable Long Mode */
-	xorl    %eax, %eax
-	btsl	$_EFER_LME, %eax
-
-	/* No Execute supported? */
-	btl	$20,%edi
-	jnc     1f
-	btsl	$_EFER_NX, %eax
-				
-	/* Make changes effective */
-1:	movl    $MSR_EFER, %ecx
-	xorl    %edx, %edx
-	wrmsr
-
-	xorl	%eax, %eax
-	btsl	$31, %eax			/* Enable paging and in turn activate Long Mode */
-	btsl	$0, %eax			/* Enable protected mode */
-
-	/* Make changes effective */
-	movl	%eax, %cr0
-
-	/* At this point:
-		CR4.PAE must be 1
-		CS.L must be 0
-		CR3 must point to PML4
-		Next instruction must be a branch
-		This must be on identity-mapped page
-	*/
-	/*
-	 * At this point we're in long mode but in 32bit compatibility mode
-	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
-	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we load
-	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
-	 */
-
-	/* Finally jump in 64bit mode */
-        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
-
-	.balign 4
-wakeup_long64_vector:
-	.long   wakeup_long64 - wakeup_code
-	.word   __KERNEL_CS, 0
-
 .code64
 
 	/* Hooray, we are in Long 64-bit mode (but still running in
 	 * low memory)
 	 */
+ENTRY(wakeup_long64)
 wakeup_long64:
-	/*
-	 * We must switch to a new descriptor in kernel space for the GDT
-	 * because soon the kernel won't have access anymore to the userspace
-	 * addresses where we're currently running on. We have to do that here
-	 * because in 32bit we couldn't load a 64bit linear address.
-	 */
-	lgdt	cpu_gdt_descr
-
 	movq    saved_magic, %rax
 	movq    $0x123456789abcdef0, %rdx
 	cmpq    %rdx, %rax
 	jne     bogus_64_magic
 
-	nop
-	nop
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss	
 	movw	%ax, %ds
@@ -208,131 +40,9 @@ wakeup_long64:
 	movq	saved_rip, %rax
 	jmp	*%rax
 
-.code32
-
-	.align	64	
-gdta:
-	/* Its good to keep gdt in sync with one in trampoline.S */
-	.word	0, 0, 0, 0			# dummy
-	/* ??? Why I need the accessed bit set in order for this to work? */
-	.quad   0x00cf9b000000ffff              # __KERNEL32_CS
-	.quad   0x00af9b000000ffff              # __KERNEL_CS
-	.quad   0x00cf93000000ffff              # __KERNEL_DS
-
-idt_48a:
-	.word	0				# idt limit = 0
-	.word	0, 0				# idt base = 0L
-
-gdt_48a:
-	.word	0x800				# gdt limit=2048,
-						#  256 GDT entries
-	.long   gdta - wakeup_code              # gdt base (relocated in later)
-	
-real_magic:	.quad 0
-video_mode:	.quad 0
-realmode_flags:	.quad 0
-
-.code16
-bogus_real_magic:
-	jmp bogus_real_magic
-
-.code64
 bogus_64_magic:
 	jmp bogus_64_magic
 
-/* This code uses an extended set of video mode numbers. These include:
- * Aliases for standard modes
- *	NORMAL_VGA (-1)
- *	EXTENDED_VGA (-2)
- *	ASK_VGA (-3)
- * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
- * of compatibility when extending the table. These are between 0x00 and 0xff.
- */
-#define VIDEO_FIRST_MENU 0x0000
-
-/* Standard BIOS video modes (BIOS number + 0x0100) */
-#define VIDEO_FIRST_BIOS 0x0100
-
-/* VESA BIOS video modes (VESA number + 0x0200) */
-#define VIDEO_FIRST_VESA 0x0200
-
-/* Video7 special modes (BIOS number + 0x0900) */
-#define VIDEO_FIRST_V7 0x0900
-
-# Setting of user mode (AX=mode ID) => CF=success
-
-# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
-# modes, we should probably compile in the video code from the boot
-# directory.
-.code16
-mode_set:
-	movw	%ax, %bx
-	subb	$VIDEO_FIRST_VESA>>8, %bh
-	cmpb	$2, %bh
-	jb	check_vesa
-
-setbad:
-	clc
-	ret
-
-check_vesa:
-	orw	$0x4000, %bx			# Use linear frame buffer
-	movw	$0x4f02, %ax			# VESA BIOS mode set call
-	int	$0x10
-	cmpw	$0x004f, %ax			# AL=4f if implemented
-	jnz	setbad				# AH=0 if OK
-
-	stc
-	ret
-
-wakeup_stack_begin:	# Stack grows down
-
-.org	0xff0
-wakeup_stack:		# Just below end of page
-
-.org   0x1000
-ENTRY(wakeup_level4_pgt)
-	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill   510,8,0
-	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
-	.quad   level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-
-ENTRY(wakeup_end)
-	
-##
-# acpi_copy_wakeup_routine
-#
-# Copy the above routine to low memory.
-#
-# Parameters:
-# %rdi:	place to copy wakeup routine to
-#
-# Returned address is location of code in low memory (past data and stack)
-#
-	.code64
-ENTRY(acpi_copy_wakeup_routine)
-	pushq	%rax
-	pushq	%rdx
-
-	movl	saved_video_mode, %edx
-	movl	%edx, video_mode - wakeup_start (,%rdi)
-	movl	acpi_realmode_flags, %edx
-	movl	%edx, realmode_flags - wakeup_start (,%rdi)
-	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
-	movq	$0x123456789abcdef0, %rdx
-	movq	%rdx, saved_magic
-
-	movq    saved_magic, %rax
-	movq    $0x123456789abcdef0, %rdx
-	cmpq    %rdx, %rax
-	jne     bogus_64_magic
-
-	# restore the regs we used
-	popq	%rdx
-	popq	%rax
-ENTRY(do_suspend_lowlevel_s4bios)
-	ret
-
 	.align 2
 	.p2align 4,,15
 .globl do_suspend_lowlevel
diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
new file mode 100644
index 0000000..17e2dc1
--- /dev/null
+++ b/arch/x86/kernel/acpi/wakeup_rm.S
@@ -0,0 +1,10 @@
+/*
+ * Wrapper script for the realmode binary as a transport object
+ * before copying to low memory.
+ */
+	.section ".rodata","a"
+	.globl	wakeup_code_start, wakeup_code_end
+wakeup_code_start:
+	.incbin	"arch/x86/kernel/acpi/rm/wakeup.bin"
+wakeup_code_end:
+	.size	wakeup_code_start, .-wakeup_code_start
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 1d5a7a3..668bcfb 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -127,10 +127,6 @@ #ifdef CONFIG_SMP
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
-#ifdef CONFIG_ACPI_SLEEP
-	addq	%rbp, wakeup_level4_pgt + 0(%rip)
-	addq	%rbp, wakeup_level4_pgt + (511*8)(%rip)
-#endif
 
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 62adc5f..da5f631 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -186,7 +186,7 @@ #endif
 extern void early_cpu_init(void);
 extern int root_mountflags;
 
-unsigned long saved_videomode;
+unsigned long saved_video_mode;
 
 #define RAMDISK_IMAGE_START_MASK	0x07FF
 #define RAMDISK_PROMPT_FLAG		0x8000
@@ -711,7 +711,7 @@ #endif
 	edid_info = boot_params.edid_info;
 	apm_info.bios = boot_params.apm_bios_info;
 	ist_info = boot_params.ist_info;
-	saved_videomode = boot_params.hdr.vid_mode;
+	saved_video_mode = boot_params.hdr.vid_mode;
 	if( boot_params.sys_desc_table.length != 0 ) {
 		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
 		machine_id = boot_params.sys_desc_table.table[0];
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index d53bd6f..ebb038e 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -132,7 +132,7 @@ #endif
  * has made sure it's suitably aligned.
  */
 
-static unsigned long __cpuinit setup_trampoline(void)
+unsigned long __cpuinit setup_trampoline(void)
 {
 	void *tramp = __va(SMP_TRAMPOLINE_BASE); 
 	memcpy(tramp, trampoline_data, trampoline_end - trampoline_data);
@@ -649,6 +649,9 @@ do_rest:
 	*((volatile unsigned short *) phys_to_virt(0x467)) = start_rip & 0xf;
 	Dprintk("3.\n");
 
+	/* Trampoline assumes it is at beggining of segment */
+	BUG_ON(start_rip & 0xf);
+
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
@@ -656,11 +659,6 @@ do_rest:
 	apic_read(APIC_ESR);
 
 	/*
-	 * Status is now clean
-	 */
-	boot_error = 0;
-
-	/*
 	 * Starting actual IPI sequence...
 	 */
 	boot_error = wakeup_secondary_via_INIT(apicid, start_rip);
diff --git a/arch/x86_64/kernel/acpi/wakeup.S b/arch/x86_64/kernel/acpi/wakeup.S
new file mode 100644
index 0000000..d0f40d9
--- /dev/null
+++ b/arch/x86_64/kernel/acpi/wakeup.S
@@ -0,0 +1,425 @@
+.text
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+#include <asm/msr.h>
+
+# Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
+#
+# wakeup_code runs in real mode, and at unknown address (determined at run-time).
+# Therefore it must only use relative jumps/calls. 
+#
+# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
+#
+# If physical address of wakeup_code is 0x12345, BIOS should call us with
+# cs = 0x1234, eip = 0x05
+#
+
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
+
+ALIGN
+	.align	16
+ENTRY(wakeup_start)
+wakeup_code:
+	wakeup_code_start = .
+	.code16
+
+# Running in *copy* of this code, somewhere in low 1MB.
+
+	cli
+	cld
+	# setup data segment
+	movw	%cs, %ax
+	movw	%ax, %ds		# Make ds:0 point to wakeup_start
+	movw	%ax, %ss
+
+	# Data segment must be set up before we can see whether to beep.
+	testl   $4, realmode_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+
+					# Private stack is needed for ASUS board
+	mov	$(wakeup_stack - wakeup_code), %sp
+
+	pushl	$0			# Kill any dangerous flags
+	popfl
+
+	movl	real_magic - wakeup_code, %eax
+	cmpl	$0x12345678, %eax
+	jne	bogus_real_magic
+
+	testl	$1, realmode_flags - wakeup_code
+	jz	1f
+	lcall   $0xc000,$3
+	movw	%cs, %ax
+	movw	%ax, %ds		# Bios might have played with that
+	movw	%ax, %ss
+1:
+
+	testl	$2, realmode_flags - wakeup_code
+	jz	1f
+	mov	video_mode - wakeup_code, %ax
+	call	mode_set
+1:
+
+	mov	%ds, %ax			# Find 32bit wakeup_code addr
+	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
+	shll    $4, %esi
+						# Fix up the vectors
+	addl    %esi, wakeup_32_vector - wakeup_code
+	addl    %esi, wakeup_long64_vector - wakeup_code
+	addl    %esi, gdt_48a + 2 - wakeup_code # Fixup the gdt pointer
+
+	lidtl	%ds:idt_48a - wakeup_code
+	lgdtl	%ds:gdt_48a - wakeup_code	# load gdt with whatever is
+						# appropriate
+
+	movl	$1, %eax			# protected mode (PE) bit
+	lmsw	%ax				# This is it!
+	jmp	1f
+1:
+
+	ljmpl   *(wakeup_32_vector - wakeup_code)
+
+	.balign 4
+wakeup_32_vector:
+	.long   wakeup_32 - wakeup_code
+	.word   __KERNEL32_CS, 0
+
+	.code32
+wakeup_32:
+# Running in this code, but at low address; paging is not yet turned on.
+
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+
+	/*
+	 * Prepare for entering 64bits mode
+	 */
+
+	/* Enable PAE */
+	xorl	%eax, %eax
+	btsl	$5, %eax
+	movl	%eax, %cr4
+
+	/* Setup early boot stage 4 level pagetables */
+	leal    (wakeup_level4_pgt - wakeup_code)(%esi), %eax
+	movl	%eax, %cr3
+
+        /* Check if nx is implemented */
+        movl    $0x80000001, %eax
+        cpuid
+        movl    %edx,%edi
+
+	/* Enable Long Mode */
+	xorl    %eax, %eax
+	btsl	$_EFER_LME, %eax
+
+	/* No Execute supported? */
+	btl	$20,%edi
+	jnc     1f
+	btsl	$_EFER_NX, %eax
+				
+	/* Make changes effective */
+1:	movl    $MSR_EFER, %ecx
+	xorl    %edx, %edx
+	wrmsr
+
+	xorl	%eax, %eax
+	btsl	$31, %eax			/* Enable paging and in turn activate Long Mode */
+	btsl	$0, %eax			/* Enable protected mode */
+
+	/* Make changes effective */
+	movl	%eax, %cr0
+
+	/* At this point:
+		CR4.PAE must be 1
+		CS.L must be 0
+		CR3 must point to PML4
+		Next instruction must be a branch
+		This must be on identity-mapped page
+	*/
+	/*
+	 * At this point we're in long mode but in 32bit compatibility mode
+	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
+	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we load
+	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
+	 */
+
+	/* Finally jump in 64bit mode */
+        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
+
+	.balign 4
+wakeup_long64_vector:
+	.long   wakeup_long64 - wakeup_code
+	.word   __KERNEL_CS, 0
+
+.code64
+
+	/* Hooray, we are in Long 64-bit mode (but still running in
+	 * low memory)
+	 */
+wakeup_long64:
+	/*
+	 * We must switch to a new descriptor in kernel space for the GDT
+	 * because soon the kernel won't have access anymore to the userspace
+	 * addresses where we're currently running on. We have to do that here
+	 * because in 32bit we couldn't load a 64bit linear address.
+	 */
+	lgdt	cpu_gdt_descr
+
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
+
+	nop
+	nop
+	movw	$__KERNEL_DS, %ax
+	movw	%ax, %ss	
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %fs
+	movw	%ax, %gs
+	movq	saved_rsp, %rsp
+
+	movq	saved_rbx, %rbx
+	movq	saved_rdi, %rdi
+	movq	saved_rsi, %rsi
+	movq	saved_rbp, %rbp
+
+	movq	saved_rip, %rax
+	jmp	*%rax
+
+.code32
+
+	.align	64	
+gdta:
+	/* Its good to keep gdt in sync with one in trampoline.S */
+	.word	0, 0, 0, 0			# dummy
+	/* ??? Why I need the accessed bit set in order for this to work? */
+	.quad   0x00cf9b000000ffff              # __KERNEL32_CS
+	.quad   0x00af9b000000ffff              # __KERNEL_CS
+	.quad   0x00cf93000000ffff              # __KERNEL_DS
+
+idt_48a:
+	.word	0				# idt limit = 0
+	.word	0, 0				# idt base = 0L
+
+gdt_48a:
+	.word	0x800				# gdt limit=2048,
+						#  256 GDT entries
+	.long   gdta - wakeup_code              # gdt base (relocated in later)
+	
+real_magic:	.quad 0
+video_mode:	.quad 0
+realmode_flags:	.quad 0
+
+.code16
+bogus_real_magic:
+	jmp bogus_real_magic
+
+.code64
+bogus_64_magic:
+	jmp bogus_64_magic
+
+	
+/* This code uses an extended set of video mode numbers. These include:
+ * Aliases for standard modes
+ *	NORMAL_VGA (-1)
+ *	EXTENDED_VGA (-2)
+ *	ASK_VGA (-3)
+ * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
+ * of compatibility when extending the table. These are between 0x00 and 0xff.
+ */
+#define VIDEO_FIRST_MENU 0x0000
+
+/* Standard BIOS video modes (BIOS number + 0x0100) */
+#define VIDEO_FIRST_BIOS 0x0100
+
+/* VESA BIOS video modes (VESA number + 0x0200) */
+#define VIDEO_FIRST_VESA 0x0200
+
+/* Video7 special modes (BIOS number + 0x0900) */
+#define VIDEO_FIRST_V7 0x0900
+
+# Setting of user mode (AX=mode ID) => CF=success
+
+# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
+# modes, we should probably compile in the video code from the boot
+# directory.
+.code16
+mode_set:
+	movw	%ax, %bx
+	subb	$VIDEO_FIRST_VESA>>8, %bh
+	cmpb	$2, %bh
+	jb	check_vesa
+
+setbad:
+	clc
+	ret
+
+check_vesa:
+	orw	$0x4000, %bx			# Use linear frame buffer
+	movw	$0x4f02, %ax			# VESA BIOS mode set call
+	int	$0x10
+	cmpw	$0x004f, %ax			# AL=4f if implemented
+	jnz	setbad				# AH=0 if OK
+
+	stc
+	ret
+
+wakeup_stack_begin:	# Stack grows down
+
+.org	0xff0
+wakeup_stack:		# Just below end of page
+
+.org   0x1000
+ENTRY(wakeup_level4_pgt)
+	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill   510,8,0
+	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
+	.quad   level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
+
+ENTRY(wakeup_end)
+	
+##
+# acpi_copy_wakeup_routine
+#
+# Copy the above routine to low memory.
+#
+# Parameters:
+# %rdi:	place to copy wakeup routine to
+#
+# Returned address is location of code in low memory (past data and stack)
+#
+	.code64
+ENTRY(acpi_copy_wakeup_routine)
+	pushq	%rax
+	pushq	%rdx
+
+	movl	saved_video_mode, %edx
+	movl	%edx, video_mode - wakeup_start (,%rdi)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (,%rdi)
+	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
+	movq	$0x123456789abcdef0, %rdx
+	movq	%rdx, saved_magic
+
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
+
+	# restore the regs we used
+	popq	%rdx
+	popq	%rax
+ENTRY(do_suspend_lowlevel_s4bios)
+	ret
+
+	.align 2
+	.p2align 4,,15
+.globl do_suspend_lowlevel
+	.type	do_suspend_lowlevel,@function
+do_suspend_lowlevel:
+.LFB5:
+	subq	$8, %rsp
+	xorl	%eax, %eax
+	call	save_processor_state
+
+	movq %rsp, saved_context_esp(%rip)
+	movq %rax, saved_context_eax(%rip)
+	movq %rbx, saved_context_ebx(%rip)
+	movq %rcx, saved_context_ecx(%rip)
+	movq %rdx, saved_context_edx(%rip)
+	movq %rbp, saved_context_ebp(%rip)
+	movq %rsi, saved_context_esi(%rip)
+	movq %rdi, saved_context_edi(%rip)
+	movq %r8,  saved_context_r08(%rip)
+	movq %r9,  saved_context_r09(%rip)
+	movq %r10, saved_context_r10(%rip)
+	movq %r11, saved_context_r11(%rip)
+	movq %r12, saved_context_r12(%rip)
+	movq %r13, saved_context_r13(%rip)
+	movq %r14, saved_context_r14(%rip)
+	movq %r15, saved_context_r15(%rip)
+	pushfq ; popq saved_context_eflags(%rip)
+
+	movq	$.L97, saved_rip(%rip)
+
+	movq %rsp,saved_rsp
+	movq %rbp,saved_rbp
+	movq %rbx,saved_rbx
+	movq %rdi,saved_rdi
+	movq %rsi,saved_rsi
+
+	addq	$8, %rsp
+	movl	$3, %edi
+	xorl	%eax, %eax
+	jmp	acpi_enter_sleep_state
+.L97:
+	.p2align 4,,7
+.L99:
+	.align 4
+	movl	$24, %eax
+	movw %ax, %ds
+	movq	saved_context+58(%rip), %rax
+	movq %rax, %cr4
+	movq	saved_context+50(%rip), %rax
+	movq %rax, %cr3
+	movq	saved_context+42(%rip), %rax
+	movq %rax, %cr2
+	movq	saved_context+34(%rip), %rax
+	movq %rax, %cr0
+	pushq saved_context_eflags(%rip) ; popfq
+	movq saved_context_esp(%rip), %rsp
+	movq saved_context_ebp(%rip), %rbp
+	movq saved_context_eax(%rip), %rax
+	movq saved_context_ebx(%rip), %rbx
+	movq saved_context_ecx(%rip), %rcx
+	movq saved_context_edx(%rip), %rdx
+	movq saved_context_esi(%rip), %rsi
+	movq saved_context_edi(%rip), %rdi
+	movq saved_context_r08(%rip), %r8
+	movq saved_context_r09(%rip), %r9
+	movq saved_context_r10(%rip), %r10
+	movq saved_context_r11(%rip), %r11
+	movq saved_context_r12(%rip), %r12
+	movq saved_context_r13(%rip), %r13
+	movq saved_context_r14(%rip), %r14
+	movq saved_context_r15(%rip), %r15
+
+	xorl	%eax, %eax
+	addq	$8, %rsp
+	jmp	restore_processor_state
+.LFE5:
+.Lfe5:
+	.size	do_suspend_lowlevel,.Lfe5-do_suspend_lowlevel
+	
+.data
+ALIGN
+ENTRY(saved_rbp)	.quad	0
+ENTRY(saved_rsi)	.quad	0
+ENTRY(saved_rdi)	.quad	0
+ENTRY(saved_rbx)	.quad	0
+
+ENTRY(saved_rip)	.quad	0
+ENTRY(saved_rsp)	.quad	0
+
+ENTRY(saved_magic)	.quad	0
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 485de13..56e09cf 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -170,7 +170,7 @@ static int acpi_pm_enter(suspend_state_t
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
-	/* ACPI 3.0 specs (P62) says that it's the responsabilty
+	/* ACPI 3.0 specs (P62) says that it's the responsibilty
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
 	 */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
