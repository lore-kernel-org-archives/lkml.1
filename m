Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbXGJDqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbXGJDqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXGJDqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:46:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXGJDqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:46:30 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 27/33] Video mode probing support for the new x86 setup code
Date: Mon,  9 Jul 2007 19:52:06 -0700
Message-Id: <11840387733386-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840386682120-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
 <11840386682120-git-send-email-hpa@zytor.com>
Message-Id: <f8afa57a4934b75080449e8dd3a23d178be77a41.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Video mode probing for the new x86 setup code.  This code breaks down
different drivers into modules.  This code deliberately drops support
for a lot of the vendor-specific mode probing present in the assembly
version, since a lot of those probes have been found to be stale in
current versions of those chips -- frequently, support for those modes
have been dropped from recent video BIOSes due to space constraints,
but the video BIOS signatures are still the same.

However, additional drivers should be extremely straightforward to plug
in, if desirable.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/vesa.h       |   79 ++++++++
 arch/i386/boot/video-bios.c |  125 ++++++++++++
 arch/i386/boot/video-vesa.c |  284 +++++++++++++++++++++++++++
 arch/i386/boot/video-vga.c  |  260 ++++++++++++++++++++++++
 arch/i386/boot/video.c      |  456 +++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/video.h      |  145 ++++++++++++++
 6 files changed, 1349 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/vesa.h
 create mode 100644 arch/i386/boot/video-bios.c
 create mode 100644 arch/i386/boot/video-vesa.c
 create mode 100644 arch/i386/boot/video-vga.c
 create mode 100644 arch/i386/boot/video.c
 create mode 100644 arch/i386/boot/video.h

diff --git a/arch/i386/boot/vesa.h b/arch/i386/boot/vesa.h
new file mode 100644
index 0000000..ff5b73c
--- /dev/null
+++ b/arch/i386/boot/vesa.h
@@ -0,0 +1,79 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *   Copyright 1999-2007 H. Peter Anvin - All Rights Reserved
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
+ *   (at your option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+#ifndef BOOT_VESA_H
+#define BOOT_VESA_H
+
+typedef struct {
+	u16 off, seg;
+} far_ptr;
+
+/* VESA General Information table */
+struct vesa_general_info {
+	u32 signature;		/* 0 Magic number = "VESA" */
+	u16 version;		/* 4 */
+	far_ptr vendor_string;	/* 6 */
+	u32 capabilities;	/* 10 */
+	far_ptr video_mode_ptr;	/* 14 */
+	u16 total_memory;	/* 18 */
+
+	u16 oem_software_rev;	/* 20 */
+	far_ptr oem_vendor_name_ptr;	/* 22 */
+	far_ptr oem_product_name_ptr;	/* 26 */
+	far_ptr oem_product_rev_ptr;	/* 30 */
+
+	u8 reserved[222];	/* 34 */
+	u8 oem_data[256];	/* 256 */
+} __attribute__ ((packed));
+
+#define VESA_MAGIC ('V' + ('E' << 8) + ('S' << 16) + ('A' << 24))
+#define VBE2_MAGIC ('V' + ('B' << 8) + ('E' << 16) + ('2' << 24))
+
+struct vesa_mode_info {
+	u16 mode_attr;		/* 0 */
+	u8 win_attr[2];		/* 2 */
+	u16 win_grain;		/* 4 */
+	u16 win_size;		/* 6 */
+	u16 win_seg[2];		/* 8 */
+	far_ptr win_scheme;	/* 12 */
+	u16 logical_scan;	/* 16 */
+
+	u16 h_res;		/* 18 */
+	u16 v_res;		/* 20 */
+	u8 char_width;		/* 22 */
+	u8 char_height;		/* 23 */
+	u8 memory_planes;	/* 24 */
+	u8 bpp;			/* 25 */
+	u8 banks;		/* 26 */
+	u8 memory_layout;	/* 27 */
+	u8 bank_size;		/* 28 */
+	u8 image_planes;	/* 29 */
+	u8 page_function;	/* 30 */
+
+	u8 rmask;		/* 31 */
+	u8 rpos;		/* 32 */
+	u8 gmask;		/* 33 */
+	u8 gpos;		/* 34 */
+	u8 bmask;		/* 35 */
+	u8 bpos;		/* 36 */
+	u8 resv_mask;		/* 37 */
+	u8 resv_pos;		/* 38 */
+	u8 dcm_info;		/* 39 */
+
+	u32 lfb_ptr;		/* 40 Linear frame buffer address */
+	u32 offscreen_ptr;	/* 44 Offscreen memory address */
+	u16 offscreen_size;	/* 48 */
+
+	u8 reserved[206];	/* 50 */
+} __attribute__ ((packed));
+
+#endif				/* LIB_SYS_VESA_H */
diff --git a/arch/i386/boot/video-bios.c b/arch/i386/boot/video-bios.c
new file mode 100644
index 0000000..afea46c
--- /dev/null
+++ b/arch/i386/boot/video-bios.c
@@ -0,0 +1,125 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video-bios.c
+ *
+ * Standard video BIOS modes
+ *
+ * We have two options for this; silent and scanned.
+ */
+
+#include "boot.h"
+#include "video.h"
+
+__videocard video_bios;
+
+/* Set a conventional BIOS mode */
+static int set_bios_mode(u8 mode);
+
+static int bios_set_mode(struct mode_info *mi)
+{
+	return set_bios_mode(mi->mode - VIDEO_FIRST_BIOS);
+}
+
+static int set_bios_mode(u8 mode)
+{
+	u16 ax;
+	u8 new_mode;
+
+	ax = mode;		/* AH=0x00 Set Video Mode */
+	asm volatile(INT10
+		     : "+a" (ax)
+		     : : "ebx", "ecx", "edx", "esi", "edi");
+
+	ax = 0x0f00;		/* Get Current Video Mode */
+	asm volatile(INT10
+		     : "+a" (ax)
+		     : : "ebx", "ecx", "edx", "esi", "edi");
+
+	do_restore = 1;		/* Assume video contents was lost */
+	new_mode = ax & 0x7f;	/* Not all BIOSes are clean with the top bit */
+
+	if (new_mode == mode)
+		return 0;	/* Mode change OK */
+
+	if (new_mode != boot_params.screen_info.orig_video_mode) {
+		/* Mode setting failed, but we didn't end up where we
+		   started.  That's bad.  Try to revert to the original
+		   video mode. */
+		ax = boot_params.screen_info.orig_video_mode;
+		asm volatile(INT10
+			     : "+a" (ax)
+			     : : "ebx", "ecx", "edx", "esi", "edi");
+	}
+	return -1;
+}
+
+static int bios_probe(void)
+{
+	u8 mode;
+	u8 saved_mode = boot_params.screen_info.orig_video_mode;
+	u16 crtc;
+	struct mode_info *mi;
+	int nmodes = 0;
+
+	if (adapter != ADAPTER_EGA && adapter != ADAPTER_VGA)
+		return 0;
+
+	set_fs(0);
+	crtc = vga_crtc();
+
+	video_bios.modes = GET_HEAP(struct mode_info, 0);
+
+	for (mode = 0x14; mode <= 0x7f; mode++) {
+		if (heap_free() < sizeof(struct mode_info))
+			break;
+
+		if (mode_defined(VIDEO_FIRST_BIOS+mode))
+			continue;
+
+		if (set_bios_mode(mode))
+			continue;
+
+		/* Try to verify that it's a text mode. */
+
+		/* Attribute Controller: make graphics controller disabled */
+		if (in_idx(0x3c0, 0x10) & 0x01)
+			continue;
+
+		/* Graphics Controller: verify Alpha addressing enabled */
+		if (in_idx(0x3ce, 0x06) & 0x01)
+			continue;
+
+		/* CRTC cursor location low should be zero(?) */
+		if (in_idx(crtc, 0x0f))
+			continue;
+
+		mi = GET_HEAP(struct mode_info, 1);
+		mi->mode = VIDEO_FIRST_BIOS+mode;
+		mi->x = rdfs16(0x44a);
+		mi->y = rdfs8(0x484)+1;
+		nmodes++;
+	}
+
+	set_bios_mode(saved_mode);
+
+	return nmodes;
+}
+
+__videocard video_bios =
+{
+	.card_name	= "BIOS (scanned)",
+	.probe		= bios_probe,
+	.set_mode	= bios_set_mode,
+	.unsafe		= 1,
+	.xmode_first	= VIDEO_FIRST_BIOS,
+	.xmode_n	= 0x80,
+};
diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
new file mode 100644
index 0000000..e6aa9eb
--- /dev/null
+++ b/arch/i386/boot/video-vesa.c
@@ -0,0 +1,284 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video-vesa.c
+ *
+ * VESA text modes
+ */
+
+#include "boot.h"
+#include "video.h"
+#include "vesa.h"
+
+/* VESA information */
+static struct vesa_general_info vginfo;
+static struct vesa_mode_info vminfo;
+
+__videocard video_vesa;
+
+static void vesa_store_mode_params_graphics(void);
+
+static int vesa_probe(void)
+{
+#if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
+	u16 ax;
+	u16 mode;
+	addr_t mode_ptr;
+	struct mode_info *mi;
+	int nmodes = 0;
+
+	video_vesa.modes = GET_HEAP(struct mode_info, 0);
+
+	vginfo.signature = VBE2_MAGIC;
+
+	/* Optimistically assume a VESA BIOS is register-clean... */
+	ax = 0x4f00;
+	asm("int $0x10" : "+a" (ax), "=m" (vginfo) : "D" (&vginfo));
+
+	if (ax != 0x004f ||
+	    vginfo.signature != VESA_MAGIC ||
+	    vginfo.version < 0x0102)
+		return 0;	/* Not present */
+#endif /* CONFIG_VIDEO_VESA || CONFIG_FIRMWARE_EDID */
+#ifdef CONFIG_VIDEO_VESA
+	set_fs(vginfo.video_mode_ptr.seg);
+	mode_ptr = vginfo.video_mode_ptr.off;
+
+	while ((mode = rdfs16(mode_ptr)) != 0xffff) {
+		mode_ptr += 2;
+
+		if (heap_free() < sizeof(struct mode_info))
+			break;	/* Heap full, can't save mode info */
+
+		if (mode & ~0x1ff)
+			continue;
+
+		memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
+
+		ax = 0x4f01;
+		asm("int $0x10"
+		    : "+a" (ax), "=m" (vminfo)
+		    : "c" (mode), "D" (&vminfo));
+
+		if (ax != 0x004f)
+			continue;
+
+		if ((vminfo.mode_attr & 0x15) == 0x05) {
+			/* Text Mode, TTY BIOS supported,
+			   supported by hardware */
+			mi = GET_HEAP(struct mode_info, 1);
+			mi->mode = mode + VIDEO_FIRST_VESA;
+			mi->x    = vminfo.h_res;
+			mi->y    = vminfo.v_res;
+			nmodes++;
+		} else if ((vminfo.mode_attr & 0x99) == 0x99) {
+#ifdef CONFIG_FB
+			/* Graphics mode, color, linear frame buffer
+			   supported -- register the mode but hide from
+			   the menu.  Only do this if framebuffer is
+			   configured, however, otherwise the user will
+			   be left without a screen. */
+			mi = GET_HEAP(struct mode_info, 1);
+			mi->mode = mode + VIDEO_FIRST_VESA;
+			mi->x = mi->y = 0;
+			nmodes++;
+#endif
+		}
+	}
+
+	return nmodes;
+#else
+	return 0;
+#endif /* CONFIG_VIDEO_VESA */
+}
+
+static int vesa_set_mode(struct mode_info *mode)
+{
+	u16 ax;
+	int is_graphic;
+	u16 vesa_mode = mode->mode - VIDEO_FIRST_VESA;
+
+	memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
+
+	ax = 0x4f01;
+	asm("int $0x10"
+	    : "+a" (ax), "=m" (vminfo)
+	    : "c" (vesa_mode), "D" (&vminfo));
+
+	if (ax != 0x004f)
+		return -1;
+
+	if ((vminfo.mode_attr & 0x15) == 0x05) {
+		/* It's a supported text mode */
+		is_graphic = 0;
+	} else if ((vminfo.mode_attr & 0x99) == 0x99) {
+		/* It's a graphics mode with linear frame buffer */
+		is_graphic = 1;
+		vesa_mode |= 0x4000; /* Request linear frame buffer */
+	} else {
+		return -1;	/* Invalid mode */
+	}
+
+
+	ax = 0x4f02;
+	asm volatile("int $0x10"
+		     : "+a" (ax)
+		     : "b" (vesa_mode), "D" (0));
+
+	if (ax != 0x004f)
+		return -1;
+
+	graphic_mode = is_graphic;
+	if (!is_graphic) {
+		/* Text mode */
+		force_x = mode->x;
+		force_y = mode->y;
+		do_restore = 1;
+	} else {
+		/* Graphics mode */
+		vesa_store_mode_params_graphics();
+	}
+
+	return 0;
+}
+
+
+/* Switch DAC to 8-bit mode */
+static void vesa_dac_set_8bits(void)
+{
+	u8 dac_size = 6;
+
+	/* If possible, switch the DAC to 8-bit mode */
+	if (vginfo.capabilities & 1) {
+		u16 ax, bx;
+
+		ax = 0x4f08;
+		bx = 0x0800;
+		asm volatile(INT10
+			     : "+a" (ax), "+b" (bx)
+			     : : "ecx", "edx", "esi", "edi");
+
+		if (ax == 0x004f)
+			dac_size = bx >> 8;
+	}
+
+	/* Set the color sizes to the DAC size, and offsets to 0 */
+	boot_params.screen_info.red_size = dac_size;
+	boot_params.screen_info.green_size = dac_size;
+	boot_params.screen_info.blue_size = dac_size;
+	boot_params.screen_info.rsvd_size = dac_size;
+
+	boot_params.screen_info.red_pos = 0;
+	boot_params.screen_info.green_pos = 0;
+	boot_params.screen_info.blue_pos = 0;
+	boot_params.screen_info.rsvd_pos = 0;
+}
+
+/* Save the VESA protected mode info */
+static void vesa_store_pm_info(void)
+{
+	u16 ax, bx, di, es;
+
+	ax = 0x4f0a;
+	bx = di = 0;
+	asm("pushw %%es; "INT10"; movw %%es,%0; popw %%es"
+	    : "=d" (es), "+a" (ax), "+b" (bx), "+D" (di)
+	    : : "ecx", "esi");
+
+	if (ax != 0x004f)
+		return;
+
+	boot_params.screen_info.vesapm_seg = es;
+	boot_params.screen_info.vesapm_off = di;
+}
+
+/*
+ * Save video mode parameters for graphics mode
+ */
+static void vesa_store_mode_params_graphics(void)
+{
+	/* Tell the kernel we're in VESA graphics mode */
+	boot_params.screen_info.orig_video_isVGA = 0x23;
+
+	/* Mode parameters */
+	boot_params.screen_info.vesa_attributes = vminfo.mode_attr;
+	boot_params.screen_info.lfb_linelength = vminfo.logical_scan;
+	boot_params.screen_info.lfb_width = vminfo.h_res;
+	boot_params.screen_info.lfb_height = vminfo.v_res;
+	boot_params.screen_info.lfb_depth = vminfo.bpp;
+	boot_params.screen_info.pages = vminfo.image_planes;
+	boot_params.screen_info.lfb_base = vminfo.lfb_ptr;
+	memcpy(&boot_params.screen_info.red_size,
+	       &vminfo.rmask, 8);
+
+	/* General parameters */
+	boot_params.screen_info.lfb_size = vginfo.total_memory;
+
+	if (vminfo.bpp <= 8)
+		vesa_dac_set_8bits();
+
+	vesa_store_pm_info();
+}
+
+/*
+ * Save EDID information for the kernel; this is invoked, separately,
+ * after mode-setting.
+ */
+void vesa_store_edid(void)
+{
+#ifdef CONFIG_FIRMWARE_EDID
+	u16 ax, bx, cx, dx, di;
+
+	/* Apparently used as a nonsense token... */
+	memset(&boot_params.edid_info, 0x13, sizeof boot_params.edid_info);
+
+	if (vginfo.version < 0x0200)
+		return;		/* EDID requires VBE 2.0+ */
+
+	ax = 0x4f15;		/* VBE DDC */
+	bx = 0x0000;		/* Report DDC capabilities */
+	cx = 0;			/* Controller 0 */
+	di = 0;			/* ES:DI must be 0 by spec */
+
+	/* Note: The VBE DDC spec is different from the main VESA spec;
+	   we genuinely have to assume all registers are destroyed here. */
+
+	asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
+	    : "+a" (ax), "+b" (bx)
+	    :  "c" (cx), "D" (di)
+	    : "esi");
+
+	if (ax != 0x004f)
+		return;		/* No EDID */
+
+	/* BH = time in seconds to transfer EDD information */
+	/* BL = DDC level supported */
+
+	ax = 0x4f15;		/* VBE DDC */
+	bx = 0x0001;		/* Read EDID */
+	cx = 0;			/* Controller 0 */
+	dx = 0;			/* EDID block number */
+	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
+	asm(INT10
+	    : "+a" (ax), "+b" (bx), "+d" (dx)
+	    : "c" (cx), "D" (di)
+	    : "esi");
+#endif /* CONFIG_FIRMWARE_EDID */
+}
+
+__videocard video_vesa =
+{
+	.card_name	= "VESA",
+	.probe		= vesa_probe,
+	.set_mode	= vesa_set_mode,
+	.xmode_first	= VIDEO_FIRST_VESA,
+	.xmode_n	= 0x200,
+};
diff --git a/arch/i386/boot/video-vga.c b/arch/i386/boot/video-vga.c
new file mode 100644
index 0000000..700d09a
--- /dev/null
+++ b/arch/i386/boot/video-vga.c
@@ -0,0 +1,260 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video-vga.c
+ *
+ * Common all-VGA modes
+ */
+
+#include "boot.h"
+#include "video.h"
+
+static struct mode_info vga_modes[] = {
+	{ VIDEO_80x25,  80, 25 },
+	{ VIDEO_8POINT, 80, 50 },
+	{ VIDEO_80x43,  80, 43 },
+	{ VIDEO_80x28,  80, 28 },
+	{ VIDEO_80x30,  80, 30 },
+	{ VIDEO_80x34,  80, 34 },
+	{ VIDEO_80x60,  80, 60 },
+};
+
+static struct mode_info ega_modes[] = {
+	{ VIDEO_80x25,  80, 25 },
+	{ VIDEO_8POINT, 80, 43 },
+};
+
+static struct mode_info cga_modes[] = {
+	{ VIDEO_80x25,  80, 25 },
+};
+
+__videocard video_vga;
+
+/* Set basic 80x25 mode */
+static u8 vga_set_basic_mode(void)
+{
+	u16 ax;
+	u8 rows;
+	u8 mode;
+
+#ifdef CONFIG_VIDEO_400_HACK
+	if (adapter >= ADAPTER_VGA) {
+		asm(INT10
+		    : : "a" (0x1202), "b" (0x0030)
+		    : "ecx", "edx", "esi", "edi");
+	}
+#endif
+
+	ax = 0x0f00;
+	asm(INT10
+	    : "+a" (ax)
+	    : : "ebx", "ecx", "edx", "esi", "edi");
+
+	mode = (u8)ax;
+
+	set_fs(0);
+	rows = rdfs8(0x484);	/* rows minus one */
+
+#ifndef CONFIG_VIDEO_400_HACK
+	if ((ax == 0x5003 || ax == 0x5007) &&
+	    (rows == 0 || rows == 24))
+		return mode;
+#endif
+
+	if (mode != 3 && mode != 7)
+		mode = 3;
+
+	/* Set the mode */
+	asm volatile(INT10
+		     : : "a" (mode)
+		     : "ebx", "ecx", "edx", "esi", "edi");
+	do_restore = 1;
+	return mode;
+}
+
+static void vga_set_8font(void)
+{
+	/* Set 8x8 font - 80x43 on EGA, 80x50 on VGA */
+
+	/* Set 8x8 font */
+	asm volatile(INT10 : : "a" (0x1112), "b" (0));
+
+	/* Use alternate print screen */
+	asm volatile(INT10 : : "a" (0x1200), "b" (0x20));
+
+	/* Turn off cursor emulation */
+	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+
+	/* Cursor is scan lines 6-7 */
+	asm volatile(INT10 : : "a" (0x0100), "c" (0x0607));
+}
+
+static void vga_set_14font(void)
+{
+	/* Set 9x14 font - 80x28 on VGA */
+
+	/* Set 9x14 font */
+	asm volatile(INT10 : : "a" (0x1111), "b" (0));
+
+	/* Turn off cursor emulation */
+	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+
+	/* Cursor is scan lines 11-12 */
+	asm volatile(INT10 : : "a" (0x0100), "c" (0x0b0c));
+}
+
+static void vga_set_80x43(void)
+{
+	/* Set 80x43 mode on VGA (not EGA) */
+
+	/* Set 350 scans */
+	asm volatile(INT10 : : "a" (0x1201), "b" (0x30));
+
+	/* Reset video mode */
+	asm volatile(INT10 : : "a" (0x0003));
+
+	vga_set_8font();
+}
+
+/* I/O address of the VGA CRTC */
+u16 vga_crtc(void)
+{
+	return (inb(0x3cc) & 1) ? 0x3d4 : 0x3b4;
+}
+
+static void vga_set_480_scanlines(int end)
+{
+	u16 crtc;
+	u8  csel;
+
+	crtc = vga_crtc();
+
+	out_idx(0x0c, crtc, 0x11); /* Vertical sync end, unlock CR0-7 */
+	out_idx(0x0b, crtc, 0x06); /* Vertical total */
+	out_idx(0x3e, crtc, 0x07); /* Vertical overflow */
+	out_idx(0xea, crtc, 0x10); /* Vertical sync start */
+	out_idx(end, crtc, 0x12); /* Vertical display end */
+	out_idx(0xe7, crtc, 0x15); /* Vertical blank start */
+	out_idx(0x04, crtc, 0x16); /* Vertical blank end */
+	csel = inb(0x3cc);
+	csel &= 0x0d;
+	csel |= 0xe2;
+	outb(csel, 0x3cc);
+}
+
+static void vga_set_80x30(void)
+{
+	vga_set_480_scanlines(0xdf);
+}
+
+static void vga_set_80x34(void)
+{
+	vga_set_14font();
+	vga_set_480_scanlines(0xdb);
+}
+
+static void vga_set_80x60(void)
+{
+	vga_set_8font();
+	vga_set_480_scanlines(0xdf);
+}
+
+static int vga_set_mode(struct mode_info *mode)
+{
+	/* Set the basic mode */
+	vga_set_basic_mode();
+
+	/* Override a possibly broken BIOS */
+	force_x = mode->x;
+	force_y = mode->y;
+
+	switch (mode->mode) {
+	case VIDEO_80x25:
+		break;
+	case VIDEO_8POINT:
+		vga_set_8font();
+		break;
+	case VIDEO_80x43:
+		vga_set_80x43();
+		break;
+	case VIDEO_80x28:
+		vga_set_14font();
+		break;
+	case VIDEO_80x30:
+		vga_set_80x30();
+		break;
+	case VIDEO_80x34:
+		vga_set_80x34();
+		break;
+	case VIDEO_80x60:
+		vga_set_80x60();
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Note: this probe includes basic information required by all
+ * systems.  It should be executed first, by making sure
+ * video-vga.c is listed first in the Makefile.
+ */
+static int vga_probe(void)
+{
+	static const char *card_name[] = {
+		"CGA/MDA/HGC", "EGA", "VGA"
+	};
+	static struct mode_info *mode_lists[] = {
+		cga_modes,
+		ega_modes,
+		vga_modes,
+	};
+	static int mode_count[] = {
+		sizeof(cga_modes)/sizeof(struct mode_info),
+		sizeof(ega_modes)/sizeof(struct mode_info),
+		sizeof(vga_modes)/sizeof(struct mode_info),
+	};
+	u8 vga_flag;
+
+	asm(INT10
+	    : "=b" (boot_params.screen_info.orig_video_ega_bx)
+	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
+	    : "ecx", "edx", "esi", "edi");
+
+	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
+	if ((u8)boot_params.screen_info.orig_video_ega_bx != 0x10) {
+		/* EGA/VGA */
+		asm(INT10
+		    : "=a" (vga_flag)
+		    : "a" (0x1a00)
+		    : "ebx", "ecx", "edx", "esi", "edi");
+
+		if (vga_flag == 0x1a) {
+			adapter = ADAPTER_VGA;
+			boot_params.screen_info.orig_video_isVGA = 1;
+		} else {
+			adapter = ADAPTER_EGA;
+		}
+	} else {
+		adapter = ADAPTER_CGA;
+	}
+
+	video_vga.modes = mode_lists[adapter];
+	video_vga.card_name = card_name[adapter];
+	return mode_count[adapter];
+}
+
+__videocard video_vga =
+{
+	.card_name	= "VGA",
+	.probe		= vga_probe,
+	.set_mode	= vga_set_mode,
+};
diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
new file mode 100644
index 0000000..3bb3573
--- /dev/null
+++ b/arch/i386/boot/video.c
@@ -0,0 +1,456 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video.c
+ *
+ * Select video mode
+ */
+
+#include "boot.h"
+#include "video.h"
+#include "vesa.h"
+
+/*
+ * Mode list variables
+ */
+static struct card_info cards[];    /* List of cards to probe for */
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
+static void store_cursor_position(void)
+{
+	u16 curpos;
+	u16 ax, bx;
+
+	ax = 0x0300;
+	bx = 0;
+	asm(INT10
+	    : "=d" (curpos), "+a" (ax), "+b" (bx)
+	    : : "ecx", "esi", "edi");
+
+	boot_params.screen_info.orig_x = curpos;
+	boot_params.screen_info.orig_y = curpos >> 8;
+}
+
+static void store_video_mode(void)
+{
+	u16 ax, page;
+
+	/* N.B.: the saving of the video page here is a bit silly,
+	   since we pretty much assume page 0 everywhere. */
+	ax = 0x0f00;
+	asm(INT10
+	    : "+a" (ax), "=b" (page)
+	    : : "ecx", "edx", "esi", "edi");
+
+	/* Not all BIOSes are clean with respect to the top bit */
+	boot_params.screen_info.orig_video_mode = ax & 0x7f;
+	boot_params.screen_info.orig_video_page = page;
+}
+
+/*
+ * Store the video mode parameters for later usage by the kernel.
+ * This is done by asking the BIOS except for the rows/columns
+ * parameters in the default 80x25 mode -- these are set directly,
+ * because some very obscure BIOSes supply insane values.
+ */
+static void store_mode_params(void)
+{
+	u16 font_size;
+	int x, y;
+
+	/* For graphics mode, it is up to the mode-setting driver
+	   (currently only video-vesa.c) to store the parameters */
+	if (graphic_mode)
+		return;
+
+	store_cursor_position();
+	store_video_mode();
+
+	if (boot_params.screen_info.orig_video_mode == 0x07) {
+		/* MDA, HGC, or VGA in monochrome mode */
+		video_segment = 0xb000;
+	} else {
+		/* CGA, EGA, VGA and so forth */
+		video_segment = 0xb800;
+	}
+
+	set_fs(0);
+	font_size = rdfs16(0x485); /* Font size, BIOS area */
+	boot_params.screen_info.orig_video_points = font_size;
+
+	x = rdfs16(0x44a);
+	y = (adapter == ADAPTER_CGA) ? 25 : rdfs8(0x484)+1;
+
+	if (force_x)
+		x = force_x;
+	if (force_y)
+		y = force_y;
+
+	boot_params.screen_info.orig_video_cols  = x;
+	boot_params.screen_info.orig_video_lines = y;
+}
+
+/* Probe the video drivers and have them generate their mode lists. */
+static void probe_cards(int unsafe)
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
+static int raw_set_mode(u16 mode)
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
+			    mode == (mi->y << 8)+mi->x)
+				return card->set_mode(mi);
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
+			mix.mode = mode;
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
+	u8 ov;
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
+	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
+	ov = in_idx(crtc, 0x07); /* Overflow register */
+	ov &= 0xbd;
+	ov |= (rows >> (8-1)) & 0x02;
+	ov |= (rows >> (9-6)) & 0x40;
+	out_idx(ov, crtc, 0x07);
+}
+
+/* Set mode (with recalc if specified) */
+static int set_mode(u16 mode)
+{
+	int rv;
+
+	/* Very special mode numbers... */
+	if (mode == VIDEO_CURRENT_MODE)
+		return 0;	/* Nothing to do... */
+	else if (mode == NORMAL_VGA)
+		mode = VIDEO_80x25;
+	else if (mode == EXTENDED_VGA)
+		mode = VIDEO_8POINT;
+
+	rv = raw_set_mode(mode);
+	if (rv)
+		return rv;
+
+	if (mode & VIDEO_RECALC)
+		vga_recalc_vertical();
+
+	return 0;
+}
+
+static unsigned int get_entry(void)
+{
+	char entry_buf[4];
+	int i, len = 0;
+	int key;
+	unsigned int v;
+
+	do {
+		key = getchar();
+
+		if (key == '\b') {
+			if (len > 0) {
+				puts("\b \b");
+				len--;
+			}
+		} else if ((key >= '0' && key <= '9') ||
+			   (key >= 'A' && key <= 'Z') ||
+			   (key >= 'a' && key <= 'z')) {
+			if (len < sizeof entry_buf) {
+				entry_buf[len++] = key;
+				putchar(key);
+			}
+		}
+	} while (key != '\r');
+	putchar('\n');
+
+	if (len == 0)
+		return VIDEO_CURRENT_MODE; /* Default */
+
+	v = 0;
+	for (i = 0; i < len; i++) {
+		v <<= 4;
+		key = entry_buf[i] | 0x20;
+		v += (key > '9') ? key-'a'+10 : key-'0';
+	}
+
+	return v;
+}
+
+static void display_menu(void)
+{
+	struct card_info *card;
+	struct mode_info *mi;
+	char ch;
+	int i;
+
+	puts("Mode:    COLSxROWS:\n");
+
+	ch = '0';
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++) {
+			int visible = mi->x && mi->y;
+			u16 mode_id = mi->mode ? mi->mode :
+				(mi->y << 8)+mi->x;
+
+			if (!visible)
+				continue; /* Hidden mode */
+
+			printf("%c  %04X  %3dx%-3d  %s\n",
+			       ch, mode_id, mi->x, mi->y, card->card_name);
+
+			if (ch == '9')
+				ch = 'a';
+			else if (ch == 'z' || ch == ' ')
+				ch = ' '; /* Out of keys... */
+			else
+				ch++;
+		}
+	}
+}
+
+#define H(x)	((x)-'a'+10)
+#define SCAN	((H('s')<<12)+(H('c')<<8)+(H('a')<<4)+H('n'))
+
+static unsigned int mode_menu(void)
+{
+	int key;
+	unsigned int sel;
+
+	puts("Press <ENTER> to see video modes available, "
+	     "<SPACE> to continue, or wait 30 sec\n");
+
+	kbd_flush();
+	while (1) {
+		key = getchar_timeout();
+		if (key == ' ' || key == 0)
+			return VIDEO_CURRENT_MODE; /* Default */
+		if (key == '\r')
+			break;
+		putchar('\a');	/* Beep! */
+	}
+
+
+	for (;;) {
+		display_menu();
+
+		puts("Enter a video mode or \"scan\" to scan for "
+		     "additional modes: ");
+		sel = get_entry();
+		if (sel != SCAN)
+			return sel;
+
+		probe_cards(1);
+	}
+}
+
+#ifdef CONFIG_VIDEO_RETAIN
+/* Save screen content to the heap */
+struct saved_screen {
+	int x, y;
+	int curx, cury;
+	u16 *data;
+} saved;
+
+static void save_screen(void)
+{
+	/* Should be called after store_mode_params() */
+	saved.x = boot_params.screen_info.orig_video_cols;
+	saved.y = boot_params.screen_info.orig_video_lines;
+	saved.curx = boot_params.screen_info.orig_x;
+	saved.cury = boot_params.screen_info.orig_y;
+
+	if (heap_free() < saved.x*saved.y*sizeof(u16)+512)
+		return;		/* Not enough heap to save the screen */
+
+	saved.data = GET_HEAP(u16, saved.x*saved.y);
+
+	set_fs(video_segment);
+	copy_from_fs(saved.data, 0, saved.x*saved.y*sizeof(u16));
+}
+
+static void restore_screen(void)
+{
+	/* Should be called after store_mode_params() */
+	int xs = boot_params.screen_info.orig_video_cols;
+	int ys = boot_params.screen_info.orig_video_lines;
+	int y;
+	addr_t dst = 0;
+	u16 *src = saved.data;
+	u16 ax, bx, dx;
+
+	if (graphic_mode)
+		return;		/* Can't restore onto a graphic mode */
+
+	if (!src)
+		return;		/* No saved screen contents */
+
+	/* Restore screen contents */
+
+	set_fs(video_segment);
+	for (y = 0; y < ys; y++) {
+		int npad;
+
+		if (y < saved.y) {
+			int copy = (xs < saved.x) ? xs : saved.x;
+			copy_to_fs(dst, src, copy*sizeof(u16));
+			dst += copy*sizeof(u16);
+			src += saved.x;
+			npad = (xs < saved.x) ? 0 : xs-saved.x;
+		} else {
+			npad = xs;
+		}
+
+		/* Writes "npad" blank characters to
+		   video_segment:dst and advances dst */
+		asm volatile("pushw %%es ; "
+			     "movw %2,%%es ; "
+			     "shrw %%cx ; "
+			     "jnc 1f ; "
+			     "stosw \n\t"
+			     "1: rep;stosl ; "
+			     "popw %%es"
+			     : "+D" (dst), "+c" (npad)
+			     : "bdSm" (video_segment),
+			       "a" (0x07200720));
+	}
+
+	/* Restore cursor position */
+	ax = 0x0200;		/* Set cursor position */
+	bx = 0;			/* Page number (<< 8) */
+	dx = (saved.cury << 8)+saved.curx;
+	asm volatile(INT10
+		     : "+a" (ax), "+b" (bx), "+d" (dx)
+		     : : "ecx", "esi", "edi");
+}
+#else
+#define save_screen()		((void)0)
+#define restore_screen()	((void)0)
+#endif
+
+void set_video(void)
+{
+	u16 mode = boot_params.hdr.vid_mode;
+
+	RESET_HEAP();
+
+	store_mode_params();
+	save_screen();
+	probe_cards(0);
+
+	for (;;) {
+		if (mode == ASK_VGA)
+			mode = mode_menu();
+
+		if (!set_mode(mode))
+			break;
+
+		printf("Undefined video mode number: %x\n", mode);
+		mode = ASK_VGA;
+	}
+	vesa_store_edid();
+	store_mode_params();
+
+	if (do_restore)
+		restore_screen();
+}
diff --git a/arch/i386/boot/video.h b/arch/i386/boot/video.h
new file mode 100644
index 0000000..29eca17
--- /dev/null
+++ b/arch/i386/boot/video.h
@@ -0,0 +1,145 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/video.h
+ *
+ * Header file for the real-mode video probing code
+ */
+
+#ifndef BOOT_VIDEO_H
+#define BOOT_VIDEO_H
+
+#include <linux/types.h>
+
+/* Enable autodetection of SVGA adapters and modes. */
+#undef CONFIG_VIDEO_SVGA
+
+/* Enable autodetection of VESA modes */
+#define CONFIG_VIDEO_VESA
+
+/* Retain screen contents when switching modes */
+#define CONFIG_VIDEO_RETAIN
+
+/* Force 400 scan lines for standard modes (hack to fix bad BIOS behaviour */
+#undef CONFIG_VIDEO_400_HACK
+
+/* This code uses an extended set of video mode numbers. These include:
+ * Aliases for standard modes
+ *      NORMAL_VGA (-1)
+ *      EXTENDED_VGA (-2)
+ *      ASK_VGA (-3)
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
+/* Special video modes */
+#define VIDEO_FIRST_SPECIAL 0x0f00
+#define VIDEO_80x25 0x0f00
+#define VIDEO_8POINT 0x0f01
+#define VIDEO_80x43 0x0f02
+#define VIDEO_80x28 0x0f03
+#define VIDEO_CURRENT_MODE 0x0f04
+#define VIDEO_80x30 0x0f05
+#define VIDEO_80x34 0x0f06
+#define VIDEO_80x60 0x0f07
+#define VIDEO_GFX_HACK 0x0f08
+#define VIDEO_LAST_SPECIAL 0x0f09
+
+/* Video modes given by resolution */
+#define VIDEO_FIRST_RESOLUTION 0x1000
+
+/* The "recalculate timings" flag */
+#define VIDEO_RECALC 0x8000
+
+/* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
+#ifdef CONFIG_VIDEO_RETAIN
+void store_screen(void);
+#define DO_STORE() store_screen()
+#else
+#define DO_STORE() ((void)0)
+#endif /* CONFIG_VIDEO_RETAIN */
+
+/*
+ * Mode table structures
+ */
+
+struct mode_info {
+	u16 mode;		/* Mode number (vga= style) */
+	u8  x, y;		/* Width, height */
+};
+
+struct card_info {
+	const char *card_name;
+	int (*set_mode)(struct mode_info *mode);
+	int (*probe)(void);
+	struct mode_info *modes;
+	int nmodes;		/* Number of probed modes so far */
+	int unsafe;		/* Probing is unsafe, only do after "scan" */
+	u16 xmode_first;	/* Unprobed modes to try to call anyway */
+	u16 xmode_n;		/* Size of unprobed mode range */
+};
+
+#define __videocard struct card_info __attribute__((section(".videocards")))
+extern struct card_info video_cards[], video_cards_end[];
+
+int mode_defined(u16 mode);	/* video.c */
+
+/* Basic video information */
+#define ADAPTER_CGA	0	/* CGA/MDA/HGC */
+#define ADAPTER_EGA	1
+#define ADAPTER_VGA	2
+
+extern int adapter;
+extern u16 video_segment;
+extern int force_x, force_y;	/* Don't query the BIOS for cols/rows */
+extern int do_restore;		/* Restore screen contents */
+extern int graphic_mode;	/* Graphics mode with linear frame buffer */
+
+/*
+ * int $0x10 is notorious for touching registers it shouldn't.
+ * gcc doesn't like %ebp being clobbered, so define it as a push/pop
+ * sequence here.
+ */
+#define INT10 "pushl %%ebp; int $0x10; popl %%ebp"
+
+/* Accessing VGA indexed registers */
+static inline u8 in_idx(u16 port, u8 index)
+{
+	outb(index, port);
+	return inb(port+1);
+}
+
+static inline void out_idx(u8 v, u16 port, u8 index)
+{
+	outw(index+(v << 8), port);
+}
+
+/* Writes a value to an indexed port and then reads the port again */
+static inline u8 tst_idx(u8 v, u16 port, u8 index)
+{
+	out_idx(port, index, v);
+	return in_idx(port, index);
+}
+
+/* Get the I/O port of the VGA CRTC */
+u16 vga_crtc(void);		/* video-vga.c */
+
+#endif /* BOOT_VIDEO_H */
-- 
1.5.2.2

