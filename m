Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYBHV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYBHV6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYBHV6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:58:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37807 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752188AbYBHV6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:58:00 -0500
Date: Fri, 8 Feb 2008 22:58:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208215809.GN12923@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl> <47AB887E.7010000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB887E.7010000@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Rafael, this is for you. My cleanups, relative to your cleanup
patch. You may need manual patching around rep/stosd.

								Pavel

diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index b239f0f..0e4742b 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -46,7 +46,10 @@ KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__AS
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
 LDFLAGS_wakeup.elf	:= -T
-$(obj)/wakeup.elf: $(src)/wakeup.ld $(WAKEUP_OBJS) FORCE
+
+CPPFLAGS_wakeup.lds += -P -C
+
+$(obj)/wakeup.elf: $(src)/wakeup.lds $(WAKEUP_OBJS) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_wakeup.bin	:= -O binary
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 26145c0..edff763 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -56,14 +56,6 @@ _start:
 	cmpl	$0x65a22c82, %eax
 	jne	bogus_real_magic
 
-	/* Zero the bss */
-	xorl	%eax, %eax
-	movw	$__bss_start, %di
-	movw	$__bss_end + 3, %cx
-	subw	%di, %cx
-	shrw	$2, %cx
-	rep; stosl
-
 	/* Call the C code */
 	calll	main
 
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index 4a26e27..6a49435 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -6,12 +6,11 @@
 #ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
 #define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
 
+#ifndef __ASSEMBLY__
 #include <linux/types.h>
 
 /* This must match data at wakeup.S */
 struct wakeup_header {
-	u16 entry;		/* unused */
-	u16 total;		/* unused */
 	u16 video_mode;		/* Video mode number */
 	u16 _jmp1;
 	u32 pmode_entry;	/* Protected mode resume point */
@@ -27,5 +26,10 @@ struct wakeup_header {
 	u16 trampoline_segment;
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
+#endif
+
+#define HEADER_OFFSET 0x3f00
+#define WAKEUP_SIZE   0x4000
+
 
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.ld b/arch/x86/kernel/acpi/realmode/wakeup.ld
deleted file mode 100644
index 5dff2f0..0000000
--- a/arch/x86/kernel/acpi/realmode/wakeup.ld
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * wakeup.ld
- *
- * Linker script for the real-mode wakeup code
- */
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(_start)
-
-SECTIONS
-{
-	. = 0x3f00;
-	.header		: { *(.header) }
-
-	. = 0;
-	.text		: { *(.text*) }
-
-	. = ALIGN(16);
-	.rodata		: { *(.rodata*) }
-
-	.videocards	: {
-		video_cards = .;
-		*(.videocards)
-		video_cards_end = .;
-	}
-
-	. = ALIGN(16);
-	.data		: { *(.data*) }
-
-	.signature	: {
-		end_signature = .;
-		LONG(0x65a22c82)
-	}
-
-	. = ALIGN(16);
-	.bss		:
-	{
-		__bss_start = .;
-		*(.bss)
-		__bss_end = .;
-	}
-
-	. = ALIGN(16);
-	_end = .;
-
-	/DISCARD/ : { *(.note*) }
-
-	/* Adjust this as appropriate */
-	/* This allows 4 pages (16K) */
-	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
-}
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
new file mode 100644
index 0000000..22fab6c
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -0,0 +1,61 @@
+/*
+ * wakeup.ld
+ *
+ * Linker script for the real-mode wakeup code
+ */
+#undef i386
+#include "wakeup.h"
+
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+ENTRY(_start)
+
+SECTIONS
+{
+	. = HEADER_OFFSET;
+	.header : {
+		 *(.header)
+	}
+
+	. = 0;
+	.text : {
+		 *(.text*)
+	}
+
+	. = ALIGN(16);
+	.rodata : {
+		*(.rodata*)
+	}
+
+	.videocards : {
+		video_cards = .;
+		*(.videocards)
+		video_cards_end = .;
+	}
+
+	. = ALIGN(16);
+	.data : {
+		 *(.data*)
+	}
+
+	.signature : {
+		end_signature = .;
+		LONG(0x65a22c82)
+	}
+
+	. = ALIGN(16);
+	.bss :	{
+		__bss_start = .;
+		*(.bss)
+		__bss_end = .;
+	}
+
+	. = ALIGN(16);
+	_end = .;
+
+	/DISCARD/ : {
+		*(.note*)
+	}
+
+	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
+}
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1b282b1..561565e 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -53,9 +53,9 @@ int acpi_save_state_mem(void)
 		       "S3 disabled\n");
 		return -ENOMEM;
 	}
-	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
+	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
 
-	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
+	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
 	if (header->signature != 0x51ee1111) {
 		printk(KERN_ERR "wakeup header does not match\n");
 		return -EINVAL;
@@ -111,13 +111,13 @@ void acpi_restore_state_mem(void)
  */
 void __init acpi_reserve_bootmem(void)
 {
-	if ((&wakeup_code_end - &wakeup_code_start) > PAGE_SIZE*4) {
+	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_realmode = (unsigned long)alloc_bootmem_low(PAGE_SIZE*4);
+	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
 
 	if (!acpi_realmode) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
