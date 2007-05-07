Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXEGBVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXEGBVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEGBVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:21:46 -0400
Received: from ozlabs.org ([203.10.76.45]:45805 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXEGBVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:21:45 -0400
Subject: [PATCH] lguest: use standard bootloader format, fix badly-sized
	initrds
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:21:26 +1000
Message-Id: <1178500887.7731.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Biederman complained that lguest doesn't use the Linux standard
boot header format.  He's got a good point.

This also simplifies the code: the example launcher writes the header
directly, rather than lguest writing into it during boot.

While we're touching this code, we also fix the problem of initrd's
which don't have a page-aligned size.

This anticipates changing the paravirt-finding routines to use a
"platform type" field from %esi, rather than a "probe all until one
succeeds" routine, but doesn't actually change that code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c   |   50 ++++++++++++++++++++++++---------------
 drivers/lguest/lguest.c         |   22 +++++++----------
 drivers/lguest/lguest_asm.S     |    5 +++
 drivers/lguest/lguest_user.c    |    4 ---
 include/linux/lguest.h          |    5 ---
 include/linux/lguest_launcher.h |    8 ------
 6 files changed, 46 insertions(+), 48 deletions(-)

===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
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
@@ -241,31 +243,33 @@ static unsigned long load_kernel(int fd,
 	return load_bzimage(fd, page_offset);
 }
 
+static inline unsigned long page_align(unsigned long addr)
+{
+	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
+}
+
 /* initrd gets loaded at top of memory: return length. */
 static unsigned long load_initrd(const char *name, unsigned long mem)
 {
 	int ifd;
 	struct stat st;
+	unsigned long len;
 	void *iaddr;
 
 	ifd = open_or_die(name, O_RDONLY);
 	if (fstat(ifd, &st) < 0)
 		err(1, "fstat() on initrd '%s'", name);
 
-	iaddr = mmap((void *)mem - st.st_size, st.st_size,
+	len = page_align(st.st_size);
+	iaddr = mmap((void *)mem - len, st.st_size,
 		     PROT_READ|PROT_EXEC|PROT_WRITE,
 		     MAP_FIXED|MAP_PRIVATE, ifd, 0);
-	if (iaddr != (void *)mem - st.st_size)
+	if (iaddr != (void *)mem - len)
 		err(1, "Mmaping initrd '%s' returned %p not %p",
-		    name, iaddr, (void *)mem - st.st_size);
+		    name, iaddr, (void *)mem - len);
 	close(ifd);
 	verbose("mapped initrd %s size=%lu @ %p\n", name, st.st_size, iaddr);
-	return st.st_size;
-}
-
-static inline unsigned long page_align(unsigned long addr)
-{
-	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
+	return len;
 }
 
 static unsigned long setup_pagetables(unsigned long mem,
@@ -933,10 +937,10 @@ static void usage(void)
 
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
@@ -984,15 +988,25 @@ int main(int argc, char *argv[])
 	map_device_descriptors(&device_list, mem);
 
 	/* Map the initrd image if requested */
-	if (initrd_name)
-		boot->initrd_size = load_initrd(initrd_name, mem);
+	if (initrd_name) {
+		initrd_size = load_initrd(initrd_name, mem);
+		*(unsigned long *)(boot+0x218) = mem - initrd_size;
+		*(unsigned long *)(boot+0x21c) = initrd_size;
+		*(unsigned char *)(boot+0x210) = 0xFF;
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
===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -52,7 +52,6 @@ struct lguest_data lguest_data = {
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 };
 struct lguest_device_desc *lguest_devices;
-static __initdata const struct lguest_boot_info *boot = __va(0);
 
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
@@ -377,8 +376,7 @@ static __init char *lguest_memory_setup(
 	/* We do this here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
 
-	e820.nr_map = 0;
-	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
+	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
 	return "LGUEST";
 }
 
@@ -409,8 +407,14 @@ static unsigned lguest_patch(u8 type, u1
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
@@ -459,7 +463,6 @@ __init void lguest_init(void)
 	paravirt_ops.wbinvd = lguest_wbinvd;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
-	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
 
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
@@ -485,13 +488,6 @@ __init void lguest_init(void)
 
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
===================================================================
--- a/drivers/lguest/lguest_asm.S
+++ b/drivers/lguest/lguest_asm.S
@@ -10,7 +10,8 @@
  * This is where we begin: we have a magic signature which the launcher looks
  * for.  The plan is that the Linux boot protocol will be extended with a
  * "platform type" field which will guide us here from the normal entry point,
- * but for the moment this suffices.
+ * but for the moment this suffices.  We pass the virtual address of the boot
+ * info to lguest_init().
  *
  * We put it in .init.text will be discarded after boot.
  */
@@ -18,6 +19,8 @@
 .ascii "GenuineLguest"
 	/* Set up initial stack. */
  	movl $(init_thread_union+THREAD_SIZE),%esp
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
 	jmp lguest_init
 
 /* The templates for inline patching. */
===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
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
===================================================================
--- a/include/linux/lguest.h
+++ b/include/linux/lguest.h
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
===================================================================
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
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


