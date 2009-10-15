Return-Path: <linux-kernel-owner+w=401wt.eu-S1763147AbZJOWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763147AbZJOWbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763139AbZJOWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:31:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49314 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763045AbZJOWbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:31:38 -0400
Message-ID: <4AD7A298.5040802@us.ibm.com>
Date: Thu, 15 Oct 2009 15:30:48 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] futex: Move drop_futex_key_refs out of spinlock'ed region
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From edd4dea2dfb706d34a42255f424781f9daa79f01 Mon Sep 17 00:00:00 2001
From: Helge Bahmann <hcb@chaoticmind.net>
Date: Mon, 12 Oct 2009 11:31:35 +0200
Subject: [PATCH] Move drop_futex_key_refs out of spinlock'ed region

When requeuing tasks from one futex to another, the reference held
by the requeued task to the original futex location needs to
be dropped eventually. Dropping the reference may ultimately lead
to a call to "iput_final" and subsequently call into filesystem-
specific code. It is therefore safer to defer this drop operation
until after the futex_hash_bucket spinlock has been dropped.

Authored-by: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
CC: stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: Sven-Thorsten Dietrich <sdietrich@novell.com>
CC: John Kacur <jkacur@redhat.com>


---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4949d33..f49bf07 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1028,7 +1028,6 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
 
@@ -1226,6 +1225,7 @@ retry_private:
 		 */
 		if (ret == 1) {
 			WARN_ON(pi_state);
+			drop_count++;
 			task_count++;
 			ret = get_futex_value_locked(&curval2, uaddr2);
 			if (!ret)
@@ -1304,6 +1304,7 @@ retry_private:
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
+				drop_count++;
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
-- 
1.5.6.5


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
