Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXLLPme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXLLPme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbXLLPjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:39:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbXLLPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:39:54 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 12/19] change write_ldt_entry signature
Date: Wed, 12 Dec 2007 10:53:57 -0200
Message-Id: <11974641172402-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974641102691-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com> <11974641042757-git-send-email-gcosta@redhat.com> <11974641102691-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch changes the signature of write_ldt_entry.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge.citrix.com>
---
 arch/x86/kernel/ldt.c         |    3 +--
 arch/x86/kernel/paravirt_32.c |    2 +-
 arch/x86/kernel/vmi_32.c      |   11 ++++++++++-
 arch/x86/xen/enlighten.c      |    4 ++--
 include/asm-x86/desc_32.h     |    9 ++++++++-
 include/asm-x86/desc_64.h     |    7 ++-----
 include/asm-x86/paravirt.h    |   10 ++++++----
 7 files changed, 30 insertions(+), 16 deletions(-)

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
diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index 77602c1..dd063fb 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -379,7 +379,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
-	.write_ldt_entry = write_dt_entry,
+	.write_ldt_entry = native_write_ldt_entry,
 	.write_gdt_entry = native_write_gdt_entry,
 	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 21edd0d..10c4641 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -64,6 +64,7 @@ static struct {
 	void (*set_tr)(u32 selector);
 	void (*write_idt_entry)(struct desc_struct *, int, u32, u32);
 	void (*write_gdt_entry)(struct desc_struct *, int, u32, u32);
+	void (*write_ldt_entry)(struct desc_struct *, int, u32, u32);
 	void (*set_kernel_stack)(u32 selector, u32 sp0);
 	void (*allocate_page)(u32, u32, u32, u32, u32);
 	void (*release_page)(u32, u32);
@@ -229,6 +230,13 @@ static void vmi_write_gdt_entry(struct desc_struct *dt, int entry,
 	vmi_ops.write_gdt_entry(dt, entry, gdt_entry[0], gdt_entry[2]);
 }
 
+static void vmi_write_ldt_entry(struct desc_struct *dt, int entry,
+				const void *desc)
+{
+	u32 *ldt_entry = (u32 *)desc;
+	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[2]);
+}
+
 static void vmi_load_sp0(struct tss_struct *tss,
 				   struct thread_struct *thread)
 {
@@ -805,7 +813,8 @@ static inline int __init activate_vmi(void)
 	para_fill(pv_cpu_ops.store_idt, GetIDT);
 	para_fill(pv_cpu_ops.store_tr, GetTR);
 	pv_cpu_ops.load_tls = vmi_load_tls;
-	para_fill(pv_cpu_ops.write_ldt_entry, WriteLDTEntry);
+	para_wrap(pv_cpu_ops.write_ldt_entry, vmi_write_ldt_entry,
+		  write_ldt_entry, WriteLDTEntry);
 	para_wrap(pv_cpu_ops.write_gdt_entry, vmi_write_gdt_entry,
 		  write_gdt_entry, WriteGDTEntry);
 	para_wrap(pv_cpu_ops.write_idt_entry, vmi_write_idt_entry,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c38240c..c904686 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -357,11 +357,11 @@ static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 }
 
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
-				u32 low, u32 high)
+				const void *ptr)
 {
 	unsigned long lp = (unsigned long)&dt[entrynum];
 	xmaddr_t mach_lp = virt_to_machine(lp);
-	u64 entry = (u64)high << 32 | low;
+	u64 entry = *(u64 *)ptr;
 
 	preempt_disable();
 
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 41d8214..92a72b0 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -69,12 +69,19 @@ static inline void pack_gate(gate_desc *gate,
 #define load_TLS(t, cpu) native_load_tls(t, cpu)
 #define set_ldt native_set_ldt
 
-#define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_ldt_entry(dt, entry, desc) \
+				native_write_ldt_entry(dt, entry, desc)
 #define write_gdt_entry(dt, entry, desc, type) \
 				native_write_gdt_entry(dt, entry, desc, type)
 #define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
+					  const void *desc)
+{
+	memcpy(&ldt[entry], desc, sizeof(struct desc_struct));
+}
+
 static inline void native_write_idt_entry(gate_desc *idt, int entry,
 					  const gate_desc *gate)
 {
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
index 3f2abf2..4f23f43 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -96,8 +96,8 @@ struct pv_cpu_ops {
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
-	void (*write_ldt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+	void (*write_ldt_entry)(struct desc_struct *ldt, int entrynum,
+				const void *desc);
 	void (*write_gdt_entry)(struct desc_struct *,
 				int entrynum, const void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
@@ -660,9 +660,11 @@ static inline void load_TLS(struct thread_struct *t, unsigned cpu)
 {
 	PVOP_VCALL2(pv_cpu_ops.load_tls, t, cpu);
 }
-static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
+
+static inline void write_ldt_entry(struct desc_struct *dt, int entry,
+				   const void *desc)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_ldt_entry, dt, entry, low, high);
+	PVOP_VCALL3(pv_cpu_ops.write_ldt_entry, dt, entry, desc);
 }
 
 static inline void write_gdt_entry(struct desc_struct *dt, int entry,
-- 
1.5.0.6

