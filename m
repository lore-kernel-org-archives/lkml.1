Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYLRXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYLRXH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYLRXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:06:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35591 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbYLRXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:06:53 -0500
Message-ID: <494AD77A.1070804@us.ibm.com>
Date: Thu, 18 Dec 2008 15:06:34 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Morton, Andrew" <akpm@osdl.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] futex: Cleanup futex_(un)lock_pi fault handling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some apparently left over cruft code was complicating the fault logic.  Testing if uval != -EFAULT doesn't have any meaning, get_user() sets ret to either 0 or -EFAULT, there's no need to compare uval, especially not against EFAULT which it will never be.  This patch removes the superfluous test and clarifies the comment blocks.

Build and boot tested on an 8way x86_64 system.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index 99f8acc..b4f87ba 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1565,12 +1565,11 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 
  uaddr_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. :-) --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	queue_unlock(&q, hb);
 
@@ -1582,7 +1581,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	}
 
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	if (to)
@@ -1676,12 +1675,11 @@ out:
 
 pi_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	spin_unlock(&hb->lock);
 
@@ -1694,7 +1692,7 @@ pi_faulted:
 	}
 
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	return ret;
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
