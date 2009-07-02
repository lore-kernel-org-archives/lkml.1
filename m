Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZGBS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZGBS6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZGBS6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:58:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZGBS6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:58:36 -0400
Date: Thu, 2 Jul 2009 18:57:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
References: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Create new chain_for_each_child() iterator
Message-ID: <tip-14f4654cbd531d48651e005cf05907c14bddb193@git.kernel.org>
Git-Commit-ID: 14f4654cbd531d48651e005cf05907c14bddb193
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 18:57:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14f4654cbd531d48651e005cf05907c14bddb193
Gitweb:     http://git.kernel.org/tip/14f4654cbd531d48651e005cf05907c14bddb193
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 17:58:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 20:47:14 +0200

perf_counter tools: Create new chain_for_each_child() iterator

Iterating through children of a node in the callchain tree
shows something that may be quite confusing at a first glance.
The head is the children field of the parent and the list nodes
are in the brothers field of the children.

This is because the childs are linked to the parent as a list
of "brothers" using the "children" list of the parent as a
head:

  ---------------
 | Parent (head) |-------------------------------------
  ---------------                                      |
     |                                                 |
  children                                             |
     |                                                 |
  -----------               -----------                |
 | 1st child |---brother---| 2nd child |---brother-----
  -----------               -----------

This makes the following strange pattern often occuring:

 list_for_each_entry(child, &parent->children, brothers) {
        // do something with children
 }

Abstract it to chain_for_each_child() to factorize and simplify
this pattern.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 3dceabd..3c4a91f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -16,6 +16,9 @@
 
 #include "callchain.h"
 
+#define chain_for_each_child(child, parent)	\
+	list_for_each_entry(child, &parent->children, brothers)
+
 
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
@@ -46,7 +49,7 @@ void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
 {
 	struct callchain_node *child;
 
-	list_for_each_entry(child, &node->children, brothers)
+	chain_for_each_child(child, node)
 		sort_chain_to_rbtree(rb_root, child);
 
 	if (node->hit)
@@ -77,7 +80,7 @@ create_child(struct callchain_node *parent, bool inherit_children)
 		list_splice(&parent->children, &new->children);
 		INIT_LIST_HEAD(&parent->children);
 
-		list_for_each_entry(next, &new->children, brothers)
+		chain_for_each_child(next, new)
 			next->parent = new;
 	}
 	list_add_tail(&new->brothers, &parent->children);
@@ -173,7 +176,7 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
-	list_for_each_entry(rnode, &root->children, brothers) {
+	chain_for_each_child(rnode, root) {
 		unsigned int ret = __append_chain(rnode, chain, start, syms);
 
 		if (!ret)
