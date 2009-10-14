Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbZJNUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbZJNUNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbZJNUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933672AbZJNUNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:13:37 -0400
Date: Wed, 14 Oct 2009 20:11:03 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD60687.10306@us.ibm.com>
References: <4AD60687.10306@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Check for NULL keys in match_futex
Message-ID: <tip-2bc872036e1c5948b5b02942810bbdd8dbdb9812@git.kernel.org>
Git-Commit-ID: 2bc872036e1c5948b5b02942810bbdd8dbdb9812
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 20:11:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bc872036e1c5948b5b02942810bbdd8dbdb9812
Gitweb:     http://git.kernel.org/tip/2bc872036e1c5948b5b02942810bbdd8dbdb9812
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Wed, 14 Oct 2009 10:12:39 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 22:00:14 +0200

futex: Check for NULL keys in match_futex

If userspace tries to perform a requeue_pi on a non-requeue_pi waiter,
it will find the futex_q->requeue_pi_key to be NULL and OOPS.

Check for NULL in match_futex() instead of doing explicit NULL pointer
checks on all call sites.  While match_futex(NULL, NULL) returning
false is a little odd, it's still correct as we expect valid key
references.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
Cc: stable@kernel.org
LKML-Reference: <4AD60687.10306@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5c88839..06938e5 100644
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
