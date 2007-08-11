Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbXHKTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbXHKTIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761353AbXHKS7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:59:34 -0400
Received: from 1wt.eu ([62.212.114.60]:1615 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763118AbXHKS7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:59:30 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184840.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:03 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 11/28] rt-mutex: Fix chain walk early wakeup bug
Content-Disposition: inline; filename=0011-rt-mutex-Fix-chain-walk-early-wakeup-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code.

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so we
we follow a non existing locking chain.

Drop out when this happens.

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/rtmutex.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 9b08847..dd5feae 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -212,6 +212,19 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	if (!waiter || !waiter->task)
 		goto out_unlock_pi;
 
+	/*
+	 * Check the orig_waiter state. After we dropped the locks,
+	 * the previous owner of the lock might have released the lock
+	 * and made us the pending owner:
+	 */
+	if (orig_waiter && !orig_waiter->task)
+		goto out_unlock_pi;
+
+	/*
+	 * Drop out, when the task has no waiters. Note,
+	 * top_waiter can be NULL, when we are in the deboosting
+	 * mode!
+	 */
 	if (top_waiter && (!task_has_pi_waiters(task) ||
 			   top_waiter != task_top_pi_waiter(task)))
 		goto out_unlock_pi;
-- 
1.5.2.4

-- 
