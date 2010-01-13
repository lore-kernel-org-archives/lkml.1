Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457Ab0AMKZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0AMKZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335Ab0AMKZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:25:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:37984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0AMKZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:25:29 -0500
Date: Wed, 13 Jan 2010 10:25:01 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465501994-git-send-email->
References: <12626465501994-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Adjust force_quiescent_state() locking, step 2
Message-ID: <tip-559569acf94f538b56bd6eead80b439d6a78cdff@git.kernel.org>
Git-Commit-ID: 559569acf94f538b56bd6eead80b439d6a78cdff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:25:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  559569acf94f538b56bd6eead80b439d6a78cdff
Gitweb:     http://git.kernel.org/tip/559569acf94f538b56bd6eead80b439d6a78cdff
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:01 +0100

rcu: Adjust force_quiescent_state() locking, step 2

This patch releases rnp->lock after the end of
force_quiescent_state()'s switch statement.  This is a second
step towards prohibiting starting grace periods while
force_quiescent_state() is executing, which will reduce the
number and complexity of races that force_quiescent_state() is
involved in.

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
LKML-Reference: <12626465501994-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eae331d..d42ad30 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1219,7 +1219,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
-		spin_unlock(&rnp->lock);
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
@@ -1246,10 +1245,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
-		if (!forcenow) {
-			spin_unlock(&rnp->lock);
+		if (!forcenow)
 			break;
-		}
 		/* fall into next case. */
 
 	case RCU_FORCE_QS:
@@ -1262,14 +1259,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Leave state in case more forcing is required. */
 
-		break;
-
-	default:
-
-		spin_unlock(&rnp->lock);
-		WARN_ON_ONCE(1);
+		spin_lock(&rnp->lock);
 		break;
 	}
+	spin_unlock(&rnp->lock);
 unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
