Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbYD2M6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbYD2M6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbYD2M6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:58:06 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:43813 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbYD2M6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:58:04 -0400
Date: Tue, 29 Apr 2008 18:27:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 1/8] lockdep: fix recursive read lock validation
Message-ID: <20080429125750.GB23562@in.ibm.com>
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

Subject: lockdep: fix recursive read lock validation

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

__lock_acquire( .read = 2 )
  hlock->read = read; /* [1] */
  validate_chain()
    ret = check_deadlock(); /* returns 2 when recursive */

    if (ret == 2)
      hlock->read = 2; /* but it was already 2 from [1] */

    check_prevs_add()
      if (hlock->read != 2)
        /* add to dependency chain */

So it will never add a recursive read lock to the dependency chain. Fix this
by setting hlock->read to 1 when its the first recursive lock instance.

This means that the following sequence is now invalid, whereas previously
it was considered valid:

  rlock(a); rlock(b); runlock(b); runlock(a)
  rlock(b); rlock(a);

It really is invalid when considered against write locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/lockdep.c       |    9 ++++-----
 lib/locking-selftest.c |   12 ++++++------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 81a4e4a..94b0f4f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1556,12 +1556,11 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 		if (!ret)
 			return 0;
 		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
+		 * If we are the first recursive read, don't jump over our
+		 * dependency.
 		 */
-		if (ret == 2)
-			hlock->read = 2;
+		if (hlock->read == 2 && ret != 2)
+			hlock->read = 1;
 		/*
 		 * Add dependency only if this lock is not the head
 		 * of the chain, and if it's not a secondary read-lock:
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 280332c..c84a689 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1135,12 +1135,12 @@ void locking_selftest(void)
 	debug_locks_silent = !debug_locks_verbose;
 
 	DO_TESTCASE_6R("A-A deadlock", AA);
-	DO_TESTCASE_6R("A-B-B-A deadlock", ABBA);
-	DO_TESTCASE_6R("A-B-B-C-C-A deadlock", ABBCCA);
-	DO_TESTCASE_6R("A-B-C-A-B-C deadlock", ABCABC);
-	DO_TESTCASE_6R("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
-	DO_TESTCASE_6R("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
-	DO_TESTCASE_6R("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
+	DO_TESTCASE_6("A-B-B-A deadlock", ABBA);
+	DO_TESTCASE_6("A-B-B-C-C-A deadlock", ABBCCA);
+	DO_TESTCASE_6("A-B-C-A-B-C deadlock", ABCABC);
+	DO_TESTCASE_6("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
+	DO_TESTCASE_6("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
+	DO_TESTCASE_6("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
 	DO_TESTCASE_6("double unlock", double_unlock);
 	DO_TESTCASE_6("initialize held", init_held);
 	DO_TESTCASE_6_SUCCESS("bad unlock order", bad_unlock_order);
-- 
Thanks and Regards
gautham
