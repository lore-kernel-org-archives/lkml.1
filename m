Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZAIHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZAIHxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZAIHwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:52:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34355 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZAIHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:52:48 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 2/2] RFC: Fix futex_lock_pi fault handling (NOT FOR INCLUSION)
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 08 Jan 2009 23:52:28 -0800
Message-ID: <20090109075228.2226.33551.stgit@Aeon>
In-Reply-To: <20090109075148.2226.5222.stgit@Aeon>
References: <20090109075148.2226.5222.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of whether we call get_user or futex_handle_fault to deal with a
fault, the uaddr doesn't change, so the key won't change.  There doesn't appear
to be a reason to re-get the key after a get_user call, but not after a
futex_handle_fault.  This patch moves both jump points to right after the the
get_futex_key call.  Also fix a missed put_futex_key() call and update the
comment to accurately depict the current code (we don't hold the mm sem now).

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/futex.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c15c029..cd03229 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1351,13 +1351,13 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	}
 
 	q.pi_state = NULL;
-retry:
+
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
-retry_unlocked:
+retry:
 	hb = queue_lock(&q);
 
 retry_locked:
@@ -1566,19 +1566,18 @@ out:
 
 uaddr_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
-	 * atomically.  Therefore, if we continue to fault after get_user()
-	 * below, we need to handle the fault ourselves, while still holding
-	 * the mmap_sem.  This can occur if the uaddr is under contention as
-	 * we have to drop the mmap_sem in order to call get_user().
+	 * We need to read and write *(int __user *)uaddr2 atomically.
+	 * Therefore, if get_user below is not enough, we need to
+	 * handle the fault ourselves.
 	 */
 	queue_unlock(&q, hb);
+	put_futex_key(fshared, &q.key);
 
 	if (attempt++) {
 		ret = futex_handle_fault((unsigned long)uaddr, attempt);
 		if (ret)
-			goto out_put_key;
-		goto retry_unlocked;
+			goto out;
+		goto retry;
 	}
 
 	ret = get_user(uval, uaddr);

