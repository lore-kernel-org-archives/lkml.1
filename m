Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZHYSC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZHYSC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZHYSCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:02:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZHYSCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:02:54 -0400
Date: Tue, 25 Aug 2009 20:02:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090825180244.GA31307@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      tracing: Fix too large stack usage in do_one_initcall()

Jiri Olsa (1):
      tracing: handle broken names in ftrace filter

Zhaolei (1):
      ftrace: Unify effect of writing to trace_options and option/*


 init/main.c           |    7 ++++---
 kernel/trace/ftrace.c |   17 +++++++++++------
 kernel/trace/trace.c  |   12 ++----------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/init/main.c b/init/main.c
index 2c5ade7..98e679e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -733,13 +733,14 @@ static void __init do_ctors(void)
 int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
+static char msgbuf[64];
+static struct boot_trace_call call;
+static struct boot_trace_ret ret;
+
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t calltime, delta, rettime;
-	char msgbuf[64];
-	struct boot_trace_call call;
-	struct boot_trace_ret ret;
 
 	if (initcall_debug) {
 		call.caller = task_pid_nr(current);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e1d23c..25edd5c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2278,7 +2278,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	read++;
 	cnt--;
 
-	if (!(iter->flags & ~FTRACE_ITER_CONT)) {
+	/*
+	 * If the parser haven't finished with the last write,
+	 * continue reading the user input without skipping spaces.
+	 */
+	if (!(iter->flags & FTRACE_ITER_CONT)) {
 		/* skip white space */
 		while (cnt && isspace(ch)) {
 			ret = get_user(ch, ubuf++);
@@ -2288,8 +2292,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 			cnt--;
 		}
 
+		/* only spaces were written */
 		if (isspace(ch)) {
-			file->f_pos += read;
+			*ppos += read;
 			ret = read;
 			goto out;
 		}
@@ -2319,12 +2324,12 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		if (ret)
 			goto out;
 		iter->buffer_idx = 0;
-	} else
+	} else {
 		iter->flags |= FTRACE_ITER_CONT;
+		iter->buffer[iter->buffer_idx++] = ch;
+	}
 
-
-	file->f_pos += read;
-
+	*ppos += read;
 	ret = read;
  out:
 	mutex_unlock(&ftrace_regex_lock);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c22b40f..8c35839 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3896,17 +3896,9 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	switch (val) {
-	case 0:
-		trace_flags &= ~(1 << index);
-		break;
-	case 1:
-		trace_flags |= 1 << index;
-		break;
-
-	default:
+	if (val != 0 && val != 1)
 		return -EINVAL;
-	}
+	set_tracer_flags(1 << index, val);
 
 	*ppos += cnt;
 
