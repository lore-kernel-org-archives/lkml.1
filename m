Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYD2M6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYD2M6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYD2M6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:58:42 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51964 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbYD2M6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:58:41 -0400
Date: Tue, 29 Apr 2008 18:28:32 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 2/8] lockdep: reader-in-writer recursion
Message-ID: <20080429125832.GC23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: reader-in-writer recursion

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Create a read mode that allows for reader-in-writer recursion

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |    1 +
 kernel/lockdep.c        |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..36e254f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -291,6 +291,7 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
  *   0: exclusive (write) acquire
  *   1: read-acquire (no recursion allowed)
  *   2: read-acquire with same-instance recursion allowed
+ *   3: 2 + reader in writer recursion
  *
  * Values for check:
  *
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 94b0f4f..3859259 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1280,6 +1280,13 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 		 */
 		if ((read == 2) && prev->read)
 			return 2;
+		/*
+		 * Allow read-after-write recursion of the same
+		 * lock class (i.e. write_lock(lock)+read_lock(lock)):
+		 */
+		if (read == 3)
+			return 2;
+
 		return print_deadlock_bug(curr, prev, next);
 	}
 	return 1;
@@ -1559,7 +1566,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 		 * If we are the first recursive read, don't jump over our
 		 * dependency.
 		 */
-		if (hlock->read == 2 && ret != 2)
+		if (hlock->read >= 2 && ret != 2)
 			hlock->read = 1;
 		/*
 		 * Add dependency only if this lock is not the head
-- 
Thanks and Regards
gautham
