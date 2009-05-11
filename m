Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZEKMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZEKMjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbZEKMj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:27 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47544 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZEKMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:26 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 1/6] lockdep: Remove redundant read checks.
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:30 +0530
Message-ID: <20090511123930.31159.58092.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) In kernel/lockdep.c::validate_chain()
	ret = check_deadlock(curr, hlock, lock, hlock->read);
ret = 2 only if hlock->read = 2.

Hence,
	if (ret == 2)
		hlock->read = 2;
is redundant, hence can be removed.

2) In kernel/lockdep.c::check_prevs_add(curr, next)
	if (hlock->read != 2)
		check_prev_add(curr, hlock, next, distance);

Thus, check_prev_add is called only when hlock->read != 2.

>From the conclusions of 2),
kernel/lockdep.c::check_prev_add(curr, prev, next, distance) gets called
iff prev->read != 2.
Hence, in kernel/lockdep.c::check_prev_add(curr, prev, next, distance)
	if (prev->read == 2)
		return 1;
is redunant, hence can be removed.


Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/lockdep.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index accb40c..8d3c2b5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1496,7 +1496,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
-	if (next->read == 2 || prev->read == 2)
+	if (next->read == 2)
 		return 1;
 	/*
 	 * Is the <prev> -> <next> dependency already present?
@@ -1754,13 +1754,6 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 		if (!ret)
 			return 0;
 		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
-		 */
-		if (ret == 2)
-			hlock->read = 2;
-		/*
 		 * Add dependency only if this lock is not the head
 		 * of the chain, and if it's not a secondary read-lock:
 		 */

