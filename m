Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYG0LeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYG0LeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYG0Ld5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:33:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60283 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYG0Ld4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:33:56 -0400
Date: Sun, 27 Jul 2008 15:37:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, roland@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] wait_task_inactive: don't consider task->nivcsw
Message-ID: <20080727113732.GA178@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If wait_task_inactive() returns success the task was deactivated.
In that case schedule() always increments ->nvcsw which alone can
be used as a "generation counter".

If the next call returns the same number, we can be sure that the
task was unscheduled. Otherwise, because we know that .on_rq == 0
again, ->nvcsw should have been changed in between.

Q: perhaps it is better to do "ncsw = (p->nvcsw << 1) | 1" ? This
decreases the possibility of "was it unscheduled" false positive
when ->nvcsw == 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- LINUS/kernel/sched.c~	2008-07-27 14:46:03.000000000 +0400
+++ LINUS/kernel/sched.c	2008-07-27 14:55:12.000000000 +0400
@@ -1922,11 +1922,8 @@ unsigned long wait_task_inactive(struct 
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
-		if (!match_state || p->state == match_state) {
-			ncsw = p->nivcsw + p->nvcsw;
-			if (unlikely(!ncsw))
-				ncsw = 1;
-		}
+		if (!match_state || p->state == match_state)
+			ncsw = p->nvcsw ?: 1;
 		task_rq_unlock(rq, &flags);
 
 		/*

