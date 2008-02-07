Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbYBGVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbYBGVBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbYBGUwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:09 -0500
Received: from mx1.suse.de ([195.135.220.2]:45565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbYBGUwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:05 -0500
Date: Thu, 7 Feb 2008 12:47:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, stefanr@s5r6.in-berlin.de,
       a.p.zijlstra@chello.nl, davidel@xmailserver.org
Subject: [patch 24/45] lockdep: annotate epoll
Message-ID: <20080207204734.GY16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lockdep-annotate-epoll.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

patch 0ccf831cbee94df9c5006dd46248c0f07847dd7c in mainline.

On Sat, 2008-01-05 at 13:35 -0800, Davide Libenzi wrote:

> I remember I talked with Arjan about this time ago. Basically, since 1)
> you can drop an epoll fd inside another epoll fd 2) callback-based wakeups
> are used, you can see a wake_up() from inside another wake_up(), but they
> will never refer to the same lock instance.
> Think about:
>
> 	dfd = socket(...);
> 	efd1 = epoll_create();
> 	efd2 = epoll_create();
> 	epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
> 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
>
> When a packet arrives to the device underneath "dfd", the net code will
> issue a wake_up() on its poll wake list. Epoll (efd1) has installed a
> callback wakeup entry on that queue, and the wake_up() performed by the
> "dfd" net code will end up in ep_poll_callback(). At this point epoll
> (efd1) notices that it may have some event ready, so it needs to wake up
> the waiters on its poll wait list (efd2). So it calls ep_poll_safewake()
> that ends up in another wake_up(), after having checked about the
> recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to
> avoid stack blasting. Never hit the same queue, to avoid loops like:
>
> 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
> 	epoll_ctl(efd3, EPOLL_CTL_ADD, efd2, ...);
> 	epoll_ctl(efd4, EPOLL_CTL_ADD, efd3, ...);
> 	epoll_ctl(efd1, EPOLL_CTL_ADD, efd4, ...);
>
> The code "if (tncur->wq == wq || ..." prevents re-entering the same
> queue/lock.

Since the epoll code is very careful to not nest same instance locks
allow the recursion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/eventpoll.c       |    2 +-
 include/linux/wait.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -353,7 +353,7 @@ static void ep_poll_safewake(struct poll
 	spin_unlock_irqrestore(&psw->lock, flags);
 
 	/* Do really wake up now */
-	wake_up(wq);
+	wake_up_nested(wq, 1 + wake_nests);
 
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&psw->lock, flags);
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -161,6 +161,22 @@ wait_queue_head_t *FASTCALL(bit_waitqueu
 #define	wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
 #define wake_up_interruptible_sync(x)   __wake_up_sync((x),TASK_INTERRUPTIBLE, 1)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+/*
+ * macro to avoid include hell
+ */
+#define wake_up_nested(x, s)						\
+do {									\
+	unsigned long flags;						\
+									\
+	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
+	wake_up_locked(x); 						\
+	spin_unlock_irqrestore(&(x)->lock, flags);			\
+} while (0)
+#else
+#define wake_up_nested(x, s)		wake_up(x)
+#endif
+
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\

-- 
