Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547Ab0AMK25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0AMK25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487Ab0AMK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:28:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:58773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab0AMK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:28:53 -0500
Date: Wed, 13 Jan 2010 10:28:14 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626498421830-git-send-email->
References: <12626498421830-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Give different levels of the rcu_node hierarchy distinct lockdep names
Message-ID: <tip-b6407e863934965cdc66cbc244d811ceeb6f4d77@git.kernel.org>
Git-Commit-ID: b6407e863934965cdc66cbc244d811ceeb6f4d77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:28:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6407e863934965cdc66cbc244d811ceeb6f4d77
Gitweb:     http://git.kernel.org/tip/b6407e863934965cdc66cbc244d811ceeb6f4d77
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 16:04:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:07 +0100

rcu: Give different levels of the rcu_node hierarchy distinct lockdep names

Previously, each level of the rcu_node hierarchy had the same
rather unimaginative name: "&rcu_node_class[i]".  This makes
lockdep diagnostics involving these lockdep classes less helpful
than would be nice. This patch fixes this by giving each level
of the rcu_node hierarchy a distinct name: "rcu_node_level_0",
"rcu_node_level_1", and so on. This version of the patch
includes improved diagnostics suggested by Josh Triplett and
Peter Zijlstra.

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
LKML-Reference: <12626498421830-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0a4c328..3b13d64 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1811,11 +1811,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
  */
 static void __init rcu_init_one(struct rcu_state *rsp)
 {
+	static char *buf[] = { "rcu_node_level_0",
+			       "rcu_node_level_1",
+			       "rcu_node_level_2",
+			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
 	struct rcu_node *rnp;
 
+	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
+
 	/* Initialize the level-tracking arrays. */
 
 	for (i = 1; i < NUM_RCU_LVLS; i++)
@@ -1829,7 +1835,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
 			spin_lock_init(&rnp->lock);
-			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
+			lockdep_set_class_and_name(&rnp->lock,
+						   &rcu_node_class[i], buf[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
