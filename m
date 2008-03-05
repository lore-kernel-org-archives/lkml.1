Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYCEVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYCEVym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762280AbYCEVyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:54:15 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56578 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179AbYCEVyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:54:14 -0500
Date: Thu, 6 Mar 2008 00:53:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] send_sigqueue: don't forget about handle_stop_signal()
Message-ID: <20080305215314.GA3821@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of Pavel's signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch)

send_group_sigqueue() calls handle_stop_signal(), send_sigqueue() doesn't.
This is not consistent and in fact I'd say this is (minor) bug.

Move handle_stop_signal() from send_group_sigqueue() to do_send_sigqueue(),
the latter is called by send_sigqueue() too.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~2_SS_HSS	2008-03-06 00:35:35.000000000 +0300
+++ 25/kernel/signal.c	2008-03-06 00:43:50.000000000 +0300
@@ -1274,8 +1274,10 @@ void sigqueue_free(struct sigqueue *q)
 }
 
 static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
-		struct sigpending *pending)
+				struct sigpending *pending)
 {
+	handle_stop_signal(sig, t);
+
 	if (unlikely(!list_empty(&q->list))) {
 		/*
 		 * If an SI_TIMER entry is already queue just increment
@@ -1335,7 +1337,6 @@ send_group_sigqueue(int sig, struct sigq
 	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	handle_stop_signal(sig, p);
 
 	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
 

