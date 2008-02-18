Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYBRREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYBRREv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYBRREa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:04:30 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50190 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYBRRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:04:28 -0500
Date: Mon, 18 Feb 2008 20:07:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] k_getrusage: don't take rcu_read_lock()
Message-ID: <20080218170737.GA2715@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(just a trivial example, more to come)

k_getrusage() holds rcu_read_lock() because it was previously required by
lock_task_sighand(). Unneeded now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/sys.c~2_GRU	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/sys.c	2008-02-18 19:15:40.000000000 +0300
@@ -1548,11 +1548,8 @@ static void k_getrusage(struct task_stru
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
-	rcu_read_lock();
-	if (!lock_task_sighand(p, &flags)) {
-		rcu_read_unlock();
+	if (!lock_task_sighand(p, &flags))
 		return;
-	}
 
 	switch (who) {
 		case RUSAGE_BOTH:
@@ -1595,9 +1592,7 @@ static void k_getrusage(struct task_stru
 		default:
 			BUG();
 	}
-
 	unlock_task_sighand(p, &flags);
-	rcu_read_unlock();
 
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);

