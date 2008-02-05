Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYBEHte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYBEHte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYBEHtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:49:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbYBEHtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:49:24 -0500
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: fix iret exception recovery
X-Fcc: ~/Mail/linus
X-Windows: a terminal disease.
Message-Id: <20080205074920.6AA1F2701A8@magilla.localdomain>
Date: Mon,  4 Feb 2008 23:49:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change broke recovery of exceptions in iret:

	commit 72fe4858544292ad64600765cb78bc02298c6b1c
	Author: Glauber de Oliveira Costa <gcosta@redhat.com>

	    x86: replace privileged instructions with paravirt macros

The ENTRY(native_iret) macro adds alignment padding before the iretq
instruction, so "iret_label" no longer points exactly at the instruction.
It was sloppy to leave the old "iret_label" label behind when replacing
its nearby use.  Removing it would have revealed the other use of the
label later in the file, and upon noticing that use, anyone exercising
the minimum of attention to detail expected of anyone touching this
subtle code would realize it needed to change as well.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index bea8474..07d4aba 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -582,7 +582,6 @@ retint_restore_args:	/* return to kernel space */
 	TRACE_IRQS_IRETQ
 restore_args:
 	RESTORE_ARGS 0,8,0						
-iret_label:	
 #ifdef CONFIG_PARAVIRT
 	INTERRUPT_RETURN
 #endif
@@ -911,7 +910,7 @@ error_kernelspace:
 	   iret run with kernel gs again, so don't set the user space flag.
 	   B stepping K8s sometimes report an truncated RIP for IRET 
 	   exceptions returning to compat mode. Check for these here too. */
-	leaq iret_label(%rip),%rbp
+	leaq native_iret(%rip),%rbp
 	cmpq %rbp,RIP(%rsp) 
 	je   error_swapgs
 	movl %ebp,%ebp	/* zero extend */
