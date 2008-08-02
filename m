Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYHBVl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYHBVl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYHBVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:41:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:62082 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYHBVlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=J1yVmXoAFx/mQZJO7/qpo0EDfliIhelucOdtdWWOttIxuvvr8qWSNviGtT6F2x/o/7
         OCa+1ZWxIn7AZ6U8TxEKJjJy5WqMFuuerHvKw8vc20bis9DbHs7FzNbIsV61x616Q9ck
         vRXrum4hsK9R6Tw1gG97bzA+yeiKThYnmLXt8=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] posix timers: timer_delete: remove the bogus "->it_process != NULL" check
Date: Sat, 2 Aug 2008 23:52:45 +0200
User-Agent: KMail/1.9.9
Cc: Roland McGrath <roland@redhat.com>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Oliver Pinter <oliver.pntr@gmail.com>, w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022352.45700.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
if not then send NAK.

---

>From 4b7a1304267bff68260ae861784b27130e805be3 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@tv-sign.ru>
Date: Fri, 25 Jul 2008 01:47:26 -0700
Subject: [PATCH] posix timers: timer_delete: remove the bogus "->it_process != NULL" check

[ Upstream commit 4b7a1304267bff68260ae861784b27130e805be3 ]

sys_timer_delete() and itimer_delete() check "timer->it_process != NULL",
this looks completely bogus.  ->it_process == NULL means that this timer
is already under destruction or it is not fully initialized, this must not
happen.

	sys_timer_delete: the timer is locked, and lock_timer() can't succeed
	if ->it_process == NULL.

	itimer_delete: it is called by exit_itimers() when there are no other
	threads which can play with signal_struct->posix_timers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index dbd8398..17f5326 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -856,11 +856,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 	return 0;
@@ -885,11 +884,10 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_process) {
-		if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-			put_task_struct(timer->it_process);
-		timer->it_process = NULL;
-	}
+	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
+		put_task_struct(timer->it_process);
+	timer->it_process = NULL;
+
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
 }
