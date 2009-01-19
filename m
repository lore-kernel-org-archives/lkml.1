Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZASA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZASA75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZASA7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:59:47 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:40347 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZASA7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=byQufPXXB0+uNSkgAhq4fo0xGeenAEzLHXRW5ltmPHlY10KX6oTdjmrvmtElj+EYXo
         mccCnGCXJxjZ9egFlaereUc07mC/zIhZt6w0DA6YXW5+F9//3vurzcK+ngFVEtXObs62
         leAp2S26neQymLvIUZRiIZ+jeOD9DmEHOOJ3c=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 5/5] x86-64: Remove pda.h
Date: Sun, 18 Jan 2009 19:52:25 -0500
Message-Id: <1232326345-3534-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232326345-3534-4-git-send-email-brgerst@gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
 <1232326345-3534-3-git-send-email-brgerst@gmail.com>
 <1232326345-3534-4-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h        |   39 -------------------------------------
 arch/x86/include/asm/pgtable_64.h |    1 -
 arch/x86/include/asm/smp.h        |    1 -
 arch/x86/kernel/asm-offsets_64.c  |    1 -
 arch/x86/kernel/cpu/common.c      |    1 -
 arch/x86/kernel/process_64.c      |    1 -
 arch/x86/kernel/traps.c           |    1 -
 7 files changed, 0 insertions(+), 45 deletions(-)
 delete mode 100644 arch/x86/include/asm/pda.h

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
deleted file mode 100644
index ba46416..0000000
--- a/arch/x86/include/asm/pda.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _ASM_X86_PDA_H
-#define _ASM_X86_PDA_H
-
-#ifndef __ASSEMBLY__
-#include <linux/stddef.h>
-#include <linux/types.h>
-#include <linux/cache.h>
-#include <linux/threads.h>
-#include <asm/page.h>
-#include <asm/percpu.h>
-
-/* Per processor datastructure. %gs points to it while the kernel runs */
-struct x8664_pda {
-	unsigned long unused1;
-	unsigned long unused2;
-	unsigned long unused3;
-	unsigned long unused4;
-	int unused5;
-	unsigned int unused6;		/* 36 was cpunumber */
-	short in_bootmem;		/* pda lives in bootmem */
-} ____cacheline_aligned_in_smp;
-
-DECLARE_PER_CPU(struct x8664_pda, __pda);
-
-#define cpu_pda(cpu)		(&per_cpu(__pda, cpu))
-
-#define read_pda(field)		percpu_read(__pda.field)
-#define write_pda(field, val)	percpu_write(__pda.field, val)
-#define add_pda(field, val)	percpu_add(__pda.field, val)
-#define sub_pda(field, val)	percpu_sub(__pda.field, val)
-#define or_pda(field, val)	percpu_or(__pda.field, val)
-
-/* This is not atomic against other CPUs -- CPU preemption needs to be off */
-#define test_and_clear_bit_pda(bit, field)				\
-	x86_test_and_clear_bit_percpu(bit, __pda.field)
-
-#endif
-
-#endif /* _ASM_X86_PDA_H */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index ba09289..1df9637 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -11,7 +11,6 @@
 #include <asm/processor.h>
 #include <linux/bitops.h>
 #include <linux/threads.h>
-#include <asm/pda.h>
 
 extern pud_t level3_kernel_pgt[512];
 extern pud_t level3_ident_pgt[512];
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 68636e7..45ef8a1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -15,7 +15,6 @@
 #  include <asm/io_apic.h>
 # endif
 #endif
-#include <asm/pda.h>
 #include <asm/thread_info.h>
 #include <asm/cpumask.h>
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 94f9c8b..8793ab3 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -11,7 +11,6 @@
 #include <linux/hardirq.h>
 #include <linux/suspend.h>
 #include <linux/kbuild.h>
-#include <asm/pda.h>
 #include <asm/processor.h>
 #include <asm/segment.h>
 #include <asm/thread_info.h>
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 94ea5cb..d025877 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -30,7 +30,6 @@
 #include <asm/genapic.h>
 #endif
 
-#include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 604b69e..ec07a17 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -46,7 +46,6 @@
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/mmu_context.h>
-#include <asm/pda.h>
 #include <asm/prctl.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 98c2d05..ed5aee5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -59,7 +59,6 @@
 #ifdef CONFIG_X86_64
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
-#include <asm/pda.h>
 #else
 #include <asm/processor-flags.h>
 #include <asm/arch_hooks.h>
-- 
1.6.1.rc1

