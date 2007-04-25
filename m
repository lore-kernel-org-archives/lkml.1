Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXDYKvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXDYKvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992644AbXDYKvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:51:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992617AbXDYKu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:50:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/16] cancel_delayed_work: use del_timer() instead of
	del_timer_sync() [try #3]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 25 Apr 2007 11:50:47 +0100
Message-ID: <20070425105047.10872.65104.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
References: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
efficient since it locks the timer unconditionally, and may wait for the
completion of the delayed_work_timer_fn().

cancel_delayed_work() == 0 means:

	before this patch:
		work->func may still be running or queued

	after this patch:
		work->func may still be running or queued, or
		delayed_work_timer_fn->__queue_work() in progress.

		The latter doesn't differ from the caller's POV,
		delayed_work_timer_fn() is called with _PENDING
		bit set.

cancel_delayed_work() == 1 with this patch adds a new possibility:

	delayed_work->work was cancelled, but delayed_work_timer_fn
	is still running (this is only possible for the re-arming
	works on single-threaded workqueue).

	In this case the timer was re-started by work->func(), nobody
	else can do this. This in turn means that delayed_work_timer_fn
	has already passed __queue_work() (and wont't touch delayed_work)
	because nobody else can queue delayed_work->work.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/workqueue.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2a7b38d..b8abfc7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -191,14 +191,15 @@ int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
- * function may still be running on return from cancel_delayed_work().  Run
- * flush_scheduled_work() to wait on it.
+ * function may still be running on return from cancel_delayed_work(), unless
+ * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
+ * cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
 	int ret;
 
-	ret = del_timer_sync(&work->timer);
+	ret = del_timer(&work->timer);
 	if (ret)
 		work_release(&work->work);
 	return ret;

