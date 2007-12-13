Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbXLMWKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbXLMWKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765783AbXLMWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:10:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765444AbXLMWJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:09:59 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and pack_tss
Date: Thu, 13 Dec 2007 17:25:37 -0200
Message-Id: <11975739373761-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By Andi Kleen's suggestion, this patch removes pack_ldt() and pack_tss()
wrappers in favour of a general wrapper. It saves us an ifdef and some lines
of code, but more importantly, it's more elegant.

No functional change is made, although the object code is expected to be
different.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h |   58 +++++++++++++++---------------------------------
 1 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 8849666..161a6d6 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -125,21 +125,6 @@ static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
 	memcpy(&gdt[entry], desc, size);
 }
 
-static inline void set_tssldt_descriptor(struct ldttss_desc64 *d,
-					 unsigned long tss, unsigned type,
-					 unsigned size)
-{
-	memset(d, 0, sizeof(*d));
-	d->limit0 = size & 0xFFFF;
-	d->base0 = PTR_LOW(tss);
-	d->base1 = PTR_MIDDLE(tss) & 0xFF;
-	d->type = type;
-	d->p = 1;
-	d->limit1 = (size >> 16) & 0xF;
-	d->base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF;
-	d->base3 = PTR_HIGH(tss);
-}
-
 static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 				   unsigned long limit, unsigned char type,
 				   unsigned char flags)
@@ -151,30 +136,24 @@ static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 	desc->p = 1;
 }
 
-static inline void pack_ldt(ldt_desc *ldt, unsigned long addr,
-			   unsigned size)
-{
 
-#ifdef CONFIG_X86_64
-		set_tssldt_descriptor(ldt,
-			     addr, DESC_LDT, size);
-#else
-		pack_descriptor(ldt, (unsigned long)addr,
-				size,
-				0x80 | DESC_LDT, 0);
-#endif
-}
-
-static inline void pack_tss(tss_desc *tss, unsigned long addr,
-			   unsigned size, unsigned entry)
+static inline void set_tssldt_descriptor(void *d, unsigned long addr,
+					 unsigned type, unsigned size)
 {
 #ifdef CONFIG_X86_64
-		set_tssldt_descriptor(tss,
-			     addr, entry, size);
+	struct ldttss_desc64 *desc = d;
+	memset(desc, 0, sizeof(*desc));
+	desc->limit0 = size & 0xFFFF;
+	desc->base0 = PTR_LOW(addr);
+	desc->base1 = PTR_MIDDLE(addr) & 0xFF;
+	desc->type = type;
+	desc->p = 1;
+	desc->limit1 = (size >> 16) & 0xF;
+	desc->base2 = (PTR_MIDDLE(addr) >> 8) & 0xFF;
+	desc->base3 = PTR_HIGH(addr);
 #else
-		pack_descriptor(tss, (unsigned long)addr,
-				size,
-				0x80 | entry, 0);
+
+	pack_descriptor((struct desc_struct *)d, addr, size, 0x80 | type, 0);
 #endif
 }
 
@@ -190,9 +169,8 @@ static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
 	 * -1? seg base+limit should be pointing to the address of the
 	 * last valid byte
 	 */
-	pack_tss(&tss, (unsigned long)addr,
-		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1,
-		DESC_TSS);
+	set_tssldt_descriptor(&tss, (unsigned long)addr, DESC_TSS,
+		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
 	write_gdt_entry(d, entry, &tss, DESC_TSS);
 }
 
@@ -206,8 +184,8 @@ static inline void native_set_ldt(const void *addr, unsigned int entries)
 		unsigned cpu = smp_processor_id();
 		ldt_desc ldt;
 
-		pack_ldt(&ldt, (unsigned long)addr,
-				entries * sizeof(ldt) - 1);
+		set_tssldt_descriptor(&ldt, (unsigned long)addr,
+				      DESC_LDT, entries * sizeof(ldt) - 1);
 		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
 				&ldt, DESC_LDT);
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
-- 
1.4.4.2

