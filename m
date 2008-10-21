Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJUOsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJUOsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYJUOsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:48:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYJUOsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:48:21 -0400
Date: Tue, 21 Oct 2008 16:47:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] core fixes
Message-ID: <20081021144753.GA553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Note that the shortlog below seems to show a merge artifact - the 
following two commits are already upstream:

 3baf63a: m32r: fix build due to notify_cpu_starting() change
 463baa8: powerpc: fix linux-next build failure

this is because the merge-base of this tree is 2e532d68a2, while your 
tree that merges this is fresher.

I did not want to merge to your latest, to not create an unnecessary 
merge commit. But i could not find a way either how to generate a proper 
shortlog either. Did i do some mistake somewhere in the workflow that 
created this situation? The tree is fine, you should see this when you 
pull:

 $ git merge core-fixes-for-linus
 Merge made by recursive.
  include/linux/profile.h |    7 +++++++
  kernel/rcupdate.c       |   19 ++++++++++---------
  2 files changed, 17 insertions(+), 9 deletions(-)

 $ gll linus..
 1420dfb: Merge branch 'core-fixes-for-linus' into tmp.tmp
 5f86515: rcupdate: fix bug of rcu_barrier*()
 8cf7d36: profiling: fix !procfs build
 52f4f32: Merge branch 'linus' into core/urgent

i think it's that 52f4f32 merge commit that created this?

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      m32r: fix build due to notify_cpu_starting() change
      profiling: fix !procfs build

Lai Jiangshan (1):
      rcupdate: fix bug of rcu_barrier*()

Stephen Rothwell (1):
      powerpc: fix linux-next build failure


 arch/m32r/kernel/smpboot.c      |    1 +
 arch/powerpc/include/asm/page.h |    6 +++++-
 include/linux/profile.h         |    7 +++++++
 kernel/rcupdate.c               |   19 ++++++++++---------
 4 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index fc29948..39cb6da 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -40,6 +40,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 64e1445..5ac51e6 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -10,9 +10,13 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#else
+#include <asm/types.h>
+#endif
 #include <asm/asm-compat.h>
 #include <asm/kdump.h>
-#include <asm/types.h>
 
 /*
  * On PPC32 page size is 4K. For PPC64 we support either 4K or 64K software
diff --git a/include/linux/profile.h b/include/linux/profile.h
index 5700450..e3eca85 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -37,7 +37,14 @@ extern int prof_on __read_mostly;
 /* init basic kernel profiler */
 int profile_init(void);
 int profile_setup(char *str);
+#ifdef CONFIG_PROC_FS
 int create_proc_profile(void);
+#else
+static inline int create_proc_profile(void)
+{
+	return 0;
+}
+#endif
 void profile_tick(int type);
 
 /*
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 467d594..ad63af8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -119,18 +119,19 @@ static void _rcu_barrier(enum rcu_barrier type)
 	/* Take cpucontrol mutex to protect against CPU hotplug */
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
-	atomic_set(&rcu_barrier_cpu_count, 0);
 	/*
-	 * The queueing of callbacks in all CPUs must be atomic with
-	 * respect to RCU, otherwise one CPU may queue a callback,
-	 * wait for a grace period, decrement barrier count and call
-	 * complete(), while other CPUs have not yet queued anything.
-	 * So, we need to make sure that grace periods cannot complete
-	 * until all the callbacks are queued.
+	 * Initialize rcu_barrier_cpu_count to 1, then invoke
+	 * rcu_barrier_func() on each CPU, so that each CPU also has
+	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
+	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
+	 * might complete its grace period before all of the other CPUs
+	 * did their increment, causing this function to return too
+	 * early.
 	 */
-	rcu_read_lock();
+	atomic_set(&rcu_barrier_cpu_count, 1);
 	on_each_cpu(rcu_barrier_func, (void *)type, 1);
-	rcu_read_unlock();
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
