Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0BBVl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:41:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0BBVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:41:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/4] ftrace: Remove record freezing
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 02 Feb 2010 16:49:25 -0500
Message-ID: <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove record freezing. Because kprobes never puts probe on
ftrace's mcount call anymore, it doesn't need ftrace to check
whether kprobes on it.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
