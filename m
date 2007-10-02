Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXJBXkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXJBXkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXJBXk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:40:29 -0400
Received: from ozlabs.org ([203.10.76.45]:56587 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914AbXJBXk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:40:27 -0400
Subject: [PATCH 4/5] Revert lguest magic and use hook in head.S
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1191368217.17826.47.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
	 <1191368154.17826.44.camel@localhost.localdomain>
	 <1191368217.17826.47.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:39:59 +1000
Message-Id: <1191368399.17826.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2.07 of the boot protocol uses 0x23C for the hardware_subarch
field, that for lguest is "1".  This allows us to use the standard
boot entry point rather than the "GenuineLguest" string hack.

This entry point also clears the BSS and copies the boot parameters
and commandline for us, saving more code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 Documentation/lguest/lguest.c |   31 ++++---------------------------
 arch/i386/kernel/head.S       |    8 ++++++++
 drivers/lguest/lguest_asm.S   |    9 +++------
 3 files changed, 15 insertions(+), 33 deletions(-)

diff -r 2fdc577cfe5c Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Tue Oct 02 22:21:05 2007 +1000
+++ b/Documentation/lguest/lguest.c	Tue Oct 02 23:00:09 2007 +1000
@@ -251,23 +251,6 @@ static void *get_pages(unsigned int num)
 	return addr;
 }
 
-/* To find out where to start we look for the magic Guest string, which marks
- * the code we see in lguest_asm.S.  This is a hack which we are currently
- * plotting to replace with the normal Linux entry point. */
-static unsigned long entry_point(const void *start, const void *end)
-{
-	const void *p;
-
-	/* The scan gives us the physical starting address.  We boot with
-	 * pagetables set up with virtual and physical the same, so that's
-	 * OK. */
-	for (p = start; p < end; p++)
-		if (memcmp(p, "GenuineLguest", strlen("GenuineLguest")) == 0)
-			return to_guest_phys(p + strlen("GenuineLguest"));
-
-	errx(1, "Is this image a genuine lguest?");
-}
-
 /* This routine is used to load the kernel or initrd.  It tries mmap, but if
  * that fails (Plan 9's kernel file isn't nicely aligned on page boundaries),
  * it falls back to reading the memory in. */
@@ -303,7 +286,6 @@ static void map_at(int fd, void *addr, u
  * We return the starting address. */
 static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr)
 {
-	void *start = (void *)-1, *end = NULL;
 	Elf32_Phdr phdr[ehdr->e_phnum];
 	unsigned int i;
 
@@ -335,19 +317,13 @@ static unsigned long map_elf(int elf_fd,
 		verbose("Section %i: size %i addr %p\n",
 			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
 
-		/* We track the first and last address we mapped, so we can
-		 * tell entry_point() where to scan. */
-		if (from_guest_phys(phdr[i].p_paddr) < start)
-			start = from_guest_phys(phdr[i].p_paddr);
-		if (from_guest_phys(phdr[i].p_paddr) + phdr[i].p_filesz > end)
-			end=from_guest_phys(phdr[i].p_paddr)+phdr[i].p_filesz;
-
 		/* We map this section of the file at its physical address. */
 		map_at(elf_fd, from_guest_phys(phdr[i].p_paddr),
 		       phdr[i].p_offset, phdr[i].p_filesz);
 	}
 
-	return entry_point(start, end);
+	/* The entry point is given in the ELF header. */
+	return ehdr->e_entry;
 }
 
 /*L:160 Unfortunately the entire ELF image isn't compressed: the segments
@@ -374,7 +350,8 @@ static unsigned long unpack_bzimage(int 
 
 	verbose("Unpacked size %i addr %p\n", len, img);
 
-	return entry_point(img, img + len);
+	/* The entry point for a bzImage is always the first byte */
+	return (unsigned long)img;
 }
 
 /*L:150 A bzImage, unlike an ELF file, is not meant to be loaded.  You're
@@ -1684,8 +1661,15 @@ int main(int argc, char *argv[])
 	*(u32 *)(boot + 0x228) = 4096;
 	concat(boot + 4096, argv+optind+2);
 
-	/* The guest type value of "1" tells the Guest it's under lguest. */
-	*(int *)(boot + 0x23c) = 1;
+	/* Boot protocol version: 2.07 supports the fields for lguest. */
+	*(u16 *)(boot + 0x206) = 0x207;
+
+	/* The hardware_subarch value of "1" tells the Guest it's an lguest. */
+	*(u32 *)(boot + 0x23c) = 1;
+
+	/* Set bit 6 of the loadflags (aka. KEEP_SEGMENTS) so the entry path
+	 * does not ttry to reload segment registers. */
+	*(u8 *)(boot + 0x211) |= (1 << 6);
 
 	/* We tell the kernel to initialize the Guest: this returns the open
 	 * /dev/lguest file descriptor. */
diff -r 2fdc577cfe5c arch/i386/lguest/boot.c
--- a/arch/i386/lguest/boot.c	Tue Oct 02 22:21:05 2007 +1000
+++ b/arch/i386/lguest/boot.c	Tue Oct 02 23:27:22 2007 +1000
@@ -938,18 +938,8 @@ static unsigned lguest_patch(u8 type, u1
 /*G:030 Once we get to lguest_init(), we know we're a Guest.  The paravirt_ops
  * structure in the kernel provides a single point for (almost) every routine
  * we have to override to avoid privileged instructions. */
-__init void lguest_init(void *boot)
-{
-	/* Copy boot parameters first: the Launcher put the physical location
-	 * in %esi, and head.S converted that to a virtual address and handed
-	 * it to us.  We use "__memcpy" because "memcpy" sometimes tries to do
-	 * tricky things to go faster, and we're not ready for that. */
-	__memcpy(&boot_params, boot, PARAM_SIZE);
-	/* The boot parameters also tell us where the command-line is: save
-	 * that, too. */
-	__memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
-	       COMMAND_LINE_SIZE);
-
+__init void lguest_init(void)
+{
 	/* We're under lguest, paravirt is enabled, and we're running at
 	 * privilege level 1, not 0 as normal. */
 	paravirt_ops.name = "lguest";
@@ -1018,11 +1008,6 @@ __init void lguest_init(void *boot)
 	 * the normal data segment to get through booting. */
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
-	/* Clear the part of the kernel data which is expected to be zero.
-	 * Normally it will be anyway, but if we're loading from a bzImage with
-	 * CONFIG_RELOCATALE=y, the relocations will be sitting here. */
-	memset(__bss_start, 0, __bss_stop - __bss_start);
-
 	/* The Host uses the top of the Guest's virtual address space for the
 	 * Host<->Guest Switcher, and it tells us how much it needs in
 	 * lguest_data.reserve_mem, set up on the LGUEST_INIT hypercall. */
diff -r 2fdc577cfe5c arch/i386/lguest/head.S
--- a/arch/i386/lguest/head.S	Tue Oct 02 22:21:05 2007 +1000
+++ b/arch/i386/lguest/head.S	Tue Oct 02 23:26:19 2007 +1000
@@ -5,11 +5,8 @@
 #include <asm/thread_info.h>
 #include <asm/processor-flags.h>
 
-/*G:020 This is where we begin: we have a magic signature which the launcher
- * looks for.  The plan is that the Linux boot protocol will be extended with a
- * "platform type" field which will guide us here from the normal entry point,
- * but for the moment this suffices.  The normal boot code uses %esi for the
- * boot header, so we do too.
+/*G:020 This is where we begin: head.S notes that the boot header's platform
+ * type field is "1" (lguest), so calls us here.  The boot header is in %esi.
  *
  * WARNING: be very careful here!  We're running at addresses equal to physical
  * addesses (around 0), not above PAGE_OFFSET as most code expectes
@@ -19,19 +16,14 @@
  * The .section line puts this code in .init.text so it will be discarded after
  * boot. */
 .section .init.text, "ax", @progbits
-.ascii "GenuineLguest"
+ENTRY(lguest_entry)
 	/* Make initial hypercall now, so we can set up the pagetables. */
 	movl $LHCALL_LGUEST_INIT, %eax
 	movl $lguest_data - __PAGE_OFFSET, %edx
 	int $LGUEST_TRAP_ENTRY
 
-	/* Set up boot information pointer to hand to lguest_init(): it wants
-	 * a virtual address. */
-	movl %esi, %eax
-	addl $__PAGE_OFFSET, %eax
-
 	/* The Host put the toplevel pagetable in lguest_data.pgdir.  The movsl
-	 * instruction uses %esi, so we needed to save it above. */
+	 * instruction uses %esi implicitly. */
 	movl lguest_data - __PAGE_OFFSET + LGUEST_DATA_pgdir, %esi
 
 	/* Copy first 32 entries of page directory to __PAGE_OFFSET entries.
@@ -46,7 +38,6 @@
 
 	/* Set up the initial stack so we can run C code. */
  	movl $(init_thread_union+THREAD_SIZE),%esp
-
 
 	/* Jumps are relative, and we're running __PAGE_OFFSET too low at the
 	 * moment. */


