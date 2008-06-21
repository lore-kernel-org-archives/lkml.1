Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYFUSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYFUSTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYFUSSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:18:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:53415 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYFUSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=W92z5XF7oIP2uJViUQTHCQVc/zOcTkJp46v8NMr/FMH94cuDAA4j5iAGElecmYh34U
         kNuNajU5TYFzSin575vwlN+vh3SIVZ7KU6PDobLq/wYwJp+FoqmKgk9sFFeEvwVKD4ZF
         TiiASG7m3BlaFp/CjH0/pHY8ekQfQMv7J/JDo=
Message-ID: <485D45D1.6010902@gmail.com>
Date: Sat, 21 Jun 2008 23:47:53 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] ftrace: freeze kprobe'd records
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let records identified as being kprobe'd be marked as "frozen". The trouble
with records which have a kprobe installed on their mcount call-site is
that they don't get updated. So if such a function which is currently being
traced gets its tracing disabled due to a new filter rule (or because it
was added to the notrace list) then it won't be updated and continue being
traced. This patch allows scanning of all frozen records during tracing to
check if they should be traced.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 366098d..3121b95 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -49,6 +49,7 @@ enum {
 	FTRACE_FL_ENABLED	= (1 << 3),
 	FTRACE_FL_NOTRACE	= (1 << 4),
 	FTRACE_FL_CONVERTED	= (1 << 5),
+	FTRACE_FL_FROZEN	= (1 << 6),
 };
 
 struct dyn_ftrace {
@@ -73,15 +74,18 @@ extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
 
+extern int skip_trace(unsigned long ip);
+
 void ftrace_disable_daemon(void);
 void ftrace_enable_daemon(void);
 
 #else
+# define skip_trace(ip)				({ 0; })
 # define ftrace_force_update()			({ 0; })
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 13cd110..0f271c4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -164,6 +164,8 @@ enum {
 };
 
 static int ftrace_filtered;
+static int tracing_on;
+static int frozen_record_count;
 
 static struct hlist_head ftrace_hash[FTRACE_HASHSIZE];
 
@@ -196,6 +198,71 @@ static int ftrace_record_suspend;
 
 static struct dyn_ftrace *ftrace_free_records;
 
+
+#ifdef CONFIG_KPROBES
+static inline void freeze_record(struct dyn_ftrace *rec)
+{
+	if (!(rec->flags & FTRACE_FL_FROZEN)) {
+		rec->flags |= FTRACE_FL_FROZEN;
+		frozen_record_count++;
+	}
+}
+
+static inline void unfreeze_record(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_FROZEN) {
+		rec->flags &= ~FTRACE_FL_FROZEN;
+		frozen_record_count--;
+	}
+}
+
+static inline int record_frozen(struct dyn_ftrace *rec)
+{
+	return rec->flags & FTRACE_FL_FROZEN;
+}
+#else
+# define freeze_record(rec)			({ 0; })
+# define unfreeze_record(rec)			({ 0; })
+# define record_frozen(rec)			({ 0; })
+#endif /* CONFIG_KPROBES */
+
+int skip_trace(unsigned long ip)
+{
+	unsigned long fl;
+	struct dyn_ftrace *rec;
+	struct hlist_node *t;
+	struct hlist_head *head;
+
+	if (frozen_record_count == 0)
+		return 0;
+
+	head = &ftrace_hash[hash_long(ip, FTRACE_HASHBITS)];
+	hlist_for_each_entry_rcu(rec, t, head, node) {
+		if (rec->ip == ip) {
+			if (record_frozen(rec)) {
+				if (rec->flags & FTRACE_FL_FAILED)
+					return 1;
+
+				if (!(rec->flags & FTRACE_FL_CONVERTED))
+					return 1;
+
+				if (!tracing_on || !ftrace_enabled)
+					return 1;
+
+				if (ftrace_filtered) {
+					fl = rec->flags & (FTRACE_FL_FILTER |
+							   FTRACE_FL_NOTRACE);
+					if (!fl || (fl & FTRACE_FL_NOTRACE))
+						return 1;
+				}
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static inline int
 ftrace_ip_in_hash(unsigned long ip, unsigned long key)
 {
@@ -435,8 +502,12 @@ static void ftrace_replace_code(int enable)
 				continue;
 
 			/* ignore updates to this record's mcount site */
-			if (get_kprobe((void *)rec->ip))
+			if (get_kprobe((void *)rec->ip)) {
+				freeze_record(rec);
 				continue;
+			} else {
+				unfreeze_record(rec);
+			}
 
 			failed = __ftrace_replace_code(rec, old, new, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
@@ -494,8 +565,11 @@ static int __ftrace_modify_code(void *data)
 		 */
 		__ftrace_update_code(NULL);
 		ftrace_replace_code(1);
-	} else if (*command & FTRACE_DISABLE_CALLS)
+		tracing_on = 1;
+	} else if (*command & FTRACE_DISABLE_CALLS) {
 		ftrace_replace_code(0);
+		tracing_on = 0;
+	}
 
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
@@ -670,7 +744,10 @@ static int __ftrace_update_code(void *ignore)
 				ftrace_del_hash(p);
 				INIT_HLIST_NODE(&p->node);
 				hlist_add_head(&p->node, &temp_list);
+				freeze_record(p);
 				continue;
+			} else {
+				unfreeze_record(p);
 			}
 
 			/* convert record (i.e, patch mcount-call with NOP) */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6e9dae7..9ade793 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -988,6 +988,9 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (unlikely(!tracer_enabled))
 		return;
 
+	if (skip_trace(ip))
+		return;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
