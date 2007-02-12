Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXBLAxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXBLAxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932938AbXBLAxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:53:04 -0500
Received: from mail.screens.ru ([213.234.233.54]:54334 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXBLAxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:53:02 -0500
Date: Mon, 12 Feb 2007 03:52:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/3] make cancel_rearming_delayed_work() work on any workqueue, not just keventd_wq
Message-ID: <20070212005254.GA2806@tv-sign.ru>
References: <20070211211524.GA203@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211211524.GA203@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12, Oleg Nesterov wrote:
>
> Remove this parameter, and rename the function to cancel_rearming_delayed_work().

Damn! Forgot to rename EXPORT_SYMBOL() as well, otherwise unchanged.



[PATCH 4/3] make cancel_rearming_delayed_work() work on any workqueue, not just keventd_wq

cancel_rearming_delayed_workqueue(wq, dwork) doesn't need the first parameter.
We don't hang on un-queued dwork any longer, and work->data doesn't change its
type. This means we can always figure out "wq" from dwork when it is needed.

Remove this parameter, and rename the function to cancel_rearming_delayed_work().
Re-create an inline "obsolete" cancel_rearming_delayed_workqueue(wq) which just
calls cancel_rearming_delayed_work().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/workqueue.h |   13 ++++++++++---
 kernel/workqueue.c        |   26 +++++++++-----------------
 2 files changed, 19 insertions(+), 20 deletions(-)

--- 6.20-rc6-mm3/include/linux/workqueue.h~4_crdw	2007-02-10 18:16:15.000000000 +0300
+++ 6.20-rc6-mm3/include/linux/workqueue.h	2007-02-12 03:15:20.000000000 +0300
@@ -185,9 +185,6 @@ extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
-void cancel_rearming_delayed_work(struct delayed_work *work);
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *,
-				       struct delayed_work *);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 /*
@@ -205,4 +202,14 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
+extern void cancel_rearming_delayed_work(struct delayed_work *work);
+
+/* Obsolete. use cancel_rearming_delayed_work() */
+static inline
+void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
+					struct delayed_work *work)
+{
+	cancel_rearming_delayed_work(work);
+}
+
 #endif
--- 6.20-rc6-mm3/kernel/workqueue.c~4_crdw	2007-02-10 19:07:41.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-12 03:15:20.000000000 +0300
@@ -555,32 +555,23 @@ void flush_work_keventd(struct work_stru
 EXPORT_SYMBOL(flush_work_keventd);
 
 /**
- * cancel_rearming_delayed_workqueue - kill off a delayed work whose handler rearms the delayed work.
- * @wq:   the controlling workqueue structure
+ * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  *
  * Note that the work callback function may still be running on return from
  * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
  */
-void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
-				       struct delayed_work *dwork)
+void cancel_rearming_delayed_work(struct delayed_work *dwork)
 {
-	/* Was it ever queued ? */
-	if (!get_wq_data(&dwork->work))
-		return;
+	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 
-	while (!cancel_delayed_work(dwork))
-		flush_workqueue(wq);
-}
-EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
+	/* Was it ever queued ? */
+	if (cwq != NULL) {
+		struct workqueue_struct *wq = cwq->wq;
 
-/**
- * cancel_rearming_delayed_work - kill off a delayed keventd work whose handler rearms the delayed work.
- * @dwork: the delayed work struct
- */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
-{
-	cancel_rearming_delayed_workqueue(keventd_wq, dwork);
+		while (!cancel_delayed_work(dwork))
+			flush_workqueue(wq);
+	}
 }
 EXPORT_SYMBOL(cancel_rearming_delayed_work);
 

