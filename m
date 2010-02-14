Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0BNJGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:06:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab0BNJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:06:49 -0500
Date: Sun, 14 Feb 2010 10:06:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] perf fixes
Message-ID: <20100214090626.GA25137@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      perf: Fix hypervisor sample reporting

Kirill Smelkov (1):
      perf top: Fix help text alignment

Mahesh Salgaonkar (1):
      perf: Make bp_len type to u64 generic across the arch


 include/linux/hw_breakpoint.h |    2 +-
 include/linux/perf_event.h    |    6 ++----
 kernel/hw_breakpoint.c        |    2 +-
 kernel/perf_event.c           |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/event.c       |    4 ++--
 6 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 070ba06..5977b72 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -44,7 +44,7 @@ static inline int hw_breakpoint_type(struct perf_event *bp)
 	return bp->attr.bp_type;
 }
 
-static inline int hw_breakpoint_len(struct perf_event *bp)
+static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
 {
 	return bp->attr.bp_len;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8fa7187..a177698 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -211,11 +211,9 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	__u32			__reserved_2;
-
-	__u64			bp_addr;
 	__u32			bp_type;
-	__u32			bp_len;
+	__u64			bp_addr;
+	__u64			bp_len;
 };
 
 /*
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 8a5c7d5..967e661 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -360,8 +360,8 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 {
 	u64 old_addr = bp->attr.bp_addr;
+	u64 old_len = bp->attr.bp_len;
 	int old_type = bp->attr.bp_type;
-	int old_len = bp->attr.bp_len;
 	int err = 0;
 
 	perf_event_disable(bp);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d27746b..2b19297 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4580,7 +4580,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2)
+	if (attr->__reserved_1)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ddc584b..4b91d8c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -705,7 +705,7 @@ static void print_mapped_keys(void)
 		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
 
 	fprintf(stdout,
-		"\t[K]     hide kernel_symbols symbols.             \t(%s)\n",
+		"\t[K]     hide kernel_symbols symbols.     \t(%s)\n",
 		hide_kernel_symbols ? "yes" : "no");
 	fprintf(stdout,
 		"\t[U]     hide user symbols.               \t(%s)\n",
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bb0fd6d..8a9e6ba 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -295,10 +295,10 @@ void thread__find_addr_location(struct thread *self,
 	al->thread = self;
 	al->addr = addr;
 
-	if (cpumode & PERF_RECORD_MISC_KERNEL) {
+	if (cpumode == PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
 		mg = &session->kmaps;
-	} else if (cpumode & PERF_RECORD_MISC_USER)
+	} else if (cpumode == PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
 		al->level = 'H';
