Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZJNRNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZJNRNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZJNRNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:13:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38637 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZJNRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:13:42 -0400
Message-ID: <4AD60687.10306@us.ibm.com>
Date: Wed, 14 Oct 2009 10:12:39 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [PATCH] futex: check for NULL keys in match_futex
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

If userspace tries to perform a requeue_pi on a non-requeue_pi waiter, it
will find the futex_q->requeue_pi_key to be NULL and OOPS.  Check for NULL
in match_futex().  This results in cleaner code than checking at each call
site.  While match_futex(NULL, NULL) returning false is a little odd, it
will OOPS as it is today.  This approach catches all possible call sites
as well.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4949d33..5971730 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -150,7 +150,8 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
  */
 static inline int match_futex(union futex_key *key1, union futex_key *key2)
 {
-	return (key1->both.word == key2->both.word
+	return (key1 && key2
+		&& key1->both.word == key2->both.word
 		&& key1->both.ptr == key2->both.ptr
 		&& key1->both.offset == key2->both.offset);
 }
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
