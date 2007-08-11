Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbXHKTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbXHKTIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763155AbXHKS7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:59:32 -0400
Received: from 1wt.eu ([62.212.114.60]:1614 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762475AbXHKS7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:59:30 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184839.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:02 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 10/28] rt-mutex: Fix stale return value
Content-Disposition: inline; filename=0010-rt-mutex-Fix-stale-return-value.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kuznetsov found some problems in the pi-futex code.

The major problem is a stale return value in rt_mutex_slowlock():

When the pi chain walk returns -EDEADLK, but the waiter was woken up
during the phases where the locks were dropped, the rtmutex could be
acquired, but due to the stale return value -EDEADLK returned to the
caller.

Reset the return value in the woken up path.

Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/rtmutex.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 4ab17da..9b08847 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -659,9 +659,16 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
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
1.5.2.4

-- 
