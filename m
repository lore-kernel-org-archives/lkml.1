Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZHZR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZHZR0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZHZR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:26:07 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:54948 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZHZR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:26:05 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 13:26:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H5LJpwPEc8BU2ABhfzFb0zVLfm8t64oza9bs8gtV/fk8hKjPRr+g0D8lNGudxTigO/
         66bc/Gg3MZdJm4Tm27CTx2u0fIiogDEvV9hLu7NJZ5lcWMmcRXcMXRfSDCWxBNNcEp0S
         zMIpc0BqW3CfxSrsQuyk1cuYgHjhay98JP2eA=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 13:20:19 -0400
Message-ID: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com>
Subject: [PATCH V2] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.
The following steps are taken to achieve this:
1. Linker script is adjusted so .text always starts and ends on a page boundary
2. Linker script is adjusted so .rodata and .data always start and
end on a page boundary
3. void mark_nxdata_nx(void) added to init/main.c with actual
functionality: NX is set for all
pages from _etext through _end.
4. mark_nxdata_nx() called from init_post(void) in init/main.c (after
init has been released)
5. free_init_pages() sets released memory NX in arch/x86/mm/init.c

The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

V1:  initial patch for 2.6.30
V2:  patch for 2.6.31-rc7

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

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
index 0607119..da6da99 100644
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

diff --git a/init/main.c b/init/main.c
index 2d9d6bd..a1a6248 100644
--- a/init/main.c
+++ b/init/main.c
@@ -7,6 +7,8 @@
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
+ *  Data NX protection by Siarhei Liakh <sliakh.lkml@gmail.com>
+ *  and Xuxian Jiang <jiang@cs.ncsu.edu>
  */

 #include <linux/types.h>
@@ -91,6 +93,21 @@ extern void radix_tree_init(void);
 extern void free_initmem(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
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
 #endif

 #ifdef CONFIG_TC
@@ -839,6 +856,7 @@ static noinline int init_post(void)
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
+	mark_nxdata_nx();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
