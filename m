Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZDODQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZDODQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZDODQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:16:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZDODQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:16:07 -0400
Message-Id: <20090415031604.688830915@goodmis.org>
References: <20090415031511.128139334@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 23:15:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 1/4] tracing/events: fix compile for modules disabled
Content-Disposition: inline; filename=0001-tracing-events-fix-compile-for-modules-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: compile fix

The addition of TRACE_EVENT for modules breaks the build for when
modules are disabled. This code fixes that.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a4b1777..6591d83 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -797,6 +797,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	     (unsigned long)event < (unsigned long)end;		\
 	     event++)
 
+#ifdef CONFIG_MODULES
 static void trace_module_add_events(struct module *mod)
 {
 	struct ftrace_event_call *call, *start, *end;
@@ -840,8 +841,8 @@ static void trace_module_remove_events(struct module *mod)
 	}
 }
 
-int trace_module_notify(struct notifier_block *self,
-			unsigned long val, void *data)
+static int trace_module_notify(struct notifier_block *self,
+			       unsigned long val, void *data)
 {
 	struct module *mod = data;
 
@@ -858,6 +859,13 @@ int trace_module_notify(struct notifier_block *self,
 
 	return 0;
 }
+#else
+static int trace_module_notify(struct notifier_block *self,
+			       unsigned long val, void *data)
+{
+	return 0;
+}
+#endif /* CONFIG_MODULES */
 
 struct notifier_block trace_module_nb = {
 	.notifier_call = trace_module_notify,
-- 
1.6.2.1

-- 
