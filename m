Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYG3RHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYG3RHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYG3RGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:06:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38848 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbYG3RGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:06:41 -0400
Date: Wed, 30 Jul 2008 21:09:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] wait_task_inactive: "improve" the returned value for ->nvcsw == 0
Message-ID: <20080730170948.GA18676@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of wait_task_inactive-dont-consider-task-nivcsw.patch)

wait_task_inactive() returns 1 when p->nvcsw == 0 || p->nvcsw == 1.
This means that two subsequent calls can return the same number while
the task was scheduled in between.

Change the code to return "nvcsw | LONG_MIN" instead of "nvcsw ?: 1",
now the overlap always needs LONG_MAX schedules.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 27/kernel/sched.c~1_WTI_RET	2008-07-30 19:32:09.000000000 +0400
+++ 27/kernel/sched.c	2008-07-30 19:47:56.000000000 +0400
@@ -1923,7 +1923,7 @@ unsigned long wait_task_inactive(struct 
 		on_rq = p->se.on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
-			ncsw = p->nvcsw ?: 1;
+			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, &flags);
 
 		/*

