Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbXJRHCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbXJRHCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXJRHC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:02:28 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48228 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750889AbXJRHC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:02:26 -0400
Date: Thu, 18 Oct 2007 09:05:31 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Maciej W\. Rozycki" <macro@linux-mips.org>,
       Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] flush_work_sync vs. flush_scheduled_work Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-ID: <20071018070531.GA2065@ff.dom.local>
References: <20071015125301.GC3015@ff.dom.local> <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local> <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local> <20071018063157.GA1694@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018063157.GA1694@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After reading this and earlier threads about phylib's way of using
workqueue I think such a lighter and safer wrt. locking alternative
for flush_scheduled_work should be useful, but maybe it's only my
imagination.

So, let's ask Oleg Nesterov, whose solutions are here only
copy-cut-pasted & possibly abused by myslef.

--------->
Subject: flush_work_sync as an alternative for flush_scheduled_work

Similar to cancel_work_sync() but will only busy wait & block
(without cancel).

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -Nurp 2.6.23-mm1-/include/linux/workqueue.h 2.6.23-mm1/include/linux/workqueue.h
--- 2.6.23-mm1-/include/linux/workqueue.h	2007-10-12 23:45:24.000000000 +0200
+++ 2.6.23-mm1/include/linux/workqueue.h	2007-10-17 20:55:26.000000000 +0200
@@ -192,6 +192,7 @@ extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern int cancel_work_sync(struct work_struct *work);
+extern void flush_work_sync(struct work_struct *work);
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
diff -Nurp 2.6.23-mm1-/kernel/workqueue.c 2.6.23-mm1/kernel/workqueue.c
--- 2.6.23-mm1-/kernel/workqueue.c	2007-10-12 23:45:25.000000000 +0200
+++ 2.6.23-mm1/kernel/workqueue.c	2007-10-17 20:54:03.000000000 +0200
@@ -539,6 +539,30 @@ int cancel_delayed_work_sync(struct dela
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
+/**
+ * flush_work_sync - block until a work_struct's callback has terminated
+ * @work: the work which is to be flushed
+ *
+ * Similar to cancel_work_sync() but will only busy wait (without cancel)
+ * if the work is queued. If the work's callback appears to be running,
+ * flush_work_sync() will block until it has completed (but doesn't block
+ * while other callbacks are running, like flush_scheduled_work() does).
+ *
+ * It is not allowed to use this function if the work re-queues itself.
+ */
+void flush_work_sync(struct work_struct *work)
+{
+	int ret;
+
+	do {
+		ret = work_pending(work);
+		wait_on_work(work);
+		if (ret)
+			cpu_relax();
+	} while (ret);
+}
+EXPORT_SYMBOL(flush_work_sync);
+
 static struct workqueue_struct *keventd_wq __read_mostly;
 
 /**
