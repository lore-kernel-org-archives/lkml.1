Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbZFBLFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbZFBLFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZFBLFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:05:15 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:45112 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFBLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:05:13 -0400
Message-Id: <20090602110512.327768024@de.ibm.com>
References: <20090602105311.591592481@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 12:53:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 3/4] kprobes: use probe_kernel_write
Content-Disposition: inline; filename=202-kprobes-probe_kernel_write.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Use proble_kernel_write() to patch the kernel.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2009-06-02 10:40:05.000000000 +0200
@@ -25,9 +25,9 @@
 #include <linux/preempt.h>
 #include <linux/stop_machine.h>
 #include <linux/kdebug.h>
+#include <linux/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
-#include <asm/uaccess.h>
 #include <linux/module.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
@@ -155,35 +155,8 @@ void __kprobes get_instruction_type(stru
 static int __kprobes swap_instruction(void *aref)
 {
 	struct ins_replace_args *args = aref;
-	u32 *addr;
-	u32 instr;
-	int err = -EFAULT;
 
-	/*
-	 * Text segment is read-only, hence we use stura to bypass dynamic
-	 * address translation to exchange the instruction. Since stura
-	 * always operates on four bytes, but we only want to exchange two
-	 * bytes do some calculations to get things right. In addition we
-	 * shall not cross any page boundaries (vmalloc area!) when writing
-	 * the new instruction.
-	 */
-	addr = (u32 *)((unsigned long)args->ptr & -4UL);
-	if ((unsigned long)args->ptr & 2)
-		instr = ((*addr) & 0xffff0000) | args->new;
-	else
-		instr = ((*addr) & 0x0000ffff) | args->new << 16;
-
-	asm volatile(
-		"	lra	%1,0(%1)\n"
-		"0:	stura	%2,%1\n"
-		"1:	la	%0,0\n"
-		"2:\n"
-		EX_TABLE(0b,2b)
-		: "+d" (err)
-		: "a" (addr), "d" (instr)
-		: "memory", "cc");
-
-	return err;
+	return probe_kernel_write(args->ptr, &args->new, sizeof(args->new));
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)

-- 
