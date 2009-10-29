Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZJ2VFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZJ2VFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZJ2VFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZJ2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:05:23 -0400
Message-Id: <20091029210526.593603847@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 16:51:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 1/3][RFC] [PATCH 1/3] tracing: Clean up ftrace.h header and add ftrace_set_notrace() declaration
References: <20091029205151.852744305@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Clean-up-ftrace.h-header-and-add-ftrace_set_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ftrace_set_notrace() declaration is missing from ftrace.h. This patch
adds it. I also noticed that the #else portion uses macros instead of
inlines, so those are updated as well.

The unregister_ftrace_command() in the #else side had an incorrect
prototype and is now fixed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..5d31e93 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -158,6 +158,7 @@ struct dyn_ftrace {
 
 int ftrace_force_update(void);
 void ftrace_set_filter(unsigned char *buf, int len, int reset);
+void ftrace_set_notrace(unsigned char *buf, int len, int reset);
 
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
@@ -236,17 +237,26 @@ extern int skip_trace(unsigned long ip);
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
 #else
-# define skip_trace(ip)				({ 0; })
-# define ftrace_force_update()			({ 0; })
-# define ftrace_set_filter(buf, len, reset)	do { } while (0)
-# define ftrace_disable_daemon()		do { } while (0)
-# define ftrace_enable_daemon()			do { } while (0)
+static inline int skip_trace(unsigned long ip)
+{
+	return 0;
+}
+static inline ftrace_force_update(void)
+{
+	return 0;
+}
+static inline void ftrace_disable_daemon(void) { }
+static inline void ftrace_enable_daemon(void) { }
+static inline void
+ftrace_set_filter(unsigned char *buf, int len, int reset) { }
+static inline void
+ftrace_set_notrace(unsigned char *buf, int len, int reset) { }
 static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
 }
-static inline int unregister_ftrace_command(char *cmd_name)
+static inline int unregister_ftrace_command(struct ftrace_func_command *cmd);
 {
 	return -EINVAL;
 }
-- 
1.6.3.3


