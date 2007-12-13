Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbXLMEvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbXLMEvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXLMErS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:47:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbXLMErO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:47:14 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 09/19] introduce fill_ldt
Date: Thu, 13 Dec 2007 00:01:42 -0200
Message-Id: <11975113583644-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975113532186-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11975113122984-git-send-email-gcosta@redhat.com> <11975113194101-git-send-email-gcosta@redhat.com> <11975113243875-git-send-email-gcosta@redhat.com> <11975113291722-git-send-email-gcosta@redhat.com> <1197511334416-git-send-email-gcosta@redhat.com> <1197511338810-git-send-email-gcosta@redhat.com> <1197511343355-git-send-email-gcosta@redhat.com> <11975113484194-git-send-email-gcosta@redhat.com> <11975113532186-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces fill_ldt(), which populates a ldt descriptor
from a user_desc in once, instead of relying in the LDT_entry_a and
LDT_entry_b macros

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/ldt.c        |    3 +--
 arch/x86/kernel/process_64.c |    3 +--
 arch/x86/kernel/tls.c        |    7 +++----
 include/asm-x86/desc_32.h    |   15 ---------------
 include/asm-x86/desc_64.h    |   17 -----------------
 include/asm-x86/ldt.h        |   19 +++++++++++++++++++
 6 files changed, 24 insertions(+), 40 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/ldt.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ldt.c
+++ linux-2.6-x86/arch/x86/kernel/ldt.c
@@ -223,8 +223,7 @@ static int write_ldt(void __user *ptr, u
 		}
 	}
 
-	ldt.a = LDT_entry_a(&ldt_info);
-	ldt.b = LDT_entry_b(&ldt_info);
+	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
 		ldt.avl = 0;
 
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-x86/arch/x86/kernel/process_64.c
@@ -446,8 +446,7 @@ static inline void set_32bit_tls(struct 
 	};
 	struct desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
-	desc->a = LDT_entry_a(&ud);
-	desc->b = LDT_entry_b(&ud);
+	fill_ldt(desc, &ud);
 }
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
Index: linux-2.6-x86/arch/x86/kernel/tls.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/tls.c
+++ linux-2.6-x86/arch/x86/kernel/tls.c
@@ -67,10 +67,9 @@ int do_set_thread_area(struct task_struc
 	if (LDT_empty(&info)) {
 		desc[0] = 0;
 		desc[1] = 0;
-	} else {
-		desc[0] = LDT_entry_a(&info);
-		desc[1] = LDT_entry_b(&info);
-	}
+	} else
+		fill_ldt((struct desc_struct *)desc, &info);
+
 	if (t == &current->thread)
 		load_TLS(t, cpu);
 
Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ linux-2.6-x86/include/asm-x86/desc_32.h
@@ -163,21 +163,6 @@ static inline void __set_tss_desc(unsign
 
 #define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
 
-#define LDT_entry_a(info) \
-	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
-
-#define LDT_entry_b(info) \
-	(((info)->base_addr & 0xff000000) | \
-	(((info)->base_addr & 0x00ff0000) >> 16) | \
-	((info)->limit & 0xf0000) | \
-	(((info)->read_exec_only ^ 1) << 9) | \
-	((info)->contents << 10) | \
-	(((info)->seg_not_present ^ 1) << 15) | \
-	((info)->seg_32bit << 22) | \
-	((info)->limit_in_pages << 23) | \
-	((info)->useable << 20) | \
-	0x7000)
-
 #define LDT_empty(info) (\
 	(info)->base_addr	== 0	&& \
 	(info)->limit		== 0	&& \
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -147,23 +147,6 @@ static inline void set_ldt_desc(unsigned
 			     (unsigned long)addr, DESC_LDT, size * 8 - 1);
 }
 
-#define LDT_entry_a(info) \
-	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
-/* Don't allow setting of the lm bit. It is useless anyways because
-   64bit system calls require __USER_CS. */
-#define LDT_entry_b(info) \
-	(((info)->base_addr & 0xff000000) | \
-	(((info)->base_addr & 0x00ff0000) >> 16) | \
-	((info)->limit & 0xf0000) | \
-	(((info)->read_exec_only ^ 1) << 9) | \
-	((info)->contents << 10) | \
-	(((info)->seg_not_present ^ 1) << 15) | \
-	((info)->seg_32bit << 22) | \
-	((info)->limit_in_pages << 23) | \
-	((info)->useable << 20) | \
-	/* ((info)->lm << 21) | */ \
-	0x7000)
-
 #define LDT_empty(info) (\
 	(info)->base_addr	== 0	&& \
 	(info)->limit		== 0	&& \
Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -1,5 +1,34 @@
+#ifndef _ASM_DESC_H_
+#define _ASM_DESC_H_
+
+#ifndef __ASSEMBLY__
+#include <asm/desc_defs.h>
+#include <asm/ldt.h>
+
+static inline void fill_ldt(struct desc_struct *desc, struct user_desc *info)
+{
+	desc->limit0 = info->limit & 0x0ffff;
+	desc->base0 = info->base_addr & 0x0000ffff;
+
+	desc->base1 = (info->base_addr & 0x00ff0000) >> 16;
+	desc->type = (info->read_exec_only ^ 1) << 1;
+	desc->type |= info->contents << 2;
+	desc->s = 1;
+	desc->dpl = 0x3;
+	desc->p = info->seg_not_present ^ 1;
+	desc->limit = (info->limit & 0xf0000) >> 16;
+	desc->avl = info->useable;
+	desc->d = info->seg_32bit;
+	desc->g = info->limit_in_pages;
+	desc->base2 = (info->base_addr & 0xff000000) >> 24;
+}
+
+#endif
+
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
 #else
 # include "desc_64.h"
 #endif
+
+#endif
