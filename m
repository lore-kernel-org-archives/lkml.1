Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZCUBdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZCUBdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 21:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZCUBdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 21:33:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbZCUBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 21:33:17 -0400
Message-ID: <49C44412.5080408@redhat.com>
Date: Fri, 20 Mar 2009 21:34:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PATCH -tip 5/5 V2] tracing: kprobe-tracer plugin supports module
 init/exit
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use register/unregister_module_*probe functions for tracing
module .init/.exit functions.

changes from v1:
 - simplify activate_handler().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 kernel/trace/trace_kprobe.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index def322f..afcfa4a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -228,6 +228,11 @@ static void free_trace_probe(struct trace_probe *tp)
 	kfree(tp);
 }

+static int activate_handler(void *offset, struct module *mod)
+{
+	return !offset;
+}
+
 static int register_trace_probe(struct trace_probe *tp)
 {
 	int ret;
@@ -236,9 +241,10 @@ static int register_trace_probe(struct trace_probe *tp)
 	list_add_tail(&tp->list, &probe_list);

 	if (probe_is_return(tp))
-		ret = register_kretprobe(&tp->rp);
+		ret = register_module_kretprobe(&tp->rp, activate_handler, 0);
 	else
-		ret = register_kprobe(&tp->kp);
+		ret = register_module_kprobe(&tp->kp, activate_handler,
+					     (void *)(tp->kp.offset));

 	if (ret) {
 		pr_warning("Probe registering error: %d\n", ret);
@@ -251,9 +257,9 @@ static int register_trace_probe(struct trace_probe *tp)
 static void unregister_trace_probe(struct trace_probe *tp)
 {
 	if (probe_is_return(tp))
-		unregister_kretprobe(&tp->rp);
+		unregister_module_kretprobe(&tp->rp);
 	else
-		unregister_kprobe(&tp->kp);
+		unregister_module_kprobe(&tp->kp);
 	list_del(&tp->list);
 }

@@ -303,7 +309,6 @@ static int create_trace_probe(int argc, char **argv)
 	} else {
 		/* a symbol specified */
 		symbol = argv[1];
-		/* TODO: support .init module functions */
 		tmp = strchr(symbol, '+');
 		if (!tmp)
 			tmp = strchr(symbol, '-');
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


