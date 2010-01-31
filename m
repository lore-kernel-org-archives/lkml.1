Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0AaX16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:27:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58478 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0AaX14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GosbhWz391RuZI/PmXAyMHeBiuLflUxJM3XAzY6N9Ge9j4N3uDtVmFGNYuN/+PK5Dy
         d6/+UD7IqjWWYl9fSs2/bl30mLoCBy2u3xWonskn78GwR1eHu2LK0GO1BC0uVi5r2lEt
         6CdKjYJFvucCeFxEG8n3w0MGX0hA2C7RwVarQ=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 18:27:55 -0500
Message-ID: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
Subject: [PATCH V6] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
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
V6:  updated for compatibility with 2.6.33-rc5
---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f92a0da..2cb7369 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ jiffies_64 = jiffies;

 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
@@ -108,6 +108,8 @@ SECTIONS
 		IRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
+		/* .text should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of text section */
 		_etext = .;
 	} :text = 0x9090
@@ -143,6 +145,8 @@ SECTIONS
 		/* rarely changed data like cpu maps */
 		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)

+		/* .data should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of data section */
 		_edata = .;
 	} :data
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d406c52..d613d0a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -356,9 +356,10 @@ void free_init_pages(char *what, unsigned long
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

@@ -373,11 +374,29 @@ void free_init_pages(char *what, unsigned long
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
