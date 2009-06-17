Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbZFQWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbZFQWg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbZFQWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:36:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37805 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762514AbZFQWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:36:43 -0400
X-Sasl-enc: Ksd4cytu1rMd6nqUnMOTNUh8lTKLmYY44WZgCFAAOq/E 1245278204
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Stas Sergeev <stsp@aknet.ru>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 3/3] x86: de-assembler-ize asm/desc.h
Date: Thu, 18 Jun 2009 00:35:59 +0200
Message-Id: <1245278159-6840-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
References: <1245278159-6840-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/desc.h is included in three assembly files, but the only macro
it defines, GET_DESC_BASE, is never used. This patch removes the
includes, removes the macro GET_DESC_BASE and the ASSEMBLY guard
from asm/desc.h.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/include/asm/desc.h |   26 --------------------------
 arch/x86/kernel/entry_32.S  |    1 -
 arch/x86/kernel/head_32.S   |    1 -
 arch/x86/kernel/head_64.S   |    1 -
 4 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c45f415..c993e9e 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_DESC_H
 #define _ASM_X86_DESC_H
 
-#ifndef __ASSEMBLY__
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
@@ -380,29 +379,4 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
 }
 
-#else
-/*
- * GET_DESC_BASE reads the descriptor base of the specified segment.
- *
- * Args:
- *    idx - descriptor index
- *    gdt - GDT pointer
- *    base - 32bit register to which the base will be written
- *    lo_w - lo word of the "base" register
- *    lo_b - lo byte of the "base" register
- *    hi_b - hi byte of the low word of the "base" register
- *
- * Example:
- *    GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
- *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
- */
-#define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
-	movb idx * 8 + 4(gdt), lo_b;			\
-	movb idx * 8 + 7(gdt), hi_b;			\
-	shll $16, base;					\
-	movw idx * 8 + 2(gdt), lo_w;
-
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 848f73f..9f8ce77 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -48,7 +48,6 @@
 #include <asm/segment.h>
 #include <asm/smp.h>
 #include <asm/page_types.h>
-#include <asm/desc.h>
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
 #include <asm/processor-flags.h>
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index dc5ed4b..8663afb 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -13,7 +13,6 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
-#include <asm/desc.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 54b29bb..fa54f78 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -12,7 +12,6 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
-#include <asm/desc.h>
 #include <asm/segment.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-- 
1.5.4.3

