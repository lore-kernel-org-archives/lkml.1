Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXEIIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXEIIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXEIInl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:43:41 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:35407 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXEIInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:43:40 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Use write_trylock_irqsave in ptrace_attach
Date: Wed, 9 May 2007 14:13:27 +0530
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091413.27344.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch makes ptrace_attach use write_trylock_irqsave.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

---
 kernel/ptrace.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.21/kernel/ptrace.c
===================================================================
--- linux-2.6.21.orig/kernel/ptrace.c
+++ linux-2.6.21/kernel/ptrace.c
@@ -160,6 +160,7 @@ int ptrace_may_attach(struct task_struct
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
+	unsigned long flags = 0;
 
 	retval = -EPERM;
 	if (task->pid <= 1)
@@ -178,9 +179,7 @@ repeat:
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
@@ -208,7 +207,7 @@ repeat:
 	force_sig_specific(SIGSTOP, task);
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
 out:
 	return retval;
