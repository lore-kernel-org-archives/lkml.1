Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZIFEhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZIFEhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZIFEhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:37:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:46898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZIFEg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:36:59 -0400
Date: Sun, 6 Sep 2009 04:36:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mhiramat@redhat.com
In-Reply-To: <4A9CB1BA.3060402@cn.fujitsu.com>
References: <4A9CB1BA.3060402@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/filters: Defer pred allocation, fix memory leak
Message-ID: <tip-c58b43218c1a04a0bcf338ea47406c759ac28e11@git.kernel.org>
Git-Commit-ID: c58b43218c1a04a0bcf338ea47406c759ac28e11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 06 Sep 2009 04:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c58b43218c1a04a0bcf338ea47406c759ac28e11
Gitweb:     http://git.kernel.org/tip/c58b43218c1a04a0bcf338ea47406c759ac28e11
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 1 Sep 2009 13:31:38 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 4 Sep 2009 23:22:33 +0200

tracing/filters: Defer pred allocation, fix memory leak

The predicates of an event and their filter structure are allocated
when we create an event filter for the first time.

These objects must be created once but each time we come with a new
filter, we overwrite such pre-existing allocation, if any.

Thus, this patch checks if the filter has already been allocated
before going ahead.

Spotted-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4A9CB1BA.3060402@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/trace/trace_events_filter.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c6b2edf..93660fb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -409,6 +409,9 @@ static int init_preds(struct ftrace_event_call *call)
 	struct filter_pred *pred;
 	int i;
 
+	if (call->filter)
+		return 0;
+
 	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (!call->filter)
 		return -ENOMEM;
@@ -447,11 +450,9 @@ static int init_subsystem_preds(struct event_subsystem *system)
 		if (strcmp(call->system, system->name) != 0)
 			continue;
 
-		if (!call->filter) {
-			err = init_preds(call);
-			if (err)
-				return err;
-		}
+		err = init_preds(call);
+		if (err)
+			return err;
 	}
 
 	return 0;
