Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbXLFTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbXLFTCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXLFTBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbXLFTBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:14 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/19] change write_idt_entry signature
Date: Thu,  6 Dec 2007 14:16:27 -0200
Message-Id: <11969578343061-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578292944-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch changes write_idt_entry signature. It now takes a gate_desc
instead of the a and b parameters. It will allow it to be later unified
between i386 and x86_64.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt_32.c |    2 +-
 arch/x86/xen/enlighten.c      |    5 ++---
 include/asm-x86/desc_32.h     |    9 +++++++--
 include/asm-x86/paravirt.h    |    9 +++++----
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index f4e3a8e..9ed46da 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -381,7 +381,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.load_tls = native_load_tls,
 	.write_ldt_entry = write_dt_entry,
 	.write_gdt_entry = write_dt_entry,
-	.write_idt_entry = write_dt_entry,
+	.write_idt_entry = write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
 	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 53b097a..829a450 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -399,8 +399,7 @@ static DEFINE_PER_CPU(struct desc_ptr, idt_desc);
 
 /* Set an IDT entry.  If the entry is part of the current IDT, then
    also update Xen. */
-static void xen_write_idt_entry(struct desc_struct *dt, int entrynum,
-				u32 low, u32 high)
+static void xen_write_idt_entry(gate_desc *dt, int entrynum, gate_desc *g)
 {
 	unsigned long p = (unsigned long)&dt[entrynum];
 	unsigned long start, end;
@@ -412,7 +411,7 @@ static void xen_write_idt_entry(struct desc_struct *dt, int entrynum,
 
 	xen_mc_flush();
 
-	write_dt_entry(dt, entrynum, low, high);
+	native_write_idt_entry(dt, entrynum, g);
 
 	if (p >= start && (p + 8) <= end) {
 		struct trap_info info[2];
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 77f1e5a..e77ed8c 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -70,9 +70,14 @@ static inline void pack_gate(gate_desc *gate,
 
 #define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
 #define write_gdt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
-#define write_idt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
+static inline void native_write_idt_entry(gate_desc *idt, int entry, gate_desc *gate)
+{
+	memcpy(&idt[entry], gate, sizeof(*gate));
+}
+
 static inline void write_dt_entry(struct desc_struct *dt,
 				  int entry, u32 entry_low, u32 entry_high)
 {
@@ -142,7 +147,7 @@ static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned s
 {
 	gate_desc g;
 	pack_gate(&g, (unsigned long)addr, seg, type, 0);
-	write_idt_entry(idt_table, gate, g.a, g.b);
+	write_idt_entry(idt_table, gate, &g);
 }
 
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 0333fb6..d369b85 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -24,6 +24,7 @@ struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
+gate_desc;
 
 /* general info */
 struct pv_info {
@@ -99,8 +100,8 @@ struct pv_cpu_ops {
 				int entrynum, u32 low, u32 high);
 	void (*write_gdt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
-	void (*write_idt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+	void (*write_idt_entry)(gate_desc *,
+				int entrynum, gate_desc *gate);
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
@@ -667,9 +668,9 @@ static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, low, high);
 }
-static inline void write_idt_entry(void *dt, int entry, u32 low, u32 high)
+static inline void write_idt_entry(gate_desc *dt, int entry, gate_desc *g)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_idt_entry, dt, entry, low, high);
+	PVOP_VCALL4(pv_cpu_ops.write_idt_entry, dt, entry, g);
 }
 static inline void set_iopl_mask(unsigned mask)
 {
-- 
1.4.4.2

