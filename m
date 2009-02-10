Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZBJRg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZBJRg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZBJRgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZBJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:19 -0500
Message-Id: <20090210173618.421524441@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] tracing, x86: fix constraint for parent variable
Content-Disposition: inline; filename=0003-tracing-x86-fix-constraint-for-parent-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The constraint used for retrieving and restoring the parent function
pointer is incorrect. The parent variable is a pointer, and the
address of the pointer is modified by the asm statement and not
the pointer itself. It is incorrect to pass it in as an output
constraint since the asm will never update the pointer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18828ae..370bafa 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -468,8 +468,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	 * ignore such a protection.
 	 */
 	asm volatile(
-		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
-		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
+		"1: " _ASM_MOV " (%[parent]), %[old]\n"
+		"2: " _ASM_MOV " %[return_hooker], (%[parent])\n"
 		"   movl $0, %[faulted]\n"
 
 		".section .fixup, \"ax\"\n"
@@ -479,9 +479,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		_ASM_EXTABLE(1b, 3b)
 		_ASM_EXTABLE(2b, 3b)
 
-		: [parent_replaced] "=r" (parent), [old] "=r" (old),
-		  [faulted] "=r" (faulted)
-		: [parent_old] "0" (parent), [return_hooker] "r" (return_hooker)
+		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
 	);
 
-- 
1.5.6.5

-- 
