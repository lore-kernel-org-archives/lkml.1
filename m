Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYIDCvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYIDCvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYIDCvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:51:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:36205 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYIDCvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:51:23 -0400
Date: Wed, 3 Sep 2008 19:51:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080903195122.73905236@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic sanity checks to the syscall execution patch

Several pieces of malware (rootkits etc) have the nasty habbit
of putting their own pointers into the syscall table.
For example, the recently "hot in the news" phalanx rootkit does this.

The patch below, while obviously not perfect protection against malware,
adds some cheap sanity checks to the syscall path to verify the
system call is actually still in the kernel code region and not some
external-to-this region such as a rootkit.

The overhead is very minimal; measured at 2 cycles or less.
(this is because the branches get predicted right and the rest of the
code is almost perfectly parallelizable... and an indirect function call
is a branch issue anyway)

with eyes-on-the-code help from Peter
the idea is from Ben Herrenschmidt 

Signed-off-by: Arjan van de Ven

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 109792b..f25c0a1 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -347,7 +347,12 @@ sysenter_past_esp:
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
-	call *sys_call_table(,%eax,4)
+	mov sys_call_table(,%eax,4), %eax
+	cmp $_stext, %eax
+	jb syscall_badsys
+	cmp $_etext, %eax
+	jae syscall_badsys
+	call *%eax
 	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -426,7 +431,12 @@ ENTRY(system_call)
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
 syscall_call:
-	call *sys_call_table(,%eax,4)
+	mov sys_call_table(,%eax,4), %eax
+	cmp $_stext, %eax
+	jb syscall_badsys
+	cmp $_etext, %eax
+	jae syscall_badsys
+	call *%eax
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 89434d4..be42486 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -360,8 +360,13 @@ ENTRY(system_call_after_swapgs)
 system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
+	mov sys_call_table(,%rax,8), %rax
+	cmpq $_stext, %rax
+	jb badsys	
+	cmpq $_etext, %rax
+	jae badsys	
 	movq %r10,%rcx
-	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
+	call *%rax  # XXX:	 rip relative
 	movq %rax,RAX-ARGOFFSET(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
