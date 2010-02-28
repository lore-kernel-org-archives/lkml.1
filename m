Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031650Ab0B1JAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 04:00:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:40419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031620Ab0B1JAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 04:00:01 -0500
Date: Sun, 28 Feb 2010 08:59:17 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267311188-16603-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267311188-16603-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make task_subsys_state() RCU-lockdep checks handle boot-time use
Message-ID: <tip-1883c79a57a5fe25309007590cccb1b2782c41b2@git.kernel.org>
Git-Commit-ID: 1883c79a57a5fe25309007590cccb1b2782c41b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 08:59:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1883c79a57a5fe25309007590cccb1b2782c41b2
Gitweb:     http://git.kernel.org/tip/1883c79a57a5fe25309007590cccb1b2782c41b2
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 27 Feb 2010 14:53:08 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 28 Feb 2010 09:17:42 +0100

rcu: Make task_subsys_state() RCU-lockdep checks handle boot-time use

It is apparently legal to invoke task_subsys_state() without RCU
protection during early boot time.  After all, there are no
concurrent tasks, so there can be no grace periods completing
concurrently.

But this does need an Acked-by from the cgroups folks.

Located-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267311188-16603-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
