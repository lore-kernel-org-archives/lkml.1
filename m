Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbXEDNCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbXEDNCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEDNCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:02:44 -0400
Received: from ozlabs.org ([203.10.76.45]:49044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbXEDNCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:02:41 -0400
Subject: [RFC PATCH 2/3] lguest: Boot with virtual == physical to get
	closer to native Linux.
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1178283582.23670.67.camel@localhost.localdomain>
References: <1178283582.23670.67.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 May 2007 23:02:04 +1000
Message-Id: <1178283724.23670.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This won't be very interesting to the paravirt discussion, it only
changes lguest).

1) This allows us to get alot closer to booting bzImages.

2) It means we don't have to know page_offset.

3) The Guest needs to modify the boot pagetables to create the
   PAGE_OFFSET mapping before jumping to C code.

4) guest_pa() walks the page tables rather than using page_offset.

5) We don't use page_offset to figure out whether to emulate: it was
   always kinda questionable, and won't work for instructions done
   before remapping (bzImage unpacking in particular).

6) We still want the kernel address for tlb flushing: have the initial
   hypercall give us that, too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 04ffad46c687 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Fri May 04 22:30:51 2007 +1000
+++ b/Documentation/lguest/lguest.c	Fri May 04 22:49:27 2007 +1000
@@ -143,15 +143,12 @@ static void *map_zeroed_pages(unsigned l
  * by all modern binaries on Linux including the kernel.
  *
  * The ELF headers give *two* addresses: a physical address, and a virtual
- * address.  The Guest kernel expects to be placed in memory at the physical
- * address, and the page tables set up so it will correspond to that virtual
- * address.  We return the difference between the virtual and physical
- * addresses in the "page_offset" pointer.
+ * address.  We use the physical address; the Guest will map itself to the
+ * virtual address.
  *
  * We also return the starting address (which will be the address of the
  * startup_32 routine): */
-static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr,
-			     unsigned long *page_offset)
+static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr)
 {
 	void *addr;
 	Elf32_Phdr phdr[ehdr->e_phnum];
@@ -175,9 +172,6 @@ static unsigned long map_elf(int elf_fd,
 	if (read(elf_fd, phdr, sizeof(phdr)) != sizeof(phdr))
 		err(1, "Reading program headers");
 
-	/* We don't know page_offset yet. */
-	*page_offset = 0;
-
 	/* Try all the headers: there are usually only three.  A read-only one,
 	 * a read-write one, and a "note" section which isn't loadable. */
 	for (i = 0; i < ehdr->e_phnum; i++) {
@@ -187,14 +181,6 @@ static unsigned long map_elf(int elf_fd,
 
 		verbose("Section %i: size %i addr %p\n",
 			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
-
-		/* We expect a simple linear address space: every segment must
-		 * have the same difference between virtual (p_vaddr) and
-		 * physical (p_paddr) address. */
-		if (!*page_offset)
-			*page_offset = phdr[i].p_vaddr - phdr[i].p_paddr;
-		else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
-			errx(1, "Page offset of section %i different", i);
 
 		/* We map this section of the file at its physical address.  We
 		 * map it read & write even if the header says this segment is
@@ -215,53 +201,14 @@ static unsigned long map_elf(int elf_fd,
 			    i, addr, (void *)phdr[i].p_paddr);
 	}
 
-	/* The ELF header gives us the physical starting address.  We want the
-	 * virtual address in this case, and fortunately, we already figured
-	 * out the physical-virtual difference and put it in "page_offset". */
-	return ehdr->e_entry + *page_offset;
-}
-
-/*L:170 Prepare to be SHOCKED and AMAZED.  And possibly a trifle nauseated.
- *
- * We know that CONFIG_PAGE_OFFSET sets what virtual address the kernel expects
- * to be.  We don't know what that option was, but we can figure it out
- * approximately by looking at the addresses in the code.  I chose the common
- * case of reading a memory location into the %eax register:
- *
- *  movl <some-address>, %eax
- *
- * This gets encoded as five bytes: "0xA1 <4-byte-address>".  For example,
- * "0xA1 0x18 0x60 0x47 0xC0" reads the address 0xC0476018 into %eax.
- *
- * In this example can guess that the kernel was compiled with
- * CONFIG_PAGE_OFFSET set to 0xC0000000 (it's always a round number).  If the
- * kernel were larger than 16MB, we might see 0xC1 addresses show up, but our
- * kernel isn't that bloated yet.
- *
- * Unfortunately, x86 has variable-length instructions, so finding this
- * particular instruction properly involves writing a disassembler.  Instead,
- * we rely on statistics.  We look for "0xA1" and tally the different bytes
- * which occur 4 bytes later (the "0xC0" in our example above).  When one of
- * those bytes appears three times, we can be reasonably confident that it
- * forms the start of CONFIG_PAGE_OFFSET.
- *
- * This is amazingly reliable. */
-static unsigned long intuit_page_offset(unsigned char *img, unsigned long len)
-{
-	unsigned int i, possibilities[256] = { 0 };
-
-	for (i = 0; i + 4 < len; i++) {
-		/* mov 0xXXXXXXXX,%eax */
-		if (img[i] == 0xA1 && ++possibilities[img[i+4]] > 3)
-			return (unsigned long)img[i+4] << 24;
-	}
-	errx(1, "could not determine page offset");
+	/* The ELF header gives us the starting address. */
+	return ehdr->e_entry;
 }
 
 /*L:160 Unfortunately the entire ELF image isn't compressed: the segments
  * which need loading are extracted and compressed raw.  This denies us the
  * information we need to make a fully-general loader. */
-static unsigned long unpack_bzimage(int fd, unsigned long *page_offset)
+static unsigned long unpack_bzimage(int fd)
 {
 	gzFile f;
 	int ret, len = 0;
@@ -282,13 +229,8 @@ static unsigned long unpack_bzimage(int 
 
 	verbose("Unpacked size %i addr %p\n", len, img);
 
-	/* Without the ELF header, we can't tell virtual-physical gap.  This is
-	 * CONFIG_PAGE_OFFSET, and people do actually change it.  Fortunately,
-	 * I have a clever way of figuring it out from the code itself.  */
-	*page_offset = intuit_page_offset(img, len);
-
 	/* Entry is physical address: convert to virtual */
-	return (unsigned long)img + *page_offset;
+	return (unsigned long)img;
 }
 
 /*L:150 A bzImage, unlike an ELF file, is not meant to be loaded.  You're
@@ -299,7 +241,7 @@ static unsigned long unpack_bzimage(int 
  * The bzImage is formed by putting the decompressing code in front of the
  * compressed kernel code.  So we can simple scan through it looking for the
  * first "gzip" header, and start decompressing from there. */
-static unsigned long load_bzimage(int fd, unsigned long *page_offset)
+static unsigned long load_bzimage(int fd)
 {
 	unsigned char c;
 	int state = 0;
@@ -327,7 +269,7 @@ static unsigned long load_bzimage(int fd
 			if (c != 0x03)
 				state = -1;
 			else
-				return unpack_bzimage(fd, page_offset);
+				return unpack_bzimage(fd);
 		}
 	}
 	errx(1, "Could not find kernel in bzImage");
@@ -336,7 +278,7 @@ static unsigned long load_bzimage(int fd
 /*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels
  * come wrapped up in the self-decompressing "bzImage" format.  With some funky
  * coding, we can load those, too. */
-static unsigned long load_kernel(int fd, unsigned long *page_offset)
+static unsigned long load_kernel(int fd)
 {
 	Elf32_Ehdr hdr;
 
@@ -346,10 +288,10 @@ static unsigned long load_kernel(int fd,
 
 	/* If it's an ELF file, it starts with "\177ELF" */
 	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG) == 0)
-		return map_elf(fd, &hdr, page_offset);
+		return map_elf(fd, &hdr);
 
 	/* Otherwise we assume it's a bzImage, and try to unpack it */
-	return load_bzimage(fd, page_offset);
+	return load_bzimage(fd);
 }
 
 /* This is a trivial little helper to align pages.  Andi Kleen hated it because
@@ -401,27 +343,20 @@ static unsigned long load_initrd(const c
 	return len;
 }
 
-/* Once we know how much memory we have, and the address the Guest kernel
- * expects, we can construct simple linear page tables which will get the Guest
- * far enough into the boot to create its own.
+/* Once we know how much memory we have, we can construct simple linear page
+ * tables which set virtual == physical which will get the Guest far enough
+ * into the boot to create its own.
  *
  * We lay them out of the way, just below the initrd (which is why we need to
  * know its size). */
 static unsigned long setup_pagetables(unsigned long mem,
-				      unsigned long initrd_size,
-				      unsigned long page_offset)
+				      unsigned long initrd_size)
 {
 	u32 *pgdir, *linear;
 	unsigned int mapped_pages, i, linear_pages;
 	unsigned int ptes_per_page = getpagesize()/sizeof(u32);
 
-	/* Ideally we map all physical memory starting at page_offset.
-	 * However, if page_offset is 0xC0000000 we can only map 1G of physical
-	 * (0xC0000000 + 1G overflows). */
-	if (mem > -page_offset)
-		mapped_pages = mem/getpagesize();
-	else
-		mapped_pages = -page_offset/getpagesize();
+	mapped_pages = mem/getpagesize();
 
 	/* Each PTE page can map ptes_per_page pages: how many do we need? */
 	linear_pages = (mapped_pages + ptes_per_page-1)/ptes_per_page;
@@ -438,11 +373,9 @@ static unsigned long setup_pagetables(un
 	for (i = 0; i < mapped_pages; i++)
 		linear[i] = ((i * getpagesize()) | PAGE_PRESENT);
 
-	/* The top level points to the linear page table pages above.  The
-	 * entry representing page_offset points to the first one, and they
-	 * continue from there. */
+	/* The top level points to the linear page table pages above. */
 	for (i = 0; i < mapped_pages; i += ptes_per_page) {
-		pgdir[(i + page_offset/getpagesize())/ptes_per_page]
+		pgdir[i/ptes_per_page]
 			= (((u32)linear + i*sizeof(u32)) | PAGE_PRESENT);
 	}
 
@@ -471,13 +404,13 @@ static void concat(char *dst, char *args
 
 /* This is where we actually tell the kernel to initialize the Guest.  We saw
  * the arguments it expects when we looked at initialize() in lguest_user.c:
- * the top physical page to allow, the top level pagetable, the entry point and
- * the page_offset constant for the Guest. */
-static int tell_kernel(u32 pgdir, u32 start, u32 page_offset)
+ * the top physical page to allow, the top level pagetable, and the entry point
+ * into the Guest. */
+static int tell_kernel(u32 pgdir, u32 start)
 {
 	u32 args[] = { LHREQ_INITIALIZE,
 		       LGUEST_GUEST_TOP/getpagesize(), /* Just below us */
-		       pgdir, start, page_offset };
+		       pgdir, start };
 	int fd;
 
 	fd = open_or_die("/dev/lguest", O_RDWR);
@@ -1442,9 +1375,9 @@ static void usage(void)
  */
 int main(int argc, char *argv[])
 {
-	/* Memory, top-level pagetable, code startpoint, PAGE_OFFSET and size
-	 * of the (optional) initrd. */
-	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
+	/* Memory, top-level pagetable, code startpoint and size of the
+	 * (optional) initrd. */
+	unsigned long mem, pgdir, start, initrd_size = 0;
 	/* A temporary, the /dev/lguest file descriptor, and a waker fd. */
 	int c, lguest_fd, waker_fd;
 	/* The list of Guest devices, based on command line arguments. */
@@ -1504,8 +1437,7 @@ int main(int argc, char *argv[])
 	map_zeroed_pages(0, mem / getpagesize());
 
 	/* Now we load the kernel */
-	start = load_kernel(open_or_die(argv[optind+1], O_RDONLY),
-			    &page_offset);
+	start = load_kernel(open_or_die(argv[optind+1], O_RDONLY));
 
 	/* Write the device descriptors into memory for the Guest to know what
 	 * devices it has.  The descriptors are mapped just above normal
@@ -1526,7 +1458,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* Set up the initial linear pagetables, starting below the initrd. */
-	pgdir = setup_pagetables(mem, initrd_size, page_offset);
+	pgdir = setup_pagetables(mem, initrd_size);
 
 	/* The Linux boot header contains an "E820" memory map: ours is a
 	 * simple, single region. */
@@ -1544,7 +1476,7 @@ int main(int argc, char *argv[])
 
 	/* We tell the kernel to initialize the Guest: this returns the open
 	 * /dev/lguest file descriptor. */
-	lguest_fd = tell_kernel(pgdir, start, page_offset);
+	lguest_fd = tell_kernel(pgdir, start);
 
 	/* We fork off a child process, which wakes the Launcher whenever one
 	 * of the input file descriptors needs attention.  Otherwise we would
diff -r 04ffad46c687 arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c	Fri May 04 22:30:51 2007 +1000
+++ b/arch/i386/kernel/asm-offsets.c	Fri May 04 22:37:09 2007 +1000
@@ -124,6 +124,7 @@ void foo(void)
 #ifdef CONFIG_LGUEST_GUEST
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
 	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
diff -r 04ffad46c687 drivers/lguest/Makefile
--- a/drivers/lguest/Makefile	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/Makefile	Fri May 04 22:37:09 2007 +1000
@@ -5,6 +5,8 @@ obj-$(CONFIG_LGUEST)	+= lg.o
 obj-$(CONFIG_LGUEST)	+= lg.o
 lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o switcher.o
+
+CFLAGS_interrupts_and_traps.o := -O0
 
 Preparation Preparation!: PREFIX=P
 Guest: PREFIX=G
diff -r 04ffad46c687 drivers/lguest/core.c
--- a/drivers/lguest/core.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/core.c	Fri May 04 22:37:42 2007 +1000
@@ -262,12 +262,13 @@ static int emulate_insn(struct lguest *l
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
 	/* The eip contains the *virtual* address of the Guest's instruction:
-	 * guest_pa just subtracts the Guest's page_offset. */
+	 * guest_pa maps that to the guest-physical address. */
 	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
 
-	/* The guest_pa() function only works for Guest kernel addresses, but
-	 * that's all we're trying to do anyway. */
-	if (lg->regs->eip < lg->page_offset)
+	/* This must be the Guest kernel trying to do something, not userspace!
+	 * The bottom two bits of the "cs" segment register are the privilege
+	 * level. */
+	if ((lg->regs->cs & 3) != GUEST_PL)
 		return 0;
 
 	/* Decoding x86 instructions is icky. */
diff -r 04ffad46c687 drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/hypercalls.c	Fri May 04 22:37:09 2007 +1000
@@ -221,12 +221,12 @@ static void initialize(struct lguest *lg
 	 * the range of addresses into "struct lguest_data". */
 	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
 	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
-	    /* We tell the Guest that it can't use the top 4MB of virtual
-	     * addresses used by the Switcher. */
-	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
 	    /* We also give the Guest a unique id, as used in lguest_net.c. */
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+
+	/* page_tables.c will also do some setup. */
+	page_table_guest_data_init(lg);
 
 	/* This is the one case where the above accesses might have been the
 	 * first write to a Guest page.  This may have caused a copy-on-write
diff -r 04ffad46c687 drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/interrupts_and_traps.c	Fri May 04 22:37:09 2007 +1000
@@ -54,8 +54,9 @@ static void push_guest_stack(struct lgue
  * it). */
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
 {
-	u32 __user *gstack;
+	u32 __user *gstack, *origstack;
 	u32 eflags, ss, irq_enable;
+	unsigned long virtstack;
 
 	/* There are two cases for interrupts: one where the Guest is already
 	 * in the kernel, and a more complex one where the Guest is in
@@ -63,8 +64,10 @@ static void set_guest_interrupt(struct l
 	if ((lg->regs->ss&0x3) != GUEST_PL) {
 		/* The Guest told us their kernel stack with the SET_STACK
 		 * hypercall: both the virtual address and the segment */
-		gstack = (u32 __user *)guest_pa(lg, lg->esp1);
+		virtstack = lg->esp1;
 		ss = lg->ss1;
+
+		origstack = gstack = (u32 __user *)guest_pa(lg, virtstack);
 		/* We push the old stack segment and pointer onto the new
 		 * stack: when the Guest does an "iret" back from the interrupt
 		 * handler the CPU will notice they're dropping privilege
@@ -73,8 +76,10 @@ static void set_guest_interrupt(struct l
 		push_guest_stack(lg, &gstack, lg->regs->esp);
 	} else {
 		/* We're staying on the same Guest (kernel) stack. */
-		gstack = (u32 __user *)guest_pa(lg, lg->regs->esp);
+		virtstack = lg->regs->esp;
 		ss = lg->regs->ss;
+
+		origstack = gstack = (u32 __user *)guest_pa(lg, virtstack);
 	}
 
 	/* Remember that we never let the Guest actually disable interrupts, so
@@ -100,7 +105,7 @@ static void set_guest_interrupt(struct l
 	/* Now we've pushed all the old state, we change the stack, the code
 	 * segment and the address to execute. */
 	lg->regs->ss = ss;
-	lg->regs->esp = (u32)gstack + lg->page_offset;
+	lg->regs->esp = virtstack + (gstack - origstack)*sizeof(unsigned long);
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
diff -r 04ffad46c687 drivers/lguest/lg.h
--- a/drivers/lguest/lg.h	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/lg.h	Fri May 04 22:37:09 2007 +1000
@@ -142,7 +142,7 @@ struct lguest
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
 	u16 guestid;
 	u32 pfn_limit;
-	u32 page_offset;
+	unsigned long kernel_address;
 	u32 cr2;
 	int halted;
 	int ts;
@@ -231,6 +231,8 @@ void map_switcher_in_guest(struct lguest
 void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
 int demand_page(struct lguest *info, unsigned long cr2, int errcode);
 void pin_page(struct lguest *lg, unsigned long vaddr);
+unsigned long guest_pa(struct lguest *lg, unsigned long vaddr);
+void page_table_guest_data_init(struct lguest *lg);
 
 /* lguest_user.c: */
 int lguest_device_init(void);
@@ -283,9 +285,5 @@ do {								\
 } while(0)
 /* (End of aside) :*/
 
-static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
-{
-	return vaddr - lg->page_offset;
-}
 #endif	/* __ASSEMBLY__ */
 #endif	/* _LGUEST_H */
diff -r 04ffad46c687 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri May 04 22:40:31 2007 +1000
@@ -83,6 +83,7 @@ struct lguest_data lguest_data = {
 	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
 	.noirq_start = (u32)lguest_noirq_start,
 	.noirq_end = (u32)lguest_noirq_end,
+	.kernel_address = PAGE_OFFSET,
 	.blocked_interrupts = { 1 }, /* Block timer interrupts */
 };
 struct lguest_device_desc *lguest_devices;
@@ -869,11 +870,7 @@ __init void do_lguest_init(void *boot)
 
 	/*G:070 Now we've seen all the paravirt_ops, we return to
 	 * do_lguest_init() where the rest of the fairly chaotic boot setup
-	 * occurs.
-	 *
-	 * The Host expects our first hypercall to tell it where our "struct
-	 * lguest_data" is, so we do that first. */
-	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
+	 * occurs. */
 
 	/* The native boot code sets up initial page tables immediately after
 	 * the kernel itself, and sets init_pg_tables_end so they're not
diff -r 04ffad46c687 drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Fri May 04 22:37:09 2007 +1000
@@ -8,19 +8,40 @@
 #define X86_EFLAGS_IF 0x00000200
 
 /*G:020 This is where we begin: head.S notes that we're not running at
- * privilege level 0 (as we would be in native boot) and looks at the
- * platform type field in the boot structure (address in %esi).  If 1 (lguest),
- * it calls here.
+ * privilege level 0 (as we would be in native boot) and looks at the platform
+ * type field in the boot structure (address in %esi).  If 1 (lguest), it calls
+ * here.  We have to be careful though: we're running at low addresses, not
+ * above PAGE_OFFSET as expected (eg. 0xC0000000).
  *
  * The .section line puts this code in .init.text so it will be discarded after
  * boot. */
 .section .init.text, "ax", @progbits
 ENTRY(lguest_init)
+	/* Make initial hypercall now, so we can set up the pagetables. */
+	movl $LHCALL_LGUEST_INIT, %eax
+	movl $lguest_data - __PAGE_OFFSET, %edx
+	int $LGUEST_TRAP_ENTRY
+
+	/* Set up boot information pointer to hand to do_lguest_init() */
+	movl %esi, %eax
+	addl $__PAGE_OFFSET, %eax
+
+	/* Current toplevel is now in lguest_data.pgdir. */
+	movl lguest_data - __PAGE_OFFSET + LGUEST_DATA_pgdir, %esi
+
+	/* Copy first 32 entries of page directory to __PAGE_OFFSET entries. */
+	movl $32, %ecx
+	movl %esi, %edi
+	addl $((__PAGE_OFFSET >> 22) * 4), %edi
+	rep
+	movsl
+
 	/* Set up initial stack. */
  	movl $(init_thread_union+THREAD_SIZE),%esp
-	/* Hand boot information pointer to do_lguest_init() */
-	movl %esi, %eax
-	jmp do_lguest_init
+
+	/* Jumps are relative, and we're running __PAGE_OFFSET too low at the
+	 * moment. */
+	jmp do_lguest_init+__PAGE_OFFSET
 
 /*G:055 We create a macro which puts the assembler code between lgstart_ and
  * lgend_ markers.  These templates end up in the .init.text section, so they
diff -r 04ffad46c687 drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/lguest_user.c	Fri May 04 22:37:09 2007 +1000
@@ -14,9 +14,7 @@
  *
  * Most of the Guest's registers are left alone: we used get_zeroed_page() to
  * allocate the structure, so they will be 0. */
-static void setup_regs(struct lguest_regs *regs,
-		       unsigned long start,
-		       unsigned long page_offset)
+static void setup_regs(struct lguest_regs *regs, unsigned long start)
 {
 	/* There are four "segment" registers which the Guest needs to boot:
 	 * The "code segment" register (cs) refers to the kernel code segment
@@ -38,9 +36,8 @@ static void setup_regs(struct lguest_reg
 	 * running. */
 	regs->eip = start;
 
-	/* %esi points to the virtual address of the boot information (it's at
-	 * physical address 0 == virtual address page_offset). */
-	regs->esi = page_offset;
+	/* %esi must point to the address of the boot information (at 0), and
+	 * it already does, so we don't touch it here. */
 }
 
 /*L:310 To send DMA into the Guest, the Launcher needs to be able to ask for a
@@ -117,7 +114,7 @@ static ssize_t read(struct file *file, c
 	return run_guest(lg, user);
 }
 
-/*L:020 The initialization write supplies 4 32-bit values (in addition to the
+/*L:020 The initialization write supplies 3 32-bit values (in addition to the
  * 32-bit LHREQ_INITIALIZE value).  These are:
  *
  * pfnlimit: The highest (Guest-physical) page number the Guest should be
@@ -128,12 +125,6 @@ static ssize_t read(struct file *file, c
  * pagetables (which are set up by the Launcher).
  *
  * start: The first instruction to execute ("eip" in x86-speak).
- *
- * page_offset: The PAGE_OFFSET constant in the Guest kernel.  We should
- * probably wean the code off this, but it's a very useful constant!  Any
- * address above this is within the Guest kernel, and any kernel address can
- * quickly converted from physical to virtual by adding PAGE_OFFSET.  It's
- * 0xC0000000 (3G) by default, but it's configurable at kernel build time.
  */
 static int initialize(struct file *file, const u32 __user *input)
 {
@@ -141,7 +132,7 @@ static int initialize(struct file *file,
 	 * Guest. */
 	struct lguest *lg;
 	int err, i;
-	u32 args[4];
+	u32 args[3];
 
 	/* You can't initialize twice!  Close the device and start again... */
 	if (file->private_data)
@@ -166,7 +157,6 @@ static int initialize(struct file *file,
 	/* Populate the easy fields of our "struct lguest" */
 	lg->guestid = i;
 	lg->pfn_limit = args[0];
-	lg->page_offset = args[3];
 
 	/* We need a complete page for the Guest registers: they are accessible
 	 * to the Guest and we can only grant it access to whole pages. */
@@ -187,7 +177,7 @@ static int initialize(struct file *file,
 
 	/* Now we initialize the Guest's registers, handing it the start
 	 * address. */
-	setup_regs(lg->regs, args[2], lg->page_offset);
+	setup_regs(lg->regs, args[2]);
 
 	/* There are a couple of GDT entries the Guest expects when first
 	 * booting. */
diff -r 04ffad46c687 drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c	Fri May 04 22:30:51 2007 +1000
+++ b/drivers/lguest/page_tables.c	Fri May 04 22:37:09 2007 +1000
@@ -13,6 +13,7 @@
 #include <linux/random.h>
 #include <linux/percpu.h>
 #include <asm/tlbflush.h>
+#include <asm/uaccess.h>
 #include "lg.h"
 
 /*M:008 We hold reference to pages, which prevents them from being swapped.
@@ -356,7 +357,7 @@ static void flush_user_mappings(struct l
 {
 	unsigned int i;
 	/* Release every pgd entry up to the kernel's address. */
-	for (i = 0; i < vaddr_to_pgd_index(lg->page_offset); i++)
+	for (i = 0; i < vaddr_to_pgd_index(lg->kernel_address); i++)
 		release_pgd(lg, lg->pgdirs[idx].pgdir + i);
 }
 
@@ -368,6 +369,25 @@ void guest_pagetable_flush_user(struct l
 	flush_user_mappings(lg, lg->pgdidx);
 }
 /*:*/
+
+/* We walk down the guest page tables to get a guest-physical address */
+unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
+{
+	gpgd_t gpgd;
+	gpte_t gpte;
+
+	/* First step: get the top-level Guest page table entry. */
+	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
+	/* Toplevel not present?  We can't map it in. */
+	if (!(gpgd.flags & _PAGE_PRESENT))
+		kill_guest(lg, "Bad address %#lx", vaddr);
+
+	gpte = mkgpte(lgread_u32(lg, gpte_addr(lg, gpgd, vaddr)));
+	if (!(gpgd.flags & _PAGE_PRESENT))
+		kill_guest(lg, "Bad address %#lx", vaddr);
+
+	return gpte.pfn * PAGE_SIZE | (vaddr & ~PAGE_MASK);
+}
 
 /* We keep several page tables.  This is a simple routine to find the page
  * table (if any) corresponding to this top-level address the Guest has given
@@ -510,7 +530,7 @@ void guest_set_pte(struct lguest *lg,
 {
 	/* Kernel mappings must be changed on all top levels.  Slow, but
 	 * doesn't happen often. */
-	if (vaddr >= lg->page_offset) {
+	if (vaddr >= lg->kernel_address) {
 		unsigned int i;
 		for (i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
 			if (lg->pgdirs[i].pgdir)
@@ -560,11 +580,6 @@ void guest_set_pmd(struct lguest *lg, un
  * its first page table is.  We set some things up here: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
 {
-	/* In flush_user_mappings() we loop from 0 to
-	 * "vaddr_to_pgd_index(lg->page_offset)".  This assumes it won't hit
-	 * the Switcher mappings, so check that now. */
-	if (vaddr_to_pgd_index(lg->page_offset) >= SWITCHER_PGD_INDEX)
-		return -EINVAL;
 	/* We start on the first shadow page table, and give it a blank PGD
 	 * page. */
 	lg->pgdidx = 0;
@@ -573,6 +588,24 @@ int init_guest_pagetable(struct lguest *
 	if (!lg->pgdirs[lg->pgdidx].pgdir)
 		return -ENOMEM;
 	return 0;
+}
+
+/* When the Guest calls LHCALL_LGUEST_INIT we do more setup. */
+void page_table_guest_data_init(struct lguest *lg)
+{
+	/* We get the kernel address: above this is all kernel memory. */
+	if (get_user(lg->kernel_address, &lg->lguest_data->kernel_address)
+	    /* We tell the Guest that it can't use the top 4MB of virtual
+	     * addresses used by the Switcher. */
+	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(lg->pgdirs[lg->pgdidx].cr3, &lg->lguest_data->pgdir))
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+
+	/* In flush_user_mappings() we loop from 0 to
+	 * "vaddr_to_pgd_index(lg->kernel_address)".  This assumes it won't hit
+	 * the Switcher mappings, so check that now. */
+	if (vaddr_to_pgd_index(lg->kernel_address) >= SWITCHER_PGD_INDEX)
+		kill_guest(lg, "bad kernel address %#lx", lg->kernel_address);
 }
 
 /* When a Guest dies, our cleanup is fairly simple. */
diff -r 04ffad46c687 include/linux/lguest.h
--- a/include/linux/lguest.h	Fri May 04 22:30:51 2007 +1000
+++ b/include/linux/lguest.h	Fri May 04 22:37:09 2007 +1000
@@ -2,9 +2,6 @@
  * this is subject to wild and random change between versions. */
 #ifndef _ASM_LGUEST_H
 #define _ASM_LGUEST_H
-
-#ifndef __ASSEMBLY__
-#include <asm/irq.h>
 
 #define LHCALL_FLUSH_ASYNC	0
 #define LHCALL_LGUEST_INIT	1
@@ -24,6 +21,11 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 
+#define LGUEST_TRAP_ENTRY 0x1F
+
+#ifndef __ASSEMBLY__
+#include <asm/irq.h>
+
 /*G:031 First, how does our Guest contact the Host to ask for privileged
  * operations?  There are two ways: the direct way is to make a "hypercall",
  * to make requests of the Host Itself.
@@ -37,8 +39,6 @@
  * Grossly invalid calls result in Sudden Death at the hands of the vengeful
  * Host, rather than returning failure.  This reflects Winston Churchill's
  * definition of a gentleman: "someone who is only rude intentionally". */
-#define LGUEST_TRAP_ENTRY 0x1F
-
 static inline unsigned long
 hcall(unsigned long call,
       unsigned long arg1, unsigned long arg2, unsigned long arg3)
@@ -99,10 +99,14 @@ struct lguest_data
 	unsigned long reserve_mem;
 	/* ID of this Guest (used by network driver to set ethernet address) */
 	u16 guestid;
+	/* Page where the top-level pagetable is */
+	unsigned long pgdir;
 
 /* Fields initialized by the Guest at boot: */
 	/* Instruction range to suppress interrupts even if enabled */
 	unsigned long noirq_start, noirq_end;
+	/* Address above which we can assume page tables don't often change. */
+	unsigned long kernel_address;
 };
 extern struct lguest_data lguest_data;
 #endif /* __ASSEMBLY__ */


