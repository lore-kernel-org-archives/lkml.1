Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbZGSTnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbZGSTnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZGSTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:43:09 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:37536 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGSTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n6NOu+1EPPNww/5g0nuTf8K7ADABY20oBFQHaRkK7NpLz3HZnIclyEjxhlw+Dur4aM
         jpVleYb4wOoNR3s4TZS/hJPoU7oOBSVprcwiCYFoUz8WufQ5b1pk01nGAhgROoJSQh/w
         +wXH8XKMgByiLrBUptsUXqFCELVHUJsm/WR4s=
MIME-Version: 1.0
Date: Sun, 19 Jul 2009 15:43:06 -0400
Message-ID: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
Subject: [PATCH] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.
The following steps are taken to achieve this:
1. Linker scripts are adjusted so .text always starts and end on a page boundary
2. Linker scripts are adjusted so .rodata and .data always starts and
end on a page boundary
3. void mark_nxdata_nx(void) added to arch/x86/mm/init_64.c and
arch/x86/mm/init_32.c with actual functionality: NX is set for all
pages from _etext through _edata
4. mark_nxdata_nx() called from init_post(void) in init/main.c

The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

---

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

diff --git a/arch/x86/include/asm/cacheflush.h
b/arch/x86/include/asm/cacheflush.h
index e55dfc1..cce364e 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -125,6 +125,7 @@ void clflush_cache_range(void *addr, unsigned int size);

 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
+void mark_nxdata_nx(void);
 extern const int rodata_test_data;
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..4041522 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -47,6 +47,7 @@ SECTIONS
 	IRQENTRY_TEXT
 	*(.fixup)
 	*(.gnu.warning)
+  	. = ALIGN(PAGE_SIZE);	/* .text should occupy whole number of pages */
   	_etext = .;			/* End of text section */
   } :text = 0x9090

@@ -93,6 +94,7 @@ SECTIONS
 	*(.data.read_mostly)
 	_edata = .;		/* End of data section */
   }
+  . = ALIGN(PAGE_SIZE);		/* needed so we can set NX for .data */

   . = ALIGN(THREAD_SIZE);	/* init_task */
   .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index c874250..a60ce17 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -42,6 +42,7 @@ SECTIONS
 	IRQENTRY_TEXT
 	*(.fixup)
 	*(.gnu.warning)
+  	. = ALIGN(PAGE_SIZE);	/* .text should occupy whole number of pages */
 	_etext = .;		/* End of text section */
   } :text = 0x9090

@@ -61,6 +62,7 @@ SECTIONS
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
 	CONSTRUCTORS
+  	. = ALIGN(PAGE_SIZE);		/* needed so we can set NX for .data */
 	_edata = .;			/* End of data section */
 	} :data

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..68163dc 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1119,6 +1119,16 @@ void mark_rodata_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 #endif
 }
+
+void mark_nxdata_nx(void)
+{
+	unsigned long start = PFN_ALIGN(_etext);
+	unsigned long size = PFN_ALIGN(_edata) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
 #endif

 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..5b0843f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -793,6 +793,15 @@ void mark_rodata_ro(void)
 #endif
 }

+void mark_nxdata_nx(void)
+{
+	unsigned long start = PFN_ALIGN(_etext);
+	unsigned long size = PFN_ALIGN(_edata) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
 #endif

 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
diff --git a/init/main.c b/init/main.c
index d721dad..6c0ee8b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -93,6 +93,7 @@ static inline void acpi_early_init(void) { }
 #endif
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
+static inline void mark_nxdata_nx(void) { }
 #endif

 #ifdef CONFIG_TC
@@ -807,6 +808,7 @@ static noinline int init_post(void)
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
+	mark_nxdata_nx();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
