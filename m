Return-Path: <linux-kernel-owner+w=401wt.eu-S967139AbXFHA3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967139AbXFHA3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966352AbXFHA3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:29:21 -0400
Received: from www.osadl.org ([213.239.205.134]:53128 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966316AbXFHA3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:29:20 -0400
Message-Id: <20070607235801.429050000@linutronix.de>
References: <20070607235106.387346000@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:29:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 1/4] rt-mutex: Fix stale return value
Content-Disposition: inline; filename=rtmutex-fix-stale-return-value.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code. 

The major problem is a stale return value in rt_mutex_slowlock():

When the pi chain walk returns -EDEADLK, but the waiter was woken up 
during the phases where the locks were dropped, the rtmutex could be
acquired, but due to the stale return value -EDEADLK returned to the
caller.

Reset the return value in the retry path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/rtmutex.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4/kernel/rtmutex.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/rtmutex.c	2007-06-08 01:39:38.000000000 +0200
+++ linux-2.6.22-rc4/kernel/rtmutex.c	2007-06-08 01:39:38.000000000 +0200
@@ -636,9 +636,16 @@ rt_mutex_slowlock(struct rt_mutex *lock,
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

