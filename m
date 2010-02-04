Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0BDJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:60173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab0BDJ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:54 -0500
Date: Thu, 4 Feb 2010 09:55:55 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Remove record freezing
Message-ID: <tip-f24bb999d2b9f2950e5cac5b69bffedf73c24ea4@git.kernel.org>
Git-Commit-ID: f24bb999d2b9f2950e5cac5b69bffedf73c24ea4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:55:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f24bb999d2b9f2950e5cac5b69bffedf73c24ea4
Gitweb:     http://git.kernel.org/tip/f24bb999d2b9f2950e5cac5b69bffedf73c24ea4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 2 Feb 2010 16:49:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:36:19 +0100

ftrace: Remove record freezing

Remove record freezing. Because kprobes never puts probe on
ftrace's mcount call anymore, it doesn't need ftrace to check
whether kprobes on it.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: przemyslaw@pawelczyk.it
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    1 -
 kernel/trace/ftrace.c  |   39 ---------------------------------------
 2 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9d127ef..eb054ae 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -143,7 +143,6 @@ enum {
 	FTRACE_FL_ENABLED	= (1 << 3),
 	FTRACE_FL_NOTRACE	= (1 << 4),
 	FTRACE_FL_CONVERTED	= (1 << 5),
-	FTRACE_FL_FROZEN	= (1 << 6),
 };
 
 struct dyn_ftrace {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3d90661..1904797 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -22,7 +22,6 @@
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
-#include <linux/kprobes.h>
 #include <linux/ftrace.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
@@ -898,36 +897,6 @@ static struct dyn_ftrace *ftrace_free_records;
 		}				\
 	}
 
-#ifdef CONFIG_KPROBES
-
-static int frozen_record_count;
-
-static inline void freeze_record(struct dyn_ftrace *rec)
-{
-	if (!(rec->flags & FTRACE_FL_FROZEN)) {
-		rec->flags |= FTRACE_FL_FROZEN;
-		frozen_record_count++;
-	}
-}
-
-static inline void unfreeze_record(struct dyn_ftrace *rec)
-{
-	if (rec->flags & FTRACE_FL_FROZEN) {
-		rec->flags &= ~FTRACE_FL_FROZEN;
-		frozen_record_count--;
-	}
-}
-
-static inline int record_frozen(struct dyn_ftrace *rec)
-{
-	return rec->flags & FTRACE_FL_FROZEN;
-}
-#else
-# define freeze_record(rec)			({ 0; })
-# define unfreeze_record(rec)			({ 0; })
-# define record_frozen(rec)			({ 0; })
-#endif /* CONFIG_KPROBES */
-
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->freelist = ftrace_free_records;
@@ -1091,14 +1060,6 @@ static void ftrace_replace_code(int enable)
 		    !(rec->flags & FTRACE_FL_CONVERTED))
 			continue;
 
-		/* ignore updates to this record's mcount site */
-		if (get_kprobe((void *)rec->ip)) {
-			freeze_record(rec);
-			continue;
-		} else {
-			unfreeze_record(rec);
-		}
-
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
 			rec->flags |= FTRACE_FL_FAILED;
