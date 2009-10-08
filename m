Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZJHBUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZJHBUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZJHBUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:20:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZJHBUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:20:04 -0400
Message-Id: <20091008011806.120041764@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 21:17:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       stable@kernel.org
Subject: [PATCH 2/3] [PATCH 2/3] tracing: correct module boundaries for ftrace_release
References: <20091008011711.701283454@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-correct-module-boundaries-for-ftrace_release.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jolsa@redhat.com <jolsa@redhat.com>

When the module is about the unload we release its call records.
The ftrace_release function was given wrong values representing
the module core boundaries, thus not releasing its call records.

Plus making ftrace_release function module specific.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1254934835-363-3-git-send-email-jolsa@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    2 +-
 kernel/trace/ftrace.c  |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index cd3d2ab..0b4f97d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -241,7 +241,7 @@ extern void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
-static inline void ftrace_release(void *start, unsigned long size) { }
+static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 46592fe..c701476 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2658,19 +2658,17 @@ static int ftrace_convert_nops(struct module *mod,
 }
 
 #ifdef CONFIG_MODULES
-void ftrace_release(void *start, void *end)
+void ftrace_release_mod(struct module *mod)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
-	unsigned long s = (unsigned long)start;
-	unsigned long e = (unsigned long)end;
 
-	if (ftrace_disabled || !start || start == end)
+	if (ftrace_disabled)
 		return;
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e)) {
+		if (within_module_core(rec->ip, mod)) {
 			/*
 			 * rec->ip is changed in ftrace_free_rec()
 			 * It should not between s and e if record was freed.
@@ -2702,9 +2700,7 @@ static int ftrace_module_notify(struct notifier_block *self,
 				   mod->num_ftrace_callsites);
 		break;
 	case MODULE_STATE_GOING:
-		ftrace_release(mod->ftrace_callsites,
-			       mod->ftrace_callsites +
-			       mod->num_ftrace_callsites);
+		ftrace_release_mod(mod);
 		break;
 	}
 
-- 
1.6.3.3


