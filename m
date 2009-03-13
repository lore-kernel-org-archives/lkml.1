Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZCMJxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZCMJxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZCMJwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:52:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZCMJwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:52:54 -0400
Message-ID: <49BA2C9F.8020009@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 17:51:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftace: remove struct list_head in struct dyn_ftrace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: save memory

The struct dyn_ftrace table is very large, this patch will save about
50%

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e1583f2..4dc32c8 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -145,7 +145,6 @@ enum {
 };
 
 struct dyn_ftrace {
-	struct list_head	list;
 	unsigned long		ip; /* address of mcount call-site */
 	unsigned long		flags;
 	struct dyn_arch_ftrace	arch;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d33d306..40eaaae 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -272,7 +272,7 @@ enum {
 
 static int ftrace_filtered;
 
-static LIST_HEAD(ftrace_new_addrs);
+static struct dyn_ftrace *ftrace_new_addrs;
 
 static DEFINE_MUTEX(ftrace_regex_lock);
 
@@ -408,8 +408,8 @@ ftrace_record_ip(unsigned long ip)
 		return NULL;
 
 	rec->ip = ip;
-
-	list_add(&rec->list, &ftrace_new_addrs);
+	rec->flags = (unsigned long)ftrace_new_addrs;
+	ftrace_new_addrs = rec;
 
 	return rec;
 }
@@ -714,19 +714,21 @@ unsigned long		ftrace_update_tot_cnt;
 
 static int ftrace_update_code(struct module *mod)
 {
-	struct dyn_ftrace *p, *t;
+	struct dyn_ftrace *p;
 	cycle_t start, stop;
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
 
-	list_for_each_entry_safe(p, t, &ftrace_new_addrs, list) {
+	while (ftrace_new_addrs) {
 
 		/* If something went wrong, bail without enabling anything */
 		if (unlikely(ftrace_disabled))
 			return -1;
 
-		list_del_init(&p->list);
+		p = ftrace_new_addrs;
+		ftrace_new_addrs = (struct dyn_ftrace *)p->flags;
+		p->flags = 0L;
 
 		/* convert record (i.e, patch mcount-call with NOP) */
 		if (ftrace_code_disable(mod, p)) {


