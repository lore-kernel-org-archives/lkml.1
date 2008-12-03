Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYLCQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYLCQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYLCQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:05:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYLCQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:05:49 -0500
Message-Id: <20081203160547.506806159@goodmis.org>
References: <20081203160448.972919719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Dec 2008 11:04:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] trace: fix output of stack trace
Content-Disposition: inline; filename=0001-trace-fix-output-of-stack-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to output of stack trace

If a function is not found in the stack of the stack tracer, the
number printed is quite strange. This fixes the algorithm to handle
missing functions better.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stack.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 06a1611..0b863f2 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -78,6 +78,7 @@ static inline void check_stack(void)
 	 * on a new max, so it is far from a fast path.
 	 */
 	while (i < max_stack_trace.nr_entries) {
+		int found = 0;
 
 		stack_dump_index[i] = this_size;
 		p = start;
@@ -86,12 +87,14 @@ static inline void check_stack(void)
 			if (*p == stack_dump_trace[i]) {
 				this_size = stack_dump_index[i++] =
 					(top - p) * sizeof(unsigned long);
+				found = 1;
 				/* Start the search from here */
 				start = p + 1;
 			}
 		}
 
-		i++;
+		if (!found)
+			i++;
 	}
 
  out:
-- 
1.5.6.5

-- 
