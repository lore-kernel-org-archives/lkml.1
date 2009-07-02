Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZGBQF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZGBQF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZGBQFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:05:50 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:40507 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZGBQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:05:49 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 12:05:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=njvDJMuou8XAg/XPG+IUd2KQusr6tlfPGhQM+628bEVPsgbWPQnUTRf2iNclZcIFUN
         /boxez2FjgNh250Dp6yFL1r1h40wBePf1CCJbhHx0dI12YCmUfkegxY5IdnRVo2bJH9J
         v5bslWwkAkHeMPX7ixsNhiM3/c/y8CP6/CQOg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perfcounter: create new chain_for_each_child() iterator
Date: Thu,  2 Jul 2009 17:58:19 +0200
Message-Id: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iterating through children of a node in the callchain tree shows
something that may be quite confusing at a first glance. The head
is the children field of the parent and the list nodes are in the
brothers field of the children.

This is because the childs are linked to the parent as a list of
"brothers" using the "children" list of the parent as a head:

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
-- 
1.6.2.3

