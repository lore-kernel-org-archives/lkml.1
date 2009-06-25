Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZFYLqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZFYLqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZFYLqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:46:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:34111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZFYLqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:46:43 -0400
Subject: [PATCH -tip] perf_counter tools: check for valid cache operations
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 17:16:07 +0530
Message-Id: <1245930367.5308.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Made new table for cache operartion stat 'hw_cache_stat' as :
 L1I : Read and prefetch only
 ITLB and BPU : Read-only

introduce is_cache_op_valid() for cache operation validity

And checks for valid cache operations.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 06af2fa..7939a21 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -90,6 +90,34 @@ static char *hw_cache_result[][MAX_ALIASES] = {
 	{ "Miss"							},
 };
 
+#define C(x)		PERF_COUNT_HW_CACHE_##x
+#define CACHE_READ	(1 << C(OP_READ))
+#define CACHE_WRITE	(1 << C(OP_WRITE))
+#define CACHE_PREFETCH	(1 << C(OP_PREFETCH))
+#define COP(x)		(1 << x)
+
+/*
+ * cache operartion stat
+ * L1I : Read and prefetch only
+ * ITLB and BPU : Read-only
+ */
+static unsigned long hw_cache_stat[C(MAX)] = {
+ [C(L1D)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(L1I)]	= (CACHE_READ | CACHE_PREFETCH),
+ [C(LL)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(ITLB)]	= (CACHE_READ),
+ [C(BPU)]	= (CACHE_READ),
+};
+
+static int is_cache_op_valid(u8 cache_type, u8 cache_op)
+{
+	if (hw_cache_stat[cache_type] & COP(cache_op))
+		return 1;	/* valid */
+	else
+		return 0;	/* invalid */
+}
+
 char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
@@ -123,6 +151,8 @@ char *event_name(int counter)
 		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
 			return "unknown-ext-hardware-cache-result";
 
+		if (!is_cache_op_valid(cache_type, cache_op))
+			return "invalid-cache";
 		sprintf(name, "%s-Cache-%s-%ses",
 			hw_cache[cache_type][0],
 			hw_cache_op[cache_op][0],
@@ -179,6 +209,9 @@ parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 	if (cache_op == -1)
 		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
 
+	if (!is_cache_op_valid(cache_type, cache_op))
+		return -EINVAL;
+
 	cache_result = parse_aliases(str, hw_cache_result,
 					PERF_COUNT_HW_CACHE_RESULT_MAX);
 	/*
-- 
1.6.0.6



