Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZHIUUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZHIUUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZHIUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:20:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZHIUUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:20:05 -0400
Date: Sun, 9 Aug 2009 22:19:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL, v2] core kernel fixes
Message-ID: <20090809201941.GB14135@elte.hu>
References: <20090809160730.GA26383@elte.hu> <4A7F185E.5070104@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7F185E.5070104@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhltc@us.ibm.com> wrote:

> Ingo Molnar wrote:
>> Linus,
>>
>> Please pull the latest core-fixes-for-linus git tree from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus
>>
>>  Thanks,
>>
>> 	Ingo
>>
>> ------------------>
>> Darren Hart (2):
>>       rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()
>>       futex: Update woken requeued futex_q lock_ptr
>
> Ingo, this still has the older version of:
>
> "futex: Update woken requeued futex_q lock_ptr"
>
> Please update to the resend on Aug 7:

Resend usual means 'same stuff again' and since i already had the 
first patch i skipped it. The usual way is to put 'v2' into the 
subject or something. Anyway - v2 needs re-testing.

Linus, please pull this shortened tree instead (it has the final 
commit removed):

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus-2

 Thanks,

	Ingo

------------------>
Darren Hart (1):
      rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()

Li Zefan (2):
      lockdep: Fix file mode of lock_stat
      lockdep: Fix typos in documentation


 Documentation/lockdep-design.txt |    6 +++---
 kernel/lockdep_proc.c            |    3 ++-
 kernel/rtmutex.c                 |    4 +---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index e20d913..abf768c 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -30,9 +30,9 @@ State
 The validator tracks lock-class usage history into 4n + 1 separate state bits:
 
 - 'ever held in STATE context'
-- 'ever head as readlock in STATE context'
-- 'ever head with STATE enabled'
-- 'ever head as readlock with STATE enabled'
+- 'ever held as readlock in STATE context'
+- 'ever held with STATE enabled'
+- 'ever held as readlock with STATE enabled'
 
 Where STATE can be either one of (kernel/lockdep_states.h)
  - hardirq
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d7135aa..e94caa6 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -758,7 +758,8 @@ static int __init lockdep_proc_init(void)
 		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
+	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
+		    &proc_lock_stat_operations);
 #endif
 
 	return 0;
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index fcd107a..29bd4ba 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1039,16 +1039,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
 		/* We got the lock for task. */
 		debug_rt_mutex_lock(lock);
-
 		rt_mutex_set_owner(lock, task, 0);
-
+		spin_unlock(&lock->wait_lock);
 		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
-
 	if (ret && !waiter->task) {
 		/*
 		 * Reset the return value. We might have
