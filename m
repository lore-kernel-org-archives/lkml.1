Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYKPV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYKPV0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYKPVZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:25:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYKPVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:25:17 -0500
Message-Id: <20081116212515.728019601@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 16 Nov 2008 16:24:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] ftrace, PPC: use probe_kernel API to modify code
Content-Disposition: inline; filename=0004-ftrace-PPC-use-probe_kernel-API-to-modify-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use cleaner probe_kernel API over assembly

Using probe_kernel_read/write interface is a much cleaner approach
than the current assembly version.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   53 ++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index aa5d0b2..3852919 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -9,6 +9,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
@@ -72,45 +73,33 @@ static int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
-	unsigned replaced;
-	unsigned old = *(unsigned *)old_code;
-	unsigned new = *(unsigned *)new_code;
-	int faulted = 0;
+	unsigned char replaced[MCOUNT_INSN_SIZE];
 
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing.
+	 *  as well as code changing. We do this by using the
+	 *  probe_kernel_* functions.
 	 *
 	 * No real locking needed, this code is run through
-	 * kstop_machine.
+	 * kstop_machine, or before SMP starts.
 	 */
-	asm volatile (
-		"1: lwz		%1, 0(%2)\n"
-		"   cmpw	%1, %5\n"
-		"   bne		2f\n"
-		"   stwu	%3, 0(%2)\n"
-		"2:\n"
-		".section .fixup, \"ax\"\n"
-		"3:	li %0, 1\n"
-		"	b 2b\n"
-		".previous\n"
-		".section __ex_table,\"a\"\n"
-		_ASM_ALIGN "\n"
-		_ASM_PTR "1b, 3b\n"
-		".previous"
-		: "=r"(faulted), "=r"(replaced)
-		: "r"(ip), "r"(new),
-		  "0"(faulted), "r"(old)
-		: "memory");
-
-	if (replaced != old && replaced != new)
-		faulted = 2;
-
-	if (!faulted)
-		flush_icache_range(ip, ip + 8);
-
-	return faulted;
+
+	/* read the text we want to modify */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
+	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+	/* replace the text with the new text */
+	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
 }
 
 static int test_24bit_addr(unsigned long ip, unsigned long addr)
-- 
1.5.6.5

-- 
