Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZHQVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZHQVjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZHQVjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:39:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbZHQVjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:39:45 -0400
Date: Mon, 17 Aug 2009 23:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090817213934.GA6551@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf record: Fix typo in pid_synthesize_comm_event

Carlos R. Mafra (1):
      perf: Rename perf-examples.txt to examples.txt

Paul Mackerras (1):
      perf_counter: Check task on counter read IPI


 kernel/perf_counter.c                              |   11 +++++++++++
 .../{perf-examples.txt => examples.txt}            |    0
 tools/perf/builtin-record.c                        |    2 +-
 3 files changed, 12 insertions(+), 1 deletions(-)
 rename tools/perf/Documentation/{perf-examples.txt => examples.txt} (100%)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 534e20d..b8fe739 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1503,10 +1503,21 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
  */
 static void __perf_counter_read(void *info)
 {
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
 
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu.  If not it has been
+	 * scheduled out before the smp call arrived.  In that case
+	 * counter->count would have been updated to a recent sample
+	 * when the counter was scheduled out.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
 	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
diff --git a/tools/perf/Documentation/perf-examples.txt b/tools/perf/Documentation/examples.txt
similarity index 100%
rename from tools/perf/Documentation/perf-examples.txt
rename to tools/perf/Documentation/examples.txt
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3d051b9..89a5ddc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -219,7 +219,7 @@ static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
 	fp = fopen(filename, "r");
-	if (fd == NULL) {
+	if (fp == NULL) {
 		/*
 		 * We raced with a task exiting - just return:
 		 */
