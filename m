Return-Path: <linux-kernel-owner+w=401wt.eu-S1762128AbXGTVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128AbXGTVUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGTVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:20:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXGTVUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:20:10 -0400
Date: Fri, 20 Jul 2007 14:19:58 -0700
Message-Id: <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
In-Reply-To: <1184885740.16311.19.camel@t60>
References: <1184885740.16311.19.camel@t60>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create an inline function for clflush(), with the proper arguments,
and use it instead of hard-coding the instruction.

This also removes one instance of hard-coded wbinvd, based on a patch
by Bauder de Oliveira Costa.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/mm/pageattr.c b/arch/i386/mm/pageattr.c
index 37992ff..cb4ded4 100644
--- a/arch/i386/mm/pageattr.c
+++ b/arch/i386/mm/pageattr.c
@@ -70,10 +70,10 @@ static struct page *split_large_page(unsigned long address, pgprot_t prot,
 
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
diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index f61fb8e..c01b535 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -40,9 +40,9 @@ static inline void flush_tce(void* tceaddr)
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
diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 9148f4a..863e929 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -65,7 +65,7 @@ static void cache_flush_page(void *adr)
 {
 	int i;
 	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-		asm volatile("clflush (%0)" :: "r" (adr + i));
+		clflush(adr+i);
 }
 
 static void flush_kernel_map(void *arg)
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index df8da72..41f46df 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
 		SetPageReserved(virt_to_page((char *)page));
 
 		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
-			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
+			clflush((char *)page+offset);
 
 		efficeon_private.l1_table[index] = page;
 
@@ -268,15 +268,16 @@ static int efficeon_insert_memory(struct agp_memory * mem, off_t pg_start, int t
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
diff --git a/include/asm-i386/system.h b/include/asm-i386/system.h
index 609756c..d05476d 100644
--- a/include/asm-i386/system.h
+++ b/include/asm-i386/system.h
@@ -160,6 +160,10 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
+}
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index e4f246d..8634067 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -113,6 +113,11 @@ static inline void write_cr4(unsigned long val)
 
 #endif	/* __KERNEL__ */
 
+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
+}
+
 #define nop() __asm__ __volatile__ ("nop")
 
 #ifdef CONFIG_SMP
