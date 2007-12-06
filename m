Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbXLFCxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbXLFCxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXLFCpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:40 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51506 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbXLFCpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:39 -0500
Message-Id: <20071206024437.834251754@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:43:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch-RFC 23/26] Prepare x86_64 for TIF_SYSCALL_TRACE async flag set in entry.S
Content-Disposition: inline; filename=fix-x86_64-sysenter-trace-race.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the flag is inactive upon syscall entry and concurrently activated before
exit, we seem to reach a state where the top of stack is incorrect upon return
to user space.

Fix this by fixing the top of stack and jumping to int_ret_from_sys_call if we
detect that thread flags has been modified.

We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2007-11-13 09:25:25.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2007-11-13 09:49:48.000000000 -0500
@@ -268,6 +268,8 @@ sysret_check:		
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */	
 sysret_careful:
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),%edx
+	jnz ret_from_sys_call_trace
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -279,6 +281,16 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
+ret_from_sys_call_trace:
+	TRACE_IRQS_ON
+	sti
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %rdi
+	movq %rsp,%rdi
+	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
