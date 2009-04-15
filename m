Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZDOShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZDOShm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZDOSgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:36:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60236 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZDOSgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:36:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] RCU: Don't try and predeclare inline funcs as it upsets
	some versions of gcc
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 15 Apr 2009 19:35:01 +0100
Message-ID: <20090415183501.11029.81607.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
References: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try and predeclare inline funcs like this:

	static inline void wait_migrated_callbacks(void)
	...
	static void _rcu_barrier(enum rcu_barrier type)
	{
		...
		wait_migrated_callbacks();
	}
	...
	static inline void wait_migrated_callbacks(void)
	{
		wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
	}

as it upsets some versions of gcc under some circumstances:

	kernel/rcupdate.c: In function `_rcu_barrier':
	kernel/rcupdate.c:125: sorry, unimplemented: inlining failed in call to 'wait_migrated_callbacks': function body not available
	kernel/rcupdate.c:152: sorry, unimplemented: called from here

This can be dealt with by simply putting the static variables (rcu_migrate_*)
at the top, and moving the implementation of the function up so that it
replaces its forward declaration.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 kernel/rcupdate.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2c7b845..a967c9f 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -58,6 +58,10 @@ static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
 int rcu_scheduler_active __read_mostly;
 
+static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
+static struct rcu_head rcu_migrate_head[3];
+static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
@@ -122,7 +126,10 @@ static void rcu_barrier_func(void *type)
 	}
 }
 
-static inline void wait_migrated_callbacks(void);
+static inline void wait_migrated_callbacks(void)
+{
+	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
+}
 
 /*
  * Orchestrate the specified type of RCU barrier, waiting for all
@@ -179,21 +186,12 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
-static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
-static struct rcu_head rcu_migrate_head[3];
-static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
-
 static void rcu_migrate_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_migrate_type_count))
 		wake_up(&rcu_migrate_wq);
 }
 
-static inline void wait_migrated_callbacks(void)
-{
-	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
-}
-
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {

