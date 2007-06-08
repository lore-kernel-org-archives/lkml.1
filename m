Return-Path: <linux-kernel-owner+w=401wt.eu-S967088AbXFHAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967088AbXFHAaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966437AbXFHA3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:29:23 -0400
Received: from www.osadl.org ([213.239.205.134]:53137 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966405AbXFHA3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:29:22 -0400
Message-Id: <20070607235801.494414000@linutronix.de>
References: <20070607235106.387346000@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:29:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 2/4] rt-mutex: Fix chain walk early wakeup bug
Content-Disposition: inline; filename=rtmutex-fix-chain-walk.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code. 

One of the root causes is:

When a wakeup happens, we do not to stop the chain walk so
we follow a not longer relevant locking chain.

Drop out when this happens.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/rtmutex.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6.22-rc4/kernel/rtmutex.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/rtmutex.c	2007-06-08 01:39:38.000000000 +0200
+++ linux-2.6.22-rc4/kernel/rtmutex.c	2007-06-08 01:39:38.000000000 +0200
@@ -189,6 +189,19 @@ int rt_mutex_adjust_prio_chain(struct ta
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

