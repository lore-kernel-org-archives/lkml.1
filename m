Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbZBEUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbZBEUZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbZBEUXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:23:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33473 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbZBEUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:23:46 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Thu, 05 Feb 2009 12:23:39 -0800
Subject: [patch 4/6] epoll keyed wakeups v3 - teach epoll about hints coming with the wakeup key
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.21761.1233865423.4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follwing patch uses the events hint now sent by some devices, to
avoid unnecessary wakeups for events that are of no interest for the
caller. This code handles both devices that are sending keyed events,
and the ones that are not (and event the ones that sometimes send events,
and sometimes don't).
Since epoll was the only user of wake_up_nested(), I brought that
inside fs/eventpoll.c instead of adding it to include/linux/wait.h.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-02-03 13:43:58.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-02-03 13:44:04.000000000 -0800
@@ -370,9 +370,28 @@ static int ep_call_nested(struct nested_
 	return error;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+				     unsigned long events, int subclass)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
+	wake_up_locked_poll(wqueue, events);
+	spin_unlock_irqrestore(&wqueue->lock, flags);
+}
+#else
+static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
+				     unsigned long events, int subclass)
+{
+	wake_up_poll(wqueue, events);
+}
+#endif
+
 static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
-	wake_up_nested((wait_queue_head_t *) cookie, 1 + call_nests);
+	ep_wake_up_nested((wait_queue_head_t *) cookie, POLLIN,
+			  1 + call_nests);
 	return 0;
 }
 
@@ -785,6 +804,15 @@ static int ep_poll_callback(wait_queue_t
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
 
+        /*
+	 * Check the events coming with the callback. At this stage, not
+	 * every device reports the events in the "key" parameter of the
+	 * callback. We need to be able to handle both cases here, hence the
+	 * test for "key" != NULL before the event match test.
+	 */
+	if (key && !((unsigned long) key & epi->event.events))
+		goto out_unlock;
+
 	/*
 	 * If we are trasfering events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
@@ -1260,7 +1288,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
-
 			error = ep_insert(ep, &epds, tfile, fd);
 		} else
 			error = -EEXIST;

