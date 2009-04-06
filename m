Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZDFRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZDFRKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZDFRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:10:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZDFRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:10:39 -0400
Message-ID: <49DA37CB.4020901@redhat.com>
Date: Mon, 06 Apr 2009 13:11:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [BUGFIX][PATCH -tip] x86: fix text_poke to handle highmem pages
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com>
In-Reply-To: <49D82987.5090003@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in text_poke to handle highmem pages, because module
text pages are possible to be highmem pages on x86-32.
In that case, since fixmap can't handle those pages, text_poke
uses kmap_atomic.

Moreover, module_text pages will be discontinuous and it is
possible that one page is lowmem and another page is highmem,
because it is allocated by vmalloc. To handle this situation,
text_poke splits poke area into two pieces and write the areas
page by page.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
---

 Hi Ingo and Mathieu,

 Masami Hiramatsu wrote:
 > A) Separate text_poke into __text_poke and __text_poke_highmem. And
 >   use pkmap_atomic in __text_poke_highmem. This way doesn't require
 >   any additional change except adding KM_TEXT_POKE0/1 in km_type.

 Here is A) patch.

 Thank you,

 arch/x86/include/asm/fixmap.h     |    3 +-
 arch/x86/include/asm/kmap_types.h |    3 ++
 arch/x86/kernel/alternative.c     |   45 ++++++++++++++++++++++++-------------
 3 files changed, 32 insertions(+), 19 deletions(-)


diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 81937a5..6c59d4a 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -111,8 +111,7 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
-	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
-	FIX_TEXT_POKE1,
+	FIX_TEXT_POKE,	/* reserve 1 page for text_poke() */
 	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
diff --git a/arch/x86/include/asm/kmap_types.h b/arch/x86/include/asm/kmap_types.h
index 5759c16..e48f11f 100644
--- a/arch/x86/include/asm/kmap_types.h
+++ b/arch/x86/include/asm/kmap_types.h
@@ -21,7 +21,8 @@ D(9)	KM_IRQ0,
 D(10)	KM_IRQ1,
 D(11)	KM_SOFTIRQ0,
 D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
+D(13)	KM_TEXT_POKE,
+D(14)	KM_TYPE_NR
 };

 #undef D
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..f4487c9 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
+#include <linux/highmem.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -514,27 +515,39 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
-	struct page *pages[2];
+	struct page *page;
 	int i;
+	unsigned long endp = ((unsigned long)addr + len) & PAGE_MASK;

-	if (!core_kernel_text((unsigned long)addr)) {
-		pages[0] = vmalloc_to_page(addr);
-		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
-	} else {
-		pages[0] = virt_to_page(addr);
-		WARN_ON(!PageReserved(pages[0]));
-		pages[1] = virt_to_page(addr + PAGE_SIZE);
+	/*
+	 * If the written range covers 2 pages, we'll split it, because
+	 * vmalloc pages are not always continuous -- e.g. 1st page is
+	 * lowmem and 2nd page is highmem.
+	 */
+	if (((unsigned long)addr & PAGE_MASK) != endp) {
+		text_poke(addr, opcode, endp - (unsigned long)addr);
+		addr =  (void *)endp;
+		opcode = (char *)opcode + (endp - (unsigned long)addr);
+		len -= endp - (unsigned long)addr;
 	}
-	BUG_ON(!pages[0]);
+
+	if (!core_kernel_text((unsigned long)addr))
+		page = vmalloc_to_page(addr);
+	else
+		page = virt_to_page(addr);
+	BUG_ON(!page);
 	local_irq_save(flags);
-	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
-	if (pages[1])
-		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
-	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
+	if (PageHighMem(page))
+		vaddr = kmap_atomic(page, KM_TEXT_POKE);
+	else {
+		set_fixmap(FIX_TEXT_POKE, page_to_phys(page));
+		vaddr = (char *)fix_to_virt(FIX_TEXT_POKE);
+	}
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	clear_fixmap(FIX_TEXT_POKE0);
-	if (pages[1])
-		clear_fixmap(FIX_TEXT_POKE1);
+	if (PageHighMem(page))
+		kunmap_atomic(vaddr, KM_TEXT_POKE);
+	else
+		clear_fixmap(FIX_TEXT_POKE);
 	local_flush_tlb();
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

