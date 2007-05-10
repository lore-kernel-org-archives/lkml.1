Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbXEJGi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbXEJGi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbXEJGii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:38:38 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:36727 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbXEJGig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:38:36 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PREEMPT_RT] [PATCH 2/2] Use write_trylock_irqsave in ptrace_attach
Date: Thu, 10 May 2007 12:07:53 +0530
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101207.53330.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This patch makes ptrace_attach() use the new API write_trylock_irqsave(). With 
this, the code in ptrace_attach() will be same for mainline and -rt. On -rt, 
write_trylock_irqsave() doesn't disable irqs and hence the problem is 
avoided.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

Index: linux-2.6.21-rt1_patch/kernel/ptrace.c
===================================================================
--- linux-2.6.21-rt1_patch.orig/kernel/ptrace.c	2007-05-10 11:28:57.000000000 
+0530
+++ linux-2.6.21-rt1_patch/kernel/ptrace.c	2007-05-10 11:29:13.000000000 +0530
@@ -160,6 +160,7 @@
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
+	unsigned long flags;
 
 	retval = -EPERM;
 	if (task->pid <= 1)
@@ -178,9 +179,7 @@
 	 * cpu's that may have task_lock).
 	 */
 	task_lock(task);
-	local_irq_disable();
-	if (!write_trylock(&tasklist_lock)) {
-		local_irq_enable();
+	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
 		task_unlock(task);
 		do {
 			cpu_relax();
@@ -208,7 +207,7 @@
 	force_sig_specific(SIGSTOP, task);
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
 out:
 	return retval;

