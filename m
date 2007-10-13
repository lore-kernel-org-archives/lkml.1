Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbXJMPBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbXJMPBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763152AbXJMOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:51:40 -0400
Received: from 1wt.eu ([62.212.114.60]:3072 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763072AbXJMOvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:51:38 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143456.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:39 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, taoyue <yue.tao@windriver.com>,
       Jeremy Katz <jeremy.katz@windriver.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 17/35] sigqueue_free: fix the race with collect_signal()
Content-Disposition: inline; filename=0059-sigqueue_free-fix-the-race-with-collect_signal.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 60187d2708caa870f0825d753df1612ea688eb9e in mainline.

Spotted by taoyue <yue.tao@windriver.com> and Jeremy Katz <jeremy.katz@windriver.com>.

collect_signal:				sigqueue_free:

	list_del_init(&first->list);
						if (!list_empty(&q->list)) {
							// not taken
						}
						q->flags &= ~SIGQUEUE_PREALLOC;

	__sigqueue_free(first);			__sigqueue_free(q);

Now, __sigqueue_free() is called twice on the same "struct sigqueue" with the
obviously bad implications.

In particular, this double free breaks the array_cache->avail logic, so the
same sigqueue could be "allocated" twice, and the bug can manifest itself via
the "impossible" BUG_ON(!SIGQUEUE_PREALLOC) in sigqueue_free/send_sigqueue.

Hopefully this can explain these mysterious bug-reports, see

	http://marc.info/?t=118766926500003
	http://marc.info/?t=118466273000005

Alexey Dobriyan reports this patch makes the difference for the testcase, but
nobody has an access to the application which opened the problems originally.

Also, this patch removes tasklist lock/unlock, ->siglock is enough.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: taoyue <yue.tao@windriver.com>
Cc: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/signal.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

Index: 2.6/kernel/signal.c
===================================================================
--- 2.6.orig/kernel/signal.c
+++ 2.6/kernel/signal.c
@@ -1345,20 +1345,19 @@ struct sigqueue *sigqueue_alloc(void)
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
+	spinlock_t *lock = &current->sighand->siglock;
+
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
 	 * If the signal is still pending remove it from the
-	 * pending queue.
+	 * pending queue. We must hold ->siglock while testing
+	 * q->list to serialize with collect_signal().
 	 */
-	if (unlikely(!list_empty(&q->list))) {
-		spinlock_t *lock = &current->sighand->siglock;
-		read_lock(&tasklist_lock);
-		spin_lock_irqsave(lock, flags);
-		if (!list_empty(&q->list))
-			list_del_init(&q->list);
-		spin_unlock_irqrestore(lock, flags);
-		read_unlock(&tasklist_lock);
-	}
+	spin_lock_irqsave(lock, flags);
+	if (!list_empty(&q->list))
+		list_del_init(&q->list);
+	spin_unlock_irqrestore(lock, flags);
+
 	q->flags &= ~SIGQUEUE_PREALLOC;
 	__sigqueue_free(q);
 }

-- 
