Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZHFE2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZHFE2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZHFE2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:28:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZHFE2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:28:44 -0400
Date: Thu, 6 Aug 2009 04:27:33 GMT
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
Message-ID: <tip-af6af30c0fcd77e621638e53ef8b176bca8bd3b4@git.kernel.org>
Git-Commit-ID: af6af30c0fcd77e621638e53ef8b176bca8bd3b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 04:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af6af30c0fcd77e621638e53ef8b176bca8bd3b4
Gitweb:     http://git.kernel.org/tip/af6af30c0fcd77e621638e53ef8b176bca8bd3b4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 5 Aug 2009 20:41:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 Aug 2009 06:26:09 +0200

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
[ v2: fix build error in the !CONFIG_EVENT_PROFILE case ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h       |    8 +++-----
 kernel/trace/trace_event_profile.c |    2 +-
 kernel/trace/trace_events.c        |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..d7cd193 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -119,11 +119,9 @@ struct ftrace_event_call {
 	void			*filter;
 	void			*mod;
 
-#ifdef CONFIG_EVENT_PROFILE
-	atomic_t	profile_count;
-	int		(*profile_enable)(struct ftrace_event_call *);
-	void		(*profile_disable)(struct ftrace_event_call *);
-#endif
+	atomic_t		profile_count;
+	int			(*profile_enable)(struct ftrace_event_call *);
+	void			(*profile_disable)(struct ftrace_event_call *);
 };
 
 #define MAX_FILTER_PRED		32
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
 
