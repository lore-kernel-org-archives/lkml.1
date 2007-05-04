Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXEDNAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXEDNAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXEDNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:00:06 -0400
Received: from ozlabs.org ([203.10.76.45]:33595 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbXEDNAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:00:02 -0400
Subject: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot
	header field
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 May 2007 22:59:42 +1000
Message-Id: <1178283582.23670.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch won't apply, even to -mm: it comes after the documentation
patch.  But it's hopefully readable ]

1) This code assumes that 0x23C is going to be the "platform type"
   field of the next version of the Linux boot header format.

2) This doesn't actually assume that P=V, but unlike the paravirt
   probe code doesn't assume that V=P+PAGE_OFFSET either.

The following patch actually fixes up lguest to boot with P=V.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/kernel/head.S     |   31 +++++++------------------------
 drivers/lguest/lguest.c     |    6 +-----
 drivers/lguest/lguest_asm.S |   26 ++------------------------
 include/asm-i386/paravirt.h |    5 -----
 4 files changed, 10 insertions(+), 58 deletions(-)

diff -r 0e7e7991bd30 arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Fri May 04 16:59:07 2007 +1000
+++ b/arch/i386/kernel/head.S	Fri May 04 20:38:08 2007 +1000
@@ -503,35 +503,13 @@ ignore_int:
 .section .text
 #ifdef CONFIG_PARAVIRT
 startup_paravirt:
-	cld
- 	movl $(init_thread_union+THREAD_SIZE),%esp
-
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
+	cmpl	$1, 0x23c(%esi)
+	je	lguest_init
+#endif
 	/* Nothing wanted us: we're screwed. */
 	ud2
-#endif
+#endif /* CONFIG_PARAVIRT */
 
 /*
  * Real beginning of normal "text" segment
diff -r 0e7e7991bd30 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S	Fri May 04 16:59:07 2007 +1000
+++ b/arch/i386/kernel/vmlinux.lds.S	Fri May 04 22:30:45 2007 +1000
@@ -80,12 +80,6 @@ SECTIONS
 	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
-
-  .paravirtprobe : AT(ADDR(.paravirtprobe) - LOAD_OFFSET) {
-  	__start_paravirtprobe = .;
-	*(.paravirtprobe)
-  	__stop_paravirtprobe = .;
-  }
 
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
diff -r 0e7e7991bd30 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri May 04 16:59:07 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri May 04 22:30:20 2007 +1000
@@ -799,10 +799,10 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-/*G:030 Once we get to lguest_init(), we know we're a Guest.  The paravirt_ops
- * structure in the kernel provides a single point for (almost) every routine
- * we have to override to avoid privileged instructions. */
-__init void lguest_init(void *boot)
+/*G:030 Once we get to do_lguest_init(), we know we're a Guest.  The
+ * paravirt_ops structure in the kernel provides a single point for (almost)
+ * every routine we have to override to avoid privileged instructions. */
+__init void do_lguest_init(void *boot)
 {
 	/* Copy boot parameters first: the Launcher put the physical location
 	 * in %esi, and head.S converted that to a virtual address and handed
@@ -868,7 +868,7 @@ __init void lguest_init(void *boot)
 	 * before returning to the rest of lguest_init(). :*/
 
 	/*G:070 Now we've seen all the paravirt_ops, we return to
-	 * lguest_init() where the rest of the fairly chaotic boot setup
+	 * do_lguest_init() where the rest of the fairly chaotic boot setup
 	 * occurs.
 	 *
 	 * The Host expects our first hypercall to tell it where our "struct
@@ -927,7 +927,3 @@ __init void lguest_init(void *boot)
  * It is now time for us to explore the nooks and crannies of the three Guest
  * devices and complete our understanding of the Guest in "make Drivers".
  */
-
-/*G:025 To complete the magic, lguest_maybe_init() from lguest_asm.S needs to
- * be registered as a paravirt probe function: */
-paravirt_probe(lguest_maybe_init);
diff -r 0e7e7991bd30 drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Fri May 04 16:59:07 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Fri May 04 22:30:20 2007 +1000
@@ -1,33 +1,26 @@
 #include <linux/linkage.h>
 #include <linux/lguest.h>
 #include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
 #include <asm/page.h>
 
 /* FIXME: Once asm/processor-flags.h goes in, include that */
 #define X86_EFLAGS_IF 0x00000200
 
 /*G:020 This is where we begin: head.S notes that we're not running at
- * privilege level 0 (as we would be in native boot) and calls the registered
- * paravirt_probe functions one at a time.
- *
- * This is expected to change to use the linux boot header in %esi and a
- * platform type in the future, so we test for that here (the final version
- * will be slightly different: we assume offset 0x23C and a value of "1" for
- * lguest).  We know that %esi with the current launcher should be zero: we
- * pass that in %eax to lguest_init().
+ * privilege level 0 (as we would be in native boot) and looks at the
+ * platform type field in the boot structure (address in %esi).  If 1 (lguest),
+ * it calls here.
  *
  * The .section line puts this code in .init.text so it will be discarded after
  * boot. */
 .section .init.text, "ax", @progbits
-ENTRY(lguest_maybe_init)
-	cmpl $0, %esi
-	jne out
+ENTRY(lguest_init)
+	/* Set up initial stack. */
+ 	movl $(init_thread_union+THREAD_SIZE),%esp
+	/* Hand boot information pointer to do_lguest_init() */
 	movl %esi, %eax
-	addl $__PAGE_OFFSET, %eax
-	cmpl $1, 0x23c(%eax)
-	je lguest_init
-out:
-	ret
+	jmp do_lguest_init
 
 /*G:055 We create a macro which puts the assembler code between lgstart_ and
  * lgend_ markers.  These templates end up in the .init.text section, so they
diff -r 0e7e7991bd30 drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c	Fri May 04 16:59:07 2007 +1000
+++ b/drivers/lguest/lguest_user.c	Fri May 04 22:30:20 2007 +1000
@@ -14,7 +14,9 @@
  *
  * Most of the Guest's registers are left alone: we used get_zeroed_page() to
  * allocate the structure, so they will be 0. */
-static void setup_regs(struct lguest_regs *regs, unsigned long start)
+static void setup_regs(struct lguest_regs *regs,
+		       unsigned long start,
+		       unsigned long page_offset)
 {
 	/* There are four "segment" registers which the Guest needs to boot:
 	 * The "code segment" register (cs) refers to the kernel code segment
@@ -36,8 +38,9 @@ static void setup_regs(struct lguest_reg
 	 * running. */
 	regs->eip = start;
 
-	/* %esi points to our boot information, at physical address 0, so don't
-	 * touch it. */
+	/* %esi points to the virtual address of the boot information (it's at
+	 * physical address 0 == virtual address page_offset). */
+	regs->esi = page_offset;
 }
 
 /*L:310 To send DMA into the Guest, the Launcher needs to be able to ask for a
@@ -184,7 +187,7 @@ static int initialize(struct file *file,
 
 	/* Now we initialize the Guest's registers, handing it the start
 	 * address. */
-	setup_regs(lg->regs, args[2]);
+	setup_regs(lg->regs, args[2], lg->page_offset);
 
 	/* There are a couple of GDT entries the Guest expects when first
 	 * booting. */
diff -r 0e7e7991bd30 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri May 04 16:59:07 2007 +1000
+++ b/include/asm-i386/paravirt.h	Fri May 04 20:24:39 2007 +1000
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
 


