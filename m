Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbXHIEmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbXHIEmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXHIEm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:29 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:45220 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXHIEmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:17 -0400
Message-Id: <20070809044125.610944971@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 5/5 -v2] Move the lguest files that are i386 specific
Content-Disposition: inline; filename=0005-Move-the-lguest-files-that-are-i386-specific.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, some may be merged with x86_64 later, but for now we move them
out of the way.  Later on we can start seeing how we can combine
some of these files to be arch generic.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/lguest/Makefile                    |    7 +-
 drivers/lguest/core.c                      |  771 -------------------
 drivers/lguest/hypercalls.c                |  300 --------
 drivers/lguest/i386/Makefile               |    7 +
 drivers/lguest/i386/core.c                 |  771 +++++++++++++++++++
 drivers/lguest/i386/hypercalls.c           |  300 ++++++++
 drivers/lguest/i386/interrupts_and_traps.c |  440 +++++++++++
 drivers/lguest/i386/lguest.c               | 1097 ++++++++++++++++++++++++++++
 drivers/lguest/i386/lguest_asm.S           |   93 +++
 drivers/lguest/i386/lguest_user.c          |  382 ++++++++++
 drivers/lguest/i386/page_tables.c          |  680 +++++++++++++++++
 drivers/lguest/i386/segments.c             |  229 ++++++
 drivers/lguest/i386/switcher.S             |  347 +++++++++
 drivers/lguest/interrupts_and_traps.c      |  440 -----------
 drivers/lguest/lguest.c                    | 1097 ----------------------------
 drivers/lguest/lguest_asm.S                |   93 ---
 drivers/lguest/lguest_user.c               |  382 ----------
 drivers/lguest/page_tables.c               |  680 -----------------
 drivers/lguest/segments.c                  |  229 ------
 drivers/lguest/switcher.S                  |  347 ---------
 20 files changed, 4348 insertions(+), 4344 deletions(-)

diff --git a/drivers/lguest/Makefile b/drivers/lguest/Makefile
index e504747..2de13eb 100644
--- a/drivers/lguest/Makefile
+++ b/drivers/lguest/Makefile
@@ -1,10 +1,7 @@
 # Guest requires the paravirt_ops replacement and the bus driver.
-obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
+obj-$(CONFIG_LGUEST_GUEST) += lguest_bus.o
 
-# Host requires the other files, which can be a module.
-obj-$(CONFIG_LGUEST)	+= lg.o
-lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
-	segments.o io.o lguest_user.o switcher.o
+obj-$(CONFIG_X86_32)	+= i386/
 
 Preparation Preparation!: PREFIX=P
 Guest: PREFIX=G
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
deleted file mode 100644
index 5bcd237..0000000
--- a/drivers/lguest/core.c
+++ /dev/null
@@ -1,771 +0,0 @@
-/*P:400 This contains run_guest() which actually calls into the Host<->Guest
- * Switcher and analyzes the return, such as determining if the Guest wants the
- * Host to do something.  This file also contains useful helper routines, and a
- * couple of non-obvious setup and teardown pieces which were implemented after
- * days of debugging pain. :*/
-#include <linux/module.h>
-#include <linux/stringify.h>
-#include <linux/stddef.h>
-#include <linux/io.h>
-#include <linux/mm.h>
-#include <linux/vmalloc.h>
-#include <linux/cpu.h>
-#include <linux/freezer.h>
-#include <asm/paravirt.h>
-#include <asm/desc.h>
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/poll.h>
-#include <asm/highmem.h>
-#include <asm/asm-offsets.h>
-#include <asm/i387.h>
-#include <linux/lg.h>
-
-/* Found in switcher.S */
-extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
-extern unsigned long default_idt_entries[];
-
-/* Every guest maps the core switcher code. */
-#define SHARED_SWITCHER_PAGES \
-	DIV_ROUND_UP(end_switcher_text - start_switcher_text, PAGE_SIZE)
-/* Pages for switcher itself, then two pages per cpu */
-#define TOTAL_SWITCHER_PAGES (SHARED_SWITCHER_PAGES + 2 * NR_CPUS)
-
-/* We map at -4M for ease of mapping into the guest (one PTE page). */
-#define SWITCHER_ADDR 0xFFC00000
-
-static struct vm_struct *switcher_vma;
-static struct page **switcher_page;
-
-static int cpu_had_pge;
-static struct {
-	unsigned long offset;
-	unsigned short segment;
-} lguest_entry;
-
-/* This One Big lock protects all inter-guest data structures. */
-DEFINE_MUTEX(lguest_lock);
-static DEFINE_PER_CPU(struct lguest *, last_guest);
-
-/* FIXME: Make dynamic. */
-#define MAX_LGUEST_GUESTS 16
-struct lguest lguests[MAX_LGUEST_GUESTS];
-
-/* Offset from where switcher.S was compiled to where we've copied it */
-static unsigned long switcher_offset(void)
-{
-	return SWITCHER_ADDR - (unsigned long)start_switcher_text;
-}
-
-/* This cpu's struct lguest_pages. */
-static struct lguest_pages *lguest_pages(unsigned int cpu)
-{
-	return &(((struct lguest_pages *)
-		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
-}
-
-/*H:010 We need to set up the Switcher at a high virtual address.  Remember the
- * Switcher is a few hundred bytes of assembler code which actually changes the
- * CPU to run the Guest, and then changes back to the Host when a trap or
- * interrupt happens.
- *
- * The Switcher code must be at the same virtual address in the Guest as the
- * Host since it will be running as the switchover occurs.
- *
- * Trying to map memory at a particular address is an unusual thing to do, so
- * it's not a simple one-liner.  We also set up the per-cpu parts of the
- * Switcher here.
- */
-static __init int map_switcher(void)
-{
-	int i, err;
-	struct page **pagep;
-
-	/*
-	 * Map the Switcher in to high memory.
-	 *
-	 * It turns out that if we choose the address 0xFFC00000 (4MB under the
-	 * top virtual address), it makes setting up the page tables really
-	 * easy.
-	 */
-
-	/* We allocate an array of "struct page"s.  map_vm_area() wants the
-	 * pages in this form, rather than just an array of pointers. */
-	switcher_page = kmalloc(sizeof(switcher_page[0])*TOTAL_SWITCHER_PAGES,
-				GFP_KERNEL);
-	if (!switcher_page) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	/* Now we actually allocate the pages.  The Guest will see these pages,
-	 * so we make sure they're zeroed. */
-	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
-		unsigned long addr = get_zeroed_page(GFP_KERNEL);
-		if (!addr) {
-			err = -ENOMEM;
-			goto free_some_pages;
-		}
-		switcher_page[i] = virt_to_page(addr);
-	}
-
-	/* Now we reserve the "virtual memory area" we want: 0xFFC00000
-	 * (SWITCHER_ADDR).  We might not get it in theory, but in practice
-	 * it's worked so far. */
-	switcher_vma = __get_vm_area(TOTAL_SWITCHER_PAGES * PAGE_SIZE,
-				       VM_ALLOC, SWITCHER_ADDR, VMALLOC_END);
-	if (!switcher_vma) {
-		err = -ENOMEM;
-		printk("lguest: could not map switcher pages high\n");
-		goto free_pages;
-	}
-
-	/* This code actually sets up the pages we've allocated to appear at
-	 * SWITCHER_ADDR.  map_vm_area() takes the vma we allocated above, the
-	 * kind of pages we're mapping (kernel pages), and a pointer to our
-	 * array of struct pages.  It increments that pointer, but we don't
-	 * care. */
-	pagep = switcher_page;
-	err = map_vm_area(switcher_vma, PAGE_KERNEL, &pagep);
-	if (err) {
-		printk("lguest: map_vm_area failed: %i\n", err);
-		goto free_vma;
-	}
-
-	/* Now the switcher is mapped at the right address, we can't fail!
-	 * Copy in the compiled-in Switcher code (from switcher.S). */
-	memcpy(switcher_vma->addr, start_switcher_text,
-	       end_switcher_text - start_switcher_text);
-
-	/* Most of the switcher.S doesn't care that it's been moved; on Intel,
-	 * jumps are relative, and it doesn't access any references to external
-	 * code or data.
-	 *
-	 * The only exception is the interrupt handlers in switcher.S: their
-	 * addresses are placed in a table (default_idt_entries), so we need to
-	 * update the table with the new addresses.  switcher_offset() is a
-	 * convenience function which returns the distance between the builtin
-	 * switcher code and the high-mapped copy we just made. */
-	for (i = 0; i < IDT_ENTRIES; i++)
-		default_idt_entries[i] += switcher_offset();
-
-	/*
-	 * Set up the Switcher's per-cpu areas.
-	 *
-	 * Each CPU gets two pages of its own within the high-mapped region
-	 * (aka. "struct lguest_pages").  Much of this can be initialized now,
-	 * but some depends on what Guest we are running (which is set up in
-	 * copy_in_guest_info()).
-	 */
-	for_each_possible_cpu(i) {
-		/* lguest_pages() returns this CPU's two pages. */
-		struct lguest_pages *pages = lguest_pages(i);
-		/* This is a convenience pointer to make the code fit one
-		 * statement to a line. */
-		struct lguest_ro_state *state = &pages->state;
-
-		/* The Global Descriptor Table: the Host has a different one
-		 * for each CPU.  We keep a descriptor for the GDT which says
-		 * where it is and how big it is (the size is actually the last
-		 * byte, not the size, hence the "-1"). */
-		state->host_gdt_desc.size = GDT_SIZE-1;
-		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
-
-		/* All CPUs on the Host use the same Interrupt Descriptor
-		 * Table, so we just use store_idt(), which gets this CPU's IDT
-		 * descriptor. */
-		store_idt(&state->host_idt_desc);
-
-		/* The descriptors for the Guest's GDT and IDT can be filled
-		 * out now, too.  We copy the GDT & IDT into ->guest_gdt and
-		 * ->guest_idt before actually running the Guest. */
-		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
-		state->guest_idt_desc.address = (long)&state->guest_idt;
-		state->guest_gdt_desc.size = sizeof(state->guest_gdt)-1;
-		state->guest_gdt_desc.address = (long)&state->guest_gdt;
-
-		/* We know where we want the stack to be when the Guest enters
-		 * the switcher: in pages->regs.  The stack grows upwards, so
-		 * we start it at the end of that structure. */
-		state->guest_tss.esp0 = (long)(&pages->regs + 1);
-		/* And this is the GDT entry to use for the stack: we keep a
-		 * couple of special LGUEST entries. */
-		state->guest_tss.ss0 = LGUEST_DS;
-
-		/* x86 can have a finegrained bitmap which indicates what I/O
-		 * ports the process can use.  We set it to the end of our
-		 * structure, meaning "none". */
-		state->guest_tss.io_bitmap_base = sizeof(state->guest_tss);
-
-		/* Some GDT entries are the same across all Guests, so we can
-		 * set them up now. */
-		setup_default_gdt_entries(state);
-		/* Most IDT entries are the same for all Guests, too.*/
-		setup_default_idt_entries(state, default_idt_entries);
-
-		/* The Host needs to be able to use the LGUEST segments on this
-		 * CPU, too, so put them in the Host GDT. */
-		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
-		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
-	}
-
-	/* In the Switcher, we want the %cs segment register to use the
-	 * LGUEST_CS GDT entry: we've put that in the Host and Guest GDTs, so
-	 * it will be undisturbed when we switch.  To change %cs and jump we
-	 * need this structure to feed to Intel's "lcall" instruction. */
-	lguest_entry.offset = (long)switch_to_guest + switcher_offset();
-	lguest_entry.segment = LGUEST_CS;
-
-	printk(KERN_INFO "lguest: mapped switcher at %p\n",
-	       switcher_vma->addr);
-	/* And we succeeded... */
-	return 0;
-
-free_vma:
-	vunmap(switcher_vma->addr);
-free_pages:
-	i = TOTAL_SWITCHER_PAGES;
-free_some_pages:
-	for (--i; i >= 0; i--)
-		__free_pages(switcher_page[i], 0);
-	kfree(switcher_page);
-out:
-	return err;
-}
-/*:*/
-
-/* Cleaning up the mapping when the module is unloaded is almost...
- * too easy. */
-static void unmap_switcher(void)
-{
-	unsigned int i;
-
-	/* vunmap() undoes *both* map_vm_area() and __get_vm_area(). */
-	vunmap(switcher_vma->addr);
-	/* Now we just need to free the pages we copied the switcher into */
-	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++)
-		__free_pages(switcher_page[i], 0);
-}
-
-/*H:130 Our Guest is usually so well behaved; it never tries to do things it
- * isn't allowed to.  Unfortunately, "struct paravirt_ops" isn't quite
- * complete, because it doesn't contain replacements for the Intel I/O
- * instructions.  As a result, the Guest sometimes fumbles across one during
- * the boot process as it probes for various things which are usually attached
- * to a PC.
- *
- * When the Guest uses one of these instructions, we get trap #13 (General
- * Protection Fault) and come here.  We see if it's one of those troublesome
- * instructions and skip over it.  We return true if we did. */
-static int emulate_insn(struct lguest *lg)
-{
-	u8 insn;
-	unsigned int insnlen = 0, in = 0, shift = 0;
-	/* The eip contains the *virtual* address of the Guest's instruction:
-	 * guest_pa just subtracts the Guest's page_offset. */
-	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
-
-	/* The guest_pa() function only works for Guest kernel addresses, but
-	 * that's all we're trying to do anyway. */
-	if (lg->regs->eip < lg->page_offset)
-		return 0;
-
-	/* Decoding x86 instructions is icky. */
-	lgread(lg, &insn, physaddr, 1);
-
-	/* 0x66 is an "operand prefix".  It means it's using the upper 16 bits
-	   of the eax register. */
-	if (insn == 0x66) {
-		shift = 16;
-		/* The instruction is 1 byte so far, read the next byte. */
-		insnlen = 1;
-		lgread(lg, &insn, physaddr + insnlen, 1);
-	}
-
-	/* We can ignore the lower bit for the moment and decode the 4 opcodes
-	 * we need to emulate. */
-	switch (insn & 0xFE) {
-	case 0xE4: /* in     <next byte>,%al */
-		insnlen += 2;
-		in = 1;
-		break;
-	case 0xEC: /* in     (%dx),%al */
-		insnlen += 1;
-		in = 1;
-		break;
-	case 0xE6: /* out    %al,<next byte> */
-		insnlen += 2;
-		break;
-	case 0xEE: /* out    %al,(%dx) */
-		insnlen += 1;
-		break;
-	default:
-		/* OK, we don't know what this is, can't emulate. */
-		return 0;
-	}
-
-	/* If it was an "IN" instruction, they expect the result to be read
-	 * into %eax, so we change %eax.  We always return all-ones, which
-	 * traditionally means "there's nothing there". */
-	if (in) {
-		/* Lower bit tells is whether it's a 16 or 32 bit access */
-		if (insn & 0x1)
-			lg->regs->eax = 0xFFFFFFFF;
-		else
-			lg->regs->eax |= (0xFFFF << shift);
-	}
-	/* Finally, we've "done" the instruction, so move past it. */
-	lg->regs->eip += insnlen;
-	/* Success! */
-	return 1;
-}
-/*:*/
-
-/*L:305
- * Dealing With Guest Memory.
- *
- * When the Guest gives us (what it thinks is) a physical address, we can use
- * the normal copy_from_user() & copy_to_user() on that address: remember,
- * Guest physical == Launcher virtual.
- *
- * But we can't trust the Guest: it might be trying to access the Launcher
- * code.  We have to check that the range is below the pfn_limit the Launcher
- * gave us.  We have to make sure that addr + len doesn't give us a false
- * positive by overflowing, too. */
-int lguest_address_ok(const struct lguest *lg,
-		      unsigned long addr, unsigned long len)
-{
-	return (addr+len) / PAGE_SIZE < lg->pfn_limit && (addr+len >= addr);
-}
-
-/* This is a convenient routine to get a 32-bit value from the Guest (a very
- * common operation).  Here we can see how useful the kill_lguest() routine we
- * met in the Launcher can be: we return a random value (0) instead of needing
- * to return an error. */
-u32 lgread_u32(struct lguest *lg, unsigned long addr)
-{
-	u32 val = 0;
-
-	/* Don't let them access lguest binary. */
-	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || get_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %#lx", addr);
-	return val;
-}
-
-/* Same thing for writing a value. */
-void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
-{
-	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || put_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad write address %#lx", addr);
-}
-
-/* This routine is more generic, and copies a range of Guest bytes into a
- * buffer.  If the copy_from_user() fails, we fill the buffer with zeroes, so
- * the caller doesn't end up using uninitialized kernel memory. */
-void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
-{
-	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
-		/* copy_from_user should do this, but as we rely on it... */
-		memset(b, 0, bytes);
-		kill_guest(lg, "bad read address %#lx len %u", addr, bytes);
-	}
-}
-
-/* Similarly, our generic routine to copy into a range of Guest bytes. */
-void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
-	     unsigned bytes)
-{
-	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_to_user((void __user *)addr, b, bytes) != 0)
-		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
-}
-/* (end of memory access helper routines) :*/
-
-static void set_ts(void)
-{
-	u32 cr0;
-
-	cr0 = read_cr0();
-	if (!(cr0 & 8))
-		write_cr0(cr0|8);
-}
-
-/*S:010
- * We are getting close to the Switcher.
- *
- * Remember that each CPU has two pages which are visible to the Guest when it
- * runs on that CPU.  This has to contain the state for that Guest: we copy the
- * state in just before we run the Guest.
- *
- * Each Guest has "changed" flags which indicate what has changed in the Guest
- * since it last ran.  We saw this set in interrupts_and_traps.c and
- * segments.c.
- */
-static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
-{
-	/* Copying all this data can be quite expensive.  We usually run the
-	 * same Guest we ran last time (and that Guest hasn't run anywhere else
-	 * meanwhile).  If that's not the case, we pretend everything in the
-	 * Guest has changed. */
-	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
-		__get_cpu_var(last_guest) = lg;
-		lg->last_pages = pages;
-		lg->changed = CHANGED_ALL;
-	}
-
-	/* These copies are pretty cheap, so we do them unconditionally: */
-	/* Save the current Host top-level page directory. */
-	pages->state.host_cr3 = __pa(current->mm->pgd);
-	/* Set up the Guest's page tables to see this CPU's pages (and no
-	 * other CPU's pages). */
-	map_switcher_in_guest(lg, pages);
-	/* Set up the two "TSS" members which tell the CPU what stack to use
-	 * for traps which do directly into the Guest (ie. traps at privilege
-	 * level 1). */
-	pages->state.guest_tss.esp1 = lg->esp1;
-	pages->state.guest_tss.ss1 = lg->ss1;
-
-	/* Copy direct-to-Guest trap entries. */
-	if (lg->changed & CHANGED_IDT)
-		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
-
-	/* Copy all GDT entries which the Guest can change. */
-	if (lg->changed & CHANGED_GDT)
-		copy_gdt(lg, pages->state.guest_gdt);
-	/* If only the TLS entries have changed, copy them. */
-	else if (lg->changed & CHANGED_GDT_TLS)
-		copy_gdt_tls(lg, pages->state.guest_gdt);
-
-	/* Mark the Guest as unchanged for next time. */
-	lg->changed = 0;
-}
-
-/* Finally: the code to actually call into the Switcher to run the Guest. */
-static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
-{
-	/* This is a dummy value we need for GCC's sake. */
-	unsigned int clobber;
-
-	/* Copy the guest-specific information into this CPU's "struct
-	 * lguest_pages". */
-	copy_in_guest_info(lg, pages);
-
-	/* Now: we push the "eflags" register on the stack, then do an "lcall".
-	 * This is how we change from using the kernel code segment to using
-	 * the dedicated lguest code segment, as well as jumping into the
-	 * Switcher.
-	 *
-	 * The lcall also pushes the old code segment (KERNEL_CS) onto the
-	 * stack, then the address of this call.  This stack layout happens to
-	 * exactly match the stack of an interrupt... */
-	asm volatile("pushf; lcall *lguest_entry"
-		     /* This is how we tell GCC that %eax ("a") and %ebx ("b")
-		      * are changed by this routine.  The "=" means output. */
-		     : "=a"(clobber), "=b"(clobber)
-		     /* %eax contains the pages pointer.  ("0" refers to the
-		      * 0-th argument above, ie "a").  %ebx contains the
-		      * physical address of the Guest's top-level page
-		      * directory. */
-		     : "0"(pages), "1"(__pa(lg->pgdirs[lg->pgdidx].pgdir))
-		     /* We tell gcc that all these registers could change,
-		      * which means we don't have to save and restore them in
-		      * the Switcher. */
-		     : "memory", "%edx", "%ecx", "%edi", "%esi");
-}
-/*:*/
-
-/*H:030 Let's jump straight to the the main loop which runs the Guest.
- * Remember, this is called by the Launcher reading /dev/lguest, and we keep
- * going around and around until something interesting happens. */
-int run_guest(struct lguest *lg, unsigned long __user *user)
-{
-	/* We stop running once the Guest is dead. */
-	while (!lg->dead) {
-		/* We need to initialize this, otherwise gcc complains.  It's
-		 * not (yet) clever enough to see that it's initialized when we
-		 * need it. */
-		unsigned int cr2 = 0; /* Damn gcc */
-
-		/* First we run any hypercalls the Guest wants done: either in
-		 * the hypercall ring in "struct lguest_data", or directly by
-		 * using int 31 (LGUEST_TRAP_ENTRY). */
-		do_hypercalls(lg);
-		/* It's possible the Guest did a SEND_DMA hypercall to the
-		 * Launcher, in which case we return from the read() now. */
-		if (lg->dma_is_pending) {
-			if (put_user(lg->pending_dma, user) ||
-			    put_user(lg->pending_key, user+1))
-				return -EFAULT;
-			return sizeof(unsigned long)*2;
-		}
-
-		/* Check for signals */
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-
-		/* If Waker set break_out, return to Launcher. */
-		if (lg->break_out)
-			return -EAGAIN;
-
-		/* Check if there are any interrupts which can be delivered
-		 * now: if so, this sets up the hander to be executed when we
-		 * next run the Guest. */
-		maybe_do_interrupt(lg);
-
-		/* All long-lived kernel loops need to check with this horrible
-		 * thing called the freezer.  If the Host is trying to suspend,
-		 * it stops us. */
-		try_to_freeze();
-
-		/* Just make absolutely sure the Guest is still alive.  One of
-		 * those hypercalls could have been fatal, for example. */
-		if (lg->dead)
-			break;
-
-		/* If the Guest asked to be stopped, we sleep.  The Guest's
-		 * clock timer or LHCALL_BREAK from the Waker will wake us. */
-		if (lg->halted) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
-			continue;
-		}
-
-		/* OK, now we're ready to jump into the Guest.  First we put up
-		 * the "Do Not Disturb" sign: */
-		local_irq_disable();
-
-		/* Remember the awfully-named TS bit?  If the Guest has asked
-		 * to set it we set it now, so we can trap and pass that trap
-		 * to the Guest if it uses the FPU. */
-		if (lg->ts)
-			set_ts();
-
-		/* SYSENTER is an optimized way of doing system calls.  We
-		 * can't allow it because it always jumps to privilege level 0.
-		 * A normal Guest won't try it because we don't advertise it in
-		 * CPUID, but a malicious Guest (or malicious Guest userspace
-		 * program) could, so we tell the CPU to disable it before
-		 * running the Guest. */
-		if (boot_cpu_has(X86_FEATURE_SEP))
-			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
-
-		/* Now we actually run the Guest.  It will pop back out when
-		 * something interesting happens, and we can examine its
-		 * registers to see what it was doing. */
-		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
-
-		/* The "regs" pointer contains two extra entries which are not
-		 * really registers: a trap number which says what interrupt or
-		 * trap made the switcher code come back, and an error code
-		 * which some traps set.  */
-
-		/* If the Guest page faulted, then the cr2 register will tell
-		 * us the bad virtual address.  We have to grab this now,
-		 * because once we re-enable interrupts an interrupt could
-		 * fault and thus overwrite cr2, or we could even move off to a
-		 * different CPU. */
-		if (lg->regs->trapnum == 14)
-			cr2 = read_cr2();
-		/* Similarly, if we took a trap because the Guest used the FPU,
-		 * we have to restore the FPU it expects to see. */
-		else if (lg->regs->trapnum == 7)
-			math_state_restore();
-
-		/* Restore SYSENTER if it's supposed to be on. */
-		if (boot_cpu_has(X86_FEATURE_SEP))
-			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
-
-		/* Now we're ready to be interrupted or moved to other CPUs */
-		local_irq_enable();
-
-		/* OK, so what happened? */
-		switch (lg->regs->trapnum) {
-		case 13: /* We've intercepted a GPF. */
-			/* Check if this was one of those annoying IN or OUT
-			 * instructions which we need to emulate.  If so, we
-			 * just go back into the Guest after we've done it. */
-			if (lg->regs->errcode == 0) {
-				if (emulate_insn(lg))
-					continue;
-			}
-			break;
-		case 14: /* We've intercepted a page fault. */
-			/* The Guest accessed a virtual address that wasn't
-			 * mapped.  This happens a lot: we don't actually set
-			 * up most of the page tables for the Guest at all when
-			 * we start: as it runs it asks for more and more, and
-			 * we set them up as required. In this case, we don't
-			 * even tell the Guest that the fault happened.
-			 *
-			 * The errcode tells whether this was a read or a
-			 * write, and whether kernel or userspace code. */
-			if (demand_page(lg, cr2, lg->regs->errcode))
-				continue;
-
-			/* OK, it's really not there (or not OK): the Guest
-			 * needs to know.  We write out the cr2 value so it
-			 * knows where the fault occurred.
-			 *
-			 * Note that if the Guest were really messed up, this
-			 * could happen before it's done the INITIALIZE
-			 * hypercall, so lg->lguest_data will be NULL, so
-			 * &lg->lguest_data->cr2 will be address 8.  Writing
-			 * into that address won't hurt the Host at all,
-			 * though. */
-			if (put_user(cr2, &lg->lguest_data->cr2))
-				kill_guest(lg, "Writing cr2");
-			break;
-		case 7: /* We've intercepted a Device Not Available fault. */
-			/* If the Guest doesn't want to know, we already
-			 * restored the Floating Point Unit, so we just
-			 * continue without telling it. */
-			if (!lg->ts)
-				continue;
-			break;
-		case 32 ... 255:
-			/* These values mean a real interrupt occurred, in
-			 * which case the Host handler has already been run.
-			 * We just do a friendly check if another process
-			 * should now be run, then fall through to loop
-			 * around: */
-			cond_resched();
-		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
-			continue;
-		}
-
-		/* If we get here, it's a trap the Guest wants to know
-		 * about. */
-		if (deliver_trap(lg, lg->regs->trapnum))
-			continue;
-
-		/* If the Guest doesn't have a handler (either it hasn't
-		 * registered any yet, or it's one of the faults we don't let
-		 * it handle), it dies with a cryptic error message. */
-		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
-			   lg->regs->trapnum, lg->regs->eip,
-			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
-	}
-	/* The Guest is dead => "No such file or directory" */
-	return -ENOENT;
-}
-
-/* Now we can look at each of the routines this calls, in increasing order of
- * complexity: do_hypercalls(), emulate_insn(), maybe_do_interrupt(),
- * deliver_trap() and demand_page().  After all those, we'll be ready to
- * examine the Switcher, and our philosophical understanding of the Host/Guest
- * duality will be complete. :*/
-
-int find_free_guest(void)
-{
-	unsigned int i;
-	for (i = 0; i < MAX_LGUEST_GUESTS; i++)
-		if (!lguests[i].tsk)
-			return i;
-	return -1;
-}
-
-static void adjust_pge(void *on)
-{
-	if (on)
-		write_cr4(read_cr4() | X86_CR4_PGE);
-	else
-		write_cr4(read_cr4() & ~X86_CR4_PGE);
-}
-
-/*H:000
- * Welcome to the Host!
- *
- * By this point your brain has been tickled by the Guest code and numbed by
- * the Launcher code; prepare for it to be stretched by the Host code.  This is
- * the heart.  Let's begin at the initialization routine for the Host's lg
- * module.
- */
-static int __init init(void)
-{
-	int err;
-
-	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
-	if (paravirt_enabled()) {
-		printk("lguest is afraid of %s\n", paravirt_ops.name);
-		return -EPERM;
-	}
-
-	/* First we put the Switcher up in very high virtual memory. */
-	err = map_switcher();
-	if (err)
-		return err;
-
-	/* Now we set up the pagetable implementation for the Guests. */
-	err = init_pagetables(switcher_page, SHARED_SWITCHER_PAGES);
-	if (err) {
-		unmap_switcher();
-		return err;
-	}
-
-	/* The I/O subsystem needs some things initialized. */
-	lguest_io_init();
-
-	/* /dev/lguest needs to be registered. */
-	err = lguest_device_init();
-	if (err) {
-		free_pagetables();
-		unmap_switcher();
-		return err;
-	}
-
-	/* Finally, we need to turn off "Page Global Enable".  PGE is an
-	 * optimization where page table entries are specially marked to show
-	 * they never change.  The Host kernel marks all the kernel pages this
-	 * way because it's always present, even when userspace is running.
-	 *
-	 * Lguest breaks this: unbeknownst to the rest of the Host kernel, we
-	 * switch to the Guest kernel.  If you don't disable this on all CPUs,
-	 * you'll get really weird bugs that you'll chase for two days.
-	 *
-	 * I used to turn PGE off every time we switched to the Guest and back
-	 * on when we return, but that slowed the Switcher down noticibly. */
-
-	/* We don't need the complexity of CPUs coming and going while we're
-	 * doing this. */
-	lock_cpu_hotplug();
-	if (cpu_has_pge) { /* We have a broader idea of "global". */
-		/* Remember that this was originally set (for cleanup). */
-		cpu_had_pge = 1;
-		/* adjust_pge is a helper function which sets or unsets the PGE
-		 * bit on its CPU, depending on the argument (0 == unset). */
-		on_each_cpu(adjust_pge, (void *)0, 0, 1);
-		/* Turn off the feature in the global feature set. */
-		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
-	}
-	unlock_cpu_hotplug();
-
-	/* All good! */
-	return 0;
-}
-
-/* Cleaning up is just the same code, backwards.  With a little French. */
-static void __exit fini(void)
-{
-	lguest_device_remove();
-	free_pagetables();
-	unmap_switcher();
-
-	/* If we had PGE before we started, turn it back on now. */
-	lock_cpu_hotplug();
-	if (cpu_had_pge) {
-		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
-		/* adjust_pge's argument "1" means set PGE. */
-		on_each_cpu(adjust_pge, (void *)1, 0, 1);
-	}
-	unlock_cpu_hotplug();
-}
-
-/* The Host side of lguest can be a module.  This is a nice way for people to
- * play with it.  */
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
deleted file mode 100644
index 3c0d41e..0000000
--- a/drivers/lguest/hypercalls.c
+++ /dev/null
@@ -1,300 +0,0 @@
-/*P:500 Just as userspace programs request kernel operations through a system
- * call, the Guest requests Host operations through a "hypercall".  You might
- * notice this nomenclature doesn't really follow any logic, but the name has
- * been around for long enough that we're stuck with it.  As you'd expect, this
- * code is basically a one big switch statement. :*/
-
-/*  Copyright (C) 2006 Rusty Russell IBM Corporation
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
-*/
-#include <linux/uaccess.h>
-#include <linux/syscalls.h>
-#include <linux/mm.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <irq_vectors.h>
-#include <linux/lg.h>
-
-/*H:120 This is the core hypercall routine: where the Guest gets what it
- * wants.  Or gets killed.  Or, in the case of LHCALL_CRASH, both.
- *
- * Remember from the Guest: %eax == which call to make, and the arguments are
- * packed into %edx, %ebx and %ecx if needed. */
-static void do_hcall(struct lguest *lg, struct lguest_regs *regs)
-{
-	switch (regs->eax) {
-	case LHCALL_FLUSH_ASYNC:
-		/* This call does nothing, except by breaking out of the Guest
-		 * it makes us process all the asynchronous hypercalls. */
-		break;
-	case LHCALL_LGUEST_INIT:
-		/* You can't get here unless you're already initialized.  Don't
-		 * do that. */
-		kill_guest(lg, "already have lguest_data");
-		break;
-	case LHCALL_CRASH: {
-		/* Crash is such a trivial hypercall that we do it in four
-		 * lines right here. */
-		char msg[128];
-		/* If the lgread fails, it will call kill_guest() itself; the
-		 * kill_guest() with the message will be ignored. */
-		lgread(lg, msg, regs->edx, sizeof(msg));
-		msg[sizeof(msg)-1] = '\0';
-		kill_guest(lg, "CRASH: %s", msg);
-		break;
-	}
-	case LHCALL_FLUSH_TLB:
-		/* FLUSH_TLB comes in two flavors, depending on the
-		 * argument: */
-		if (regs->edx)
-			guest_pagetable_clear_all(lg);
-		else
-			guest_pagetable_flush_user(lg);
-		break;
-	case LHCALL_BIND_DMA:
-		/* BIND_DMA really wants four arguments, but it's the only call
-		 * which does.  So the Guest packs the number of buffers and
-		 * the interrupt number into the final argument, and we decode
-		 * it here.  This can legitimately fail, since we currently
-		 * place a limit on the number of DMA pools a Guest can have.
-		 * So we return true or false from this call. */
-		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
-				     regs->ecx >> 8, regs->ecx & 0xFF);
-		break;
-
-	/* All these calls simply pass the arguments through to the right
-	 * routines. */
-	case LHCALL_SEND_DMA:
-		send_dma(lg, regs->edx, regs->ebx);
-		break;
-	case LHCALL_LOAD_GDT:
-		load_guest_gdt(lg, regs->edx, regs->ebx);
-		break;
-	case LHCALL_LOAD_IDT_ENTRY:
-		load_guest_idt_entry(lg, regs->edx, regs->ebx, regs->ecx);
-		break;
-	case LHCALL_NEW_PGTABLE:
-		guest_new_pagetable(lg, regs->edx);
-		break;
-	case LHCALL_SET_STACK:
-		guest_set_stack(lg, regs->edx, regs->ebx, regs->ecx);
-		break;
-	case LHCALL_SET_PTE:
-		guest_set_pte(lg, regs->edx, regs->ebx, mkgpte(regs->ecx));
-		break;
-	case LHCALL_SET_PMD:
-		guest_set_pmd(lg, regs->edx, regs->ebx);
-		break;
-	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg, regs->edx);
-		break;
-	case LHCALL_SET_CLOCKEVENT:
-		guest_set_clockevent(lg, regs->edx);
-		break;
-
-	case LHCALL_TS:
-		/* This sets the TS flag, as we saw used in run_guest(). */
-		lg->ts = regs->edx;
-		break;
-	case LHCALL_HALT:
-		/* Similarly, this sets the halted flag for run_guest(). */
-		lg->halted = 1;
-		break;
-	default:
-		kill_guest(lg, "Bad hypercall %li\n", regs->eax);
-	}
-}
-
-/* Asynchronous hypercalls are easy: we just look in the array in the Guest's
- * "struct lguest_data" and see if there are any new ones marked "ready".
- *
- * We are careful to do these in order: obviously we respect the order the
- * Guest put them in the ring, but we also promise the Guest that they will
- * happen before any normal hypercall (which is why we check this before
- * checking for a normal hcall). */
-static void do_async_hcalls(struct lguest *lg)
-{
-	unsigned int i;
-	u8 st[LHCALL_RING_SIZE];
-
-	/* For simplicity, we copy the entire call status array in at once. */
-	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
-		return;
-
-
-	/* We process "struct lguest_data"s hcalls[] ring once. */
-	for (i = 0; i < ARRAY_SIZE(st); i++) {
-		struct lguest_regs regs;
-		/* We remember where we were up to from last time.  This makes
-		 * sure that the hypercalls are done in the order the Guest
-		 * places them in the ring. */
-		unsigned int n = lg->next_hcall;
-
-		/* 0xFF means there's no call here (yet). */
-		if (st[n] == 0xFF)
-			break;
-
-		/* OK, we have hypercall.  Increment the "next_hcall" cursor,
-		 * and wrap back to 0 if we reach the end. */
-		if (++lg->next_hcall == LHCALL_RING_SIZE)
-			lg->next_hcall = 0;
-
-		/* We copy the hypercall arguments into a fake register
-		 * structure.  This makes life simple for do_hcall(). */
-		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
-		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
-		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
-		    || get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx)) {
-			kill_guest(lg, "Fetching async hypercalls");
-			break;
-		}
-
-		/* Do the hypercall, same as a normal one. */
-		do_hcall(lg, &regs);
-
-		/* Mark the hypercall done. */
-		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
-			kill_guest(lg, "Writing result for async hypercall");
-			break;
-		}
-
- 		/* Stop doing hypercalls if we've just done a DMA to the
-		 * Launcher: it needs to service this first. */
-		if (lg->dma_is_pending)
-			break;
-	}
-}
-
-/* Last of all, we look at what happens first of all.  The very first time the
- * Guest makes a hypercall, we end up here to set things up: */
-static void initialize(struct lguest *lg)
-{
-	u32 tsc_speed;
-
-	/* You can't do anything until you're initialized.  The Guest knows the
-	 * rules, so we're unforgiving here. */
-	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
-		kill_guest(lg, "hypercall %li before LGUEST_INIT",
-			   lg->regs->eax);
-		return;
-	}
-
-	/* We insist that the Time Stamp Counter exist and doesn't change with
-	 * cpu frequency.  Some devious chip manufacturers decided that TSC
-	 * changes could be handled in software.  I decided that time going
-	 * backwards might be good for benchmarks, but it's bad for users.
-	 *
-	 * We also insist that the TSC be stable: the kernel detects unreliable
-	 * TSCs for its own purposes, and we use that here. */
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) && !check_tsc_unstable())
-		tsc_speed = tsc_khz;
-	else
-		tsc_speed = 0;
-
-	/* The pointer to the Guest's "struct lguest_data" is the only
-	 * argument. */
-	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
-	/* If we check the address they gave is OK now, we can simply
-	 * copy_to_user/from_user from now on rather than using lgread/lgwrite.
-	 * I put this in to show that I'm not immune to writing stupid
-	 * optimizations. */
-	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
-		kill_guest(lg, "bad guest page %p", lg->lguest_data);
-		return;
-	}
-	/* The Guest tells us where we're not to deliver interrupts by putting
-	 * the range of addresses into "struct lguest_data". */
-	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
-	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
-	    /* We tell the Guest that it can't use the top 4MB of virtual
-	     * addresses used by the Switcher. */
-	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
-	    || put_user(tsc_speed, &lg->lguest_data->tsc_khz)
-	    /* We also give the Guest a unique id, as used in lguest_net.c. */
-	    || put_user(lg->guestid, &lg->lguest_data->guestid))
-		kill_guest(lg, "bad guest page %p", lg->lguest_data);
-
-	/* We write the current time into the Guest's data page once now. */
-	write_timestamp(lg);
-
-	/* This is the one case where the above accesses might have been the
-	 * first write to a Guest page.  This may have caused a copy-on-write
-	 * fault, but the Guest might be referring to the old (read-only)
-	 * page. */
-	guest_pagetable_clear_all(lg);
-}
-/* Now we've examined the hypercall code; our Guest can make requests.  There
- * is one other way we can do things for the Guest, as we see in
- * emulate_insn(). */
-
-/*H:110 Tricky point: we mark the hypercall as "done" once we've done it.
- * Normally we don't need to do this: the Guest will run again and update the
- * trap number before we come back around the run_guest() loop to
- * do_hypercalls().
- *
- * However, if we are signalled or the Guest sends DMA to the Launcher, that
- * loop will exit without running the Guest.  When it comes back it would try
- * to re-run the hypercall. */
-static void clear_hcall(struct lguest *lg)
-{
-	lg->regs->trapnum = 255;
-}
-
-/*H:100
- * Hypercalls
- *
- * Remember from the Guest, hypercalls come in two flavors: normal and
- * asynchronous.  This file handles both of types.
- */
-void do_hypercalls(struct lguest *lg)
-{
-	/* Not initialized yet? */
-	if (unlikely(!lg->lguest_data)) {
-		/* Did the Guest make a hypercall?  We might have come back for
-		 * some other reason (an interrupt, a different trap). */
-		if (lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
-			/* Set up the "struct lguest_data" */
-			initialize(lg);
-			/* The hypercall is done. */
-			clear_hcall(lg);
-		}
-		return;
-	}
-
-	/* The Guest has initialized.
-	 *
-	 * Look in the hypercall ring for the async hypercalls: */
-	do_async_hcalls(lg);
-
-	/* If we stopped reading the hypercall ring because the Guest did a
-	 * SEND_DMA to the Launcher, we want to return now.  Otherwise if the
-	 * Guest asked us to do a hypercall, we do it. */
-	if (!lg->dma_is_pending && lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
-		do_hcall(lg, lg->regs);
-		/* The hypercall is done. */
-		clear_hcall(lg);
-	}
-}
-
-/* This routine supplies the Guest with time: it's used for wallclock time at
- * initial boot and as a rough time source if the TSC isn't available. */
-void write_timestamp(struct lguest *lg)
-{
-	struct timespec now;
-	ktime_get_real_ts(&now);
-	if (put_user(now, &lg->lguest_data->time))
-		kill_guest(lg, "Writing timestamp");
-}
diff --git a/drivers/lguest/i386/Makefile b/drivers/lguest/i386/Makefile
new file mode 100644
index 0000000..de63997
--- /dev/null
+++ b/drivers/lguest/i386/Makefile
@@ -0,0 +1,7 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o ../io.o lguest_user.o switcher.o
diff --git a/drivers/lguest/i386/core.c b/drivers/lguest/i386/core.c
new file mode 100644
index 0000000..5bcd237
--- /dev/null
+++ b/drivers/lguest/i386/core.c
@@ -0,0 +1,771 @@
+/*P:400 This contains run_guest() which actually calls into the Host<->Guest
+ * Switcher and analyzes the return, such as determining if the Guest wants the
+ * Host to do something.  This file also contains useful helper routines, and a
+ * couple of non-obvious setup and teardown pieces which were implemented after
+ * days of debugging pain. :*/
+#include <linux/module.h>
+#include <linux/stringify.h>
+#include <linux/stddef.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/cpu.h>
+#include <linux/freezer.h>
+#include <asm/paravirt.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/poll.h>
+#include <asm/highmem.h>
+#include <asm/asm-offsets.h>
+#include <asm/i387.h>
+#include <linux/lg.h>
+
+/* Found in switcher.S */
+extern char start_switcher_text[], end_switcher_text[], switch_to_guest[];
+extern unsigned long default_idt_entries[];
+
+/* Every guest maps the core switcher code. */
+#define SHARED_SWITCHER_PAGES \
+	DIV_ROUND_UP(end_switcher_text - start_switcher_text, PAGE_SIZE)
+/* Pages for switcher itself, then two pages per cpu */
+#define TOTAL_SWITCHER_PAGES (SHARED_SWITCHER_PAGES + 2 * NR_CPUS)
+
+/* We map at -4M for ease of mapping into the guest (one PTE page). */
+#define SWITCHER_ADDR 0xFFC00000
+
+static struct vm_struct *switcher_vma;
+static struct page **switcher_page;
+
+static int cpu_had_pge;
+static struct {
+	unsigned long offset;
+	unsigned short segment;
+} lguest_entry;
+
+/* This One Big lock protects all inter-guest data structures. */
+DEFINE_MUTEX(lguest_lock);
+static DEFINE_PER_CPU(struct lguest *, last_guest);
+
+/* FIXME: Make dynamic. */
+#define MAX_LGUEST_GUESTS 16
+struct lguest lguests[MAX_LGUEST_GUESTS];
+
+/* Offset from where switcher.S was compiled to where we've copied it */
+static unsigned long switcher_offset(void)
+{
+	return SWITCHER_ADDR - (unsigned long)start_switcher_text;
+}
+
+/* This cpu's struct lguest_pages. */
+static struct lguest_pages *lguest_pages(unsigned int cpu)
+{
+	return &(((struct lguest_pages *)
+		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
+}
+
+/*H:010 We need to set up the Switcher at a high virtual address.  Remember the
+ * Switcher is a few hundred bytes of assembler code which actually changes the
+ * CPU to run the Guest, and then changes back to the Host when a trap or
+ * interrupt happens.
+ *
+ * The Switcher code must be at the same virtual address in the Guest as the
+ * Host since it will be running as the switchover occurs.
+ *
+ * Trying to map memory at a particular address is an unusual thing to do, so
+ * it's not a simple one-liner.  We also set up the per-cpu parts of the
+ * Switcher here.
+ */
+static __init int map_switcher(void)
+{
+	int i, err;
+	struct page **pagep;
+
+	/*
+	 * Map the Switcher in to high memory.
+	 *
+	 * It turns out that if we choose the address 0xFFC00000 (4MB under the
+	 * top virtual address), it makes setting up the page tables really
+	 * easy.
+	 */
+
+	/* We allocate an array of "struct page"s.  map_vm_area() wants the
+	 * pages in this form, rather than just an array of pointers. */
+	switcher_page = kmalloc(sizeof(switcher_page[0])*TOTAL_SWITCHER_PAGES,
+				GFP_KERNEL);
+	if (!switcher_page) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Now we actually allocate the pages.  The Guest will see these pages,
+	 * so we make sure they're zeroed. */
+	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++) {
+		unsigned long addr = get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			err = -ENOMEM;
+			goto free_some_pages;
+		}
+		switcher_page[i] = virt_to_page(addr);
+	}
+
+	/* Now we reserve the "virtual memory area" we want: 0xFFC00000
+	 * (SWITCHER_ADDR).  We might not get it in theory, but in practice
+	 * it's worked so far. */
+	switcher_vma = __get_vm_area(TOTAL_SWITCHER_PAGES * PAGE_SIZE,
+				       VM_ALLOC, SWITCHER_ADDR, VMALLOC_END);
+	if (!switcher_vma) {
+		err = -ENOMEM;
+		printk("lguest: could not map switcher pages high\n");
+		goto free_pages;
+	}
+
+	/* This code actually sets up the pages we've allocated to appear at
+	 * SWITCHER_ADDR.  map_vm_area() takes the vma we allocated above, the
+	 * kind of pages we're mapping (kernel pages), and a pointer to our
+	 * array of struct pages.  It increments that pointer, but we don't
+	 * care. */
+	pagep = switcher_page;
+	err = map_vm_area(switcher_vma, PAGE_KERNEL, &pagep);
+	if (err) {
+		printk("lguest: map_vm_area failed: %i\n", err);
+		goto free_vma;
+	}
+
+	/* Now the switcher is mapped at the right address, we can't fail!
+	 * Copy in the compiled-in Switcher code (from switcher.S). */
+	memcpy(switcher_vma->addr, start_switcher_text,
+	       end_switcher_text - start_switcher_text);
+
+	/* Most of the switcher.S doesn't care that it's been moved; on Intel,
+	 * jumps are relative, and it doesn't access any references to external
+	 * code or data.
+	 *
+	 * The only exception is the interrupt handlers in switcher.S: their
+	 * addresses are placed in a table (default_idt_entries), so we need to
+	 * update the table with the new addresses.  switcher_offset() is a
+	 * convenience function which returns the distance between the builtin
+	 * switcher code and the high-mapped copy we just made. */
+	for (i = 0; i < IDT_ENTRIES; i++)
+		default_idt_entries[i] += switcher_offset();
+
+	/*
+	 * Set up the Switcher's per-cpu areas.
+	 *
+	 * Each CPU gets two pages of its own within the high-mapped region
+	 * (aka. "struct lguest_pages").  Much of this can be initialized now,
+	 * but some depends on what Guest we are running (which is set up in
+	 * copy_in_guest_info()).
+	 */
+	for_each_possible_cpu(i) {
+		/* lguest_pages() returns this CPU's two pages. */
+		struct lguest_pages *pages = lguest_pages(i);
+		/* This is a convenience pointer to make the code fit one
+		 * statement to a line. */
+		struct lguest_ro_state *state = &pages->state;
+
+		/* The Global Descriptor Table: the Host has a different one
+		 * for each CPU.  We keep a descriptor for the GDT which says
+		 * where it is and how big it is (the size is actually the last
+		 * byte, not the size, hence the "-1"). */
+		state->host_gdt_desc.size = GDT_SIZE-1;
+		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
+
+		/* All CPUs on the Host use the same Interrupt Descriptor
+		 * Table, so we just use store_idt(), which gets this CPU's IDT
+		 * descriptor. */
+		store_idt(&state->host_idt_desc);
+
+		/* The descriptors for the Guest's GDT and IDT can be filled
+		 * out now, too.  We copy the GDT & IDT into ->guest_gdt and
+		 * ->guest_idt before actually running the Guest. */
+		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
+		state->guest_idt_desc.address = (long)&state->guest_idt;
+		state->guest_gdt_desc.size = sizeof(state->guest_gdt)-1;
+		state->guest_gdt_desc.address = (long)&state->guest_gdt;
+
+		/* We know where we want the stack to be when the Guest enters
+		 * the switcher: in pages->regs.  The stack grows upwards, so
+		 * we start it at the end of that structure. */
+		state->guest_tss.esp0 = (long)(&pages->regs + 1);
+		/* And this is the GDT entry to use for the stack: we keep a
+		 * couple of special LGUEST entries. */
+		state->guest_tss.ss0 = LGUEST_DS;
+
+		/* x86 can have a finegrained bitmap which indicates what I/O
+		 * ports the process can use.  We set it to the end of our
+		 * structure, meaning "none". */
+		state->guest_tss.io_bitmap_base = sizeof(state->guest_tss);
+
+		/* Some GDT entries are the same across all Guests, so we can
+		 * set them up now. */
+		setup_default_gdt_entries(state);
+		/* Most IDT entries are the same for all Guests, too.*/
+		setup_default_idt_entries(state, default_idt_entries);
+
+		/* The Host needs to be able to use the LGUEST segments on this
+		 * CPU, too, so put them in the Host GDT. */
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+	}
+
+	/* In the Switcher, we want the %cs segment register to use the
+	 * LGUEST_CS GDT entry: we've put that in the Host and Guest GDTs, so
+	 * it will be undisturbed when we switch.  To change %cs and jump we
+	 * need this structure to feed to Intel's "lcall" instruction. */
+	lguest_entry.offset = (long)switch_to_guest + switcher_offset();
+	lguest_entry.segment = LGUEST_CS;
+
+	printk(KERN_INFO "lguest: mapped switcher at %p\n",
+	       switcher_vma->addr);
+	/* And we succeeded... */
+	return 0;
+
+free_vma:
+	vunmap(switcher_vma->addr);
+free_pages:
+	i = TOTAL_SWITCHER_PAGES;
+free_some_pages:
+	for (--i; i >= 0; i--)
+		__free_pages(switcher_page[i], 0);
+	kfree(switcher_page);
+out:
+	return err;
+}
+/*:*/
+
+/* Cleaning up the mapping when the module is unloaded is almost...
+ * too easy. */
+static void unmap_switcher(void)
+{
+	unsigned int i;
+
+	/* vunmap() undoes *both* map_vm_area() and __get_vm_area(). */
+	vunmap(switcher_vma->addr);
+	/* Now we just need to free the pages we copied the switcher into */
+	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++)
+		__free_pages(switcher_page[i], 0);
+}
+
+/*H:130 Our Guest is usually so well behaved; it never tries to do things it
+ * isn't allowed to.  Unfortunately, "struct paravirt_ops" isn't quite
+ * complete, because it doesn't contain replacements for the Intel I/O
+ * instructions.  As a result, the Guest sometimes fumbles across one during
+ * the boot process as it probes for various things which are usually attached
+ * to a PC.
+ *
+ * When the Guest uses one of these instructions, we get trap #13 (General
+ * Protection Fault) and come here.  We see if it's one of those troublesome
+ * instructions and skip over it.  We return true if we did. */
+static int emulate_insn(struct lguest *lg)
+{
+	u8 insn;
+	unsigned int insnlen = 0, in = 0, shift = 0;
+	/* The eip contains the *virtual* address of the Guest's instruction:
+	 * guest_pa just subtracts the Guest's page_offset. */
+	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
+
+	/* The guest_pa() function only works for Guest kernel addresses, but
+	 * that's all we're trying to do anyway. */
+	if (lg->regs->eip < lg->page_offset)
+		return 0;
+
+	/* Decoding x86 instructions is icky. */
+	lgread(lg, &insn, physaddr, 1);
+
+	/* 0x66 is an "operand prefix".  It means it's using the upper 16 bits
+	   of the eax register. */
+	if (insn == 0x66) {
+		shift = 16;
+		/* The instruction is 1 byte so far, read the next byte. */
+		insnlen = 1;
+		lgread(lg, &insn, physaddr + insnlen, 1);
+	}
+
+	/* We can ignore the lower bit for the moment and decode the 4 opcodes
+	 * we need to emulate. */
+	switch (insn & 0xFE) {
+	case 0xE4: /* in     <next byte>,%al */
+		insnlen += 2;
+		in = 1;
+		break;
+	case 0xEC: /* in     (%dx),%al */
+		insnlen += 1;
+		in = 1;
+		break;
+	case 0xE6: /* out    %al,<next byte> */
+		insnlen += 2;
+		break;
+	case 0xEE: /* out    %al,(%dx) */
+		insnlen += 1;
+		break;
+	default:
+		/* OK, we don't know what this is, can't emulate. */
+		return 0;
+	}
+
+	/* If it was an "IN" instruction, they expect the result to be read
+	 * into %eax, so we change %eax.  We always return all-ones, which
+	 * traditionally means "there's nothing there". */
+	if (in) {
+		/* Lower bit tells is whether it's a 16 or 32 bit access */
+		if (insn & 0x1)
+			lg->regs->eax = 0xFFFFFFFF;
+		else
+			lg->regs->eax |= (0xFFFF << shift);
+	}
+	/* Finally, we've "done" the instruction, so move past it. */
+	lg->regs->eip += insnlen;
+	/* Success! */
+	return 1;
+}
+/*:*/
+
+/*L:305
+ * Dealing With Guest Memory.
+ *
+ * When the Guest gives us (what it thinks is) a physical address, we can use
+ * the normal copy_from_user() & copy_to_user() on that address: remember,
+ * Guest physical == Launcher virtual.
+ *
+ * But we can't trust the Guest: it might be trying to access the Launcher
+ * code.  We have to check that the range is below the pfn_limit the Launcher
+ * gave us.  We have to make sure that addr + len doesn't give us a false
+ * positive by overflowing, too. */
+int lguest_address_ok(const struct lguest *lg,
+		      unsigned long addr, unsigned long len)
+{
+	return (addr+len) / PAGE_SIZE < lg->pfn_limit && (addr+len >= addr);
+}
+
+/* This is a convenient routine to get a 32-bit value from the Guest (a very
+ * common operation).  Here we can see how useful the kill_lguest() routine we
+ * met in the Launcher can be: we return a random value (0) instead of needing
+ * to return an error. */
+u32 lgread_u32(struct lguest *lg, unsigned long addr)
+{
+	u32 val = 0;
+
+	/* Don't let them access lguest binary. */
+	if (!lguest_address_ok(lg, addr, sizeof(val))
+	    || get_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad read address %#lx", addr);
+	return val;
+}
+
+/* Same thing for writing a value. */
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
+{
+	if (!lguest_address_ok(lg, addr, sizeof(val))
+	    || put_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad write address %#lx", addr);
+}
+
+/* This routine is more generic, and copies a range of Guest bytes into a
+ * buffer.  If the copy_from_user() fails, we fill the buffer with zeroes, so
+ * the caller doesn't end up using uninitialized kernel memory. */
+void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
+		/* copy_from_user should do this, but as we rely on it... */
+		memset(b, 0, bytes);
+		kill_guest(lg, "bad read address %#lx len %u", addr, bytes);
+	}
+}
+
+/* Similarly, our generic routine to copy into a range of Guest bytes. */
+void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
+	     unsigned bytes)
+{
+	if (!lguest_address_ok(lg, addr, bytes)
+	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
+}
+/* (end of memory access helper routines) :*/
+
+static void set_ts(void)
+{
+	u32 cr0;
+
+	cr0 = read_cr0();
+	if (!(cr0 & 8))
+		write_cr0(cr0|8);
+}
+
+/*S:010
+ * We are getting close to the Switcher.
+ *
+ * Remember that each CPU has two pages which are visible to the Guest when it
+ * runs on that CPU.  This has to contain the state for that Guest: we copy the
+ * state in just before we run the Guest.
+ *
+ * Each Guest has "changed" flags which indicate what has changed in the Guest
+ * since it last ran.  We saw this set in interrupts_and_traps.c and
+ * segments.c.
+ */
+static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
+{
+	/* Copying all this data can be quite expensive.  We usually run the
+	 * same Guest we ran last time (and that Guest hasn't run anywhere else
+	 * meanwhile).  If that's not the case, we pretend everything in the
+	 * Guest has changed. */
+	if (__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
+		__get_cpu_var(last_guest) = lg;
+		lg->last_pages = pages;
+		lg->changed = CHANGED_ALL;
+	}
+
+	/* These copies are pretty cheap, so we do them unconditionally: */
+	/* Save the current Host top-level page directory. */
+	pages->state.host_cr3 = __pa(current->mm->pgd);
+	/* Set up the Guest's page tables to see this CPU's pages (and no
+	 * other CPU's pages). */
+	map_switcher_in_guest(lg, pages);
+	/* Set up the two "TSS" members which tell the CPU what stack to use
+	 * for traps which do directly into the Guest (ie. traps at privilege
+	 * level 1). */
+	pages->state.guest_tss.esp1 = lg->esp1;
+	pages->state.guest_tss.ss1 = lg->ss1;
+
+	/* Copy direct-to-Guest trap entries. */
+	if (lg->changed & CHANGED_IDT)
+		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
+
+	/* Copy all GDT entries which the Guest can change. */
+	if (lg->changed & CHANGED_GDT)
+		copy_gdt(lg, pages->state.guest_gdt);
+	/* If only the TLS entries have changed, copy them. */
+	else if (lg->changed & CHANGED_GDT_TLS)
+		copy_gdt_tls(lg, pages->state.guest_gdt);
+
+	/* Mark the Guest as unchanged for next time. */
+	lg->changed = 0;
+}
+
+/* Finally: the code to actually call into the Switcher to run the Guest. */
+static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
+{
+	/* This is a dummy value we need for GCC's sake. */
+	unsigned int clobber;
+
+	/* Copy the guest-specific information into this CPU's "struct
+	 * lguest_pages". */
+	copy_in_guest_info(lg, pages);
+
+	/* Now: we push the "eflags" register on the stack, then do an "lcall".
+	 * This is how we change from using the kernel code segment to using
+	 * the dedicated lguest code segment, as well as jumping into the
+	 * Switcher.
+	 *
+	 * The lcall also pushes the old code segment (KERNEL_CS) onto the
+	 * stack, then the address of this call.  This stack layout happens to
+	 * exactly match the stack of an interrupt... */
+	asm volatile("pushf; lcall *lguest_entry"
+		     /* This is how we tell GCC that %eax ("a") and %ebx ("b")
+		      * are changed by this routine.  The "=" means output. */
+		     : "=a"(clobber), "=b"(clobber)
+		     /* %eax contains the pages pointer.  ("0" refers to the
+		      * 0-th argument above, ie "a").  %ebx contains the
+		      * physical address of the Guest's top-level page
+		      * directory. */
+		     : "0"(pages), "1"(__pa(lg->pgdirs[lg->pgdidx].pgdir))
+		     /* We tell gcc that all these registers could change,
+		      * which means we don't have to save and restore them in
+		      * the Switcher. */
+		     : "memory", "%edx", "%ecx", "%edi", "%esi");
+}
+/*:*/
+
+/*H:030 Let's jump straight to the the main loop which runs the Guest.
+ * Remember, this is called by the Launcher reading /dev/lguest, and we keep
+ * going around and around until something interesting happens. */
+int run_guest(struct lguest *lg, unsigned long __user *user)
+{
+	/* We stop running once the Guest is dead. */
+	while (!lg->dead) {
+		/* We need to initialize this, otherwise gcc complains.  It's
+		 * not (yet) clever enough to see that it's initialized when we
+		 * need it. */
+		unsigned int cr2 = 0; /* Damn gcc */
+
+		/* First we run any hypercalls the Guest wants done: either in
+		 * the hypercall ring in "struct lguest_data", or directly by
+		 * using int 31 (LGUEST_TRAP_ENTRY). */
+		do_hypercalls(lg);
+		/* It's possible the Guest did a SEND_DMA hypercall to the
+		 * Launcher, in which case we return from the read() now. */
+		if (lg->dma_is_pending) {
+			if (put_user(lg->pending_dma, user) ||
+			    put_user(lg->pending_key, user+1))
+				return -EFAULT;
+			return sizeof(unsigned long)*2;
+		}
+
+		/* Check for signals */
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		/* If Waker set break_out, return to Launcher. */
+		if (lg->break_out)
+			return -EAGAIN;
+
+		/* Check if there are any interrupts which can be delivered
+		 * now: if so, this sets up the hander to be executed when we
+		 * next run the Guest. */
+		maybe_do_interrupt(lg);
+
+		/* All long-lived kernel loops need to check with this horrible
+		 * thing called the freezer.  If the Host is trying to suspend,
+		 * it stops us. */
+		try_to_freeze();
+
+		/* Just make absolutely sure the Guest is still alive.  One of
+		 * those hypercalls could have been fatal, for example. */
+		if (lg->dead)
+			break;
+
+		/* If the Guest asked to be stopped, we sleep.  The Guest's
+		 * clock timer or LHCALL_BREAK from the Waker will wake us. */
+		if (lg->halted) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			continue;
+		}
+
+		/* OK, now we're ready to jump into the Guest.  First we put up
+		 * the "Do Not Disturb" sign: */
+		local_irq_disable();
+
+		/* Remember the awfully-named TS bit?  If the Guest has asked
+		 * to set it we set it now, so we can trap and pass that trap
+		 * to the Guest if it uses the FPU. */
+		if (lg->ts)
+			set_ts();
+
+		/* SYSENTER is an optimized way of doing system calls.  We
+		 * can't allow it because it always jumps to privilege level 0.
+		 * A normal Guest won't try it because we don't advertise it in
+		 * CPUID, but a malicious Guest (or malicious Guest userspace
+		 * program) could, so we tell the CPU to disable it before
+		 * running the Guest. */
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
+
+		/* Now we actually run the Guest.  It will pop back out when
+		 * something interesting happens, and we can examine its
+		 * registers to see what it was doing. */
+		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
+
+		/* The "regs" pointer contains two extra entries which are not
+		 * really registers: a trap number which says what interrupt or
+		 * trap made the switcher code come back, and an error code
+		 * which some traps set.  */
+
+		/* If the Guest page faulted, then the cr2 register will tell
+		 * us the bad virtual address.  We have to grab this now,
+		 * because once we re-enable interrupts an interrupt could
+		 * fault and thus overwrite cr2, or we could even move off to a
+		 * different CPU. */
+		if (lg->regs->trapnum == 14)
+			cr2 = read_cr2();
+		/* Similarly, if we took a trap because the Guest used the FPU,
+		 * we have to restore the FPU it expects to see. */
+		else if (lg->regs->trapnum == 7)
+			math_state_restore();
+
+		/* Restore SYSENTER if it's supposed to be on. */
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+
+		/* Now we're ready to be interrupted or moved to other CPUs */
+		local_irq_enable();
+
+		/* OK, so what happened? */
+		switch (lg->regs->trapnum) {
+		case 13: /* We've intercepted a GPF. */
+			/* Check if this was one of those annoying IN or OUT
+			 * instructions which we need to emulate.  If so, we
+			 * just go back into the Guest after we've done it. */
+			if (lg->regs->errcode == 0) {
+				if (emulate_insn(lg))
+					continue;
+			}
+			break;
+		case 14: /* We've intercepted a page fault. */
+			/* The Guest accessed a virtual address that wasn't
+			 * mapped.  This happens a lot: we don't actually set
+			 * up most of the page tables for the Guest at all when
+			 * we start: as it runs it asks for more and more, and
+			 * we set them up as required. In this case, we don't
+			 * even tell the Guest that the fault happened.
+			 *
+			 * The errcode tells whether this was a read or a
+			 * write, and whether kernel or userspace code. */
+			if (demand_page(lg, cr2, lg->regs->errcode))
+				continue;
+
+			/* OK, it's really not there (or not OK): the Guest
+			 * needs to know.  We write out the cr2 value so it
+			 * knows where the fault occurred.
+			 *
+			 * Note that if the Guest were really messed up, this
+			 * could happen before it's done the INITIALIZE
+			 * hypercall, so lg->lguest_data will be NULL, so
+			 * &lg->lguest_data->cr2 will be address 8.  Writing
+			 * into that address won't hurt the Host at all,
+			 * though. */
+			if (put_user(cr2, &lg->lguest_data->cr2))
+				kill_guest(lg, "Writing cr2");
+			break;
+		case 7: /* We've intercepted a Device Not Available fault. */
+			/* If the Guest doesn't want to know, we already
+			 * restored the Floating Point Unit, so we just
+			 * continue without telling it. */
+			if (!lg->ts)
+				continue;
+			break;
+		case 32 ... 255:
+			/* These values mean a real interrupt occurred, in
+			 * which case the Host handler has already been run.
+			 * We just do a friendly check if another process
+			 * should now be run, then fall through to loop
+			 * around: */
+			cond_resched();
+		case LGUEST_TRAP_ENTRY: /* Handled at top of loop */
+			continue;
+		}
+
+		/* If we get here, it's a trap the Guest wants to know
+		 * about. */
+		if (deliver_trap(lg, lg->regs->trapnum))
+			continue;
+
+		/* If the Guest doesn't have a handler (either it hasn't
+		 * registered any yet, or it's one of the faults we don't let
+		 * it handle), it dies with a cryptic error message. */
+		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
+			   lg->regs->trapnum, lg->regs->eip,
+			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
+	}
+	/* The Guest is dead => "No such file or directory" */
+	return -ENOENT;
+}
+
+/* Now we can look at each of the routines this calls, in increasing order of
+ * complexity: do_hypercalls(), emulate_insn(), maybe_do_interrupt(),
+ * deliver_trap() and demand_page().  After all those, we'll be ready to
+ * examine the Switcher, and our philosophical understanding of the Host/Guest
+ * duality will be complete. :*/
+
+int find_free_guest(void)
+{
+	unsigned int i;
+	for (i = 0; i < MAX_LGUEST_GUESTS; i++)
+		if (!lguests[i].tsk)
+			return i;
+	return -1;
+}
+
+static void adjust_pge(void *on)
+{
+	if (on)
+		write_cr4(read_cr4() | X86_CR4_PGE);
+	else
+		write_cr4(read_cr4() & ~X86_CR4_PGE);
+}
+
+/*H:000
+ * Welcome to the Host!
+ *
+ * By this point your brain has been tickled by the Guest code and numbed by
+ * the Launcher code; prepare for it to be stretched by the Host code.  This is
+ * the heart.  Let's begin at the initialization routine for the Host's lg
+ * module.
+ */
+static int __init init(void)
+{
+	int err;
+
+	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
+	if (paravirt_enabled()) {
+		printk("lguest is afraid of %s\n", paravirt_ops.name);
+		return -EPERM;
+	}
+
+	/* First we put the Switcher up in very high virtual memory. */
+	err = map_switcher();
+	if (err)
+		return err;
+
+	/* Now we set up the pagetable implementation for the Guests. */
+	err = init_pagetables(switcher_page, SHARED_SWITCHER_PAGES);
+	if (err) {
+		unmap_switcher();
+		return err;
+	}
+
+	/* The I/O subsystem needs some things initialized. */
+	lguest_io_init();
+
+	/* /dev/lguest needs to be registered. */
+	err = lguest_device_init();
+	if (err) {
+		free_pagetables();
+		unmap_switcher();
+		return err;
+	}
+
+	/* Finally, we need to turn off "Page Global Enable".  PGE is an
+	 * optimization where page table entries are specially marked to show
+	 * they never change.  The Host kernel marks all the kernel pages this
+	 * way because it's always present, even when userspace is running.
+	 *
+	 * Lguest breaks this: unbeknownst to the rest of the Host kernel, we
+	 * switch to the Guest kernel.  If you don't disable this on all CPUs,
+	 * you'll get really weird bugs that you'll chase for two days.
+	 *
+	 * I used to turn PGE off every time we switched to the Guest and back
+	 * on when we return, but that slowed the Switcher down noticibly. */
+
+	/* We don't need the complexity of CPUs coming and going while we're
+	 * doing this. */
+	lock_cpu_hotplug();
+	if (cpu_has_pge) { /* We have a broader idea of "global". */
+		/* Remember that this was originally set (for cleanup). */
+		cpu_had_pge = 1;
+		/* adjust_pge is a helper function which sets or unsets the PGE
+		 * bit on its CPU, depending on the argument (0 == unset). */
+		on_each_cpu(adjust_pge, (void *)0, 0, 1);
+		/* Turn off the feature in the global feature set. */
+		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+	}
+	unlock_cpu_hotplug();
+
+	/* All good! */
+	return 0;
+}
+
+/* Cleaning up is just the same code, backwards.  With a little French. */
+static void __exit fini(void)
+{
+	lguest_device_remove();
+	free_pagetables();
+	unmap_switcher();
+
+	/* If we had PGE before we started, turn it back on now. */
+	lock_cpu_hotplug();
+	if (cpu_had_pge) {
+		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+		/* adjust_pge's argument "1" means set PGE. */
+		on_each_cpu(adjust_pge, (void *)1, 0, 1);
+	}
+	unlock_cpu_hotplug();
+}
+
+/* The Host side of lguest can be a module.  This is a nice way for people to
+ * play with it.  */
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
diff --git a/drivers/lguest/i386/hypercalls.c b/drivers/lguest/i386/hypercalls.c
new file mode 100644
index 0000000..3c0d41e
--- /dev/null
+++ b/drivers/lguest/i386/hypercalls.c
@@ -0,0 +1,300 @@
+/*P:500 Just as userspace programs request kernel operations through a system
+ * call, the Guest requests Host operations through a "hypercall".  You might
+ * notice this nomenclature doesn't really follow any logic, but the name has
+ * been around for long enough that we're stuck with it.  As you'd expect, this
+ * code is basically a one big switch statement. :*/
+
+/*  Copyright (C) 2006 Rusty Russell IBM Corporation
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+*/
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <irq_vectors.h>
+#include <linux/lg.h>
+
+/*H:120 This is the core hypercall routine: where the Guest gets what it
+ * wants.  Or gets killed.  Or, in the case of LHCALL_CRASH, both.
+ *
+ * Remember from the Guest: %eax == which call to make, and the arguments are
+ * packed into %edx, %ebx and %ecx if needed. */
+static void do_hcall(struct lguest *lg, struct lguest_regs *regs)
+{
+	switch (regs->eax) {
+	case LHCALL_FLUSH_ASYNC:
+		/* This call does nothing, except by breaking out of the Guest
+		 * it makes us process all the asynchronous hypercalls. */
+		break;
+	case LHCALL_LGUEST_INIT:
+		/* You can't get here unless you're already initialized.  Don't
+		 * do that. */
+		kill_guest(lg, "already have lguest_data");
+		break;
+	case LHCALL_CRASH: {
+		/* Crash is such a trivial hypercall that we do it in four
+		 * lines right here. */
+		char msg[128];
+		/* If the lgread fails, it will call kill_guest() itself; the
+		 * kill_guest() with the message will be ignored. */
+		lgread(lg, msg, regs->edx, sizeof(msg));
+		msg[sizeof(msg)-1] = '\0';
+		kill_guest(lg, "CRASH: %s", msg);
+		break;
+	}
+	case LHCALL_FLUSH_TLB:
+		/* FLUSH_TLB comes in two flavors, depending on the
+		 * argument: */
+		if (regs->edx)
+			guest_pagetable_clear_all(lg);
+		else
+			guest_pagetable_flush_user(lg);
+		break;
+	case LHCALL_BIND_DMA:
+		/* BIND_DMA really wants four arguments, but it's the only call
+		 * which does.  So the Guest packs the number of buffers and
+		 * the interrupt number into the final argument, and we decode
+		 * it here.  This can legitimately fail, since we currently
+		 * place a limit on the number of DMA pools a Guest can have.
+		 * So we return true or false from this call. */
+		regs->eax = bind_dma(lg, regs->edx, regs->ebx,
+				     regs->ecx >> 8, regs->ecx & 0xFF);
+		break;
+
+	/* All these calls simply pass the arguments through to the right
+	 * routines. */
+	case LHCALL_SEND_DMA:
+		send_dma(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_GDT:
+		load_guest_gdt(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_IDT_ENTRY:
+		load_guest_idt_entry(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_NEW_PGTABLE:
+		guest_new_pagetable(lg, regs->edx);
+		break;
+	case LHCALL_SET_STACK:
+		guest_set_stack(lg, regs->edx, regs->ebx, regs->ecx);
+		break;
+	case LHCALL_SET_PTE:
+		guest_set_pte(lg, regs->edx, regs->ebx, mkgpte(regs->ecx));
+		break;
+	case LHCALL_SET_PMD:
+		guest_set_pmd(lg, regs->edx, regs->ebx);
+		break;
+	case LHCALL_LOAD_TLS:
+		guest_load_tls(lg, regs->edx);
+		break;
+	case LHCALL_SET_CLOCKEVENT:
+		guest_set_clockevent(lg, regs->edx);
+		break;
+
+	case LHCALL_TS:
+		/* This sets the TS flag, as we saw used in run_guest(). */
+		lg->ts = regs->edx;
+		break;
+	case LHCALL_HALT:
+		/* Similarly, this sets the halted flag for run_guest(). */
+		lg->halted = 1;
+		break;
+	default:
+		kill_guest(lg, "Bad hypercall %li\n", regs->eax);
+	}
+}
+
+/* Asynchronous hypercalls are easy: we just look in the array in the Guest's
+ * "struct lguest_data" and see if there are any new ones marked "ready".
+ *
+ * We are careful to do these in order: obviously we respect the order the
+ * Guest put them in the ring, but we also promise the Guest that they will
+ * happen before any normal hypercall (which is why we check this before
+ * checking for a normal hcall). */
+static void do_async_hcalls(struct lguest *lg)
+{
+	unsigned int i;
+	u8 st[LHCALL_RING_SIZE];
+
+	/* For simplicity, we copy the entire call status array in at once. */
+	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+		return;
+
+
+	/* We process "struct lguest_data"s hcalls[] ring once. */
+	for (i = 0; i < ARRAY_SIZE(st); i++) {
+		struct lguest_regs regs;
+		/* We remember where we were up to from last time.  This makes
+		 * sure that the hypercalls are done in the order the Guest
+		 * places them in the ring. */
+		unsigned int n = lg->next_hcall;
+
+		/* 0xFF means there's no call here (yet). */
+		if (st[n] == 0xFF)
+			break;
+
+		/* OK, we have hypercall.  Increment the "next_hcall" cursor,
+		 * and wrap back to 0 if we reach the end. */
+		if (++lg->next_hcall == LHCALL_RING_SIZE)
+			lg->next_hcall = 0;
+
+		/* We copy the hypercall arguments into a fake register
+		 * structure.  This makes life simple for do_hcall(). */
+		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
+		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
+		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
+		    || get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx)) {
+			kill_guest(lg, "Fetching async hypercalls");
+			break;
+		}
+
+		/* Do the hypercall, same as a normal one. */
+		do_hcall(lg, &regs);
+
+		/* Mark the hypercall done. */
+		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
+			kill_guest(lg, "Writing result for async hypercall");
+			break;
+		}
+
+ 		/* Stop doing hypercalls if we've just done a DMA to the
+		 * Launcher: it needs to service this first. */
+		if (lg->dma_is_pending)
+			break;
+	}
+}
+
+/* Last of all, we look at what happens first of all.  The very first time the
+ * Guest makes a hypercall, we end up here to set things up: */
+static void initialize(struct lguest *lg)
+{
+	u32 tsc_speed;
+
+	/* You can't do anything until you're initialized.  The Guest knows the
+	 * rules, so we're unforgiving here. */
+	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
+		kill_guest(lg, "hypercall %li before LGUEST_INIT",
+			   lg->regs->eax);
+		return;
+	}
+
+	/* We insist that the Time Stamp Counter exist and doesn't change with
+	 * cpu frequency.  Some devious chip manufacturers decided that TSC
+	 * changes could be handled in software.  I decided that time going
+	 * backwards might be good for benchmarks, but it's bad for users.
+	 *
+	 * We also insist that the TSC be stable: the kernel detects unreliable
+	 * TSCs for its own purposes, and we use that here. */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) && !check_tsc_unstable())
+		tsc_speed = tsc_khz;
+	else
+		tsc_speed = 0;
+
+	/* The pointer to the Guest's "struct lguest_data" is the only
+	 * argument. */
+	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
+	/* If we check the address they gave is OK now, we can simply
+	 * copy_to_user/from_user from now on rather than using lgread/lgwrite.
+	 * I put this in to show that I'm not immune to writing stupid
+	 * optimizations. */
+	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+		return;
+	}
+	/* The Guest tells us where we're not to deliver interrupts by putting
+	 * the range of addresses into "struct lguest_data". */
+	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
+	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
+	    /* We tell the Guest that it can't use the top 4MB of virtual
+	     * addresses used by the Switcher. */
+	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(tsc_speed, &lg->lguest_data->tsc_khz)
+	    /* We also give the Guest a unique id, as used in lguest_net.c. */
+	    || put_user(lg->guestid, &lg->lguest_data->guestid))
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+
+	/* We write the current time into the Guest's data page once now. */
+	write_timestamp(lg);
+
+	/* This is the one case where the above accesses might have been the
+	 * first write to a Guest page.  This may have caused a copy-on-write
+	 * fault, but the Guest might be referring to the old (read-only)
+	 * page. */
+	guest_pagetable_clear_all(lg);
+}
+/* Now we've examined the hypercall code; our Guest can make requests.  There
+ * is one other way we can do things for the Guest, as we see in
+ * emulate_insn(). */
+
+/*H:110 Tricky point: we mark the hypercall as "done" once we've done it.
+ * Normally we don't need to do this: the Guest will run again and update the
+ * trap number before we come back around the run_guest() loop to
+ * do_hypercalls().
+ *
+ * However, if we are signalled or the Guest sends DMA to the Launcher, that
+ * loop will exit without running the Guest.  When it comes back it would try
+ * to re-run the hypercall. */
+static void clear_hcall(struct lguest *lg)
+{
+	lg->regs->trapnum = 255;
+}
+
+/*H:100
+ * Hypercalls
+ *
+ * Remember from the Guest, hypercalls come in two flavors: normal and
+ * asynchronous.  This file handles both of types.
+ */
+void do_hypercalls(struct lguest *lg)
+{
+	/* Not initialized yet? */
+	if (unlikely(!lg->lguest_data)) {
+		/* Did the Guest make a hypercall?  We might have come back for
+		 * some other reason (an interrupt, a different trap). */
+		if (lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
+			/* Set up the "struct lguest_data" */
+			initialize(lg);
+			/* The hypercall is done. */
+			clear_hcall(lg);
+		}
+		return;
+	}
+
+	/* The Guest has initialized.
+	 *
+	 * Look in the hypercall ring for the async hypercalls: */
+	do_async_hcalls(lg);
+
+	/* If we stopped reading the hypercall ring because the Guest did a
+	 * SEND_DMA to the Launcher, we want to return now.  Otherwise if the
+	 * Guest asked us to do a hypercall, we do it. */
+	if (!lg->dma_is_pending && lg->regs->trapnum == LGUEST_TRAP_ENTRY) {
+		do_hcall(lg, lg->regs);
+		/* The hypercall is done. */
+		clear_hcall(lg);
+	}
+}
+
+/* This routine supplies the Guest with time: it's used for wallclock time at
+ * initial boot and as a rough time source if the TSC isn't available. */
+void write_timestamp(struct lguest *lg)
+{
+	struct timespec now;
+	ktime_get_real_ts(&now);
+	if (put_user(now, &lg->lguest_data->time))
+		kill_guest(lg, "Writing timestamp");
+}
diff --git a/drivers/lguest/i386/interrupts_and_traps.c b/drivers/lguest/i386/interrupts_and_traps.c
new file mode 100644
index 0000000..3daf3e2
--- /dev/null
+++ b/drivers/lguest/i386/interrupts_and_traps.c
@@ -0,0 +1,440 @@
+/*P:800 Interrupts (traps) are complicated enough to earn their own file.
+ * There are three classes of interrupts:
+ *
+ * 1) Real hardware interrupts which occur while we're running the Guest,
+ * 2) Interrupts for virtual devices attached to the Guest, and
+ * 3) Traps and faults from the Guest.
+ *
+ * Real hardware interrupts must be delivered to the Host, not the Guest.
+ * Virtual interrupts must be delivered to the Guest, but we make them look
+ * just like real hardware would deliver them.  Traps from the Guest can be set
+ * up to go directly back into the Guest, but sometimes the Host wants to see
+ * them first, so we also have a way of "reflecting" them into the Guest as if
+ * they had been delivered to it directly. :*/
+#include <linux/uaccess.h>
+#include <linux/lg.h>
+
+/* The address of the interrupt handler is split into two bits: */
+static unsigned long idt_address(u32 lo, u32 hi)
+{
+	return (lo & 0x0000FFFF) | (hi & 0xFFFF0000);
+}
+
+/* The "type" of the interrupt handler is a 4 bit field: we only support a
+ * couple of types. */
+static int idt_type(u32 lo, u32 hi)
+{
+	return (hi >> 8) & 0xF;
+}
+
+/* An IDT entry can't be used unless the "present" bit is set. */
+static int idt_present(u32 lo, u32 hi)
+{
+	return (hi & 0x8000);
+}
+
+/* We need a helper to "push" a value onto the Guest's stack, since that's a
+ * big part of what delivering an interrupt does. */
+static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
+{
+	/* Stack grows upwards: move stack then write value. */
+	*gstack -= 4;
+	lgwrite_u32(lg, *gstack, val);
+}
+
+/*H:210 The set_guest_interrupt() routine actually delivers the interrupt or
+ * trap.  The mechanics of delivering traps and interrupts to the Guest are the
+ * same, except some traps have an "error code" which gets pushed onto the
+ * stack as well: the caller tells us if this is one.
+ *
+ * "lo" and "hi" are the two parts of the Interrupt Descriptor Table for this
+ * interrupt or trap.  It's split into two parts for traditional reasons: gcc
+ * on i386 used to be frightened by 64 bit numbers.
+ *
+ * We set up the stack just like the CPU does for a real interrupt, so it's
+ * identical for the Guest (and the standard "iret" instruction will undo
+ * it). */
+static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
+{
+	unsigned long gstack;
+	u32 eflags, ss, irq_enable;
+
+	/* There are two cases for interrupts: one where the Guest is already
+	 * in the kernel, and a more complex one where the Guest is in
+	 * userspace.  We check the privilege level to find out. */
+	if ((lg->regs->ss&0x3) != GUEST_PL) {
+		/* The Guest told us their kernel stack with the SET_STACK
+		 * hypercall: both the virtual address and the segment */
+		gstack = guest_pa(lg, lg->esp1);
+		ss = lg->ss1;
+		/* We push the old stack segment and pointer onto the new
+		 * stack: when the Guest does an "iret" back from the interrupt
+		 * handler the CPU will notice they're dropping privilege
+		 * levels and expect these here. */
+		push_guest_stack(lg, &gstack, lg->regs->ss);
+		push_guest_stack(lg, &gstack, lg->regs->esp);
+	} else {
+		/* We're staying on the same Guest (kernel) stack. */
+		gstack = guest_pa(lg, lg->regs->esp);
+		ss = lg->regs->ss;
+	}
+
+	/* Remember that we never let the Guest actually disable interrupts, so
+	 * the "Interrupt Flag" bit is always set.  We copy that bit from the
+	 * Guest's "irq_enabled" field into the eflags word: the Guest copies
+	 * it back in "lguest_iret". */
+	eflags = lg->regs->eflags;
+	if (get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
+	    && !(irq_enable & X86_EFLAGS_IF))
+		eflags &= ~X86_EFLAGS_IF;
+
+	/* An interrupt is expected to push three things on the stack: the old
+	 * "eflags" word, the old code segment, and the old instruction
+	 * pointer. */
+	push_guest_stack(lg, &gstack, eflags);
+	push_guest_stack(lg, &gstack, lg->regs->cs);
+	push_guest_stack(lg, &gstack, lg->regs->eip);
+
+	/* For the six traps which supply an error code, we push that, too. */
+	if (has_err)
+		push_guest_stack(lg, &gstack, lg->regs->errcode);
+
+	/* Now we've pushed all the old state, we change the stack, the code
+	 * segment and the address to execute. */
+	lg->regs->ss = ss;
+	lg->regs->esp = gstack + lg->page_offset;
+	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
+	lg->regs->eip = idt_address(lo, hi);
+
+	/* There are two kinds of interrupt handlers: 0xE is an "interrupt
+	 * gate" which expects interrupts to be disabled on entry. */
+	if (idt_type(lo, hi) == 0xE)
+		if (put_user(0, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Disabling interrupts");
+}
+
+/*H:200
+ * Virtual Interrupts.
+ *
+ * maybe_do_interrupt() gets called before every entry to the Guest, to see if
+ * we should divert the Guest to running an interrupt handler. */
+void maybe_do_interrupt(struct lguest *lg)
+{
+	unsigned int irq;
+	DECLARE_BITMAP(blk, LGUEST_IRQS);
+	struct desc_struct *idt;
+
+	/* If the Guest hasn't even initialized yet, we can do nothing. */
+	if (!lg->lguest_data)
+		return;
+
+	/* Take our "irqs_pending" array and remove any interrupts the Guest
+	 * wants blocked: the result ends up in "blk". */
+	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
+			   sizeof(blk)))
+		return;
+
+	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
+
+	/* Find the first interrupt. */
+	irq = find_first_bit(blk, LGUEST_IRQS);
+	/* None?  Nothing to do */
+	if (irq >= LGUEST_IRQS)
+		return;
+
+	/* They may be in the middle of an iret, where they asked us never to
+	 * deliver interrupts. */
+	if (lg->regs->eip >= lg->noirq_start && lg->regs->eip < lg->noirq_end)
+		return;
+
+	/* If they're halted, interrupts restart them. */
+	if (lg->halted) {
+		/* Re-enable interrupts. */
+		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Re-enabling interrupts");
+		lg->halted = 0;
+	} else {
+		/* Otherwise we check if they have interrupts disabled. */
+		u32 irq_enabled;
+		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
+			irq_enabled = 0;
+		if (!irq_enabled)
+			return;
+	}
+
+	/* Look at the IDT entry the Guest gave us for this interrupt.  The
+	 * first 32 (FIRST_EXTERNAL_VECTOR) entries are for traps, so we skip
+	 * over them. */
+	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
+	/* If they don't have a handler (yet?), we just ignore it */
+	if (idt_present(idt->a, idt->b)) {
+		/* OK, mark it no longer pending and deliver it. */
+		clear_bit(irq, lg->irqs_pending);
+		/* set_guest_interrupt() takes the interrupt descriptor and a
+		 * flag to say whether this interrupt pushes an error code onto
+		 * the stack as well: virtual interrupts never do. */
+		set_guest_interrupt(lg, idt->a, idt->b, 0);
+	}
+
+	/* Every time we deliver an interrupt, we update the timestamp in the
+	 * Guest's lguest_data struct.  It would be better for the Guest if we
+	 * did this more often, but it can actually be quite slow: doing it
+	 * here is a compromise which means at least it gets updated every
+	 * timer interrupt. */
+	write_timestamp(lg);
+}
+
+/*H:220 Now we've got the routines to deliver interrupts, delivering traps
+ * like page fault is easy.  The only trick is that Intel decided that some
+ * traps should have error codes: */
+static int has_err(unsigned int trap)
+{
+	return (trap == 8 || (trap >= 10 && trap <= 14) || trap == 17);
+}
+
+/* deliver_trap() returns true if it could deliver the trap. */
+int deliver_trap(struct lguest *lg, unsigned int num)
+{
+	u32 lo = lg->idt[num].a, hi = lg->idt[num].b;
+
+	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
+	 * bogus one in): if we fail here, the Guest will be killed. */
+	if (!idt_present(lo, hi))
+		return 0;
+	set_guest_interrupt(lg, lo, hi, has_err(num));
+	return 1;
+}
+
+/*H:250 Here's the hard part: returning to the Host every time a trap happens
+ * and then calling deliver_trap() and re-entering the Guest is slow.
+ * Particularly because Guest userspace system calls are traps (trap 128).
+ *
+ * So we'd like to set up the IDT to tell the CPU to deliver traps directly
+ * into the Guest.  This is possible, but the complexities cause the size of
+ * this file to double!  However, 150 lines of code is worth writing for taking
+ * system calls down from 1750ns to 270ns.  Plus, if lguest didn't do it, all
+ * the other hypervisors would tease it.
+ *
+ * This routine determines if a trap can be delivered directly. */
+static int direct_trap(const struct lguest *lg,
+		       const struct desc_struct *trap,
+		       unsigned int num)
+{
+	/* Hardware interrupts don't go to the Guest at all (except system
+	 * call). */
+	if (num >= FIRST_EXTERNAL_VECTOR && num != SYSCALL_VECTOR)
+		return 0;
+
+	/* The Host needs to see page faults (for shadow paging and to save the
+	 * fault address), general protection faults (in/out emulation) and
+	 * device not available (TS handling), and of course, the hypercall
+	 * trap. */
+	if (num == 14 || num == 13 || num == 7 || num == LGUEST_TRAP_ENTRY)
+		return 0;
+
+	/* Only trap gates (type 15) can go direct to the Guest.  Interrupt
+	 * gates (type 14) disable interrupts as they are entered, which we
+	 * never let the Guest do.  Not present entries (type 0x0) also can't
+	 * go direct, of course 8) */
+	return idt_type(trap->a, trap->b) == 0xF;
+}
+/*:*/
+
+/*M:005 The Guest has the ability to turn its interrupt gates into trap gates,
+ * if it is careful.  The Host will let trap gates can go directly to the
+ * Guest, but the Guest needs the interrupts atomically disabled for an
+ * interrupt gate.  It can do this by pointing the trap gate at instructions
+ * within noirq_start and noirq_end, where it can safely disable interrupts. */
+
+/*M:006 The Guests do not use the sysenter (fast system call) instruction,
+ * because it's hardcoded to enter privilege level 0 and so can't go direct.
+ * It's about twice as fast as the older "int 0x80" system call, so it might
+ * still be worthwhile to handle it in the Switcher and lcall down to the
+ * Guest.  The sysenter semantics are hairy tho: search for that keyword in
+ * entry.S :*/
+
+/*H:260 When we make traps go directly into the Guest, we need to make sure
+ * the kernel stack is valid (ie. mapped in the page tables).  Otherwise, the
+ * CPU trying to deliver the trap will fault while trying to push the interrupt
+ * words on the stack: this is called a double fault, and it forces us to kill
+ * the Guest.
+ *
+ * Which is deeply unfair, because (literally!) it wasn't the Guests' fault. */
+void pin_stack_pages(struct lguest *lg)
+{
+	unsigned int i;
+
+	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
+	 * two pages of stack space. */
+	for (i = 0; i < lg->stack_pages; i++)
+		/* The stack grows *upwards*, hence the subtraction */
+		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
+}
+
+/* Direct traps also mean that we need to know whenever the Guest wants to use
+ * a different kernel stack, so we can change the IDT entries to use that
+ * stack.  The IDT entries expect a virtual address, so unlike most addresses
+ * the Guest gives us, the "esp" (stack pointer) value here is virtual, not
+ * physical.
+ *
+ * In Linux each process has its own kernel stack, so this happens a lot: we
+ * change stacks on each context switch. */
+void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
+{
+	/* You are not allowd have a stack segment with privilege level 0: bad
+	 * Guest! */
+	if ((seg & 0x3) != GUEST_PL)
+		kill_guest(lg, "bad stack segment %i", seg);
+	/* We only expect one or two stack pages. */
+	if (pages > 2)
+		kill_guest(lg, "bad stack pages %u", pages);
+	/* Save where the stack is, and how many pages */
+	lg->ss1 = seg;
+	lg->esp1 = esp;
+	lg->stack_pages = pages;
+	/* Make sure the new stack pages are mapped */
+	pin_stack_pages(lg);
+}
+
+/* All this reference to mapping stacks leads us neatly into the other complex
+ * part of the Host: page table handling. */
+
+/*H:235 This is the routine which actually checks the Guest's IDT entry and
+ * transfers it into our entry in "struct lguest": */
+static void set_trap(struct lguest *lg, struct desc_struct *trap,
+		     unsigned int num, u32 lo, u32 hi)
+{
+	u8 type = idt_type(lo, hi);
+
+	/* We zero-out a not-present entry */
+	if (!idt_present(lo, hi)) {
+		trap->a = trap->b = 0;
+		return;
+	}
+
+	/* We only support interrupt and trap gates. */
+	if (type != 0xE && type != 0xF)
+		kill_guest(lg, "bad IDT type %i", type);
+
+	/* We only copy the handler address, present bit, privilege level and
+	 * type.  The privilege level controls where the trap can be triggered
+	 * manually with an "int" instruction.  This is usually GUEST_PL,
+	 * except for system calls which userspace can use. */
+	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
+	trap->b = (hi&0xFFFFEF00);
+}
+
+/*H:230 While we're here, dealing with delivering traps and interrupts to the
+ * Guest, we might as well complete the picture: how the Guest tells us where
+ * it wants them to go.  This would be simple, except making traps fast
+ * requires some tricks.
+ *
+ * We saw the Guest setting Interrupt Descriptor Table (IDT) entries with the
+ * LHCALL_LOAD_IDT_ENTRY hypercall before: that comes here. */
+void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
+{
+	/* Guest never handles: NMI, doublefault, spurious interrupt or
+	 * hypercall.  We ignore when it tries to set them. */
+	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
+		return;
+
+	/* Mark the IDT as changed: next time the Guest runs we'll know we have
+	 * to copy this again. */
+	lg->changed |= CHANGED_IDT;
+
+	/* The IDT which we keep in "struct lguest" only contains 32 entries
+	 * for the traps and LGUEST_IRQS (32) entries for interrupts.  We
+	 * ignore attempts to set handlers for higher interrupt numbers, except
+	 * for the system call "interrupt" at 128: we have a special IDT entry
+	 * for that. */
+	if (num < ARRAY_SIZE(lg->idt))
+		set_trap(lg, &lg->idt[num], num, lo, hi);
+	else if (num == SYSCALL_VECTOR)
+		set_trap(lg, &lg->syscall_idt, num, lo, hi);
+}
+
+/* The default entry for each interrupt points into the Switcher routines which
+ * simply return to the Host.  The run_guest() loop will then call
+ * deliver_trap() to bounce it back into the Guest. */
+static void default_idt_entry(struct desc_struct *idt,
+			      int trap,
+			      const unsigned long handler)
+{
+	/* A present interrupt gate. */
+	u32 flags = 0x8e00;
+
+	/* Set the privilege level on the entry for the hypercall: this allows
+	 * the Guest to use the "int" instruction to trigger it. */
+	if (trap == LGUEST_TRAP_ENTRY)
+		flags |= (GUEST_PL << 13);
+
+	/* Now pack it into the IDT entry in its weird format. */
+	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
+	idt->b = (handler&0xFFFF0000) | flags;
+}
+
+/* When the Guest first starts, we put default entries into the IDT. */
+void setup_default_idt_entries(struct lguest_ro_state *state,
+			       const unsigned long *def)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->guest_idt); i++)
+		default_idt_entry(&state->guest_idt[i], i, def[i]);
+}
+
+/*H:240 We don't use the IDT entries in the "struct lguest" directly, instead
+ * we copy them into the IDT which we've set up for Guests on this CPU, just
+ * before we run the Guest.  This routine does that copy. */
+void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+		const unsigned long *def)
+{
+	unsigned int i;
+
+	/* We can simply copy the direct traps, otherwise we use the default
+	 * ones in the Switcher: they will return to the Host. */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
+		if (direct_trap(lg, &lg->idt[i], i))
+			idt[i] = lg->idt[i];
+		else
+			default_idt_entry(&idt[i], i, def[i]);
+	}
+
+	/* Don't forget the system call trap!  The IDT entries for other
+	 * interupts never change, so no need to copy them. */
+	i = SYSCALL_VECTOR;
+	if (direct_trap(lg, &lg->syscall_idt, i))
+		idt[i] = lg->syscall_idt;
+	else
+		default_idt_entry(&idt[i], i, def[i]);
+}
+
+void guest_set_clockevent(struct lguest *lg, unsigned long delta)
+{
+	ktime_t expires;
+
+	if (unlikely(delta == 0)) {
+		/* Clock event device is shutting down. */
+		hrtimer_cancel(&lg->hrt);
+		return;
+	}
+
+	expires = ktime_add_ns(ktime_get_real(), delta);
+	hrtimer_start(&lg->hrt, expires, HRTIMER_MODE_ABS);
+}
+
+static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
+{
+	struct lguest *lg = container_of(timer, struct lguest, hrt);
+
+	set_bit(0, lg->irqs_pending);
+	if (lg->halted)
+		wake_up_process(lg->tsk);
+	return HRTIMER_NORESTART;
+}
+
+void init_clockdev(struct lguest *lg)
+{
+	hrtimer_init(&lg->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	lg->hrt.function = clockdev_fn;
+}
diff --git a/drivers/lguest/i386/lguest.c b/drivers/lguest/i386/lguest.c
new file mode 100644
index 0000000..1bc1546
--- /dev/null
+++ b/drivers/lguest/i386/lguest.c
@@ -0,0 +1,1097 @@
+/*P:010
+ * A hypervisor allows multiple Operating Systems to run on a single machine.
+ * To quote David Wheeler: "Any problem in computer science can be solved with
+ * another layer of indirection."
+ *
+ * We keep things simple in two ways.  First, we start with a normal Linux
+ * kernel and insert a module (lg.ko) which allows us to run other Linux
+ * kernels the same way we'd run processes.  We call the first kernel the Host,
+ * and the others the Guests.  The program which sets up and configures Guests
+ * (such as the example in Documentation/lguest/lguest.c) is called the
+ * Launcher.
+ *
+ * Secondly, we only run specially modified Guests, not normal kernels.  When
+ * you set CONFIG_LGUEST to 'y' or 'm', this automatically sets
+ * CONFIG_LGUEST_GUEST=y, which compiles this file into the kernel so it knows
+ * how to be a Guest.  This means that you can use the same kernel you boot
+ * normally (ie. as a Host) as a Guest.
+ *
+ * These Guests know that they cannot do privileged operations, such as disable
+ * interrupts, and that they have to ask the Host to do such things explicitly.
+ * This file consists of all the replacements for such low-level native
+ * hardware operations: these special Guest versions call the Host.
+ *
+ * So how does the kernel know it's a Guest?  The Guest starts at a special
+ * entry point marked with a magic string, which sets up a few things then
+ * calls here.  We replace the native functions in "struct paravirt_ops"
+ * with our Guest versions, then boot like normal. :*/
+
+/*
+ * Copyright (C) 2006, Rusty Russell <rusty@rustcorp.com.au> IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/start_kernel.h>
+#include <linux/string.h>
+#include <linux/console.h>
+#include <linux/screen_info.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/lguest.h>
+#include <linux/lguest_launcher.h>
+#include <linux/lguest_bus.h>
+#include <asm/paravirt.h>
+#include <asm/param.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/desc.h>
+#include <asm/setup.h>
+#include <asm/e820.h>
+#include <asm/mce.h>
+#include <asm/io.h>
+
+/*G:010 Welcome to the Guest!
+ *
+ * The Guest in our tale is a simple creature: identical to the Host but
+ * behaving in simplified but equivalent ways.  In particular, the Guest is the
+ * same kernel as the Host (or at least, built from the same source code). :*/
+
+/* Declarations for definitions in lguest_guest.S */
+extern char lguest_noirq_start[], lguest_noirq_end[];
+extern const char lgstart_cli[], lgend_cli[];
+extern const char lgstart_sti[], lgend_sti[];
+extern const char lgstart_popf[], lgend_popf[];
+extern const char lgstart_pushf[], lgend_pushf[];
+extern const char lgstart_iret[], lgend_iret[];
+extern void lguest_iret(void);
+
+struct lguest_data lguest_data = {
+	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
+	.noirq_start = (u32)lguest_noirq_start,
+	.noirq_end = (u32)lguest_noirq_end,
+	.blocked_interrupts = { 1 }, /* Block timer interrupts */
+};
+struct lguest_device_desc *lguest_devices;
+static cycle_t clock_base;
+
+/*G:035 Notice the lazy_hcall() above, rather than hcall().  This is our first
+ * real optimization trick!
+ *
+ * When lazy_mode is set, it means we're allowed to defer all hypercalls and do
+ * them as a batch when lazy_mode is eventually turned off.  Because hypercalls
+ * are reasonably expensive, batching them up makes sense.  For example, a
+ * large mmap might update dozens of page table entries: that code calls
+ * lguest_lazy_mode(PARAVIRT_LAZY_MMU), does the dozen updates, then calls
+ * lguest_lazy_mode(PARAVIRT_LAZY_NONE).
+ *
+ * So, when we're in lazy mode, we call async_hypercall() to store the call for
+ * future processing.  When lazy mode is turned off we issue a hypercall to
+ * flush the stored calls.
+ *
+ * There's also a hack where "mode" is set to "PARAVIRT_LAZY_FLUSH" which
+ * indicates we're to flush any outstanding calls immediately.  This is used
+ * when an interrupt handler does a kmap_atomic(): the page table changes must
+ * happen immediately even if we're in the middle of a batch.  Usually we're
+ * not, though, so there's nothing to do. */
+static enum paravirt_lazy_mode lazy_mode; /* Note: not SMP-safe! */
+static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
+{
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	} else {
+		lazy_mode = mode;
+		if (mode == PARAVIRT_LAZY_NONE)
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	}
+}
+
+static void lazy_hcall(unsigned long call,
+		       unsigned long arg1,
+		       unsigned long arg2,
+		       unsigned long arg3)
+{
+	if (lazy_mode == PARAVIRT_LAZY_NONE)
+		hcall(call, arg1, arg2, arg3);
+	else
+		async_hcall(call, arg1, arg2, arg3);
+}
+
+/* async_hcall() is pretty simple: I'm quite proud of it really.  We have a
+ * ring buffer of stored hypercalls which the Host will run though next time we
+ * do a normal hypercall.  Each entry in the ring has 4 slots for the hypercall
+ * arguments, and a "hcall_status" word which is 0 if the call is ready to go,
+ * and 255 once the Host has finished with it.
+ *
+ * If we come around to a slot which hasn't been finished, then the table is
+ * full and we just make the hypercall directly.  This has the nice side
+ * effect of causing the Host to run all the stored calls in the ring buffer
+ * which empties it for next time! */
+void async_hcall(unsigned long call,
+		 unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	/* Note: This code assumes we're uniprocessor. */
+	static unsigned int next_call;
+	unsigned long flags;
+
+	/* Disable interrupts if not already disabled: we don't want an
+	 * interrupt handler making a hypercall while we're already doing
+	 * one! */
+	local_irq_save(flags);
+	if (lguest_data.hcall_status[next_call] != 0xFF) {
+		/* Table full, so do normal hcall which will flush table. */
+		hcall(call, arg1, arg2, arg3);
+	} else {
+		lguest_data.hcalls[next_call].eax = call;
+		lguest_data.hcalls[next_call].edx = arg1;
+		lguest_data.hcalls[next_call].ebx = arg2;
+		lguest_data.hcalls[next_call].ecx = arg3;
+		/* Arguments must all be written before we mark it to go */
+		wmb();
+		lguest_data.hcall_status[next_call] = 0;
+		if (++next_call == LHCALL_RING_SIZE)
+			next_call = 0;
+	}
+	local_irq_restore(flags);
+}
+/*:*/
+
+/* Wrappers for the SEND_DMA and BIND_DMA hypercalls.  This is mainly because
+ * Jeff Garzik complained that __pa() should never appear in drivers, and this
+ * helps remove most of them.   But also, it wraps some ugliness. */
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
+{
+	/* The hcall might not write this if something goes wrong */
+	dma->used_len = 0;
+	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
+}
+
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq)
+{
+	/* This is the only hypercall which actually wants 5 arguments, and we
+	 * only support 4.  Fortunately the interrupt number is always less
+	 * than 256, so we can pack it with the number of dmas in the final
+	 * argument.  */
+	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
+		return -ENOMEM;
+	return 0;
+}
+
+/* Unbinding is the same hypercall as binding, but with 0 num & irq. */
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
+{
+	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
+}
+
+/* For guests, device memory can be used as normal memory, so we cast away the
+ * __iomem to quieten sparse. */
+void *lguest_map(unsigned long phys_addr, unsigned long pages)
+{
+	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
+}
+
+void lguest_unmap(void *addr)
+{
+	iounmap((__force void __iomem *)addr);
+}
+
+/*G:033
+ * Here are our first native-instruction replacements: four functions for
+ * interrupt control.
+ *
+ * The simplest way of implementing these would be to have "turn interrupts
+ * off" and "turn interrupts on" hypercalls.  Unfortunately, this is too slow:
+ * these are by far the most commonly called functions of those we override.
+ *
+ * So instead we keep an "irq_enabled" field inside our "struct lguest_data",
+ * which the Guest can update with a single instruction.  The Host knows to
+ * check there when it wants to deliver an interrupt.
+ */
+
+/* save_flags() is expected to return the processor state (ie. "eflags").  The
+ * eflags word contains all kind of stuff, but in practice Linux only cares
+ * about the interrupt flag.  Our "save_flags()" just returns that. */
+static unsigned long save_fl(void)
+{
+	return lguest_data.irq_enabled;
+}
+
+/* "restore_flags" just sets the flags back to the value given. */
+static void restore_fl(unsigned long flags)
+{
+	lguest_data.irq_enabled = flags;
+}
+
+/* Interrupts go off... */
+static void irq_disable(void)
+{
+	lguest_data.irq_enabled = 0;
+}
+
+/* Interrupts go on... */
+static void irq_enable(void)
+{
+	lguest_data.irq_enabled = X86_EFLAGS_IF;
+}
+/*:*/
+/*M:003 Note that we don't check for outstanding interrupts when we re-enable
+ * them (or when we unmask an interrupt).  This seems to work for the moment,
+ * since interrupts are rare and we'll just get the interrupt on the next timer
+ * tick, but when we turn on CONFIG_NO_HZ, we should revisit this.  One way
+ * would be to put the "irq_enabled" field in a page by itself, and have the
+ * Host write-protect it when an interrupt comes in when irqs are disabled.
+ * There will then be a page fault as soon as interrupts are re-enabled. :*/
+
+/*G:034
+ * The Interrupt Descriptor Table (IDT).
+ *
+ * The IDT tells the processor what to do when an interrupt comes in.  Each
+ * entry in the table is a 64-bit descriptor: this holds the privilege level,
+ * address of the handler, and... well, who cares?  The Guest just asks the
+ * Host to make the change anyway, because the Host controls the real IDT.
+ */
+static void lguest_write_idt_entry(struct desc_struct *dt,
+				   int entrynum, u32 low, u32 high)
+{
+	/* Keep the local copy up to date. */
+	write_dt_entry(dt, entrynum, low, high);
+	/* Tell Host about this new entry. */
+	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
+}
+
+/* Changing to a different IDT is very rare: we keep the IDT up-to-date every
+ * time it is written, so we can simply loop through all entries and tell the
+ * Host about them. */
+static void lguest_load_idt(const struct Xgt_desc_struct *desc)
+{
+	unsigned int i;
+	struct desc_struct *idt = (void *)desc->address;
+
+	for (i = 0; i < (desc->size+1)/8; i++)
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+}
+
+/*
+ * The Global Descriptor Table.
+ *
+ * The Intel architecture defines another table, called the Global Descriptor
+ * Table (GDT).  You tell the CPU where it is (and its size) using the "lgdt"
+ * instruction, and then several other instructions refer to entries in the
+ * table.  There are three entries which the Switcher needs, so the Host simply
+ * controls the entire thing and the Guest asks it to make changes using the
+ * LOAD_GDT hypercall.
+ *
+ * This is the opposite of the IDT code where we have a LOAD_IDT_ENTRY
+ * hypercall and use that repeatedly to load a new IDT.  I don't think it
+ * really matters, but wouldn't it be nice if they were the same?
+ */
+static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
+{
+	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
+	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
+}
+
+/* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
+ * then tell the Host to reload the entire thing.  This operation is so rare
+ * that this naive implementation is reasonable. */
+static void lguest_write_gdt_entry(struct desc_struct *dt,
+				   int entrynum, u32 low, u32 high)
+{
+	write_dt_entry(dt, entrynum, low, high);
+	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
+}
+
+/* OK, I lied.  There are three "thread local storage" GDT entries which change
+ * on every context switch (these three entries are how glibc implements
+ * __thread variables).  So we have a hypercall specifically for this case. */
+static void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
+}
+/*:*/
+
+/*G:038 That's enough excitement for now, back to ploughing through each of
+ * the paravirt_ops (we're about 1/3 of the way through).
+ *
+ * This is the Local Descriptor Table, another weird Intel thingy.  Linux only
+ * uses this for some strange applications like Wine.  We don't do anything
+ * here, so they'll get an informative and friendly Segmentation Fault. */
+static void lguest_set_ldt(const void *addr, unsigned entries)
+{
+}
+
+/* This loads a GDT entry into the "Task Register": that entry points to a
+ * structure called the Task State Segment.  Some comments scattered though the
+ * kernel code indicate that this used for task switching in ages past, along
+ * with blood sacrifice and astrology.
+ *
+ * Now there's nothing interesting in here that we don't get told elsewhere.
+ * But the native version uses the "ltr" instruction, which makes the Host
+ * complain to the Guest about a Segmentation Fault and it'll oops.  So we
+ * override the native version with a do-nothing version. */
+static void lguest_load_tr_desc(void)
+{
+}
+
+/* The "cpuid" instruction is a way of querying both the CPU identity
+ * (manufacturer, model, etc) and its features.  It was introduced before the
+ * Pentium in 1993 and keeps getting extended by both Intel and AMD.  As you
+ * might imagine, after a decade and a half this treatment, it is now a giant
+ * ball of hair.  Its entry in the current Intel manual runs to 28 pages.
+ *
+ * This instruction even it has its own Wikipedia entry.  The Wikipedia entry
+ * has been translated into 4 languages.  I am not making this up!
+ *
+ * We could get funky here and identify ourselves as "GenuineLguest", but
+ * instead we just use the real "cpuid" instruction.  Then I pretty much turned
+ * off feature bits until the Guest booted.  (Don't say that: you'll damage
+ * lguest sales!)  Shut up, inner voice!  (Hey, just pointing out that this is
+ * hardly future proof.)  Noone's listening!  They don't like you anyway,
+ * parenthetic weirdo!
+ *
+ * Replacing the cpuid so we can turn features off is great for the kernel, but
+ * anyone (including userspace) can just use the raw "cpuid" instruction and
+ * the Host won't even notice since it isn't privileged.  So we try not to get
+ * too worked up about it. */
+static void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
+{
+	int function = *eax;
+
+	native_cpuid(eax, ebx, ecx, edx);
+	switch (function) {
+	case 1:	/* Basic feature request. */
+		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
+		*ecx &= 0x00002201;
+		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
+		*edx &= 0x07808101;
+		/* The Host can do a nice optimization if it knows that the
+		 * kernel mappings (addresses above 0xC0000000 or whatever
+		 * PAGE_OFFSET is set to) haven't changed.  But Linux calls
+		 * flush_tlb_user() for both user and kernel mappings unless
+		 * the Page Global Enable (PGE) feature bit is set. */
+		*edx |= 0x00002000;
+		break;
+	case 0x80000000:
+		/* Futureproof this a little: if they ask how much extended
+		 * processor information there is, limit it to known fields. */
+		if (*eax > 0x80000008)
+			*eax = 0x80000008;
+		break;
+	}
+}
+
+/* Intel has four control registers, imaginatively named cr0, cr2, cr3 and cr4.
+ * I assume there's a cr1, but it hasn't bothered us yet, so we'll not bother
+ * it.  The Host needs to know when the Guest wants to change them, so we have
+ * a whole series of functions like read_cr0() and write_cr0().
+ *
+ * We start with CR0.  CR0 allows you to turn on and off all kinds of basic
+ * features, but Linux only really cares about one: the horrifically-named Task
+ * Switched (TS) bit at bit 3 (ie. 8)
+ *
+ * What does the TS bit do?  Well, it causes the CPU to trap (interrupt 7) if
+ * the floating point unit is used.  Which allows us to restore FPU state
+ * lazily after a task switch, and Linux uses that gratefully, but wouldn't a
+ * name like "FPUTRAP bit" be a little less cryptic?
+ *
+ * We store cr0 (and cr3) locally, because the Host never changes it.  The
+ * Guest sometimes wants to read it and we'd prefer not to bother the Host
+ * unnecessarily. */
+static unsigned long current_cr0, current_cr3;
+static void lguest_write_cr0(unsigned long val)
+{
+	/* 8 == TS bit. */
+	lazy_hcall(LHCALL_TS, val & 8, 0, 0);
+	current_cr0 = val;
+}
+
+static unsigned long lguest_read_cr0(void)
+{
+	return current_cr0;
+}
+
+/* Intel provided a special instruction to clear the TS bit for people too cool
+ * to use write_cr0() to do it.  This "clts" instruction is faster, because all
+ * the vowels have been optimized out. */
+static void lguest_clts(void)
+{
+	lazy_hcall(LHCALL_TS, 0, 0, 0);
+	current_cr0 &= ~8U;
+}
+
+/* CR2 is the virtual address of the last page fault, which the Guest only ever
+ * reads.  The Host kindly writes this into our "struct lguest_data", so we
+ * just read it out of there. */
+static unsigned long lguest_read_cr2(void)
+{
+	return lguest_data.cr2;
+}
+
+/* CR3 is the current toplevel pagetable page: the principle is the same as
+ * cr0.  Keep a local copy, and tell the Host when it changes. */
+static void lguest_write_cr3(unsigned long cr3)
+{
+	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
+	current_cr3 = cr3;
+}
+
+static unsigned long lguest_read_cr3(void)
+{
+	return current_cr3;
+}
+
+/* CR4 is used to enable and disable PGE, but we don't care. */
+static unsigned long lguest_read_cr4(void)
+{
+	return 0;
+}
+
+static void lguest_write_cr4(unsigned long val)
+{
+}
+
+/*
+ * Page Table Handling.
+ *
+ * Now would be a good time to take a rest and grab a coffee or similarly
+ * relaxing stimulant.  The easy parts are behind us, and the trek gradually
+ * winds uphill from here.
+ *
+ * Quick refresher: memory is divided into "pages" of 4096 bytes each.  The CPU
+ * maps virtual addresses to physical addresses using "page tables".  We could
+ * use one huge index of 1 million entries: each address is 4 bytes, so that's
+ * 1024 pages just to hold the page tables.   But since most virtual addresses
+ * are unused, we use a two level index which saves space.  The CR3 register
+ * contains the physical address of the top level "page directory" page, which
+ * contains physical addresses of up to 1024 second-level pages.  Each of these
+ * second level pages contains up to 1024 physical addresses of actual pages,
+ * or Page Table Entries (PTEs).
+ *
+ * Here's a diagram, where arrows indicate physical addresses:
+ *
+ * CR3 ---> +---------+
+ *	    |  	   --------->+---------+
+ *	    |	      |	     | PADDR1  |
+ *	  Top-level   |	     | PADDR2  |
+ *	  (PMD) page  |	     | 	       |
+ *	    |	      |	   Lower-level |
+ *	    |	      |	   (PTE) page  |
+ *	    |	      |	     |	       |
+ *	      ....    	     	 ....
+ *
+ * So to convert a virtual address to a physical address, we look up the top
+ * level, which points us to the second level, which gives us the physical
+ * address of that page.  If the top level entry was not present, or the second
+ * level entry was not present, then the virtual address is invalid (we
+ * say "the page was not mapped").
+ *
+ * Put another way, a 32-bit virtual address is divided up like so:
+ *
+ *  1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
+ * |<---- 10 bits ---->|<---- 10 bits ---->|<------ 12 bits ------>|
+ *    Index into top     Index into second      Offset within page
+ *  page directory page    pagetable page
+ *
+ * The kernel spends a lot of time changing both the top-level page directory
+ * and lower-level pagetable pages.  The Guest doesn't know physical addresses,
+ * so while it maintains these page tables exactly like normal, it also needs
+ * to keep the Host informed whenever it makes a change: the Host will create
+ * the real page tables based on the Guests'.
+ */
+
+/* The Guest calls this to set a second-level entry (pte), ie. to map a page
+ * into a process' address space.  We set the entry then tell the Host the
+ * toplevel and address this corresponds to.  The Guest uses one pagetable per
+ * process, so we need to tell the Host which one we're changing (mm->pgd). */
+static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
+}
+
+/* The Guest calls this to set a top-level entry.  Again, we set the entry then
+ * tell the Host which top-level page we changed, and the index of the entry we
+ * changed. */
+static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	*pmdp = pmdval;
+	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
+		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+}
+
+/* There are a couple of legacy places where the kernel sets a PTE, but we
+ * don't know the top level any more.  This is useless for us, since we don't
+ * know which pagetable is changing or what address, so we just tell the Host
+ * to forget all of them.  Fortunately, this is very rare.
+ *
+ * ... except in early boot when the kernel sets up the initial pagetables,
+ * which makes booting astonishingly slow.  So we don't even tell the Host
+ * anything changed until we've done the first page table switch.
+ */
+static void lguest_set_pte(pte_t *ptep, pte_t pteval)
+{
+	*ptep = pteval;
+	/* Don't bother with hypercall before initial setup. */
+	if (current_cr3)
+		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+}
+
+/* Unfortunately for Lguest, the paravirt_ops for page tables were based on
+ * native page table operations.  On native hardware you can set a new page
+ * table entry whenever you want, but if you want to remove one you have to do
+ * a TLB flush (a TLB is a little cache of page table entries kept by the CPU).
+ *
+ * So the lguest_set_pte_at() and lguest_set_pmd() functions above are only
+ * called when a valid entry is written, not when it's removed (ie. marked not
+ * present).  Instead, this is where we come when the Guest wants to remove a
+ * page table entry: we tell the Host to set that entry to 0 (ie. the present
+ * bit is zero). */
+static void lguest_flush_tlb_single(unsigned long addr)
+{
+	/* Simply set it to zero: if it was not, it will fault back in. */
+	lazy_hcall(LHCALL_SET_PTE, current_cr3, addr, 0);
+}
+
+/* This is what happens after the Guest has removed a large number of entries.
+ * This tells the Host that any of the page table entries for userspace might
+ * have changed, ie. virtual addresses below PAGE_OFFSET. */
+static void lguest_flush_tlb_user(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 0, 0, 0);
+}
+
+/* This is called when the kernel page tables have changed.  That's not very
+ * common (unless the Guest is using highmem, which makes the Guest extremely
+ * slow), so it's worth separating this from the user flushing above. */
+static void lguest_flush_tlb_kernel(void)
+{
+	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+}
+
+/*
+ * The Unadvanced Programmable Interrupt Controller.
+ *
+ * This is an attempt to implement the simplest possible interrupt controller.
+ * I spent some time looking though routines like set_irq_chip_and_handler,
+ * set_irq_chip_and_handler_name, set_irq_chip_data and set_phasers_to_stun and
+ * I *think* this is as simple as it gets.
+ *
+ * We can tell the Host what interrupts we want blocked ready for using the
+ * lguest_data.interrupts bitmap, so disabling (aka "masking") them is as
+ * simple as setting a bit.  We don't actually "ack" interrupts as such, we
+ * just mask and unmask them.  I wonder if we should be cleverer?
+ */
+static void disable_lguest_irq(unsigned int irq)
+{
+	set_bit(irq, lguest_data.blocked_interrupts);
+}
+
+static void enable_lguest_irq(unsigned int irq)
+{
+	clear_bit(irq, lguest_data.blocked_interrupts);
+}
+
+/* This structure describes the lguest IRQ controller. */
+static struct irq_chip lguest_irq_controller = {
+	.name		= "lguest",
+	.mask		= disable_lguest_irq,
+	.mask_ack	= disable_lguest_irq,
+	.unmask		= enable_lguest_irq,
+};
+
+/* This sets up the Interrupt Descriptor Table (IDT) entry for each hardware
+ * interrupt (except 128, which is used for system calls), and then tells the
+ * Linux infrastructure that each interrupt is controlled by our level-based
+ * lguest interrupt controller. */
+static void __init lguest_init_IRQ(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_IRQS; i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != SYSCALL_VECTOR) {
+			set_intr_gate(vector, interrupt[i]);
+			set_irq_chip_and_handler(i, &lguest_irq_controller,
+						 handle_level_irq);
+		}
+	}
+	/* This call is required to set up for 4k stacks, where we have
+	 * separate stacks for hard and soft interrupts. */
+	irq_ctx_init(smp_processor_id());
+}
+
+/*
+ * Time.
+ *
+ * It would be far better for everyone if the Guest had its own clock, but
+ * until then the Host gives us the time on every interrupt.
+ */
+static unsigned long lguest_get_wallclock(void)
+{
+	return lguest_data.time.tv_sec;
+}
+
+static cycle_t lguest_clock_read(void)
+{
+	unsigned long sec, nsec;
+
+	/* If the Host tells the TSC speed, we can trust that. */
+	if (lguest_data.tsc_khz)
+		return native_read_tsc();
+
+	/* If we can't use the TSC, we read the time value written by the Host.
+	 * Since it's in two parts (seconds and nanoseconds), we risk reading
+	 * it just as it's changing from 99 & 0.999999999 to 100 and 0, and
+	 * getting 99 and 0.  As Linux tends to come apart under the stress of
+	 * time travel, we must be careful: */
+	do {
+		/* First we read the seconds part. */
+		sec = lguest_data.time.tv_sec;
+		/* This read memory barrier tells the compiler and the CPU that
+		 * this can't be reordered: we have to complete the above
+		 * before going on. */
+		rmb();
+		/* Now we read the nanoseconds part. */
+		nsec = lguest_data.time.tv_nsec;
+		/* Make sure we've done that. */
+		rmb();
+		/* Now if the seconds part has changed, try again. */
+	} while (unlikely(lguest_data.time.tv_sec != sec));
+
+	/* Our non-TSC clock is in real nanoseconds. */
+	return sec*1000000000ULL + nsec;
+}
+
+/* This is what we tell the kernel is our clocksource.  */
+static struct clocksource lguest_clock = {
+	.name		= "lguest",
+	.rating		= 400,
+	.read		= lguest_clock_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 1,
+};
+
+/* The "scheduler clock" is just our real clock, adjusted to start at zero */
+static unsigned long long lguest_sched_clock(void)
+{
+	return cyc2ns(&lguest_clock, lguest_clock_read() - clock_base);
+}
+
+/* We also need a "struct clock_event_device": Linux asks us to set it to go
+ * off some time in the future.  Actually, James Morris figured all this out, I
+ * just applied the patch. */
+static int lguest_clockevent_set_next_event(unsigned long delta,
+                                           struct clock_event_device *evt)
+{
+	if (delta < LG_CLOCK_MIN_DELTA) {
+		if (printk_ratelimit())
+			printk(KERN_DEBUG "%s: small delta %lu ns\n",
+			       __FUNCTION__, delta);
+		return -ETIME;
+	}
+	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
+	return 0;
+}
+
+static void lguest_clockevent_set_mode(enum clock_event_mode mode,
+                                      struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* A 0 argument shuts the clock down. */
+		hcall(LHCALL_SET_CLOCKEVENT, 0, 0, 0);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* This is what we expect. */
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		BUG();
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
+}
+
+/* This describes our primitive timer chip. */
+static struct clock_event_device lguest_clockevent = {
+	.name                   = "lguest",
+	.features               = CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event         = lguest_clockevent_set_next_event,
+	.set_mode               = lguest_clockevent_set_mode,
+	.rating                 = INT_MAX,
+	.mult                   = 1,
+	.shift                  = 0,
+	.min_delta_ns           = LG_CLOCK_MIN_DELTA,
+	.max_delta_ns           = LG_CLOCK_MAX_DELTA,
+};
+
+/* This is the Guest timer interrupt handler (hardware interrupt 0).  We just
+ * call the clockevent infrastructure and it does whatever needs doing. */
+static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long flags;
+
+	/* Don't interrupt us while this is running. */
+	local_irq_save(flags);
+	lguest_clockevent.event_handler(&lguest_clockevent);
+	local_irq_restore(flags);
+}
+
+/* At some point in the boot process, we get asked to set up our timing
+ * infrastructure.  The kernel doesn't expect timer interrupts before this, but
+ * we cleverly initialized the "blocked_interrupts" field of "struct
+ * lguest_data" so that timer interrupts were blocked until now. */
+static void lguest_time_init(void)
+{
+	/* Set up the timer interrupt (0) to go to our simple timer routine */
+	set_irq_handler(0, lguest_time_irq);
+
+	/* Our clock structure look like arch/i386/kernel/tsc.c if we can use
+	 * the TSC, otherwise it's a dumb nanosecond-resolution clock.  Either
+	 * way, the "rating" is initialized so high that it's always chosen
+	 * over any other clocksource. */
+	if (lguest_data.tsc_khz) {
+		lguest_clock.shift = 22;
+		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
+							 lguest_clock.shift);
+		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
+	}
+	clock_base = lguest_clock_read();
+	clocksource_register(&lguest_clock);
+
+	/* Now we've set up our clock, we can use it as the scheduler clock */
+	paravirt_ops.sched_clock = lguest_sched_clock;
+
+	/* We can't set cpumask in the initializer: damn C limitations!  Set it
+	 * here and register our timer device. */
+	lguest_clockevent.cpumask = cpumask_of_cpu(0);
+	clockevents_register_device(&lguest_clockevent);
+
+	/* Finally, we unblock the timer interrupt. */
+	enable_lguest_irq(0);
+}
+
+/*
+ * Miscellaneous bits and pieces.
+ *
+ * Here is an oddball collection of functions which the Guest needs for things
+ * to work.  They're pretty simple.
+ */
+
+/* The Guest needs to tell the host what stack it expects traps to use.  For
+ * native hardware, this is part of the Task State Segment mentioned above in
+ * lguest_load_tr_desc(), but to help hypervisors there's this special call.
+ *
+ * We tell the Host the segment we want to use (__KERNEL_DS is the kernel data
+ * segment), the privilege level (we're privilege level 1, the Host is 0 and
+ * will not tolerate us trying to use that), the stack pointer, and the number
+ * of pages in the stack. */
+static void lguest_load_esp0(struct tss_struct *tss,
+				     struct thread_struct *thread)
+{
+	lazy_hcall(LHCALL_SET_STACK, __KERNEL_DS|0x1, thread->esp0,
+		   THREAD_SIZE/PAGE_SIZE);
+}
+
+/* Let's just say, I wouldn't do debugging under a Guest. */
+static void lguest_set_debugreg(int regno, unsigned long value)
+{
+	/* FIXME: Implement */
+}
+
+/* There are times when the kernel wants to make sure that no memory writes are
+ * caught in the cache (that they've all reached real hardware devices).  This
+ * doesn't matter for the Guest which has virtual hardware.
+ *
+ * On the Pentium 4 and above, cpuid() indicates that the Cache Line Flush
+ * (clflush) instruction is available and the kernel uses that.  Otherwise, it
+ * uses the older "Write Back and Invalidate Cache" (wbinvd) instruction.
+ * Unlike clflush, wbinvd can only be run at privilege level 0.  So we can
+ * ignore clflush, but replace wbinvd.
+ */
+static void lguest_wbinvd(void)
+{
+}
+
+/* If the Guest expects to have an Advanced Programmable Interrupt Controller,
+ * we play dumb by ignoring writes and returning 0 for reads.  So it's no
+ * longer Programmable nor Controlling anything, and I don't think 8 lines of
+ * code qualifies for Advanced.  It will also never interrupt anything.  It
+ * does, however, allow us to get through the Linux boot code. */
+#ifdef CONFIG_X86_LOCAL_APIC
+static void lguest_apic_write(unsigned long reg, unsigned long v)
+{
+}
+
+static unsigned long lguest_apic_read(unsigned long reg)
+{
+	return 0;
+}
+#endif
+
+/* STOP!  Until an interrupt comes in. */
+static void lguest_safe_halt(void)
+{
+	hcall(LHCALL_HALT, 0, 0, 0);
+}
+
+/* Perhaps CRASH isn't the best name for this hypercall, but we use it to get a
+ * message out when we're crashing as well as elegant termination like powering
+ * off.
+ *
+ * Note that the Host always prefers that the Guest speak in physical addresses
+ * rather than virtual addresses, so we use __pa() here. */
+static void lguest_power_off(void)
+{
+	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
+}
+
+/*
+ * Panicing.
+ *
+ * Don't.  But if you did, this is what happens.
+ */
+static int lguest_panic(struct notifier_block *nb, unsigned long l, void *p)
+{
+	hcall(LHCALL_CRASH, __pa(p), 0, 0);
+	/* The hcall won't return, but to keep gcc happy, we're "done". */
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block paniced = {
+	.notifier_call = lguest_panic
+};
+
+/* Setting up memory is fairly easy. */
+static __init char *lguest_memory_setup(void)
+{
+	/* We do this here and not earlier because lockcheck barfs if we do it
+	 * before start_kernel() */
+	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+
+	/* The Linux bootloader header contains an "e820" memory map: the
+	 * Launcher populated the first entry with our memory limit. */
+	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
+
+	/* This string is for the boot messages. */
+	return "LGUEST";
+}
+
+/*G:050
+ * Patching (Powerfully Placating Performance Pedants)
+ *
+ * We have already seen that "struct paravirt_ops" lets us replace simple
+ * native instructions with calls to the appropriate back end all throughout
+ * the kernel.  This allows the same kernel to run as a Guest and as a native
+ * kernel, but it's slow because of all the indirect branches.
+ *
+ * Remember that David Wheeler quote about "Any problem in computer science can
+ * be solved with another layer of indirection"?  The rest of that quote is
+ * "... But that usually will create another problem."  This is the first of
+ * those problems.
+ *
+ * Our current solution is to allow the paravirt back end to optionally patch
+ * over the indirect calls to replace them with something more efficient.  We
+ * patch the four most commonly called functions: disable interrupts, enable
+ * interrupts, restore interrupts and save interrupts.  We usually have 10
+ * bytes to patch into: the Guest versions of these operations are small enough
+ * that we can fit comfortably.
+ *
+ * First we need assembly templates of each of the patchable Guest operations,
+ * and these are in lguest_asm.S. */
+
+/*G:060 We construct a table from the assembler templates: */
+static const struct lguest_insns
+{
+	const char *start, *end;
+} lguest_insns[] = {
+	[PARAVIRT_PATCH(irq_disable)] = { lgstart_cli, lgend_cli },
+	[PARAVIRT_PATCH(irq_enable)] = { lgstart_sti, lgend_sti },
+	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
+	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
+};
+
+/* Now our patch routine is fairly simple (based on the native one in
+ * paravirt.c).  If we have a replacement, we copy it in and return how much of
+ * the available space we used. */
+static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
+{
+	unsigned int insn_len;
+
+	/* Don't do anything special if we don't have a replacement */
+	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
+		return paravirt_patch_default(type, clobber, insns, len);
+
+	insn_len = lguest_insns[type].end - lguest_insns[type].start;
+
+	/* Similarly if we can't fit replacement (shouldn't happen, but let's
+	 * be thorough). */
+	if (len < insn_len)
+		return paravirt_patch_default(type, clobber, insns, len);
+
+	/* Copy in our instructions. */
+	memcpy(insns, lguest_insns[type].start, insn_len);
+	return insn_len;
+}
+
+/*G:030 Once we get to lguest_init(), we know we're a Guest.  The paravirt_ops
+ * structure in the kernel provides a single point for (almost) every routine
+ * we have to override to avoid privileged instructions. */
+__init void lguest_init(void *boot)
+{
+	/* Copy boot parameters first: the Launcher put the physical location
+	 * in %esi, and head.S converted that to a virtual address and handed
+	 * it to us. */
+	memcpy(&boot_params, boot, PARAM_SIZE);
+	/* The boot parameters also tell us where the command-line is: save
+	 * that, too. */
+	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
+	       COMMAND_LINE_SIZE);
+
+	/* We're under lguest, paravirt is enabled, and we're running at
+	 * privilege level 1, not 0 as normal. */
+	paravirt_ops.name = "lguest";
+	paravirt_ops.paravirt_enabled = 1;
+	paravirt_ops.kernel_rpl = 1;
+
+	/* We set up all the lguest overrides for sensitive operations.  These
+	 * are detailed with the operations themselves. */
+	paravirt_ops.save_fl = save_fl;
+	paravirt_ops.restore_fl = restore_fl;
+	paravirt_ops.irq_disable = irq_disable;
+	paravirt_ops.irq_enable = irq_enable;
+	paravirt_ops.load_gdt = lguest_load_gdt;
+	paravirt_ops.memory_setup = lguest_memory_setup;
+	paravirt_ops.cpuid = lguest_cpuid;
+	paravirt_ops.write_cr3 = lguest_write_cr3;
+	paravirt_ops.flush_tlb_user = lguest_flush_tlb_user;
+	paravirt_ops.flush_tlb_single = lguest_flush_tlb_single;
+	paravirt_ops.flush_tlb_kernel = lguest_flush_tlb_kernel;
+	paravirt_ops.set_pte = lguest_set_pte;
+	paravirt_ops.set_pte_at = lguest_set_pte_at;
+	paravirt_ops.set_pmd = lguest_set_pmd;
+#ifdef CONFIG_X86_LOCAL_APIC
+	paravirt_ops.apic_write = lguest_apic_write;
+	paravirt_ops.apic_write_atomic = lguest_apic_write;
+	paravirt_ops.apic_read = lguest_apic_read;
+#endif
+	paravirt_ops.load_idt = lguest_load_idt;
+	paravirt_ops.iret = lguest_iret;
+	paravirt_ops.load_esp0 = lguest_load_esp0;
+	paravirt_ops.load_tr_desc = lguest_load_tr_desc;
+	paravirt_ops.set_ldt = lguest_set_ldt;
+	paravirt_ops.load_tls = lguest_load_tls;
+	paravirt_ops.set_debugreg = lguest_set_debugreg;
+	paravirt_ops.clts = lguest_clts;
+	paravirt_ops.read_cr0 = lguest_read_cr0;
+	paravirt_ops.write_cr0 = lguest_write_cr0;
+	paravirt_ops.init_IRQ = lguest_init_IRQ;
+	paravirt_ops.read_cr2 = lguest_read_cr2;
+	paravirt_ops.read_cr3 = lguest_read_cr3;
+	paravirt_ops.read_cr4 = lguest_read_cr4;
+	paravirt_ops.write_cr4 = lguest_write_cr4;
+	paravirt_ops.write_gdt_entry = lguest_write_gdt_entry;
+	paravirt_ops.write_idt_entry = lguest_write_idt_entry;
+	paravirt_ops.patch = lguest_patch;
+	paravirt_ops.safe_halt = lguest_safe_halt;
+	paravirt_ops.get_wallclock = lguest_get_wallclock;
+	paravirt_ops.time_init = lguest_time_init;
+	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
+	paravirt_ops.wbinvd = lguest_wbinvd;
+	/* Now is a good time to look at the implementations of these functions
+	 * before returning to the rest of lguest_init(). */
+
+	/*G:070 Now we've seen all the paravirt_ops, we return to
+	 * lguest_init() where the rest of the fairly chaotic boot setup
+	 * occurs.
+	 *
+	 * The Host expects our first hypercall to tell it where our "struct
+	 * lguest_data" is, so we do that first. */
+	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
+
+	/* The native boot code sets up initial page tables immediately after
+	 * the kernel itself, and sets init_pg_tables_end so they're not
+	 * clobbered.  The Launcher places our initial pagetables somewhere at
+	 * the top of our physical memory, so we don't need extra space: set
+	 * init_pg_tables_end to the end of the kernel. */
+	init_pg_tables_end = __pa(pg0);
+
+	/* Load the %fs segment register (the per-cpu segment register) with
+	 * the normal data segment to get through booting. */
+	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
+
+	/* Clear the part of the kernel data which is expected to be zero.
+	 * Normally it will be anyway, but if we're loading from a bzImage with
+	 * CONFIG_RELOCATALE=y, the relocations will be sitting here. */
+	memset(__bss_start, 0, __bss_stop - __bss_start);
+
+	/* The Host uses the top of the Guest's virtual address space for the
+	 * Host<->Guest Switcher, and it tells us how much it needs in
+	 * lguest_data.reserve_mem, set up on the LGUEST_INIT hypercall. */
+	reserve_top_address(lguest_data.reserve_mem);
+
+	/* If we don't initialize the lock dependency checker now, it crashes
+	 * paravirt_disable_iospace. */
+	lockdep_init();
+
+	/* The IDE code spends about 3 seconds probing for disks: if we reserve
+	 * all the I/O ports up front it can't get them and so doesn't probe.
+	 * Other device drivers are similar (but less severe).  This cuts the
+	 * kernel boot time on my machine from 4.1 seconds to 0.45 seconds. */
+	paravirt_disable_iospace();
+
+	/* This is messy CPU setup stuff which the native boot code does before
+	 * start_kernel, so we have to do, too: */
+	cpu_detect(&new_cpu_data);
+	/* head.S usually sets up the first capability word, so do it here. */
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+
+	/* Math is always hard! */
+	new_cpu_data.hard_math = 1;
+
+#ifdef CONFIG_X86_MCE
+	mce_disabled = 1;
+#endif
+#ifdef CONFIG_ACPI
+	acpi_disabled = 1;
+	acpi_ht = 0;
+#endif
+
+	/* We set the perferred console to "hvc".  This is the "hypervisor
+	 * virtual console" driver written by the PowerPC people, which we also
+	 * adapted for lguest's use. */
+	add_preferred_console("hvc", 0, NULL);
+
+	/* Last of all, we set the power management poweroff hook to point to
+	 * the Guest routine to power off. */
+	pm_power_off = lguest_power_off;
+
+	/* Now we're set up, call start_kernel() in init/main.c and we proceed
+	 * to boot as normal.  It never returns. */
+	start_kernel();
+}
+/*
+ * This marks the end of stage II of our journey, The Guest.
+ *
+ * It is now time for us to explore the nooks and crannies of the three Guest
+ * devices and complete our understanding of the Guest in "make Drivers".
+ */
diff --git a/drivers/lguest/i386/lguest_asm.S b/drivers/lguest/i386/lguest_asm.S
new file mode 100644
index 0000000..f182c6a
--- /dev/null
+++ b/drivers/lguest/i386/lguest_asm.S
@@ -0,0 +1,93 @@
+#include <linux/linkage.h>
+#include <linux/lguest.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/processor-flags.h>
+
+/*G:020 This is where we begin: we have a magic signature which the launcher
+ * looks for.  The plan is that the Linux boot protocol will be extended with a
+ * "platform type" field which will guide us here from the normal entry point,
+ * but for the moment this suffices.  The normal boot code uses %esi for the
+ * boot header, so we do too.  We convert it to a virtual address by adding
+ * PAGE_OFFSET, and hand it to lguest_init() as its argument (ie. %eax).
+ *
+ * The .section line puts this code in .init.text so it will be discarded after
+ * boot. */
+.section .init.text, "ax", @progbits
+.ascii "GenuineLguest"
+	/* Set up initial stack. */
+ 	movl $(init_thread_union+THREAD_SIZE),%esp
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
+	jmp lguest_init
+
+/*G:055 We create a macro which puts the assembler code between lgstart_ and
+ * lgend_ markers.  These templates end up in the .init.text section, so they
+ * are discarded after boot. */
+#define LGUEST_PATCH(name, insns...)			\
+	lgstart_##name:	insns; lgend_##name:;		\
+	.globl lgstart_##name; .globl lgend_##name
+
+LGUEST_PATCH(cli, movl $0, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(sti, movl $X86_EFLAGS_IF, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(popf, movl %eax, lguest_data+LGUEST_DATA_irq_enabled)
+LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
+/*:*/
+
+.text
+/* These demark the EIP range where host should never deliver interrupts. */
+.global lguest_noirq_start
+.global lguest_noirq_end
+
+/*M:004 When the Host reflects a trap or injects an interrupt into the Guest,
+ * it sets the eflags interrupt bit on the stack based on
+ * lguest_data.irq_enabled, so the Guest iret logic does the right thing when
+ * restoring it.  However, when the Host sets the Guest up for direct traps,
+ * such as system calls, the processor is the one to push eflags onto the
+ * stack, and the interrupt bit will be 1 (in reality, interrupts are always
+ * enabled in the Guest).
+ *
+ * This turns out to be harmless: the only trap which should happen under Linux
+ * with interrupts disabled is Page Fault (due to our lazy mapping of vmalloc
+ * regions), which has to be reflected through the Host anyway.  If another
+ * trap *does* go off when interrupts are disabled, the Guest will panic, and
+ * we'll never get to this iret! :*/
+
+/*G:045 There is one final paravirt_op that the Guest implements, and glancing
+ * at it you can see why I left it to last.  It's *cool*!  It's in *assembler*!
+ *
+ * The "iret" instruction is used to return from an interrupt or trap.  The
+ * stack looks like this:
+ *   old address
+ *   old code segment & privilege level
+ *   old processor flags ("eflags")
+ *
+ * The "iret" instruction pops those values off the stack and restores them all
+ * at once.  The only problem is that eflags includes the Interrupt Flag which
+ * the Guest can't change: the CPU will simply ignore it when we do an "iret".
+ * So we have to copy eflags from the stack to lguest_data.irq_enabled before
+ * we do the "iret".
+ *
+ * There are two problems with this: firstly, we need to use a register to do
+ * the copy and secondly, the whole thing needs to be atomic.  The first
+ * problem is easy to solve: push %eax on the stack so we can use it, and then
+ * restore it at the end just before the real "iret".
+ *
+ * The second is harder: copying eflags to lguest_data.irq_enabled will turn
+ * interrupts on before we're finished, so we could be interrupted before we
+ * return to userspace or wherever.  Our solution to this is to surround the
+ * code with lguest_noirq_start: and lguest_noirq_end: labels.  We tell the
+ * Host that it is *never* to interrupt us there, even if interrupts seem to be
+ * enabled. */
+ENTRY(lguest_iret)
+	pushl	%eax
+	movl	12(%esp), %eax
+lguest_noirq_start:
+	/* Note the %ss: segment prefix here.  Normal data accesses use the
+	 * "ds" segment, but that will have already been restored for whatever
+	 * we're returning to (such as userspace): we can't trust it.  The %ss:
+	 * prefix makes sure we use the stack segment, which is still valid. */
+	movl	%eax,%ss:lguest_data+LGUEST_DATA_irq_enabled
+	popl	%eax
+	iret
+lguest_noirq_end:
diff --git a/drivers/lguest/i386/lguest_user.c b/drivers/lguest/i386/lguest_user.c
new file mode 100644
index 0000000..2f477df
--- /dev/null
+++ b/drivers/lguest/i386/lguest_user.c
@@ -0,0 +1,382 @@
+/*P:200 This contains all the /dev/lguest code, whereby the userspace launcher
+ * controls and communicates with the Guest.  For example, the first write will
+ * tell us the memory size, pagetable, entry point and kernel address offset.
+ * A read will run the Guest until a signal is pending (-EINTR), or the Guest
+ * does a DMA out to the Launcher.  Writes are also used to get a DMA buffer
+ * registered by the Guest and to send the Guest an interrupt. :*/
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/lg.h>
+
+/*L:030 setup_regs() doesn't really belong in this file, but it gives us an
+ * early glimpse deeper into the Host so it's worth having here.
+ *
+ * Most of the Guest's registers are left alone: we used get_zeroed_page() to
+ * allocate the structure, so they will be 0. */
+static void setup_regs(struct lguest_regs *regs, unsigned long start)
+{
+	/* There are four "segment" registers which the Guest needs to boot:
+	 * The "code segment" register (cs) refers to the kernel code segment
+	 * __KERNEL_CS, and the "data", "extra" and "stack" segment registers
+	 * refer to the kernel data segment __KERNEL_DS.
+	 *
+	 * The privilege level is packed into the lower bits.  The Guest runs
+	 * at privilege level 1 (GUEST_PL).*/
+	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
+	regs->cs = __KERNEL_CS|GUEST_PL;
+
+	/* The "eflags" register contains miscellaneous flags.  Bit 1 (0x002)
+	 * is supposed to always be "1".  Bit 9 (0x200) controls whether
+	 * interrupts are enabled.  We always leave interrupts enabled while
+	 * running the Guest. */
+	regs->eflags = 0x202;
+
+	/* The "Extended Instruction Pointer" register says where the Guest is
+	 * running. */
+	regs->eip = start;
+
+	/* %esi points to our boot information, at physical address 0, so don't
+	 * touch it. */
+}
+
+/*L:310 To send DMA into the Guest, the Launcher needs to be able to ask for a
+ * DMA buffer.  This is done by writing LHREQ_GETDMA and the key to
+ * /dev/lguest. */
+static long user_get_dma(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long key, udma, irq;
+
+	/* Fetch the key they wrote to us. */
+	if (get_user(key, input) != 0)
+		return -EFAULT;
+	/* Look for a free Guest DMA buffer bound to that key. */
+	udma = get_dma_buffer(lg, key, &irq);
+	if (!udma)
+		return -ENOENT;
+
+	/* We need to tell the Launcher what interrupt the Guest expects after
+	 * the buffer is filled.  We stash it in udma->used_len. */
+	lgwrite_u32(lg, udma + offsetof(struct lguest_dma, used_len), irq);
+
+	/* The (guest-physical) address of the DMA buffer is returned from
+	 * the write(). */
+	return udma;
+}
+
+/*L:315 To force the Guest to stop running and return to the Launcher, the
+ * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
+ * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
+static int break_guest_out(struct lguest *lg, const u32 __user *input)
+{
+	unsigned long on;
+
+	/* Fetch whether they're turning break on or off.. */
+	if (get_user(on, input) != 0)
+		return -EFAULT;
+
+	if (on) {
+		lg->break_out = 1;
+		/* Pop it out (may be running on different CPU) */
+		wake_up_process(lg->tsk);
+		/* Wait for them to reset it */
+		return wait_event_interruptible(lg->break_wq, !lg->break_out);
+	} else {
+		lg->break_out = 0;
+		wake_up(&lg->break_wq);
+		return 0;
+	}
+}
+
+/*L:050 Sending an interrupt is done by writing LHREQ_IRQ and an interrupt
+ * number to /dev/lguest. */
+static int user_send_irq(struct lguest *lg, const u32 __user *input)
+{
+	u32 irq;
+
+	if (get_user(irq, input) != 0)
+		return -EFAULT;
+	if (irq >= LGUEST_IRQS)
+		return -EINVAL;
+	/* Next time the Guest runs, the core code will see if it can deliver
+	 * this interrupt. */
+	set_bit(irq, lg->irqs_pending);
+	return 0;
+}
+
+/*L:040 Once our Guest is initialized, the Launcher makes it run by reading
+ * from /dev/lguest. */
+static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
+{
+	struct lguest *lg = file->private_data;
+
+	/* You must write LHREQ_INITIALIZE first! */
+	if (!lg)
+		return -EINVAL;
+
+	/* If you're not the task which owns the guest, go away. */
+	if (current != lg->tsk)
+		return -EPERM;
+
+	/* If the guest is already dead, we indicate why */
+	if (lg->dead) {
+		size_t len;
+
+		/* lg->dead either contains an error code, or a string. */
+		if (IS_ERR(lg->dead))
+			return PTR_ERR(lg->dead);
+
+		/* We can only return as much as the buffer they read with. */
+		len = min(size, strlen(lg->dead)+1);
+		if (copy_to_user(user, lg->dead, len) != 0)
+			return -EFAULT;
+		return len;
+	}
+
+	/* If we returned from read() last time because the Guest sent DMA,
+	 * clear the flag. */
+	if (lg->dma_is_pending)
+		lg->dma_is_pending = 0;
+
+	/* Run the Guest until something interesting happens. */
+	return run_guest(lg, (unsigned long __user *)user);
+}
+
+/*L:020 The initialization write supplies 4 32-bit values (in addition to the
+ * 32-bit LHREQ_INITIALIZE value).  These are:
+ *
+ * pfnlimit: The highest (Guest-physical) page number the Guest should be
+ * allowed to access.  The Launcher has to live in Guest memory, so it sets
+ * this to ensure the Guest can't reach it.
+ *
+ * pgdir: The (Guest-physical) address of the top of the initial Guest
+ * pagetables (which are set up by the Launcher).
+ *
+ * start: The first instruction to execute ("eip" in x86-speak).
+ *
+ * page_offset: The PAGE_OFFSET constant in the Guest kernel.  We should
+ * probably wean the code off this, but it's a very useful constant!  Any
+ * address above this is within the Guest kernel, and any kernel address can
+ * quickly converted from physical to virtual by adding PAGE_OFFSET.  It's
+ * 0xC0000000 (3G) by default, but it's configurable at kernel build time.
+ */
+static int initialize(struct file *file, const u32 __user *input)
+{
+	/* "struct lguest" contains everything we (the Host) know about a
+	 * Guest. */
+	struct lguest *lg;
+	int err, i;
+	u32 args[4];
+
+	/* We grab the Big Lguest lock, which protects the global array
+	 * "lguests" and multiple simultaneous initializations. */
+	mutex_lock(&lguest_lock);
+	/* You can't initialize twice!  Close the device and start again... */
+	if (file->private_data) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (copy_from_user(args, input, sizeof(args)) != 0) {
+		err = -EFAULT;
+		goto unlock;
+	}
+
+	/* Find an unused guest. */
+	i = find_free_guest();
+	if (i < 0) {
+		err = -ENOSPC;
+		goto unlock;
+	}
+	/* OK, we have an index into the "lguest" array: "lg" is a convenient
+	 * pointer. */
+	lg = &lguests[i];
+
+	/* Populate the easy fields of our "struct lguest" */
+	lg->guestid = i;
+	lg->pfn_limit = args[0];
+	lg->page_offset = args[3];
+
+	/* We need a complete page for the Guest registers: they are accessible
+	 * to the Guest and we can only grant it access to whole pages. */
+	lg->regs_page = get_zeroed_page(GFP_KERNEL);
+	if (!lg->regs_page) {
+		err = -ENOMEM;
+		goto release_guest;
+	}
+	/* We actually put the registers at the bottom of the page. */
+	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
+
+	/* Initialize the Guest's shadow page tables, using the toplevel
+	 * address the Launcher gave us.  This allocates memory, so can
+	 * fail. */
+	err = init_guest_pagetable(lg, args[1]);
+	if (err)
+		goto free_regs;
+
+	/* Now we initialize the Guest's registers, handing it the start
+	 * address. */
+	setup_regs(lg->regs, args[2]);
+
+	/* There are a couple of GDT entries the Guest expects when first
+	 * booting. */
+	setup_guest_gdt(lg);
+
+	/* The timer for lguest's clock needs initialization. */
+	init_clockdev(lg);
+
+	/* We keep a pointer to the Launcher task (ie. current task) for when
+	 * other Guests want to wake this one (inter-Guest I/O). */
+	lg->tsk = current;
+	/* We need to keep a pointer to the Launcher's memory map, because if
+	 * the Launcher dies we need to clean it up.  If we don't keep a
+	 * reference, it is destroyed before close() is called. */
+	lg->mm = get_task_mm(lg->tsk);
+
+	/* Initialize the queue for the waker to wait on */
+	init_waitqueue_head(&lg->break_wq);
+
+	/* We remember which CPU's pages this Guest used last, for optimization
+	 * when the same Guest runs on the same CPU twice. */
+	lg->last_pages = NULL;
+
+	/* We keep our "struct lguest" in the file's private_data. */
+	file->private_data = lg;
+
+	mutex_unlock(&lguest_lock);
+
+	/* And because this is a write() call, we return the length used. */
+	return sizeof(args);
+
+free_regs:
+	free_page(lg->regs_page);
+release_guest:
+	memset(lg, 0, sizeof(*lg));
+unlock:
+	mutex_unlock(&lguest_lock);
+	return err;
+}
+
+/*L:010 The first operation the Launcher does must be a write.  All writes
+ * start with a 32 bit number: for the first write this must be
+ * LHREQ_INITIALIZE to set up the Guest.  After that the Launcher can use
+ * writes of other values to get DMA buffers and send interrupts. */
+static ssize_t write(struct file *file, const char __user *input,
+		     size_t size, loff_t *off)
+{
+	/* Once the guest is initialized, we hold the "struct lguest" in the
+	 * file private data. */
+	struct lguest *lg = file->private_data;
+	u32 req;
+
+	if (get_user(req, input) != 0)
+		return -EFAULT;
+	input += sizeof(req);
+
+	/* If you haven't initialized, you must do that first. */
+	if (req != LHREQ_INITIALIZE && !lg)
+		return -EINVAL;
+
+	/* Once the Guest is dead, all you can do is read() why it died. */
+	if (lg && lg->dead)
+		return -ENOENT;
+
+	/* If you're not the task which owns the Guest, you can only break */
+	if (lg && current != lg->tsk && req != LHREQ_BREAK)
+		return -EPERM;
+
+	switch (req) {
+	case LHREQ_INITIALIZE:
+		return initialize(file, (const u32 __user *)input);
+	case LHREQ_GETDMA:
+		return user_get_dma(lg, (const u32 __user *)input);
+	case LHREQ_IRQ:
+		return user_send_irq(lg, (const u32 __user *)input);
+	case LHREQ_BREAK:
+		return break_guest_out(lg, (const u32 __user *)input);
+	default:
+		return -EINVAL;
+	}
+}
+
+/*L:060 The final piece of interface code is the close() routine.  It reverses
+ * everything done in initialize().  This is usually called because the
+ * Launcher exited.
+ *
+ * Note that the close routine returns 0 or a negative error number: it can't
+ * really fail, but it can whine.  I blame Sun for this wart, and K&R C for
+ * letting them do it. :*/
+static int close(struct inode *inode, struct file *file)
+{
+	struct lguest *lg = file->private_data;
+
+	/* If we never successfully initialized, there's nothing to clean up */
+	if (!lg)
+		return 0;
+
+	/* We need the big lock, to protect from inter-guest I/O and other
+	 * Launchers initializing guests. */
+	mutex_lock(&lguest_lock);
+	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
+	hrtimer_cancel(&lg->hrt);
+	/* Free any DMA buffers the Guest had bound. */
+	release_all_dma(lg);
+	/* Free up the shadow page tables for the Guest. */
+	free_guest_pagetable(lg);
+	/* Now all the memory cleanups are done, it's safe to release the
+	 * Launcher's memory management structure. */
+	mmput(lg->mm);
+	/* If lg->dead doesn't contain an error code it will be NULL or a
+	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
+	if (!IS_ERR(lg->dead))
+		kfree(lg->dead);
+	/* We can free up the register page we allocated. */
+	free_page(lg->regs_page);
+	/* We clear the entire structure, which also marks it as free for the
+	 * next user. */
+	memset(lg, 0, sizeof(*lg));
+	/* Release lock and exit. */
+	mutex_unlock(&lguest_lock);
+
+	return 0;
+}
+
+/*L:000
+ * Welcome to our journey through the Launcher!
+ *
+ * The Launcher is the Host userspace program which sets up, runs and services
+ * the Guest.  In fact, many comments in the Drivers which refer to "the Host"
+ * doing things are inaccurate: the Launcher does all the device handling for
+ * the Guest.  The Guest can't tell what's done by the the Launcher and what by
+ * the Host.
+ *
+ * Just to confuse you: to the Host kernel, the Launcher *is* the Guest and we
+ * shall see more of that later.
+ *
+ * We begin our understanding with the Host kernel interface which the Launcher
+ * uses: reading and writing a character device called /dev/lguest.  All the
+ * work happens in the read(), write() and close() routines: */
+static struct file_operations lguest_fops = {
+	.owner	 = THIS_MODULE,
+	.release = close,
+	.write	 = write,
+	.read	 = read,
+};
+
+/* This is a textbook example of a "misc" character device.  Populate a "struct
+ * miscdevice" and register it with misc_register(). */
+static struct miscdevice lguest_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "lguest",
+	.fops	= &lguest_fops,
+};
+
+int __init lguest_device_init(void)
+{
+	return misc_register(&lguest_dev);
+}
+
+void __exit lguest_device_remove(void)
+{
+	misc_deregister(&lguest_dev);
+}
diff --git a/drivers/lguest/i386/page_tables.c b/drivers/lguest/i386/page_tables.c
new file mode 100644
index 0000000..812d56a
--- /dev/null
+++ b/drivers/lguest/i386/page_tables.c
@@ -0,0 +1,680 @@
+/*P:700 The pagetable code, on the other hand, still shows the scars of
+ * previous encounters.  It's functional, and as neat as it can be in the
+ * circumstances, but be wary, for these things are subtle and break easily.
+ * The Guest provides a virtual to physical mapping, but we can neither trust
+ * it nor use it: we verify and convert it here to point the hardware to the
+ * actual Guest pages when running the Guest. :*/
+
+/* Copyright (C) Rusty Russell IBM Corporation 2006.
+ * GPL v2 and any later version */
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+#include <linux/percpu.h>
+#include <asm/tlbflush.h>
+#include <linux/lg.h>
+
+/*M:008 We hold reference to pages, which prevents them from being swapped.
+ * It'd be nice to have a callback in the "struct mm_struct" when Linux wants
+ * to swap out.  If we had this, and a shrinker callback to trim PTE pages, we
+ * could probably consider launching Guests as non-root. :*/
+
+/*H:300
+ * The Page Table Code
+ *
+ * We use two-level page tables for the Guest.  If you're not entirely
+ * comfortable with virtual addresses, physical addresses and page tables then
+ * I recommend you review lguest.c's "Page Table Handling" (with diagrams!).
+ *
+ * The Guest keeps page tables, but we maintain the actual ones here: these are
+ * called "shadow" page tables.  Which is a very Guest-centric name: these are
+ * the real page tables the CPU uses, although we keep them up to date to
+ * reflect the Guest's.  (See what I mean about weird naming?  Since when do
+ * shadows reflect anything?)
+ *
+ * Anyway, this is the most complicated part of the Host code.  There are seven
+ * parts to this:
+ *  (i) Setting up a page table entry for the Guest when it faults,
+ *  (ii) Setting up the page table entry for the Guest stack,
+ *  (iii) Setting up a page table entry when the Guest tells us it has changed,
+ *  (iv) Switching page tables,
+ *  (v) Flushing (thowing away) page tables,
+ *  (vi) Mapping the Switcher when the Guest is about to run,
+ *  (vii) Setting up the page tables initially.
+ :*/
+
+/* Pages a 4k long, and each page table entry is 4 bytes long, giving us 1024
+ * (or 2^10) entries per page. */
+#define PTES_PER_PAGE_SHIFT 10
+#define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
+
+/* 1024 entries in a page table page maps 1024 pages: 4MB.  The Switcher is
+ * conveniently placed at the top 4MB, so it uses a separate, complete PTE
+ * page.  */
+#define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
+
+/* We actually need a separate PTE page for each CPU.  Remember that after the
+ * Switcher code itself comes two pages for each CPU, and we don't want this
+ * CPU's guest to see the pages of any other CPU. */
+static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
+#define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
+
+/*H:320 With our shadow and Guest types established, we need to deal with
+ * them: the page table code is curly enough to need helper functions to keep
+ * it clear and clean.
+ *
+ * The first helper takes a virtual address, and says which entry in the top
+ * level page table deals with that address.  Since each top level entry deals
+ * with 4M, this effectively divides by 4M. */
+static unsigned vaddr_to_pgd_index(unsigned long vaddr)
+{
+	return vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+}
+
+/* There are two functions which return pointers to the shadow (aka "real")
+ * page tables.
+ *
+ * spgd_addr() takes the virtual address and returns a pointer to the top-level
+ * page directory entry for that address.  Since we keep track of several page
+ * tables, the "i" argument tells us which one we're interested in (it's
+ * usually the current one). */
+static spgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
+{
+	unsigned int index = vaddr_to_pgd_index(vaddr);
+
+	/* We kill any Guest trying to touch the Switcher addresses. */
+	if (index >= SWITCHER_PGD_INDEX) {
+		kill_guest(lg, "attempt to access switcher pages");
+		index = 0;
+	}
+	/* Return a pointer index'th pgd entry for the i'th page table. */
+	return &lg->pgdirs[i].pgdir[index];
+}
+
+/* This routine then takes the PGD entry given above, which contains the
+ * address of the PTE page.  It then returns a pointer to the PTE entry for the
+ * given address. */
+static spte_t *spte_addr(struct lguest *lg, spgd_t spgd, unsigned long vaddr)
+{
+	spte_t *page = __va(spgd.pfn << PAGE_SHIFT);
+	/* You should never call this if the PGD entry wasn't valid */
+	BUG_ON(!(spgd.flags & _PAGE_PRESENT));
+	return &page[(vaddr >> PAGE_SHIFT) % PTES_PER_PAGE];
+}
+
+/* These two functions just like the above two, except they access the Guest
+ * page tables.  Hence they return a Guest address. */
+static unsigned long gpgd_addr(struct lguest *lg, unsigned long vaddr)
+{
+	unsigned int index = vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
+	return lg->pgdirs[lg->pgdidx].cr3 + index * sizeof(gpgd_t);
+}
+
+static unsigned long gpte_addr(struct lguest *lg,
+			       gpgd_t gpgd, unsigned long vaddr)
+{
+	unsigned long gpage = gpgd.pfn << PAGE_SHIFT;
+	BUG_ON(!(gpgd.flags & _PAGE_PRESENT));
+	return gpage + ((vaddr>>PAGE_SHIFT) % PTES_PER_PAGE) * sizeof(gpte_t);
+}
+
+/*H:350 This routine takes a page number given by the Guest and converts it to
+ * an actual, physical page number.  It can fail for several reasons: the
+ * virtual address might not be mapped by the Launcher, the write flag is set
+ * and the page is read-only, or the write flag was set and the page was
+ * shared so had to be copied, but we ran out of memory.
+ *
+ * This holds a reference to the page, so release_pte() is careful to
+ * put that back. */
+static unsigned long get_pfn(unsigned long virtpfn, int write)
+{
+	struct page *page;
+	/* This value indicates failure. */
+	unsigned long ret = -1UL;
+
+	/* get_user_pages() is a complex interface: it gets the "struct
+	 * vm_area_struct" and "struct page" assocated with a range of pages.
+	 * It also needs the task's mmap_sem held, and is not very quick.
+	 * It returns the number of pages it got. */
+	down_read(&current->mm->mmap_sem);
+	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
+			   1, write, 1, &page, NULL) == 1)
+		ret = page_to_pfn(page);
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+/*H:340 Converting a Guest page table entry to a shadow (ie. real) page table
+ * entry can be a little tricky.  The flags are (almost) the same, but the
+ * Guest PTE contains a virtual page number: the CPU needs the real page
+ * number. */
+static spte_t gpte_to_spte(struct lguest *lg, gpte_t gpte, int write)
+{
+	spte_t spte;
+	unsigned long pfn;
+
+	/* The Guest sets the global flag, because it thinks that it is using
+	 * PGE.  We only told it to use PGE so it would tell us whether it was
+	 * flushing a kernel mapping or a userspace mapping.  We don't actually
+	 * use the global bit, so throw it away. */
+	spte.flags = (gpte.flags & ~_PAGE_GLOBAL);
+
+	/* We need a temporary "unsigned long" variable to hold the answer from
+	 * get_pfn(), because it returns 0xFFFFFFFF on failure, which wouldn't
+	 * fit in spte.pfn.  get_pfn() finds the real physical number of the
+	 * page, given the virtual number. */
+	pfn = get_pfn(gpte.pfn, write);
+	if (pfn == -1UL) {
+		kill_guest(lg, "failed to get page %u", gpte.pfn);
+		/* When we destroy the Guest, we'll go through the shadow page
+		 * tables and release_pte() them.  Make sure we don't think
+		 * this one is valid! */
+		spte.flags = 0;
+	}
+	/* Now we assign the page number, and our shadow PTE is complete. */
+	spte.pfn = pfn;
+	return spte;
+}
+
+/*H:460 And to complete the chain, release_pte() looks like this: */
+static void release_pte(spte_t pte)
+{
+	/* Remember that get_user_pages() took a reference to the page, in
+	 * get_pfn()?  We have to put it back now. */
+	if (pte.flags & _PAGE_PRESENT)
+		put_page(pfn_to_page(pte.pfn));
+}
+/*:*/
+
+static void check_gpte(struct lguest *lg, gpte_t gpte)
+{
+	if ((gpte.flags & (_PAGE_PWT|_PAGE_PSE)) || gpte.pfn >= lg->pfn_limit)
+		kill_guest(lg, "bad page table entry");
+}
+
+static void check_gpgd(struct lguest *lg, gpgd_t gpgd)
+{
+	if ((gpgd.flags & ~_PAGE_TABLE) || gpgd.pfn >= lg->pfn_limit)
+		kill_guest(lg, "bad page directory entry");
+}
+
+/*H:330
+ * (i) Setting up a page table entry for the Guest when it faults
+ *
+ * We saw this call in run_guest(): when we see a page fault in the Guest, we
+ * come here.  That's because we only set up the shadow page tables lazily as
+ * they're needed, so we get page faults all the time and quietly fix them up
+ * and return to the Guest without it knowing.
+ *
+ * If we fixed up the fault (ie. we mapped the address), this routine returns
+ * true. */
+int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
+{
+	gpgd_t gpgd;
+	spgd_t *spgd;
+	unsigned long gpte_ptr;
+	gpte_t gpte;
+	spte_t *spte;
+
+	/* First step: get the top-level Guest page table entry. */
+	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
+	/* Toplevel not present?  We can't map it in. */
+	if (!(gpgd.flags & _PAGE_PRESENT))
+		return 0;
+
+	/* Now look at the matching shadow entry. */
+	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	if (!(spgd->flags & _PAGE_PRESENT)) {
+		/* No shadow entry: allocate a new shadow PTE page. */
+		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
+		/* This is not really the Guest's fault, but killing it is
+		 * simple for this corner case. */
+		if (!ptepage) {
+			kill_guest(lg, "out of memory allocating pte page");
+			return 0;
+		}
+		/* We check that the Guest pgd is OK. */
+		check_gpgd(lg, gpgd);
+		/* And we copy the flags to the shadow PGD entry.  The page
+		 * number in the shadow PGD is the page we just allocated. */
+		spgd->raw.val = (__pa(ptepage) | gpgd.flags);
+	}
+
+	/* OK, now we look at the lower level in the Guest page table: keep its
+	 * address, because we might update it later. */
+	gpte_ptr = gpte_addr(lg, gpgd, vaddr);
+	gpte = mkgpte(lgread_u32(lg, gpte_ptr));
+
+	/* If this page isn't in the Guest page tables, we can't page it in. */
+	if (!(gpte.flags & _PAGE_PRESENT))
+		return 0;
+
+	/* Check they're not trying to write to a page the Guest wants
+	 * read-only (bit 2 of errcode == write). */
+	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
+		return 0;
+
+	/* User access to a kernel page? (bit 3 == user access) */
+	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
+		return 0;
+
+	/* Check that the Guest PTE flags are OK, and the page number is below
+	 * the pfn_limit (ie. not mapping the Launcher binary). */
+	check_gpte(lg, gpte);
+	/* Add the _PAGE_ACCESSED and (for a write) _PAGE_DIRTY flag */
+	gpte.flags |= _PAGE_ACCESSED;
+	if (errcode & 2)
+		gpte.flags |= _PAGE_DIRTY;
+
+	/* Get the pointer to the shadow PTE entry we're going to set. */
+	spte = spte_addr(lg, *spgd, vaddr);
+	/* If there was a valid shadow PTE entry here before, we release it.
+	 * This can happen with a write to a previously read-only entry. */
+	release_pte(*spte);
+
+	/* If this is a write, we insist that the Guest page is writable (the
+	 * final arg to gpte_to_spte()). */
+	if (gpte.flags & _PAGE_DIRTY)
+		*spte = gpte_to_spte(lg, gpte, 1);
+	else {
+		/* If this is a read, don't set the "writable" bit in the page
+		 * table entry, even if the Guest says it's writable.  That way
+		 * we come back here when a write does actually ocur, so we can
+		 * update the Guest's _PAGE_DIRTY flag. */
+		gpte_t ro_gpte = gpte;
+		ro_gpte.flags &= ~_PAGE_RW;
+		*spte = gpte_to_spte(lg, ro_gpte, 0);
+	}
+
+	/* Finally, we write the Guest PTE entry back: we've set the
+	 * _PAGE_ACCESSED and maybe the _PAGE_DIRTY flags. */
+	lgwrite_u32(lg, gpte_ptr, gpte.raw.val);
+
+	/* We succeeded in mapping the page! */
+	return 1;
+}
+
+/*H:360 (ii) Setting up the page table entry for the Guest stack.
+ *
+ * Remember pin_stack_pages() which makes sure the stack is mapped?  It could
+ * simply call demand_page(), but as we've seen that logic is quite long, and
+ * usually the stack pages are already mapped anyway, so it's not required.
+ *
+ * This is a quick version which answers the question: is this virtual address
+ * mapped by the shadow page tables, and is it writable? */
+static int page_writable(struct lguest *lg, unsigned long vaddr)
+{
+	spgd_t *spgd;
+	unsigned long flags;
+
+	/* Look at the top level entry: is it present? */
+	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
+	if (!(spgd->flags & _PAGE_PRESENT))
+		return 0;
+
+	/* Check the flags on the pte entry itself: it must be present and
+	 * writable. */
+	flags = spte_addr(lg, *spgd, vaddr)->flags;
+	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
+}
+
+/* So, when pin_stack_pages() asks us to pin a page, we check if it's already
+ * in the page tables, and if not, we call demand_page() with error code 2
+ * (meaning "write"). */
+void pin_page(struct lguest *lg, unsigned long vaddr)
+{
+	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
+		kill_guest(lg, "bad stack page %#lx", vaddr);
+}
+
+/*H:450 If we chase down the release_pgd() code, it looks like this: */
+static void release_pgd(struct lguest *lg, spgd_t *spgd)
+{
+	/* If the entry's not present, there's nothing to release. */
+	if (spgd->flags & _PAGE_PRESENT) {
+		unsigned int i;
+		/* Converting the pfn to find the actual PTE page is easy: turn
+		 * the page number into a physical address, then convert to a
+		 * virtual address (easy for kernel pages like this one). */
+		spte_t *ptepage = __va(spgd->pfn << PAGE_SHIFT);
+		/* For each entry in the page, we might need to release it. */
+		for (i = 0; i < PTES_PER_PAGE; i++)
+			release_pte(ptepage[i]);
+		/* Now we can free the page of PTEs */
+		free_page((long)ptepage);
+		/* And zero out the PGD entry we we never release it twice. */
+		spgd->raw.val = 0;
+	}
+}
+
+/*H:440 (v) Flushing (thowing away) page tables,
+ *
+ * We saw flush_user_mappings() called when we re-used a top-level pgdir page.
+ * It simply releases every PTE page from 0 up to the kernel address. */
+static void flush_user_mappings(struct lguest *lg, int idx)
+{
+	unsigned int i;
+	/* Release every pgd entry up to the kernel's address. */
+	for (i = 0; i < vaddr_to_pgd_index(lg->page_offset); i++)
+		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
+}
+
+/* The Guest also has a hypercall to do this manually: it's used when a large
+ * number of mappings have been changed. */
+void guest_pagetable_flush_user(struct lguest *lg)
+{
+	/* Drop the userspace part of the current page table. */
+	flush_user_mappings(lg, lg->pgdidx);
+}
+/*:*/
+
+/* We keep several page tables.  This is a simple routine to find the page
+ * table (if any) corresponding to this top-level address the Guest has given
+ * us. */
+static unsigned int find_pgdir(struct lguest *lg, unsigned long pgtable)
+{
+	unsigned int i;
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		if (lg->pgdirs[i].cr3 == pgtable)
+			break;
+	return i;
+}
+
+/*H:435 And this is us, creating the new page directory.  If we really do
+ * allocate a new one (and so the kernel parts are not there), we set
+ * blank_pgdir. */
+static unsigned int new_pgdir(struct lguest *lg,
+			      unsigned long cr3,
+			      int *blank_pgdir)
+{
+	unsigned int next;
+
+	/* We pick one entry at random to throw out.  Choosing the Least
+	 * Recently Used might be better, but this is easy. */
+	next = random32() % ARRAY_SIZE(lg->pgdirs);
+	/* If it's never been allocated at all before, try now. */
+	if (!lg->pgdirs[next].pgdir) {
+		lg->pgdirs[next].pgdir = (spgd_t *)get_zeroed_page(GFP_KERNEL);
+		/* If the allocation fails, just keep using the one we have */
+		if (!lg->pgdirs[next].pgdir)
+			next = lg->pgdidx;
+		else
+			/* This is a blank page, so there are no kernel
+			 * mappings: caller must map the stack! */
+			*blank_pgdir = 1;
+	}
+	/* Record which Guest toplevel this shadows. */
+	lg->pgdirs[next].cr3 = cr3;
+	/* Release all the non-kernel mappings. */
+	flush_user_mappings(lg, next);
+
+	return next;
+}
+
+/*H:430 (iv) Switching page tables
+ *
+ * This is what happens when the Guest changes page tables (ie. changes the
+ * top-level pgdir).  This happens on almost every context switch. */
+void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
+{
+	int newpgdir, repin = 0;
+
+	/* Look to see if we have this one already. */
+	newpgdir = find_pgdir(lg, pgtable);
+	/* If not, we allocate or mug an existing one: if it's a fresh one,
+	 * repin gets set to 1. */
+	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
+		newpgdir = new_pgdir(lg, pgtable, &repin);
+	/* Change the current pgd index to the new one. */
+	lg->pgdidx = newpgdir;
+	/* If it was completely blank, we map in the Guest kernel stack */
+	if (repin)
+		pin_stack_pages(lg);
+}
+
+/*H:470 Finally, a routine which throws away everything: all PGD entries in all
+ * the shadow page tables.  This is used when we destroy the Guest. */
+static void release_all_pagetables(struct lguest *lg)
+{
+	unsigned int i, j;
+
+	/* Every shadow pagetable this Guest has */
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		if (lg->pgdirs[i].pgdir)
+			/* Every PGD entry except the Switcher at the top */
+			for (j = 0; j < SWITCHER_PGD_INDEX; j++)
+				release_pgd(lg, lg->pgdirs[i].pgdir + j);
+}
+
+/* We also throw away everything when a Guest tells us it's changed a kernel
+ * mapping.  Since kernel mappings are in every page table, it's easiest to
+ * throw them all away.  This is amazingly slow, but thankfully rare. */
+void guest_pagetable_clear_all(struct lguest *lg)
+{
+	release_all_pagetables(lg);
+	/* We need the Guest kernel stack mapped again. */
+	pin_stack_pages(lg);
+}
+
+/*H:420 This is the routine which actually sets the page table entry for then
+ * "idx"'th shadow page table.
+ *
+ * Normally, we can just throw out the old entry and replace it with 0: if they
+ * use it demand_page() will put the new entry in.  We need to do this anyway:
+ * The Guest expects _PAGE_ACCESSED to be set on its PTE the first time a page
+ * is read from, and _PAGE_DIRTY when it's written to.
+ *
+ * But Avi Kivity pointed out that most Operating Systems (Linux included) set
+ * these bits on PTEs immediately anyway.  This is done to save the CPU from
+ * having to update them, but it helps us the same way: if they set
+ * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
+ * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
+ */
+static void do_set_pte(struct lguest *lg, int idx,
+		       unsigned long vaddr, gpte_t gpte)
+{
+	/* Look up the matching shadow page directot entry. */
+	spgd_t *spgd = spgd_addr(lg, idx, vaddr);
+
+	/* If the top level isn't present, there's no entry to update. */
+	if (spgd->flags & _PAGE_PRESENT) {
+		/* Otherwise, we start by releasing the existing entry. */
+		spte_t *spte = spte_addr(lg, *spgd, vaddr);
+		release_pte(*spte);
+
+		/* If they're setting this entry as dirty or accessed, we might
+		 * as well put that entry they've given us in now.  This shaves
+		 * 10% off a copy-on-write micro-benchmark. */
+		if (gpte.flags & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
+			check_gpte(lg, gpte);
+			*spte = gpte_to_spte(lg, gpte, gpte.flags&_PAGE_DIRTY);
+		} else
+			/* Otherwise we can demand_page() it in later. */
+			spte->raw.val = 0;
+	}
+}
+
+/*H:410 Updating a PTE entry is a little trickier.
+ *
+ * We keep track of several different page tables (the Guest uses one for each
+ * process, so it makes sense to cache at least a few).  Each of these have
+ * identical kernel parts: ie. every mapping above PAGE_OFFSET is the same for
+ * all processes.  So when the page table above that address changes, we update
+ * all the page tables, not just the current one.  This is rare.
+ *
+ * The benefit is that when we have to track a new page table, we can copy keep
+ * all the kernel mappings.  This speeds up context switch immensely. */
+void guest_set_pte(struct lguest *lg,
+		   unsigned long cr3, unsigned long vaddr, gpte_t gpte)
+{
+	/* Kernel mappings must be changed on all top levels.  Slow, but
+	 * doesn't happen often. */
+	if (vaddr >= lg->page_offset) {
+		unsigned int i;
+		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+			if (lg->pgdirs[i].pgdir)
+				do_set_pte(lg, i, vaddr, gpte);
+	} else {
+		/* Is this page table one we have a shadow for? */
+		int pgdir = find_pgdir(lg, cr3);
+		if (pgdir != ARRAY_SIZE(lg->pgdirs))
+			/* If so, do the update. */
+			do_set_pte(lg, pgdir, vaddr, gpte);
+	}
+}
+
+/*H:400
+ * (iii) Setting up a page table entry when the Guest tells us it has changed.
+ *
+ * Just like we did in interrupts_and_traps.c, it makes sense for us to deal
+ * with the other side of page tables while we're here: what happens when the
+ * Guest asks for a page table to be updated?
+ *
+ * We already saw that demand_page() will fill in the shadow page tables when
+ * needed, so we can simply remove shadow page table entries whenever the Guest
+ * tells us they've changed.  When the Guest tries to use the new entry it will
+ * fault and demand_page() will fix it up.
+ *
+ * So with that in mind here's our code to to update a (top-level) PGD entry:
+ */
+void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 idx)
+{
+	int pgdir;
+
+	/* The kernel seems to try to initialize this early on: we ignore its
+	 * attempts to map over the Switcher. */
+	if (idx >= SWITCHER_PGD_INDEX)
+		return;
+
+	/* If they're talking about a page table we have a shadow for... */
+	pgdir = find_pgdir(lg, cr3);
+	if (pgdir < ARRAY_SIZE(lg->pgdirs))
+		/* ... throw it away. */
+		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
+}
+
+/*H:500 (vii) Setting up the page tables initially.
+ *
+ * When a Guest is first created, the Launcher tells us where the toplevel of
+ * its first page table is.  We set some things up here: */
+int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
+{
+	/* In flush_user_mappings() we loop from 0 to
+	 * "vaddr_to_pgd_index(lg->page_offset)".  This assumes it won't hit
+	 * the Switcher mappings, so check that now. */
+	if (vaddr_to_pgd_index(lg->page_offset) >= SWITCHER_PGD_INDEX)
+		return -EINVAL;
+	/* We start on the first shadow page table, and give it a blank PGD
+	 * page. */
+	lg->pgdidx = 0;
+	lg->pgdirs[lg->pgdidx].cr3 = pgtable;
+	lg->pgdirs[lg->pgdidx].pgdir = (spgd_t*)get_zeroed_page(GFP_KERNEL);
+	if (!lg->pgdirs[lg->pgdidx].pgdir)
+		return -ENOMEM;
+	return 0;
+}
+
+/* When a Guest dies, our cleanup is fairly simple. */
+void free_guest_pagetable(struct lguest *lg)
+{
+	unsigned int i;
+
+	/* Throw away all page table pages. */
+	release_all_pagetables(lg);
+	/* Now free the top levels: free_page() can handle 0 just fine. */
+	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
+		free_page((long)lg->pgdirs[i].pgdir);
+}
+
+/*H:480 (vi) Mapping the Switcher when the Guest is about to run.
+ *
+ * The Switcher and the two pages for this CPU need to be available to the
+ * Guest (and not the pages for other CPUs).  We have the appropriate PTE pages
+ * for each CPU already set up, we just need to hook them in. */
+void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
+{
+	spte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
+	spgd_t switcher_pgd;
+	spte_t regs_pte;
+
+	/* Make the last PGD entry for this Guest point to the Switcher's PTE
+	 * page for this CPU (with appropriate flags). */
+	switcher_pgd.pfn = __pa(switcher_pte_page) >> PAGE_SHIFT;
+	switcher_pgd.flags = _PAGE_KERNEL;
+	lg->pgdirs[lg->pgdidx].pgdir[SWITCHER_PGD_INDEX] = switcher_pgd;
+
+	/* We also change the Switcher PTE page.  When we're running the Guest,
+	 * we want the Guest's "regs" page to appear where the first Switcher
+	 * page for this CPU is.  This is an optimization: when the Switcher
+	 * saves the Guest registers, it saves them into the first page of this
+	 * CPU's "struct lguest_pages": if we make sure the Guest's register
+	 * page is already mapped there, we don't have to copy them out
+	 * again. */
+	regs_pte.pfn = __pa(lg->regs_page) >> PAGE_SHIFT;
+	regs_pte.flags = _PAGE_KERNEL;
+	switcher_pte_page[(unsigned long)pages/PAGE_SIZE%PTES_PER_PAGE]
+		= regs_pte;
+}
+/*:*/
+
+static void free_switcher_pte_pages(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		free_page((long)switcher_pte_page(i));
+}
+
+/*H:520 Setting up the Switcher PTE page for given CPU is fairly easy, given
+ * the CPU number and the "struct page"s for the Switcher code itself.
+ *
+ * Currently the Switcher is less than a page long, so "pages" is always 1. */
+static __init void populate_switcher_pte_page(unsigned int cpu,
+					      struct page *switcher_page[],
+					      unsigned int pages)
+{
+	unsigned int i;
+	spte_t *pte = switcher_pte_page(cpu);
+
+	/* The first entries are easy: they map the Switcher code. */
+	for (i = 0; i < pages; i++) {
+		pte[i].pfn = page_to_pfn(switcher_page[i]);
+		pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
+	}
+
+	/* The only other thing we map is this CPU's pair of pages. */
+	i = pages + cpu*2;
+
+	/* First page (Guest registers) is writable from the Guest */
+	pte[i].pfn = page_to_pfn(switcher_page[i]);
+	pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED|_PAGE_RW;
+	/* The second page contains the "struct lguest_ro_state", and is
+	 * read-only. */
+	pte[i+1].pfn = page_to_pfn(switcher_page[i+1]);
+	pte[i+1].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
+}
+
+/*H:510 At boot or module load time, init_pagetables() allocates and populates
+ * the Switcher PTE page for each CPU. */
+__init int init_pagetables(struct page **switcher_page, unsigned int pages)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+		switcher_pte_page(i) = (spte_t *)get_zeroed_page(GFP_KERNEL);
+		if (!switcher_pte_page(i)) {
+			free_switcher_pte_pages();
+			return -ENOMEM;
+		}
+		populate_switcher_pte_page(i, switcher_page, pages);
+	}
+	return 0;
+}
+/*:*/
+
+/* Cleaning up simply involves freeing the PTE page for each CPU. */
+void free_pagetables(void)
+{
+	free_switcher_pte_pages();
+}
diff --git a/drivers/lguest/i386/segments.c b/drivers/lguest/i386/segments.c
new file mode 100644
index 0000000..351b13f
--- /dev/null
+++ b/drivers/lguest/i386/segments.c
@@ -0,0 +1,229 @@
+/*P:600 The x86 architecture has segments, which involve a table of descriptors
+ * which can be used to do funky things with virtual address interpretation.
+ * We originally used to use segments so the Guest couldn't alter the
+ * Guest<->Host Switcher, and then we had to trim Guest segments, and restore
+ * for userspace per-thread segments, but trim again for on userspace->kernel
+ * transitions...  This nightmarish creation was contained within this file,
+ * where we knew not to tread without heavy armament and a change of underwear.
+ *
+ * In these modern times, the segment handling code consists of simple sanity
+ * checks, and the worst you'll experience reading this code is butterfly-rash
+ * from frolicking through its parklike serenity. :*/
+#include <linux/lg.h>
+
+/*H:600
+ * We've almost completed the Host; there's just one file to go!
+ *
+ * Segments & The Global Descriptor Table
+ *
+ * (That title sounds like a bad Nerdcore group.  Not to suggest that there are
+ * any good Nerdcore groups, but in high school a friend of mine had a band
+ * called Joe Fish and the Chips, so there are definitely worse band names).
+ *
+ * To refresh: the GDT is a table of 8-byte values describing segments.  Once
+ * set up, these segments can be loaded into one of the 6 "segment registers".
+ *
+ * GDT entries are passed around as "struct desc_struct"s, which like IDT
+ * entries are split into two 32-bit members, "a" and "b".  One day, someone
+ * will clean that up, and be declared a Hero.  (No pressure, I'm just saying).
+ *
+ * Anyway, the GDT entry contains a base (the start address of the segment), a
+ * limit (the size of the segment - 1), and some flags.  Sounds simple, and it
+ * would be, except those zany Intel engineers decided that it was too boring
+ * to put the base at one end, the limit at the other, and the flags in
+ * between.  They decided to shotgun the bits at random throughout the 8 bytes,
+ * like so:
+ *
+ * 0               16                     40       48  52  56     63
+ * [ limit part 1 ][     base part 1     ][ flags ][li][fl][base ]
+ *                                                  mit ags part 2
+ *                                                part 2
+ *
+ * As a result, this file contains a certain amount of magic numeracy.  Let's
+ * begin.
+ */
+
+/* Is the descriptor the Guest wants us to put in OK?
+ *
+ * The flag which Intel says must be zero: must be zero.  The descriptor must
+ * be present, (this is actually checked earlier but is here for thorougness),
+ * and the descriptor type must be 1 (a memory segment).  */
+static int desc_ok(const struct desc_struct *gdt)
+{
+	return ((gdt->b & 0x00209000) == 0x00009000);
+}
+
+/* Is the segment present?  (Otherwise it can't be used by the Guest). */
+static int segment_present(const struct desc_struct *gdt)
+{
+	return gdt->b & 0x8000;
+}
+
+/* There are several entries we don't let the Guest set.  The TSS entry is the
+ * "Task State Segment" which controls all kinds of delicate things.  The
+ * LGUEST_CS and LGUEST_DS entries are reserved for the Switcher, and the
+ * the Guest can't be trusted to deal with double faults. */
+static int ignored_gdt(unsigned int num)
+{
+	return (num == GDT_ENTRY_TSS
+		|| num == GDT_ENTRY_LGUEST_CS
+		|| num == GDT_ENTRY_LGUEST_DS
+		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
+}
+
+/* If the Guest asks us to remove an entry from the GDT, we have to be careful.
+ * If one of the segment registers is pointing at that entry the Switcher will
+ * crash when it tries to reload the segment registers for the Guest.
+ *
+ * It doesn't make much sense for the Guest to try to remove its own code, data
+ * or stack segments while they're in use: assume that's a Guest bug.  If it's
+ * one of the lesser segment registers using the removed entry, we simply set
+ * that register to 0 (unusable). */
+static void check_segment_use(struct lguest *lg, unsigned int desc)
+{
+	/* GDT entries are 8 bytes long, so we divide to get the index and
+	 * ignore the bottom bits. */
+	if (lg->regs->gs / 8 == desc)
+		lg->regs->gs = 0;
+	if (lg->regs->fs / 8 == desc)
+		lg->regs->fs = 0;
+	if (lg->regs->es / 8 == desc)
+		lg->regs->es = 0;
+	if (lg->regs->ds / 8 == desc
+	    || lg->regs->cs / 8 == desc
+	    || lg->regs->ss / 8 == desc)
+		kill_guest(lg, "Removed live GDT entry %u", desc);
+}
+/*:*/
+/*M:009 We wouldn't need to check for removal of in-use segments if we handled
+ * faults in the Switcher.  However, it's probably not a worthwhile
+ * optimization. :*/
+
+/*H:610 Once the GDT has been changed, we look through the changed entries and
+ * see if they're OK.  If not, we'll call kill_guest() and the Guest will never
+ * get to use the invalid entries. */
+static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
+{
+	unsigned int i;
+
+	for (i = start; i < end; i++) {
+		/* We never copy these ones to real GDT, so we don't care what
+		 * they say */
+		if (ignored_gdt(i))
+			continue;
+
+		/* We could fault in switch_to_guest if they are using
+		 * a removed segment. */
+		if (!segment_present(&lg->gdt[i])) {
+			check_segment_use(lg, i);
+			continue;
+		}
+
+		if (!desc_ok(&lg->gdt[i]))
+			kill_guest(lg, "Bad GDT descriptor %i", i);
+
+		/* Segment descriptors contain a privilege level: the Guest is
+		 * sometimes careless and leaves this as 0, even though it's
+		 * running at privilege level 1.  If so, we fix it here. */
+		if ((lg->gdt[i].b & 0x00006000) == 0)
+			lg->gdt[i].b |= (GUEST_PL << 13);
+
+		/* Each descriptor has an "accessed" bit.  If we don't set it
+		 * now, the CPU will try to set it when the Guest first loads
+		 * that entry into a segment register.  But the GDT isn't
+		 * writable by the Guest, so bad things can happen. */
+		lg->gdt[i].b |= 0x00000100;
+	}
+}
+
+/* This routine is called at boot or modprobe time for each CPU to set up the
+ * "constant" GDT entries for Guests running on that CPU. */
+void setup_default_gdt_entries(struct lguest_ro_state *state)
+{
+	struct desc_struct *gdt = state->guest_gdt;
+	unsigned long tss = (unsigned long)&state->guest_tss;
+
+	/* The hypervisor segments are full 0-4G segments, privilege level 0 */
+	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
+	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
+
+	/* The TSS segment refers to the TSS entry for this CPU, so we cannot
+	 * copy it from the Guest.  Forgive the magic flags */
+	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
+	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
+		| ((tss >> 16) & 0x000000FF);
+}
+
+/* This routine is called before the Guest is run for the first time. */
+void setup_guest_gdt(struct lguest *lg)
+{
+	/* Start with full 0-4G segments... */
+	lg->gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
+	lg->gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	/* ...except the Guest is allowed to use them, so set the privilege
+	 * level appropriately in the flags. */
+	lg->gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
+	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+}
+
+/* Like the IDT, we never simply use the GDT the Guest gives us.  We set up the
+ * GDTs for each CPU, then we copy across the entries each time we want to run
+ * a different Guest on that CPU. */
+
+/* A partial GDT load, for the three "thead-local storage" entries.  Otherwise
+ * it's just like load_guest_gdt().  So much, in fact, it would probably be
+ * neater to have a single hypercall to cover both. */
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
+		gdt[i] = lg->gdt[i];
+}
+
+/* This is the full version */
+void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	/* The default entries from setup_default_gdt_entries() are not
+	 * replaced.  See ignored_gdt() above. */
+	for (i = 0; i < GDT_ENTRIES; i++)
+		if (!ignored_gdt(i))
+			gdt[i] = lg->gdt[i];
+}
+
+/* This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT). */
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
+{
+	/* We assume the Guest has the same number of GDT entries as the
+	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
+	if (num > ARRAY_SIZE(lg->gdt))
+		kill_guest(lg, "too many gdt entries %i", num);
+
+	/* We read the whole thing in, then fix it up. */
+	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
+	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
+	/* Mark that the GDT changed so the core knows it has to copy it again,
+	 * even if the Guest is run on the same CPU. */
+	lg->changed |= CHANGED_GDT;
+}
+
+void guest_load_tls(struct lguest *lg, unsigned long gtls)
+{
+	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
+
+	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
+	lg->changed |= CHANGED_GDT_TLS;
+}
+
+/*
+ * With this, we have finished the Host.
+ *
+ * Five of the seven parts of our task are complete.  You have made it through
+ * the Bit of Despair (I think that's somewhere in the page table code,
+ * myself).
+ *
+ * Next, we examine "make Switcher".  It's short, but intense.
+ */
diff --git a/drivers/lguest/i386/switcher.S b/drivers/lguest/i386/switcher.S
new file mode 100644
index 0000000..40382f6
--- /dev/null
+++ b/drivers/lguest/i386/switcher.S
@@ -0,0 +1,347 @@
+/*P:900 This is the Switcher: code which sits at 0xFFC00000 to do the low-level
+ * Guest<->Host switch.  It is as simple as it can be made, but it's naturally
+ * very specific to x86.
+ *
+ * You have now completed Preparation.  If this has whet your appetite; if you
+ * are feeling invigorated and refreshed then the next, more challenging stage
+ * can be found in "make Guest". :*/
+
+/*S:100
+ * Welcome to the Switcher itself!
+ *
+ * This file contains the low-level code which changes the CPU to run the Guest
+ * code, and returns to the Host when something happens.  Understand this, and
+ * you understand the heart of our journey.
+ *
+ * Because this is in assembler rather than C, our tale switches from prose to
+ * verse.  First I tried limericks:
+ *
+ *	There once was an eax reg,
+ *	To which our pointer was fed,
+ *	It needed an add,
+ *	Which asm-offsets.h had
+ *	But this limerick is hurting my head.
+ *
+ * Next I tried haikus, but fitting the required reference to the seasons in
+ * every stanza was quickly becoming tiresome:
+ *
+ *	The %eax reg
+ *	Holds "struct lguest_pages" now:
+ *	Cherry blossoms fall.
+ *
+ * Then I started with Heroic Verse, but the rhyming requirement leeched away
+ * the content density and led to some uniquely awful oblique rhymes:
+ *
+ *	These constants are coming from struct offsets
+ *	For use within the asm switcher text.
+ *
+ * Finally, I settled for something between heroic hexameter, and normal prose
+ * with inappropriate linebreaks.  Anyway, it aint no Shakespeare.
+ */
+
+// Not all kernel headers work from assembler
+// But these ones are needed: the ENTRY() define
+// And constants extracted from struct offsets
+// To avoid magic numbers and breakage:
+// Should they change the compiler can't save us
+// Down here in the depths of assembler code.
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/lg.h>
+
+// We mark the start of the code to copy
+// It's placed in .text tho it's never run here
+// You'll see the trick macro at the end
+// Which interleaves data and text to effect.
+.text
+ENTRY(start_switcher_text)
+
+// When we reach switch_to_guest we have just left
+// The safe and comforting shores of C code
+// %eax has the "struct lguest_pages" to use
+// Where we save state and still see it from the Guest
+// And %ebx holds the Guest shadow pagetable:
+// Once set we have truly left Host behind.
+ENTRY(switch_to_guest)
+	// We told gcc all its regs could fade,
+	// Clobbered by our journey into the Guest
+	// We could have saved them, if we tried
+	// But time is our master and cycles count.
+
+	// Segment registers must be saved for the Host
+	// We push them on the Host stack for later
+	pushl	%es
+	pushl	%ds
+	pushl	%gs
+	pushl	%fs
+	// But the compiler is fickle, and heeds
+	// No warning of %ebp clobbers
+	// When frame pointers are used.  That register
+	// Must be saved and restored or chaos strikes.
+	pushl	%ebp
+	// The Host's stack is done, now save it away
+	// In our "struct lguest_pages" at offset
+	// Distilled into asm-offsets.h
+	movl	%esp, LGUEST_PAGES_host_sp(%eax)
+
+	// All saved and there's now five steps before us:
+	// Stack, GDT, IDT, TSS
+	// And last of all the page tables are flipped.
+
+	// Yet beware that our stack pointer must be
+	// Always valid lest an NMI hits
+	// %edx does the duty here as we juggle
+	// %eax is lguest_pages: our stack lies within.
+	movl	%eax, %edx
+	addl	$LGUEST_PAGES_regs, %edx
+	movl	%edx, %esp
+
+	// The Guest's GDT we so carefully
+	// Placed in the "struct lguest_pages" before
+	lgdt	LGUEST_PAGES_guest_gdt_desc(%eax)
+
+	// The Guest's IDT we did partially
+	// Move to the "struct lguest_pages" as well.
+	lidt	LGUEST_PAGES_guest_idt_desc(%eax)
+
+	// The TSS entry which controls traps
+	// Must be loaded up with "ltr" now:
+	// For after we switch over our page tables
+	// It (as the rest) will be writable no more.
+	// (The GDT entry TSS needs
+	// Changes type when we load it: damn Intel!)
+	movl	$(GDT_ENTRY_TSS*8), %edx
+	ltr	%dx
+
+	// Look back now, before we take this last step!
+	// The Host's TSS entry was also marked used;
+	// Let's clear it again, ere we return.
+	// The GDT descriptor of the Host
+	// Points to the table after two "size" bytes
+	movl	(LGUEST_PAGES_host_gdt_desc+2)(%eax), %edx
+	// Clear the type field of "used" (byte 5, bit 2)
+	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%edx)
+
+	// Once our page table's switched, the Guest is live!
+	// The Host fades as we run this final step.
+	// Our "struct lguest_pages" is now read-only.
+	movl	%ebx, %cr3
+
+	// The page table change did one tricky thing:
+	// The Guest's register page has been mapped
+	// Writable onto our %esp (stack) --
+	// We can simply pop off all Guest regs.
+	popl	%ebx
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+	popl	%edi
+	popl	%ebp
+	popl	%gs
+	popl	%eax
+	popl	%fs
+	popl	%ds
+	popl	%es
+
+	// Near the base of the stack lurk two strange fields
+	// Which we fill as we exit the Guest
+	// These are the trap number and its error
+	// We can simply step past them on our way.
+	addl	$8, %esp
+
+	// The last five stack slots hold return address
+	// And everything needed to change privilege
+	// Into the Guest privilege level of 1,
+	// And the stack where the Guest had last left it.
+	// Interrupts are turned back on: we are Guest.
+	iret
+
+// There are two paths where we switch to the Host
+// So we put the routine in a macro.
+// We are on our way home, back to the Host
+// Interrupted out of the Guest, we come here.
+#define SWITCH_TO_HOST							\
+	/* We save the Guest state: all registers first			\
+	 * Laid out just as "struct lguest_regs" defines */		\
+	pushl	%es;							\
+	pushl	%ds;							\
+	pushl	%fs;							\
+	pushl	%eax;							\
+	pushl	%gs;							\
+	pushl	%ebp;							\
+	pushl	%edi;							\
+	pushl	%esi;							\
+	pushl	%edx;							\
+	pushl	%ecx;							\
+	pushl	%ebx;							\
+	/* Our stack and our code are using segments			\
+	 * Set in the TSS and IDT					\
+	 * Yet if we were to touch data we'd use			\
+	 * Whatever data segment the Guest had.				\
+	 * Load the lguest ds segment for now. */			\
+	movl	$(LGUEST_DS), %eax;					\
+	movl	%eax, %ds;						\
+	/* So where are we?  Which CPU, which struct?			\
+	 * The stack is our clue: our TSS sets				\
+	 * It at the end of "struct lguest_pages"			\
+	 * And we then pushed and pushed and pushed Guest regs:		\
+	 * Now stack points atop the "struct lguest_regs".   		\
+	 * Subtract that offset, and we find our struct. */		\
+	movl	%esp, %eax;						\
+	subl	$LGUEST_PAGES_regs, %eax;				\
+	/* Save our trap number: the switch will obscure it		\
+	 * (The Guest regs are not mapped here in the Host)		\
+	 * %ebx holds it safe for deliver_to_host */			\
+	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
+	/* The Host GDT, IDT and stack!					\
+	 * All these lie safely hidden from the Guest:			\
+	 * We must return to the Host page tables			\
+	 * (Hence that was saved in struct lguest_pages) */		\
+	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
+	movl	%edx, %cr3;						\
+	/* As before, when we looked back at the Host			\
+	 * As we left and marked TSS unused				\
+	 * So must we now for the Guest left behind. */			\
+	andb	$0xFD, (LGUEST_PAGES_guest_gdt+GDT_ENTRY_TSS*8+5)(%eax); \
+	/* Switch to Host's GDT, IDT. */				\
+	lgdt	LGUEST_PAGES_host_gdt_desc(%eax);			\
+	lidt	LGUEST_PAGES_host_idt_desc(%eax);			\
+	/* Restore the Host's stack where it's saved regs lie */	\
+	movl	LGUEST_PAGES_host_sp(%eax), %esp;			\
+	/* Last the TSS: our Host is complete */			\
+	movl	$(GDT_ENTRY_TSS*8), %edx;				\
+	ltr	%dx;							\
+	/* Restore now the regs saved right at the first. */		\
+	popl	%ebp;							\
+	popl	%fs;							\
+	popl	%gs;							\
+	popl	%ds;							\
+	popl	%es
+
+// Here's where we come when the Guest has just trapped:
+// (Which trap we'll see has been pushed on the stack).
+// We need only switch back, and the Host will decode
+// Why we came home, and what needs to be done.
+return_to_host:
+	SWITCH_TO_HOST
+	iret
+
+// An interrupt, with some cause external
+// Has ajerked us rudely from the Guest's code
+// Again we must return home to the Host
+deliver_to_host:
+	SWITCH_TO_HOST
+	// But now we must go home via that place
+	// Where that interrupt was supposed to go
+	// Had we not been ensconced, running the Guest.
+	// Here we see the cleverness of our stack:
+	// The Host stack is formed like an interrupt
+	// With EIP, CS and EFLAGS layered.
+	// Interrupt handlers end with "iret"
+	// And that will take us home at long long last.
+
+	// But first we must find the handler to call!
+	// The IDT descriptor for the Host
+	// Has two bytes for size, and four for address:
+	// %edx will hold it for us for now.
+	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
+	// We now know the table address we need,
+	// And saved the trap's number inside %ebx.
+	// Yet the pointer to the handler is smeared
+	// Across the bits of the table entry.
+	// What oracle can tell us how to extract
+	// From such a convoluted encoding?
+	// I consulted gcc, and it gave
+	// These instructions, which I gladly credit:
+	leal	(%edx,%ebx,8), %eax
+	movzwl	(%eax),%edx
+	movl	4(%eax), %eax
+	xorw	%ax, %ax
+	orl	%eax, %edx
+	// Now the address of the handler's in %edx
+	// We call it now: its "iret" takes us home.
+	jmp	*%edx
+
+// Every interrupt can come to us here
+// But we must truly tell each apart.
+// They number two hundred and fifty six
+// And each must land in a different spot,
+// Push its number on stack, and join the stream.
+
+// And worse, a mere six of the traps stand apart
+// And push on their stack an addition:
+// An error number, thirty two bits long
+// So we punish the other two fifty
+// And make them push a zero so they match.
+
+// Yet two fifty six entries is long
+// And all will look most the same as the last
+// So we create a macro which can make
+// As many entries as we need to fill.
+
+// Note the change to .data then .text:
+// We plant the address of each entry
+// Into a (data) table for the Host
+// To know where each Guest interrupt should go.
+.macro IRQ_STUB N TARGET
+	.data; .long 1f; .text; 1:
+ // Trap eight, ten through fourteen and seventeen
+ // Supply an error number.  Else zero.
+ .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
+	pushl	$0
+ .endif
+	pushl	$\N
+	jmp	\TARGET
+	ALIGN
+.endm
+
+// This macro creates numerous entries
+// Using GAS macros which out-power C's.
+.macro IRQ_STUBS FIRST LAST TARGET
+ irq=\FIRST
+ .rept \LAST-\FIRST+1
+	IRQ_STUB irq \TARGET
+  irq=irq+1
+ .endr
+.endm
+
+// Here's the marker for our pointer table
+// Laid in the data section just before
+// Each macro places the address of code
+// Forming an array: each one points to text
+// Which handles interrupt in its turn.
+.data
+.global default_idt_entries
+default_idt_entries:
+.text
+	// The first two traps go straight back to the Host
+	IRQ_STUBS 0 1 return_to_host
+	// We'll say nothing, yet, about NMI
+	IRQ_STUB 2 handle_nmi
+	// Other traps also return to the Host
+	IRQ_STUBS 3 31 return_to_host
+	// All interrupts go via their handlers
+	IRQ_STUBS 32 127 deliver_to_host
+	// 'Cept system calls coming from userspace
+	// Are to go to the Guest, never the Host.
+	IRQ_STUB 128 return_to_host
+	IRQ_STUBS 129 255 deliver_to_host
+
+// The NMI, what a fabulous beast
+// Which swoops in and stops us no matter that
+// We're suspended between heaven and hell,
+// (Or more likely between the Host and Guest)
+// When in it comes!  We are dazed and confused
+// So we do the simplest thing which one can.
+// Though we've pushed the trap number and zero
+// We discard them, return, and hope we live.
+handle_nmi:
+	addl	$8, %esp
+	iret
+
+// We are done; all that's left is Mastery
+// And "make Mastery" is a journey long
+// Designed to make your fingers itch to code.
+
+// Here ends the text, the file and poem.
+ENTRY(end_switcher_text)
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
deleted file mode 100644
index 3daf3e2..0000000
--- a/drivers/lguest/interrupts_and_traps.c
+++ /dev/null
@@ -1,440 +0,0 @@
-/*P:800 Interrupts (traps) are complicated enough to earn their own file.
- * There are three classes of interrupts:
- *
- * 1) Real hardware interrupts which occur while we're running the Guest,
- * 2) Interrupts for virtual devices attached to the Guest, and
- * 3) Traps and faults from the Guest.
- *
- * Real hardware interrupts must be delivered to the Host, not the Guest.
- * Virtual interrupts must be delivered to the Guest, but we make them look
- * just like real hardware would deliver them.  Traps from the Guest can be set
- * up to go directly back into the Guest, but sometimes the Host wants to see
- * them first, so we also have a way of "reflecting" them into the Guest as if
- * they had been delivered to it directly. :*/
-#include <linux/uaccess.h>
-#include <linux/lg.h>
-
-/* The address of the interrupt handler is split into two bits: */
-static unsigned long idt_address(u32 lo, u32 hi)
-{
-	return (lo & 0x0000FFFF) | (hi & 0xFFFF0000);
-}
-
-/* The "type" of the interrupt handler is a 4 bit field: we only support a
- * couple of types. */
-static int idt_type(u32 lo, u32 hi)
-{
-	return (hi >> 8) & 0xF;
-}
-
-/* An IDT entry can't be used unless the "present" bit is set. */
-static int idt_present(u32 lo, u32 hi)
-{
-	return (hi & 0x8000);
-}
-
-/* We need a helper to "push" a value onto the Guest's stack, since that's a
- * big part of what delivering an interrupt does. */
-static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
-{
-	/* Stack grows upwards: move stack then write value. */
-	*gstack -= 4;
-	lgwrite_u32(lg, *gstack, val);
-}
-
-/*H:210 The set_guest_interrupt() routine actually delivers the interrupt or
- * trap.  The mechanics of delivering traps and interrupts to the Guest are the
- * same, except some traps have an "error code" which gets pushed onto the
- * stack as well: the caller tells us if this is one.
- *
- * "lo" and "hi" are the two parts of the Interrupt Descriptor Table for this
- * interrupt or trap.  It's split into two parts for traditional reasons: gcc
- * on i386 used to be frightened by 64 bit numbers.
- *
- * We set up the stack just like the CPU does for a real interrupt, so it's
- * identical for the Guest (and the standard "iret" instruction will undo
- * it). */
-static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
-{
-	unsigned long gstack;
-	u32 eflags, ss, irq_enable;
-
-	/* There are two cases for interrupts: one where the Guest is already
-	 * in the kernel, and a more complex one where the Guest is in
-	 * userspace.  We check the privilege level to find out. */
-	if ((lg->regs->ss&0x3) != GUEST_PL) {
-		/* The Guest told us their kernel stack with the SET_STACK
-		 * hypercall: both the virtual address and the segment */
-		gstack = guest_pa(lg, lg->esp1);
-		ss = lg->ss1;
-		/* We push the old stack segment and pointer onto the new
-		 * stack: when the Guest does an "iret" back from the interrupt
-		 * handler the CPU will notice they're dropping privilege
-		 * levels and expect these here. */
-		push_guest_stack(lg, &gstack, lg->regs->ss);
-		push_guest_stack(lg, &gstack, lg->regs->esp);
-	} else {
-		/* We're staying on the same Guest (kernel) stack. */
-		gstack = guest_pa(lg, lg->regs->esp);
-		ss = lg->regs->ss;
-	}
-
-	/* Remember that we never let the Guest actually disable interrupts, so
-	 * the "Interrupt Flag" bit is always set.  We copy that bit from the
-	 * Guest's "irq_enabled" field into the eflags word: the Guest copies
-	 * it back in "lguest_iret". */
-	eflags = lg->regs->eflags;
-	if (get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
-	    && !(irq_enable & X86_EFLAGS_IF))
-		eflags &= ~X86_EFLAGS_IF;
-
-	/* An interrupt is expected to push three things on the stack: the old
-	 * "eflags" word, the old code segment, and the old instruction
-	 * pointer. */
-	push_guest_stack(lg, &gstack, eflags);
-	push_guest_stack(lg, &gstack, lg->regs->cs);
-	push_guest_stack(lg, &gstack, lg->regs->eip);
-
-	/* For the six traps which supply an error code, we push that, too. */
-	if (has_err)
-		push_guest_stack(lg, &gstack, lg->regs->errcode);
-
-	/* Now we've pushed all the old state, we change the stack, the code
-	 * segment and the address to execute. */
-	lg->regs->ss = ss;
-	lg->regs->esp = gstack + lg->page_offset;
-	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
-	lg->regs->eip = idt_address(lo, hi);
-
-	/* There are two kinds of interrupt handlers: 0xE is an "interrupt
-	 * gate" which expects interrupts to be disabled on entry. */
-	if (idt_type(lo, hi) == 0xE)
-		if (put_user(0, &lg->lguest_data->irq_enabled))
-			kill_guest(lg, "Disabling interrupts");
-}
-
-/*H:200
- * Virtual Interrupts.
- *
- * maybe_do_interrupt() gets called before every entry to the Guest, to see if
- * we should divert the Guest to running an interrupt handler. */
-void maybe_do_interrupt(struct lguest *lg)
-{
-	unsigned int irq;
-	DECLARE_BITMAP(blk, LGUEST_IRQS);
-	struct desc_struct *idt;
-
-	/* If the Guest hasn't even initialized yet, we can do nothing. */
-	if (!lg->lguest_data)
-		return;
-
-	/* Take our "irqs_pending" array and remove any interrupts the Guest
-	 * wants blocked: the result ends up in "blk". */
-	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
-			   sizeof(blk)))
-		return;
-
-	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
-
-	/* Find the first interrupt. */
-	irq = find_first_bit(blk, LGUEST_IRQS);
-	/* None?  Nothing to do */
-	if (irq >= LGUEST_IRQS)
-		return;
-
-	/* They may be in the middle of an iret, where they asked us never to
-	 * deliver interrupts. */
-	if (lg->regs->eip >= lg->noirq_start && lg->regs->eip < lg->noirq_end)
-		return;
-
-	/* If they're halted, interrupts restart them. */
-	if (lg->halted) {
-		/* Re-enable interrupts. */
-		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
-			kill_guest(lg, "Re-enabling interrupts");
-		lg->halted = 0;
-	} else {
-		/* Otherwise we check if they have interrupts disabled. */
-		u32 irq_enabled;
-		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
-			irq_enabled = 0;
-		if (!irq_enabled)
-			return;
-	}
-
-	/* Look at the IDT entry the Guest gave us for this interrupt.  The
-	 * first 32 (FIRST_EXTERNAL_VECTOR) entries are for traps, so we skip
-	 * over them. */
-	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
-	/* If they don't have a handler (yet?), we just ignore it */
-	if (idt_present(idt->a, idt->b)) {
-		/* OK, mark it no longer pending and deliver it. */
-		clear_bit(irq, lg->irqs_pending);
-		/* set_guest_interrupt() takes the interrupt descriptor and a
-		 * flag to say whether this interrupt pushes an error code onto
-		 * the stack as well: virtual interrupts never do. */
-		set_guest_interrupt(lg, idt->a, idt->b, 0);
-	}
-
-	/* Every time we deliver an interrupt, we update the timestamp in the
-	 * Guest's lguest_data struct.  It would be better for the Guest if we
-	 * did this more often, but it can actually be quite slow: doing it
-	 * here is a compromise which means at least it gets updated every
-	 * timer interrupt. */
-	write_timestamp(lg);
-}
-
-/*H:220 Now we've got the routines to deliver interrupts, delivering traps
- * like page fault is easy.  The only trick is that Intel decided that some
- * traps should have error codes: */
-static int has_err(unsigned int trap)
-{
-	return (trap == 8 || (trap >= 10 && trap <= 14) || trap == 17);
-}
-
-/* deliver_trap() returns true if it could deliver the trap. */
-int deliver_trap(struct lguest *lg, unsigned int num)
-{
-	u32 lo = lg->idt[num].a, hi = lg->idt[num].b;
-
-	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
-	 * bogus one in): if we fail here, the Guest will be killed. */
-	if (!idt_present(lo, hi))
-		return 0;
-	set_guest_interrupt(lg, lo, hi, has_err(num));
-	return 1;
-}
-
-/*H:250 Here's the hard part: returning to the Host every time a trap happens
- * and then calling deliver_trap() and re-entering the Guest is slow.
- * Particularly because Guest userspace system calls are traps (trap 128).
- *
- * So we'd like to set up the IDT to tell the CPU to deliver traps directly
- * into the Guest.  This is possible, but the complexities cause the size of
- * this file to double!  However, 150 lines of code is worth writing for taking
- * system calls down from 1750ns to 270ns.  Plus, if lguest didn't do it, all
- * the other hypervisors would tease it.
- *
- * This routine determines if a trap can be delivered directly. */
-static int direct_trap(const struct lguest *lg,
-		       const struct desc_struct *trap,
-		       unsigned int num)
-{
-	/* Hardware interrupts don't go to the Guest at all (except system
-	 * call). */
-	if (num >= FIRST_EXTERNAL_VECTOR && num != SYSCALL_VECTOR)
-		return 0;
-
-	/* The Host needs to see page faults (for shadow paging and to save the
-	 * fault address), general protection faults (in/out emulation) and
-	 * device not available (TS handling), and of course, the hypercall
-	 * trap. */
-	if (num == 14 || num == 13 || num == 7 || num == LGUEST_TRAP_ENTRY)
-		return 0;
-
-	/* Only trap gates (type 15) can go direct to the Guest.  Interrupt
-	 * gates (type 14) disable interrupts as they are entered, which we
-	 * never let the Guest do.  Not present entries (type 0x0) also can't
-	 * go direct, of course 8) */
-	return idt_type(trap->a, trap->b) == 0xF;
-}
-/*:*/
-
-/*M:005 The Guest has the ability to turn its interrupt gates into trap gates,
- * if it is careful.  The Host will let trap gates can go directly to the
- * Guest, but the Guest needs the interrupts atomically disabled for an
- * interrupt gate.  It can do this by pointing the trap gate at instructions
- * within noirq_start and noirq_end, where it can safely disable interrupts. */
-
-/*M:006 The Guests do not use the sysenter (fast system call) instruction,
- * because it's hardcoded to enter privilege level 0 and so can't go direct.
- * It's about twice as fast as the older "int 0x80" system call, so it might
- * still be worthwhile to handle it in the Switcher and lcall down to the
- * Guest.  The sysenter semantics are hairy tho: search for that keyword in
- * entry.S :*/
-
-/*H:260 When we make traps go directly into the Guest, we need to make sure
- * the kernel stack is valid (ie. mapped in the page tables).  Otherwise, the
- * CPU trying to deliver the trap will fault while trying to push the interrupt
- * words on the stack: this is called a double fault, and it forces us to kill
- * the Guest.
- *
- * Which is deeply unfair, because (literally!) it wasn't the Guests' fault. */
-void pin_stack_pages(struct lguest *lg)
-{
-	unsigned int i;
-
-	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
-	 * two pages of stack space. */
-	for (i = 0; i < lg->stack_pages; i++)
-		/* The stack grows *upwards*, hence the subtraction */
-		pin_page(lg, lg->esp1 - i * PAGE_SIZE);
-}
-
-/* Direct traps also mean that we need to know whenever the Guest wants to use
- * a different kernel stack, so we can change the IDT entries to use that
- * stack.  The IDT entries expect a virtual address, so unlike most addresses
- * the Guest gives us, the "esp" (stack pointer) value here is virtual, not
- * physical.
- *
- * In Linux each process has its own kernel stack, so this happens a lot: we
- * change stacks on each context switch. */
-void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages)
-{
-	/* You are not allowd have a stack segment with privilege level 0: bad
-	 * Guest! */
-	if ((seg & 0x3) != GUEST_PL)
-		kill_guest(lg, "bad stack segment %i", seg);
-	/* We only expect one or two stack pages. */
-	if (pages > 2)
-		kill_guest(lg, "bad stack pages %u", pages);
-	/* Save where the stack is, and how many pages */
-	lg->ss1 = seg;
-	lg->esp1 = esp;
-	lg->stack_pages = pages;
-	/* Make sure the new stack pages are mapped */
-	pin_stack_pages(lg);
-}
-
-/* All this reference to mapping stacks leads us neatly into the other complex
- * part of the Host: page table handling. */
-
-/*H:235 This is the routine which actually checks the Guest's IDT entry and
- * transfers it into our entry in "struct lguest": */
-static void set_trap(struct lguest *lg, struct desc_struct *trap,
-		     unsigned int num, u32 lo, u32 hi)
-{
-	u8 type = idt_type(lo, hi);
-
-	/* We zero-out a not-present entry */
-	if (!idt_present(lo, hi)) {
-		trap->a = trap->b = 0;
-		return;
-	}
-
-	/* We only support interrupt and trap gates. */
-	if (type != 0xE && type != 0xF)
-		kill_guest(lg, "bad IDT type %i", type);
-
-	/* We only copy the handler address, present bit, privilege level and
-	 * type.  The privilege level controls where the trap can be triggered
-	 * manually with an "int" instruction.  This is usually GUEST_PL,
-	 * except for system calls which userspace can use. */
-	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
-	trap->b = (hi&0xFFFFEF00);
-}
-
-/*H:230 While we're here, dealing with delivering traps and interrupts to the
- * Guest, we might as well complete the picture: how the Guest tells us where
- * it wants them to go.  This would be simple, except making traps fast
- * requires some tricks.
- *
- * We saw the Guest setting Interrupt Descriptor Table (IDT) entries with the
- * LHCALL_LOAD_IDT_ENTRY hypercall before: that comes here. */
-void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
-{
-	/* Guest never handles: NMI, doublefault, spurious interrupt or
-	 * hypercall.  We ignore when it tries to set them. */
-	if (num == 2 || num == 8 || num == 15 || num == LGUEST_TRAP_ENTRY)
-		return;
-
-	/* Mark the IDT as changed: next time the Guest runs we'll know we have
-	 * to copy this again. */
-	lg->changed |= CHANGED_IDT;
-
-	/* The IDT which we keep in "struct lguest" only contains 32 entries
-	 * for the traps and LGUEST_IRQS (32) entries for interrupts.  We
-	 * ignore attempts to set handlers for higher interrupt numbers, except
-	 * for the system call "interrupt" at 128: we have a special IDT entry
-	 * for that. */
-	if (num < ARRAY_SIZE(lg->idt))
-		set_trap(lg, &lg->idt[num], num, lo, hi);
-	else if (num == SYSCALL_VECTOR)
-		set_trap(lg, &lg->syscall_idt, num, lo, hi);
-}
-
-/* The default entry for each interrupt points into the Switcher routines which
- * simply return to the Host.  The run_guest() loop will then call
- * deliver_trap() to bounce it back into the Guest. */
-static void default_idt_entry(struct desc_struct *idt,
-			      int trap,
-			      const unsigned long handler)
-{
-	/* A present interrupt gate. */
-	u32 flags = 0x8e00;
-
-	/* Set the privilege level on the entry for the hypercall: this allows
-	 * the Guest to use the "int" instruction to trigger it. */
-	if (trap == LGUEST_TRAP_ENTRY)
-		flags |= (GUEST_PL << 13);
-
-	/* Now pack it into the IDT entry in its weird format. */
-	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
-	idt->b = (handler&0xFFFF0000) | flags;
-}
-
-/* When the Guest first starts, we put default entries into the IDT. */
-void setup_default_idt_entries(struct lguest_ro_state *state,
-			       const unsigned long *def)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(state->guest_idt); i++)
-		default_idt_entry(&state->guest_idt[i], i, def[i]);
-}
-
-/*H:240 We don't use the IDT entries in the "struct lguest" directly, instead
- * we copy them into the IDT which we've set up for Guests on this CPU, just
- * before we run the Guest.  This routine does that copy. */
-void copy_traps(const struct lguest *lg, struct desc_struct *idt,
-		const unsigned long *def)
-{
-	unsigned int i;
-
-	/* We can simply copy the direct traps, otherwise we use the default
-	 * ones in the Switcher: they will return to the Host. */
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
-		if (direct_trap(lg, &lg->idt[i], i))
-			idt[i] = lg->idt[i];
-		else
-			default_idt_entry(&idt[i], i, def[i]);
-	}
-
-	/* Don't forget the system call trap!  The IDT entries for other
-	 * interupts never change, so no need to copy them. */
-	i = SYSCALL_VECTOR;
-	if (direct_trap(lg, &lg->syscall_idt, i))
-		idt[i] = lg->syscall_idt;
-	else
-		default_idt_entry(&idt[i], i, def[i]);
-}
-
-void guest_set_clockevent(struct lguest *lg, unsigned long delta)
-{
-	ktime_t expires;
-
-	if (unlikely(delta == 0)) {
-		/* Clock event device is shutting down. */
-		hrtimer_cancel(&lg->hrt);
-		return;
-	}
-
-	expires = ktime_add_ns(ktime_get_real(), delta);
-	hrtimer_start(&lg->hrt, expires, HRTIMER_MODE_ABS);
-}
-
-static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
-{
-	struct lguest *lg = container_of(timer, struct lguest, hrt);
-
-	set_bit(0, lg->irqs_pending);
-	if (lg->halted)
-		wake_up_process(lg->tsk);
-	return HRTIMER_NORESTART;
-}
-
-void init_clockdev(struct lguest *lg)
-{
-	hrtimer_init(&lg->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
-	lg->hrt.function = clockdev_fn;
-}
diff --git a/drivers/lguest/lguest.c b/drivers/lguest/lguest.c
deleted file mode 100644
index 1bc1546..0000000
--- a/drivers/lguest/lguest.c
+++ /dev/null
@@ -1,1097 +0,0 @@
-/*P:010
- * A hypervisor allows multiple Operating Systems to run on a single machine.
- * To quote David Wheeler: "Any problem in computer science can be solved with
- * another layer of indirection."
- *
- * We keep things simple in two ways.  First, we start with a normal Linux
- * kernel and insert a module (lg.ko) which allows us to run other Linux
- * kernels the same way we'd run processes.  We call the first kernel the Host,
- * and the others the Guests.  The program which sets up and configures Guests
- * (such as the example in Documentation/lguest/lguest.c) is called the
- * Launcher.
- *
- * Secondly, we only run specially modified Guests, not normal kernels.  When
- * you set CONFIG_LGUEST to 'y' or 'm', this automatically sets
- * CONFIG_LGUEST_GUEST=y, which compiles this file into the kernel so it knows
- * how to be a Guest.  This means that you can use the same kernel you boot
- * normally (ie. as a Host) as a Guest.
- *
- * These Guests know that they cannot do privileged operations, such as disable
- * interrupts, and that they have to ask the Host to do such things explicitly.
- * This file consists of all the replacements for such low-level native
- * hardware operations: these special Guest versions call the Host.
- *
- * So how does the kernel know it's a Guest?  The Guest starts at a special
- * entry point marked with a magic string, which sets up a few things then
- * calls here.  We replace the native functions in "struct paravirt_ops"
- * with our Guest versions, then boot like normal. :*/
-
-/*
- * Copyright (C) 2006, Rusty Russell <rusty@rustcorp.com.au> IBM Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/kernel.h>
-#include <linux/start_kernel.h>
-#include <linux/string.h>
-#include <linux/console.h>
-#include <linux/screen_info.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/lguest.h>
-#include <linux/lguest_launcher.h>
-#include <linux/lguest_bus.h>
-#include <asm/paravirt.h>
-#include <asm/param.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/desc.h>
-#include <asm/setup.h>
-#include <asm/e820.h>
-#include <asm/mce.h>
-#include <asm/io.h>
-
-/*G:010 Welcome to the Guest!
- *
- * The Guest in our tale is a simple creature: identical to the Host but
- * behaving in simplified but equivalent ways.  In particular, the Guest is the
- * same kernel as the Host (or at least, built from the same source code). :*/
-
-/* Declarations for definitions in lguest_guest.S */
-extern char lguest_noirq_start[], lguest_noirq_end[];
-extern const char lgstart_cli[], lgend_cli[];
-extern const char lgstart_sti[], lgend_sti[];
-extern const char lgstart_popf[], lgend_popf[];
-extern const char lgstart_pushf[], lgend_pushf[];
-extern const char lgstart_iret[], lgend_iret[];
-extern void lguest_iret(void);
-
-struct lguest_data lguest_data = {
-	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
-	.noirq_start = (u32)lguest_noirq_start,
-	.noirq_end = (u32)lguest_noirq_end,
-	.blocked_interrupts = { 1 }, /* Block timer interrupts */
-};
-struct lguest_device_desc *lguest_devices;
-static cycle_t clock_base;
-
-/*G:035 Notice the lazy_hcall() above, rather than hcall().  This is our first
- * real optimization trick!
- *
- * When lazy_mode is set, it means we're allowed to defer all hypercalls and do
- * them as a batch when lazy_mode is eventually turned off.  Because hypercalls
- * are reasonably expensive, batching them up makes sense.  For example, a
- * large mmap might update dozens of page table entries: that code calls
- * lguest_lazy_mode(PARAVIRT_LAZY_MMU), does the dozen updates, then calls
- * lguest_lazy_mode(PARAVIRT_LAZY_NONE).
- *
- * So, when we're in lazy mode, we call async_hypercall() to store the call for
- * future processing.  When lazy mode is turned off we issue a hypercall to
- * flush the stored calls.
- *
- * There's also a hack where "mode" is set to "PARAVIRT_LAZY_FLUSH" which
- * indicates we're to flush any outstanding calls immediately.  This is used
- * when an interrupt handler does a kmap_atomic(): the page table changes must
- * happen immediately even if we're in the middle of a batch.  Usually we're
- * not, though, so there's nothing to do. */
-static enum paravirt_lazy_mode lazy_mode; /* Note: not SMP-safe! */
-static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
-{
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
-			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	} else {
-		lazy_mode = mode;
-		if (mode == PARAVIRT_LAZY_NONE)
-			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	}
-}
-
-static void lazy_hcall(unsigned long call,
-		       unsigned long arg1,
-		       unsigned long arg2,
-		       unsigned long arg3)
-{
-	if (lazy_mode == PARAVIRT_LAZY_NONE)
-		hcall(call, arg1, arg2, arg3);
-	else
-		async_hcall(call, arg1, arg2, arg3);
-}
-
-/* async_hcall() is pretty simple: I'm quite proud of it really.  We have a
- * ring buffer of stored hypercalls which the Host will run though next time we
- * do a normal hypercall.  Each entry in the ring has 4 slots for the hypercall
- * arguments, and a "hcall_status" word which is 0 if the call is ready to go,
- * and 255 once the Host has finished with it.
- *
- * If we come around to a slot which hasn't been finished, then the table is
- * full and we just make the hypercall directly.  This has the nice side
- * effect of causing the Host to run all the stored calls in the ring buffer
- * which empties it for next time! */
-void async_hcall(unsigned long call,
-		 unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-	/* Note: This code assumes we're uniprocessor. */
-	static unsigned int next_call;
-	unsigned long flags;
-
-	/* Disable interrupts if not already disabled: we don't want an
-	 * interrupt handler making a hypercall while we're already doing
-	 * one! */
-	local_irq_save(flags);
-	if (lguest_data.hcall_status[next_call] != 0xFF) {
-		/* Table full, so do normal hcall which will flush table. */
-		hcall(call, arg1, arg2, arg3);
-	} else {
-		lguest_data.hcalls[next_call].eax = call;
-		lguest_data.hcalls[next_call].edx = arg1;
-		lguest_data.hcalls[next_call].ebx = arg2;
-		lguest_data.hcalls[next_call].ecx = arg3;
-		/* Arguments must all be written before we mark it to go */
-		wmb();
-		lguest_data.hcall_status[next_call] = 0;
-		if (++next_call == LHCALL_RING_SIZE)
-			next_call = 0;
-	}
-	local_irq_restore(flags);
-}
-/*:*/
-
-/* Wrappers for the SEND_DMA and BIND_DMA hypercalls.  This is mainly because
- * Jeff Garzik complained that __pa() should never appear in drivers, and this
- * helps remove most of them.   But also, it wraps some ugliness. */
-void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
-{
-	/* The hcall might not write this if something goes wrong */
-	dma->used_len = 0;
-	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
-}
-
-int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
-		    unsigned int num, u8 irq)
-{
-	/* This is the only hypercall which actually wants 5 arguments, and we
-	 * only support 4.  Fortunately the interrupt number is always less
-	 * than 256, so we can pack it with the number of dmas in the final
-	 * argument.  */
-	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
-		return -ENOMEM;
-	return 0;
-}
-
-/* Unbinding is the same hypercall as binding, but with 0 num & irq. */
-void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
-{
-	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
-}
-
-/* For guests, device memory can be used as normal memory, so we cast away the
- * __iomem to quieten sparse. */
-void *lguest_map(unsigned long phys_addr, unsigned long pages)
-{
-	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
-}
-
-void lguest_unmap(void *addr)
-{
-	iounmap((__force void __iomem *)addr);
-}
-
-/*G:033
- * Here are our first native-instruction replacements: four functions for
- * interrupt control.
- *
- * The simplest way of implementing these would be to have "turn interrupts
- * off" and "turn interrupts on" hypercalls.  Unfortunately, this is too slow:
- * these are by far the most commonly called functions of those we override.
- *
- * So instead we keep an "irq_enabled" field inside our "struct lguest_data",
- * which the Guest can update with a single instruction.  The Host knows to
- * check there when it wants to deliver an interrupt.
- */
-
-/* save_flags() is expected to return the processor state (ie. "eflags").  The
- * eflags word contains all kind of stuff, but in practice Linux only cares
- * about the interrupt flag.  Our "save_flags()" just returns that. */
-static unsigned long save_fl(void)
-{
-	return lguest_data.irq_enabled;
-}
-
-/* "restore_flags" just sets the flags back to the value given. */
-static void restore_fl(unsigned long flags)
-{
-	lguest_data.irq_enabled = flags;
-}
-
-/* Interrupts go off... */
-static void irq_disable(void)
-{
-	lguest_data.irq_enabled = 0;
-}
-
-/* Interrupts go on... */
-static void irq_enable(void)
-{
-	lguest_data.irq_enabled = X86_EFLAGS_IF;
-}
-/*:*/
-/*M:003 Note that we don't check for outstanding interrupts when we re-enable
- * them (or when we unmask an interrupt).  This seems to work for the moment,
- * since interrupts are rare and we'll just get the interrupt on the next timer
- * tick, but when we turn on CONFIG_NO_HZ, we should revisit this.  One way
- * would be to put the "irq_enabled" field in a page by itself, and have the
- * Host write-protect it when an interrupt comes in when irqs are disabled.
- * There will then be a page fault as soon as interrupts are re-enabled. :*/
-
-/*G:034
- * The Interrupt Descriptor Table (IDT).
- *
- * The IDT tells the processor what to do when an interrupt comes in.  Each
- * entry in the table is a 64-bit descriptor: this holds the privilege level,
- * address of the handler, and... well, who cares?  The Guest just asks the
- * Host to make the change anyway, because the Host controls the real IDT.
- */
-static void lguest_write_idt_entry(struct desc_struct *dt,
-				   int entrynum, u32 low, u32 high)
-{
-	/* Keep the local copy up to date. */
-	write_dt_entry(dt, entrynum, low, high);
-	/* Tell Host about this new entry. */
-	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
-}
-
-/* Changing to a different IDT is very rare: we keep the IDT up-to-date every
- * time it is written, so we can simply loop through all entries and tell the
- * Host about them. */
-static void lguest_load_idt(const struct Xgt_desc_struct *desc)
-{
-	unsigned int i;
-	struct desc_struct *idt = (void *)desc->address;
-
-	for (i = 0; i < (desc->size+1)/8; i++)
-		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
-}
-
-/*
- * The Global Descriptor Table.
- *
- * The Intel architecture defines another table, called the Global Descriptor
- * Table (GDT).  You tell the CPU where it is (and its size) using the "lgdt"
- * instruction, and then several other instructions refer to entries in the
- * table.  There are three entries which the Switcher needs, so the Host simply
- * controls the entire thing and the Guest asks it to make changes using the
- * LOAD_GDT hypercall.
- *
- * This is the opposite of the IDT code where we have a LOAD_IDT_ENTRY
- * hypercall and use that repeatedly to load a new IDT.  I don't think it
- * really matters, but wouldn't it be nice if they were the same?
- */
-static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
-{
-	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
-	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
-}
-
-/* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
- * then tell the Host to reload the entire thing.  This operation is so rare
- * that this naive implementation is reasonable. */
-static void lguest_write_gdt_entry(struct desc_struct *dt,
-				   int entrynum, u32 low, u32 high)
-{
-	write_dt_entry(dt, entrynum, low, high);
-	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
-}
-
-/* OK, I lied.  There are three "thread local storage" GDT entries which change
- * on every context switch (these three entries are how glibc implements
- * __thread variables).  So we have a hypercall specifically for this case. */
-static void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
-{
-	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
-}
-/*:*/
-
-/*G:038 That's enough excitement for now, back to ploughing through each of
- * the paravirt_ops (we're about 1/3 of the way through).
- *
- * This is the Local Descriptor Table, another weird Intel thingy.  Linux only
- * uses this for some strange applications like Wine.  We don't do anything
- * here, so they'll get an informative and friendly Segmentation Fault. */
-static void lguest_set_ldt(const void *addr, unsigned entries)
-{
-}
-
-/* This loads a GDT entry into the "Task Register": that entry points to a
- * structure called the Task State Segment.  Some comments scattered though the
- * kernel code indicate that this used for task switching in ages past, along
- * with blood sacrifice and astrology.
- *
- * Now there's nothing interesting in here that we don't get told elsewhere.
- * But the native version uses the "ltr" instruction, which makes the Host
- * complain to the Guest about a Segmentation Fault and it'll oops.  So we
- * override the native version with a do-nothing version. */
-static void lguest_load_tr_desc(void)
-{
-}
-
-/* The "cpuid" instruction is a way of querying both the CPU identity
- * (manufacturer, model, etc) and its features.  It was introduced before the
- * Pentium in 1993 and keeps getting extended by both Intel and AMD.  As you
- * might imagine, after a decade and a half this treatment, it is now a giant
- * ball of hair.  Its entry in the current Intel manual runs to 28 pages.
- *
- * This instruction even it has its own Wikipedia entry.  The Wikipedia entry
- * has been translated into 4 languages.  I am not making this up!
- *
- * We could get funky here and identify ourselves as "GenuineLguest", but
- * instead we just use the real "cpuid" instruction.  Then I pretty much turned
- * off feature bits until the Guest booted.  (Don't say that: you'll damage
- * lguest sales!)  Shut up, inner voice!  (Hey, just pointing out that this is
- * hardly future proof.)  Noone's listening!  They don't like you anyway,
- * parenthetic weirdo!
- *
- * Replacing the cpuid so we can turn features off is great for the kernel, but
- * anyone (including userspace) can just use the raw "cpuid" instruction and
- * the Host won't even notice since it isn't privileged.  So we try not to get
- * too worked up about it. */
-static void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
-			 unsigned int *ecx, unsigned int *edx)
-{
-	int function = *eax;
-
-	native_cpuid(eax, ebx, ecx, edx);
-	switch (function) {
-	case 1:	/* Basic feature request. */
-		/* We only allow kernel to see SSE3, CMPXCHG16B and SSSE3 */
-		*ecx &= 0x00002201;
-		/* SSE, SSE2, FXSR, MMX, CMOV, CMPXCHG8B, FPU. */
-		*edx &= 0x07808101;
-		/* The Host can do a nice optimization if it knows that the
-		 * kernel mappings (addresses above 0xC0000000 or whatever
-		 * PAGE_OFFSET is set to) haven't changed.  But Linux calls
-		 * flush_tlb_user() for both user and kernel mappings unless
-		 * the Page Global Enable (PGE) feature bit is set. */
-		*edx |= 0x00002000;
-		break;
-	case 0x80000000:
-		/* Futureproof this a little: if they ask how much extended
-		 * processor information there is, limit it to known fields. */
-		if (*eax > 0x80000008)
-			*eax = 0x80000008;
-		break;
-	}
-}
-
-/* Intel has four control registers, imaginatively named cr0, cr2, cr3 and cr4.
- * I assume there's a cr1, but it hasn't bothered us yet, so we'll not bother
- * it.  The Host needs to know when the Guest wants to change them, so we have
- * a whole series of functions like read_cr0() and write_cr0().
- *
- * We start with CR0.  CR0 allows you to turn on and off all kinds of basic
- * features, but Linux only really cares about one: the horrifically-named Task
- * Switched (TS) bit at bit 3 (ie. 8)
- *
- * What does the TS bit do?  Well, it causes the CPU to trap (interrupt 7) if
- * the floating point unit is used.  Which allows us to restore FPU state
- * lazily after a task switch, and Linux uses that gratefully, but wouldn't a
- * name like "FPUTRAP bit" be a little less cryptic?
- *
- * We store cr0 (and cr3) locally, because the Host never changes it.  The
- * Guest sometimes wants to read it and we'd prefer not to bother the Host
- * unnecessarily. */
-static unsigned long current_cr0, current_cr3;
-static void lguest_write_cr0(unsigned long val)
-{
-	/* 8 == TS bit. */
-	lazy_hcall(LHCALL_TS, val & 8, 0, 0);
-	current_cr0 = val;
-}
-
-static unsigned long lguest_read_cr0(void)
-{
-	return current_cr0;
-}
-
-/* Intel provided a special instruction to clear the TS bit for people too cool
- * to use write_cr0() to do it.  This "clts" instruction is faster, because all
- * the vowels have been optimized out. */
-static void lguest_clts(void)
-{
-	lazy_hcall(LHCALL_TS, 0, 0, 0);
-	current_cr0 &= ~8U;
-}
-
-/* CR2 is the virtual address of the last page fault, which the Guest only ever
- * reads.  The Host kindly writes this into our "struct lguest_data", so we
- * just read it out of there. */
-static unsigned long lguest_read_cr2(void)
-{
-	return lguest_data.cr2;
-}
-
-/* CR3 is the current toplevel pagetable page: the principle is the same as
- * cr0.  Keep a local copy, and tell the Host when it changes. */
-static void lguest_write_cr3(unsigned long cr3)
-{
-	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
-	current_cr3 = cr3;
-}
-
-static unsigned long lguest_read_cr3(void)
-{
-	return current_cr3;
-}
-
-/* CR4 is used to enable and disable PGE, but we don't care. */
-static unsigned long lguest_read_cr4(void)
-{
-	return 0;
-}
-
-static void lguest_write_cr4(unsigned long val)
-{
-}
-
-/*
- * Page Table Handling.
- *
- * Now would be a good time to take a rest and grab a coffee or similarly
- * relaxing stimulant.  The easy parts are behind us, and the trek gradually
- * winds uphill from here.
- *
- * Quick refresher: memory is divided into "pages" of 4096 bytes each.  The CPU
- * maps virtual addresses to physical addresses using "page tables".  We could
- * use one huge index of 1 million entries: each address is 4 bytes, so that's
- * 1024 pages just to hold the page tables.   But since most virtual addresses
- * are unused, we use a two level index which saves space.  The CR3 register
- * contains the physical address of the top level "page directory" page, which
- * contains physical addresses of up to 1024 second-level pages.  Each of these
- * second level pages contains up to 1024 physical addresses of actual pages,
- * or Page Table Entries (PTEs).
- *
- * Here's a diagram, where arrows indicate physical addresses:
- *
- * CR3 ---> +---------+
- *	    |  	   --------->+---------+
- *	    |	      |	     | PADDR1  |
- *	  Top-level   |	     | PADDR2  |
- *	  (PMD) page  |	     | 	       |
- *	    |	      |	   Lower-level |
- *	    |	      |	   (PTE) page  |
- *	    |	      |	     |	       |
- *	      ....    	     	 ....
- *
- * So to convert a virtual address to a physical address, we look up the top
- * level, which points us to the second level, which gives us the physical
- * address of that page.  If the top level entry was not present, or the second
- * level entry was not present, then the virtual address is invalid (we
- * say "the page was not mapped").
- *
- * Put another way, a 32-bit virtual address is divided up like so:
- *
- *  1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
- * |<---- 10 bits ---->|<---- 10 bits ---->|<------ 12 bits ------>|
- *    Index into top     Index into second      Offset within page
- *  page directory page    pagetable page
- *
- * The kernel spends a lot of time changing both the top-level page directory
- * and lower-level pagetable pages.  The Guest doesn't know physical addresses,
- * so while it maintains these page tables exactly like normal, it also needs
- * to keep the Host informed whenever it makes a change: the Host will create
- * the real page tables based on the Guests'.
- */
-
-/* The Guest calls this to set a second-level entry (pte), ie. to map a page
- * into a process' address space.  We set the entry then tell the Host the
- * toplevel and address this corresponds to.  The Guest uses one pagetable per
- * process, so we need to tell the Host which one we're changing (mm->pgd). */
-static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	*ptep = pteval;
-	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
-}
-
-/* The Guest calls this to set a top-level entry.  Again, we set the entry then
- * tell the Host which top-level page we changed, and the index of the entry we
- * changed. */
-static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	*pmdp = pmdval;
-	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
-		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
-}
-
-/* There are a couple of legacy places where the kernel sets a PTE, but we
- * don't know the top level any more.  This is useless for us, since we don't
- * know which pagetable is changing or what address, so we just tell the Host
- * to forget all of them.  Fortunately, this is very rare.
- *
- * ... except in early boot when the kernel sets up the initial pagetables,
- * which makes booting astonishingly slow.  So we don't even tell the Host
- * anything changed until we've done the first page table switch.
- */
-static void lguest_set_pte(pte_t *ptep, pte_t pteval)
-{
-	*ptep = pteval;
-	/* Don't bother with hypercall before initial setup. */
-	if (current_cr3)
-		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
-}
-
-/* Unfortunately for Lguest, the paravirt_ops for page tables were based on
- * native page table operations.  On native hardware you can set a new page
- * table entry whenever you want, but if you want to remove one you have to do
- * a TLB flush (a TLB is a little cache of page table entries kept by the CPU).
- *
- * So the lguest_set_pte_at() and lguest_set_pmd() functions above are only
- * called when a valid entry is written, not when it's removed (ie. marked not
- * present).  Instead, this is where we come when the Guest wants to remove a
- * page table entry: we tell the Host to set that entry to 0 (ie. the present
- * bit is zero). */
-static void lguest_flush_tlb_single(unsigned long addr)
-{
-	/* Simply set it to zero: if it was not, it will fault back in. */
-	lazy_hcall(LHCALL_SET_PTE, current_cr3, addr, 0);
-}
-
-/* This is what happens after the Guest has removed a large number of entries.
- * This tells the Host that any of the page table entries for userspace might
- * have changed, ie. virtual addresses below PAGE_OFFSET. */
-static void lguest_flush_tlb_user(void)
-{
-	lazy_hcall(LHCALL_FLUSH_TLB, 0, 0, 0);
-}
-
-/* This is called when the kernel page tables have changed.  That's not very
- * common (unless the Guest is using highmem, which makes the Guest extremely
- * slow), so it's worth separating this from the user flushing above. */
-static void lguest_flush_tlb_kernel(void)
-{
-	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
-}
-
-/*
- * The Unadvanced Programmable Interrupt Controller.
- *
- * This is an attempt to implement the simplest possible interrupt controller.
- * I spent some time looking though routines like set_irq_chip_and_handler,
- * set_irq_chip_and_handler_name, set_irq_chip_data and set_phasers_to_stun and
- * I *think* this is as simple as it gets.
- *
- * We can tell the Host what interrupts we want blocked ready for using the
- * lguest_data.interrupts bitmap, so disabling (aka "masking") them is as
- * simple as setting a bit.  We don't actually "ack" interrupts as such, we
- * just mask and unmask them.  I wonder if we should be cleverer?
- */
-static void disable_lguest_irq(unsigned int irq)
-{
-	set_bit(irq, lguest_data.blocked_interrupts);
-}
-
-static void enable_lguest_irq(unsigned int irq)
-{
-	clear_bit(irq, lguest_data.blocked_interrupts);
-}
-
-/* This structure describes the lguest IRQ controller. */
-static struct irq_chip lguest_irq_controller = {
-	.name		= "lguest",
-	.mask		= disable_lguest_irq,
-	.mask_ack	= disable_lguest_irq,
-	.unmask		= enable_lguest_irq,
-};
-
-/* This sets up the Interrupt Descriptor Table (IDT) entry for each hardware
- * interrupt (except 128, which is used for system calls), and then tells the
- * Linux infrastructure that each interrupt is controlled by our level-based
- * lguest interrupt controller. */
-static void __init lguest_init_IRQ(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < LGUEST_IRQS; i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != SYSCALL_VECTOR) {
-			set_intr_gate(vector, interrupt[i]);
-			set_irq_chip_and_handler(i, &lguest_irq_controller,
-						 handle_level_irq);
-		}
-	}
-	/* This call is required to set up for 4k stacks, where we have
-	 * separate stacks for hard and soft interrupts. */
-	irq_ctx_init(smp_processor_id());
-}
-
-/*
- * Time.
- *
- * It would be far better for everyone if the Guest had its own clock, but
- * until then the Host gives us the time on every interrupt.
- */
-static unsigned long lguest_get_wallclock(void)
-{
-	return lguest_data.time.tv_sec;
-}
-
-static cycle_t lguest_clock_read(void)
-{
-	unsigned long sec, nsec;
-
-	/* If the Host tells the TSC speed, we can trust that. */
-	if (lguest_data.tsc_khz)
-		return native_read_tsc();
-
-	/* If we can't use the TSC, we read the time value written by the Host.
-	 * Since it's in two parts (seconds and nanoseconds), we risk reading
-	 * it just as it's changing from 99 & 0.999999999 to 100 and 0, and
-	 * getting 99 and 0.  As Linux tends to come apart under the stress of
-	 * time travel, we must be careful: */
-	do {
-		/* First we read the seconds part. */
-		sec = lguest_data.time.tv_sec;
-		/* This read memory barrier tells the compiler and the CPU that
-		 * this can't be reordered: we have to complete the above
-		 * before going on. */
-		rmb();
-		/* Now we read the nanoseconds part. */
-		nsec = lguest_data.time.tv_nsec;
-		/* Make sure we've done that. */
-		rmb();
-		/* Now if the seconds part has changed, try again. */
-	} while (unlikely(lguest_data.time.tv_sec != sec));
-
-	/* Our non-TSC clock is in real nanoseconds. */
-	return sec*1000000000ULL + nsec;
-}
-
-/* This is what we tell the kernel is our clocksource.  */
-static struct clocksource lguest_clock = {
-	.name		= "lguest",
-	.rating		= 400,
-	.read		= lguest_clock_read,
-	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1,
-};
-
-/* The "scheduler clock" is just our real clock, adjusted to start at zero */
-static unsigned long long lguest_sched_clock(void)
-{
-	return cyc2ns(&lguest_clock, lguest_clock_read() - clock_base);
-}
-
-/* We also need a "struct clock_event_device": Linux asks us to set it to go
- * off some time in the future.  Actually, James Morris figured all this out, I
- * just applied the patch. */
-static int lguest_clockevent_set_next_event(unsigned long delta,
-                                           struct clock_event_device *evt)
-{
-	if (delta < LG_CLOCK_MIN_DELTA) {
-		if (printk_ratelimit())
-			printk(KERN_DEBUG "%s: small delta %lu ns\n",
-			       __FUNCTION__, delta);
-		return -ETIME;
-	}
-	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
-	return 0;
-}
-
-static void lguest_clockevent_set_mode(enum clock_event_mode mode,
-                                      struct clock_event_device *evt)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		/* A 0 argument shuts the clock down. */
-		hcall(LHCALL_SET_CLOCKEVENT, 0, 0, 0);
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* This is what we expect. */
-		break;
-	case CLOCK_EVT_MODE_PERIODIC:
-		BUG();
-	case CLOCK_EVT_MODE_RESUME:
-		break;
-	}
-}
-
-/* This describes our primitive timer chip. */
-static struct clock_event_device lguest_clockevent = {
-	.name                   = "lguest",
-	.features               = CLOCK_EVT_FEAT_ONESHOT,
-	.set_next_event         = lguest_clockevent_set_next_event,
-	.set_mode               = lguest_clockevent_set_mode,
-	.rating                 = INT_MAX,
-	.mult                   = 1,
-	.shift                  = 0,
-	.min_delta_ns           = LG_CLOCK_MIN_DELTA,
-	.max_delta_ns           = LG_CLOCK_MAX_DELTA,
-};
-
-/* This is the Guest timer interrupt handler (hardware interrupt 0).  We just
- * call the clockevent infrastructure and it does whatever needs doing. */
-static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
-{
-	unsigned long flags;
-
-	/* Don't interrupt us while this is running. */
-	local_irq_save(flags);
-	lguest_clockevent.event_handler(&lguest_clockevent);
-	local_irq_restore(flags);
-}
-
-/* At some point in the boot process, we get asked to set up our timing
- * infrastructure.  The kernel doesn't expect timer interrupts before this, but
- * we cleverly initialized the "blocked_interrupts" field of "struct
- * lguest_data" so that timer interrupts were blocked until now. */
-static void lguest_time_init(void)
-{
-	/* Set up the timer interrupt (0) to go to our simple timer routine */
-	set_irq_handler(0, lguest_time_irq);
-
-	/* Our clock structure look like arch/i386/kernel/tsc.c if we can use
-	 * the TSC, otherwise it's a dumb nanosecond-resolution clock.  Either
-	 * way, the "rating" is initialized so high that it's always chosen
-	 * over any other clocksource. */
-	if (lguest_data.tsc_khz) {
-		lguest_clock.shift = 22;
-		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
-							 lguest_clock.shift);
-		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
-	}
-	clock_base = lguest_clock_read();
-	clocksource_register(&lguest_clock);
-
-	/* Now we've set up our clock, we can use it as the scheduler clock */
-	paravirt_ops.sched_clock = lguest_sched_clock;
-
-	/* We can't set cpumask in the initializer: damn C limitations!  Set it
-	 * here and register our timer device. */
-	lguest_clockevent.cpumask = cpumask_of_cpu(0);
-	clockevents_register_device(&lguest_clockevent);
-
-	/* Finally, we unblock the timer interrupt. */
-	enable_lguest_irq(0);
-}
-
-/*
- * Miscellaneous bits and pieces.
- *
- * Here is an oddball collection of functions which the Guest needs for things
- * to work.  They're pretty simple.
- */
-
-/* The Guest needs to tell the host what stack it expects traps to use.  For
- * native hardware, this is part of the Task State Segment mentioned above in
- * lguest_load_tr_desc(), but to help hypervisors there's this special call.
- *
- * We tell the Host the segment we want to use (__KERNEL_DS is the kernel data
- * segment), the privilege level (we're privilege level 1, the Host is 0 and
- * will not tolerate us trying to use that), the stack pointer, and the number
- * of pages in the stack. */
-static void lguest_load_esp0(struct tss_struct *tss,
-				     struct thread_struct *thread)
-{
-	lazy_hcall(LHCALL_SET_STACK, __KERNEL_DS|0x1, thread->esp0,
-		   THREAD_SIZE/PAGE_SIZE);
-}
-
-/* Let's just say, I wouldn't do debugging under a Guest. */
-static void lguest_set_debugreg(int regno, unsigned long value)
-{
-	/* FIXME: Implement */
-}
-
-/* There are times when the kernel wants to make sure that no memory writes are
- * caught in the cache (that they've all reached real hardware devices).  This
- * doesn't matter for the Guest which has virtual hardware.
- *
- * On the Pentium 4 and above, cpuid() indicates that the Cache Line Flush
- * (clflush) instruction is available and the kernel uses that.  Otherwise, it
- * uses the older "Write Back and Invalidate Cache" (wbinvd) instruction.
- * Unlike clflush, wbinvd can only be run at privilege level 0.  So we can
- * ignore clflush, but replace wbinvd.
- */
-static void lguest_wbinvd(void)
-{
-}
-
-/* If the Guest expects to have an Advanced Programmable Interrupt Controller,
- * we play dumb by ignoring writes and returning 0 for reads.  So it's no
- * longer Programmable nor Controlling anything, and I don't think 8 lines of
- * code qualifies for Advanced.  It will also never interrupt anything.  It
- * does, however, allow us to get through the Linux boot code. */
-#ifdef CONFIG_X86_LOCAL_APIC
-static void lguest_apic_write(unsigned long reg, unsigned long v)
-{
-}
-
-static unsigned long lguest_apic_read(unsigned long reg)
-{
-	return 0;
-}
-#endif
-
-/* STOP!  Until an interrupt comes in. */
-static void lguest_safe_halt(void)
-{
-	hcall(LHCALL_HALT, 0, 0, 0);
-}
-
-/* Perhaps CRASH isn't the best name for this hypercall, but we use it to get a
- * message out when we're crashing as well as elegant termination like powering
- * off.
- *
- * Note that the Host always prefers that the Guest speak in physical addresses
- * rather than virtual addresses, so we use __pa() here. */
-static void lguest_power_off(void)
-{
-	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
-}
-
-/*
- * Panicing.
- *
- * Don't.  But if you did, this is what happens.
- */
-static int lguest_panic(struct notifier_block *nb, unsigned long l, void *p)
-{
-	hcall(LHCALL_CRASH, __pa(p), 0, 0);
-	/* The hcall won't return, but to keep gcc happy, we're "done". */
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block paniced = {
-	.notifier_call = lguest_panic
-};
-
-/* Setting up memory is fairly easy. */
-static __init char *lguest_memory_setup(void)
-{
-	/* We do this here and not earlier because lockcheck barfs if we do it
-	 * before start_kernel() */
-	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
-
-	/* The Linux bootloader header contains an "e820" memory map: the
-	 * Launcher populated the first entry with our memory limit. */
-	add_memory_region(E820_MAP->addr, E820_MAP->size, E820_MAP->type);
-
-	/* This string is for the boot messages. */
-	return "LGUEST";
-}
-
-/*G:050
- * Patching (Powerfully Placating Performance Pedants)
- *
- * We have already seen that "struct paravirt_ops" lets us replace simple
- * native instructions with calls to the appropriate back end all throughout
- * the kernel.  This allows the same kernel to run as a Guest and as a native
- * kernel, but it's slow because of all the indirect branches.
- *
- * Remember that David Wheeler quote about "Any problem in computer science can
- * be solved with another layer of indirection"?  The rest of that quote is
- * "... But that usually will create another problem."  This is the first of
- * those problems.
- *
- * Our current solution is to allow the paravirt back end to optionally patch
- * over the indirect calls to replace them with something more efficient.  We
- * patch the four most commonly called functions: disable interrupts, enable
- * interrupts, restore interrupts and save interrupts.  We usually have 10
- * bytes to patch into: the Guest versions of these operations are small enough
- * that we can fit comfortably.
- *
- * First we need assembly templates of each of the patchable Guest operations,
- * and these are in lguest_asm.S. */
-
-/*G:060 We construct a table from the assembler templates: */
-static const struct lguest_insns
-{
-	const char *start, *end;
-} lguest_insns[] = {
-	[PARAVIRT_PATCH(irq_disable)] = { lgstart_cli, lgend_cli },
-	[PARAVIRT_PATCH(irq_enable)] = { lgstart_sti, lgend_sti },
-	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
-	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
-};
-
-/* Now our patch routine is fairly simple (based on the native one in
- * paravirt.c).  If we have a replacement, we copy it in and return how much of
- * the available space we used. */
-static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
-{
-	unsigned int insn_len;
-
-	/* Don't do anything special if we don't have a replacement */
-	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
-		return paravirt_patch_default(type, clobber, insns, len);
-
-	insn_len = lguest_insns[type].end - lguest_insns[type].start;
-
-	/* Similarly if we can't fit replacement (shouldn't happen, but let's
-	 * be thorough). */
-	if (len < insn_len)
-		return paravirt_patch_default(type, clobber, insns, len);
-
-	/* Copy in our instructions. */
-	memcpy(insns, lguest_insns[type].start, insn_len);
-	return insn_len;
-}
-
-/*G:030 Once we get to lguest_init(), we know we're a Guest.  The paravirt_ops
- * structure in the kernel provides a single point for (almost) every routine
- * we have to override to avoid privileged instructions. */
-__init void lguest_init(void *boot)
-{
-	/* Copy boot parameters first: the Launcher put the physical location
-	 * in %esi, and head.S converted that to a virtual address and handed
-	 * it to us. */
-	memcpy(&boot_params, boot, PARAM_SIZE);
-	/* The boot parameters also tell us where the command-line is: save
-	 * that, too. */
-	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
-	       COMMAND_LINE_SIZE);
-
-	/* We're under lguest, paravirt is enabled, and we're running at
-	 * privilege level 1, not 0 as normal. */
-	paravirt_ops.name = "lguest";
-	paravirt_ops.paravirt_enabled = 1;
-	paravirt_ops.kernel_rpl = 1;
-
-	/* We set up all the lguest overrides for sensitive operations.  These
-	 * are detailed with the operations themselves. */
-	paravirt_ops.save_fl = save_fl;
-	paravirt_ops.restore_fl = restore_fl;
-	paravirt_ops.irq_disable = irq_disable;
-	paravirt_ops.irq_enable = irq_enable;
-	paravirt_ops.load_gdt = lguest_load_gdt;
-	paravirt_ops.memory_setup = lguest_memory_setup;
-	paravirt_ops.cpuid = lguest_cpuid;
-	paravirt_ops.write_cr3 = lguest_write_cr3;
-	paravirt_ops.flush_tlb_user = lguest_flush_tlb_user;
-	paravirt_ops.flush_tlb_single = lguest_flush_tlb_single;
-	paravirt_ops.flush_tlb_kernel = lguest_flush_tlb_kernel;
-	paravirt_ops.set_pte = lguest_set_pte;
-	paravirt_ops.set_pte_at = lguest_set_pte_at;
-	paravirt_ops.set_pmd = lguest_set_pmd;
-#ifdef CONFIG_X86_LOCAL_APIC
-	paravirt_ops.apic_write = lguest_apic_write;
-	paravirt_ops.apic_write_atomic = lguest_apic_write;
-	paravirt_ops.apic_read = lguest_apic_read;
-#endif
-	paravirt_ops.load_idt = lguest_load_idt;
-	paravirt_ops.iret = lguest_iret;
-	paravirt_ops.load_esp0 = lguest_load_esp0;
-	paravirt_ops.load_tr_desc = lguest_load_tr_desc;
-	paravirt_ops.set_ldt = lguest_set_ldt;
-	paravirt_ops.load_tls = lguest_load_tls;
-	paravirt_ops.set_debugreg = lguest_set_debugreg;
-	paravirt_ops.clts = lguest_clts;
-	paravirt_ops.read_cr0 = lguest_read_cr0;
-	paravirt_ops.write_cr0 = lguest_write_cr0;
-	paravirt_ops.init_IRQ = lguest_init_IRQ;
-	paravirt_ops.read_cr2 = lguest_read_cr2;
-	paravirt_ops.read_cr3 = lguest_read_cr3;
-	paravirt_ops.read_cr4 = lguest_read_cr4;
-	paravirt_ops.write_cr4 = lguest_write_cr4;
-	paravirt_ops.write_gdt_entry = lguest_write_gdt_entry;
-	paravirt_ops.write_idt_entry = lguest_write_idt_entry;
-	paravirt_ops.patch = lguest_patch;
-	paravirt_ops.safe_halt = lguest_safe_halt;
-	paravirt_ops.get_wallclock = lguest_get_wallclock;
-	paravirt_ops.time_init = lguest_time_init;
-	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
-	paravirt_ops.wbinvd = lguest_wbinvd;
-	/* Now is a good time to look at the implementations of these functions
-	 * before returning to the rest of lguest_init(). */
-
-	/*G:070 Now we've seen all the paravirt_ops, we return to
-	 * lguest_init() where the rest of the fairly chaotic boot setup
-	 * occurs.
-	 *
-	 * The Host expects our first hypercall to tell it where our "struct
-	 * lguest_data" is, so we do that first. */
-	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
-
-	/* The native boot code sets up initial page tables immediately after
-	 * the kernel itself, and sets init_pg_tables_end so they're not
-	 * clobbered.  The Launcher places our initial pagetables somewhere at
-	 * the top of our physical memory, so we don't need extra space: set
-	 * init_pg_tables_end to the end of the kernel. */
-	init_pg_tables_end = __pa(pg0);
-
-	/* Load the %fs segment register (the per-cpu segment register) with
-	 * the normal data segment to get through booting. */
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
-
-	/* Clear the part of the kernel data which is expected to be zero.
-	 * Normally it will be anyway, but if we're loading from a bzImage with
-	 * CONFIG_RELOCATALE=y, the relocations will be sitting here. */
-	memset(__bss_start, 0, __bss_stop - __bss_start);
-
-	/* The Host uses the top of the Guest's virtual address space for the
-	 * Host<->Guest Switcher, and it tells us how much it needs in
-	 * lguest_data.reserve_mem, set up on the LGUEST_INIT hypercall. */
-	reserve_top_address(lguest_data.reserve_mem);
-
-	/* If we don't initialize the lock dependency checker now, it crashes
-	 * paravirt_disable_iospace. */
-	lockdep_init();
-
-	/* The IDE code spends about 3 seconds probing for disks: if we reserve
-	 * all the I/O ports up front it can't get them and so doesn't probe.
-	 * Other device drivers are similar (but less severe).  This cuts the
-	 * kernel boot time on my machine from 4.1 seconds to 0.45 seconds. */
-	paravirt_disable_iospace();
-
-	/* This is messy CPU setup stuff which the native boot code does before
-	 * start_kernel, so we have to do, too: */
-	cpu_detect(&new_cpu_data);
-	/* head.S usually sets up the first capability word, so do it here. */
-	new_cpu_data.x86_capability[0] = cpuid_edx(1);
-
-	/* Math is always hard! */
-	new_cpu_data.hard_math = 1;
-
-#ifdef CONFIG_X86_MCE
-	mce_disabled = 1;
-#endif
-#ifdef CONFIG_ACPI
-	acpi_disabled = 1;
-	acpi_ht = 0;
-#endif
-
-	/* We set the perferred console to "hvc".  This is the "hypervisor
-	 * virtual console" driver written by the PowerPC people, which we also
-	 * adapted for lguest's use. */
-	add_preferred_console("hvc", 0, NULL);
-
-	/* Last of all, we set the power management poweroff hook to point to
-	 * the Guest routine to power off. */
-	pm_power_off = lguest_power_off;
-
-	/* Now we're set up, call start_kernel() in init/main.c and we proceed
-	 * to boot as normal.  It never returns. */
-	start_kernel();
-}
-/*
- * This marks the end of stage II of our journey, The Guest.
- *
- * It is now time for us to explore the nooks and crannies of the three Guest
- * devices and complete our understanding of the Guest in "make Drivers".
- */
diff --git a/drivers/lguest/lguest_asm.S b/drivers/lguest/lguest_asm.S
deleted file mode 100644
index f182c6a..0000000
--- a/drivers/lguest/lguest_asm.S
+++ /dev/null
@@ -1,93 +0,0 @@
-#include <linux/linkage.h>
-#include <linux/lguest.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/processor-flags.h>
-
-/*G:020 This is where we begin: we have a magic signature which the launcher
- * looks for.  The plan is that the Linux boot protocol will be extended with a
- * "platform type" field which will guide us here from the normal entry point,
- * but for the moment this suffices.  The normal boot code uses %esi for the
- * boot header, so we do too.  We convert it to a virtual address by adding
- * PAGE_OFFSET, and hand it to lguest_init() as its argument (ie. %eax).
- *
- * The .section line puts this code in .init.text so it will be discarded after
- * boot. */
-.section .init.text, "ax", @progbits
-.ascii "GenuineLguest"
-	/* Set up initial stack. */
- 	movl $(init_thread_union+THREAD_SIZE),%esp
-	movl %esi, %eax
-	addl $__PAGE_OFFSET, %eax
-	jmp lguest_init
-
-/*G:055 We create a macro which puts the assembler code between lgstart_ and
- * lgend_ markers.  These templates end up in the .init.text section, so they
- * are discarded after boot. */
-#define LGUEST_PATCH(name, insns...)			\
-	lgstart_##name:	insns; lgend_##name:;		\
-	.globl lgstart_##name; .globl lgend_##name
-
-LGUEST_PATCH(cli, movl $0, lguest_data+LGUEST_DATA_irq_enabled)
-LGUEST_PATCH(sti, movl $X86_EFLAGS_IF, lguest_data+LGUEST_DATA_irq_enabled)
-LGUEST_PATCH(popf, movl %eax, lguest_data+LGUEST_DATA_irq_enabled)
-LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
-/*:*/
-
-.text
-/* These demark the EIP range where host should never deliver interrupts. */
-.global lguest_noirq_start
-.global lguest_noirq_end
-
-/*M:004 When the Host reflects a trap or injects an interrupt into the Guest,
- * it sets the eflags interrupt bit on the stack based on
- * lguest_data.irq_enabled, so the Guest iret logic does the right thing when
- * restoring it.  However, when the Host sets the Guest up for direct traps,
- * such as system calls, the processor is the one to push eflags onto the
- * stack, and the interrupt bit will be 1 (in reality, interrupts are always
- * enabled in the Guest).
- *
- * This turns out to be harmless: the only trap which should happen under Linux
- * with interrupts disabled is Page Fault (due to our lazy mapping of vmalloc
- * regions), which has to be reflected through the Host anyway.  If another
- * trap *does* go off when interrupts are disabled, the Guest will panic, and
- * we'll never get to this iret! :*/
-
-/*G:045 There is one final paravirt_op that the Guest implements, and glancing
- * at it you can see why I left it to last.  It's *cool*!  It's in *assembler*!
- *
- * The "iret" instruction is used to return from an interrupt or trap.  The
- * stack looks like this:
- *   old address
- *   old code segment & privilege level
- *   old processor flags ("eflags")
- *
- * The "iret" instruction pops those values off the stack and restores them all
- * at once.  The only problem is that eflags includes the Interrupt Flag which
- * the Guest can't change: the CPU will simply ignore it when we do an "iret".
- * So we have to copy eflags from the stack to lguest_data.irq_enabled before
- * we do the "iret".
- *
- * There are two problems with this: firstly, we need to use a register to do
- * the copy and secondly, the whole thing needs to be atomic.  The first
- * problem is easy to solve: push %eax on the stack so we can use it, and then
- * restore it at the end just before the real "iret".
- *
- * The second is harder: copying eflags to lguest_data.irq_enabled will turn
- * interrupts on before we're finished, so we could be interrupted before we
- * return to userspace or wherever.  Our solution to this is to surround the
- * code with lguest_noirq_start: and lguest_noirq_end: labels.  We tell the
- * Host that it is *never* to interrupt us there, even if interrupts seem to be
- * enabled. */
-ENTRY(lguest_iret)
-	pushl	%eax
-	movl	12(%esp), %eax
-lguest_noirq_start:
-	/* Note the %ss: segment prefix here.  Normal data accesses use the
-	 * "ds" segment, but that will have already been restored for whatever
-	 * we're returning to (such as userspace): we can't trust it.  The %ss:
-	 * prefix makes sure we use the stack segment, which is still valid. */
-	movl	%eax,%ss:lguest_data+LGUEST_DATA_irq_enabled
-	popl	%eax
-	iret
-lguest_noirq_end:
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
deleted file mode 100644
index 2f477df..0000000
--- a/drivers/lguest/lguest_user.c
+++ /dev/null
@@ -1,382 +0,0 @@
-/*P:200 This contains all the /dev/lguest code, whereby the userspace launcher
- * controls and communicates with the Guest.  For example, the first write will
- * tell us the memory size, pagetable, entry point and kernel address offset.
- * A read will run the Guest until a signal is pending (-EINTR), or the Guest
- * does a DMA out to the Launcher.  Writes are also used to get a DMA buffer
- * registered by the Guest and to send the Guest an interrupt. :*/
-#include <linux/uaccess.h>
-#include <linux/miscdevice.h>
-#include <linux/fs.h>
-#include <linux/lg.h>
-
-/*L:030 setup_regs() doesn't really belong in this file, but it gives us an
- * early glimpse deeper into the Host so it's worth having here.
- *
- * Most of the Guest's registers are left alone: we used get_zeroed_page() to
- * allocate the structure, so they will be 0. */
-static void setup_regs(struct lguest_regs *regs, unsigned long start)
-{
-	/* There are four "segment" registers which the Guest needs to boot:
-	 * The "code segment" register (cs) refers to the kernel code segment
-	 * __KERNEL_CS, and the "data", "extra" and "stack" segment registers
-	 * refer to the kernel data segment __KERNEL_DS.
-	 *
-	 * The privilege level is packed into the lower bits.  The Guest runs
-	 * at privilege level 1 (GUEST_PL).*/
-	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
-	regs->cs = __KERNEL_CS|GUEST_PL;
-
-	/* The "eflags" register contains miscellaneous flags.  Bit 1 (0x002)
-	 * is supposed to always be "1".  Bit 9 (0x200) controls whether
-	 * interrupts are enabled.  We always leave interrupts enabled while
-	 * running the Guest. */
-	regs->eflags = 0x202;
-
-	/* The "Extended Instruction Pointer" register says where the Guest is
-	 * running. */
-	regs->eip = start;
-
-	/* %esi points to our boot information, at physical address 0, so don't
-	 * touch it. */
-}
-
-/*L:310 To send DMA into the Guest, the Launcher needs to be able to ask for a
- * DMA buffer.  This is done by writing LHREQ_GETDMA and the key to
- * /dev/lguest. */
-static long user_get_dma(struct lguest *lg, const u32 __user *input)
-{
-	unsigned long key, udma, irq;
-
-	/* Fetch the key they wrote to us. */
-	if (get_user(key, input) != 0)
-		return -EFAULT;
-	/* Look for a free Guest DMA buffer bound to that key. */
-	udma = get_dma_buffer(lg, key, &irq);
-	if (!udma)
-		return -ENOENT;
-
-	/* We need to tell the Launcher what interrupt the Guest expects after
-	 * the buffer is filled.  We stash it in udma->used_len. */
-	lgwrite_u32(lg, udma + offsetof(struct lguest_dma, used_len), irq);
-
-	/* The (guest-physical) address of the DMA buffer is returned from
-	 * the write(). */
-	return udma;
-}
-
-/*L:315 To force the Guest to stop running and return to the Launcher, the
- * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
- * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
-static int break_guest_out(struct lguest *lg, const u32 __user *input)
-{
-	unsigned long on;
-
-	/* Fetch whether they're turning break on or off.. */
-	if (get_user(on, input) != 0)
-		return -EFAULT;
-
-	if (on) {
-		lg->break_out = 1;
-		/* Pop it out (may be running on different CPU) */
-		wake_up_process(lg->tsk);
-		/* Wait for them to reset it */
-		return wait_event_interruptible(lg->break_wq, !lg->break_out);
-	} else {
-		lg->break_out = 0;
-		wake_up(&lg->break_wq);
-		return 0;
-	}
-}
-
-/*L:050 Sending an interrupt is done by writing LHREQ_IRQ and an interrupt
- * number to /dev/lguest. */
-static int user_send_irq(struct lguest *lg, const u32 __user *input)
-{
-	u32 irq;
-
-	if (get_user(irq, input) != 0)
-		return -EFAULT;
-	if (irq >= LGUEST_IRQS)
-		return -EINVAL;
-	/* Next time the Guest runs, the core code will see if it can deliver
-	 * this interrupt. */
-	set_bit(irq, lg->irqs_pending);
-	return 0;
-}
-
-/*L:040 Once our Guest is initialized, the Launcher makes it run by reading
- * from /dev/lguest. */
-static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
-{
-	struct lguest *lg = file->private_data;
-
-	/* You must write LHREQ_INITIALIZE first! */
-	if (!lg)
-		return -EINVAL;
-
-	/* If you're not the task which owns the guest, go away. */
-	if (current != lg->tsk)
-		return -EPERM;
-
-	/* If the guest is already dead, we indicate why */
-	if (lg->dead) {
-		size_t len;
-
-		/* lg->dead either contains an error code, or a string. */
-		if (IS_ERR(lg->dead))
-			return PTR_ERR(lg->dead);
-
-		/* We can only return as much as the buffer they read with. */
-		len = min(size, strlen(lg->dead)+1);
-		if (copy_to_user(user, lg->dead, len) != 0)
-			return -EFAULT;
-		return len;
-	}
-
-	/* If we returned from read() last time because the Guest sent DMA,
-	 * clear the flag. */
-	if (lg->dma_is_pending)
-		lg->dma_is_pending = 0;
-
-	/* Run the Guest until something interesting happens. */
-	return run_guest(lg, (unsigned long __user *)user);
-}
-
-/*L:020 The initialization write supplies 4 32-bit values (in addition to the
- * 32-bit LHREQ_INITIALIZE value).  These are:
- *
- * pfnlimit: The highest (Guest-physical) page number the Guest should be
- * allowed to access.  The Launcher has to live in Guest memory, so it sets
- * this to ensure the Guest can't reach it.
- *
- * pgdir: The (Guest-physical) address of the top of the initial Guest
- * pagetables (which are set up by the Launcher).
- *
- * start: The first instruction to execute ("eip" in x86-speak).
- *
- * page_offset: The PAGE_OFFSET constant in the Guest kernel.  We should
- * probably wean the code off this, but it's a very useful constant!  Any
- * address above this is within the Guest kernel, and any kernel address can
- * quickly converted from physical to virtual by adding PAGE_OFFSET.  It's
- * 0xC0000000 (3G) by default, but it's configurable at kernel build time.
- */
-static int initialize(struct file *file, const u32 __user *input)
-{
-	/* "struct lguest" contains everything we (the Host) know about a
-	 * Guest. */
-	struct lguest *lg;
-	int err, i;
-	u32 args[4];
-
-	/* We grab the Big Lguest lock, which protects the global array
-	 * "lguests" and multiple simultaneous initializations. */
-	mutex_lock(&lguest_lock);
-	/* You can't initialize twice!  Close the device and start again... */
-	if (file->private_data) {
-		err = -EBUSY;
-		goto unlock;
-	}
-
-	if (copy_from_user(args, input, sizeof(args)) != 0) {
-		err = -EFAULT;
-		goto unlock;
-	}
-
-	/* Find an unused guest. */
-	i = find_free_guest();
-	if (i < 0) {
-		err = -ENOSPC;
-		goto unlock;
-	}
-	/* OK, we have an index into the "lguest" array: "lg" is a convenient
-	 * pointer. */
-	lg = &lguests[i];
-
-	/* Populate the easy fields of our "struct lguest" */
-	lg->guestid = i;
-	lg->pfn_limit = args[0];
-	lg->page_offset = args[3];
-
-	/* We need a complete page for the Guest registers: they are accessible
-	 * to the Guest and we can only grant it access to whole pages. */
-	lg->regs_page = get_zeroed_page(GFP_KERNEL);
-	if (!lg->regs_page) {
-		err = -ENOMEM;
-		goto release_guest;
-	}
-	/* We actually put the registers at the bottom of the page. */
-	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
-
-	/* Initialize the Guest's shadow page tables, using the toplevel
-	 * address the Launcher gave us.  This allocates memory, so can
-	 * fail. */
-	err = init_guest_pagetable(lg, args[1]);
-	if (err)
-		goto free_regs;
-
-	/* Now we initialize the Guest's registers, handing it the start
-	 * address. */
-	setup_regs(lg->regs, args[2]);
-
-	/* There are a couple of GDT entries the Guest expects when first
-	 * booting. */
-	setup_guest_gdt(lg);
-
-	/* The timer for lguest's clock needs initialization. */
-	init_clockdev(lg);
-
-	/* We keep a pointer to the Launcher task (ie. current task) for when
-	 * other Guests want to wake this one (inter-Guest I/O). */
-	lg->tsk = current;
-	/* We need to keep a pointer to the Launcher's memory map, because if
-	 * the Launcher dies we need to clean it up.  If we don't keep a
-	 * reference, it is destroyed before close() is called. */
-	lg->mm = get_task_mm(lg->tsk);
-
-	/* Initialize the queue for the waker to wait on */
-	init_waitqueue_head(&lg->break_wq);
-
-	/* We remember which CPU's pages this Guest used last, for optimization
-	 * when the same Guest runs on the same CPU twice. */
-	lg->last_pages = NULL;
-
-	/* We keep our "struct lguest" in the file's private_data. */
-	file->private_data = lg;
-
-	mutex_unlock(&lguest_lock);
-
-	/* And because this is a write() call, we return the length used. */
-	return sizeof(args);
-
-free_regs:
-	free_page(lg->regs_page);
-release_guest:
-	memset(lg, 0, sizeof(*lg));
-unlock:
-	mutex_unlock(&lguest_lock);
-	return err;
-}
-
-/*L:010 The first operation the Launcher does must be a write.  All writes
- * start with a 32 bit number: for the first write this must be
- * LHREQ_INITIALIZE to set up the Guest.  After that the Launcher can use
- * writes of other values to get DMA buffers and send interrupts. */
-static ssize_t write(struct file *file, const char __user *input,
-		     size_t size, loff_t *off)
-{
-	/* Once the guest is initialized, we hold the "struct lguest" in the
-	 * file private data. */
-	struct lguest *lg = file->private_data;
-	u32 req;
-
-	if (get_user(req, input) != 0)
-		return -EFAULT;
-	input += sizeof(req);
-
-	/* If you haven't initialized, you must do that first. */
-	if (req != LHREQ_INITIALIZE && !lg)
-		return -EINVAL;
-
-	/* Once the Guest is dead, all you can do is read() why it died. */
-	if (lg && lg->dead)
-		return -ENOENT;
-
-	/* If you're not the task which owns the Guest, you can only break */
-	if (lg && current != lg->tsk && req != LHREQ_BREAK)
-		return -EPERM;
-
-	switch (req) {
-	case LHREQ_INITIALIZE:
-		return initialize(file, (const u32 __user *)input);
-	case LHREQ_GETDMA:
-		return user_get_dma(lg, (const u32 __user *)input);
-	case LHREQ_IRQ:
-		return user_send_irq(lg, (const u32 __user *)input);
-	case LHREQ_BREAK:
-		return break_guest_out(lg, (const u32 __user *)input);
-	default:
-		return -EINVAL;
-	}
-}
-
-/*L:060 The final piece of interface code is the close() routine.  It reverses
- * everything done in initialize().  This is usually called because the
- * Launcher exited.
- *
- * Note that the close routine returns 0 or a negative error number: it can't
- * really fail, but it can whine.  I blame Sun for this wart, and K&R C for
- * letting them do it. :*/
-static int close(struct inode *inode, struct file *file)
-{
-	struct lguest *lg = file->private_data;
-
-	/* If we never successfully initialized, there's nothing to clean up */
-	if (!lg)
-		return 0;
-
-	/* We need the big lock, to protect from inter-guest I/O and other
-	 * Launchers initializing guests. */
-	mutex_lock(&lguest_lock);
-	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
-	hrtimer_cancel(&lg->hrt);
-	/* Free any DMA buffers the Guest had bound. */
-	release_all_dma(lg);
-	/* Free up the shadow page tables for the Guest. */
-	free_guest_pagetable(lg);
-	/* Now all the memory cleanups are done, it's safe to release the
-	 * Launcher's memory management structure. */
-	mmput(lg->mm);
-	/* If lg->dead doesn't contain an error code it will be NULL or a
-	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
-	if (!IS_ERR(lg->dead))
-		kfree(lg->dead);
-	/* We can free up the register page we allocated. */
-	free_page(lg->regs_page);
-	/* We clear the entire structure, which also marks it as free for the
-	 * next user. */
-	memset(lg, 0, sizeof(*lg));
-	/* Release lock and exit. */
-	mutex_unlock(&lguest_lock);
-
-	return 0;
-}
-
-/*L:000
- * Welcome to our journey through the Launcher!
- *
- * The Launcher is the Host userspace program which sets up, runs and services
- * the Guest.  In fact, many comments in the Drivers which refer to "the Host"
- * doing things are inaccurate: the Launcher does all the device handling for
- * the Guest.  The Guest can't tell what's done by the the Launcher and what by
- * the Host.
- *
- * Just to confuse you: to the Host kernel, the Launcher *is* the Guest and we
- * shall see more of that later.
- *
- * We begin our understanding with the Host kernel interface which the Launcher
- * uses: reading and writing a character device called /dev/lguest.  All the
- * work happens in the read(), write() and close() routines: */
-static struct file_operations lguest_fops = {
-	.owner	 = THIS_MODULE,
-	.release = close,
-	.write	 = write,
-	.read	 = read,
-};
-
-/* This is a textbook example of a "misc" character device.  Populate a "struct
- * miscdevice" and register it with misc_register(). */
-static struct miscdevice lguest_dev = {
-	.minor	= MISC_DYNAMIC_MINOR,
-	.name	= "lguest",
-	.fops	= &lguest_fops,
-};
-
-int __init lguest_device_init(void)
-{
-	return misc_register(&lguest_dev);
-}
-
-void __exit lguest_device_remove(void)
-{
-	misc_deregister(&lguest_dev);
-}
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
deleted file mode 100644
index 812d56a..0000000
--- a/drivers/lguest/page_tables.c
+++ /dev/null
@@ -1,680 +0,0 @@
-/*P:700 The pagetable code, on the other hand, still shows the scars of
- * previous encounters.  It's functional, and as neat as it can be in the
- * circumstances, but be wary, for these things are subtle and break easily.
- * The Guest provides a virtual to physical mapping, but we can neither trust
- * it nor use it: we verify and convert it here to point the hardware to the
- * actual Guest pages when running the Guest. :*/
-
-/* Copyright (C) Rusty Russell IBM Corporation 2006.
- * GPL v2 and any later version */
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <linux/random.h>
-#include <linux/percpu.h>
-#include <asm/tlbflush.h>
-#include <linux/lg.h>
-
-/*M:008 We hold reference to pages, which prevents them from being swapped.
- * It'd be nice to have a callback in the "struct mm_struct" when Linux wants
- * to swap out.  If we had this, and a shrinker callback to trim PTE pages, we
- * could probably consider launching Guests as non-root. :*/
-
-/*H:300
- * The Page Table Code
- *
- * We use two-level page tables for the Guest.  If you're not entirely
- * comfortable with virtual addresses, physical addresses and page tables then
- * I recommend you review lguest.c's "Page Table Handling" (with diagrams!).
- *
- * The Guest keeps page tables, but we maintain the actual ones here: these are
- * called "shadow" page tables.  Which is a very Guest-centric name: these are
- * the real page tables the CPU uses, although we keep them up to date to
- * reflect the Guest's.  (See what I mean about weird naming?  Since when do
- * shadows reflect anything?)
- *
- * Anyway, this is the most complicated part of the Host code.  There are seven
- * parts to this:
- *  (i) Setting up a page table entry for the Guest when it faults,
- *  (ii) Setting up the page table entry for the Guest stack,
- *  (iii) Setting up a page table entry when the Guest tells us it has changed,
- *  (iv) Switching page tables,
- *  (v) Flushing (thowing away) page tables,
- *  (vi) Mapping the Switcher when the Guest is about to run,
- *  (vii) Setting up the page tables initially.
- :*/
-
-/* Pages a 4k long, and each page table entry is 4 bytes long, giving us 1024
- * (or 2^10) entries per page. */
-#define PTES_PER_PAGE_SHIFT 10
-#define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
-
-/* 1024 entries in a page table page maps 1024 pages: 4MB.  The Switcher is
- * conveniently placed at the top 4MB, so it uses a separate, complete PTE
- * page.  */
-#define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
-
-/* We actually need a separate PTE page for each CPU.  Remember that after the
- * Switcher code itself comes two pages for each CPU, and we don't want this
- * CPU's guest to see the pages of any other CPU. */
-static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
-#define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
-
-/*H:320 With our shadow and Guest types established, we need to deal with
- * them: the page table code is curly enough to need helper functions to keep
- * it clear and clean.
- *
- * The first helper takes a virtual address, and says which entry in the top
- * level page table deals with that address.  Since each top level entry deals
- * with 4M, this effectively divides by 4M. */
-static unsigned vaddr_to_pgd_index(unsigned long vaddr)
-{
-	return vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
-}
-
-/* There are two functions which return pointers to the shadow (aka "real")
- * page tables.
- *
- * spgd_addr() takes the virtual address and returns a pointer to the top-level
- * page directory entry for that address.  Since we keep track of several page
- * tables, the "i" argument tells us which one we're interested in (it's
- * usually the current one). */
-static spgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
-{
-	unsigned int index = vaddr_to_pgd_index(vaddr);
-
-	/* We kill any Guest trying to touch the Switcher addresses. */
-	if (index >= SWITCHER_PGD_INDEX) {
-		kill_guest(lg, "attempt to access switcher pages");
-		index = 0;
-	}
-	/* Return a pointer index'th pgd entry for the i'th page table. */
-	return &lg->pgdirs[i].pgdir[index];
-}
-
-/* This routine then takes the PGD entry given above, which contains the
- * address of the PTE page.  It then returns a pointer to the PTE entry for the
- * given address. */
-static spte_t *spte_addr(struct lguest *lg, spgd_t spgd, unsigned long vaddr)
-{
-	spte_t *page = __va(spgd.pfn << PAGE_SHIFT);
-	/* You should never call this if the PGD entry wasn't valid */
-	BUG_ON(!(spgd.flags & _PAGE_PRESENT));
-	return &page[(vaddr >> PAGE_SHIFT) % PTES_PER_PAGE];
-}
-
-/* These two functions just like the above two, except they access the Guest
- * page tables.  Hence they return a Guest address. */
-static unsigned long gpgd_addr(struct lguest *lg, unsigned long vaddr)
-{
-	unsigned int index = vaddr >> (PAGE_SHIFT + PTES_PER_PAGE_SHIFT);
-	return lg->pgdirs[lg->pgdidx].cr3 + index * sizeof(gpgd_t);
-}
-
-static unsigned long gpte_addr(struct lguest *lg,
-			       gpgd_t gpgd, unsigned long vaddr)
-{
-	unsigned long gpage = gpgd.pfn << PAGE_SHIFT;
-	BUG_ON(!(gpgd.flags & _PAGE_PRESENT));
-	return gpage + ((vaddr>>PAGE_SHIFT) % PTES_PER_PAGE) * sizeof(gpte_t);
-}
-
-/*H:350 This routine takes a page number given by the Guest and converts it to
- * an actual, physical page number.  It can fail for several reasons: the
- * virtual address might not be mapped by the Launcher, the write flag is set
- * and the page is read-only, or the write flag was set and the page was
- * shared so had to be copied, but we ran out of memory.
- *
- * This holds a reference to the page, so release_pte() is careful to
- * put that back. */
-static unsigned long get_pfn(unsigned long virtpfn, int write)
-{
-	struct page *page;
-	/* This value indicates failure. */
-	unsigned long ret = -1UL;
-
-	/* get_user_pages() is a complex interface: it gets the "struct
-	 * vm_area_struct" and "struct page" assocated with a range of pages.
-	 * It also needs the task's mmap_sem held, and is not very quick.
-	 * It returns the number of pages it got. */
-	down_read(&current->mm->mmap_sem);
-	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
-			   1, write, 1, &page, NULL) == 1)
-		ret = page_to_pfn(page);
-	up_read(&current->mm->mmap_sem);
-	return ret;
-}
-
-/*H:340 Converting a Guest page table entry to a shadow (ie. real) page table
- * entry can be a little tricky.  The flags are (almost) the same, but the
- * Guest PTE contains a virtual page number: the CPU needs the real page
- * number. */
-static spte_t gpte_to_spte(struct lguest *lg, gpte_t gpte, int write)
-{
-	spte_t spte;
-	unsigned long pfn;
-
-	/* The Guest sets the global flag, because it thinks that it is using
-	 * PGE.  We only told it to use PGE so it would tell us whether it was
-	 * flushing a kernel mapping or a userspace mapping.  We don't actually
-	 * use the global bit, so throw it away. */
-	spte.flags = (gpte.flags & ~_PAGE_GLOBAL);
-
-	/* We need a temporary "unsigned long" variable to hold the answer from
-	 * get_pfn(), because it returns 0xFFFFFFFF on failure, which wouldn't
-	 * fit in spte.pfn.  get_pfn() finds the real physical number of the
-	 * page, given the virtual number. */
-	pfn = get_pfn(gpte.pfn, write);
-	if (pfn == -1UL) {
-		kill_guest(lg, "failed to get page %u", gpte.pfn);
-		/* When we destroy the Guest, we'll go through the shadow page
-		 * tables and release_pte() them.  Make sure we don't think
-		 * this one is valid! */
-		spte.flags = 0;
-	}
-	/* Now we assign the page number, and our shadow PTE is complete. */
-	spte.pfn = pfn;
-	return spte;
-}
-
-/*H:460 And to complete the chain, release_pte() looks like this: */
-static void release_pte(spte_t pte)
-{
-	/* Remember that get_user_pages() took a reference to the page, in
-	 * get_pfn()?  We have to put it back now. */
-	if (pte.flags & _PAGE_PRESENT)
-		put_page(pfn_to_page(pte.pfn));
-}
-/*:*/
-
-static void check_gpte(struct lguest *lg, gpte_t gpte)
-{
-	if ((gpte.flags & (_PAGE_PWT|_PAGE_PSE)) || gpte.pfn >= lg->pfn_limit)
-		kill_guest(lg, "bad page table entry");
-}
-
-static void check_gpgd(struct lguest *lg, gpgd_t gpgd)
-{
-	if ((gpgd.flags & ~_PAGE_TABLE) || gpgd.pfn >= lg->pfn_limit)
-		kill_guest(lg, "bad page directory entry");
-}
-
-/*H:330
- * (i) Setting up a page table entry for the Guest when it faults
- *
- * We saw this call in run_guest(): when we see a page fault in the Guest, we
- * come here.  That's because we only set up the shadow page tables lazily as
- * they're needed, so we get page faults all the time and quietly fix them up
- * and return to the Guest without it knowing.
- *
- * If we fixed up the fault (ie. we mapped the address), this routine returns
- * true. */
-int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
-{
-	gpgd_t gpgd;
-	spgd_t *spgd;
-	unsigned long gpte_ptr;
-	gpte_t gpte;
-	spte_t *spte;
-
-	/* First step: get the top-level Guest page table entry. */
-	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
-	/* Toplevel not present?  We can't map it in. */
-	if (!(gpgd.flags & _PAGE_PRESENT))
-		return 0;
-
-	/* Now look at the matching shadow entry. */
-	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
-	if (!(spgd->flags & _PAGE_PRESENT)) {
-		/* No shadow entry: allocate a new shadow PTE page. */
-		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
-		/* This is not really the Guest's fault, but killing it is
-		 * simple for this corner case. */
-		if (!ptepage) {
-			kill_guest(lg, "out of memory allocating pte page");
-			return 0;
-		}
-		/* We check that the Guest pgd is OK. */
-		check_gpgd(lg, gpgd);
-		/* And we copy the flags to the shadow PGD entry.  The page
-		 * number in the shadow PGD is the page we just allocated. */
-		spgd->raw.val = (__pa(ptepage) | gpgd.flags);
-	}
-
-	/* OK, now we look at the lower level in the Guest page table: keep its
-	 * address, because we might update it later. */
-	gpte_ptr = gpte_addr(lg, gpgd, vaddr);
-	gpte = mkgpte(lgread_u32(lg, gpte_ptr));
-
-	/* If this page isn't in the Guest page tables, we can't page it in. */
-	if (!(gpte.flags & _PAGE_PRESENT))
-		return 0;
-
-	/* Check they're not trying to write to a page the Guest wants
-	 * read-only (bit 2 of errcode == write). */
-	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
-		return 0;
-
-	/* User access to a kernel page? (bit 3 == user access) */
-	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
-		return 0;
-
-	/* Check that the Guest PTE flags are OK, and the page number is below
-	 * the pfn_limit (ie. not mapping the Launcher binary). */
-	check_gpte(lg, gpte);
-	/* Add the _PAGE_ACCESSED and (for a write) _PAGE_DIRTY flag */
-	gpte.flags |= _PAGE_ACCESSED;
-	if (errcode & 2)
-		gpte.flags |= _PAGE_DIRTY;
-
-	/* Get the pointer to the shadow PTE entry we're going to set. */
-	spte = spte_addr(lg, *spgd, vaddr);
-	/* If there was a valid shadow PTE entry here before, we release it.
-	 * This can happen with a write to a previously read-only entry. */
-	release_pte(*spte);
-
-	/* If this is a write, we insist that the Guest page is writable (the
-	 * final arg to gpte_to_spte()). */
-	if (gpte.flags & _PAGE_DIRTY)
-		*spte = gpte_to_spte(lg, gpte, 1);
-	else {
-		/* If this is a read, don't set the "writable" bit in the page
-		 * table entry, even if the Guest says it's writable.  That way
-		 * we come back here when a write does actually ocur, so we can
-		 * update the Guest's _PAGE_DIRTY flag. */
-		gpte_t ro_gpte = gpte;
-		ro_gpte.flags &= ~_PAGE_RW;
-		*spte = gpte_to_spte(lg, ro_gpte, 0);
-	}
-
-	/* Finally, we write the Guest PTE entry back: we've set the
-	 * _PAGE_ACCESSED and maybe the _PAGE_DIRTY flags. */
-	lgwrite_u32(lg, gpte_ptr, gpte.raw.val);
-
-	/* We succeeded in mapping the page! */
-	return 1;
-}
-
-/*H:360 (ii) Setting up the page table entry for the Guest stack.
- *
- * Remember pin_stack_pages() which makes sure the stack is mapped?  It could
- * simply call demand_page(), but as we've seen that logic is quite long, and
- * usually the stack pages are already mapped anyway, so it's not required.
- *
- * This is a quick version which answers the question: is this virtual address
- * mapped by the shadow page tables, and is it writable? */
-static int page_writable(struct lguest *lg, unsigned long vaddr)
-{
-	spgd_t *spgd;
-	unsigned long flags;
-
-	/* Look at the top level entry: is it present? */
-	spgd = spgd_addr(lg, lg->pgdidx, vaddr);
-	if (!(spgd->flags & _PAGE_PRESENT))
-		return 0;
-
-	/* Check the flags on the pte entry itself: it must be present and
-	 * writable. */
-	flags = spte_addr(lg, *spgd, vaddr)->flags;
-	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
-}
-
-/* So, when pin_stack_pages() asks us to pin a page, we check if it's already
- * in the page tables, and if not, we call demand_page() with error code 2
- * (meaning "write"). */
-void pin_page(struct lguest *lg, unsigned long vaddr)
-{
-	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
-		kill_guest(lg, "bad stack page %#lx", vaddr);
-}
-
-/*H:450 If we chase down the release_pgd() code, it looks like this: */
-static void release_pgd(struct lguest *lg, spgd_t *spgd)
-{
-	/* If the entry's not present, there's nothing to release. */
-	if (spgd->flags & _PAGE_PRESENT) {
-		unsigned int i;
-		/* Converting the pfn to find the actual PTE page is easy: turn
-		 * the page number into a physical address, then convert to a
-		 * virtual address (easy for kernel pages like this one). */
-		spte_t *ptepage = __va(spgd->pfn << PAGE_SHIFT);
-		/* For each entry in the page, we might need to release it. */
-		for (i = 0; i < PTES_PER_PAGE; i++)
-			release_pte(ptepage[i]);
-		/* Now we can free the page of PTEs */
-		free_page((long)ptepage);
-		/* And zero out the PGD entry we we never release it twice. */
-		spgd->raw.val = 0;
-	}
-}
-
-/*H:440 (v) Flushing (thowing away) page tables,
- *
- * We saw flush_user_mappings() called when we re-used a top-level pgdir page.
- * It simply releases every PTE page from 0 up to the kernel address. */
-static void flush_user_mappings(struct lguest *lg, int idx)
-{
-	unsigned int i;
-	/* Release every pgd entry up to the kernel's address. */
-	for (i = 0; i < vaddr_to_pgd_index(lg->page_offset); i++)
-		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
-}
-
-/* The Guest also has a hypercall to do this manually: it's used when a large
- * number of mappings have been changed. */
-void guest_pagetable_flush_user(struct lguest *lg)
-{
-	/* Drop the userspace part of the current page table. */
-	flush_user_mappings(lg, lg->pgdidx);
-}
-/*:*/
-
-/* We keep several page tables.  This is a simple routine to find the page
- * table (if any) corresponding to this top-level address the Guest has given
- * us. */
-static unsigned int find_pgdir(struct lguest *lg, unsigned long pgtable)
-{
-	unsigned int i;
-	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-		if (lg->pgdirs[i].cr3 == pgtable)
-			break;
-	return i;
-}
-
-/*H:435 And this is us, creating the new page directory.  If we really do
- * allocate a new one (and so the kernel parts are not there), we set
- * blank_pgdir. */
-static unsigned int new_pgdir(struct lguest *lg,
-			      unsigned long cr3,
-			      int *blank_pgdir)
-{
-	unsigned int next;
-
-	/* We pick one entry at random to throw out.  Choosing the Least
-	 * Recently Used might be better, but this is easy. */
-	next = random32() % ARRAY_SIZE(lg->pgdirs);
-	/* If it's never been allocated at all before, try now. */
-	if (!lg->pgdirs[next].pgdir) {
-		lg->pgdirs[next].pgdir = (spgd_t *)get_zeroed_page(GFP_KERNEL);
-		/* If the allocation fails, just keep using the one we have */
-		if (!lg->pgdirs[next].pgdir)
-			next = lg->pgdidx;
-		else
-			/* This is a blank page, so there are no kernel
-			 * mappings: caller must map the stack! */
-			*blank_pgdir = 1;
-	}
-	/* Record which Guest toplevel this shadows. */
-	lg->pgdirs[next].cr3 = cr3;
-	/* Release all the non-kernel mappings. */
-	flush_user_mappings(lg, next);
-
-	return next;
-}
-
-/*H:430 (iv) Switching page tables
- *
- * This is what happens when the Guest changes page tables (ie. changes the
- * top-level pgdir).  This happens on almost every context switch. */
-void guest_new_pagetable(struct lguest *lg, unsigned long pgtable)
-{
-	int newpgdir, repin = 0;
-
-	/* Look to see if we have this one already. */
-	newpgdir = find_pgdir(lg, pgtable);
-	/* If not, we allocate or mug an existing one: if it's a fresh one,
-	 * repin gets set to 1. */
-	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
-		newpgdir = new_pgdir(lg, pgtable, &repin);
-	/* Change the current pgd index to the new one. */
-	lg->pgdidx = newpgdir;
-	/* If it was completely blank, we map in the Guest kernel stack */
-	if (repin)
-		pin_stack_pages(lg);
-}
-
-/*H:470 Finally, a routine which throws away everything: all PGD entries in all
- * the shadow page tables.  This is used when we destroy the Guest. */
-static void release_all_pagetables(struct lguest *lg)
-{
-	unsigned int i, j;
-
-	/* Every shadow pagetable this Guest has */
-	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-		if (lg->pgdirs[i].pgdir)
-			/* Every PGD entry except the Switcher at the top */
-			for (j = 0; j < SWITCHER_PGD_INDEX; j++)
-				release_pgd(lg, lg->pgdirs[i].pgdir + j);
-}
-
-/* We also throw away everything when a Guest tells us it's changed a kernel
- * mapping.  Since kernel mappings are in every page table, it's easiest to
- * throw them all away.  This is amazingly slow, but thankfully rare. */
-void guest_pagetable_clear_all(struct lguest *lg)
-{
-	release_all_pagetables(lg);
-	/* We need the Guest kernel stack mapped again. */
-	pin_stack_pages(lg);
-}
-
-/*H:420 This is the routine which actually sets the page table entry for then
- * "idx"'th shadow page table.
- *
- * Normally, we can just throw out the old entry and replace it with 0: if they
- * use it demand_page() will put the new entry in.  We need to do this anyway:
- * The Guest expects _PAGE_ACCESSED to be set on its PTE the first time a page
- * is read from, and _PAGE_DIRTY when it's written to.
- *
- * But Avi Kivity pointed out that most Operating Systems (Linux included) set
- * these bits on PTEs immediately anyway.  This is done to save the CPU from
- * having to update them, but it helps us the same way: if they set
- * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
- * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
- */
-static void do_set_pte(struct lguest *lg, int idx,
-		       unsigned long vaddr, gpte_t gpte)
-{
-	/* Look up the matching shadow page directot entry. */
-	spgd_t *spgd = spgd_addr(lg, idx, vaddr);
-
-	/* If the top level isn't present, there's no entry to update. */
-	if (spgd->flags & _PAGE_PRESENT) {
-		/* Otherwise, we start by releasing the existing entry. */
-		spte_t *spte = spte_addr(lg, *spgd, vaddr);
-		release_pte(*spte);
-
-		/* If they're setting this entry as dirty or accessed, we might
-		 * as well put that entry they've given us in now.  This shaves
-		 * 10% off a copy-on-write micro-benchmark. */
-		if (gpte.flags & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
-			check_gpte(lg, gpte);
-			*spte = gpte_to_spte(lg, gpte, gpte.flags&_PAGE_DIRTY);
-		} else
-			/* Otherwise we can demand_page() it in later. */
-			spte->raw.val = 0;
-	}
-}
-
-/*H:410 Updating a PTE entry is a little trickier.
- *
- * We keep track of several different page tables (the Guest uses one for each
- * process, so it makes sense to cache at least a few).  Each of these have
- * identical kernel parts: ie. every mapping above PAGE_OFFSET is the same for
- * all processes.  So when the page table above that address changes, we update
- * all the page tables, not just the current one.  This is rare.
- *
- * The benefit is that when we have to track a new page table, we can copy keep
- * all the kernel mappings.  This speeds up context switch immensely. */
-void guest_set_pte(struct lguest *lg,
-		   unsigned long cr3, unsigned long vaddr, gpte_t gpte)
-{
-	/* Kernel mappings must be changed on all top levels.  Slow, but
-	 * doesn't happen often. */
-	if (vaddr >= lg->page_offset) {
-		unsigned int i;
-		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-			if (lg->pgdirs[i].pgdir)
-				do_set_pte(lg, i, vaddr, gpte);
-	} else {
-		/* Is this page table one we have a shadow for? */
-		int pgdir = find_pgdir(lg, cr3);
-		if (pgdir != ARRAY_SIZE(lg->pgdirs))
-			/* If so, do the update. */
-			do_set_pte(lg, pgdir, vaddr, gpte);
-	}
-}
-
-/*H:400
- * (iii) Setting up a page table entry when the Guest tells us it has changed.
- *
- * Just like we did in interrupts_and_traps.c, it makes sense for us to deal
- * with the other side of page tables while we're here: what happens when the
- * Guest asks for a page table to be updated?
- *
- * We already saw that demand_page() will fill in the shadow page tables when
- * needed, so we can simply remove shadow page table entries whenever the Guest
- * tells us they've changed.  When the Guest tries to use the new entry it will
- * fault and demand_page() will fix it up.
- *
- * So with that in mind here's our code to to update a (top-level) PGD entry:
- */
-void guest_set_pmd(struct lguest *lg, unsigned long cr3, u32 idx)
-{
-	int pgdir;
-
-	/* The kernel seems to try to initialize this early on: we ignore its
-	 * attempts to map over the Switcher. */
-	if (idx >= SWITCHER_PGD_INDEX)
-		return;
-
-	/* If they're talking about a page table we have a shadow for... */
-	pgdir = find_pgdir(lg, cr3);
-	if (pgdir < ARRAY_SIZE(lg->pgdirs))
-		/* ... throw it away. */
-		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
-}
-
-/*H:500 (vii) Setting up the page tables initially.
- *
- * When a Guest is first created, the Launcher tells us where the toplevel of
- * its first page table is.  We set some things up here: */
-int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
-{
-	/* In flush_user_mappings() we loop from 0 to
-	 * "vaddr_to_pgd_index(lg->page_offset)".  This assumes it won't hit
-	 * the Switcher mappings, so check that now. */
-	if (vaddr_to_pgd_index(lg->page_offset) >= SWITCHER_PGD_INDEX)
-		return -EINVAL;
-	/* We start on the first shadow page table, and give it a blank PGD
-	 * page. */
-	lg->pgdidx = 0;
-	lg->pgdirs[lg->pgdidx].cr3 = pgtable;
-	lg->pgdirs[lg->pgdidx].pgdir = (spgd_t*)get_zeroed_page(GFP_KERNEL);
-	if (!lg->pgdirs[lg->pgdidx].pgdir)
-		return -ENOMEM;
-	return 0;
-}
-
-/* When a Guest dies, our cleanup is fairly simple. */
-void free_guest_pagetable(struct lguest *lg)
-{
-	unsigned int i;
-
-	/* Throw away all page table pages. */
-	release_all_pagetables(lg);
-	/* Now free the top levels: free_page() can handle 0 just fine. */
-	for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-		free_page((long)lg->pgdirs[i].pgdir);
-}
-
-/*H:480 (vi) Mapping the Switcher when the Guest is about to run.
- *
- * The Switcher and the two pages for this CPU need to be available to the
- * Guest (and not the pages for other CPUs).  We have the appropriate PTE pages
- * for each CPU already set up, we just need to hook them in. */
-void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages)
-{
-	spte_t *switcher_pte_page = __get_cpu_var(switcher_pte_pages);
-	spgd_t switcher_pgd;
-	spte_t regs_pte;
-
-	/* Make the last PGD entry for this Guest point to the Switcher's PTE
-	 * page for this CPU (with appropriate flags). */
-	switcher_pgd.pfn = __pa(switcher_pte_page) >> PAGE_SHIFT;
-	switcher_pgd.flags = _PAGE_KERNEL;
-	lg->pgdirs[lg->pgdidx].pgdir[SWITCHER_PGD_INDEX] = switcher_pgd;
-
-	/* We also change the Switcher PTE page.  When we're running the Guest,
-	 * we want the Guest's "regs" page to appear where the first Switcher
-	 * page for this CPU is.  This is an optimization: when the Switcher
-	 * saves the Guest registers, it saves them into the first page of this
-	 * CPU's "struct lguest_pages": if we make sure the Guest's register
-	 * page is already mapped there, we don't have to copy them out
-	 * again. */
-	regs_pte.pfn = __pa(lg->regs_page) >> PAGE_SHIFT;
-	regs_pte.flags = _PAGE_KERNEL;
-	switcher_pte_page[(unsigned long)pages/PAGE_SIZE%PTES_PER_PAGE]
-		= regs_pte;
-}
-/*:*/
-
-static void free_switcher_pte_pages(void)
-{
-	unsigned int i;
-
-	for_each_possible_cpu(i)
-		free_page((long)switcher_pte_page(i));
-}
-
-/*H:520 Setting up the Switcher PTE page for given CPU is fairly easy, given
- * the CPU number and the "struct page"s for the Switcher code itself.
- *
- * Currently the Switcher is less than a page long, so "pages" is always 1. */
-static __init void populate_switcher_pte_page(unsigned int cpu,
-					      struct page *switcher_page[],
-					      unsigned int pages)
-{
-	unsigned int i;
-	spte_t *pte = switcher_pte_page(cpu);
-
-	/* The first entries are easy: they map the Switcher code. */
-	for (i = 0; i < pages; i++) {
-		pte[i].pfn = page_to_pfn(switcher_page[i]);
-		pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
-	}
-
-	/* The only other thing we map is this CPU's pair of pages. */
-	i = pages + cpu*2;
-
-	/* First page (Guest registers) is writable from the Guest */
-	pte[i].pfn = page_to_pfn(switcher_page[i]);
-	pte[i].flags = _PAGE_PRESENT|_PAGE_ACCESSED|_PAGE_RW;
-	/* The second page contains the "struct lguest_ro_state", and is
-	 * read-only. */
-	pte[i+1].pfn = page_to_pfn(switcher_page[i+1]);
-	pte[i+1].flags = _PAGE_PRESENT|_PAGE_ACCESSED;
-}
-
-/*H:510 At boot or module load time, init_pagetables() allocates and populates
- * the Switcher PTE page for each CPU. */
-__init int init_pagetables(struct page **switcher_page, unsigned int pages)
-{
-	unsigned int i;
-
-	for_each_possible_cpu(i) {
-		switcher_pte_page(i) = (spte_t *)get_zeroed_page(GFP_KERNEL);
-		if (!switcher_pte_page(i)) {
-			free_switcher_pte_pages();
-			return -ENOMEM;
-		}
-		populate_switcher_pte_page(i, switcher_page, pages);
-	}
-	return 0;
-}
-/*:*/
-
-/* Cleaning up simply involves freeing the PTE page for each CPU. */
-void free_pagetables(void)
-{
-	free_switcher_pte_pages();
-}
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
deleted file mode 100644
index 351b13f..0000000
--- a/drivers/lguest/segments.c
+++ /dev/null
@@ -1,229 +0,0 @@
-/*P:600 The x86 architecture has segments, which involve a table of descriptors
- * which can be used to do funky things with virtual address interpretation.
- * We originally used to use segments so the Guest couldn't alter the
- * Guest<->Host Switcher, and then we had to trim Guest segments, and restore
- * for userspace per-thread segments, but trim again for on userspace->kernel
- * transitions...  This nightmarish creation was contained within this file,
- * where we knew not to tread without heavy armament and a change of underwear.
- *
- * In these modern times, the segment handling code consists of simple sanity
- * checks, and the worst you'll experience reading this code is butterfly-rash
- * from frolicking through its parklike serenity. :*/
-#include <linux/lg.h>
-
-/*H:600
- * We've almost completed the Host; there's just one file to go!
- *
- * Segments & The Global Descriptor Table
- *
- * (That title sounds like a bad Nerdcore group.  Not to suggest that there are
- * any good Nerdcore groups, but in high school a friend of mine had a band
- * called Joe Fish and the Chips, so there are definitely worse band names).
- *
- * To refresh: the GDT is a table of 8-byte values describing segments.  Once
- * set up, these segments can be loaded into one of the 6 "segment registers".
- *
- * GDT entries are passed around as "struct desc_struct"s, which like IDT
- * entries are split into two 32-bit members, "a" and "b".  One day, someone
- * will clean that up, and be declared a Hero.  (No pressure, I'm just saying).
- *
- * Anyway, the GDT entry contains a base (the start address of the segment), a
- * limit (the size of the segment - 1), and some flags.  Sounds simple, and it
- * would be, except those zany Intel engineers decided that it was too boring
- * to put the base at one end, the limit at the other, and the flags in
- * between.  They decided to shotgun the bits at random throughout the 8 bytes,
- * like so:
- *
- * 0               16                     40       48  52  56     63
- * [ limit part 1 ][     base part 1     ][ flags ][li][fl][base ]
- *                                                  mit ags part 2
- *                                                part 2
- *
- * As a result, this file contains a certain amount of magic numeracy.  Let's
- * begin.
- */
-
-/* Is the descriptor the Guest wants us to put in OK?
- *
- * The flag which Intel says must be zero: must be zero.  The descriptor must
- * be present, (this is actually checked earlier but is here for thorougness),
- * and the descriptor type must be 1 (a memory segment).  */
-static int desc_ok(const struct desc_struct *gdt)
-{
-	return ((gdt->b & 0x00209000) == 0x00009000);
-}
-
-/* Is the segment present?  (Otherwise it can't be used by the Guest). */
-static int segment_present(const struct desc_struct *gdt)
-{
-	return gdt->b & 0x8000;
-}
-
-/* There are several entries we don't let the Guest set.  The TSS entry is the
- * "Task State Segment" which controls all kinds of delicate things.  The
- * LGUEST_CS and LGUEST_DS entries are reserved for the Switcher, and the
- * the Guest can't be trusted to deal with double faults. */
-static int ignored_gdt(unsigned int num)
-{
-	return (num == GDT_ENTRY_TSS
-		|| num == GDT_ENTRY_LGUEST_CS
-		|| num == GDT_ENTRY_LGUEST_DS
-		|| num == GDT_ENTRY_DOUBLEFAULT_TSS);
-}
-
-/* If the Guest asks us to remove an entry from the GDT, we have to be careful.
- * If one of the segment registers is pointing at that entry the Switcher will
- * crash when it tries to reload the segment registers for the Guest.
- *
- * It doesn't make much sense for the Guest to try to remove its own code, data
- * or stack segments while they're in use: assume that's a Guest bug.  If it's
- * one of the lesser segment registers using the removed entry, we simply set
- * that register to 0 (unusable). */
-static void check_segment_use(struct lguest *lg, unsigned int desc)
-{
-	/* GDT entries are 8 bytes long, so we divide to get the index and
-	 * ignore the bottom bits. */
-	if (lg->regs->gs / 8 == desc)
-		lg->regs->gs = 0;
-	if (lg->regs->fs / 8 == desc)
-		lg->regs->fs = 0;
-	if (lg->regs->es / 8 == desc)
-		lg->regs->es = 0;
-	if (lg->regs->ds / 8 == desc
-	    || lg->regs->cs / 8 == desc
-	    || lg->regs->ss / 8 == desc)
-		kill_guest(lg, "Removed live GDT entry %u", desc);
-}
-/*:*/
-/*M:009 We wouldn't need to check for removal of in-use segments if we handled
- * faults in the Switcher.  However, it's probably not a worthwhile
- * optimization. :*/
-
-/*H:610 Once the GDT has been changed, we look through the changed entries and
- * see if they're OK.  If not, we'll call kill_guest() and the Guest will never
- * get to use the invalid entries. */
-static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
-{
-	unsigned int i;
-
-	for (i = start; i < end; i++) {
-		/* We never copy these ones to real GDT, so we don't care what
-		 * they say */
-		if (ignored_gdt(i))
-			continue;
-
-		/* We could fault in switch_to_guest if they are using
-		 * a removed segment. */
-		if (!segment_present(&lg->gdt[i])) {
-			check_segment_use(lg, i);
-			continue;
-		}
-
-		if (!desc_ok(&lg->gdt[i]))
-			kill_guest(lg, "Bad GDT descriptor %i", i);
-
-		/* Segment descriptors contain a privilege level: the Guest is
-		 * sometimes careless and leaves this as 0, even though it's
-		 * running at privilege level 1.  If so, we fix it here. */
-		if ((lg->gdt[i].b & 0x00006000) == 0)
-			lg->gdt[i].b |= (GUEST_PL << 13);
-
-		/* Each descriptor has an "accessed" bit.  If we don't set it
-		 * now, the CPU will try to set it when the Guest first loads
-		 * that entry into a segment register.  But the GDT isn't
-		 * writable by the Guest, so bad things can happen. */
-		lg->gdt[i].b |= 0x00000100;
-	}
-}
-
-/* This routine is called at boot or modprobe time for each CPU to set up the
- * "constant" GDT entries for Guests running on that CPU. */
-void setup_default_gdt_entries(struct lguest_ro_state *state)
-{
-	struct desc_struct *gdt = state->guest_gdt;
-	unsigned long tss = (unsigned long)&state->guest_tss;
-
-	/* The hypervisor segments are full 0-4G segments, privilege level 0 */
-	gdt[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
-	gdt[GDT_ENTRY_LGUEST_DS] = FULL_SEGMENT;
-
-	/* The TSS segment refers to the TSS entry for this CPU, so we cannot
-	 * copy it from the Guest.  Forgive the magic flags */
-	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
-	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
-		| ((tss >> 16) & 0x000000FF);
-}
-
-/* This routine is called before the Guest is run for the first time. */
-void setup_guest_gdt(struct lguest *lg)
-{
-	/* Start with full 0-4G segments... */
-	lg->gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
-	lg->gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
-	/* ...except the Guest is allowed to use them, so set the privilege
-	 * level appropriately in the flags. */
-	lg->gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
-	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
-}
-
-/* Like the IDT, we never simply use the GDT the Guest gives us.  We set up the
- * GDTs for each CPU, then we copy across the entries each time we want to run
- * a different Guest on that CPU. */
-
-/* A partial GDT load, for the three "thead-local storage" entries.  Otherwise
- * it's just like load_guest_gdt().  So much, in fact, it would probably be
- * neater to have a single hypercall to cover both. */
-void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
-{
-	unsigned int i;
-
-	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
-		gdt[i] = lg->gdt[i];
-}
-
-/* This is the full version */
-void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
-{
-	unsigned int i;
-
-	/* The default entries from setup_default_gdt_entries() are not
-	 * replaced.  See ignored_gdt() above. */
-	for (i = 0; i < GDT_ENTRIES; i++)
-		if (!ignored_gdt(i))
-			gdt[i] = lg->gdt[i];
-}
-
-/* This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT). */
-void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
-{
-	/* We assume the Guest has the same number of GDT entries as the
-	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
-	if (num > ARRAY_SIZE(lg->gdt))
-		kill_guest(lg, "too many gdt entries %i", num);
-
-	/* We read the whole thing in, then fix it up. */
-	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
-	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
-	/* Mark that the GDT changed so the core knows it has to copy it again,
-	 * even if the Guest is run on the same CPU. */
-	lg->changed |= CHANGED_GDT;
-}
-
-void guest_load_tls(struct lguest *lg, unsigned long gtls)
-{
-	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
-
-	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
-	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
-	lg->changed |= CHANGED_GDT_TLS;
-}
-
-/*
- * With this, we have finished the Host.
- *
- * Five of the seven parts of our task are complete.  You have made it through
- * the Bit of Despair (I think that's somewhere in the page table code,
- * myself).
- *
- * Next, we examine "make Switcher".  It's short, but intense.
- */
diff --git a/drivers/lguest/switcher.S b/drivers/lguest/switcher.S
deleted file mode 100644
index 40382f6..0000000
--- a/drivers/lguest/switcher.S
+++ /dev/null
@@ -1,347 +0,0 @@
-/*P:900 This is the Switcher: code which sits at 0xFFC00000 to do the low-level
- * Guest<->Host switch.  It is as simple as it can be made, but it's naturally
- * very specific to x86.
- *
- * You have now completed Preparation.  If this has whet your appetite; if you
- * are feeling invigorated and refreshed then the next, more challenging stage
- * can be found in "make Guest". :*/
-
-/*S:100
- * Welcome to the Switcher itself!
- *
- * This file contains the low-level code which changes the CPU to run the Guest
- * code, and returns to the Host when something happens.  Understand this, and
- * you understand the heart of our journey.
- *
- * Because this is in assembler rather than C, our tale switches from prose to
- * verse.  First I tried limericks:
- *
- *	There once was an eax reg,
- *	To which our pointer was fed,
- *	It needed an add,
- *	Which asm-offsets.h had
- *	But this limerick is hurting my head.
- *
- * Next I tried haikus, but fitting the required reference to the seasons in
- * every stanza was quickly becoming tiresome:
- *
- *	The %eax reg
- *	Holds "struct lguest_pages" now:
- *	Cherry blossoms fall.
- *
- * Then I started with Heroic Verse, but the rhyming requirement leeched away
- * the content density and led to some uniquely awful oblique rhymes:
- *
- *	These constants are coming from struct offsets
- *	For use within the asm switcher text.
- *
- * Finally, I settled for something between heroic hexameter, and normal prose
- * with inappropriate linebreaks.  Anyway, it aint no Shakespeare.
- */
-
-// Not all kernel headers work from assembler
-// But these ones are needed: the ENTRY() define
-// And constants extracted from struct offsets
-// To avoid magic numbers and breakage:
-// Should they change the compiler can't save us
-// Down here in the depths of assembler code.
-#include <linux/linkage.h>
-#include <asm/asm-offsets.h>
-#include <asm/lg.h>
-
-// We mark the start of the code to copy
-// It's placed in .text tho it's never run here
-// You'll see the trick macro at the end
-// Which interleaves data and text to effect.
-.text
-ENTRY(start_switcher_text)
-
-// When we reach switch_to_guest we have just left
-// The safe and comforting shores of C code
-// %eax has the "struct lguest_pages" to use
-// Where we save state and still see it from the Guest
-// And %ebx holds the Guest shadow pagetable:
-// Once set we have truly left Host behind.
-ENTRY(switch_to_guest)
-	// We told gcc all its regs could fade,
-	// Clobbered by our journey into the Guest
-	// We could have saved them, if we tried
-	// But time is our master and cycles count.
-
-	// Segment registers must be saved for the Host
-	// We push them on the Host stack for later
-	pushl	%es
-	pushl	%ds
-	pushl	%gs
-	pushl	%fs
-	// But the compiler is fickle, and heeds
-	// No warning of %ebp clobbers
-	// When frame pointers are used.  That register
-	// Must be saved and restored or chaos strikes.
-	pushl	%ebp
-	// The Host's stack is done, now save it away
-	// In our "struct lguest_pages" at offset
-	// Distilled into asm-offsets.h
-	movl	%esp, LGUEST_PAGES_host_sp(%eax)
-
-	// All saved and there's now five steps before us:
-	// Stack, GDT, IDT, TSS
-	// And last of all the page tables are flipped.
-
-	// Yet beware that our stack pointer must be
-	// Always valid lest an NMI hits
-	// %edx does the duty here as we juggle
-	// %eax is lguest_pages: our stack lies within.
-	movl	%eax, %edx
-	addl	$LGUEST_PAGES_regs, %edx
-	movl	%edx, %esp
-
-	// The Guest's GDT we so carefully
-	// Placed in the "struct lguest_pages" before
-	lgdt	LGUEST_PAGES_guest_gdt_desc(%eax)
-
-	// The Guest's IDT we did partially
-	// Move to the "struct lguest_pages" as well.
-	lidt	LGUEST_PAGES_guest_idt_desc(%eax)
-
-	// The TSS entry which controls traps
-	// Must be loaded up with "ltr" now:
-	// For after we switch over our page tables
-	// It (as the rest) will be writable no more.
-	// (The GDT entry TSS needs
-	// Changes type when we load it: damn Intel!)
-	movl	$(GDT_ENTRY_TSS*8), %edx
-	ltr	%dx
-
-	// Look back now, before we take this last step!
-	// The Host's TSS entry was also marked used;
-	// Let's clear it again, ere we return.
-	// The GDT descriptor of the Host
-	// Points to the table after two "size" bytes
-	movl	(LGUEST_PAGES_host_gdt_desc+2)(%eax), %edx
-	// Clear the type field of "used" (byte 5, bit 2)
-	andb	$0xFD, (GDT_ENTRY_TSS*8 + 5)(%edx)
-
-	// Once our page table's switched, the Guest is live!
-	// The Host fades as we run this final step.
-	// Our "struct lguest_pages" is now read-only.
-	movl	%ebx, %cr3
-
-	// The page table change did one tricky thing:
-	// The Guest's register page has been mapped
-	// Writable onto our %esp (stack) --
-	// We can simply pop off all Guest regs.
-	popl	%ebx
-	popl	%ecx
-	popl	%edx
-	popl	%esi
-	popl	%edi
-	popl	%ebp
-	popl	%gs
-	popl	%eax
-	popl	%fs
-	popl	%ds
-	popl	%es
-
-	// Near the base of the stack lurk two strange fields
-	// Which we fill as we exit the Guest
-	// These are the trap number and its error
-	// We can simply step past them on our way.
-	addl	$8, %esp
-
-	// The last five stack slots hold return address
-	// And everything needed to change privilege
-	// Into the Guest privilege level of 1,
-	// And the stack where the Guest had last left it.
-	// Interrupts are turned back on: we are Guest.
-	iret
-
-// There are two paths where we switch to the Host
-// So we put the routine in a macro.
-// We are on our way home, back to the Host
-// Interrupted out of the Guest, we come here.
-#define SWITCH_TO_HOST							\
-	/* We save the Guest state: all registers first			\
-	 * Laid out just as "struct lguest_regs" defines */		\
-	pushl	%es;							\
-	pushl	%ds;							\
-	pushl	%fs;							\
-	pushl	%eax;							\
-	pushl	%gs;							\
-	pushl	%ebp;							\
-	pushl	%edi;							\
-	pushl	%esi;							\
-	pushl	%edx;							\
-	pushl	%ecx;							\
-	pushl	%ebx;							\
-	/* Our stack and our code are using segments			\
-	 * Set in the TSS and IDT					\
-	 * Yet if we were to touch data we'd use			\
-	 * Whatever data segment the Guest had.				\
-	 * Load the lguest ds segment for now. */			\
-	movl	$(LGUEST_DS), %eax;					\
-	movl	%eax, %ds;						\
-	/* So where are we?  Which CPU, which struct?			\
-	 * The stack is our clue: our TSS sets				\
-	 * It at the end of "struct lguest_pages"			\
-	 * And we then pushed and pushed and pushed Guest regs:		\
-	 * Now stack points atop the "struct lguest_regs".   		\
-	 * Subtract that offset, and we find our struct. */		\
-	movl	%esp, %eax;						\
-	subl	$LGUEST_PAGES_regs, %eax;				\
-	/* Save our trap number: the switch will obscure it		\
-	 * (The Guest regs are not mapped here in the Host)		\
-	 * %ebx holds it safe for deliver_to_host */			\
-	movl	LGUEST_PAGES_regs_trapnum(%eax), %ebx;			\
-	/* The Host GDT, IDT and stack!					\
-	 * All these lie safely hidden from the Guest:			\
-	 * We must return to the Host page tables			\
-	 * (Hence that was saved in struct lguest_pages) */		\
-	movl	LGUEST_PAGES_host_cr3(%eax), %edx;			\
-	movl	%edx, %cr3;						\
-	/* As before, when we looked back at the Host			\
-	 * As we left and marked TSS unused				\
-	 * So must we now for the Guest left behind. */			\
-	andb	$0xFD, (LGUEST_PAGES_guest_gdt+GDT_ENTRY_TSS*8+5)(%eax); \
-	/* Switch to Host's GDT, IDT. */				\
-	lgdt	LGUEST_PAGES_host_gdt_desc(%eax);			\
-	lidt	LGUEST_PAGES_host_idt_desc(%eax);			\
-	/* Restore the Host's stack where it's saved regs lie */	\
-	movl	LGUEST_PAGES_host_sp(%eax), %esp;			\
-	/* Last the TSS: our Host is complete */			\
-	movl	$(GDT_ENTRY_TSS*8), %edx;				\
-	ltr	%dx;							\
-	/* Restore now the regs saved right at the first. */		\
-	popl	%ebp;							\
-	popl	%fs;							\
-	popl	%gs;							\
-	popl	%ds;							\
-	popl	%es
-
-// Here's where we come when the Guest has just trapped:
-// (Which trap we'll see has been pushed on the stack).
-// We need only switch back, and the Host will decode
-// Why we came home, and what needs to be done.
-return_to_host:
-	SWITCH_TO_HOST
-	iret
-
-// An interrupt, with some cause external
-// Has ajerked us rudely from the Guest's code
-// Again we must return home to the Host
-deliver_to_host:
-	SWITCH_TO_HOST
-	// But now we must go home via that place
-	// Where that interrupt was supposed to go
-	// Had we not been ensconced, running the Guest.
-	// Here we see the cleverness of our stack:
-	// The Host stack is formed like an interrupt
-	// With EIP, CS and EFLAGS layered.
-	// Interrupt handlers end with "iret"
-	// And that will take us home at long long last.
-
-	// But first we must find the handler to call!
-	// The IDT descriptor for the Host
-	// Has two bytes for size, and four for address:
-	// %edx will hold it for us for now.
-	movl	(LGUEST_PAGES_host_idt_desc+2)(%eax), %edx
-	// We now know the table address we need,
-	// And saved the trap's number inside %ebx.
-	// Yet the pointer to the handler is smeared
-	// Across the bits of the table entry.
-	// What oracle can tell us how to extract
-	// From such a convoluted encoding?
-	// I consulted gcc, and it gave
-	// These instructions, which I gladly credit:
-	leal	(%edx,%ebx,8), %eax
-	movzwl	(%eax),%edx
-	movl	4(%eax), %eax
-	xorw	%ax, %ax
-	orl	%eax, %edx
-	// Now the address of the handler's in %edx
-	// We call it now: its "iret" takes us home.
-	jmp	*%edx
-
-// Every interrupt can come to us here
-// But we must truly tell each apart.
-// They number two hundred and fifty six
-// And each must land in a different spot,
-// Push its number on stack, and join the stream.
-
-// And worse, a mere six of the traps stand apart
-// And push on their stack an addition:
-// An error number, thirty two bits long
-// So we punish the other two fifty
-// And make them push a zero so they match.
-
-// Yet two fifty six entries is long
-// And all will look most the same as the last
-// So we create a macro which can make
-// As many entries as we need to fill.
-
-// Note the change to .data then .text:
-// We plant the address of each entry
-// Into a (data) table for the Host
-// To know where each Guest interrupt should go.
-.macro IRQ_STUB N TARGET
-	.data; .long 1f; .text; 1:
- // Trap eight, ten through fourteen and seventeen
- // Supply an error number.  Else zero.
- .if (\N <> 8) && (\N < 10 || \N > 14) && (\N <> 17)
-	pushl	$0
- .endif
-	pushl	$\N
-	jmp	\TARGET
-	ALIGN
-.endm
-
-// This macro creates numerous entries
-// Using GAS macros which out-power C's.
-.macro IRQ_STUBS FIRST LAST TARGET
- irq=\FIRST
- .rept \LAST-\FIRST+1
-	IRQ_STUB irq \TARGET
-  irq=irq+1
- .endr
-.endm
-
-// Here's the marker for our pointer table
-// Laid in the data section just before
-// Each macro places the address of code
-// Forming an array: each one points to text
-// Which handles interrupt in its turn.
-.data
-.global default_idt_entries
-default_idt_entries:
-.text
-	// The first two traps go straight back to the Host
-	IRQ_STUBS 0 1 return_to_host
-	// We'll say nothing, yet, about NMI
-	IRQ_STUB 2 handle_nmi
-	// Other traps also return to the Host
-	IRQ_STUBS 3 31 return_to_host
-	// All interrupts go via their handlers
-	IRQ_STUBS 32 127 deliver_to_host
-	// 'Cept system calls coming from userspace
-	// Are to go to the Guest, never the Host.
-	IRQ_STUB 128 return_to_host
-	IRQ_STUBS 129 255 deliver_to_host
-
-// The NMI, what a fabulous beast
-// Which swoops in and stops us no matter that
-// We're suspended between heaven and hell,
-// (Or more likely between the Host and Guest)
-// When in it comes!  We are dazed and confused
-// So we do the simplest thing which one can.
-// Though we've pushed the trap number and zero
-// We discard them, return, and hope we live.
-handle_nmi:
-	addl	$8, %esp
-	iret
-
-// We are done; all that's left is Mastery
-// And "make Mastery" is a journey long
-// Designed to make your fingers itch to code.
-
-// Here ends the text, the file and poem.
-ENTRY(end_switcher_text)
-- 
1.4.4.4

-- 
