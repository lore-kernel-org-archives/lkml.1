Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYJHTZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYJHTZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYJHTY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:24:57 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:50982 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbYJHTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:24:56 -0400
Date: Thu, 9 Oct 2008 00:54:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 4/9] Modify kprobe exception handler to recognise
	single-stepping by HW Breakpoint handler
Message-ID: <20081008192445.GD4989@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008192044.GA4510@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the kprobe handler to help it recognise single-stepping by
the HW Breakpoint exception code. A per-cpu variable called 'sstep_reason' to
distinguish the source of single-step exceptions.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/kprobes.c |   18 ++++++++++++++++--
 include/asm-x86/kprobes.h |    8 ++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/kprobes.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/kprobes.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/kprobes.c
@@ -54,6 +54,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/debugreg.h>
 
 void jprobe_return_end(void);
 
@@ -517,6 +518,7 @@ static int __kprobes kprobe_handler(stru
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
+	unsigned int *ssr;
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 	if (*addr != BREAKPOINT_INSTRUCTION) {
@@ -541,6 +543,7 @@ static int __kprobes kprobe_handler(stru
 	 */
 	preempt_disable();
 
+	ssr = &(__get_cpu_var(sstep_reason));
 	kcb = get_kprobe_ctlblk();
 	p = get_kprobe(addr);
 
@@ -560,14 +563,17 @@ static int __kprobes kprobe_handler(stru
 			 * for jprobe processing, so get out doing nothing
 			 * more here.
 			 */
-			if (!p->pre_handler || !p->pre_handler(p, regs))
+			if (!p->pre_handler || !p->pre_handler(p, regs)) {
 				setup_singlestep(p, regs, kcb);
+				(*ssr) |= SSTEP_KPROBE;
+			}
 			return 1;
 		}
 	} else if (kprobe_running()) {
 		p = __get_cpu_var(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			setup_singlestep(p, regs, kcb);
+			(*ssr) |= SSTEP_KPROBE;
 			return 1;
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */
@@ -952,6 +958,7 @@ int __kprobes kprobe_exceptions_notify(s
 {
 	struct die_args *args = data;
 	int ret = NOTIFY_DONE;
+	unsigned int *ssr = &(__get_cpu_var(sstep_reason));
 
 	if (args->regs && user_mode_vm(args->regs))
 		return ret;
@@ -962,8 +969,15 @@ int __kprobes kprobe_exceptions_notify(s
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
+		/* We could be here due to single-stepping after a pre-handler
+		 * execution of HW Breakpoint or kprobes. We determine the cause
+		 * using the bitmask flag 'sstep_reason'.
+		 */
+		if (((*ssr) & SSTEP_KPROBE) &&
+					post_kprobe_handler(args->regs)) {
+			current->thread.vdr6 &= ~DR_STEP;
 			ret = NOTIFY_STOP;
+		}
 		break;
 	case DIE_GPF:
 		/*
Index: linux-bkpt-lkml-27-rc9/include/asm-x86/kprobes.h
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/include/asm-x86/kprobes.h
+++ linux-bkpt-lkml-27-rc9/include/asm-x86/kprobes.h
@@ -30,6 +30,14 @@
 struct pt_regs;
 struct kprobe;
 
+/* Single stepping can be initiated for kprobes post handler or following HW
+ * Breakpoint exception. The bitmask below is used to identify the cause.
+ */
+#define SSTEP_KPROBE 1
+#define SSTEP_HWBKPT 2
+
+DECLARE_PER_CPU(unsigned int, sstep_reason);
+
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_INSTRUCTION 0xe9
