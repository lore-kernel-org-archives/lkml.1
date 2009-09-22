Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZIVNfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZIVNfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZIVNfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZIVNfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:13 -0400
Date: Tue, 22 Sep 2009 13:34:16 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] ratelimit: Fix/allow use in atomic contexts
Message-ID: <tip-edaac8e3167501cda336231d00611bf59c164346@git.kernel.org>
Git-Commit-ID: edaac8e3167501cda336231d00611bf59c164346
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:34:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edaac8e3167501cda336231d00611bf59c164346
Gitweb:     http://git.kernel.org/tip/edaac8e3167501cda336231d00611bf59c164346
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 14:44:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 14:05:48 +0200

ratelimit: Fix/allow use in atomic contexts

I'd like to use printk_ratelimit() in NMI context, but it's not
robust right now due to spinlock usage in lib/ratelimit.c. If an
NMI is unlucky enough to hit just that spot we might lock up trying
to take the spinlock again.

Fix that by using a trylock variant. If we contend on that lock we
can genuinely skip the message because the state is just being
accessed by another CPU (or by this CPU).

( We could use atomics for the suppressed messages field, but
  i doubt it matters in practice and it makes the code heavier. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/ratelimit.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 0e2c28e..69bfcac 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -28,7 +28,15 @@ int __ratelimit(struct ratelimit_state *rs)
 	if (!rs->interval)
 		return 1;
 
-	spin_lock_irqsave(&rs->lock, flags);
+	/*
+	 * If we contend on this state's lock then almost
+	 * by definition we are too busy to print a message,
+	 * in addition to the one that will be printed by
+	 * the entity that is holding the lock already:
+	 */
+	if (!spin_trylock_irqsave(&rs->lock, flags))
+		return 1;
+
 	if (!rs->begin)
 		rs->begin = jiffies;
 
