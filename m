Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbYCWNB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbYCWNB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYCWNBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:01:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46040 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbYCWNBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:01:49 -0400
Date: Sun, 23 Mar 2008 16:06:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] signals: allow the kernel to actually kill /sbin/init
Message-ID: <20080323130650.GA242@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the buggy /sbin/init hangs if SIGSEGV/etc happens. The kernel sends
the signal, init dequeues it and ignores, returns from the exception, repeats
the faulting instruction, and so on forever.

Imho, such a behaviour is not good. I think that the explicit loud death of
the buggy /sbin/init is better than the silent hang.

Change force_sig_info() to clear SIGNAL_UNKILLABLE when the task should be
really killed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_INIT_SIGSEGV	2008-03-16 15:45:56.000000000 +0300
+++ 25/kernel/signal.c	2008-03-16 16:14:56.000000000 +0300
@@ -877,7 +877,8 @@ specific_send_sig_info(int sig, struct s
  * since we do not want to have a signal handler that was blocked
  * be invoked when user space had explicitly blocked it.
  *
- * We don't want to have recursive SIGSEGV's etc, for example.
+ * We don't want to have recursive SIGSEGV's etc, for example,
+ * that is why we also clear SIGNAL_UNKILLABLE.
  */
 int
 force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
@@ -897,6 +898,8 @@ force_sig_info(int sig, struct siginfo *
 			recalc_sigpending_and_wake(t);
 		}
 	}
+	if (action->sa.sa_handler == SIG_DFL)
+		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = specific_send_sig_info(sig, info, t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 

