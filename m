Return-Path: <linux-kernel-owner+w=401wt.eu-S966196AbXDCOCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966196AbXDCOCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966195AbXDCOCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:02:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966181AbXDCOB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:01:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/8] AF_RXRPC: Make it possible to merely try to cancel timers
	and delayed work [try #2]
To: torvalds@osdl.org, akpm@osdl.org
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 03 Apr 2007 15:01:19 +0100
Message-ID: <20070403140119.20369.19067.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070403140108.20369.59745.stgit@warthog.cambridge.redhat.com>
References: <20070403140108.20369.59745.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export try_to_del_timer_sync() for use by the RxRPC module.

Add a try_to_cancel_delayed_work() so that it is possible to merely attempt to
cancel a delayed work timer.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/workqueue.h |   21 +++++++++++++++++++++
 kernel/timer.c            |    2 ++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2a7b38d..40a61ae 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -204,4 +204,25 @@ static inline int cancel_delayed_work(struct delayed_work *work)
 	return ret;
 }
 
+/**
+ * try_to_cancel_delayed_work - Try to kill pending scheduled, delayed work
+ * @work: the work to cancel
+ *
+ * Try to kill off a pending schedule_delayed_work().
+ * - The timer may still be running afterwards, and if so, the work may still
+ *   be pending
+ * - Returns -1 if timer still active, 1 if timer removed, 0 if not scheduled
+ * - Can be called from the work routine; if it's still pending, just return
+ *   and it'll be called again.
+ */
+static inline int try_to_cancel_delayed_work(struct delayed_work *work)
+{
+	int ret;
+
+	ret = try_to_del_timer_sync(&work->timer);
+	if (ret > 0)
+		work_release(&work->work);
+	return ret;
+}
+
 #endif
diff --git a/kernel/timer.c b/kernel/timer.c
index 440048a..ba4d6e0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -505,6 +505,8 @@ out:
 	return ret;
 }
 
+EXPORT_SYMBOL(try_to_del_timer_sync);
+
 /**
  * del_timer_sync - deactivate a timer and wait for the handler to finish.
  * @timer: the timer to be deactivated

