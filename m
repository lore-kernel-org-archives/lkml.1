Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYAVUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYAVUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYAVUOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:14:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47523 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096AbYAVUOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:14:08 -0500
Date: Tue, 22 Jan 2008 20:37:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com
Subject: factor out common s2ram wakeup code
Message-ID: <20080122193719.GA3791@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems to compile 32/64bit, and work 32bit... Now, video code should
be probably shared with kernel/boot; but that was rewritten to C and
I'm not sure if I know enough about linkers... basically the C code
should replace mode_set() and friends. Peter, can you help?

								Pavel
--- 

Factor out common real-mode part of wakeup_{32,64}.S.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 2fac1886274433c64e76611e6b1ba2318c5914a4
tree 2d6bdc7c2eda9845b57e1d7128b187df1b1fd2c9
parent 7a9546efcc4d90040a52c003eb9a303200c41f86
author Pavel <pavel@amd.ucw.cz> Tue, 22 Jan 2008 20:34:03 +0100
committer Pavel <pavel@amd.ucw.cz> Tue, 22 Jan 2008 20:34:03 +0100

 arch/x86/kernel/acpi/wakeup.S    |  111 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/acpi/wakeup_32.S |  118 +-----------------------------------
 arch/x86/kernel/acpi/wakeup_64.S |  125 +-------------------------------------
 3 files changed, 116 insertions(+), 238 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup.S b/arch/x86/kernel/acpi/wakeup.S
new file mode 100644
index 0000000..38205c8
--- /dev/null
+++ b/arch/x86/kernel/acpi/wakeup.S
@@ -0,0 +1,111 @@
+# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
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
+ALIGN
+	.align	4096
+ENTRY(wakeup_start)
+wakeup_code:
+	wakeup_code_start = .
+	.code16
+
+	cli
+	cld
+
+	# setup data segment
+	movw	%cs, %ax
+	movw	%ax, %ds					# Make ds:0 point to wakeup_start
+	movw	%ax, %ss
+
+	testl   $4, realmode_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
+
+	pushl	$0						# Kill any dangerous flags
+	popfl
+
+
+	movl	real_magic - wakeup_code, %eax
+	cmpl	$0x12345678, %eax
+	jne	bogus_real_magic
+
+	testl	$1, realmode_flags - wakeup_code
+	jz	1f
+	lcall   $0xc000,$3
+	movw	%cs, %ax
+	movw	%ax, %ds					# Bios might have played with that
+	movw	%ax, %ss
+1:
+
+	testl	$2, realmode_flags - wakeup_code
+	jz	mode_done
+	mov	video_mode - wakeup_code, %ax
+	call	mode_set
+	jmp	mode_done
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
+bogus_real_magic:
+	jmp bogus_real_magic
+
+real_magic:	.quad 0
+video_mode:	.quad 0
+realmode_flags:	.quad 0
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 1e931aa..9b26909 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -3,73 +3,11 @@ #include <linux/linkage.h>
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
-
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
+# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 
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
+#include "wakeup.S"
 
+mode_done:
 	# set up page table
 	movl	$swsusp_pg_dir-__PAGE_OFFSET, %eax
 	movl	%eax, %cr3
@@ -109,60 +47,10 @@ real_save_gdt:	.word 0
 real_save_cr0:	.long 0
 real_save_cr3:	.long 0
 real_save_cr4:	.long 0
-real_magic:	.long 0
-video_mode:	.long 0
-realmode_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
 
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
-
 	.code32
 	ALIGN
 
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 5ed3bc5..b02d97f 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -7,78 +7,10 @@ #include <asm/msr.h>
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
-
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
+#include "wakeup.S"
 
+mode_done:
 	mov	%ds, %ax			# Find 32bit wakeup_code addr
 	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
 	shll    $4, %esi
@@ -227,64 +159,11 @@ gdt_48a:
 	.word	0x800				# gdt limit=2048,
 						#  256 GDT entries
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
-	
-real_magic:	.quad 0
-video_mode:	.quad 0
-realmode_flags:	.quad 0
-
-.code16
-bogus_real_magic:
-	jmp bogus_real_magic
 
 .code64
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
 wakeup_stack_begin:	# Stack grows down
 
 .org	0xff0

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
