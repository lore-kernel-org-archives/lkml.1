Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZFVVit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZFVVit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZFVVil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:38:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbZFVVik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:38:40 -0400
Subject: [PATCH -tip] perf_counter util: Added Hardware cache event in perf
 list
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 03:08:08 +0530
Message-Id: <1245706688.6167.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


./perf list

List of pre-defined events (to be used in -e):

  cpu-cycles OR cycles                          [Hardware event]
  instructions                                  [Hardware event]
  cache-references                              [Hardware event]
  cache-misses                                  [Hardware event]
  branch-instructions OR branches               [Hardware event]
  branch-misses                                 [Hardware event]
  bus-cycles                                    [Hardware event]

  cpu-clock                                     [Software event]
  task-clock                                    [Software event]
  page-faults OR faults                         [Software event]
  minor-faults                                  [Software event]
  major-faults                                  [Software event]
  context-switches OR cs                        [Software event]
  cpu-migrations OR migrations                  [Software event]

  L1-data-Cache-Load-Reference                  [Hardware cache event]
  L1-data-Cache-Load-Miss                       [Hardware cache event]
  L1-data-Cache-Store-Reference                 [Hardware cache event]
  L1-data-Cache-Store-Miss                      [Hardware cache event]
  L1-data-Cache-Prefetch-Reference              [Hardware cache event]
  L1-data-Cache-Prefetch-Miss                   [Hardware cache event]
  L1-instruction-Cache-Load-Reference           [Hardware cache event]
  L1-instruction-Cache-Load-Miss                [Hardware cache event]
  L1-instruction-Cache-Store-Reference          [Hardware cache event]
  L1-instruction-Cache-Store-Miss               [Hardware cache event]
  L1-instruction-Cache-Prefetch-Reference       [Hardware cache event]
  L1-instruction-Cache-Prefetch-Miss            [Hardware cache event]
  L2-Cache-Load-Reference                       [Hardware cache event]
  L2-Cache-Load-Miss                            [Hardware cache event]
  L2-Cache-Store-Reference                      [Hardware cache event]
  L2-Cache-Store-Miss                           [Hardware cache event]
  L2-Cache-Prefetch-Reference                   [Hardware cache event]
  L2-Cache-Prefetch-Miss                        [Hardware cache event]
  Data-TLB-Cache-Load-Reference                 [Hardware cache event]
  Data-TLB-Cache-Load-Miss                      [Hardware cache event]
  Data-TLB-Cache-Store-Reference                [Hardware cache event]
  Data-TLB-Cache-Store-Miss                     [Hardware cache event]
  Data-TLB-Cache-Prefetch-Reference             [Hardware cache event]
  Data-TLB-Cache-Prefetch-Miss                  [Hardware cache event]
  Instruction-TLB-Cache-Load-Reference          [Hardware cache event]
  Instruction-TLB-Cache-Load-Miss               [Hardware cache event]
  Instruction-TLB-Cache-Store-Reference         [Hardware cache event]
  Instruction-TLB-Cache-Store-Miss              [Hardware cache event]
  Instruction-TLB-Cache-Prefetch-Reference      [Hardware cache event]
  Instruction-TLB-Cache-Prefetch-Miss           [Hardware cache event]
  Branch-Cache-Load-Reference                   [Hardware cache event]
  Branch-Cache-Load-Miss                        [Hardware cache event]
  Branch-Cache-Store-Reference                  [Hardware cache event]
  Branch-Cache-Store-Miss                       [Hardware cache event]
  Branch-Cache-Prefetch-Reference               [Hardware cache event]
  Branch-Cache-Prefetch-Miss                    [Hardware cache event]

  rNNN                                          [raw hardware event descriptor]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 06af2fa..6e5ffa0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -296,8 +296,8 @@ static const char * const event_type_descriptors[] = {
 void print_events(void)
 {
 	struct event_symbol *syms = event_symbols;
-	unsigned int i, type, prev_type = -1;
-	char name[40];
+	unsigned int i, type, op, prev_type = -1;
+	char name[50];
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
@@ -314,14 +314,28 @@ void print_events(void)
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
+		fprintf(stderr, "  %-45s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				sprintf(name, "%s-Cache-%s-%s",
+					hw_cache[type][0],
+					hw_cache_op[op][0],
+					hw_cache_result[i][0]);
+				fprintf(stderr, "  %-45s [%s]\n", name,
+					event_type_descriptors[4]);
+			}
+		}
+	}
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, "  %-45s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
-- 
1.6.0.6



