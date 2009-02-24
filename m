Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbZBXRas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbZBXRas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbZBXR2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:28:47 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1128 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759893AbZBXR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:28:46 -0500
Message-ID: <49A42E4B.1060100@cybernetics.com>
Date: Tue, 24 Feb 2009 12:28:43 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] [-mm] epoll: remove unnecessary xchg
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

This patch is against the current -mm tree, and might not apply
to 2.6.29.  Since this patch probably won't go into 2.6.29, you may
apply this version of the patch after the other patches in -mm.

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
 

