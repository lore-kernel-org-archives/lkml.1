Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbZDNN6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbZDNN6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZDNNyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:54:09 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34578 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbZDNNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:51 -0400
Message-Id: <20090414135349.394396587@de.ibm.com>
References: <20090414135327.576111185@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 15:53:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/14] cpu hotplug and accounting values
Content-Disposition: inline; filename=012-cpu-accounting.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Reset the cpu timer to the maximum value and correctly initialize the
cpu accounting values in the lowcore when the cpu is started.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/asm-offsets.c |    2 ++
 arch/s390/kernel/entry.S       |   13 +++++++++++++
 arch/s390/kernel/entry64.S     |   13 +++++++++++++
 3 files changed, 28 insertions(+)

Index: quilt-2.6/arch/s390/kernel/asm-offsets.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/asm-offsets.c
+++ quilt-2.6/arch/s390/kernel/asm-offsets.c
@@ -27,6 +27,8 @@ int main(void)
 	DEFINE(__TI_flags, offsetof(struct thread_info, flags));
 	DEFINE(__TI_cpu, offsetof(struct thread_info, cpu));
 	DEFINE(__TI_precount, offsetof(struct thread_info, preempt_count));
+	DEFINE(__TI_user_timer, offsetof(struct thread_info, user_timer));
+	DEFINE(__TI_system_timer, offsetof(struct thread_info, system_timer));
 	BLANK();
 	DEFINE(__PT_ARGS, offsetof(struct pt_regs, args));
 	DEFINE(__PT_PSW, offsetof(struct pt_regs, psw));
Index: quilt-2.6/arch/s390/kernel/entry64.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry64.S
+++ quilt-2.6/arch/s390/kernel/entry64.S
@@ -831,14 +831,27 @@ mcck_return:
 	__CPUINIT
 	.globl restart_int_handler
 restart_int_handler:
+	basr	%r1,0
+restart_base:
+	spt	restart_vtime-restart_base(%r1)
+	stck	__LC_LAST_UPDATE_CLOCK
+	mvc	__LC_LAST_UPDATE_TIMER(8),restart_vtime-restart_base(%r1)
+	mvc	__LC_EXIT_TIMER(8),restart_vtime-restart_base(%r1)
 	lg	%r15,__LC_SAVE_AREA+120 # load ksp
 	lghi	%r10,__LC_CREGS_SAVE_AREA
 	lctlg	%c0,%c15,0(%r10) # get new ctl regs
 	lghi	%r10,__LC_AREGS_SAVE_AREA
 	lam	%a0,%a15,0(%r10)
 	lmg	%r6,%r15,__SF_GPRS(%r15) # load registers from clone
+	lg	%r1,__LC_THREAD_INFO
+	mvc	__LC_USER_TIMER(8),__TI_user_timer(%r1)
+	mvc	__LC_SYSTEM_TIMER(8),__TI_system_timer(%r1)
+	xc	__LC_STEAL_TIMER(8),__LC_STEAL_TIMER
 	stosm	__SF_EMPTY(%r15),0x04	# now we can turn dat on
 	jg	start_secondary
+	.align	8
+restart_vtime:
+	.long	0x7fffffff,0xffffffff
 	.previous
 #else
 /*
Index: quilt-2.6/arch/s390/kernel/entry.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry.S
+++ quilt-2.6/arch/s390/kernel/entry.S
@@ -837,16 +837,29 @@ mcck_return:
 	__CPUINIT
 	.globl restart_int_handler
 restart_int_handler:
+	basr	%r1,0
+restart_base:
+	spt	restart_vtime-restart_base(%r1)
+	stck	__LC_LAST_UPDATE_CLOCK
+	mvc	__LC_LAST_UPDATE_TIMER(8),restart_vtime-restart_base(%r1)
+	mvc	__LC_EXIT_TIMER(8),restart_vtime-restart_base(%r1)
 	l	%r15,__LC_SAVE_AREA+60	# load ksp
 	lctl	%c0,%c15,__LC_CREGS_SAVE_AREA # get new ctl regs
 	lam	%a0,%a15,__LC_AREGS_SAVE_AREA
 	lm	%r6,%r15,__SF_GPRS(%r15) # load registers from clone
+	l	%r1,__LC_THREAD_INFO
+	mvc	__LC_USER_TIMER(8),__TI_user_timer(%r1)
+	mvc	__LC_SYSTEM_TIMER(8),__TI_system_timer(%r1)
+	xc	__LC_STEAL_TIMER(8),__LC_STEAL_TIMER
 	stosm	__SF_EMPTY(%r15),0x04	# now we can turn dat on
 	basr	%r14,0
 	l	%r14,restart_addr-.(%r14)
 	br	%r14			# branch to start_secondary
 restart_addr:
 	.long	start_secondary
+	.align	8
+restart_vtime:
+	.long	0x7fffffff,0xffffffff
 	.previous
 #else
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

