Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZE1C6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZE1C6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 22:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZE1C6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 22:58:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZE1C6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 22:58:40 -0400
Date: Thu, 28 May 2009 04:54:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090528025407.GA22182@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com> <20090527224140.GC6770@redhat.com> <20090527230700.11F2DFC2BD@magilla.sf.frob.com> <20090527235936.GB12216@redhat.com> <20090528003256.86E4EFC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528003256.86E4EFC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > OK, lets do this change later ;)
>
> Agreed.

Damn. OTOH, it is so ugly to cache pid/uid for the very unlikely case.

Roland, will you agree with the patch below?

If yes, I'd like to send it separately.

Oleg.

-------------------------------------------------------------------
[PATCH -mm] ptrace: ptrace_signal: fix the usage of ->parent

This patch complicates the code to fix the pure theoretical problems.
But since we are going to change this code, it is better to fix them
anyway.

- If we are not traced any longer after ptrace_stop(), si_pid/si_uid
  are not necessary right.

- It is not safe to dereference current->parent without tasklist or
  RCU lock. The tracer can detach and exit. ->siglock can't prevent
  this, and (in theory) local_irq_disable() doesn't imply RCU lock.

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

