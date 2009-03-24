Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbZCXPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbZCXPt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZCXPtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:38718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbZCXPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:49:13 -0400
Date: Tue, 24 Mar 2009 15:48:36 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C871BE.3080405@cn.fujitsu.com>
References: <49C871BE.3080405@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] tracing: use union for multi-usages field
Message-ID: <tip-ee000b7f9fe429d2470c674ccec8d344f6789e0d@git.kernel.org>
Git-Commit-ID: ee000b7f9fe429d2470c674ccec8d344f6789e0d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 15:48:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee000b7f9fe429d2470c674ccec8d344f6789e0d
Gitweb:     http://git.kernel.org/tip/ee000b7f9fe429d2470c674ccec8d344f6789e0d
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 13:38:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 16:43:12 +0100

tracing: use union for multi-usages field

Impact: cleanup

struct dyn_ftrace::ip has different usages in his lifecycle,
we use union for it. And also for struct dyn_ftrace::flags.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C871BE.3080405@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace.h |   12 +++++++++---
 kernel/trace/ftrace.c  |    8 ++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1141248..015a3d2 100644
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
index bb37711..7b8722b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -341,7 +341,7 @@ static inline int record_frozen(struct dyn_ftrace *rec)
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
-	rec->ip = (unsigned long)ftrace_free_records;
+	rec->freelist = ftrace_free_records;
 	ftrace_free_records = rec;
 	rec->flags |= FTRACE_FL_FREE;
 }
@@ -379,7 +379,7 @@ static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 			return NULL;
 		}
 
-		ftrace_free_records = (void *)rec->ip;
+		ftrace_free_records = rec->freelist;
 		memset(rec, 0, sizeof(*rec));
 		return rec;
 	}
@@ -411,7 +411,7 @@ ftrace_record_ip(unsigned long ip)
 		return NULL;
 
 	rec->ip = ip;
-	rec->flags = (unsigned long)ftrace_new_addrs;
+	rec->newlist = ftrace_new_addrs;
 	ftrace_new_addrs = rec;
 
 	return rec;
@@ -731,7 +731,7 @@ static int ftrace_update_code(struct module *mod)
 			return -1;
 
 		p = ftrace_new_addrs;
-		ftrace_new_addrs = (struct dyn_ftrace *)p->flags;
+		ftrace_new_addrs = p->newlist;
 		p->flags = 0L;
 
 		/* convert record (i.e, patch mcount-call with NOP) */
