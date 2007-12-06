Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXLFTE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXLFTE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbXLFTBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbXLFTBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:47 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 11/19] change write_ldt_entry signature
Date: Thu,  6 Dec 2007 14:16:32 -0200
Message-Id: <11969578581299-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578534185-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch changes the signature of write_ldt_entry.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/ldt.c      |    3 +--
 arch/x86/xen/enlighten.c   |    4 ++--
 include/asm-x86/desc_32.h  |    9 ++++++++-
 include/asm-x86/desc_64.h  |    7 ++-----
 include/asm-x86/paravirt.h |   10 ++++++----
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 3e872b4..b8ef462 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -229,8 +229,7 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 
 	/* Install the new entry ...  */
 install:
-	write_ldt_entry(mm->context.ldt, ldt_info.entry_number,
-			ldt.a, ldt.b);
+	write_ldt_entry(mm->context.ldt, ldt_info.entry_number, &ldt);
 	error = 0;
 
 out_unlock:
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a552103..16223b6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -357,11 +357,11 @@ static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 }
 
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
-				u32 low, u32 high)
+				void *ptr)
 {
 	unsigned long lp = (unsigned long)&dt[entrynum];
 	xmaddr_t mach_lp = virt_to_machine(lp);
-	u64 entry = (u64)high << 32 | low;
+	u64 entry = *(u64 *)ptr;
 
 	preempt_disable();
 
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 622b0e7..46fe80a 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -68,12 +68,19 @@ static inline void pack_gate(gate_desc *gate,
 #define load_TLS(t, cpu) native_load_tls(t, cpu)
 #define set_ldt native_set_ldt
 
-#define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_ldt_entry(dt, entry, desc) \
+				native_write_ldt_entry(dt, entry, desc)
 #define write_gdt_entry(dt, entry, desc, size) \
 				native_write_gdt_entry(dt, entry, desc, size)
 #define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
+					  void *desc)
+{
+	memcpy(&ldt[entry], desc, size);
+}
+
 static inline void native_write_idt_entry(gate_desc *idt, int entry, gate_desc *gate)
 {
 	memcpy(&idt[entry], gate, sizeof(*gate));
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index e0aa4bc..3cd5f10 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -34,12 +34,9 @@ extern gate_desc idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
 static inline void write_ldt_entry(struct desc_struct *ldt,
-				   int entry, u32 entry_low, u32 entry_high)
+				   int entry, void *ptr)
 {
-	__u32 *lp = (__u32 *)((entry << 3) + (char *)ldt);
-
-	lp[0] = entry_low;
-	lp[1] = entry_high;
+	memcpy(&ldt[entry], ptr, 8);
 }
 
 /* the cpu gdt accessor */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index a3e22b7..b855264 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -96,8 +96,8 @@ struct pv_cpu_ops {
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
-	void (*write_ldt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+	void (*write_ldt_entry)(struct desc_struct *ldt, int entrynum,
+				void *desc);
 	void (*write_gdt_entry)(struct desc_struct *,
 				int entrynum, void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
@@ -660,9 +660,11 @@ static inline void load_TLS(struct thread_struct *t, unsigned cpu)
 {
 	PVOP_VCALL2(pv_cpu_ops.load_tls, t, cpu);
 }
-static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
+
+static inline void write_ldt_entry(struct desc_struct *dt, int entry,
+				   void *desc)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_ldt_entry, dt, entry, low, high);
+	PVOP_VCALL3(pv_cpu_ops.write_ldt_entry, dt, entry, desc);
 }
 
 static inline void write_gdt_entry(struct desc_struct *dt, int entry,
-- 
1.4.4.2

