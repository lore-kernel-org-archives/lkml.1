Return-Path: <linux-kernel-owner+w=401wt.eu-S968239AbXFHKQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968239AbXFHKQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967568AbXFHKQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:16:08 -0400
Received: from www.osadl.org ([213.239.205.134]:51228 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937401AbXFHKQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:16:07 -0400
Message-Id: <20070608101735.088903362@inhelltoy.tec.linutronix.de>
References: <20070608101714.067427012@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 10:29:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Stable Team <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: [patch-stable 2/3] rt-mutex: Fix chain walk early wakeup bug
Content-Disposition: inline; filename=rtmutex-fix-chain-walk.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code. 

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so we
we follow a non existing locking chain.

Drop out when this happens.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/rtmutex.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6.21/kernel/rtmutex.c
===================================================================
--- linux-2.6.21.orig/kernel/rtmutex.c	2007-06-08 11:56:10.000000000 +0200
+++ linux-2.6.21/kernel/rtmutex.c	2007-06-08 11:56:10.000000000 +0200
@@ -212,6 +212,19 @@ static int rt_mutex_adjust_prio_chain(st
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

