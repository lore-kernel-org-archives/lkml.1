Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZHHLwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZHHLwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZHHLwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZHHLwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:52:41 -0400
Date: Sat, 8 Aug 2009 11:52:03 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249690585-9145-4-git-send-email-fweisbec@gmail.com>
References: <1249690585-9145-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: callchain: Fix sum of percentages to be 100% by displaying amount of ignored chains in fractal mode
Message-ID: <tip-84fce09c6b21ef675de079a724c13a205c89520b@git.kernel.org>
Git-Commit-ID: 84fce09c6b21ef675de079a724c13a205c89520b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 11:52:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84fce09c6b21ef675de079a724c13a205c89520b
Gitweb:     http://git.kernel.org/tip/84fce09c6b21ef675de079a724c13a205c89520b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 02:16:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 13:49:21 +0200

perf tools: callchain: Fix sum of percentages to be 100% by displaying amount of ignored chains in fractal mode

When we filter the callchains below a given percentage, we
ignore them and the end result only shows entries that have an
upper percentage than the filter threshold.

It seems to users then that we have an imbalance in the
percentage, as if the sum inside a profiled branch doesn't
reach 100%.

Since in the past there have been real perf report bugs that
showed the same sypmtom, it would be nice to assure the user
that the data is perfect and trustable and it all sums up to
100.00%.

So fix this by displaying the remaining hits that have been
filtered but without more detail than their amount in each
branches. Example while filtering below 50%:

7.73%  [k] delay_tsc
                |
                |--98.22%-- __const_udelay
                |          |
                |          |--86.37%-- ath5k_hw_register_timeout
                |          |          ath5k_hw_noise_floor_calibration
                |          |          ath5k_hw_reset
                |          |          ath5k_reset
                |          |          ath5k_config
                |          |          ieee80211_hw_config
                |          |          |
                |          |          |--88.53%-- ieee80211_scan_work
                |          |          |          worker_thread
                |          |          |          kthread
                |          |          |          child_rip
                |          |           --11.47%-- [...]
                |           --13.63%-- [...]
                 --1.78%-- [...]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1249690585-9145-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   47 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c4a8e10..99274ce 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -891,6 +891,21 @@ ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
 	return ret;
 }
 
+static struct symbol *rem_sq_bracket;
+static struct callchain_list rem_hits;
+
+static void init_rem_hits(void)
+{
+	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
+	if (!rem_sq_bracket) {
+		fprintf(stderr, "Not enough memory to display remaining hits\n");
+		return;
+	}
+
+	strcpy(rem_sq_bracket->name, "[...]");
+	rem_hits.sym = rem_sq_bracket;
+}
+
 static size_t
 callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			u64 total_samples, int depth, int depth_mask)
@@ -900,6 +915,7 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	struct callchain_list *chain;
 	int new_depth_mask = depth_mask;
 	u64 new_total;
+	u64 remaining;
 	size_t ret = 0;
 	int i;
 
@@ -908,17 +924,25 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	else
 		new_total = total_samples;
 
+	remaining = new_total;
+
 	node = rb_first(&self->rb_root);
 	while (node) {
+		u64 cumul;
+
 		child = rb_entry(node, struct callchain_node, rb_node);
+		cumul = cumul_hits(child);
+		remaining -= cumul;
 
 		/*
 		 * The depth mask manages the output of pipes that show
 		 * the depth. We don't want to keep the pipes of the current
-		 * level for the last child of this depth
+		 * level for the last child of this depth.
+		 * Except if we have remaining filtered hits. They will
+		 * supersede the last child
 		 */
 		next = rb_next(node);
-		if (!next)
+		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
 			new_depth_mask &= ~(1 << (depth - 1));
 
 		/*
@@ -933,7 +957,7 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
 						      new_total,
-						      cumul_hits(child));
+						      cumul);
 		}
 		ret += callchain__fprintf_graph(fp, child, new_total,
 						depth + 1,
@@ -941,6 +965,19 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		node = next;
 	}
 
+	if (callchain_param.mode == CHAIN_GRAPH_REL &&
+		remaining && remaining != new_total) {
+
+		if (!rem_sq_bracket)
+			return ret;
+
+		new_depth_mask &= ~(1 << (depth - 1));
+
+		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
+					      new_depth_mask, 0, new_total,
+					      remaining);
+	}
+
 	return ret;
 }
 
@@ -1361,6 +1398,8 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	unsigned int width;
 	char *col_width = col_width_list_str;
 
+	init_rem_hits();
+
 	fprintf(fp, "# Samples: %Ld\n", (u64)total_samples);
 	fprintf(fp, "#\n");
 
@@ -1432,6 +1471,8 @@ print_entries:
 	}
 	fprintf(fp, "\n");
 
+	free(rem_sq_bracket);
+
 	return ret;
 }
 
