Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZGTMBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZGTMBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZGTMBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:01:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:45370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZGTMBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:01:53 -0400
Date: Mon, 20 Jul 2009 12:01:14 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090718150853.GA11294@localhost.localdomain>
References: <20090718150853.GA11294@localhost.localdomain>
Subject: [tip:x86/asm] x86: Use get_desc_base()
Message-ID: <tip-254e0a6bff87ab8b22293c4bd1443507df698407@git.kernel.org>
Git-Commit-ID: 254e0a6bff87ab8b22293c4bd1443507df698407
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Jul 2009 12:01:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  254e0a6bff87ab8b22293c4bd1443507df698407
Gitweb:     http://git.kernel.org/tip/254e0a6bff87ab8b22293c4bd1443507df698407
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sun, 19 Jul 2009 00:08:54 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Jul 2009 18:27:51 +0200

x86: Use get_desc_base()

Use get_desc_base() to get the base address in desc_struct

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090718150853.GA11294@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/doublefault_32.c |    4 +---
 arch/x86/kernel/step.c           |    9 ++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index b4f14c6..37250fe 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -27,9 +27,7 @@ static void doublefault_fn(void)
 
 	if (ptr_ok(gdt)) {
 		gdt += GDT_ENTRY_TSS << 3;
-		tss = *(u16 *)(gdt+2);
-		tss += *(u8 *)(gdt+4) << 16;
-		tss += *(u8 *)(gdt+7) << 24;
+		tss = get_desc_base((struct desc_struct *)gdt);
 		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
 		if (ptr_ok(tss)) {
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index e8b9863..3149032 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/ptrace.h>
+#include <asm/desc.h>
 
 unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
@@ -23,7 +24,7 @@ unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *re
 	 * and APM bios ones we just ignore here.
 	 */
 	if ((seg & SEGMENT_TI_MASK) == SEGMENT_LDT) {
-		u32 *desc;
+		struct desc_struct *desc;
 		unsigned long base;
 
 		seg &= ~7UL;
@@ -33,12 +34,10 @@ unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *re
 			addr = -1L; /* bogus selector, access would fault */
 		else {
 			desc = child->mm->context.ldt + seg;
-			base = ((desc[0] >> 16) |
-				((desc[1] & 0xff) << 16) |
-				(desc[1] & 0xff000000));
+			base = get_desc_base(desc);
 
 			/* 16-bit code segment? */
-			if (!((desc[1] >> 22) & 1))
+			if (!desc->d)
 				addr &= 0xffff;
 			addr += base;
 		}
