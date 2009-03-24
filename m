Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZCXFk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZCXFk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZCXFkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:40:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59120 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZCXFkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:40:17 -0400
Message-ID: <49C871BE.3080405@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 13:38:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: use union for multi-usages field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

cleanup for readability.

struct dyn_ftrace::ip has different usages in his lifecycle,
we use union for it. And also for struct dyn_ftrace::flags.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index db3fed6..cdb0d3f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -145,9 +145,15 @@ enum {
 };
 
 struct dyn_ftrace {
-	unsigned long		ip; /* address of mcount call-site */
-	unsigned long		flags;
-	struct dyn_arch_ftrace	arch;
+	union {
+		unsigned long		ip; /* address of mcount call-site */
+		struct dyn_ftrace	*freelist;
+	};
+	union {
+		unsigned long		flags;
+		struct dyn_ftrace	*newlist;
+	};
+	struct dyn_arch_ftrace		arch;
 };
 
 int ftrace_force_update(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7847806..2c578c5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -339,7 +339,7 @@ static inline int record_frozen(struct dyn_ftrace *rec)
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
-	rec->ip = (unsigned long)ftrace_free_records;
+	rec->freelist = ftrace_free_records;
 	ftrace_free_records = rec;
 	rec->flags |= FTRACE_FL_FREE;
 }
@@ -377,7 +377,7 @@ static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 			return NULL;
 		}
 
-		ftrace_free_records = (void *)rec->ip;
+		ftrace_free_records = rec->freelist;
 		memset(rec, 0, sizeof(*rec));
 		return rec;
 	}
@@ -409,7 +409,7 @@ ftrace_record_ip(unsigned long ip)
 		return NULL;
 
 	rec->ip = ip;
-	rec->flags = (unsigned long)ftrace_new_addrs;
+	rec->newlist = ftrace_new_addrs;
 	ftrace_new_addrs = rec;
 
 	return rec;
@@ -729,7 +729,7 @@ static int ftrace_update_code(struct module *mod)
 			return -1;
 
 		p = ftrace_new_addrs;
-		ftrace_new_addrs = (struct dyn_ftrace *)p->flags;
+		ftrace_new_addrs = p->newlist;
 		p->flags = 0L;
 
 		/* convert record (i.e, patch mcount-call with NOP) */


