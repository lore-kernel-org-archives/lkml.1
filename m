Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXJQG5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXJQG5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXJQG5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:57:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXJQG5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:57:07 -0400
Date: Tue, 16 Oct 2007 23:56:42 -0700
Message-Id: <200710170656.l9H6ugvf016636@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Arch Mailing list <linux-arch@vger.kernel.org>
Subject: [GIT PULL] Remove the use of magic macros for boot_params/screen_info
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git master

This patch removes all uses of magic macros to access the former
zeropage, now the boot_params structure, as well as the screen_info
structure.  The equivalent (pre-x86-merge) of the boot_params patch
has been in -mm since shortly after 2.6.22.

A minor note: the video mode number 0x6A was officially assigned by
VESA; the only VESA standard 7-bit video mode number ever assigned.

H. Peter Anvin (2):
      [x86] remove uses of magic macros for boot_params access
      Remove magic macros for screen_info structure members

 arch/arm/mach-footbridge/cats-hw.c |    6 ++--
 arch/x86/boot/Makefile             |    1 +
 arch/x86/kernel/e820_64.c          |   19 ++++++----
 arch/x86/kernel/early_printk.c     |   15 +++-----
 arch/x86/kernel/efi_32.c           |   15 +++++---
 arch/x86/kernel/head64.c           |   20 ++--------
 arch/x86/kernel/setup64.c          |    4 +-
 arch/x86/kernel/setup_32.c         |   67 +++++++++++++++++++----------------
 arch/x86/kernel/setup_64.c         |   51 ++++++++++++++-------------
 arch/x86/mach-default/setup.c      |   12 ++++---
 arch/x86/mach-visws/setup.c        |    2 +-
 arch/x86/mach-voyager/setup.c      |   14 ++++---
 arch/x86/mm/discontig_32.c         |    5 ++-
 arch/x86/xen/enlighten.c           |    7 ++--
 drivers/lguest/lguest.c            |    4 ++-
 drivers/video/console/dummycon.c   |    4 +-
 drivers/video/console/vgacon.c     |   51 ++++++++++++++-------------
 drivers/video/intelfb/intelfbdrv.c |    5 ++-
 drivers/video/vga16fb.c            |    2 +-
 include/asm-x86/Kbuild             |    1 -
 include/asm-x86/bootparam.h        |    3 ++
 include/asm-x86/bootsetup.h        |   40 ---------------------
 include/asm-x86/setup_32.h         |   29 ---------------
 include/asm-x86/setup_64.h         |   13 +++++++
 include/linux/screen_info.h        |    9 -----
 25 files changed, 173 insertions(+), 226 deletions(-)
 delete mode 100644 include/asm-x86/bootsetup.h

[Log messages and full diffs follow]

commit 3ea335100014785fd2518461705654b200e58d00
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Oct 16 22:36:04 2007 -0700

    Remove magic macros for screen_info structure members
    
    Stop using magic macros for screen_info structure members.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/arm/mach-footbridge/cats-hw.c b/arch/arm/mach-footbridge/cats-hw.c
index ef6ccc8..c261472 100644
--- a/arch/arm/mach-footbridge/cats-hw.c
+++ b/arch/arm/mach-footbridge/cats-hw.c
@@ -78,9 +78,9 @@ static void __init
 fixup_cats(struct machine_desc *desc, struct tag *tags,
 	   char **cmdline, struct meminfo *mi)
 {
-	ORIG_VIDEO_LINES  = 25;
-	ORIG_VIDEO_POINTS = 16;
-	ORIG_Y = 24;
+	screen_info.orig_video_lines  = 25;
+	screen_info.orig_video_points = 16;
+	screen_info.orig_y = 24;
 }
 
 MACHINE_START(CATS, "Chalice-CATS")
diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
index d9315d9..b63860f 100644
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -18,8 +18,8 @@
  */
 
 #if defined(__arm__)
-#define DUMMY_COLUMNS	ORIG_VIDEO_COLS
-#define DUMMY_ROWS	ORIG_VIDEO_LINES
+#define DUMMY_COLUMNS	screen_info.orig_video_cols
+#define DUMMY_ROWS	screen_info.orig_video_lines
 #elif defined(__hppa__)
 /* set by Kconfig. Use 80x25 for 640x480 and 160x64 for 1280x1024 */
 #define DUMMY_COLUMNS	CONFIG_DUMMY_CONSOLE_COLUMNS
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index a569871..f65bcd3 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -362,7 +362,7 @@ static const char *vgacon_startup(void)
 	u16 saved1, saved2;
 	volatile u16 *p;
 
-	if (ORIG_VIDEO_ISVGA == VIDEO_TYPE_VLFB) {
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
 	      no_vga:
 #ifdef CONFIG_DUMMY_CONSOLE
 		conswitchp = &dummy_con;
@@ -373,28 +373,29 @@ static const char *vgacon_startup(void)
 	}
 
 	/* boot_params.screen_info initialized? */
-	if ((ORIG_VIDEO_MODE  == 0) &&
-	    (ORIG_VIDEO_LINES == 0) &&
-	    (ORIG_VIDEO_COLS  == 0))
+	if ((screen_info.orig_video_mode  == 0) &&
+	    (screen_info.orig_video_lines == 0) &&
+	    (screen_info.orig_video_cols  == 0))
 		goto no_vga;
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
-	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
-	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
-	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */
-	    (ORIG_VIDEO_MODE == 0x6A))	/* 800x600/4, 0x6A is very common */
+	if ((screen_info.orig_video_mode == 0x0D) ||	/* 320x200/4 */
+	    (screen_info.orig_video_mode == 0x0E) ||	/* 640x200/4 */
+	    (screen_info.orig_video_mode == 0x10) ||	/* 640x350/4 */
+	    (screen_info.orig_video_mode == 0x12) ||	/* 640x480/4 */
+	    (screen_info.orig_video_mode == 0x6A))	/* 800x600/4 (VESA) */
 		goto no_vga;
 
-	vga_video_num_lines = ORIG_VIDEO_LINES;
-	vga_video_num_columns = ORIG_VIDEO_COLS;
+	vga_video_num_lines = screen_info.orig_video_lines;
+	vga_video_num_columns = screen_info.orig_video_cols;
 	state.vgabase = NULL;
 
-	if (ORIG_VIDEO_MODE == 7) {	/* Is this a monochrome display? */
+	if (screen_info.orig_video_mode == 7) {
+		/* Monochrome display */
 		vga_vram_base = 0xb0000;
 		vga_video_port_reg = VGA_CRT_IM;
 		vga_video_port_val = VGA_CRT_DM;
-		if ((ORIG_VIDEO_EGA_BX & 0xff) != 0x10) {
+		if ((screen_info.orig_video_ega_bx & 0xff) != 0x10) {
 			static struct resource ega_console_resource =
 			    { .name = "ega", .start = 0x3B0, .end = 0x3BF };
 			vga_video_type = VIDEO_TYPE_EGAM;
@@ -422,12 +423,12 @@ static const char *vgacon_startup(void)
 		vga_vram_base = 0xb8000;
 		vga_video_port_reg = VGA_CRT_IC;
 		vga_video_port_val = VGA_CRT_DC;
-		if ((ORIG_VIDEO_EGA_BX & 0xff) != 0x10) {
+		if ((screen_info.orig_video_ega_bx & 0xff) != 0x10) {
 			int i;
 
 			vga_vram_size = 0x8000;
 
-			if (!ORIG_VIDEO_ISVGA) {
+			if (!screen_info.orig_video_isVGA) {
 				static struct resource ega_console_resource
 				    = { .name = "ega", .start = 0x3C0, .end = 0x3DF };
 				vga_video_type = VIDEO_TYPE_EGAC;
@@ -521,14 +522,14 @@ static const char *vgacon_startup(void)
 	    || vga_video_type == VIDEO_TYPE_VGAC
 	    || vga_video_type == VIDEO_TYPE_EGAM) {
 		vga_hardscroll_enabled = vga_hardscroll_user_enable;
-		vga_default_font_height = ORIG_VIDEO_POINTS;
-		vga_video_font_height = ORIG_VIDEO_POINTS;
+		vga_default_font_height = screen_info.orig_video_points;
+		vga_video_font_height = screen_info.orig_video_points;
 		/* This may be suboptimal but is a safe bet - go with it */
 		vga_scan_lines =
 		    vga_video_font_height * vga_video_num_lines;
 	}
 
-	vgacon_xres = ORIG_VIDEO_COLS * VGA_FONTWIDTH;
+	vgacon_xres = screen_info.orig_video_cols * VGA_FONTWIDTH;
 	vgacon_yres = vga_scan_lines;
 
 	if (!vga_init_done) {
@@ -798,7 +799,7 @@ static int vgacon_switch(struct vc_data *c)
 {
 	int x = c->vc_cols * VGA_FONTWIDTH;
 	int y = c->vc_rows * c->vc_font.height;
-	int rows = ORIG_VIDEO_LINES * vga_default_font_height/
+	int rows = screen_info.orig_video_lines * vga_default_font_height/
 		c->vc_font.height;
 	/*
 	 * We need to save screen size here as it's the only way
@@ -818,7 +819,7 @@ static int vgacon_switch(struct vc_data *c)
 
 		if ((vgacon_xres != x || vgacon_yres != y) &&
 		    (!(vga_video_num_columns % 2) &&
-		     vga_video_num_columns <= ORIG_VIDEO_COLS &&
+		     vga_video_num_columns <= screen_info.orig_video_cols &&
 		     vga_video_num_lines <= rows))
 			vgacon_doresize(c, c->vc_cols, c->vc_rows);
 	}
@@ -1280,8 +1281,8 @@ static int vgacon_font_get(struct vc_data *c, struct console_font *font)
 static int vgacon_resize(struct vc_data *c, unsigned int width,
 			 unsigned int height, unsigned int user)
 {
-	if (width % 2 || width > ORIG_VIDEO_COLS ||
-	    height > (ORIG_VIDEO_LINES * vga_default_font_height)/
+	if (width % 2 || width > screen_info.orig_video_cols ||
+	    height > (screen_info.orig_video_lines * vga_default_font_height)/
 	    c->vc_font.height)
 		/* let svgatextmode tinker with video timings and
 		   return success */
@@ -1313,8 +1314,8 @@ static void vgacon_save_screen(struct vc_data *c)
 		 * console initialization routines.
 		 */
 		vga_bootup_console = 1;
-		c->vc_x = ORIG_X;
-		c->vc_y = ORIG_Y;
+		c->vc_x = screen_info.orig_x;
+		c->vc_y = screen_info.orig_y;
 	}
 
 	/* We can't copy in more then the size of the video buffer,
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 0428f21..e8e38ed 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -804,7 +804,8 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
 	if (bailearly == 1)
 		bailout(dinfo);
 
-	if (FIXED_MODE(dinfo) && ORIG_VIDEO_ISVGA != VIDEO_TYPE_VLFB) {
+	if (FIXED_MODE(dinfo) &&
+	    screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB) {
 		ERR_MSG("Video mode must be programmed at boot time.\n");
 		cleanup(dinfo);
 		return -ENODEV;
@@ -815,7 +816,7 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
 
 	/* Initialise dinfo and related data. */
 	/* If an initial mode was programmed at boot time, get its details. */
-	if (ORIG_VIDEO_ISVGA == VIDEO_TYPE_VLFB)
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB)
 		get_initial_mode(dinfo);
 
 	if (bailearly == 3)
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 2a14d28..9b3c592 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1364,7 +1364,7 @@ static int __init vga16fb_probe(struct platform_device *dev)
 	par = info->par;
 
 	mutex_init(&par->open_lock);
-	par->isVGA = ORIG_VIDEO_ISVGA;
+	par->isVGA = screen_info.orig_video_isVGA;
 	par->palette_blanked = 0;
 	par->vesa_blanked = 0;
 
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 3ee412b..ba81ffe 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -47,15 +47,6 @@ struct screen_info {
 
 extern struct screen_info screen_info;
 
-#define ORIG_X			(screen_info.orig_x)
-#define ORIG_Y			(screen_info.orig_y)
-#define ORIG_VIDEO_MODE		(screen_info.orig_video_mode)
-#define ORIG_VIDEO_COLS 	(screen_info.orig_video_cols)
-#define ORIG_VIDEO_EGA_BX	(screen_info.orig_video_ega_bx)
-#define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
-#define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
-#define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
-
 #define VIDEO_TYPE_MDA		0x10	/* Monochrome Text Display	*/
 #define VIDEO_TYPE_CGA		0x11	/* CGA Display 			*/
 #define VIDEO_TYPE_EGAM		0x20	/* EGA/VGA in Monochrome Mode	*/

commit 30c826451d3e5bbc6e11bba0e7fee5d2f49d9b75
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Oct 15 17:13:22 2007 -0700

    [x86] remove uses of magic macros for boot_params access
    
    Instead of using magic macros for boot_params access, simply use the
    boot_params structure.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index e8756e5..89dbf97 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -39,6 +39,7 @@ setup-y		+= printf.o string.o tty.o video.o version.o voyager.o
 setup-y		+= video-vga.o
 setup-y		+= video-vesa.o
 setup-y		+= video-bios.o
+
 targets		+= $(setup-y)
 hostprogs-y	:= tools/build
 
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 0f4d5e2..e422b81 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -24,7 +24,7 @@
 #include <asm/page.h>
 #include <asm/e820.h>
 #include <asm/proto.h>
-#include <asm/bootsetup.h>
+#include <asm/setup.h>
 #include <asm/sections.h>
 
 struct e820map e820;
@@ -68,10 +68,15 @@ static inline int bad_addr(unsigned long *addrp, unsigned long size)
 
 	/* initrd */ 
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (LOADER_TYPE && INITRD_START && last >= INITRD_START && 
-	    addr < INITRD_START+INITRD_SIZE) { 
-		*addrp = PAGE_ALIGN(INITRD_START + INITRD_SIZE);
-		return 1;
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image+ramdisk_size;
+
+		if (last >= ramdisk_image && addr < ramdisk_end) {
+			*addrp = PAGE_ALIGN(ramdisk_end);
+			return 1;
+		}
 	} 
 #endif
 	/* kernel code */
@@ -594,8 +599,8 @@ void __init setup_memory_region(void)
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(E820_MAP, &E820_MAP_NR);
-	if (copy_e820_map(E820_MAP, E820_MAP_NR) < 0)
+	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0)
 		early_panic("Cannot find a valid memory map");
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map("BIOS-e820");
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index fd9aff3..b7d6c23 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -6,15 +6,10 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
+#include <asm/setup.h>
 #include <xen/hvc-console.h>
 
 /* Simple VGA output */
-
-#ifdef __i386__
-#include <asm/setup.h>
-#else
-#include <asm/bootsetup.h>
-#endif
 #define VGABASE		(__ISA_IO_base + 0xb8000)
 
 static int max_ypos = 25, max_xpos = 80;
@@ -234,10 +229,10 @@ static int __init setup_early_printk(char *buf)
 		early_serial_init(buf);
 		early_console = &early_serial_console;
 	} else if (!strncmp(buf, "vga", 3)
-	           && SCREEN_INFO.orig_video_isVGA == 1) {
-		max_xpos = SCREEN_INFO.orig_video_cols;
-		max_ypos = SCREEN_INFO.orig_video_lines;
-		current_ypos = SCREEN_INFO.orig_y;
+	           && boot_params.screen_info.orig_video_isVGA == 1) {
+		max_xpos = boot_params.screen_info.orig_video_cols;
+		max_ypos = boot_params.screen_info.orig_video_lines;
+		current_ypos = boot_params.screen_info.orig_y;
 		early_console = &early_vga_console;
  	} else if (!strncmp(buf, "simnow", 6)) {
  		simnow_init(buf + 6);
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index 2452c6f..b42558c 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -331,11 +331,13 @@ void __init efi_init(void)
 	memset(&efi, 0, sizeof(efi) );
 	memset(&efi_phys, 0, sizeof(efi_phys));
 
-	efi_phys.systab = EFI_SYSTAB;
-	memmap.phys_map = EFI_MEMMAP;
-	memmap.nr_map = EFI_MEMMAP_SIZE/EFI_MEMDESC_SIZE;
-	memmap.desc_version = EFI_MEMDESC_VERSION;
-	memmap.desc_size = EFI_MEMDESC_SIZE;
+	efi_phys.systab =
+		(efi_system_table_t *)boot_params.efi_info.efi_systab;
+	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
+	memmap.nr_map = boot_params.efi_info.efi_memmap_size/
+		boot_params.efi_info.efi_memdesc_size;
+	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
+	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 
 	efi.systab = (efi_system_table_t *)
 		boot_ioremap((unsigned long) efi_phys.systab,
@@ -446,7 +448,8 @@ void __init efi_init(void)
 		printk(KERN_ERR PFX "Could not map the runtime service table!\n");
 
 	/* Map the EFI memory map for use until paging_init() */
-	memmap.map = boot_ioremap((unsigned long) EFI_MEMMAP, EFI_MEMMAP_SIZE);
+	memmap.map = boot_ioremap(boot_params.efi_info.efi_memmap,
+				  boot_params.efi_info.efi_memmap_size);
 	if (memmap.map == NULL)
 		printk(KERN_ERR PFX "Could not map the EFI memory map!\n");
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 8561f62..a7eee0a 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -14,7 +14,6 @@
 #include <asm/processor.h>
 #include <asm/proto.h>
 #include <asm/smp.h>
-#include <asm/bootsetup.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
@@ -36,26 +35,15 @@ static void __init clear_bss(void)
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
 }
 
-#define NEW_CL_POINTER		0x228	/* Relative to real mode data */
-#define OLD_CL_MAGIC_ADDR	0x20
-#define OLD_CL_MAGIC            0xA33F
-#define OLD_CL_OFFSET           0x22
-
 static void __init copy_bootdata(char *real_mode_data)
 {
-	unsigned long new_data;
 	char * command_line;
 
-	memcpy(x86_boot_params, real_mode_data, BOOT_PARAM_SIZE);
-	new_data = *(u32 *) (x86_boot_params + NEW_CL_POINTER);
-	if (!new_data) {
-		if (OLD_CL_MAGIC != *(u16 *)(real_mode_data + OLD_CL_MAGIC_ADDR)) {
-			return;
-		}
-		new_data = __pa(real_mode_data) + *(u16 *)(real_mode_data + OLD_CL_OFFSET);
+	memcpy(&boot_params, real_mode_data, sizeof boot_params);
+	if (boot_params.hdr.cmd_line_ptr) {
+		command_line = __va(boot_params.hdr.cmd_line_ptr);
+		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
-	command_line = __va(new_data);
-	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 1200aaa..ba91882 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -11,7 +11,6 @@
 #include <linux/bootmem.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
-#include <asm/bootsetup.h>
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -23,8 +22,9 @@
 #include <asm/percpu.h>
 #include <asm/proto.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 
-char x86_boot_params[BOOT_PARAM_SIZE] __initdata;
+struct boot_params __initdata boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index c8e1bc3..b87a6fd 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -137,10 +137,11 @@ EXPORT_SYMBOL(edd);
  */
 static inline void copy_edd(void)
 {
-     memcpy(edd.mbr_signature, EDD_MBR_SIGNATURE, sizeof(edd.mbr_signature));
-     memcpy(edd.edd_info, EDD_BUF, sizeof(edd.edd_info));
-     edd.mbr_signature_nr = EDD_MBR_SIG_NR;
-     edd.edd_info_nr = EDD_NR;
+     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
+	    sizeof(edd.mbr_signature));
+     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
+     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
+     edd.edd_info_nr = boot_params.eddbuf_entries;
 }
 #else
 static inline void copy_edd(void)
@@ -434,17 +435,20 @@ void __init setup_bootmem_allocator(void)
 #endif
 	numa_kva_reserve();
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (LOADER_TYPE && INITRD_START) {
-		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
-			reserve_bootmem(INITRD_START, INITRD_SIZE);
-			initrd_start = INITRD_START + PAGE_OFFSET;
-			initrd_end = initrd_start+INITRD_SIZE;
-		}
-		else {
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+
+		if (ramdisk_end <= end_of_lowmem) {
+			reserve_bootmem(ramdisk_image, ramdisk_size);
+			initrd_start = ramdisk_image + PAGE_OFFSET;
+			initrd_end = initrd_start+ramdisk_size;
+		} else {
 			printk(KERN_ERR "initrd extends beyond end of memory "
-			    "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-			    INITRD_START + INITRD_SIZE,
-			    max_low_pfn << PAGE_SHIFT);
+			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+			       ramdisk_end, end_of_lowmem);
 			initrd_start = 0;
 		}
 	}
@@ -512,28 +516,29 @@ void __init setup_arch(char **cmdline_p)
 	 * the system table is valid.  If not, then initialize normally.
 	 */
 #ifdef CONFIG_EFI
-	if ((LOADER_TYPE == 0x50) && EFI_SYSTAB)
+	if ((boot_params.hdr.type_of_loader == 0x50) &&
+	    boot_params.efi_info.efi_systab)
 		efi_enabled = 1;
 #endif
 
- 	ROOT_DEV = old_decode_dev(ORIG_ROOT_DEV);
- 	screen_info = SCREEN_INFO;
-	edid_info = EDID_INFO;
-	apm_info.bios = APM_BIOS_INFO;
-	ist_info = IST_INFO;
-	saved_videomode = VIDEO_MODE;
-	if( SYS_DESC_TABLE.length != 0 ) {
-		set_mca_bus(SYS_DESC_TABLE.table[3] & 0x2);
-		machine_id = SYS_DESC_TABLE.table[0];
-		machine_submodel_id = SYS_DESC_TABLE.table[1];
-		BIOS_revision = SYS_DESC_TABLE.table[2];
+	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
+	screen_info = boot_params.screen_info;
+	edid_info = boot_params.edid_info;
+	apm_info.bios = boot_params.apm_bios_info;
+	ist_info = boot_params.ist_info;
+	saved_videomode = boot_params.hdr.vid_mode;
+	if( boot_params.sys_desc_table.length != 0 ) {
+		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
+		machine_id = boot_params.sys_desc_table.table[0];
+		machine_submodel_id = boot_params.sys_desc_table.table[1];
+		BIOS_revision = boot_params.sys_desc_table.table[2];
 	}
-	bootloader_type = LOADER_TYPE;
+	bootloader_type = boot_params.hdr.type_of_loader;
 
 #ifdef CONFIG_BLK_DEV_RAM
-	rd_image_start = RAMDISK_FLAGS & RAMDISK_IMAGE_START_MASK;
-	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
-	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
+	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
+	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
+	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
 	ARCH_SETUP
 	if (efi_enabled)
@@ -545,7 +550,7 @@ void __init setup_arch(char **cmdline_p)
 
 	copy_edd();
 
-	if (!MOUNT_ROOT_RDONLY)
+	if (!boot_params.hdr.root_flags)
 		root_mountflags &= ~MS_RDONLY;
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 85b5b63..8159bf0 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -52,7 +52,6 @@
 #include <asm/dma.h>
 #include <asm/mpspec.h>
 #include <asm/mmu_context.h>
-#include <asm/bootsetup.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
 #include <asm/mach_apic.h>
@@ -180,10 +179,11 @@ EXPORT_SYMBOL(edd);
  */
 static inline void copy_edd(void)
 {
-     memcpy(edd.mbr_signature, EDD_MBR_SIGNATURE, sizeof(edd.mbr_signature));
-     memcpy(edd.edd_info, EDD_BUF, sizeof(edd.edd_info));
-     edd.mbr_signature_nr = EDD_MBR_SIG_NR;
-     edd.edd_info_nr = EDD_NR;
+     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
+	    sizeof(edd.mbr_signature));
+     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
+     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
+     edd.edd_info_nr = boot_params.eddbuf_entries;
 }
 #else
 static inline void copy_edd(void)
@@ -220,21 +220,21 @@ void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
- 	ROOT_DEV = old_decode_dev(ORIG_ROOT_DEV);
- 	screen_info = SCREEN_INFO;
-	edid_info = EDID_INFO;
-	saved_video_mode = SAVED_VIDEO_MODE;
-	bootloader_type = LOADER_TYPE;
+	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
+	screen_info = boot_params.screen_info;
+	edid_info = boot_params.edid_info;
+	saved_video_mode = boot_params.hdr.vid_mode;
+	bootloader_type = boot_params.hdr.type_of_loader;
 
 #ifdef CONFIG_BLK_DEV_RAM
-	rd_image_start = RAMDISK_FLAGS & RAMDISK_IMAGE_START_MASK;
-	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
-	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
+	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
+	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
+	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
 	setup_memory_region();
 	copy_edd();
 
-	if (!MOUNT_ROOT_RDONLY)
+	if (!boot_params.hdr.root_flags)
 		root_mountflags &= ~MS_RDONLY;
 	init_mm.start_code = (unsigned long) &_text;
 	init_mm.end_code = (unsigned long) &_etext;
@@ -339,17 +339,20 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	find_smp_config();
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (LOADER_TYPE && INITRD_START) {
-		if (INITRD_START + INITRD_SIZE <= (end_pfn << PAGE_SHIFT)) {
-			reserve_bootmem_generic(INITRD_START, INITRD_SIZE);
-			initrd_start = INITRD_START + PAGE_OFFSET;
-			initrd_end = initrd_start+INITRD_SIZE;
-		}
-		else {
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
+
+		if (ramdisk_end <= end_of_mem) {
+			reserve_bootmem_generic(ramdisk_image, ramdisk_size);
+			initrd_start = ramdisk_image + PAGE_OFFSET;
+			initrd_end = initrd_start+ramdisk_size;
+		} else {
 			printk(KERN_ERR "initrd extends beyond end of memory "
-			    "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-			    (unsigned long)(INITRD_START + INITRD_SIZE),
-			    (unsigned long)(end_pfn << PAGE_SHIFT));
+			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+			       ramdisk_end, end_of_mem);
 			initrd_start = 0;
 		}
 	}
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 7f635c7..1bd8298 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -159,16 +159,18 @@ char * __init machine_specific_memory_setup(void)
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(E820_MAP, &E820_MAP_NR);
-	if (copy_e820_map(E820_MAP, E820_MAP_NR) < 0) {
+	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
+	    < 0) {
 		unsigned long mem_size;
 
 		/* compare results from other methods and take the greater */
-		if (ALT_MEM_K < EXT_MEM_K) {
-			mem_size = EXT_MEM_K;
+		if (boot_params.alt_mem_k
+		    < boot_params.screen_info.ext_mem_k) {
+			mem_size = boot_params.screen_info.ext_mem_k;
 			who = "BIOS-88";
 		} else {
-			mem_size = ALT_MEM_K;
+			mem_size = boot_params.alt_mem_k;
 			who = "BIOS-e801";
 		}
 
diff --git a/arch/x86/mach-visws/setup.c b/arch/x86/mach-visws/setup.c
index 1f81f10..de4c9db 100644
--- a/arch/x86/mach-visws/setup.c
+++ b/arch/x86/mach-visws/setup.c
@@ -152,7 +152,7 @@ char * __init machine_specific_memory_setup(void)
 {
 	long long gfx_mem_size = 8 * MB;
 
-	mem_size = ALT_MEM_K;
+	mem_size = boot_params.alt_mem_k;
 
 	if (!mem_size) {
 		printk(KERN_WARNING "Bootloader didn't set memory size, upgrade it !\n");
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 2b55694..a0ab400 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -83,7 +83,7 @@ char * __init machine_specific_memory_setup(void)
 
 		if(inb(catbase) != VOYAGER_DINO) {
 			printk(KERN_ERR "Voyager: Failed to get DINO for L4, setting tom to EXT_MEM_K\n");
-			tom = (EXT_MEM_K)<<10;
+			tom = (boot_params.screen_info.ext_mem_k)<<10;
 		}
 		who = "Voyager-TOM";
 		add_memory_region(0, 0x9f000, E820_RAM);
@@ -104,16 +104,18 @@ char * __init machine_specific_memory_setup(void)
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
-	sanitize_e820_map(E820_MAP, &E820_MAP_NR);
-	if (copy_e820_map(E820_MAP, E820_MAP_NR) < 0) {
+	sanitize_e820_map(boot_params.e820_map, &boot_params.e820_entries);
+	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
+	    < 0) {
 		unsigned long mem_size;
 
 		/* compare results from other methods and take the greater */
-		if (ALT_MEM_K < EXT_MEM_K) {
-			mem_size = EXT_MEM_K;
+		if (boot_params.alt_mem_k
+		    < boot_params.screen_info.ext_mem_k) {
+			mem_size = boot_params.screen_info.ext_mem_k;
 			who = "BIOS-88";
 		} else {
-			mem_size = ALT_MEM_K;
+			mem_size = boot_params.alt_mem_k;
 			who = "BIOS-e801";
 		}
 
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 860e912..b1e4545 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -288,8 +288,9 @@ unsigned long __init setup_memory(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Numa kva area is below the initrd */
-	if (LOADER_TYPE && INITRD_START)
-		kva_start_pfn = PFN_DOWN(INITRD_START)  - kva_pages;
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
+		kva_start_pfn = PFN_DOWN(boot_params.hdr.ramdisk_image)
+			- kva_pages;
 #endif
 	kva_start_pfn -= kva_start_pfn & (PTRS_PER_PTE-1);
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f01bfcd..493a083 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1137,9 +1137,10 @@ asmlinkage void __init xen_start_kernel(void)
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 
 	/* Poke various useful things into boot_params */
-	LOADER_TYPE = (9 << 4) | 0;
-	INITRD_START = xen_start_info->mod_start ? __pa(xen_start_info->mod_start) : 0;
-	INITRD_SIZE = xen_start_info->mod_len;
+	boot_params.hdr.type_of_loader = (9 << 4) | 0;
+	boot_params.hdr.ramdisk_image = xen_start_info->mod_start
+		? __pa(xen_start_info->mod_start) : 0;
+	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
 	/* Start the world */
 	start_kernel();
diff --git a/drivers/lguest/lguest.c b/drivers/lguest/lguest.c
index ee1c6d0..4a579c8 100644
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -893,7 +893,9 @@ static __init char *lguest_memory_setup(void)
 
 	/* The Linux bootloader header contains an "e820" memory map: the
 	 * Launcher populated the first entry with our memory limit. */
-	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
+	add_memory_region(boot_params.e820_map[0].addr,
+			  boot_params.e820_map[0].size,
+			  boot_params.e820_map[0].type);
 
 	/* This string is for the boot messages. */
 	return "LGUEST";
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index e9afb7e..a569871 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -372,7 +372,7 @@ static const char *vgacon_startup(void)
 #endif
 	}
 
-	/* SCREEN_INFO initialized? */
+	/* boot_params.screen_info initialized? */
 	if ((ORIG_VIDEO_MODE  == 0) &&
 	    (ORIG_VIDEO_LINES == 0) &&
 	    (ORIG_VIDEO_COLS  == 0))
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index c5e43cb..80744db 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -1,7 +1,6 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += boot.h
-header-y += bootsetup.h
 header-y += debugreg_32.h
 header-y += debugreg_64.h
 header-y += debugreg.h
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index b91b017..ef67b59 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -14,6 +14,9 @@ struct setup_header {
 	u16	root_flags;
 	u32	syssize;
 	u16	ram_size;
+#define RAMDISK_IMAGE_START_MASK	0x07FF
+#define RAMDISK_PROMPT_FLAG		0x8000
+#define RAMDISK_LOAD_FLAG		0x4000
 	u16	vid_mode;
 	u16	root_dev;
 	u16	boot_flag;
diff --git a/include/asm-x86/bootsetup.h b/include/asm-x86/bootsetup.h
deleted file mode 100644
index 7b1c3ad..0000000
--- a/include/asm-x86/bootsetup.h
+++ /dev/null
@@ -1,40 +0,0 @@
-
-#ifndef _X86_64_BOOTSETUP_H
-#define _X86_64_BOOTSETUP_H 1
-
-#define BOOT_PARAM_SIZE		4096
-extern char x86_boot_params[BOOT_PARAM_SIZE];
-
-/*
- * This is set up by the setup-routine at boot-time
- */
-#define PARAM	((unsigned char *)x86_boot_params)
-#define SCREEN_INFO (*(struct screen_info *) (PARAM+0))
-#define EXT_MEM_K (*(unsigned short *) (PARAM+2))
-#define ALT_MEM_K (*(unsigned int *) (PARAM+0x1e0))
-#define E820_MAP_NR (*(char*) (PARAM+E820NR))
-#define E820_MAP    ((struct e820entry *) (PARAM+E820MAP))
-#define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
-#define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
-#define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
-#define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
-#define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
-#define SAVED_VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
-#define ORIG_ROOT_DEV (*(unsigned short *) (PARAM+0x1FC))
-#define AUX_DEVICE_INFO (*(unsigned char *) (PARAM+0x1FF))
-#define LOADER_TYPE (*(unsigned char *) (PARAM+0x210))
-#define KERNEL_START (*(unsigned int *) (PARAM+0x214))
-#define INITRD_START (*(unsigned int *) (PARAM+0x218))
-#define INITRD_SIZE (*(unsigned int *) (PARAM+0x21c))
-#define EDID_INFO (*(struct edid_info *) (PARAM+0x140))
-#define EDD_NR     (*(unsigned char *) (PARAM+EDDNR))
-#define EDD_MBR_SIG_NR (*(unsigned char *) (PARAM+EDD_MBR_SIG_NR_BUF))
-#define EDD_MBR_SIGNATURE ((unsigned int *) (PARAM+EDD_MBR_SIG_BUF))
-#define EDD_BUF     ((struct edd_info *) (PARAM+EDDBUF))
-#define COMMAND_LINE boot_command_line
-
-#define RAMDISK_IMAGE_START_MASK  	0x07FF
-#define RAMDISK_PROMPT_FLAG		0x8000
-#define RAMDISK_LOAD_FLAG		0x4000	
-
-#endif
diff --git a/include/asm-x86/setup_32.h b/include/asm-x86/setup_32.h
index 7862fe8..7a57ca8 100644
--- a/include/asm-x86/setup_32.h
+++ b/include/asm-x86/setup_32.h
@@ -34,35 +34,6 @@
  */
 extern struct boot_params boot_params;
 
-#define PARAM	((char *)&boot_params)
-#define SCREEN_INFO (*(struct screen_info *) (PARAM+0))
-#define EXT_MEM_K (*(unsigned short *) (PARAM+2))
-#define ALT_MEM_K (*(unsigned long *) (PARAM+0x1e0))
-#define E820_MAP_NR (*(char*) (PARAM+E820NR))
-#define E820_MAP    ((struct e820entry *) (PARAM+E820MAP))
-#define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
-#define IST_INFO   (*(struct ist_info *) (PARAM+0x60))
-#define SYS_DESC_TABLE (*(struct sys_desc_table *)(PARAM+0xa0))
-#define EFI_SYSTAB ((efi_system_table_t *) *((unsigned long *)(PARAM+0x1c4)))
-#define EFI_MEMDESC_SIZE (*((unsigned long *) (PARAM+0x1c8)))
-#define EFI_MEMDESC_VERSION (*((unsigned long *) (PARAM+0x1cc)))
-#define EFI_MEMMAP ((void *) *((unsigned long *)(PARAM+0x1d0)))
-#define EFI_MEMMAP_SIZE (*((unsigned long *) (PARAM+0x1d4)))
-#define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
-#define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
-#define VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
-#define ORIG_ROOT_DEV (*(unsigned short *) (PARAM+0x1FC))
-#define AUX_DEVICE_INFO (*(unsigned char *) (PARAM+0x1FF))
-#define LOADER_TYPE (*(unsigned char *) (PARAM+0x210))
-#define KERNEL_START (*(unsigned long *) (PARAM+0x214))
-#define INITRD_START (*(unsigned long *) (PARAM+0x218))
-#define INITRD_SIZE (*(unsigned long *) (PARAM+0x21c))
-#define EDID_INFO   (*(struct edid_info *) (PARAM+0x140))
-#define EDD_NR     (*(unsigned char *) (PARAM+EDDNR))
-#define EDD_MBR_SIG_NR (*(unsigned char *) (PARAM+EDD_MBR_SIG_NR_BUF))
-#define EDD_MBR_SIGNATURE ((unsigned int *) (PARAM+EDD_MBR_SIG_BUF))
-#define EDD_BUF     ((struct edd_info *) (PARAM+EDDBUF))
-
 /*
  * Do NOT EVER look at the BIOS memory size location.
  * It does not work on many machines.
diff --git a/include/asm-x86/setup_64.h b/include/asm-x86/setup_64.h
index eaeff73..a04aadc 100644
--- a/include/asm-x86/setup_64.h
+++ b/include/asm-x86/setup_64.h
@@ -3,4 +3,17 @@
 
 #define COMMAND_LINE_SIZE	2048
 
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#include <asm/bootparam.h>
+
+/*
+ * This is set up by the setup-routine at boot-time
+ */
+extern struct boot_params boot_params;
+
+#endif /* not __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
 #endif
