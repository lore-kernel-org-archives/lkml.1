Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZI3VBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZI3VBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZI3VBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:01:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:43959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZI3VBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:01:46 -0400
Date: Wed, 30 Sep 2009 21:01:13 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, johnstul@us.ibm.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090930170754.0886ff2e@infradead.org>
References: <20090930170754.0886ff2e@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched_clock: Fix atomicity/continuity bug by using cmpxchg64()
Message-ID: <tip-152f9d0710a62708710161bce1b29fa8292c8c11@git.kernel.org>
Git-Commit-ID: 152f9d0710a62708710161bce1b29fa8292c8c11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 30 Sep 2009 21:01:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  152f9d0710a62708710161bce1b29fa8292c8c11
Gitweb:     http://git.kernel.org/tip/152f9d0710a62708710161bce1b29fa8292c8c11
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Wed, 30 Sep 2009 20:36:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Sep 2009 22:56:10 +0200

sched_clock: Fix atomicity/continuity bug by using cmpxchg64()

Commit def0a9b2573 (sched_clock: Make it NMI safe) assumed
cmpxchg() of 64bit values was available on X86_32.

That is not so - and causes some subtle scheduler misbehavior due
to incorrect timestamps off to up by ~4 seconds.

Two symptoms are known right now:

 - interactivity problems seen by Arjan: up to 600 msecs
   latencies instead of the expected 20-40 msecs. These
   latencies are very visible on the desktop.

 - incorrect CPU stats: occasionally too high percentages in 'top',
   and crazy CPU usage stats.

Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090930170754.0886ff2e@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_clock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ac2e1dc..479ce56 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -127,7 +127,7 @@ again:
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
 		goto again;
 
 	return clock;
@@ -163,7 +163,7 @@ again:
 		val = remote_clock;
 	}
 
-	if (cmpxchg(ptr, old_val, val) != old_val)
+	if (cmpxchg64(ptr, old_val, val) != old_val)
 		goto again;
 
 	return val;
