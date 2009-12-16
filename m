Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbZLPWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbZLPWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbZLPWU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:20:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763009AbZLPWUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:20:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/3] kprobe-tracer: Check new event/group name
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 16 Dec 2009 17:24:08 -0500
Message-ID: <20091216222408.14459.68790.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check new event/group name is same syntax as c symbol. In other
words, checking the name is as like as other tracepoint events.
This can prevent user to create an event with useless name (e.g.
foo|bar, foo*bar).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/trace_kprobe.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..167c189 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -282,6 +282,17 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Check the name is good for event/group */
+static int good_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return 0;
+	while (*++name != '\0')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return 0;
+	return 1;
+}
+
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -293,10 +304,11 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 					     int nargs, int is_return)
 {
 	struct trace_probe *tp;
+	int ret = -ENOMEM;
 
 	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
 	if (!tp)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(ret);
 
 	if (symbol) {
 		tp->symbol = kstrdup(symbol, GFP_KERNEL);
@@ -312,14 +324,20 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event)
+	if (!event || !good_event_name(event)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.name = kstrdup(event, GFP_KERNEL);
 	if (!tp->call.name)
 		goto error;
 
-	if (!group)
+	if (!group || !good_event_name(group)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.system = kstrdup(group, GFP_KERNEL);
 	if (!tp->call.system)
 		goto error;
@@ -330,7 +348,7 @@ error:
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 
 static void free_probe_arg(struct probe_arg *arg)
@@ -695,10 +713,10 @@ static int create_trace_probe(int argc, char **argv)
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@%s%+ld",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_%ld",
 				 is_return ? 'r' : 'p', symbol, offset);
 		else
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@0x%p",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_0x%p",
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
