Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZJCCbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZJCCbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZJCCbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:31:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:7190 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZJCCbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WyxxjVLDlUQ1fGUA7nFHliarFraPFFofgEDHv2XmXCu8YKDVfSEvWWzxq7arnvwpaV
         VPNuLni1N3Di1pl0OZVH++yloyKRj64S2aJ3X9O+rSs08Us7V2+C9J+uThvIThcsk1Xg
         JdfExa+Rjgl6pUD2km3tehH64873gCmhCpbyo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] tracing/ftrace: Fix to check create_event_dir() when adding new events
Date: Sat,  3 Oct 2009 04:31:31 +0200
Message-Id: <1254537091-4993-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
References: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

