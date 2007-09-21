Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbXIUUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbXIUUtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763256AbXIUUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763117AbXIUUo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: hpa@zytor.com, andi@firstfloor.org, gcosta@redhat.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [14/45] x86: Create clflush() inline, remove hardcoded wbinvd
Message-Id: <20070921204455.C68D714EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "H. Peter Anvin" <hpa@zytor.com>
Create an inline function for clflush(), with the proper arguments,
and use it instead of hard-coding the instruction.

This also removes one instance of hard-coded wbinvd, based on a patch
by Bauder de Oliveira Costa.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c         |    4 ++--
 arch/x86_64/kernel/tce.c        |    4 ++--
 arch/x86_64/mm/pageattr.c       |    2 +-
 drivers/char/agp/efficeon-agp.c |   11 ++++++-----
 include/asm-i386/system.h       |    4 ++++
 include/asm-x86_64/system.h     |    5 +++++
 6 files changed, 20 insertions(+), 10 deletions(-)

Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -70,10 +70,10 @@ static struct page *split_large_page(uns
 
 static void cache_flush_page(struct page *p)
 { 
-	unsigned long adr = (unsigned long)page_address(p);
+	void *adr = page_address(p);
 	int i;
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-		asm volatile("clflush (%0)" :: "r" (adr + i));
+		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
Index: linux/arch/x86_64/kernel/tce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tce.c
+++ linux/arch/x86_64/kernel/tce.c
@@ -40,9 +40,9 @@ static inline void flush_tce(void* tcead
 {
 	/* a single tce can't cross a cache line */
 	if (cpu_has_clflush)
-		asm volatile("clflush (%0)" :: "r" (tceaddr));
+		clflush(tceaddr);
 	else
-		asm volatile("wbinvd":::"memory");
+		wbinvd();
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -65,7 +65,7 @@ static void cache_flush_page(void *adr)
 {
 	int i;
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-		asm volatile("clflush (%0)" :: "r" (adr + i));
+		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
Index: linux/drivers/char/agp/efficeon-agp.c
===================================================================
--- linux.orig/drivers/char/agp/efficeon-agp.c
+++ linux/drivers/char/agp/efficeon-agp.c
@@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(st
 		SetPageReserved(virt_to_page((char *)page));
 
 		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
-			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
+			clflush((char *)page+offset);
 
 		efficeon_private.l1_table[index] = page;
 
@@ -268,15 +268,16 @@ static int efficeon_insert_memory(struct
 		*page = insert;
 
 		/* clflush is slow, so don't clflush until we have to */
-		if ( last_page &&
-		     ((unsigned long)page^(unsigned long)last_page) & clflush_mask )
-		    asm volatile("clflush %0" : : "m" (*last_page));
+		if (last_page &&
+		    (((unsigned long)page^(unsigned long)last_page) &
+		     clflush_mask))
+			clflush(last_page);
 
 		last_page = page;
 	}
 
 	if ( last_page )
-		asm volatile("clflush %0" : : "m" (*last_page));
+		clflush(last_page);
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
Index: linux/include/asm-i386/system.h
===================================================================
--- linux.orig/include/asm-i386/system.h
+++ linux/include/asm-i386/system.h
@@ -160,6 +160,10 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
+}
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
Index: linux/include/asm-x86_64/system.h
===================================================================
--- linux.orig/include/asm-x86_64/system.h
+++ linux/include/asm-x86_64/system.h
@@ -137,6 +137,11 @@ static inline void write_cr8(unsigned lo
 
 #endif	/* __KERNEL__ */
 
+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
+}
+
 #define nop() __asm__ __volatile__ ("nop")
 
 #ifdef CONFIG_SMP
