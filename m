Return-Path: <linux-kernel-owner+w=401wt.eu-S1031574AbXD3Rpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031574AbXD3Rpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031579AbXD3Rpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:45:30 -0400
Received: from holomorphy.com ([66.93.40.71]:56443 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031574AbXD3Rp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:45:28 -0400
Date: Mon, 30 Apr 2007 10:45:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [4/6] go BUG on vmallocspace in __pa() (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174510.GG19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> Here's what I did for i386 for someone concerned about blowing the stack.

Add checks to __pa() so it goes BUG() on vmallocspace addresses.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/kernel/doublefault.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/doublefault.c	2007-04-30 10:26:15.959875324 -0700
+++ stack-paranoia/arch/i386/kernel/doublefault.c	2007-04-30 10:34:55.201465216 -0700
@@ -62,5 +62,5 @@
 	.ss		= __KERNEL_DS,
 	.ds		= __USER_DS,
 
-	.__cr3		= __pa(swapper_pg_dir)
+	.__cr3		= (unsigned long)swapper_pg_dir - PAGE_OFFSET,
 };
Index: stack-paranoia/arch/i386/mm/pgtable.c
===================================================================
--- stack-paranoia.orig/arch/i386/mm/pgtable.c	2007-04-30 10:26:16.075881935 -0700
+++ stack-paranoia/arch/i386/mm/pgtable.c	2007-04-30 10:34:55.201465216 -0700
@@ -181,6 +181,15 @@
 #endif
 }
 
+unsigned long __kvaddr_to_paddr(unsigned long kvaddr)
+{
+	if (high_memory)
+		BUG_ON(kvaddr >= VMALLOC_START);
+	else
+		BUG_ON(kvaddr >= (unsigned long)__va(MAXMEM));
+	return kvaddr - PAGE_OFFSET;
+}
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
Index: stack-paranoia/include/asm-i386/page.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/page.h	2007-04-30 10:26:32.012790127 -0700
+++ stack-paranoia/include/asm-i386/page.h	2007-04-30 10:34:55.197464988 -0700
@@ -118,11 +118,17 @@
 #define __PAGE_OFFSET		((unsigned long)CONFIG_PAGE_OFFSET)
 #endif
 
-
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
+
+#ifdef __ASSEMBLY__
+#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
+#else
+extern unsigned long __kvaddr_to_paddr(unsigned long);
+#define __pa(x)			__kvaddr_to_paddr((unsigned long)(x))
+#endif
+
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
 #define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
-#define __pa(x)			((unsigned long)(x)-PAGE_OFFSET)
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)          __pa(RELOC_HIDE((unsigned long)(x),0))
