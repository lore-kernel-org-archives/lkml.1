Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXLMQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXLMQ7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762405AbXLMQ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:58:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762232AbXLMQ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:58:16 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 05/19] introduce gate_desc type.
Date: Thu, 13 Dec 2007 11:57:53 -0200
Message-Id: <11975543382698-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975543173017-git-send-email-gcosta@redhat.com>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <11975542952896-git-send-email-gcosta@redhat.com> <11975543001070-git-send-email-gcosta@redhat.com> <1197554307167-git-send-email-gcosta@redhat.com> <11975543173017-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To account for the differences in gate descriptor in i386 and x86_64
a gate_desc type is introduced.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/traps_32.c  |    3 ++-
 include/asm-x86/desc_32.h   |   15 ++++++++-------
 include/asm-x86/desc_64.h   |    4 ++--
 include/asm-x86/desc_defs.h |    8 +++++++-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 94c5aea..6b03d88 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -76,8 +76,8 @@ char ignore_fpu_irq = 0;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-struct desc_struct idt_table[256]
-	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+gate_desc idt_table[256]
+	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index bc5ca34..77f1e5a 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -3,6 +3,7 @@
 
 #include <asm/ldt.h>
 #include <asm/segment.h>
+#include <asm/desc_defs.h>
 
 #ifndef __ASSEMBLY__
 
@@ -24,7 +25,7 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 }
 
 extern struct desc_ptr idt_descr;
-extern struct desc_struct idt_table[];
+extern gate_desc idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
 static inline void pack_descriptor(__u32 *a, __u32 *b,
@@ -35,11 +36,11 @@ static inline void pack_descriptor(__u32 *a, __u32 *b,
 		(limit & 0x000f0000) | ((type & 0xff) << 8) | ((flags & 0xf) << 20);
 }
 
-static inline void pack_gate(__u32 *a, __u32 *b,
+static inline void pack_gate(gate_desc *gate,
 	unsigned long base, unsigned short seg, unsigned char type, unsigned char flags)
 {
-	*a = (seg << 16) | (base & 0xffff);
-	*b = (base & 0xffff0000) | ((type & 0xff) << 8) | (flags & 0xff);
+	gate->a = (seg << 16) | (base & 0xffff);
+	gate->b = (base & 0xffff0000) | ((type & 0xff) << 8) | (flags & 0xff);
 }
 
 #define DESCTYPE_LDT 	0x82	/* present, system, DPL-0, LDT */
@@ -139,9 +140,9 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 
 static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned short seg)
 {
-	__u32 a, b;
-	pack_gate(&a, &b, (unsigned long)addr, seg, type, 0);
-	write_idt_entry(idt_table, gate, a, b);
+	gate_desc g;
+	pack_gate(&g, (unsigned long)addr, seg, type, 0);
+	write_idt_entry(idt_table, gate, g.a, g.b);
 }
 
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 660cc84..ffc6c06 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -30,7 +30,7 @@ static inline unsigned long __store_tr(void)
 
 #define store_tr(tr) (tr) = __store_tr()
 
-extern struct gate_struct idt_table[];
+extern gate_desc idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
 static inline void write_ldt_entry(struct desc_struct *ldt,
@@ -58,7 +58,7 @@ static inline void store_gdt(struct desc_ptr *ptr)
 static inline void _set_gate(void *adr, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist)
 {
-	struct gate_struct s;
+	gate_desc s;
 
 	s.offset_low = PTR_LOW(func);
 	s.segment = __KERNEL_CS;
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index f37b44c..05eff93 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -39,7 +39,7 @@ enum {
 };
 
 // 16byte gate
-struct gate_struct {
+struct gate_struct64 {
 	u16 offset_low;
 	u16 segment;
 	unsigned ist : 3, zero0 : 5, type : 5, dpl : 2, p : 1;
@@ -67,6 +67,12 @@ struct ldttss_desc {
 	u32 zero1;
 } __attribute__((packed));
 
+#ifdef CONFIG_X86_64
+typedef struct gate_struct64 gate_desc;
+#else
+typedef struct desc_struct gate_desc;
+#endif
+
 struct desc_ptr {
 	unsigned short size;
 	unsigned long address;
-- 
1.5.0.6

