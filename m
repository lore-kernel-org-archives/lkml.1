Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHESt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHESt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHESt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:57418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZHESt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:49:26 -0400
Date: Wed, 5 Aug 2009 18:48:37 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, chris.mason@oracle.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, chris.mason@oracle.com, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249497664.5890.4.camel@laptop>
References: <1249497664.5890.4.camel@laptop>
Subject: [tip:perfcounters/urgent] ftrace: Fix perf-tracepoint OOPS
Message-ID: <tip-5fe31b14cc8eccc06311c3cc5674420a66431372@git.kernel.org>
Git-Commit-ID: 5fe31b14cc8eccc06311c3cc5674420a66431372
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 18:48:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fe31b14cc8eccc06311c3cc5674420a66431372
Gitweb:     http://git.kernel.org/tip/5fe31b14cc8eccc06311c3cc5674420a66431372
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 5 Aug 2009 20:41:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 20:45:52 +0200

ftrace: Fix perf-tracepoint OOPS

Not all tracepoints are created equal, in specific the ftrace
tracepoints are created with TRACE_EVENT_FORMAT() which does
not generate the needed bits to tie them into perf counters.

For those events, don't create the 'id' file and fail
->profile_enable when their ID is specified through other
means.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1249497664.5890.4.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 23d2972..e75276a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		entry = trace_create_file("enable", 0644, call->dir, call,
 					  enable);
 
-	if (call->id)
+	if (call->id && call->profile_enable)
 		entry = trace_create_file("id", 0444, call->dir, call,
 					  id);
 
