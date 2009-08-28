Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZH1SE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZH1SE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZH1SE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZH1SE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:04:57 -0400
Date: Fri, 28 Aug 2009 20:00:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/1] introduce __cancel_delayed_work()
Message-ID: <20090828180015.GB19326@redhat.com>
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com> <ada4orwvrx7.fsf@cisco.com> <20090825093906.GA3020@redhat.com> <ada7hwqto0z.fsf@cisco.com> <20090828175931.GA19326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828175931.GA19326@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cancel_delayed_work() has to use del_timer_sync() to guarantee the
timer function is not running after return. But most users doesn't
actually need this, and del_timer_sync() has problems: it is not
useable from interrupt, and it depends on every lock which could
be taken from irq.

Introduce __cancel_delayed_work() which calls del_timer() instead.

The immediate reason for this patch is
http://bugzilla.kernel.org/show_bug.cgi?id=13757
but hopefully this helper makes sense anyway.

As for 13757 bug, actually we need requeue_delayed_work(), but its
semantics is not clear yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- MINI/include/linux/workqueue.h~CDW	2009-08-27 20:17:08.000000000 +0200
+++ MINI/include/linux/workqueue.h	2009-08-27 20:22:48.000000000 +0200
@@ -240,6 +240,21 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
+/*
+ * Like above, but uses del_timer() instead of del_timer_sync(). This means,
+ * if it returns 0 the timer function may be running and the queueing is in
+ * progress.
+ */
+static inline int __cancel_delayed_work(struct delayed_work *work)
+{
+	int ret;
+
+	ret = del_timer(&work->timer);
+	if (ret)
+		work_clear_pending(&work->work);
+	return ret;
+}
+
 extern int cancel_delayed_work_sync(struct delayed_work *work);
 
 /* Obsolete. use cancel_delayed_work_sync() */

