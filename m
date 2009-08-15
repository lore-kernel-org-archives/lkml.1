Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZHOAdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZHOAdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 20:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZHOAdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 20:33:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbZHOAdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 20:33:39 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] inline __fatal_signal_pending
X-Fcc: ~/Mail/linus
X-Windows: the first fully modular software disaster.
Message-Id: <20090815003250.8101E40595@magilla.sf.frob.com>
Date: Fri, 14 Aug 2009 17:32:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fatal_signal_pending inlines to one instruction on x86, probably two
instructions on other machines.  It takes two longer x86 instructions
just to call it and test its return value, not to mention the function
itself.

On my random x86_64 config, this saved 70 bytes of text (59 of those
being __fatal_signal_pending itself).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    5 ++++-
 kernel/signal.c       |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..fabe715 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2250,7 +2250,10 @@ static inline int signal_pending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
-extern int __fatal_signal_pending(struct task_struct *p);
+static inline int __fatal_signal_pending(struct task_struct *p)
+{
+	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+}
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index 64c5dee..d441e3d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1036,12 +1036,6 @@ void zap_other_threads(struct task_struct *p)
 	}
 }
 
-int __fatal_signal_pending(struct task_struct *tsk)
-{
-	return sigismember(&tsk->pending.signal, SIGKILL);
-}
-EXPORT_SYMBOL(__fatal_signal_pending);
-
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
