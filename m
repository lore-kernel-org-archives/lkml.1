Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZCWOPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZCWOPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZCWOPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:15:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbZCWOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:15:00 -0400
Message-ID: <49C7995C.2010601@redhat.com>
Date: Mon, 23 Mar 2009 10:14:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       bharata@linux.vnet.ibm.com
Subject: [BUGFIX][PATCH -tip] x86: kretprobe-booster interrupt emulation code
 fix
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix interrupt emulation code in kretprobe-booster according to
pt_regs update (es/ds change and gs adding).

This issue has been reported on systemtap-bugzilla:
http://sources.redhat.com/bugzilla/show_bug.cgi?id=9965

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/x86/kernel/kprobes.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 55b9461..64dba72 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -638,13 +638,13 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 #else
 			"	pushf\n"
 			/*
-			 * Skip cs, ip, orig_ax.
+			 * Skip cs, ip, orig_ax and gs.
 			 * trampoline_handler() will plug in these values
 			 */
-			"	subl $12, %esp\n"
+			"	subl $16, %esp\n"
 			"	pushl %fs\n"
-			"	pushl %ds\n"
 			"	pushl %es\n"
+			"	pushl %ds\n"
 			"	pushl %eax\n"
 			"	pushl %ebp\n"
 			"	pushl %edi\n"
@@ -655,10 +655,10 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	movl %esp, %eax\n"
 			"	call trampoline_handler\n"
 			/* Move flags to cs */
-			"	movl 52(%esp), %edx\n"
-			"	movl %edx, 48(%esp)\n"
+			"	movl 56(%esp), %edx\n"
+			"	movl %edx, 52(%esp)\n"
 			/* Replace saved flags with true return address. */
-			"	movl %eax, 52(%esp)\n"
+			"	movl %eax, 56(%esp)\n"
 			"	popl %ebx\n"
 			"	popl %ecx\n"
 			"	popl %edx\n"
@@ -666,8 +666,8 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	popl %edi\n"
 			"	popl %ebp\n"
 			"	popl %eax\n"
-			/* Skip ip, orig_ax, es, ds, fs */
-			"	addl $20, %esp\n"
+			/* Skip ds, es, fs, gs, orig_ax and ip */
+			"	addl $24, %esp\n"
 			"	popf\n"
 #endif
 			"	ret\n");
@@ -694,6 +694,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 #endif
 	regs->ip = trampoline_address;
 	regs->orig_ax = ~0UL;
+	regs->gs = 0;

 	/*
 	 * It is possible to have multiple instances associated with a given


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

