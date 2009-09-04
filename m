Return-Path: <linux-kernel-owner+w=401wt.eu-S934355AbZIDVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbZIDVmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934323AbZIDVmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:42:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:45026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277AbZIDVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gkbavre632E5nLCy6Z9BYPL6L+8+CzKAcSM2QhBu3j2G2zATRVZ3+BsKgnjK0jzw6y
         /i4M6UeWR2UzYpbYTAa5RB9kOvC3ihzk8o73lfERV5Q0raDL6Q8iUwzNVPahzQgQ9VpD
         XO6E2EIPoxcyeVeCZd5F/tDkTd6REyW3Hr+wE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing/filters: Defer pred allocation, fix memory leak
Date: Fri,  4 Sep 2009 23:42:16 +0200
Message-Id: <1252100537-7783-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
References: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.2.3

