Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZGEJxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZGEJxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZGEJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:53:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbZGEJxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:53:03 -0400
Date: Sun, 5 Jul 2009 09:52:28 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, jens.axboe@oracle.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246772361-9960-4-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: callchains: Manage the cumul hits on the fly
Message-ID: <tip-e05b876c222178bc6abcfa9f23d8311731691046@git.kernel.org>
Git-Commit-ID: e05b876c222178bc6abcfa9f23d8311731691046
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 09:52:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e05b876c222178bc6abcfa9f23d8311731691046
Gitweb:     http://git.kernel.org/tip/e05b876c222178bc6abcfa9f23d8311731691046
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 5 Jul 2009 07:39:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jul 2009 10:30:22 +0200

perf_counter tools: callchains: Manage the cumul hits on the fly

The cumul hits are the number of hits of every childs of a node
plus the hits of the current nodes, required for percentage
computing of a branch.

Theses numbers are calculated during the sorting of the branches of
the callchain tree using a depth first postfix traversal, so that
cumulative hits are propagated in the right order.

But if we plan to implement percentages relative to the parent and not
absolute percentages (relative to the whole overhead), we need to know
the cumulative hits of the parent before computing the children
because the relative minimum acceptable number of entries (ie: minimum
rate against the cumulative hits from the parent) is the basis to
filter the children against a given rate.

Then we need to handle the cumul hits on the fly to prepare the
implementation of relative overhead rates.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246772361-9960-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c9900fe..5d244af 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -74,13 +74,11 @@ static void __sort_chain_graph(struct callchain_node *node, u64 min_hit)
 	struct callchain_node *child;
 
 	node->rb_root = RB_ROOT;
-	node->cumul_hit = node->hit;
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph(child, min_hit);
 		if (child->cumul_hit >= min_hit)
 			rb_insert_callchain(&node->rb_root, child, GRAPH);
-		node->cumul_hit += child->cumul_hit;
 	}
 }
 
@@ -159,7 +157,7 @@ add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	new = create_child(parent, false);
 	fill_node(new, chain, start, syms);
 
-	new->hit = 1;
+	new->cumul_hit = new->hit = 1;
 }
 
 /*
@@ -189,6 +187,7 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 
 	/* split the hits */
 	new->hit = parent->hit;
+	new->cumul_hit = parent->cumul_hit;
 	new->val_nr = parent->val_nr - idx_local;
 	parent->val_nr = idx_local;
 
@@ -216,10 +215,13 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
 		unsigned int ret = __append_chain(rnode, chain, start, syms);
 
 		if (!ret)
-			return;
+			goto cumul;
 	}
 	/* nothing in children, add to the current node */
 	add_child(root, chain, start, syms);
+
+cumul:
+	root->cumul_hit++;
 }
 
 static int
@@ -261,6 +263,8 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	/* we match 100% of the path, increment the hit */
 	if (i - start == root->val_nr && i == chain->nr) {
 		root->hit++;
+		root->cumul_hit++;
+
 		return 0;
 	}
 
