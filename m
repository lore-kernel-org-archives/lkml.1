Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZBXR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZBXR2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbZBXR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:27:34 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:2144 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455AbZBXR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:27:33 -0500
Message-ID: <49A42E02.1090404@cybernetics.com>
Date: Tue, 24 Feb 2009 12:27:30 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] [2.6.29] epoll: remove unnecessary xchg
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
---

This patch is against 2.6.29-rc6; however, it doesn't need to go
into 2.6.29.  Use the -mm version instead if applying after the other
patches in -mm.

--- a/fs/eventpoll.c	2009-02-20 16:50:16.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-20 16:53:26.000000000 -0500
@@ -375,27 +375,21 @@ out_unlock:
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
 

