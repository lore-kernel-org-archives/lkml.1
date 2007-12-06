Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXLFTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXLFTBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXLFTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbXLFTBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:01 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/19] unify desc_struct
Date: Thu,  6 Dec 2007 14:16:22 -0200
Message-Id: <11969578092869-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196957800568-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to make the access of struct desc_struct variables
equal across architectures. In this patch, I unify the i386 and x86_64
versions under an anonymous union, keeping the way they are accessed
untouched (a and b for 32-bit code, individual bit-fields for 64-bit).

This solution is not beautiful, but will allow us to integrate common
code that differed by the way descriptors were used. This is to be viewed
incrementally. There's simply too much code to be fixed at once.

In the future, goal is to set up in a single way of acessing
the desc_struct fields.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apm_32.c       |    2 +-
 arch/x86/kernel/cpu/common.c   |   28 ++++++++++++++--------------
 arch/x86/kernel/process_64.c   |    2 +-
 arch/x86/kernel/traps_32.c     |    2 +-
 include/asm-x86/desc_defs.h    |   28 ++++++++++++++++++++--------
 include/asm-x86/processor_32.h |    5 +----
 6 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 8cd9778..b8b9339 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -405,7 +405,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *	user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static const struct desc_struct	bad_bios_desc = { 0, 0x00409200 };
+static const struct desc_struct	bad_bios_desc = {{{ 0, 0x00409200 }}};
 
 static const char		driver_version[] = "1.16ac";	/* no spaces */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 235cd61..0fe1c1d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,31 +22,31 @@
 #include "cpu.h"
 
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
-	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
-	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { 0x0000ffff, 0x00cff200 },
+	[GDT_ENTRY_KERNEL_CS] = {{{ 0x0000ffff, 0x00cf9a00 }}},
+	[GDT_ENTRY_KERNEL_DS] = {{{ 0x0000ffff, 0x00cf9200 }}},
+	[GDT_ENTRY_DEFAULT_USER_CS] = {{{ 0x0000ffff, 0x00cffa00 }}},
+	[GDT_ENTRY_DEFAULT_USER_DS] = {{{ 0x0000ffff, 0x00cff200 }}},
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
 	 * They code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
-	[GDT_ENTRY_PNPBIOS_CS32] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
-	[GDT_ENTRY_PNPBIOS_CS16] = { 0x0000ffff, 0x00009a00 },/* 16-bit code */
-	[GDT_ENTRY_PNPBIOS_DS] = { 0x0000ffff, 0x00009200 }, /* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS1] = { 0x00000000, 0x00009200 },/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS2] = { 0x00000000, 0x00009200 },/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_CS32] = {{{ 0x0000ffff, 0x00409a00 }}},/* 32-bit code */
+	[GDT_ENTRY_PNPBIOS_CS16] = {{{ 0x0000ffff, 0x00009a00 }}},/* 16-bit code */
+	[GDT_ENTRY_PNPBIOS_DS] = {{{ 0x0000ffff, 0x00009200 }}}, /* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS1] = {{{ 0x00000000, 0x00009200 }}},/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS2] = {{{ 0x00000000, 0x00009200 }}},/* 16-bit data */
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
-	[GDT_ENTRY_APMBIOS_BASE] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
+	[GDT_ENTRY_APMBIOS_BASE] = {{{ 0x0000ffff, 0x00409a00 }}},/* 32-bit code */
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1] = { 0x0000ffff, 0x00009a00 },
-	[GDT_ENTRY_APMBIOS_BASE+2] = { 0x0000ffff, 0x00409200 }, /* data */
+	[GDT_ENTRY_APMBIOS_BASE+1] = {{{ 0x0000ffff, 0x00009a00 }}},
+	[GDT_ENTRY_APMBIOS_BASE+2] = {{{ 0x0000ffff, 0x00409200 }}}, /* data */
 
-	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
-	[GDT_ENTRY_PERCPU] = { 0x00000000, 0x00000000 },
+	[GDT_ENTRY_ESPFIX_SS] = {{{ 0x00000000, 0x00c09200 }}},
+	[GDT_ENTRY_PERCPU] = {{{ 0x00000000, 0x00000000 }}},
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6724840..9e99cb7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -437,7 +437,7 @@ static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 		.limit_in_pages = 1,
 		.useable = 1,
 	};
-	struct n_desc_struct *desc = (void *)t->thread.tls_array;
+	struct desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
 	desc->a = LDT_entry_a(&ud);
 	desc->b = LDT_entry_b(&ud);
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index e15014e..94c5aea 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -76,7 +76,7 @@ char ignore_fpu_irq = 0;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-struct desc_struct idt_table[256] __attribute__((__section__(".data.idt"))) = { {0, 0}, };
+struct desc_struct idt_table[256] __attribute__((__section__(".data.idt"))) = { {{{ 0, 0 }}}, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 0890040..b3db064 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -11,18 +11,30 @@
 
 #include <linux/types.h>
 
+/*
+ * FIXME: Acessing the desc_struct through its fields is more elegant,
+ * and should be the one valid thing to do. However, a lot of open code
+ * still touches the a and b acessors, and doing this allow us to do it
+ * incrementally. We keep the signature as a struct, rather than an union,
+ * so we can get rid of it transparently in the future -- glommer
+ */
+#define raw_desc_struct struct { unsigned int a, b; }
+#define detailed_desc_struct                                   \
+  struct {                                                       \
+	u16 limit0;                                             \
+	u16 base0;                                              \
+	unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;    \
+	unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 :8;\
+  }
+
 // 8 byte segment descriptor
 struct desc_struct {
-	u16 limit0;
-	u16 base0;
-	unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
-	unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 : 8;
+	union {
+		raw_desc_struct;
+		detailed_desc_struct;
+	};
 } __attribute__((packed));
 
-struct n_desc_struct {
-	unsigned int a,b;
-};
-
 enum {
 	GATE_INTERRUPT = 0xE,
 	GATE_TRAP = 0xF,
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 0d83da1..f1fc049 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -20,14 +20,11 @@
 #include <linux/cpumask.h>
 #include <linux/init.h>
 #include <asm/processor-flags.h>
+#include <asm/desc_defs.h>
 
 /* flag for disabling the tsc */
 extern int tsc_disable;
 
-struct desc_struct {
-	unsigned long a,b;
-};
-
 static inline int desc_empty(const void *ptr)
 {
 	const u32 *desc = ptr;
-- 
1.4.4.2

