Return-Path: <linux-kernel-owner+w=401wt.eu-S937106AbXHGVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937106AbXHGVTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964899AbXHGUzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:55:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59780 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbXHGUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:55:46 -0400
Date: Tue, 7 Aug 2007 13:48:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, vatsa@in.ibm.com, mschmidt@redhat.com,
       oleg@tv-sign.ru
Subject: [2.6.22.2 review 64/84] destroy_workqueue() can livelock
Message-ID: <20070807204819.GN23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="destroy_workqueue-can-livelock.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleg Nesterov <oleg@tv-sign.ru>

Pointed out by Michal Schmidt <mschmidt@redhat.com>.

The bug was introduced in 2.6.22 by me.

cleanup_workqueue_thread() does flush_cpu_workqueue(cwq) in a loop until
->worklist becomes empty.  This is live-lockable, a re-niced caller can get
CPU after wake_up() and insert a new barrier before the lower-priority
cwq->thread has a chance to clear ->current_work.

Change cleanup_workqueue_thread() to do flush_cpu_workqueue(cwq) only once.
 We can rely on the fact that run_workqueue() won't return until it flushes
all works.  So it is safe to call kthread_stop() after that, the "should
stop" request won't be noticed until run_workqueue() returns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/workqueue.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -739,18 +739,17 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
+	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
-	 * is not enough, a concurrent flush_workqueue() can insert a
-	 * barrier after us.
+	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * a concurrent flush_workqueue() can insert a barrier after us.
+	 * However, in that case run_workqueue() won't return and check
+	 * kthread_should_stop() until it flushes all work_struct's.
 	 * When ->worklist becomes empty it is safe to exit because no
 	 * more work_structs can be queued on this cwq: flush_workqueue
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	while (flush_cpu_workqueue(cwq))
-		;
-
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }

-- 
