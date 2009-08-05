Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZHESlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZHESlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZHESlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:41:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:47309 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZHESlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:41:12 -0400
Subject: [PATCH] ftrace: fix perf-tracepoint OOPS
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Chris Mason <chris.mason@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 20:41:04 +0200
Message-Id: <1249497664.5890.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all tracepoints are created equal, in specific the ftrace
tracepoints are created with TRACE_EVENT_FORMAT() which does not
generate the needed bits to tie them into perf counters.

For those events, don't create the 'id' file and fail ->profile_enable
when their ID is specified through other means.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_event_profile.c |    2 +-
 kernel/trace/trace_events.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 5b5895a..11ba5bb 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -14,7 +14,7 @@ int ftrace_profile_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id) {
+		if (event->id == event_id && event->profile_enable) {
 			ret = event->profile_enable(event);
 			break;
 		}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cdec5..e2b301d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -971,7 +971,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		entry = trace_create_file("enable", 0644, call->dir, call,
 					  enable);
 
-	if (call->id)
+	if (call->id && call->profile_enable)
 		entry = trace_create_file("id", 0444, call->dir, call,
 					  id);
 


