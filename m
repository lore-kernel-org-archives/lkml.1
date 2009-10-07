Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZJGT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZJGT0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZJGT0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:26:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:48951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbZJGT0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:26:23 -0400
Date: Wed, 7 Oct 2009 19:25:11 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, hcb@chaoticmind.net,
       stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       stable@kernel.org, hcb@chaoticmind.net, tglx@linutronix.de
In-Reply-To: <4ACCE21E.5030805@us.ibm.com>
References: <4ACCE21E.5030805@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: fix requeue_pi key imbalance
Message-ID: <tip-da085681014fb43d67d9bf6d14bc068e9254bd49@git.kernel.org>
Git-Commit-ID: da085681014fb43d67d9bf6d14bc068e9254bd49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 19:25:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da085681014fb43d67d9bf6d14bc068e9254bd49
Gitweb:     http://git.kernel.org/tip/da085681014fb43d67d9bf6d14bc068e9254bd49
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Wed, 7 Oct 2009 11:46:54 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 7 Oct 2009 21:22:03 +0200

futex: fix requeue_pi key imbalance

If futex_wait_requeue_pi() wakes prior to requeue, we drop the
reference to the source futex_key twice, once in
handle_early_requeue_pi_wakeup() and once on our way out.

Remove the drop from the handle_early_requeue_pi_wakeup() and keep
the get/drops together in futex_wait_requeue_pi().

Reported-by: Helge Bahmann <hcb@chaoticmind.net>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Helge Bahmann <hcb@chaoticmind.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: stable-2.6.31 <stable@kernel.org>
LKML-Reference: <4ACCE21E.5030805@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1e176f3..c3bb2fc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2111,7 +2111,6 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &q->list.plist);
-		drop_futex_key_refs(&q->key);
 
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
