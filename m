Return-Path: <linux-kernel-owner+w=401wt.eu-S1163341AbXD1SBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163341AbXD1SBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163344AbXD1SBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:38982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163349AbXD1R7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:03 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [13/22] x86_64: 64bit ACPI wakeup trampoline
Message-Id: <20070428175900.622F8151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o Moved wakeup_level4_pgt into the wakeup routine so we can
  run the kernel above 4G.

o Now we first go to 64bit mode and continue to run from trampoline and
  then then start accessing kernel symbols and restore processor context.
  This enables us to resume even in relocatable kernel context when 
  kernel might not be loaded at physical addr it has been compiled for.

o Removed the need for modifying any existing kernel page table.

o Increased the size of the wakeup routine to 8K. This is required as
  wake page tables are on trampoline itself and they got to be at 4K
  boundary, hence one page is not sufficient.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/acpi/sleep.c  |   24 ++-------------
 arch/x86_64/kernel/acpi/wakeup.S |   59 ++++++++++++++++++++++++---------------
 arch/x86_64/kernel/head.S        |    9 -----
 3 files changed, 41 insertions(+), 51 deletions(-)

Index: linux/arch/x86_64/kernel/acpi/sleep.c
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/sleep.c
+++ linux/arch/x86_64/kernel/acpi/sleep.c
@@ -60,19 +60,6 @@ extern char wakeup_start, wakeup_end;
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 
-static pgd_t low_ptr;
-
-static void init_low_mapping(void)
-{
-	pgd_t *slot0 = pgd_offset(current->mm, 0UL);
-	low_ptr = *slot0;
-	/* FIXME: We're playing with the current task's page tables here, which
-	 * is potentially dangerous on SMP systems.
-	 */
-	set_pgd(slot0, *pgd_offset(current->mm, PAGE_OFFSET));
-	local_flush_tlb();
-}
-
 /**
  * acpi_save_state_mem - save kernel state
  *
@@ -81,8 +68,6 @@ static void init_low_mapping(void)
  */
 int acpi_save_state_mem(void)
 {
-	init_low_mapping();
-
 	memcpy((void *)acpi_wakeup_address, &wakeup_start,
 	       &wakeup_end - &wakeup_start);
 	acpi_copy_wakeup_routine(acpi_wakeup_address);
@@ -95,8 +80,6 @@ int acpi_save_state_mem(void)
  */
 void acpi_restore_state_mem(void)
 {
-	set_pgd(pgd_offset(current->mm, 0UL), low_ptr);
-	local_flush_tlb();
 }
 
 /**
@@ -109,10 +92,11 @@ void acpi_restore_state_mem(void)
  */
 void __init acpi_reserve_bootmem(void)
 {
-	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE);
-	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE)
+	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
+	if ((&wakeup_end - &wakeup_start) > (PAGE_SIZE*2))
 		printk(KERN_CRIT
-		       "ACPI: Wakeup code way too big, will crash on attempt to suspend\n");
+		       "ACPI: Wakeup code way too big, will crash on attempt"
+		       " to suspend\n");
 }
 
 static int __init acpi_sleep_setup(char *str)
Index: linux/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux/arch/x86_64/kernel/acpi/wakeup.S
@@ -1,6 +1,7 @@
 .text
 #include <linux/linkage.h>
 #include <asm/segment.h>
+#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
 
@@ -62,12 +63,15 @@ wakeup_code:
 
 	movb	$0xa2, %al	;  outb %al, $0x80
 	
-	lidt	%ds:idt_48a - wakeup_code
-	xorl	%eax, %eax
-	movw	%ds, %ax			# (Convert %ds:gdt to a linear ptr)
-	shll	$4, %eax
-	addl	$(gdta - wakeup_code), %eax
-	movl	%eax, gdt_48a +2 - wakeup_code
+	mov	%ds, %ax			# Find 32bit wakeup_code addr
+	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
+	shll    $4, %esi
+						# Fix up the vectors
+	addl    %esi, wakeup_32_vector - wakeup_code
+	addl    %esi, wakeup_long64_vector - wakeup_code
+	addl    %esi, gdt_48a + 2 - wakeup_code # Fixup the gdt pointer
+
+	lidtl	%ds:idt_48a - wakeup_code
 	lgdtl	%ds:gdt_48a - wakeup_code	# load gdt with whatever is
 						# appropriate
 
@@ -80,7 +84,7 @@ wakeup_code:
 
 	.balign 4
 wakeup_32_vector:
-	.long   wakeup_32 - __START_KERNEL_map
+	.long   wakeup_32 - wakeup_code
 	.word   __KERNEL32_CS, 0
 
 	.code32
@@ -103,10 +107,6 @@ wakeup_32:
 	movl	$__KERNEL_DS, %eax
 	movl	%eax, %ds
 
-	movl	saved_magic - __START_KERNEL_map, %eax
-	cmpl	$0x9abcdef0, %eax
-	jne	bogus_32_magic
-
 	movw	$0x0e00 + 'i', %ds:(0xb8012)
 	movb	$0xa8, %al	;  outb %al, $0x80;
 
@@ -120,7 +120,7 @@ wakeup_32:
 	movl	%eax, %cr4
 
 	/* Setup early boot stage 4 level pagetables */
-	movl	$(wakeup_level4_pgt - __START_KERNEL_map), %eax
+	leal    (wakeup_level4_pgt - wakeup_code)(%esi), %eax
 	movl	%eax, %cr3
 
 	/* Enable Long Mode */
@@ -159,11 +159,11 @@ wakeup_32:
 	 */
 
 	/* Finally jump in 64bit mode */
-	ljmp	*(wakeup_long64_vector - __START_KERNEL_map)
+        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
 
 	.balign 4
 wakeup_long64_vector:
-	.long   wakeup_long64 - __START_KERNEL_map
+	.long   wakeup_long64 - wakeup_code
 	.word   __KERNEL_CS, 0
 
 .code64
@@ -178,11 +178,16 @@ wakeup_long64:
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	cpu_gdt_descr - __START_KERNEL_map
+	lgdt	cpu_gdt_descr
 
 	movw	$0x0e00 + 'n', %ds:(0xb8014)
 	movb	$0xa9, %al	;  outb %al, $0x80
 
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
+
 	movw	$0x0e00 + 'u', %ds:(0xb8016)
 	
 	nop
@@ -223,20 +228,21 @@ idt_48a:
 gdt_48a:
 	.word	0x800				# gdt limit=2048,
 						#  256 GDT entries
-	.word	0, 0				# gdt base (filled in later)
-	
+	.long   gdta - wakeup_code              # gdt base (relocated in later)
 	
 real_magic:	.quad 0
 video_mode:	.quad 0
 video_flags:	.quad 0
 
+.code16
 bogus_real_magic:
 	movb	$0xba,%al	;  outb %al,$0x80
 	jmp bogus_real_magic
 
-bogus_32_magic:
+.code64
+bogus_64_magic:
 	movb	$0xb3,%al	;  outb %al,$0x80
-	jmp bogus_32_magic
+	jmp bogus_64_magic
 
 bogus_cpu:
 	movb	$0xbc,%al	;  outb %al,$0x80
@@ -263,6 +269,7 @@ bogus_cpu:
 #define VIDEO_FIRST_V7 0x0900
 
 # Setting of user mode (AX=mode ID) => CF=success
+.code16
 mode_seta:
 	movw	%ax, %bx
 #if 0
@@ -313,6 +320,13 @@ wakeup_stack_begin:	# Stack grows down
 .org	0xff0
 wakeup_stack:		# Just below end of page
 
+.org   0x1000
+ENTRY(wakeup_level4_pgt)
+	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill   510,8,0
+	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
+	.quad   level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
+
 ENTRY(wakeup_end)
 	
 ##
@@ -338,9 +352,10 @@ ENTRY(acpi_copy_wakeup_routine)
 	movq	$0x123456789abcdef0, %rdx
 	movq	%rdx, saved_magic
 
-	movl	saved_magic - __START_KERNEL_map, %eax
-	cmpl	$0x9abcdef0, %eax
-	jne	bogus_32_magic
+	movq    saved_magic, %rax
+	movq    $0x123456789abcdef0, %rdx
+	cmpq    %rdx, %rax
+	jne     bogus_64_magic
 
 	# restore the regs we used
 	popq	%rdx
Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -308,15 +308,6 @@ NEXT_PAGE(level2_kernel_pgt)
 
 	.data
 
-#ifdef CONFIG_ACPI_SLEEP
-	.align PAGE_SIZE
-ENTRY(wakeup_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	510,8,0
-	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-#endif
-
 #ifndef CONFIG_HOTPLUG_CPU
 	__INITDATA
 #endif
