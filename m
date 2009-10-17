Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZJQKCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZJQKCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZJQKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:02:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:36469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZJQKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:02:11 -0400
Date: Sat, 17 Oct 2009 10:01:14 GMT
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
In-Reply-To: <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
Message-ID: <tip-4fead8e46fded93cc0d432ced774d9a3a8d21bad@git.kernel.org>
Git-Commit-ID: 4fead8e46fded93cc0d432ced774d9a3a8d21bad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:01:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fead8e46fded93cc0d432ced774d9a3a8d21bad
Gitweb:     http://git.kernel.org/tip/4fead8e46fded93cc0d432ced774d9a3a8d21bad
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 14 Sep 2009 16:49:12 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:03:50 +0200

ftrace: Fix trace_remove_event_call() to lock trace_event_mutex

Lock not only event_mutex but also trace_event_mutex in
trace_remove_event_call() to protect __unregister_ftrace_event().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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
LKML-Reference: <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 83cc2c0..f85b0f1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1054,6 +1054,9 @@ static void remove_subsystem_dir(const char *name)
 	}
 }
 
+/*
+ * Must be called under locking both of event_mutex and trace_event_mutex.
+ */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	ftrace_event_enable_disable(call, 0);
@@ -1070,7 +1073,9 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
 	mutex_lock(&event_mutex);
+	down_write(&trace_event_mutex);
 	__trace_remove_event_call(call);
+	up_write(&trace_event_mutex);
 	mutex_unlock(&event_mutex);
 }
 
