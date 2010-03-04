Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0CDQdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:33:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:48524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0CDQdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:33:17 -0500
Date: Thu, 4 Mar 2010 16:32:51 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu, menage@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, menage@google.com,
       mingo@elte.hu
In-Reply-To: <1267667418-32233-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267667418-32233-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Suppress __mpol_dup() false positive from RCU lockdep
Message-ID: <tip-99ee4ca746dda71326db7645463b4075ac1d665c@git.kernel.org>
Git-Commit-ID: 99ee4ca746dda71326db7645463b4075ac1d665c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:32:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99ee4ca746dda71326db7645463b4075ac1d665c
Gitweb:     http://git.kernel.org/tip/99ee4ca746dda71326db7645463b4075ac1d665c
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 17:50:17 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:07:34 +0100

rcu: Suppress __mpol_dup() false positive from RCU lockdep

Common code is used during task creation and after the task has
started running.  RCU protection is not needed during task
creation because no other CPU has access to the
under-construction task.  Provide the RCU protection anyway to
suppress the false positive, as there does not appear to be a
good way for the common code to recognize that the task is only
accessible to the CPU creating it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
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
LKML-Reference: <1267667418-32233-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/mempolicy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 290fb5b..3cec080 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1730,10 +1730,12 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 
 	if (!new)
 		return ERR_PTR(-ENOMEM);
+	rcu_read_lock();
 	if (current_cpuset_is_being_rebound()) {
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(old, &mems);
 	}
+	rcu_read_unlock();
 	*new = *old;
 	atomic_set(&new->refcnt, 1);
 	return new;
