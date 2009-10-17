Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZJQKDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZJQKDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZJQKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:03:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:36582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbZJQKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:03:38 -0400
Date: Sat, 17 Oct 2009 10:02:54 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090925182054.10157.55219.stgit@omoto>
References: <20090925182054.10157.55219.stgit@omoto>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/ftrace: Fix to check create_event_dir() when adding new events
Message-ID: <tip-88f70d7590538e427c8405a2e02ac2624847386c@git.kernel.org>
Git-Commit-ID: 88f70d7590538e427c8405a2e02ac2624847386c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:02:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88f70d7590538e427c8405a2e02ac2624847386c
Gitweb:     http://git.kernel.org/tip/88f70d7590538e427c8405a2e02ac2624847386c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 25 Sep 2009 11:20:54 -0700
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 3 Oct 2009 03:04:58 +0200

tracing/ftrace: Fix to check create_event_dir() when adding new events

Check result of event_create_dir() and add ftrace_event_call to
ftrace_events list only if it is succeeded. Thanks to Li for pointing
it out.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090925182054.10157.55219.stgit@omoto>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a4b7c9a..155b5d5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -957,12 +957,12 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 	if (!d_events)
 		return -ENOENT;
 
-	list_add(&call->list, &ftrace_events);
 	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
 				&ftrace_enable_fops, &ftrace_event_filter_fops,
 				&ftrace_event_format_fops);
-	if (ret < 0)
-		list_del(&call->list);
+	if (!ret)
+		list_add(&call->list, &ftrace_events);
+
 	return ret;
 }
 
@@ -1124,10 +1124,11 @@ static void trace_module_add_events(struct module *mod)
 				return;
 		}
 		call->mod = mod;
-		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events,
-				 &file_ops->id, &file_ops->enable,
-				 &file_ops->filter, &file_ops->format);
+		ret = event_create_dir(call, d_events,
+				       &file_ops->id, &file_ops->enable,
+				       &file_ops->filter, &file_ops->format);
+		if (!ret)
+			list_add(&call->list, &ftrace_events);
 	}
 }
 
@@ -1267,10 +1268,12 @@ static __init int event_trace_init(void)
 				continue;
 			}
 		}
-		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events, &ftrace_event_id_fops,
-				 &ftrace_enable_fops, &ftrace_event_filter_fops,
-				 &ftrace_event_format_fops);
+		ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
+				       &ftrace_enable_fops,
+				       &ftrace_event_filter_fops,
+				       &ftrace_event_format_fops);
+		if (!ret)
+			list_add(&call->list, &ftrace_events);
 	}
 
 	while (true) {
