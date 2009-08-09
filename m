Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZHILNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZHILNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZHILNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:40982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZHILNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:13:14 -0400
Date: Sun, 9 Aug 2009 11:12:40 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090809024235.GA10146@nowhere>
References: <20090809024235.GA10146@nowhere>
Subject: [tip:perfcounters/urgent] perf tools: callchain: Fix bad rounding of minimum rate
Message-ID: <tip-c0a8865e32c8d1a562db38e06ef31ef23282f646@git.kernel.org>
Git-Commit-ID: c0a8865e32c8d1a562db38e06ef31ef23282f646
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:12:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0a8865e32c8d1a562db38e06ef31ef23282f646
Gitweb:     http://git.kernel.org/tip/c0a8865e32c8d1a562db38e06ef31ef23282f646
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 9 Aug 2009 04:19:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 13:07:46 +0200

perf tools: callchain: Fix bad rounding of minimum rate

Sometimes we get callchain branches that have a rate under the
limit given by the user.

Say you launched:

 perf record -f -g -a ./hackbench 10
 perf report -g fractal,10.0

And you got:

2.33%       hackbench  [kernel]                  [k] _spin_lock_irqsave
                |
                |--78.57%-- remove_wait_queue
                |          poll_freewait
                |          do_sys_poll
                |          sys_poll
                |          sysenter_dispatch
                |          0xf7ffa430
                |          0x1ffadea3c
                |
                |--7.14%-- __up_read
                |          up_read
                |          do_page_fault
                |          page_fault
                |          0xf7ffa430
                |          0xa0df710000000a
                ...

It is abnormal to get a 7.14% branch whereas we passed a 10%
filter.

The problem is that we round down the minimum threshold. This
happens mostly when we have very low number of events. If the
total amount of your branch is 4 and you have a subranch of 3
events, filtering to 90% will be computed like follows:

  limit = 4 * 0.9;

The result is about 3.6, but the cast to integer will round
down to 3. It means that our filter is actually of 75%

We must then explicitly round up the minimum threshold.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com
Cc: peterz@infradead.org
Cc: efault@gmx.de
LKML-Reference: <20090809024235.GA10146@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index a8e67aa..0114734 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <errno.h>
+#include <math.h>
 
 #include "callchain.h"
 
@@ -112,7 +113,7 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
-	min_hit = node->children_hit * min_percent / 100.0;
+	min_hit = ceil(node->children_hit * min_percent);
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
@@ -126,7 +127,7 @@ static void
 sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
 		     u64 min_hit __used, struct callchain_param *param)
 {
-	__sort_chain_graph_rel(chain_root, param->min_percent);
+	__sort_chain_graph_rel(chain_root, param->min_percent / 100.0);
 	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
