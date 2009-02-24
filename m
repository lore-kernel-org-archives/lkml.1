Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbZBXR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbZBXR2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbZBXR1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:27:46 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3494 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214AbZBXR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:27:45 -0500
Message-ID: <49A42E0F.10704@cybernetics.com>
Date: Tue, 24 Feb 2009 12:27:43 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] [2.6.29] epoll: clean up ep_modify
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_modify() doesn't need to set event.data from within the ep->lock
spinlock as the comment suggests.  The only place event.data is used
is ep_send_events(), and this is protected by ep->mtx instead
of ep->lock.  Also update the comment for mutex_lock() at the top
of ep_send_events(), which mentions epoll_ctl(EPOLL_CTL_DEL)
but not epoll_ctl(EPOLL_CTL_MOD).

ep_modify() can also use spin_lock_irq() instead of
spin_lock_irqsave().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against 2.6.29-rc6; however, it doesn't need to go
into 2.6.29.  Use the -mm version instead if applying after the other
patches in -mm.

--- a/fs/eventpoll.c	2009-02-23 15:37:14.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 15:38:04.000000000 -0500
@@ -885,15 +885,14 @@ static int ep_modify(struct eventpoll *e
 {
 	int pwake = 0;
 	unsigned int revents;
-	unsigned long flags;
 
 	/*
-	 * Set the new event interest mask before calling f_op->poll(), otherwise
-	 * a potential race might occur. In fact if we do this operation inside
-	 * the lock, an event might happen between the f_op->poll() call and the
-	 * new event set registering.
+	 * Set the new event interest mask before calling f_op->poll();
+	 * otherwise we might miss an event that happens between the
+	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events;
+	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
@@ -901,16 +900,12 @@ static int ep_modify(struct eventpoll *e
 	 */
 	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
 
-	spin_lock_irqsave(&ep->lock, flags);
-
-	/* Copy the data member from inside the lock */
-	epi->event.data = event->data;
-
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
 	 * list, push it inside.
 	 */
 	if (revents & event->events) {
+		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
 
@@ -920,8 +915,8 @@ static int ep_modify(struct eventpoll *e
 			if (waitqueue_active(&ep->poll_wait))
 				pwake++;
 		}
+		spin_unlock_irq(&ep->lock);
 	}
-	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -943,7 +938,7 @@ static int ep_send_events(struct eventpo
 
 	/*
 	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl(EPOLL_CTL_DEL).
+	 * eventpoll_release_file() and epoll_ctl().
 	 */
 	mutex_lock(&ep->mtx);
 

