Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbZELCGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbZELCGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZELCGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:06:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41493 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZELCGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:06:15 -0400
Date: Mon, 11 May 2009 22:05:28 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <20090512020614.4891.63987.sendpatchset@localhost.localdomain>
Subject: [PATCH] x86: merge process.c a bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merge arch_align_stack() and arch_randomize_brk(), since
they are the same.

Tested on x86_64.

Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..2b9a8d0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
+#include <linux/random.h>
 #include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -613,3 +614,16 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
+unsigned long arch_align_stack(unsigned long sp)
+{
+	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+		sp -= get_random_int() % 8192;
+	return sp & ~0xf;
+}
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..a3bb049 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
@@ -497,15 +496,3 @@ unsigned long get_wchan(struct task_struct *p)
 	return 0;
 }
 
-unsigned long arch_align_stack(unsigned long sp)
-{
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
-	return sp & ~0xf;
-}
-
-unsigned long arch_randomize_brk(struct mm_struct *mm)
-{
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
-}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..34386f7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
-#include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
@@ -660,15 +659,3 @@ long sys_arch_prctl(int code, unsigned long addr)
 	return do_arch_prctl(current, code, addr);
 }
 
-unsigned long arch_align_stack(unsigned long sp)
-{
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
-	return sp & ~0xf;
-}
-
-unsigned long arch_randomize_brk(struct mm_struct *mm)
-{
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
-}
