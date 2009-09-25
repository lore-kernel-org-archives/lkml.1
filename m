Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZIYSTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZIYSTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 14:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZIYSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 14:19:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZIYSTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 14:19:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 3/3] tracing/ftrace: Fix to check
	create_event_dir() when adding new events
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Date: Fri, 25 Sep 2009 11:20:54 -0700
Message-ID: <20090925182054.10157.55219.stgit@omoto>
In-Reply-To: <20090925181952.10157.9975.stgit@omoto>
References: <20090925181952.10157.9975.stgit@omoto>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check result of create_event_dir() and add ftrace_event_call to
ftrace_events list only if it is succeeded. Thanks Li for pointing it out.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---

 kernel/trace/trace_events.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a4b7c9a..f03cda3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -957,12 +957,14 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 	if (!d_events)
 		return -ENOENT;
 
-	list_add(&call->list, &ftrace_events);
 	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
 				&ftrace_enable_fops, &ftrace_event_filter_fops,
 				&ftrace_event_format_fops);
 	if (ret < 0)
-		list_del(&call->list);
+		pr_warning("Could not create directory of trace events/%s\n",
+			   call->name);
+	else
+		list_add(&call->list, &ftrace_events);
 	return ret;
 }
 
@@ -1124,10 +1126,15 @@ static void trace_module_add_events(struct module *mod)
 				return;
 		}
 		call->mod = mod;
+		ret = event_create_dir(call, d_events,
+				       &file_ops->id, &file_ops->enable,
+				       &file_ops->filter, &file_ops->format);
+		if (ret < 0) {
+			pr_warning("Could not create directory of trace "
+				   "point events/%s\n", call->name);
+			continue;
+		}
 		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events,
-				 &file_ops->id, &file_ops->enable,
-				 &file_ops->filter, &file_ops->format);
 	}
 }
 
@@ -1267,10 +1274,16 @@ static __init int event_trace_init(void)
 				continue;
 			}
 		}
+		ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
+				       &ftrace_enable_fops,
+				       &ftrace_event_filter_fops,
+				       &ftrace_event_format_fops);
+		if (ret < 0) {
+			pr_warning("Could not create directory of trace "
+				   "point events/%s\n", call->name);
+			continue;
+		}
 		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events, &ftrace_event_id_fops,
-				 &ftrace_enable_fops, &ftrace_event_filter_fops,
-				 &ftrace_event_format_fops);
 	}
 
 	while (true) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
