Return-Path: <linux-kernel-owner+w=401wt.eu-S1750814AbXFME2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbXFME2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXFME2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:28:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35467 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbXFME2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:28:07 -0400
Date: Tue, 12 Jun 2007 21:28:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, josh@freedesktop.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] Force rcutorture tasks to spread over CPUs
Message-ID: <20070613042804.GA6132@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Of late, the scheduler seems to have decided to make things too easy for
RCU -- on some configurations, all of the rcutorture tasks end up on the
same CPU, which doesn't do a very good job of torturing RCU.  This patch
helps the scheduler spread these tasks out by forcing a 20-millisecond
burst of CPU-bound execution on each of rcutorture's tasks, which seems
to work reasonably well in practice.

My challenge for those working on the scheduler is to make this patch
unnecessary.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -urpNa -X dontdiff linux-2.6.21.4-rt13/kernel/rcutorture.c linux-2.6.21.4-rt13-rcutorturespread/kernel/rcutorture.c
--- linux-2.6.21.4-rt13/kernel/rcutorture.c	2007-06-12 09:19:02.000000000 -0700
+++ linux-2.6.21.4-rt13-rcutorturespread/kernel/rcutorture.c	2007-06-12 21:05:05.000000000 -0700
@@ -102,6 +102,8 @@ struct rcu_torture {
 };
 
 static int fullstop = 0;	/* stop generating callbacks at test end. */
+static int startwriters;	/* force load-balancing of writers. */
+static int startreaders;	/* force load-balancing of readers. */
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture *rcu_torture_current = NULL;
 static long rcu_torture_current_version = 0;
@@ -525,6 +527,8 @@ rcu_torture_writer(void *arg)
 	static DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
+	while (!startwriters)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 	current->flags |= PF_NOFREEZE;
 
@@ -565,6 +569,8 @@ rcu_torture_fakewriter(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
+	while (!startwriters)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 	current->flags |= PF_NOFREEZE;
 
@@ -596,6 +602,8 @@ rcu_torture_reader(void *arg)
 	int pipe_count;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
+	while (!startreaders)
+		barrier();	/* Force scheduler to spread over CPUs. */
 	set_user_nice(current, 19);
 	current->flags |= PF_NOFREEZE;
 
@@ -929,6 +937,8 @@ rcu_torture_init(void)
 
 	/* Start up the kthreads. */
 
+	startwriters = 0;
+	barrier();
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_writer task");
 	writer_task = kthread_run(rcu_torture_writer, NULL,
 				  "rcu_torture_writer");
@@ -956,6 +966,12 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	barrier();
+	startwriters = 1;
+	schedule_timeout_interruptible(round_jiffies_relative(HZ/50));
+
+	startreaders = 0;
+	barrier();
 	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
@@ -974,6 +990,10 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	schedule_timeout_interruptible(round_jiffies_relative(HZ/50));
+	barrier();
+	startreaders = 1;
+
 	if (stat_interval > 0) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_stats task");
 		stats_task = kthread_run(rcu_torture_stats, NULL,
