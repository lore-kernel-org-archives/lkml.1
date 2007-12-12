Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbXLLPi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbXLLPi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbXLLPii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:38:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbXLLPig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:38:36 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 01/19] unify desc_struct
Date: Wed, 12 Dec 2007 10:53:46 -0200
Message-Id: <11974640522688-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974640441088-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com>
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
 include/asm-x86/desc_defs.h    |   25 +++++++++++++++++--------
 include/asm-x86/lguest.h       |    4 ++--
 include/asm-x86/processor_32.h |    5 +----
 7 files changed, 37 insertions(+), 31 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-x86/arch/x86/kernel/apm_32.c
@@ -405,7 +405,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitq
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *	user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static const struct desc_struct	bad_bios_desc = { 0, 0x00409200 };
+static const struct desc_struct	bad_bios_desc = { { { 0, 0x00409200 } } };
 
 static const char		driver_version[] = "1.16ac";	/* no spaces */
 
Index: linux-2.6-x86/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6-x86/arch/x86/kernel/cpu/common.c
@@ -22,31 +22,38 @@
 #include "cpu.h"
 
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
-	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
-	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { 0x0000ffff, 0x00cff200 },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff200 } } },
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
+	/* 32-bit code */
+	[GDT_ENTRY_PNPBIOS_CS32] = { { { 0x0000ffff, 0x00409a00 } } },
+	/* 16-bit code */
+	[GDT_ENTRY_PNPBIOS_CS16] = { { { 0x0000ffff, 0x00009a00 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_DS] = { { { 0x0000ffff, 0x00009200 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS1] = { { { 0x00000000, 0x00009200 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS2] = { { { 0x00000000, 0x00009200 } } },
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
-	[GDT_ENTRY_APMBIOS_BASE] = { 0x0000ffff, 0x00409a00 },/* 32-bit code */
+	/* 32-bit code */
+	[GDT_ENTRY_APMBIOS_BASE] = { { { 0x0000ffff, 0x00409a00 } } },
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1] = { 0x0000ffff, 0x00009a00 },
-	[GDT_ENTRY_APMBIOS_BASE+2] = { 0x0000ffff, 0x00409200 }, /* data */
+	[GDT_ENTRY_APMBIOS_BASE+1] = { { { 0x0000ffff, 0x00009a00 } } },
+	/* data */
+	[GDT_ENTRY_APMBIOS_BASE+2] = { { { 0x0000ffff, 0x00409200 } } },
 
-	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
-	[GDT_ENTRY_PERCPU] = { 0x00000000, 0x00000000 },
+	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-x86/arch/x86/kernel/process_64.c
@@ -444,7 +444,7 @@ static inline void set_32bit_tls(struct 
 		.limit_in_pages = 1,
 		.useable = 1,
 	};
-	struct n_desc_struct *desc = (void *)t->thread.tls_array;
+	struct desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
 	desc->a = LDT_entry_a(&ud);
 	desc->b = LDT_entry_b(&ud);
Index: linux-2.6-x86/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6-x86/arch/x86/kernel/traps_32.c
@@ -76,7 +76,8 @@ char ignore_fpu_irq = 0;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-struct desc_struct idt_table[256] __attribute__((__section__(".data.idt"))) = { {0, 0}, };
+struct desc_struct idt_table[256]
+	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
Index: linux-2.6-x86/include/asm-x86/desc_defs.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_defs.h
+++ linux-2.6-x86/include/asm-x86/desc_defs.h
@@ -11,17 +11,26 @@
 
 #include <linux/types.h>
 
+/*
+ * FIXME: Acessing the desc_struct through its fields is more elegant,
+ * and should be the one valid thing to do. However, a lot of open code
+ * still touches the a and b acessors, and doing this allow us to do it
+ * incrementally. We keep the signature as a struct, rather than an union,
+ * so we can get rid of it transparently in the future -- glommer
+ */
 // 8 byte segment descriptor
 struct desc_struct {
-	u16 limit0;
-	u16 base0;
-	unsigned base1 : 8, type : 4, s : 1, dpl : 2, p : 1;
-	unsigned limit : 4, avl : 1, l : 1, d : 1, g : 1, base2 : 8;
-} __attribute__((packed));
+	union {
+		struct { unsigned int a, b; };
+		struct {
+			u16 limit0;
+			u16 base0;
+			unsigned base1: 8, type: 4, s: 1, dpl: 2, p: 1;
+			unsigned limit: 4, avl: 1, l: 1, d: 1, g: 1, base2: 8;
+		};
 
-struct n_desc_struct {
-	unsigned int a,b;
-};
+	};
+} __attribute__((packed));
 
 enum {
 	GATE_INTERRUPT = 0xE,
Index: linux-2.6-x86/include/asm-x86/lguest.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/lguest.h
+++ linux-2.6-x86/include/asm-x86/lguest.h
@@ -78,8 +78,8 @@ static inline void lguest_set_ts(void)
 }
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
-#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
-#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
+#define FULL_EXEC_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9b00} } })
+#define FULL_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9300} } })
 
 #endif /* __ASSEMBLY__ */
 
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
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
