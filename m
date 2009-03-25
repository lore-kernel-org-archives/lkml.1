Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbZCYR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbZCYR7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbZCYR7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:59:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761048AbZCYR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:59:12 -0400
Date: Wed, 25 Mar 2009 17:57:32 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ananth@in.ibm.com, bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <49C7995C.2010601@redhat.com>
References: <49C7995C.2010601@redhat.com>
Subject: [tip:tracing/kprobes] x86: kretprobe-booster interrupt emulation code fix
Message-ID: <tip-fee039a1d05c6e0f71b0fe270d847742a02d56c4@git.kernel.org>
Git-Commit-ID: fee039a1d05c6e0f71b0fe270d847742a02d56c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 17:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fee039a1d05c6e0f71b0fe270d847742a02d56c4
Gitweb:     http://git.kernel.org/tip/fee039a1d05c6e0f71b0fe270d847742a02d56c4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 23 Mar 2009 10:14:52 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 18:53:29 +0100

x86: kretprobe-booster interrupt emulation code fix

Fix interrupt emulation code in kretprobe-booster according to
pt_regs update (es/ds change and gs adding).

This issue has been reported on systemtap-bugzilla:

  http://sources.redhat.com/bugzilla/show_bug.cgi?id=9965

  | On a -tip kernel on x86_32, kretprobe_example (from samples) triggers the
  | following backtrace when its retprobing a class of functions that cause a
  | copy_from/to_user().
  |
  | BUG: sleeping function called from invalid context at mm/memory.c:3196
  | in_atomic(): 0, irqs_disabled(): 1, pid: 2286, name: cat

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Tested-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: systemtap-ml <systemtap@sources.redhat.com>
LKML-Reference: <49C7995C.2010601@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/kprobes.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 4558dd3..759095d 100644
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
@@ -691,6 +691,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	regs->cs = __KERNEL_CS;
 #else
 	regs->cs = __KERNEL_CS | get_kernel_rpl();
+	regs->gs = 0;
 #endif
 	regs->ip = trampoline_address;
 	regs->orig_ax = ~0UL;
