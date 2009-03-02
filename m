Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZCBXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZCBXLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZCBXK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:10:27 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:4956 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbZCBXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:10:26 -0500
Message-ID: <49AC675F.3030608@cybernetics.com>
Date: Mon, 02 Mar 2009 18:10:23 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] epoll: remove unnecessary xchg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xchg in ep_unregister_pollwait() is unnecessary because it is protected
by either epmutex or ep->mtx (the same protection as ep_remove()).
If xchg wasn't unnecessary, it would be insufficient to protect against
problems.  If multiple concurrent calls to ep_unregister_pollwait()
were possible, then a second caller that returns without doing anything
because nwait == 0 could return before the waitqueues are removed
by the first caller, which looks like it could lead to problematic
races with ep_poll_callback().  So remove xchg and add comments about
the locking.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---
--- a/fs/eventpoll.c	2009-02-23 13:26:53.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 13:29:31.000000000 -0500
@@ -413,27 +413,21 @@ static void ep_poll_safewake(wait_queue_
 }
 
 /*
- * This function unregister poll callbacks from the associated file descriptor.
- * Since this must be called without holding "ep->lock" the atomic exchange trick
- * will protect us from multiple unregister.
+ * This function unregisters poll callbacks from the associated file
+ * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
+ * ep_free).
  */
 static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 {
-	int nwait;
 	struct list_head *lsthead = &epi->pwqlist;
 	struct eppoll_entry *pwq;
 
-	/* This is called without locks, so we need the atomic exchange */
-	nwait = xchg(&epi->nwait, 0);
+	while (!list_empty(lsthead)) {
+		pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
-	if (nwait) {
-		while (!list_empty(lsthead)) {
-			pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
-
-			list_del_init(&pwq->llink);
-			remove_wait_queue(pwq->whead, &pwq->wait);
-			kmem_cache_free(pwq_cache, pwq);
-		}
+		list_del(&pwq->llink);
+		remove_wait_queue(pwq->whead, &pwq->wait);
+		kmem_cache_free(pwq_cache, pwq);
 	}
 }
 


