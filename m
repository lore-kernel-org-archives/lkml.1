Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900Ab0B0WxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:53:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34054 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965838Ab0B0WxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:53:11 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: make task_subsys_state() RCU-lockdep checks handle boot-time use
Date: Sat, 27 Feb 2010 14:53:08 -0800
Message-Id: <1267311188-16603-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100227225240.GA16515@linux.vnet.ibm.com>
References: <20100227225240.GA16515@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is apparently legal to invoke task_subsys_state() without RCU protection
during early boot time.  After all, there are no concurrent tasks, so there
can be no grace periods completing concurrently.

But this does need an Acked-by from the cgroups folks.

Located-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c9bbcb2..a73e1ce 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -489,6 +489,7 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
+				     !rcu_scheduler_active ||
 				     cgroup_lock_is_held());
 }
 
-- 
1.6.6

