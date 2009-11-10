Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZKJW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZKJW2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbZKJW2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:28:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:34943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306AbZKJW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:28:30 -0500
Date: Tue, 10 Nov 2009 22:28:13 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12578890423298-git-send-email->
References: <12578890423298-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Rename dynticks_completed to completed_fqs
Message-ID: <tip-4bcfe055030d9e953945def3864f7e6997b27782@git.kernel.org>
Git-Commit-ID: 4bcfe055030d9e953945def3864f7e6997b27782
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bcfe055030d9e953945def3864f7e6997b27782
Gitweb:     http://git.kernel.org/tip/4bcfe055030d9e953945def3864f7e6997b27782
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 10 Nov 2009 13:37:21 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 22:48:50 +0100

rcu: Rename dynticks_completed to completed_fqs

This field is used whether or not CONFIG_NO_HZ is set, so the
old name of ->dynticks_completed is quite misleading.

Change to ->completed_fqs, given that it the value that
force_quiescent_state() is trying to drive the ->completed field
away from.

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
LKML-Reference: <12578890423298-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    4 ++--
 kernel/rcutree.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ec007dd..26fc780 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -187,7 +187,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
  */
 static void dyntick_record_completed(struct rcu_state *rsp, long comp)
 {
-	rsp->dynticks_completed = comp;
+	rsp->completed_fqs = comp;
 }
 
 #ifdef CONFIG_SMP
@@ -197,7 +197,7 @@ static void dyntick_record_completed(struct rcu_state *rsp, long comp)
  */
 static long dyntick_recall_completed(struct rcu_state *rsp)
 {
-	return rsp->dynticks_completed;
+	return rsp->completed_fqs;
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index ddb79ec..17a28a0 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -264,6 +264,8 @@ struct rcu_state {
 	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
+	long	completed_fqs;			/* Value of completed @ snap. */
+						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -278,8 +280,6 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	long dynticks_completed;		/* Value of completed @ snap. */
-						/*  Protected by fqslock. */
 };
 
 #ifdef RCU_TREE_NONCORE
