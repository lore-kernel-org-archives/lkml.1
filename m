Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXD2AVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXD2AVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXD2AVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:21:23 -0400
Received: from gw.goop.org ([64.81.55.164]:50634 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbXD2AVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:21:20 -0400
Message-ID: <4633E507.7070002@goop.org>
Date: Sat, 28 Apr 2007 17:21:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: init early_gdt_descr and idle task properly on voyager
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize early_gdt_descr and idle task properly.

[ Incremental fix for "i386: introduce voyager smp_ops, fix voyager build" ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/kernel/smpboot.c           |    3 ---
 arch/i386/mach-voyager/voyager_smp.c |    2 ++
 include/asm-i386/processor.h         |    3 +++
 3 files changed, 5 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -763,9 +763,6 @@ static inline struct task_struct * alloc
 #define alloc_idle_task(cpu) fork_idle(cpu)
 #endif
 
-/* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
===================================================================
--- a/arch/i386/mach-voyager/voyager_smp.c
+++ b/arch/i386/mach-voyager/voyager_smp.c
@@ -580,6 +580,8 @@ do_boot_cpu(__u8 cpu)
 	stack_start.esp = (void *) idle->thread.esp;
 
 	init_gdt(cpu);
+ 	per_cpu(current_task, cpu) = idle;
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
===================================================================
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -749,6 +749,9 @@ extern void enable_sep_cpu(void);
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
 extern void cpu_init(void);

