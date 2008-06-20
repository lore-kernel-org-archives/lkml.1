Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYFTIPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYFTIPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYFTIOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:14:50 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:53853 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYFTIOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:14:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: lmbench regression due to cond_resched nullification change 26-rc5 vs. 25
Date: Fri, 20 Jun 2008 10:14:43 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201014.43576.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On a 6-way s390 I have seen some interesting regression in 2.6.26-rc5 vs. 
2.6.25 for the lmbench benchmark.

For example select file 500:
23 microseconds
32 microseconds

Several lmbench tests show a regression but I only bisected the select test 
case so far:
-------------------------<snip---------------------

commit c714a534d85576af21b06be605ca55cb2fb887ee
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 12 13:34:13 2008 -0700

    Make 'cond_resched()' nullification depend on PREEMPT_BKL

    Because it's not correct with a non-preemptable BKL and just causes
    PREEMPT kernels to have longer latencies than non-PREEMPT ones (which is
    obviously not the point of it at all).

    Of course, that config option actually got removed as an option earlier,
    so for now this basically disables it entirely, but if BKL preemption is
    ever resurrected it will be a meaningful optimization.  And in the
    meantime, it at least documents the intent of the code, while not doing
    the wrong thing.

    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a63f2d..5395a61 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2038,7 +2038,7 @@ static inline int need_resched(void)
  * cond_resched_softirq() will enable bhs before scheduling.
  */
 extern int _cond_resched(void);
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_BKL
 static inline int cond_resched(void)
 {
        return 0;
-------------------------<snip---------------------

Reverting that patch gives me the 2.6.25 performance. 

I think the patch is fine from the correctness point of view (do resched 
inside BKL protected zones if its safe) but I dont understand why it has a 
large impact on the select microbenchmark. Any ideas? Is it simply the 
overhead of _cond_resched?

Christian
