Return-Path: <linux-kernel-owner+w=401wt.eu-S1764011AbYCGL5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011AbYCGL5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYCGL5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:57:36 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:46350 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYCGL5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:57:36 -0500
Date: Fri, 7 Mar 2008 14:57:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: microoptimize the usage of ->curr_target
Message-ID: <20080307115709.GA10557@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland McGrath.

Initialize signal->curr_target in copy_signal(). This way ->curr_target is
never == NULL, we can kill the check in __group_complete_signal's hot path.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/fork.c~4_CURR_TASK	2008-02-17 23:40:09.000000000 +0300
+++ 25/kernel/fork.c	2008-03-07 14:50:52.000000000 +0300
@@ -902,7 +902,7 @@ static int copy_signal(unsigned long clo
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
-	sig->curr_target = NULL;
+	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
--- 25/kernel/signal.c~4_CURR_TASK	2008-03-07 13:59:09.000000000 +0300
+++ 25/kernel/signal.c	2008-03-07 14:51:58.000000000 +0300
@@ -863,10 +863,6 @@ __group_complete_signal(int sig, struct 
 		 * Otherwise try to find a suitable thread.
 		 */
 		t = signal->curr_target;
-		if (t == NULL)
-			/* restart balancing at this thread */
-			t = signal->curr_target = p;
-
 		while (!wants_signal(sig, t)) {
 			t = next_thread(t);
 			if (t == signal->curr_target)

