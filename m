Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXLFTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXLFTD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXLFTBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbXLFTBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:40 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 9/19] introduce fill_ldt
Date: Thu,  6 Dec 2007 14:16:30 -0200
Message-Id: <11969578483552-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578431489-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com>
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

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 7eb0c8a..3e872b4 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -223,8 +223,7 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		}
 	}
 
-	ldt.a = LDT_entry_a(&ldt_info);
-	ldt.b = LDT_entry_b(&ldt_info);
+	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
 		ldt.avl = 0;
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9e99cb7..8b6d492 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -439,8 +439,7 @@ static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 	};
 	struct desc_struct *desc = (void *)t->thread.tls_array;
 	desc += tls;
-	desc->a = LDT_entry_a(&ud);
-	desc->b = LDT_entry_b(&ud);
+	fill_ldt(desc, &ud);
 }
 
 static inline u32 read_32bit_tls(struct task_struct *t, int tls)
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 67a3776..74d2b65 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -67,10 +67,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
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
 
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index e77ed8c..3653c9f 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -162,21 +162,6 @@ static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const vo
 
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
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 8fe1b4c..e0aa4bc 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -147,23 +147,6 @@ static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
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
diff --git a/include/asm-x86/ldt.h b/include/asm-x86/ldt.h
index 20c5972..5f00d02 100644
--- a/include/asm-x86/ldt.h
+++ b/include/asm-x86/ldt.h
@@ -5,6 +5,7 @@
  */
 #ifndef _ASM_X86_LDT_H
 #define _ASM_X86_LDT_H
+#include <asm/desc_defs.h>
 
 /* Maximum number of LDT entries supported. */
 #define LDT_ENTRIES	8192
@@ -32,6 +33,24 @@ struct user_desc {
 #endif
 };
 
+static inline void fill_ldt(struct desc_struct *desc, struct user_desc *info)
+{
+	desc->limit0 = info->limit & 0x0ffff;
+	desc->base0 = info->base_addr & 0x0000ffff;
+
+	desc->base1 = info->base_addr & 0x00ff0000;
+	desc->type = (info->read_exec_only ^ 1) << 1;
+	desc->type |= info->contents << 2;
+	desc->s = 1;
+	desc->dpl = 0x3;
+	desc->p = info->seg_not_present ^ 1;
+	desc->limit = info->limit & 0xf0000;
+	desc->avl = info->useable;
+	desc->d = info->seg_32bit;
+	desc->g = info->limit_in_pages;
+	desc->base2 = info->base_addr & 0xff000000;
+}
+
 #define MODIFY_LDT_CONTENTS_DATA	0
 #define MODIFY_LDT_CONTENTS_STACK	1
 #define MODIFY_LDT_CONTENTS_CODE	2
-- 
1.4.4.2

