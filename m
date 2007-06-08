Return-Path: <linux-kernel-owner+w=401wt.eu-S968729AbXFHKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968729AbXFHKQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967760AbXFHKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:16:09 -0400
Received: from www.osadl.org ([213.239.205.134]:51231 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966961AbXFHKQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:16:08 -0400
Message-Id: <20070608101735.036883282@inhelltoy.tec.linutronix.de>
References: <20070608101714.067427012@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 10:29:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Stable Team <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: [patch-stable 1/3] rt-mutex: Fix stale return value
Content-Disposition: inline; filename=rtmutex-fix-stale-return-value.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code. 

The major problem is a stale return value in rt_mutex_slowlock():

When the pi chain walk returns -EDEADLK, but the waiter was woken up 
during the phases where the locks were dropped, the rtmutex could be
acquired, but due to the stale return value -EDEADLK returned to the
caller.

Reset the return value in the woken up path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/rtmutex.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.21/kernel/rtmutex.c
===================================================================
--- linux-2.6.21.orig/kernel/rtmutex.c	2007-06-08 11:56:10.000000000 +0200
+++ linux-2.6.21/kernel/rtmutex.c	2007-06-08 11:56:10.000000000 +0200
@@ -659,9 +659,16 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 			 * all over without going into schedule to try
 			 * to get the lock now:
 			 */
-			if (unlikely(!waiter.task))
+			if (unlikely(!waiter.task)) {
+				/*
+				 * Reset the return value. We might
+				 * have returned with -EDEADLK and the
+				 * owner released the lock while we
+				 * were walking the pi chain.
+				 */
+				ret = 0;
 				continue;
-
+			}
 			if (unlikely(ret))
 				break;
 		}

-- 

