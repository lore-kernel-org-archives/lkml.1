Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZJHNsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZJHNsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZJHNr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:47:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:34412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763AbZJHNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:47:58 -0400
Date: Thu, 8 Oct 2009 13:47:02 GMT
From: "tip-bot for jolsa@redhat.com" <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1254934835-363-3-git-send-email-jolsa@redhat.com>
References: <1254934835-363-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: correct module boundaries for ftrace_release
Message-ID: <tip-e7247a15ff3bbdab0a8b402dffa1171e5c05a8e0@git.kernel.org>
Git-Commit-ID: e7247a15ff3bbdab0a8b402dffa1171e5c05a8e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 13:47:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7247a15ff3bbdab0a8b402dffa1171e5c05a8e0
Gitweb:     http://git.kernel.org/tip/e7247a15ff3bbdab0a8b402dffa1171e5c05a8e0
Author:     jolsa@redhat.com <jolsa@redhat.com>
AuthorDate: Wed, 7 Oct 2009 19:00:35 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 7 Oct 2009 15:52:09 -0400

tracing: correct module boundaries for ftrace_release

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
 
