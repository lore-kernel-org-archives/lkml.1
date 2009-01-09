Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZAIHxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZAIHxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZAIHww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:52:52 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56657 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZAIHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:52:48 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/2] RFC: Fix futex_wake_op fault handling (NOT FOR INCLUSION)
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 08 Jan 2009 23:52:22 -0800
Message-ID: <20090109075222.2226.43590.stgit@Aeon>
In-Reply-To: <20090109075148.2226.5222.stgit@Aeon>
References: <20090109075148.2226.5222.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the the uaddr doesn't change after attempts to handle the fault, there is no
need to re-get the futex keys after get_user().  This patch makes successful
calls to futex_handle_fault() and get_user() start the retry from the same
point (right after the get_futex_key calls).  Also simplify the logic and
corrects missing put on the futex keys.  Finally, update the comment to more
accurate reflect the current code (we no hold the mm sem here).

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/futex.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 206d4c9..c15c029 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -745,7 +745,6 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
 
-retryfull:
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
@@ -782,25 +781,19 @@ retry:
 		}
 
 		/*
-		 * futex_atomic_op_inuser needs to both read and write
-		 * *(int __user *)uaddr2, but we can't modify it
-		 * non-atomically.  Therefore, if get_user below is not
-		 * enough, we need to handle the fault ourselves, while
-		 * still holding the mmap_sem.
+		 * We need to read and write *(int __user *)uaddr2 atomically.
+		 * Therefore, if get_user below is not enough, we need to
+		 * handle the fault ourselves.
 		 */
-		if (attempt++) {
+		if (attempt++)
 			ret = futex_handle_fault((unsigned long)uaddr2,
 						 attempt);
-			if (ret)
-				goto out_put_keys;
-			goto retry;
-		}
+		else
+			ret = get_user(dummy, uaddr2);
 
-		ret = get_user(dummy, uaddr2);
 		if (ret)
-			return ret;
-
-		goto retryfull;
+			goto out_put_keys;
+		goto retry;
 	}
 
 	head = &hb1->chain;

