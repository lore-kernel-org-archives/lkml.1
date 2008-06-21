Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYFUSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYFUSVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYFUSUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:20:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:48896 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYFUSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=lpnf+HeaG8TSfH3JyyC3nwS5KvWSjro/SmsbYyXX5vrkkUHXcetn71bT/Huwss/GB1
         7CqaQK02S7DB7szauHGofbgfpScsFEGkaCekYWP1E4tVeb2xi9ZRJBsQ/0rvKOXof8fi
         u90FW9UHiWVWxxTO02oNuaAZpFa3UjEoaSB7A=
Message-ID: <485D466D.7000209@gmail.com>
Date: Sat, 21 Jun 2008 23:50:29 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] ftrace: avoid modifying kprobe'd records
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid modifying the mcount call-site if there is a kprobe installed on it.
These records are not marked as failed however. This allowed the filter
rules on them to remain up-to-date. Whenever the kprobe on the corresponding
record is removed, the record gets updated as normal.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1e9e5c..13cd110 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -21,6 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
+#include <linux/kprobes.h>
 #include <linux/ftrace.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
@@ -433,6 +434,10 @@ static void ftrace_replace_code(int enable)
 			if (rec->flags & FTRACE_FL_FAILED)
 				continue;
 
+			/* ignore updates to this record's mcount site */
+			if (get_kprobe((void *)rec->ip))
+				continue;
+
 			failed = __ftrace_replace_code(rec, old, new, enable);
 			if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
 				rec->flags |= FTRACE_FL_FAILED;
@@ -622,11 +627,11 @@ unsigned long		ftrace_update_tot_cnt;
 
 static int __ftrace_update_code(void *ignore)
 {
+	int i, save_ftrace_enabled;
+	cycle_t start, stop;
 	struct dyn_ftrace *p;
 	struct hlist_node *t, *n;
-	int save_ftrace_enabled;
-	cycle_t start, stop;
-	int i;
+	struct hlist_head *head, temp_list;
 
 	/* Don't be recording funcs now */
 	ftrace_record_suspend++;
@@ -638,8 +643,11 @@ static int __ftrace_update_code(void *ignore)
 
 	/* No locks needed, the machine is stopped! */
 	for (i = 0; i < FTRACE_HASHSIZE; i++) {
+		INIT_HLIST_HEAD(&temp_list);
+		head = &ftrace_hash[i];
+
 		/* all CPUS are stopped, we are safe to modify code */
-		hlist_for_each_entry_safe(p, t, n, &ftrace_hash[i], node) {
+		hlist_for_each_entry_safe(p, t, n, head, node) {
 			/* Skip over failed records which have not been
 			 * freed. */
 			if (p->flags & FTRACE_FL_FAILED)
@@ -653,6 +661,19 @@ static int __ftrace_update_code(void *ignore)
 			if (p->flags & (FTRACE_FL_CONVERTED))
 				break;
 
+			/* Ignore updates to this record's mcount site.
+			 * Reintroduce this record at the head of this
+			 * bucket to attempt to "convert" it again if
+			 * the kprobe on it is unregistered before the
+			 * next run. */
+			if (get_kprobe((void *)p->ip)) {
+				ftrace_del_hash(p);
+				INIT_HLIST_NODE(&p->node);
+				hlist_add_head(&p->node, &temp_list);
+				continue;
+			}
+
+			/* convert record (i.e, patch mcount-call with NOP) */
 			if (ftrace_code_disable(p)) {
 				p->flags |= FTRACE_FL_CONVERTED;
 				ftrace_update_cnt++;
@@ -664,6 +685,12 @@ static int __ftrace_update_code(void *ignore)
 				}
 			}
 		}
+
+		hlist_for_each_entry_safe(p, t, n, &temp_list, node) {
+			hlist_del(&p->node);
+			INIT_HLIST_NODE(&p->node);
+			hlist_add_head(&p->node, head);
+		}
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
