Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZBKRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZBKRJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZBKRJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:09:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBKRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:09:03 -0500
Subject: [PATCH -v4] futex: fix reference leak
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090211162618.GC32301@elte.hu>
References: <1234197950.5951.132.camel@laptop>
	 <1234198023.5951.133.camel@laptop>
	 <1234200538.16083.52.camel@pc1117.cambridge.arm.com>
	 <1234203975.5951.143.camel@laptop>
	 <1234205595.4286.223.camel@localhost.localdomain>
	 <1234205874.5951.151.camel@laptop> <20090211122849.GD16535@elte.hu>
	 <1234366605.23438.179.camel@twins> <20090211154952.GB24408@elte.hu>
	 <1234367802.23438.183.camel@twins>  <20090211162618.GC32301@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 18:10:10 +0100
Message-Id: <1234372210.23438.192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: futex: fix reference leak
From: Peter Zijlstra <peterz@infradead.org>

Catalin noticed that (38d47c1b7075: futex: rely on get_user_pages() for
shared futexes) caused an mm_struct leak.

Some tracing with the function graph tracer quickly pointed out that
futex_wait() has exit paths with unbalanced reference counts.

This regression was discovered by kmemleak.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/futex.c |   53 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index f89d373..438701a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1165,6 +1165,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct task_struct *curr = current;
+	struct restart_block *restart;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
@@ -1216,11 +1217,13 @@ retry:
 
 		if (!ret)
 			goto retry;
-		return ret;
+		goto out;
 	}
 	ret = -EWOULDBLOCK;
-	if (uval != val)
-		goto out_unlock_put_key;
+	if (unlikely(uval != val)) {
+		queue_unlock(&q, hb);
+		goto out_put_key;
+	}
 
 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
@@ -1284,38 +1287,38 @@ retry:
 	 */
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
+	ret = 0;
 	if (!unqueue_me(&q))
-		return 0;
+		goto out_put_key;
+	ret = -ETIMEDOUT;
 	if (rem)
-		return -ETIMEDOUT;
+		goto out_put_key;
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
+	ret = -ERESTARTSYS;
 	if (!abs_time)
-		return -ERESTARTSYS;
-	else {
-		struct restart_block *restart;
-		restart = &current_thread_info()->restart_block;
-		restart->fn = futex_wait_restart;
-		restart->futex.uaddr = (u32 *)uaddr;
-		restart->futex.val = val;
-		restart->futex.time = abs_time->tv64;
-		restart->futex.bitset = bitset;
-		restart->futex.flags = 0;
-
-		if (fshared)
-			restart->futex.flags |= FLAGS_SHARED;
-		if (clockrt)
-			restart->futex.flags |= FLAGS_CLOCKRT;
-		return -ERESTART_RESTARTBLOCK;
-	}
+		goto out_put_key;
 
-out_unlock_put_key:
-	queue_unlock(&q, hb);
-	put_futex_key(fshared, &q.key);
+	restart = &current_thread_info()->restart_block;
+	restart->fn = futex_wait_restart;
+	restart->futex.uaddr = (u32 *)uaddr;
+	restart->futex.val = val;
+	restart->futex.time = abs_time->tv64;
+	restart->futex.bitset = bitset;
+	restart->futex.flags = 0;
+
+	if (fshared)
+		restart->futex.flags |= FLAGS_SHARED;
+	if (clockrt)
+		restart->futex.flags |= FLAGS_CLOCKRT;
 
+	ret = -ERESTART_RESTARTBLOCK;
+
+out_put_key:
+	put_futex_key(fshared, &q.key);
 out:
 	return ret;
 }

