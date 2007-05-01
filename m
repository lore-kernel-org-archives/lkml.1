Return-Path: <linux-kernel-owner+w=401wt.eu-S1946338AbXEADjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946338AbXEADjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946311AbXEADjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:39:08 -0400
Received: from ozlabs.org ([203.10.76.45]:35691 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946339AbXEADjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:39:04 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, Vivek Goyal <vgoyal@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	 <1177902195.30071.203.camel@localhost.localdomain>
	 <463572B7.90202@zytor.com>
	 <1177909434.30071.216.camel@localhost.localdomain>
	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 13:38:42 +1000
Message-Id: <1177990722.28659.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 09:34 -0600, Eric W. Biederman wrote:
> Reading this it occurs to me what I object to wasn't that clear.
> 
> I have no problem with the testing of %cs to see if we are not in ring0.
> That part while a little odd is fine, and we will certainly need a test
> to skip the protected instructions in head.S
> 
> What I object to in particular is having (struct lguest_info?) instead
> of using the standard format for kernel parameters pointed to in %esi.

Here's a rough patch to see what it looks like from an lguest POV.  It's
an improvement in many ways: I chose to hardcode the search for matching
backend rather than use paravirt_probe-style magic.

It'd be nicer if there were a "struct boot_params" declaration, but we
can't have everything.

Cheers,
Rusty.

diff -r 9a673a220ad6 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Mon Apr 30 20:10:26 2007 +1000
+++ b/Documentation/lguest/lguest.c	Tue May 01 13:19:02 2007 +1000
@@ -30,10 +30,12 @@
 #include <termios.h>
 #include <getopt.h>
 #include <zlib.h>
+typedef unsigned long long u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 typedef uint8_t u8;
 #include "../../include/linux/lguest_launcher.h"
+#include "../../include/asm-i386/e820.h"
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
@@ -915,10 +917,10 @@ static void usage(void)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mem, pgdir, start, page_offset;
+	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
 	int c, lguest_fd, waker_fd;
 	struct device_list device_list;
-	struct lguest_boot_info *boot = (void *)0;
+	void *boot = (void *)0;
 	const char *initrd_name = NULL;
 
 	device_list.max_infd = -1;
@@ -966,15 +968,24 @@ int main(int argc, char *argv[])
 	map_device_descriptors(&device_list, mem);
 
 	/* Map the initrd image if requested */
-	if (initrd_name)
-		boot->initrd_size = load_initrd(initrd_name, mem);
+	if (initrd_name) {
+		initrd_size = load_initrd(initrd_name, mem);
+		*(unsigned long *)(boot+0x218) = mem - initrd_size;
+		*(unsigned long *)(boot+0x21c) = initrd_size;
+	}
 
 	/* Set up the initial linar pagetables. */
-	pgdir = setup_pagetables(mem, boot->initrd_size, page_offset);
-
-	/* Give the guest the boot information it needs. */
-	concat(boot->cmdline, argv+optind+2);
-	boot->max_pfn = mem/getpagesize();
+	pgdir = setup_pagetables(mem, initrd_size, page_offset);
+
+	/* E820 memory map: ours is a simple, single region. */
+	*(char*)(boot+E820NR) = 1;
+	*((struct e820entry *)(boot+E820MAP)) 
+		= ((struct e820entry) { 0, mem, E820_RAM });
+	/* Command line pointer and command line (at 4096) */
+	*(void **)(boot + 0x228) = boot + 4096;
+	concat(boot + 4096, argv+optind+2);
+	/* Paravirt type: 1 == lguest */
+	*(int *)(boot + 0x23c) = 1;
 
 	lguest_fd = tell_kernel(pgdir, start, page_offset);
 	waker_fd = setup_waker(&device_list);
diff -r 9a673a220ad6 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Mon Apr 30 20:10:26 2007 +1000
+++ b/arch/i386/kernel/head.S	Tue May 01 12:29:55 2007 +1000
@@ -504,34 +504,17 @@ ignore_int:
 #ifdef CONFIG_PARAVIRT
 startup_paravirt:
 	cld
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
  	movl $(init_thread_union+THREAD_SIZE),%esp
 
-	/* We take pains to preserve all the regs. */
-	pushl	%edx
-	pushl	%ecx
-	pushl	%eax
-
-	pushl	$__start_paravirtprobe
-1:
-	movl	0(%esp), %eax
-	cmpl	$__stop_paravirtprobe, %eax
-	je	unhandled_paravirt
-	pushl	(%eax)
-	movl	8(%esp), %eax
-	call	*(%esp)
-	popl	%eax
-
-	movl	4(%esp), %eax
-	movl	8(%esp), %ecx
-	movl	12(%esp), %edx
-
-	addl	$4, (%esp)
-	jmp	1b
-
-unhandled_paravirt:
+#ifdef CONFIG_LGUEST_GUEST
+	cmpl	$1, 0x23c(%eax)
+	je	lguest_init
+#endif
 	/* Nothing wanted us: we're screwed. */
 	ud2
-#endif
+#endif /* CONFIG_PARAVIRT */
 
 /*
  * Real beginning of normal "text" segment
diff -r 9a673a220ad6 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Mon Apr 30 20:10:26 2007 +1000
+++ b/drivers/lguest/lguest.c	Tue May 01 13:28:06 2007 +1000
@@ -53,7 +53,6 @@ struct lguest_data lguest_data = {
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 };
 struct lguest_device_desc *lguest_devices;
-static __initdata const struct lguest_boot_info *boot = __va(0);
 
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
@@ -378,8 +377,7 @@ static __init char *lguest_memory_setup(
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
 
-	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
 	return "LGUEST";
 }
 
@@ -410,8 +408,14 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-__init void lguest_init(void)
-{
+__init void lguest_init(void *boot)
+{
+	/* Copy boot parameters first. */
+	memcpy(boot_params, boot, PARAM_SIZE);
+	memcpy(boot_command_line,
+	       __va(*(unsigned long *)(boot_params + NEW_CL_POINTER)),
+	       COMMAND_LINE_SIZE);
+
 	paravirt_ops.name = "lguest";
 	paravirt_ops.paravirt_enabled = 1;
 	paravirt_ops.kernel_rpl = 1;
@@ -460,7 +464,6 @@ __init void lguest_init(void)
 	paravirt_ops.wbinvd = lguest_wbinvd;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
-	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
 
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
@@ -487,14 +490,6 @@ __init void lguest_init(void)
 
 	add_preferred_console("hvc", 0, NULL);
 
-	if (boot->initrd_size) {
-		/* We stash this at top of memory. */
-		INITRD_START = boot->max_pfn*PAGE_SIZE - boot->initrd_size;
-		INITRD_SIZE = boot->initrd_size;
-		LOADER_TYPE = 0xFF;
-	}
-
 	pm_power_off = lguest_power_off;
 	start_kernel();
 }
-paravirt_probe(lguest_maybe_init);
diff -r 9a673a220ad6 drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Mon Apr 30 20:10:26 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Tue May 01 12:37:25 2007 +1000
@@ -5,31 +5,12 @@
 /* FIXME: Once asm/processor-flags.h goes in, include that */
 #define X86_EFLAGS_IF 0x00000200
 
-/*
- * This is where we begin: head.S notes that paging is already enabled (which
- * doesn't happen in native boot) and calls the registered paravirt_probe
- * functions one at a time.  Ours is a simple assembler test for magic
- * registers.  If they're correct we jump to lguest_init.
- *
- * We put it in .init.text will be discarded after boot.
- */
-.section .init.text, "ax", @progbits
-ENTRY(lguest_maybe_init)
-	cmpl $LGUEST_MAGIC_EBP, %ebp
-	jne out
-	cmpl $LGUEST_MAGIC_EDI, %edi
-	jne out
-	cmpl $LGUEST_MAGIC_ESI, %esi
-	jne out
-	je lguest_init
-out:
-	ret
-
 /* The templates for inline patching. */
 #define LGUEST_PATCH(name, insns...)			\
 	lgstart_##name:	insns; lgend_##name:;		\
 	.globl lgstart_##name; .globl lgend_##name
 
+.section .init.text, "ax", @progbits
 LGUEST_PATCH(cli, movl $0, lguest_data+LGUEST_DATA_irq_enabled)
 LGUEST_PATCH(sti, movl $X86_EFLAGS_IF, lguest_data+LGUEST_DATA_irq_enabled)
 LGUEST_PATCH(popf, movl %eax, lguest_data+LGUEST_DATA_irq_enabled)
diff -r 9a673a220ad6 drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c	Mon Apr 30 20:10:26 2007 +1000
+++ b/drivers/lguest/lguest_user.c	Tue May 01 12:11:50 2007 +1000
@@ -7,13 +7,11 @@ static void setup_regs(struct lguest_reg
 static void setup_regs(struct lguest_regs *regs, unsigned long start)
 {
 	/* Write out stack in format lguest expects, so we can switch to it. */
-	regs->edi = LGUEST_MAGIC_EDI;
-	regs->ebp = LGUEST_MAGIC_EBP;
-	regs->esi = LGUEST_MAGIC_ESI;
 	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
 	regs->cs = __KERNEL_CS|GUEST_PL;
 	regs->eflags = 0x202; 	/* Interrupts enabled. */
 	regs->eip = start;
+	/* esi points to our boot information (physical address 0) */
 }
 
 /* + addr */
diff -r 9a673a220ad6 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Mon Apr 30 20:10:26 2007 +1000
+++ b/include/asm-i386/paravirt.h	Tue May 01 11:35:17 2007 +1000
@@ -221,11 +221,6 @@ struct paravirt_ops
 	void (*irq_enable_sysexit)(void);
 	void (*iret)(void);
 };
-
-/* Mark a paravirt probe function. */
-#define paravirt_probe(fn)						\
- static asmlinkage void (*__paravirtprobe_##fn)(void) __attribute_used__ \
-		__attribute__((__section__(".paravirtprobe"))) = fn
 
 extern struct paravirt_ops paravirt_ops;
 
diff -r 9a673a220ad6 include/linux/lguest.h
--- a/include/linux/lguest.h	Mon Apr 30 20:10:26 2007 +1000
+++ b/include/linux/lguest.h	Tue May 01 12:11:07 2007 +1000
@@ -2,11 +2,6 @@
  * this is subject to wild and random change between versions. */
 #ifndef _ASM_LGUEST_H
 #define _ASM_LGUEST_H
-
-/* These are randomly chosen numbers which indicate we're an lguest at boot */
-#define LGUEST_MAGIC_EBP 0x4C687970
-#define LGUEST_MAGIC_EDI 0x652D4D65
-#define LGUEST_MAGIC_ESI 0xFFFFFFFF
 
 #ifndef __ASSEMBLY__
 #include <asm/irq.h>
diff -r 9a673a220ad6 include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h	Mon Apr 30 20:10:26 2007 +1000
+++ b/include/linux/lguest_launcher.h	Tue May 01 11:33:59 2007 +1000
@@ -15,14 +15,6 @@ struct lguest_dma
  	u32 used_len;
 	u32 addr[LGUEST_MAX_DMA_SECTIONS];
 	u16 len[LGUEST_MAX_DMA_SECTIONS];
-};
-
-/* This is found at address 0. */
-struct lguest_boot_info
-{
-	u32 max_pfn;
-	u32 initrd_size;
-	char cmdline[256];
 };
 
 struct lguest_block_page


