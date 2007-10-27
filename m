Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbXJ0SIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbXJ0SIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbXJ0SIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:08:40 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:53521 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbXJ0SIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:08:39 -0400
Date: Sat, 27 Oct 2007 14:08:37 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@muc.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix x86_64 TIF_SYSCALL_TRACE race in entry.S
Message-ID: <20071027180837.GA18134@Krystal>
References: <20071026193738.GA1591@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071026193738.GA1591@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:02:48 up 89 days, 18:21,  2 users,  load average: 0.61, 0.54, 0.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix x86_64 TIF_SYSCALL_TRACE race in entry.S

When the flag is inactive upon syscall entry and concurrently activated before
exit, we seem to reach a state where the top of stack is incorrect upon return
to user space.

Fix this by fixing the top of stack and jumping to int_ret_from_sys_call if we
detect that thread flags has been modified.

We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.

It applies on top of 2.6.23-mm1 or 2.6.23.1. If you think the
implementation is correct, I'll port it to 2.6.24-rc1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
---
 arch/x86_64/kernel/entry.S |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/entry.S	2007-10-27 14:01:12.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/entry.S	2007-10-27 14:01:28.000000000 -0400
@@ -245,9 +245,11 @@ ret_from_sys_call:
 	/* edi:	flagmask */
 sysret_check:		
 	GET_THREAD_INFO(%rcx)
+	movl threadinfo_flags(%rcx),%edx
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),%edx
+	jnz ret_from_sys_call_trace
 	cli
 	TRACE_IRQS_OFF
-	movl threadinfo_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz  sysret_careful 
 	CFI_REMEMBER_STATE
@@ -278,6 +280,14 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
+ret_from_sys_call_trace:
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
