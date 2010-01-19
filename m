Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449Ab0ASIkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0ASIkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821Ab0ASIkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:40:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab0ASIkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:40:02 -0500
Message-ID: <4B556F66.3070402@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 16:37:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3 v2] perf_event: fix race in perf_swevent_get_recursion_context()
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B54662B.4050109@cn.fujitsu.com>
In-Reply-To: <4B54662B.4050109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It only disable preemption in perf_swevent_get_recursion_context(),
it can't avoid race of hard-irq and NMI since they are nested that
will re-enter this path and make the recursion value chaotic

In this patch, we use atomic operation to avoid it and reduce
cpu_ctx->recursion size, it also make this patch no need disable
preemption

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |   14 ++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c6f812e..8474ab0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -730,7 +730,7 @@ struct perf_cpu_context {
 	 *
 	 * task, softirq, irq, nmi context
 	 */
-	int				recursion[4];
+	unsigned long			recursion;
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index eae6ff6..77ef16e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3921,7 +3921,7 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	int rctx;
 
 	if (in_nmi())
@@ -3933,13 +3933,8 @@ int perf_swevent_get_recursion_context(void)
 	else
 		rctx = 0;
 
-	if (cpuctx->recursion[rctx]) {
-		put_cpu_var(perf_cpu_context);
+	if (test_and_set_bit(rctx, &cpuctx->recursion))
 		return -1;
-	}
-
-	cpuctx->recursion[rctx]++;
-	barrier();
 
 	return rctx;
 }
@@ -3948,9 +3943,8 @@ EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 void perf_swevent_put_recursion_context(int rctx)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	barrier();
-	cpuctx->recursion[rctx]--;
-	put_cpu_var(perf_cpu_context);
+
+	clear_bit(rctx, &cpuctx->recursion);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
-- 
1.6.1.2


