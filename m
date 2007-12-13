Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbXLMExI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbXLMExI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXLMEre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:47:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbXLMErc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:47:32 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 19/19] unify set_tss_desc
Date: Thu, 13 Dec 2007 00:01:52 -0200
Message-Id: <11975114062948-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197511401733-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11975113122984-git-send-email-gcosta@redhat.com> <11975113194101-git-send-email-gcosta@redhat.com> <11975113243875-git-send-email-gcosta@redhat.com> <11975113291722-git-send-email-gcosta@redhat.com> <1197511334416-git-send-email-gcosta@redhat.com> <1197511338810-git-send-email-gcosta@redhat.com> <1197511343355-git-send-email-gcosta@redhat.com> <11975113484194-git-send-email-gcosta@redhat.com> <11975113532186-git-send-email-gcosta@redhat.com> <11975113583644-git-send-email-gcosta@redhat.com> <1197511363887-git-send-email-gcosta@redhat.com> <11975113672937-git-send-email-gcosta@redhat.com> <11975113721808-git-send-email-gcosta@redhat.com> <11975113771692-git-send-email-gcosta@redhat.com> <11975113821418-git-send-email-gcosta@redhat.com> <11975113873364-git-send-email-gcosta@redhat.com> <11975113923422-git-send-email-gcosta@redhat.com> <11975113961144-git-send-email-gcosta@redhat.com> <1197511401733-git-send-email-gc!
 osta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the set_tss_desc between i386 and x86_64,
which can now have a common implementation. After the old
functions are removed from desc_{32,64}.h, nothing important is
left, and the files can be removed.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h    |   40 +++++++++++++++++++++++++++++++++-------
 include/asm-x86/desc_32.h |   27 ---------------------------
 include/asm-x86/desc_64.h |   34 ----------------------------------
 3 files changed, 33 insertions(+), 68 deletions(-)
 delete mode 100644 include/asm-x86/desc_32.h
 delete mode 100644 include/asm-x86/desc_64.h

Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -165,6 +165,39 @@ static inline void pack_ldt(ldt_desc *ld
 #endif
 }
 
+static inline void pack_tss(tss_desc *tss, unsigned long addr,
+			   unsigned size, unsigned entry)
+{
+#ifdef CONFIG_X86_64
+		set_tssldt_descriptor(tss,
+			     addr, entry, size);
+#else
+		pack_descriptor(tss, (unsigned long)addr,
+				size,
+				0x80 | entry, 0);
+#endif
+}
+
+static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
+{
+	struct desc_struct *d = get_cpu_gdt_table(cpu);
+	tss_desc tss;
+
+	/*
+	 * sizeof(unsigned long) coming from an extra "long" at the end
+	 * of the iobitmap. See tss_struct definition in processor.h
+	 *
+	 * -1? seg base+limit should be pointing to the address of the
+	 * last valid byte
+	 */
+	pack_tss(&tss, (unsigned long)addr,
+		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1,
+		DESC_TSS);
+	write_gdt_entry(d, entry, &tss, DESC_TSS);
+}
+
+#define set_tss_desc(cpu, addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
+
 static inline void native_set_ldt(const void *addr, unsigned int entries)
 {
 	if (likely(entries == 0))
@@ -222,12 +255,6 @@ static inline void native_load_tls(struc
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-#ifdef CONFIG_X86_32
-# include "desc_32.h"
-#else
-# include "desc_64.h"
-#endif
-
 #define _LDT_empty(info) (\
 	(info)->base_addr	== 0	&& \
 	(info)->limit		== 0	&& \
Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef __ARCH_DESC_H
-#define __ARCH_DESC_H
-
-#include <asm/ldt.h>
-#include <asm/segment.h>
-#include <asm/desc_defs.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/preempt.h>
-#include <linux/percpu.h>
-
-static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
-{
-	tss_desc tss;
-	pack_descriptor(&tss, (unsigned long)addr,
-			offsetof(struct tss_struct, __cacheline_filler) - 1,
-			DESC_TSS, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), entry, &tss, DESC_TSS);
-}
-
-
-#define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
-
-#endif /* !__ASSEMBLY__ */
-
-#endif
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -1,34 +1 @@
-/* Written 2000 by Andi Kleen */
-#ifndef __ARCH_DESC_H
-#define __ARCH_DESC_H
 
-#include <linux/threads.h>
-#include <asm/ldt.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/string.h>
-
-#include <asm/segment.h>
-
-static inline void set_tss_desc(unsigned cpu, void *addr)
-{
-	struct desc_struct *d = get_cpu_gdt_table(cpu);
-	tss_desc tss;
-
-	/*
-	 * sizeof(unsigned long) coming from an extra "long" at the end
-	 * of the iobitmap. See tss_struct definition in processor.h
-	 *
-	 * -1? seg base+limit should be pointing to the address of the
-	 * last valid byte
-	 */
-	set_tssldt_descriptor(&tss,
-		(unsigned long)addr, DESC_TSS,
-		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
-	write_gdt_entry(d, GDT_ENTRY_TSS, &tss, DESC_TSS);
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif
