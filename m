Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZHHC1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZHHC1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZHHC1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:27:11 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:34906 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbZHHC0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qG+cNGaCbE0Pei0SGfb7BZw+mY3wVAA6OFiy7Q2DIr58LxFLV2Fl92AYf1d9Ja3Oej
         MFbdOp2iGGZVk+qQfTnukq4U/fbxZtIXjnteK1RKU31VDPTjnXp00mJ30NkjcQoByAuA
         qeM8aUOCG2siERe56mhs+BbHZGYKIjNvDE/MQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/4] perf tools: callchain: Display amount of ignored chains in fractal mode
Date: Sat,  8 Aug 2009 04:26:40 +0200
Message-Id: <1249698400-5441-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we filter the callchains below a given percentage, we ignore them
and the end result only shows entries that have an upper percentage
than the filter threshold. It seems then that we have an imbalance in
the percentage, as if the sum inside a profiled branch doesn't reach
100%.

Fix this by displaying the remaining hits that have been filtered but
without more detail than their amount in each branches.
Example while filtering below 50%:

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
 
-- 
1.6.2.3

