Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbZDCKhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbZDCKhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763663AbZDCKgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:36:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:42879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763052AbZDCKgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:36:53 -0400
Date: Fri, 3 Apr 2009 10:36:13 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, rcu: fix rcu_tree_trace.c data structure dependencies
Message-ID: <tip-6258c4fb59e77d748f7efc2c137ad420372edd07@git.kernel.org>
Git-Commit-ID: 6258c4fb59e77d748f7efc2c137ad420372edd07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6258c4fb59e77d748f7efc2c137ad420372edd07
Gitweb:     http://git.kernel.org/tip/6258c4fb59e77d748f7efc2c137ad420372edd07
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:42:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:03 +0200

kmemtrace, rcu: fix rcu_tree_trace.c data structure dependencies

Impact: cleanup

We want to remove rcutree internals from the public rcutree.h file for
upcoming kmemtrace changes - but kernel/rcutree_trace.c depends on them.

Introduce kernel/rcutree.h for internal definitions. (Probably all
the other data types from include/linux/rcutree.h could be
moved here too - except rcu_data.)

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c       |    8 ++++----
 kernel/rcutree.h       |   10 ++++++++++
 kernel/rcutree_trace.c |    2 ++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a2015ed..7f32669 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -72,11 +72,11 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 	.n_force_qs_ngp = 0, \
 }
 
-static struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
-static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_data);
 
-static struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
-static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 /*
  * Increment the quiescent state counter.
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
new file mode 100644
index 0000000..5e872bb
--- /dev/null
+++ b/kernel/rcutree.h
@@ -0,0 +1,10 @@
+
+/*
+ * RCU implementation internal declarations:
+ */
+extern struct rcu_state rcu_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_data);
+
+extern struct rcu_state rcu_bh_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d6db3e8..4ee954f 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -43,6 +43,8 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
+#include "rcutree.h"
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
