Return-Path: <linux-kernel-owner+w=401wt.eu-S937333AbZDIXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937333AbZDIXPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937269AbZDIXOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:14:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:54316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937257AbZDIXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:14:12 -0400
Date: Thu, 9 Apr 2009 23:13:47 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com, pavel@ucw.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl, pavel@ucw.cz
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the video code
Message-ID: <tip-cf06de7b9cdd3efee7a59dced1977b3c21d43732@git.kernel.org>
Git-Commit-ID: cf06de7b9cdd3efee7a59dced1977b3c21d43732
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:13:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf06de7b9cdd3efee7a59dced1977b3c21d43732
Gitweb:     http://git.kernel.org/tip/cf06de7b9cdd3efee7a59dced1977b3c21d43732
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:20:11 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:12 -0700

x86, setup: "glove box" BIOS interrupts in the video code

Impact: BIOS proofing

"Glove box" off BIOS interrupts in the video code.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>


---
 arch/x86/boot/video-bios.c |   27 ++++-----
 arch/x86/boot/video-vesa.c |  137 +++++++++++++++++++-------------------------
 arch/x86/boot/video-vga.c  |   95 +++++++++++++++++++------------
 arch/x86/boot/video.c      |   42 ++++++-------
 arch/x86/boot/video.h      |   14 -----
 5 files changed, 151 insertions(+), 164 deletions(-)

diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index 3fa979c..d660be4 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -29,21 +30,21 @@ static int bios_set_mode(struct mode_info *mi)
 
 static int set_bios_mode(u8 mode)
 {
-	u16 ax;
+	struct biosregs ireg, oreg;
 	u8 new_mode;
 
-	ax = mode;		/* AH=0x00 Set Video Mode */
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.al = mode;		/* AH=0x00 Set Video Mode */
+	intcall(0x10, &ireg, NULL);
 
-	ax = 0x0f00;		/* Get Current Video Mode */
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+
+	ireg.ah = 0x0f;		/* Get Current Video Mode */
+	intcall(0x10, &ireg, &oreg);
 
 	do_restore = 1;		/* Assume video contents were lost */
-	new_mode = ax & 0x7f;	/* Not all BIOSes are clean with the top bit */
+
+	/* Not all BIOSes are clean with the top bit */
+	new_mode = ireg.al & 0x7f;
 
 	if (new_mode == mode)
 		return 0;	/* Mode change OK */
@@ -53,10 +54,8 @@ static int set_bios_mode(u8 mode)
 		/* Mode setting failed, but we didn't end up where we
 		   started.  That's bad.  Try to revert to the original
 		   video mode. */
-		ax = boot_params.screen_info.orig_video_mode;
-		asm volatile(INT10
-			     : "+a" (ax)
-			     : : "ebx", "ecx", "edx", "esi", "edi");
+		ireg.ax = boot_params.screen_info.orig_video_mode;
+		intcall(0x10, &ireg, NULL);
 	}
 #endif
 	return -1;
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 4a58c8c..c700147 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -31,7 +32,7 @@ static inline void vesa_store_mode_params_graphics(void) {}
 static int vesa_probe(void)
 {
 #if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
-	u16 ax, cx, di;
+	struct biosregs ireg, oreg;
 	u16 mode;
 	addr_t mode_ptr;
 	struct mode_info *mi;
@@ -39,13 +40,12 @@ static int vesa_probe(void)
 
 	video_vesa.modes = GET_HEAP(struct mode_info, 0);
 
-	ax = 0x4f00;
-	di = (size_t)&vginfo;
-	asm(INT10
-	    : "+a" (ax), "+D" (di), "=m" (vginfo)
-	    : : "ebx", "ecx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f00;
+	ireg.di = (size_t)&vginfo;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f ||
+	if (ireg.ax != 0x004f ||
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
@@ -65,14 +65,12 @@ static int vesa_probe(void)
 
 		memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
-		ax = 0x4f01;
-		cx = mode;
-		di = (size_t)&vminfo;
-		asm(INT10
-		    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
-		    : : "ebx", "edx", "esi");
+		ireg.ax = 0x4f01;
+		ireg.cx = mode;
+		ireg.di = (size_t)&vminfo;
+		intcall(0x10, &ireg, &oreg);
 
-		if (ax != 0x004f)
+		if (ireg.ax != 0x004f)
 			continue;
 
 		if ((vminfo.mode_attr & 0x15) == 0x05) {
@@ -111,20 +109,19 @@ static int vesa_probe(void)
 
 static int vesa_set_mode(struct mode_info *mode)
 {
-	u16 ax, bx, cx, di;
+	struct biosregs ireg, oreg;
 	int is_graphic;
 	u16 vesa_mode = mode->mode - VIDEO_FIRST_VESA;
 
 	memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
-	ax = 0x4f01;
-	cx = vesa_mode;
-	di = (size_t)&vminfo;
-	asm(INT10
-	    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
-	    : : "ebx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f01;
+	ireg.cx = vesa_mode;
+	ireg.di = (size_t)&vminfo;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return -1;
 
 	if ((vminfo.mode_attr & 0x15) == 0x05) {
@@ -141,14 +138,12 @@ static int vesa_set_mode(struct mode_info *mode)
 	}
 
 
-	ax = 0x4f02;
-	bx = vesa_mode;
-	di = 0;
-	asm volatile(INT10
-		     : "+a" (ax), "+b" (bx), "+D" (di)
-		     : : "ecx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f02;
+	ireg.bx = vesa_mode;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return -1;
 
 	graphic_mode = is_graphic;
@@ -171,50 +166,45 @@ static int vesa_set_mode(struct mode_info *mode)
 /* Switch DAC to 8-bit mode */
 static void vesa_dac_set_8bits(void)
 {
+	struct biosregs ireg, oreg;
 	u8 dac_size = 6;
 
 	/* If possible, switch the DAC to 8-bit mode */
 	if (vginfo.capabilities & 1) {
-		u16 ax, bx;
-
-		ax = 0x4f08;
-		bx = 0x0800;
-		asm volatile(INT10
-			     : "+a" (ax), "+b" (bx)
-			     : : "ecx", "edx", "esi", "edi");
-
-		if (ax == 0x004f)
-			dac_size = bx >> 8;
+		initregs(&ireg);
+		ireg.ax = 0x4f08;
+		ireg.bh = 0x08;
+		intcall(0x10, &ireg, &oreg);
+		if (oreg.ax == 0x004f)
+			dac_size = oreg.bh;
 	}
 
 	/* Set the color sizes to the DAC size, and offsets to 0 */
-	boot_params.screen_info.red_size = dac_size;
+	boot_params.screen_info.red_size   = dac_size;
 	boot_params.screen_info.green_size = dac_size;
-	boot_params.screen_info.blue_size = dac_size;
-	boot_params.screen_info.rsvd_size = dac_size;
+	boot_params.screen_info.blue_size  = dac_size;
+	boot_params.screen_info.rsvd_size  = dac_size;
 
-	boot_params.screen_info.red_pos = 0;
-	boot_params.screen_info.green_pos = 0;
-	boot_params.screen_info.blue_pos = 0;
-	boot_params.screen_info.rsvd_pos = 0;
+	boot_params.screen_info.red_pos    = 0;
+	boot_params.screen_info.green_pos  = 0;
+	boot_params.screen_info.blue_pos   = 0;
+	boot_params.screen_info.rsvd_pos   = 0;
 }
 
 /* Save the VESA protected mode info */
 static void vesa_store_pm_info(void)
 {
-	u16 ax, bx, di, es;
+	struct biosregs ireg, oreg;
 
-	ax = 0x4f0a;
-	bx = di = 0;
-	asm("pushw %%es; "INT10"; movw %%es,%0; popw %%es"
-	    : "=d" (es), "+a" (ax), "+b" (bx), "+D" (di)
-	    : : "ecx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f0a;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return;
 
-	boot_params.screen_info.vesapm_seg = es;
-	boot_params.screen_info.vesapm_off = di;
+	boot_params.screen_info.vesapm_seg = oreg.es;
+	boot_params.screen_info.vesapm_off = oreg.di;
 }
 
 /*
@@ -252,7 +242,7 @@ static void vesa_store_mode_params_graphics(void)
 void vesa_store_edid(void)
 {
 #ifdef CONFIG_FIRMWARE_EDID
-	u16 ax, bx, cx, dx, di;
+	struct biosregs ireg, oreg;
 
 	/* Apparently used as a nonsense token... */
 	memset(&boot_params.edid_info, 0x13, sizeof boot_params.edid_info);
@@ -260,33 +250,26 @@ void vesa_store_edid(void)
 	if (vginfo.version < 0x0200)
 		return;		/* EDID requires VBE 2.0+ */
 
-	ax = 0x4f15;		/* VBE DDC */
-	bx = 0x0000;		/* Report DDC capabilities */
-	cx = 0;			/* Controller 0 */
-	di = 0;			/* ES:DI must be 0 by spec */
-
-	/* Note: The VBE DDC spec is different from the main VESA spec;
-	   we genuinely have to assume all registers are destroyed here. */
-
-	asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
-	    : "+a" (ax), "+b" (bx), "+c" (cx), "+D" (di)
-	    : : "esi", "edx");
+	initregs(&ireg);
+	ireg.ax = 0x4f15;		/* VBE DDC */
+	/* ireg.bx = 0x0000; */		/* Report DDC capabilities */
+	/* ireg.cx = 0;	*/		/* Controller 0 */
+	ireg.es = 0;			/* ES:DI must be 0 by spec */
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return;		/* No EDID */
 
 	/* BH = time in seconds to transfer EDD information */
 	/* BL = DDC level supported */
 
-	ax = 0x4f15;		/* VBE DDC */
-	bx = 0x0001;		/* Read EDID */
-	cx = 0;			/* Controller 0 */
-	dx = 0;			/* EDID block number */
-	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
-	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info),
-	      "+c" (cx), "+D" (di)
-	    : : "esi");
+	ireg.ax = 0x4f15;		/* VBE DDC */
+	ireg.bx = 0x0001;		/* Read EDID */
+	/* ireg.cx = 0; */		/* Controller 0 */
+	/* ireg.dx = 0;	*/		/* EDID block number */
+	ireg.es = ds();
+	ireg.di =(size_t)&boot_params.edid_info; /* (ES:)Pointer to block */
+	intcall(0x10, &ireg, &oreg);
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 9e0587a..8f8d827 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -39,30 +40,30 @@ static __videocard video_vga;
 /* Set basic 80x25 mode */
 static u8 vga_set_basic_mode(void)
 {
+	struct biosregs ireg, oreg;
 	u16 ax;
 	u8 rows;
 	u8 mode;
 
+	initregs(&ireg);
+
 #ifdef CONFIG_VIDEO_400_HACK
 	if (adapter >= ADAPTER_VGA) {
-		asm volatile(INT10
-			     : : "a" (0x1202), "b" (0x0030)
-			     : "ecx", "edx", "esi", "edi");
+		ireg.ax = 0x1202;
+		ireg.bx = 0x0030;
+		intcall(0x10, &ireg, NULL);
 	}
 #endif
 
 	ax = 0x0f00;
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
-
-	mode = (u8)ax;
+	intcall(0x10, &ireg, &oreg);
+	mode = oreg.al;
 
 	set_fs(0);
 	rows = rdfs8(0x484);	/* rows minus one */
 
 #ifndef CONFIG_VIDEO_400_HACK
-	if ((ax == 0x5003 || ax == 0x5007) &&
+	if ((oreg.ax == 0x5003 || oreg.ax == 0x5007) &&
 	    (rows == 0 || rows == 24))
 		return mode;
 #endif
@@ -71,10 +72,8 @@ static u8 vga_set_basic_mode(void)
 		mode = 3;
 
 	/* Set the mode */
-	ax = mode;
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+	ireg.ax = mode;		/* AH=0: set mode */
+	intcall(0x10, &ireg, NULL);
 	do_restore = 1;
 	return mode;
 }
@@ -82,43 +81,69 @@ static u8 vga_set_basic_mode(void)
 static void vga_set_8font(void)
 {
 	/* Set 8x8 font - 80x43 on EGA, 80x50 on VGA */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 8x8 font */
-	asm volatile(INT10 : : "a" (0x1112), "b" (0));
+	ireg.ax = 0x1112;
+	/* ireg.bl = 0; */
+	intcall(0x10, &ireg, NULL);
 
 	/* Use alternate print screen */
-	asm volatile(INT10 : : "a" (0x1200), "b" (0x20));
+	ireg.ax = 0x1200;
+	ireg.bl = 0x20;
+	intcall(0x10, &ireg, NULL);
 
 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x34;
+	intcall(0x10, &ireg, NULL);
 
 	/* Cursor is scan lines 6-7 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0607));
+	ireg.ax = 0x0100;
+	ireg.cx = 0x0607;
+	intcall(0x10, &ireg, NULL);
 }
 
 static void vga_set_14font(void)
 {
 	/* Set 9x14 font - 80x28 on VGA */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 9x14 font */
-	asm volatile(INT10 : : "a" (0x1111), "b" (0));
+	ireg.ax = 0x1111;
+	/* ireg.bl = 0; */
+	intcall(0x10, &ireg, NULL);
 
 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x34;
+	intcall(0x10, &ireg, NULL);
 
 	/* Cursor is scan lines 11-12 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0b0c));
+	ireg.ax = 0x0100;
+	ireg.cx = 0x0b0c;
+	intcall(0x10, &ireg, NULL);
 }
 
 static void vga_set_80x43(void)
 {
 	/* Set 80x43 mode on VGA (not EGA) */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 350 scans */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x30));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x30;
+	intcall(0x10, &ireg, NULL);
 
 	/* Reset video mode */
-	asm volatile(INT10 : : "a" (0x0003));
+	ireg.ax = 0x0003;
+	intcall(0x10, &ireg, NULL);
 
 	vga_set_8font();
 }
@@ -225,8 +250,6 @@ static int vga_set_mode(struct mode_info *mode)
  */
 static int vga_probe(void)
 {
-	u16 ega_bx;
-
 	static const char *card_name[] = {
 		"CGA/MDA/HGC", "EGA", "VGA"
 	};
@@ -240,26 +263,26 @@ static int vga_probe(void)
 		sizeof(ega_modes)/sizeof(struct mode_info),
 		sizeof(vga_modes)/sizeof(struct mode_info),
 	};
-	u8 vga_flag;
 
-	asm(INT10
-	    : "=b" (ega_bx)
-	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
-	    : "ecx", "edx", "esi", "edi");
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+
+	ireg.ax = 0x1200;
+	ireg.bl = 0x10;		/* Check EGA/VGA */
+	intcall(0x10, &ireg, &oreg);
 
 #ifndef _WAKEUP
-	boot_params.screen_info.orig_video_ega_bx = ega_bx;
+	boot_params.screen_info.orig_video_ega_bx = oreg.bx;
 #endif
 
 	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
-	if ((u8)ega_bx != 0x10) {
+	if (oreg.bl != 0x10) {
 		/* EGA/VGA */
-		asm(INT10
-		    : "=a" (vga_flag)
-		    : "a" (0x1a00)
-		    : "ebx", "ecx", "edx", "esi", "edi");
+		ireg.ax = 0x1a00;
+		intcall(0x10, &ireg, &oreg);
 
-		if (vga_flag == 0x1a) {
+		if (oreg.al == 0x1a) {
 			adapter = ADAPTER_VGA;
 #ifndef _WAKEUP
 			boot_params.screen_info.orig_video_isVGA = 1;
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index 3bef2c1..bad728b 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -18,33 +19,29 @@
 
 static void store_cursor_position(void)
 {
-	u16 curpos;
-	u16 ax, bx;
+	struct biosregs ireg, oreg;
 
-	ax = 0x0300;
-	bx = 0;
-	asm(INT10
-	    : "=d" (curpos), "+a" (ax), "+b" (bx)
-	    : : "ecx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x03;
+	intcall(0x10, &ireg, &oreg);
 
-	boot_params.screen_info.orig_x = curpos;
-	boot_params.screen_info.orig_y = curpos >> 8;
+	boot_params.screen_info.orig_x = oreg.dl;
+	boot_params.screen_info.orig_y = oreg.dh;
 }
 
 static void store_video_mode(void)
 {
-	u16 ax, page;
+	struct biosregs ireg, oreg;
 
 	/* N.B.: the saving of the video page here is a bit silly,
 	   since we pretty much assume page 0 everywhere. */
-	ax = 0x0f00;
-	asm(INT10
-	    : "+a" (ax), "=b" (page)
-	    : : "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x0f;
+	intcall(0x10, &ireg, &oreg);
 
 	/* Not all BIOSes are clean with respect to the top bit */
-	boot_params.screen_info.orig_video_mode = ax & 0x7f;
-	boot_params.screen_info.orig_video_page = page >> 8;
+	boot_params.screen_info.orig_video_mode = oreg.al & 0x7f;
+	boot_params.screen_info.orig_video_page = oreg.bh;
 }
 
 /*
@@ -257,7 +254,7 @@ static void restore_screen(void)
 	int y;
 	addr_t dst = 0;
 	u16 *src = saved.data;
-	u16 ax, bx, dx;
+	struct biosregs ireg;
 
 	if (graphic_mode)
 		return;		/* Can't restore onto a graphic mode */
@@ -296,12 +293,11 @@ static void restore_screen(void)
 	}
 
 	/* Restore cursor position */
-	ax = 0x0200;		/* Set cursor position */
-	bx = 0;			/* Page number (<< 8) */
-	dx = (saved.cury << 8)+saved.curx;
-	asm volatile(INT10
-		     : "+a" (ax), "+b" (bx), "+d" (dx)
-		     : : "ecx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x02;		/* Set cursor position */
+	ireg.dh = saved.cury;
+	ireg.dl = saved.curx;
+	intcall(0x10, &ireg, NULL);
 }
 #else
 #define save_screen()		((void)0)
diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index ee63f5d..5bb174a 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -112,20 +112,6 @@ extern int force_x, force_y;	/* Don't query the BIOS for cols/rows */
 extern int do_restore;		/* Restore screen contents */
 extern int graphic_mode;	/* Graphics mode with linear frame buffer */
 
-/*
- * int $0x10 is notorious for touching registers it shouldn't.
- * gcc doesn't like %ebp being clobbered, so define it as a push/pop
- * sequence here.
- *
- * A number of systems, including the original PC can clobber %bp in
- * certain circumstances, like when scrolling.  There exists at least
- * one Trident video card which could clobber DS under a set of
- * circumstances that we are unlikely to encounter (scrolling when
- * using an extended graphics mode of more than 800x600 pixels), but
- * it's cheap insurance to deal with that here.
- */
-#define INT10 "pushl %%ebp; pushw %%ds; int $0x10; popw %%ds; popl %%ebp"
-
 /* Accessing VGA indexed registers */
 static inline u8 in_idx(u16 port, u8 index)
 {
