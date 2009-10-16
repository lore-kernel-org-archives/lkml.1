Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZJPIl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZJPIl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZJPIlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:41:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:43623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZJPIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:41:54 -0400
Date: Fri, 16 Oct 2009 08:40:06 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, johnstul@linux.vnet.ibm.com,
       eric.dumazet@gmail.com, peterz@infradead.org, dino@in.ibm.com,
       sdietrich@novell.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@linux.vnet.ibm.com, jkacur@redhat.com, peterz@infradead.org,
       dino@in.ibm.com, sdietrich@novell.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD7A298.5040802@us.ibm.com>
References: <4AD7A298.5040802@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Move drop_futex_key_refs out of spinlock'ed region
Message-ID: <tip-89061d3d58e1f0742139605dc6a7950aa1ecc019@git.kernel.org>
Git-Commit-ID: 89061d3d58e1f0742139605dc6a7950aa1ecc019
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 08:40:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89061d3d58e1f0742139605dc6a7950aa1ecc019
Gitweb:     http://git.kernel.org/tip/89061d3d58e1f0742139605dc6a7950aa1ecc019
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Thu, 15 Oct 2009 15:30:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 10:19:18 +0200

futex: Move drop_futex_key_refs out of spinlock'ed region

When requeuing tasks from one futex to another, the reference held
by the requeued task to the original futex location needs to be
dropped eventually.

Dropping the reference may ultimately lead to a call to
"iput_final" and subsequently call into filesystem- specific code -
which may be non-atomic.

It is therefore safer to defer this drop operation until after the
futex_hash_bucket spinlock has been dropped.

Originally-From: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: <stable@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@linux.vnet.ibm.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <4AD7A298.5040802@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 06938e5..642f3bb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1029,7 +1029,6 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
 
@@ -1227,6 +1226,7 @@ retry_private:
 		 */
 		if (ret == 1) {
 			WARN_ON(pi_state);
+			drop_count++;
 			task_count++;
 			ret = get_futex_value_locked(&curval2, uaddr2);
 			if (!ret)
@@ -1305,6 +1305,7 @@ retry_private:
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
+				drop_count++;
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
