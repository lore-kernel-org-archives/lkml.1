Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZE1Lkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZE1Lkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZE1LkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:40:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZE1LkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:40:08 -0400
Date: Thu, 28 May 2009 13:35:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/12 v2] ptrace: ptrace_signal: fix the usage of
	->parent
Message-ID: <20090528113537.GA18678@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch complicates the code to fix the pure theoretical problems.
But since we are going to change this code, it is better to fix them
anyway.

- If we are not traced any longer after ptrace_stop(), si_pid/si_uid
  are not necessary right.

- It is not safe to dereference current->parent without tasklist or
  RCU lock. The tracer can detach and exit. ->siglock can't prevent
  this, and (in theory) local_irq_disable() doesn't imply RCU lock.

Hopefully this "signr != info->si_signo" code will go away eventually.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/signal.c~PTRACE_SIGNAL	2009-05-28 04:12:02.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-28 04:14:38.000000000 +0200
@@ -1770,11 +1770,22 @@ static int ptrace_signal(int signr, sigi
 	   specific in the siginfo structure then it should
 	   have updated *info via PTRACE_SETSIGINFO.  */
 	if (signr != info->si_signo) {
+		struct task_struct *tracer;
+
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
-		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+
+		rcu_read_lock();
+		tracer = current->parent;
+		if (task_ptrace(current)) {
+			info->si_pid = task_pid_vnr(tracer);
+			info->si_uid = task_uid(tracer);
+		} else {
+			info->si_pid = 0;
+			info->si_uid = 0;
+		}
+		rcu_read_unlock();
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */

