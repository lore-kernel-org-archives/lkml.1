Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZCMCjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZCMCjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZCMCi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023825.294064533@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/16] tracing: protect ring_buffer_expanded with trace_types_lock
Content-Disposition: inline; filename=0002-tracing-protect-ring_buffer_expanded-with-trace_typ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: prevent races with ring_buffer_expanded

This patch places the expanding of the tracing buffer under the
protection of the trace_types_lock mutex. It is highly unlikely
that there would be any contention, but better safe than sorry.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c61ee85..04ab824 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2391,8 +2391,10 @@ int tracing_update_buffers(void)
 {
 	int ret = 0;
 
+	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
 		ret = tracing_resize_ring_buffer(trace_buf_size);
+	mutex_unlock(&trace_types_lock);
 
 	return ret;
 }
@@ -2412,6 +2414,8 @@ static int tracing_set_tracer(const char *buf)
 	struct tracer *t;
 	int ret = 0;
 
+	mutex_lock(&trace_types_lock);
+
 	if (!ring_buffer_expanded) {
 		ret = tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
@@ -2419,7 +2423,6 @@ static int tracing_set_tracer(const char *buf)
 		ret = 0;
 	}
 
-	mutex_lock(&trace_types_lock);
 	for (t = trace_types; t; t = t->next) {
 		if (strcmp(t->name, buf) == 0)
 			break;
-- 
1.6.1.3

-- 
