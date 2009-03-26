Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZCZJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZCZJU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZCZJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:20:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:38220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZCZJUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:20:17 -0400
Date: Thu, 26 Mar 2009 09:18:55 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237878882.8339.61.camel@charm-linux>
References: <1237878882.8339.61.camel@charm-linux>
Subject: [tip:tracing/filters] tracing: filter fix for TRACE_EVENT_FORMAT events
Message-ID: <tip-9a8118baaeb0eaa148913bed77bf9c6335f6ca63@git.kernel.org>
Git-Commit-ID: 9a8118baaeb0eaa148913bed77bf9c6335f6ca63
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Mar 2009 09:18:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a8118baaeb0eaa148913bed77bf9c6335f6ca63
Gitweb:     http://git.kernel.org/tip/9a8118baaeb0eaa148913bed77bf9c6335f6ca63
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 26 Mar 2009 01:24:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Mar 2009 09:13:14 +0100

tracing: filter fix for TRACE_EVENT_FORMAT events

Impact: fix crash (hang) when using TRACE_EVENT_FORMAT filter files

filters are only hooked up to the tracepoint events defined using
TRACE_EVENT but not the tracers that use TRACE_EVENT_FORMAT, such
as ftrace.

Do not display the filter files at all for TRACE_EVENT_FORMAT events
for the time being.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237878882.8339.61.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d132997..64ec4d2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -680,7 +680,6 @@ static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
 	struct event_subsystem *system;
-	struct dentry *entry;
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -709,12 +708,6 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	system->preds = NULL;
 
-	entry = debugfs_create_file("filter", 0644, system->entry, system,
-				    &ftrace_subsystem_filter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/filter' entry\n", name);
-
 	return system->entry;
 }
 
@@ -770,14 +763,13 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   " events/%s\n", call->name);
 			return ret;
 		}
+		entry = debugfs_create_file("filter", 0644, call->dir, call,
+					    &ftrace_event_filter_fops);
+		if (!entry)
+			pr_warning("Could not create debugfs "
+				   "'%s/filter' entry\n", call->name);
 	}
 
-	entry = debugfs_create_file("filter", 0644, call->dir, call,
-				    &ftrace_event_filter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/filter' entry\n", call->name);
-
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
