Return-Path: <linux-kernel-owner+w=401wt.eu-S1764760AbXLTOgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764760AbXLTOgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933996AbXLTOWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:22:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938AbXLTOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:22:43 -0500
Date: Thu, 20 Dec 2007 15:22:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler + debugging updates
Message-ID: <20071220142230.GA15638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull this scheduler+debugging git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

These patches successfully passed a couple of hundred 32-bit and 64-bit 
x86 random kernel builds and bootups. (The debug patch is fine IMO - 
i'll redo this push if it's questionable.)

Thanks!

	Ingo

------------------>
Arjan van de Ven (1):
      debug: add end-of-oops marker

Peter Zijlstra (1):
      sched: rt: account the cpu time during the tick

 panic.c    |   18 ++++++++++++++++++
 sched_rt.c |    2 ++
 2 files changed, 20 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6f6e03e..da4d6ba 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -19,6 +19,7 @@
 #include <linux/nmi.h>
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
+#include <linux/random.h>
 
 int panic_on_oops;
 int tainted;
@@ -266,12 +267,29 @@ void oops_enter(void)
 }
 
 /*
+ * 64-bit random ID for oopses:
+ */
+static u64 oops_id;
+
+static int init_oops_id(void)
+{
+	if (!oops_id)
+		get_random_bytes(&oops_id, sizeof(oops_id));
+
+	return 0;
+}
+late_initcall(init_oops_id);
+
+/*
  * Called when the architecture exits its oops handler, after printing
  * everything.
  */
 void oops_exit(void)
 {
 	do_oops_enter_exit();
+	init_oops_id();
+	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+		(unsigned long long)oops_id);
 }
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ee9c8b6..9ba3daa 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -208,6 +208,8 @@ move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
+	update_curr_rt(rq);
+
 	/*
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.
