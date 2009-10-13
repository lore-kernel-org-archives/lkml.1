Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZJMBD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZJMBD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZJMBD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:03:57 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:34121 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZJMBDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rGnyb6Yj1KtaopK0cdxGixes2onAUa8tQuynD/7btGi47wfXSxrhREx6vc8IcrRsGD
         IwuwaHZnp+y1mvS+rDVcUCNsWeQgF1icpyfxlhC9h6j6LZlAsjbhEleo9tqXG7zsjv+M
         ea/SnRSi8XLLlmBnixYUXsEYGS9CD3twfU3Zw=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 21:03:17 -0400
Message-ID: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com>
Subject: [PATCH V5] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Aristeu Rozanski <aris@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.
The following steps are taken to achieve this:
1. Linker script is adjusted so .text always starts and ends on a page boundary
2. Linker script is adjusted so .rodata and .data always start and
end on a page boundary
3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
functionality: NX is set for all pages from _etext through _end.
4. mark_nxdata_nx() called from free_initmem() (after init has been released)
5. free_init_pages() sets released memory NX in arch/x86/mm/init.c

The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

V1:  initial patch for 2.6.30
V2:  patch for 2.6.31-rc7
V3:  moved all code into arch/x86, adjusted credits
V4:  fixed ifdef, removed credits from CREDITS
V5:  fixed an address calculation bug in mark_nxdata_nx()
---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 78d185d..83ae734 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -43,14 +43,14 @@ jiffies_64 = jiffies;

 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
-	user PT_LOAD FLAGS(7);          /* RWE */
-	data.init PT_LOAD FLAGS(7);     /* RWE */
+	user PT_LOAD FLAGS(6);          /* RW_ */
+	data.init PT_LOAD FLAGS(6);     /* RW_ */
 #ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);        /* RWE */
+	percpu PT_LOAD FLAGS(6);        /* RW_ */
 #endif
-	data.init2 PT_LOAD FLAGS(7);    /* RWE */
+	data.init2 PT_LOAD FLAGS(6);    /* RW_ */
 #endif
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
@@ -89,6 +89,8 @@ SECTIONS
 		IRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
+		/* .text should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of text section */
 		_etext = .;
 	} :text = 0x9090
@@ -151,6 +153,8 @@ SECTIONS
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)

+		/* .data should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of data section */
 		_edata = .;
 	}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0607119..7bfd411 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -423,9 +423,10 @@ void free_init_pages(char *what, unsigned long
begin, unsigned long end)
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
-	 * writeable first.
+	 * writeable and non-executable first.
 	 */
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);

 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);

@@ -440,11 +441,29 @@ void free_init_pages(char *what, unsigned long
begin, unsigned long end)
 #endif
 }

+void mark_nxdata_nx(void)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PAGE_ALIGN((unsigned long)(&_etext));
+	unsigned long size = PAGE_ALIGN((unsigned long)(&_end)) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_memory_nx(start, size >> PAGE_SHIFT);
+#endif
+}
+
 void free_initmem(void)
 {
 	free_init_pages("unused kernel memory",
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
+	/* Set kernel's data as NX */
+	mark_nxdata_nx();
 }

 #ifdef CONFIG_BLK_DEV_INITRD
