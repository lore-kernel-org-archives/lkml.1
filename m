Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbZL1I1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbZL1I1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZL1I1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:27:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54970 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZL1I1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:27:02 -0500
Subject: [RFC/PATCH] x86: Use KERN_DEFAULT log-level in __show_regs()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: vegard.nossum@gmail.com, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Dec 2009 10:26:59 +0200
Message-Id: <1261988819.4641.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Andrew Morton reported a strange looking kmemcheck warning:

  WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88004fba6c20)
  0000000000000000310000000000000000000000000000002413000000c9ffff
   u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u

   [<ffffffff810af3aa>] kmemleak_scan+0x25a/0x540
   [<ffffffff810afbcb>] kmemleak_scan_thread+0x5b/0xe0
   [<ffffffff8104d0fe>] kthread+0x9e/0xb0
   [<ffffffff81003074>] kernel_thread_helper+0x4/0x10
   [<ffffffffffffffff>] 0xffffffffffffffff

The above printout is missing register dump completely. The problem here is
that the output comes from syslog which doesn't show KERN_INFO log-level
messages. We didn't see this before because both of us were testing on 32-bit
kernels which use the _default_ log-level.

Fix that up by explicitly using KERN_DEFAULT log-level for __show_regs()
printks.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/process.c    |    4 ++--
 arch/x86/kernel/process_32.c |   14 +++++++-------
 arch/x86/kernel/process_64.c |   24 ++++++++++++------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 98c2cde..c6ee241 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -103,8 +103,8 @@ void show_regs_common(void)
 	if (!product)
 		product = "";
 
-	printk("\n");
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
+	printk(KERN_CONT "\n");
+	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9c517b5..37ad1e0 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -139,16 +139,16 @@ void __show_regs(struct pt_regs *regs, int all)
 
 	show_regs_common();
 
-	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
+	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
 	print_symbol("EIP is at %s\n", regs->ip);
 
-	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
+	printk(KERN_DEFAULT "EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
 		regs->ax, regs->bx, regs->cx, regs->dx);
-	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
+	printk(KERN_DEFAULT "ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
 		regs->si, regs->di, regs->bp, sp);
-	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
+	printk(KERN_DEFAULT " DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
 	       (u16)regs->ds, (u16)regs->es, (u16)regs->fs, gs, ss);
 
 	if (!all)
@@ -158,19 +158,19 @@ void __show_regs(struct pt_regs *regs, int all)
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
-	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
+	printk(KERN_DEFAULT "CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
 			cr0, cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
 			d0, d1, d2, d3);
 
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
-	printk("DR6: %08lx DR7: %08lx\n",
+	printk(KERN_DEFAULT "DR6: %08lx DR7: %08lx\n",
 			d6, d7);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 52fbd0c..f9e0331 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -161,19 +161,19 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned int ds, cs, es;
 
 	show_regs_common();
-	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
+	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
-	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
+	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
 			regs->sp, regs->flags);
-	printk(KERN_INFO "RAX: %016lx RBX: %016lx RCX: %016lx\n",
+	printk(KERN_DEFAULT "RAX: %016lx RBX: %016lx RCX: %016lx\n",
 	       regs->ax, regs->bx, regs->cx);
-	printk(KERN_INFO "RDX: %016lx RSI: %016lx RDI: %016lx\n",
+	printk(KERN_DEFAULT "RDX: %016lx RSI: %016lx RDI: %016lx\n",
 	       regs->dx, regs->si, regs->di);
-	printk(KERN_INFO "RBP: %016lx R08: %016lx R09: %016lx\n",
+	printk(KERN_DEFAULT "RBP: %016lx R08: %016lx R09: %016lx\n",
 	       regs->bp, regs->r8, regs->r9);
-	printk(KERN_INFO "R10: %016lx R11: %016lx R12: %016lx\n",
+	printk(KERN_DEFAULT "R10: %016lx R11: %016lx R12: %016lx\n",
 	       regs->r10, regs->r11, regs->r12);
-	printk(KERN_INFO "R13: %016lx R14: %016lx R15: %016lx\n",
+	printk(KERN_DEFAULT "R13: %016lx R14: %016lx R15: %016lx\n",
 	       regs->r13, regs->r14, regs->r15);
 
 	asm("movl %%ds,%0" : "=r" (ds));
@@ -194,21 +194,21 @@ void __show_regs(struct pt_regs *regs, int all)
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk(KERN_INFO "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	printk(KERN_DEFAULT "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       fs, fsindex, gs, gsindex, shadowgs);
-	printk(KERN_INFO "CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds,
+	printk(KERN_DEFAULT "CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds,
 			es, cr0);
-	printk(KERN_INFO "CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3,
+	printk(KERN_DEFAULT "CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3,
 			cr4);
 
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
-	printk(KERN_INFO "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
+	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
-	printk(KERN_INFO "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+	printk(KERN_DEFAULT "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
 void show_regs(struct pt_regs *regs)
-- 
1.6.0.4



