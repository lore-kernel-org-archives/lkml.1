Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYGXQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYGXQbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYGXQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:31:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34764 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYGXQbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:31:41 -0400
Date: Thu, 24 Jul 2008 20:35:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] __down_common: use signal_pending_state()
Message-ID: <20080724163500.GA3154@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change __down_common() to use signal_pending_state() instead of open
coding.

The changes in kernel/semaphore.o are just artefacts, the state checks
are optimized away.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/semaphore.c~2_SPS_DOWN	2008-06-08 17:25:01.000000000 +0400
+++ 26-rc2/kernel/semaphore.c	2008-07-24 20:17:47.000000000 +0400
@@ -211,9 +211,7 @@ static inline int __sched __down_common(
 	waiter.up = 0;
 
 	for (;;) {
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+		if (signal_pending_state(state, task))
 			goto interrupted;
 		if (timeout <= 0)
 			goto timed_out;

