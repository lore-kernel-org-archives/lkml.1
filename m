Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYAVWy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYAVWy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYAVWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:54:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34192 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbYAVWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:54:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 22 Jan 2008 23:54:24 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] lockdep: annotate epoll
To: Peter Zijlstra <peterz@infradead.org>
cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <tkrat.fcd947ba88aa56a8@s5r6.in-berlin.de>
Message-ID: <tkrat.3cc18a24024636f5@s5r6.in-berlin.de>
References: <20080121160255.M12670@visp.net.lb> 
 <47952094.9050102@s5r6.in-berlin.de> <20080122110448.M46928@visp.net.lb> 
 <4796189F.8070506@s5r6.in-berlin.de> <1201019283.6341.28.camel@lappy>
 <tkrat.fcd947ba88aa56a8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Jan, Stefan Richter wrote:
> On 22 Jan, Peter Zijlstra wrote:
>> Curious though that this gets reported frequently the last few weeks,
>> afaics this problem is way old.
> 
> Here is a report against Fedora's 2.6.23-0.222.rc9.git4.fc8, filed in
> October:  https://bugzilla.redhat.com/show_bug.cgi?id=323411

Upstream bug: http://bugzilla.kernel.org/show_bug.cgi?id=9786

Date: Sun, 13 Jan 2008 19:44:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

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
---
 fs/eventpoll.c       |    2 +-
 include/linux/wait.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: linux/fs/eventpoll.c
===================================================================
--- linux.orig/fs/eventpoll.c
+++ linux/fs/eventpoll.c
@@ -353,7 +353,7 @@ static void ep_poll_safewake(struct poll
 	spin_unlock_irqrestore(&psw->lock, flags);
 
 	/* Do really wake up now */
-	wake_up(wq);
+	wake_up_nested(wq, 1 + wake_nests);
 
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&psw->lock, flags);
Index: linux/include/linux/wait.h
===================================================================
--- linux.orig/include/linux/wait.h
+++ linux/include/linux/wait.h
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
Stefan Richter
-=====-==--- ---= =-==-
http://arcgraph.de/sr/

