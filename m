Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXLFTGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXLFTGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXLFTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:02:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbXLFTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:02:22 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 19/19] unify set_tss_desc
Date: Thu,  6 Dec 2007 14:16:40 -0200
Message-Id: <11969578973380-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196957892937-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com> <11969578671479-git-send-email-gcosta@redhat.com> <119695787262-git-send-email-gcosta@redhat.com> <11969578773678-git-send-email-gcosta@redhat.com> <11969578811685-git-send-email-gcosta@redhat.com> <11969578862882-git-send-email-gcosta@redhat.com> <1196957892937-git-send-email-gcosta@redhat.com>
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
 include/asm-x86/desc_64.h |   34 ----------------------------------
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 1290757..4aab1fd 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -133,6 +133,39 @@ static inline void pack_ldt(ldt_desc *ldt, unsigned long addr,
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
+	write_gdt_entry(d, entry, &tss, sizeof(tss));
+}
+
+#define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
+
 static inline void native_set_ldt(const void *addr, unsigned int entries)
 {
 	if (likely(entries == 0))
@@ -191,13 +224,6 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 }
 #endif /* __ASSEMBLY__ */
 
-
-#ifdef CONFIG_X86_32
-# include "desc_32.h"
-#else
-# include "desc_64.h"
-#endif
-
 #ifndef __ASSEMBLY__
 
 #define _LDT_empty(info) (\
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
deleted file mode 100644
index de37b9b..0000000
--- a/include/asm-x86/desc_64.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* Written 2000 by Andi Kleen */
-#ifndef __ARCH_DESC_H
-#define __ARCH_DESC_H
-
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
-	write_gdt_entry(d, GDT_ENTRY_TSS, &tss, sizeof(tss_desc));
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif
-- 
1.4.4.2

