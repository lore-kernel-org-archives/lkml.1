Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZAVUVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZAVUVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZAVUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:21:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZAVUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:21:11 -0500
Message-Id: <20090122202109.783570330@goodmis.org>
References: <20090122202030.210768976@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 15:20:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] trace: fix logic to start/stop counting
Content-Disposition: inline; filename=0002-trace-fix-logic-to-start-stop-counting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The logic in the tracing_start/stop code prevents the WARN_ON
from ever detecting if a start/stop pair was mismatched.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 757ae6f..2129ab9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -610,13 +610,12 @@ void tracing_start(void)
 		return;
 
 	spin_lock_irqsave(&tracing_start_lock, flags);
-	if (--trace_stop_count)
-		goto out;
-
-	if (trace_stop_count < 0) {
-		/* Someone screwed up their debugging */
-		WARN_ON_ONCE(1);
-		trace_stop_count = 0;
+	if (--trace_stop_count) {
+		if (trace_stop_count < 0) {
+			/* Someone screwed up their debugging */
+			WARN_ON_ONCE(1);
+			trace_stop_count = 0;
+		}
 		goto out;
 	}
 
-- 
1.5.6.5

-- 
