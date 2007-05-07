Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXEGBLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXEGBLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXEGBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:11:07 -0400
Received: from ozlabs.org ([203.10.76.45]:56242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbXEGBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:11:04 -0400
Subject: [PATCH 2/3] lguest: 2.6.21-mm1 update: lguest-magic-signature.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1178500168.7731.23.camel@localhost.localdomain>
References: <1178500168.7731.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:10:52 +1000
Message-Id: <1178500252.7731.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

paravirt_probe() and its infrastructure proved as popular as it was
pretty.  In anticipation of its imminent demise, this switches lguest to
use a magic string to identify a different entry point.

This is not the long-term solution: that will take a new bootloader rev
and will hopefully be done in the next few months.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |   25 +++++++++++++++++++++----
 drivers/lguest/lguest.c       |    2 --
 drivers/lguest/lguest_asm.S   |   23 +++++++++--------------
 3 files changed, 30 insertions(+), 20 deletions(-)

===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -96,6 +96,19 @@ static void *map_zeroed_pages(unsigned l
 	return (void *)addr;
 }
 
+/* Find magic string marking entry point, return entry point. */
+static unsigned long entry_point(void *start, void *end,
+				 unsigned long page_offset)
+{
+	void *p;
+
+	for (p = start; p < end; p++)
+		if (memcmp(p, "GenuineLguest", strlen("GenuineLguest")) == 0)
+			return (long)p + strlen("GenuineLguest") + page_offset;
+
+	err(1, "Is this image a genuine lguest?");
+}
+
 /* Returns the entry point */
 static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr,
 			     unsigned long *page_offset)
@@ -103,6 +116,7 @@ static unsigned long map_elf(int elf_fd,
 	void *addr;
 	Elf32_Phdr phdr[ehdr->e_phnum];
 	unsigned int i;
+	unsigned long start = -1UL, end = 0;
 
 	/* Sanity checks. */
 	if (ehdr->e_type != ET_EXEC
@@ -131,6 +145,11 @@ static unsigned long map_elf(int elf_fd,
 			*page_offset = phdr[i].p_vaddr - phdr[i].p_paddr;
 		else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
 			errx(1, "Page offset of section %i different", i);
+
+		if (phdr[i].p_paddr < start)
+			start = phdr[i].p_paddr;
+		if (phdr[i].p_paddr + phdr[i].p_filesz > end)
+			end = phdr[i].p_paddr + phdr[i].p_filesz;
 
 		/* We map everything private, writable. */
 		addr = mmap((void *)phdr[i].p_paddr,
@@ -143,8 +162,7 @@ static unsigned long map_elf(int elf_fd,
 			    i, addr, (void *)phdr[i].p_paddr);
 	}
 
-	/* Entry is physical address: convert to virtual */
-	return ehdr->e_entry + *page_offset;
+	return entry_point((void *)start, (void *)end, *page_offset);
 }
 
 /* This is amazingly reliable. */
@@ -175,8 +193,7 @@ static unsigned long unpack_bzimage(int 
 	verbose("Unpacked size %i addr %p\n", len, img);
 	*page_offset = intuit_page_offset(img, len);
 
-	/* Entry is physical address: convert to virtual */
-	return (unsigned long)img + *page_offset;
+	return entry_point(img, img + len, *page_offset);
 }
 
 static unsigned long load_bzimage(int fd, unsigned long *page_offset)
===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -43,7 +43,6 @@ extern const char lgstart_popf[], lgend_
 extern const char lgstart_popf[], lgend_popf[];
 extern const char lgstart_pushf[], lgend_pushf[];
 extern const char lgstart_iret[], lgend_iret[];
-extern asmlinkage void lguest_maybe_init(void);
 extern void lguest_iret(void);
 
 struct lguest_data lguest_data = {
@@ -497,4 +496,3 @@ __init void lguest_init(void)
 	pm_power_off = lguest_power_off;
 	start_kernel();
 }
-paravirt_probe(lguest_maybe_init);
===================================================================
--- a/drivers/lguest/lguest_asm.S
+++ b/drivers/lguest/lguest_asm.S
@@ -1,29 +1,24 @@
 #include <linux/linkage.h>
 #include <linux/lguest.h>
 #include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
 
 /* FIXME: Once asm/processor-flags.h goes in, include that */
 #define X86_EFLAGS_IF 0x00000200
 
 /*
- * This is where we begin: head.S notes that paging is already enabled (which
- * doesn't happen in native boot) and calls the registered paravirt_probe
- * functions one at a time.  Ours is a simple assembler test for magic
- * registers.  If they're correct we jump to lguest_init.
+ * This is where we begin: we have a magic signature which the launcher looks
+ * for.  The plan is that the Linux boot protocol will be extended with a
+ * "platform type" field which will guide us here from the normal entry point,
+ * but for the moment this suffices.
  *
  * We put it in .init.text will be discarded after boot.
  */
 .section .init.text, "ax", @progbits
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
+.ascii "GenuineLguest"
+	/* Set up initial stack. */
+ 	movl $(init_thread_union+THREAD_SIZE),%esp
+	jmp lguest_init
 
 /* The templates for inline patching. */
 #define LGUEST_PATCH(name, insns...)			\


