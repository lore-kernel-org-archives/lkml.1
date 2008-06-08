Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYFHRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYFHRTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYFHRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:19:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41436 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYFHRTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:19:09 -0400
Date: Sun, 8 Jun 2008 21:20:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] __mutex_lock_common: use signal_pending_state()
Message-ID: <20080608172042.GA10386@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change __mutex_lock_common() to use signal_pending_state() for the sake of
the code re-use.

This adds 7 bytes to kernel/mutex.o, but afaics only because gcc isn't smart
enough.

(btw, uninlining of __mutex_lock_common() shrinks .text from 2722 to 1542,
 perhaps it is worth doing).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/mutex.c~2_MUTEX_USE_HELPER	2008-06-04 22:05:53.000000000 +0400
+++ 26-rc2/kernel/mutex.c	2008-06-08 19:08:32.000000000 +0400
@@ -165,10 +165,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
-		if (unlikely((state == TASK_INTERRUPTIBLE &&
-					signal_pending(task)) ||
-			      (state == TASK_KILLABLE &&
-					fatal_signal_pending(task)))) {
+		if (unlikely(signal_pending_state(state, task))) {
 			mutex_remove_waiter(lock, &waiter,
 					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);

