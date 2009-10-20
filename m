Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZJTHJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZJTHJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZJTHJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:09:09 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16926 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZJTHJJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Tue, 20 Oct 2009 03:09:09 -0400
Message-Id: <4ADD7E6C020000780001AD73@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 20 Oct 2009 08:10:04 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: adjust ia32entry branches for better static
	 prediction
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap branch pairs so that the static branch prediction logic would
consider the syscall-number-in-range case the taken path.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/ia32/ia32entry.S |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
+++ 2.6.32-rc5-x86_64-ia32-syscall-trace-branch-dir/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
@@ -249,9 +249,9 @@ sysenter_tracesys:
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl	$(IA32_NR_syscalls-1),%eax
-	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
-	jmp	sysenter_do_call
+	cmpl	$IA32_NR_syscalls,%eax
+	jb	sysenter_do_call
+	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
 
@@ -368,9 +368,9 @@ cstar_tracesys:
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	cmpl $(IA32_NR_syscalls-1),%eax
-	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
-	jmp cstar_do_call
+	cmpl $IA32_NR_syscalls,%eax
+	jb cstar_do_call
+	jmp int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 END(ia32_cstar_target)
 				
 ia32_badarg:
@@ -445,9 +445,9 @@ ia32_tracesys:			 
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl $(IA32_NR_syscalls-1),%eax
-	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
-	jmp ia32_do_call
+	cmpl $IA32_NR_syscalls,%eax
+	jb ia32_do_call
+	jmp int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 END(ia32_syscall)
 
 ia32_badsys:



