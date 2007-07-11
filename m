Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbXGKTX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbXGKTX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761797AbXGKTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761523AbXGKTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 10/33] Make struct boot_params a real structure, and remove obsolete fields
Date: Wed, 11 Jul 2007 12:18:35 -0700
Message-Id: <11841815403041-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815403678-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
Message-Id: <ee5aac7aaaa45d7bab8fe9bc2e5ac4fb8b9c3e44.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Make struct boot_params a real structure, and remove the handling of
some obsolete fields, in particular hd*_info, which was only used by
the ST-506 driver, and likely to be wrong for that driver on any
modern BIOS.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/setup.c       |   12 +-----
 include/asm-i386/bootparam.h   |   85 ++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/setup.h       |   10 +++--
 include/asm-x86_64/boot.h      |   16 +-------
 include/asm-x86_64/bootparam.h |    1 +
 5 files changed, 94 insertions(+), 30 deletions(-)
 create mode 100644 include/asm-i386/bootparam.h
 create mode 100644 include/asm-x86_64/bootparam.h

diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 698c24f..2d61e65 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -102,19 +102,10 @@ static unsigned int highmem_pages = -1;
 /*
  * Setup options
  */
-struct drive_info_struct { char dummy[32]; } drive_info;
-#if defined(CONFIG_BLK_DEV_IDE) || defined(CONFIG_BLK_DEV_HD) || \
-    defined(CONFIG_BLK_DEV_IDE_MODULE) || defined(CONFIG_BLK_DEV_HD_MODULE)
-EXPORT_SYMBOL(drive_info);
-#endif
 struct screen_info screen_info;
 EXPORT_SYMBOL(screen_info);
 struct apm_info apm_info;
 EXPORT_SYMBOL(apm_info);
-struct sys_desc_table_struct {
-	unsigned short length;
-	unsigned char table[0];
-};
 struct edid_info edid_info;
 EXPORT_SYMBOL_GPL(edid_info);
 struct ist_info ist_info;
@@ -134,7 +125,7 @@ unsigned long saved_videomode;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-unsigned char __initdata boot_params[PARAM_SIZE];
+struct boot_params __initdata boot_params;
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
@@ -528,7 +519,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
  	ROOT_DEV = old_decode_dev(ORIG_ROOT_DEV);
- 	drive_info = DRIVE_INFO;
  	screen_info = SCREEN_INFO;
 	edid_info = EDID_INFO;
 	apm_info.bios = APM_BIOS_INFO;
diff --git a/include/asm-i386/bootparam.h b/include/asm-i386/bootparam.h
new file mode 100644
index 0000000..427d865
--- /dev/null
+++ b/include/asm-i386/bootparam.h
@@ -0,0 +1,85 @@
+#ifndef _ASM_BOOTPARAM_H
+#define _ASM_BOOTPARAM_H
+
+#include <linux/types.h>
+#include <linux/screen_info.h>
+#include <linux/apm_bios.h>
+#include <asm/e820.h>
+#include <linux/edd.h>
+#include <video/edid.h>
+
+struct setup_header {
+	u8	setup_sects;
+	u16	root_flags;
+	u32	syssize;
+	u16	ram_size;
+	u16	vid_mode;
+	u16	root_dev;
+	u16	boot_flag;
+	u16	jump;
+	u32	header;
+	u16	version;
+	u32	realmode_swtch;
+	u16	start_sys;
+	u16	kernel_version;
+	u8	type_of_loader;
+	u8	loadflags;
+#define LOADED_HIGH	0x01
+#define CAN_USE_HEAP	0x80
+	u16	setup_move_size;
+	u32	code32_start;
+	u32	ramdisk_image;
+	u32	ramdisk_size;
+	u32	bootsect_kludge;
+	u16	heap_end_ptr;
+	u16	_pad1;
+	u32	cmd_line_ptr;
+	u32	initrd_addr_max;
+	u32	kernel_alignment;
+	u8	relocatable_kernel;
+} __attribute__((packed));
+
+struct sys_desc_table {
+	u16 length;
+	u8  table[14];
+};
+
+struct efi_info {
+	u32 _pad1;
+	u32 efi_systab;
+	u32 efi_memdesc_size;
+	u32 efi_memdec_version;
+	u32 efi_memmap;
+	u32 fi_memmap_size;
+	u32 _pad2[2];
+};
+
+/* The so-called "zeropage" */
+struct boot_params {
+	struct screen_info screen_info;			/* 0x000 */
+	struct apm_bios_info apm_bios_info;		/* 0x040 */
+	u8  _pad2[12];					/* 0x054 */
+	u32 speedstep_info[4];				/* 0x060 */
+	u8  _pad3[16];					/* 0x070 */
+	u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
+	u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
+	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
+	u8  _pad4[144];					/* 0x0b0 */
+	struct edid_info edid_info;			/* 0x140 */
+	struct efi_info efi_info;			/* 0x1c0 */
+	u32 alt_mem_k;					/* 0x1e0 */
+	u32 scratch;		/* Scratch field! */	/* 0x1e4 */
+	u8  e820_entries;				/* 0x1e8 */
+	u8  eddbuf_entries;				/* 0x1e9 */
+	u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
+	u8  _pad6[6];					/* 0x1eb */
+	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
+	u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
+	u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
+	struct e820entry e820_map[E820MAX];		/* 0x2d0 */
+	u8  _pad8[48];					/* 0xcd0 */
+	struct edd_info eddbuf[EDDMAXNR];		/* 0xd00 */
+	u8  _pad9[276];					/* 0xeec */
+} __attribute__((packed));
+
+#endif /* _ASM_BOOTPARAM_H */
diff --git a/include/asm-i386/setup.h b/include/asm-i386/setup.h
index 0e8077c..0d5bff9 100644
--- a/include/asm-i386/setup.h
+++ b/include/asm-i386/setup.h
@@ -26,12 +26,15 @@
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
 
 #ifndef __ASSEMBLY__
+
+#include <asm/bootparam.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
-extern unsigned char boot_params[PARAM_SIZE];
+extern struct boot_params boot_params;
 
-#define PARAM	(boot_params)
+#define PARAM	((char *)&boot_params)
 #define SCREEN_INFO (*(struct screen_info *) (PARAM+0))
 #define EXT_MEM_K (*(unsigned short *) (PARAM+2))
 #define ALT_MEM_K (*(unsigned long *) (PARAM+0x1e0))
@@ -39,8 +42,7 @@ extern unsigned char boot_params[PARAM_SIZE];
 #define E820_MAP    ((struct e820entry *) (PARAM+E820MAP))
 #define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
 #define IST_INFO   (*(struct ist_info *) (PARAM+0x60))
-#define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
-#define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
+#define SYS_DESC_TABLE (*(struct sys_desc_table *)(PARAM+0xa0))
 #define EFI_SYSTAB ((efi_system_table_t *) *((unsigned long *)(PARAM+0x1c4)))
 #define EFI_MEMDESC_SIZE (*((unsigned long *) (PARAM+0x1c8)))
 #define EFI_MEMDESC_VERSION (*((unsigned long *) (PARAM+0x1cc)))
diff --git a/include/asm-x86_64/boot.h b/include/asm-x86_64/boot.h
index 96b228e..3c46cea 100644
--- a/include/asm-x86_64/boot.h
+++ b/include/asm-x86_64/boot.h
@@ -1,15 +1 @@
-#ifndef _LINUX_BOOT_H
-#define _LINUX_BOOT_H
-
-/* Don't touch these, unless you really know what you're doing. */
-#define DEF_INITSEG	0x9000
-#define DEF_SYSSEG	0x1000
-#define DEF_SETUPSEG	0x9020
-#define DEF_SYSSIZE	0x7F00
-
-/* Internal svga startup constants */
-#define NORMAL_VGA	0xffff		/* 80x25 mode */
-#define EXTENDED_VGA	0xfffe		/* 80x50 mode */
-#define ASK_VGA		0xfffd		/* ask for it at bootup */
-
-#endif
+#include <asm-i386/boot.h>
diff --git a/include/asm-x86_64/bootparam.h b/include/asm-x86_64/bootparam.h
new file mode 100644
index 0000000..aa82e52
--- /dev/null
+++ b/include/asm-x86_64/bootparam.h
@@ -0,0 +1 @@
+#include <asm-i386/bootparam.h>
-- 
1.5.2.2

