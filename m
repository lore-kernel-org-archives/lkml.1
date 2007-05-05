Return-Path: <linux-kernel-owner+w=401wt.eu-S1031760AbXEEPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031760AbXEEPdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031783AbXEEPdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:33:44 -0400
Received: from ozlabs.org ([203.10.76.45]:51284 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031760AbXEEPdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:33:42 -0400
Subject: [PATCH] lguest: don't use paravirt_probe, it's dying
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1178335341.12284.99.camel@localhost.localdomain>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	 <1178280770.23670.61.camel@localhost.localdomain>
	 <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	 <1178289450.23670.100.camel@localhost.localdomain>
	 <m1lkg4sk3f.fsf@ebiederm.dsl.xmission.com>
	 <1178328168.12284.11.camel@localhost.localdomain>
	 <m18xc4nfqf.fsf@ebiederm.dsl.xmission.com>
	 <1178335341.12284.99.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 05 May 2007 21:18:43 +1000
Message-Id: <1178363923.12284.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 13:22 +1000, Rusty Russell wrote:
> On Fri, 2007-05-04 at 20:53 -0600, Eric W. Biederman wrote:
> > Frankly I think the least risk of problems comes from just doing a
> > separate entry point for lguest for now.  It means we don't even have
> > to touch the common code path and later dropping will be trivially 
> > lguest specific, and certain to not break anything else.
> 
> Hmm, I railed for so long against Xen doing that, it feels... wrong...
> to do that now 8)

And here's the patch.  It's pretty trivial actually.  It even worked
first time.  It applies against -mm (ie. before the "boot with P=V"
patches I showed before).

Thanks!
Rusty.
==
paravirt_probe() and its infrastructure proved as popular as it was
pretty.  In anticipation of its imminent demise, this switches lguest to
use a magic string to identify a different entry point.

This is not the long-term solution: that will take a new bootloader rev
and will hopefully be done in the next few months.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 9cfbf629088e Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Sat May 05 13:06:53 2007 +1000
+++ b/Documentation/lguest/lguest.c	Sat May 05 17:33:25 2007 +1000
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
diff -r 9cfbf629088e drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Sat May 05 13:06:53 2007 +1000
+++ b/drivers/lguest/lguest.c	Sat May 05 17:21:44 2007 +1000
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
diff -r 9cfbf629088e drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Sat May 05 13:06:53 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Sat May 05 17:21:38 2007 +1000
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




