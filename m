Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYLBUgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYLBUgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLBUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203425.258501817@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: clean up function graph asm
Content-Disposition: inline; filename=0004-ftrace-clean-up-function-graph-asm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

There exists macros for x86 asm to handle x86_64 and i386.
This patch updates function graph asm to use them.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5883247..1a5b8f8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -467,28 +467,16 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	 * ignore such a protection.
 	 */
 	asm volatile(
-#ifdef CONFIG_X86_64
-		"1: movq (%[parent_old]), %[old]\n"
-		"2: movq %[return_hooker], (%[parent_replaced])\n"
-#else
-		"1: movl (%[parent_old]), %[old]\n"
-		"2: movl %[return_hooker], (%[parent_replaced])\n"
-#endif
+		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
+		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
 		"   movl $0, %[faulted]\n"
 
 		".section .fixup, \"ax\"\n"
 		"3: movl $1, %[faulted]\n"
 		".previous\n"
 
-		".section __ex_table, \"a\"\n"
-#ifdef CONFIG_X86_64
-		"   .quad 1b, 3b\n"
-		"   .quad 2b, 3b\n"
-#else
-		"   .long 1b, 3b\n"
-		"   .long 2b, 3b\n"
-#endif
-		".previous\n"
+		_ASM_EXTABLE(1b, 3b)
+		_ASM_EXTABLE(2b, 3b)
 
 		: [parent_replaced] "=r" (parent), [old] "=r" (old),
 		  [faulted] "=r" (faulted)
-- 
1.5.6.5

-- 
