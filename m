Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470Ab0AMK2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0AMK2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505Ab0AMK2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:28:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:58714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab0AMK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:28:00 -0500
Date: Wed, 13 Jan 2010 10:27:11 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465501854-git-send-email->
References: <12626465501854-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make force_quiescent_state() start grace period if needed
Message-ID: <tip-46a1e34eda805501a8b32f26394faa435149f6d1@git.kernel.org>
Git-Commit-ID: 46a1e34eda805501a8b32f26394faa435149f6d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:27:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46a1e34eda805501a8b32f26394faa435149f6d1
Gitweb:     http://git.kernel.org/tip/46a1e34eda805501a8b32f26394faa435149f6d1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:09 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:05 +0100

rcu: Make force_quiescent_state() start grace period if needed

Grace periods cannot be started while force_quiescent_state() is
active.  This is OK in that the affected CPUs will try again
later, but it does induce needless grace-period delays.  This
patch causes rcu_start_gp() to record a failed attempt to start
a grace period. When force_quiescent_state() prepares to return,
it then starts the grace period if there was such a failed
attempt.

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
LKML-Reference: <12626465501854-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    8 ++++++++
 kernel/rcutree.h |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d920285..55e8f6e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -660,6 +660,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
+		if (cpu_needs_another_gp(rsp, rdp))
+			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -1239,6 +1241,12 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		break;
 	}
 	rsp->fqs_active = 0;
+	if (rsp->fqs_need_gp) {
+		spin_unlock(&rsp->fqslock); /* irqs remain disabled */
+		rsp->fqs_need_gp = 0;
+		rcu_start_gp(rsp, flags); /* releases rnp->lock */
+		return;
+	}
 	spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index edb6fae..bd5d78a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -278,6 +278,11 @@ struct rcu_state {
 						/* Force QS state. */
 	u8	fqs_active;			/* force_quiescent_state() */
 						/*  is running. */
+	u8	fqs_need_gp;			/* A CPU was prevented from */
+						/*  starting a new grace */
+						/*  period because */
+						/*  force_quiescent_state() */
+						/*  was running. */
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
 
