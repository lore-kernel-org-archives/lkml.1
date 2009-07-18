Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZGRPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZGRPME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZGRPMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:12:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51697 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZGRPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FV/NcnsqVk6lFaPfmkQpMfOsGjAh9E6r3LGfFxbfTu8tyhtRzrWiyGenxMLB9A+1Ub
         s5pWk3numN05i6R+HrhqRXNZ1OrRJucEmrTejqJyf09uR2JPzkEbPX+4OYi42aRcjVap
         slLnpczXFS7I0Z4mzP4ffeyI0b4Za/a7jvIw0=
Date: Sun, 19 Jul 2009 00:08:54 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 1/4] x86: use get_desc_base()
Message-ID: <20090718150853.GA11294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_desc_base() to get the base address in desc_struct

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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
-- 
1.6.0.6

