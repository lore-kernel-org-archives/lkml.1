Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZIDBTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZIDBTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZIDBTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:19:24 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:36138 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZIDBTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:19:23 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 21:19:22 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qjlBn8H2ECcl82utBSmAZxnx7S+v+ZFF7EPff90QxZ/eq3XbanTFd5bL6XULqO1kz1
         Uq2JsklqXSXS+oAIreyWxhCUDrx3xynGFE8AvGQeEh5oGweXEuINDDSVRgq7XLJn1x5J
         62g4GksLsgSGfqZ8+nW1Rgk8jysMSG9yChQfU=
MIME-Version: 1.0
Date: Thu, 3 Sep 2009 21:13:09 -0400
Message-ID: <817ecb6f0909031813n335279a3pb974b9efa8989095@mail.gmail.com>
Subject: [PATCH V3] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
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

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

diff --git a/CREDITS b/CREDITS
index 1a41bf4..a24b669 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1657,6 +1657,13 @@ N: Niels Kristian Bech Jensen
 E: nkbj1970@hotmail.com
 D: Miscellaneous kernel updates and fixes.

+N: Xuxian Jiang
+E: jiang@cs.ncsu.edu
+D: RO/NX protection for static kernel and LKMs
+S: North Carolina State University
+S: Raleigh, North Carolina
+S: USA
+
 N: Michael K. Johnson
 E: johnsonm@redhat.com
 W: http://www.redhat.com/~johnsonm
@@ -2068,6 +2075,13 @@ S: Post Office Box 371
 S: North Little Rock, Arkansas 72115
 S: USA

+N: Siarhei Liakh
+E: sliakh.lkml@gmail.com
+D: RO/NX protection for static kernel and LKMs
+S: North Carolina State University
+S: Raleigh, North Carolina
+S: USA
+
 N: Stephan Linz
 E: linz@mazet.de
 E: Stephan.Linz@gmx.de
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 78d185d..1b036e3 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -43,7 +43,7 @@ jiffies_64 = jiffies;

 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(7);          /* RWE */
 	data.init PT_LOAD FLAGS(7);     /* RWE */
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
index 0607119..9091bc0 100644
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

@@ -440,11 +441,31 @@ void free_init_pages(char *what, unsigned long
begin, unsigned long end)
 #endif
 }

+#ifndef CONFIG_DEBUG_RODATA
+static inline void mark_nxdata_nx(void) { }
+#else
+void mark_nxdata_nx(void)
+{
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PFN_ALIGN(_etext);
+	unsigned long size = PFN_ALIGN(_end) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
+#endif
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
