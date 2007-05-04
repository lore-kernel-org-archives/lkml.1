Return-Path: <linux-kernel-owner+w=401wt.eu-S1161575AbXEDXkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161575AbXEDXkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbXEDXkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:40:18 -0400
Received: from haxent.com ([65.99.219.155]:2925 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422832AbXEDXhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:37:51 -0400
Message-ID: <463BC3CA.6050109@haxent.com.br>
Date: Fri, 04 May 2007 20:37:46 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br>
In-Reply-To: <20070504225730.490334000@haxent.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If multiple threads are parked on epoll_wait (on a single epoll fd) and
events become available, epoll performs a wake up of all threads of the
poll wait list, causing a thundering herd of processes trying to grab
the eventpoll lock.

This patch addresses this by using exclusive waiters (wake one). Once
the exclusive thread finishes transferring it's events, a new thread
is woken if there are more events available.

Makes sense?

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/eventpoll.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/fs/eventpoll.c
===================================================================
--- linux-2.6.orig/fs/eventpoll.c
+++ linux-2.6/fs/eventpoll.c
@@ -1491,6 +1491,12 @@ static void ep_reinject_items(struct eve
 		}
 	}

+	/*
+	 * If there is events available, wake up the next waiter, if any.
+	 */
+	if (!ricnt)
+		ricnt = !list_empty(&ep->rdllist);
+
 	if (ricnt) {
 		/*
 		 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -1570,6 +1576,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
+		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue(&ep->wq, &wait);

 		for (;;) {

--
