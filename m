Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZLNJs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZLNJs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbZLNJsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:48:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:48293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbZLNJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:48:17 -0500
Date: Mon, 14 Dec 2009 09:47:46 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC532.9010802@cn.fujitsu.com>
References: <4B1DC532.9010802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Simplify trace_option_write()
Message-ID: <tip-8d18eaaff5acaa58369be342c86e607643ce10c7@git.kernel.org>
Git-Commit-ID: 8d18eaaff5acaa58369be342c86e607643ce10c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d18eaaff5acaa58369be342c86e607643ce10c7
Gitweb:     http://git.kernel.org/tip/8d18eaaff5acaa58369be342c86e607643ce10c7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:17:06 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:28 +0100

tracing: Simplify trace_option_write()

- remove duplicate code inside trace_options_write()
- extract duplicate code in trace_options_write() and set_tracer_option()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC532.9010802@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   85 ++++++++++++++++++-------------------------------
 1 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 898409d..0507600 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2343,38 +2343,39 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int __set_tracer_option(struct tracer *trace,
+			       struct tracer_flags *tracer_flags,
+			       struct tracer_opt *opts, int neg)
+{
+	int ret;
+
+	ret = trace->set_flag(tracer_flags->val, opts->bit, !neg);
+	if (ret)
+		return ret;
+
+	if (neg)
+		tracer_flags->val &= ~opts->bit;
+	else
+		tracer_flags->val |= opts->bit;
+	return 0;
+}
+
 /* Try to assign a tracer specific option */
 static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 {
 	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
-	int ret = 0, i = 0;
-	int len;
+	int i;
 
 	for (i = 0; tracer_flags->opts[i].name; i++) {
 		opts = &tracer_flags->opts[i];
-		len = strlen(opts->name);
 
-		if (strncmp(cmp, opts->name, len) == 0) {
-			ret = trace->set_flag(tracer_flags->val,
-				opts->bit, !neg);
-			break;
-		}
+		if (strcmp(cmp, opts->name) == 0)
+			return __set_tracer_option(trace, trace->flags,
+						   opts, neg);
 	}
-	/* Not found */
-	if (!tracer_flags->opts[i].name)
-		return -EINVAL;
 
-	/* Refused to handle */
-	if (ret)
-		return ret;
-
-	if (neg)
-		tracer_flags->val &= ~opts->bit;
-	else
-		tracer_flags->val |= opts->bit;
-
-	return 0;
+	return -EINVAL;
 }
 
 static void set_tracer_flags(unsigned int mask, int enabled)
@@ -2394,7 +2395,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int ret;
 	int i;
@@ -2406,16 +2407,15 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
-	if (strncmp(buf, "no", 2) == 0) {
+	if (strncmp(cmp, "no", 2) == 0) {
 		neg = 1;
 		cmp += 2;
 	}
 
 	for (i = 0; trace_options[i]; i++) {
-		int len = strlen(trace_options[i]);
-
-		if (strncmp(cmp, trace_options[i], len) == 0) {
+		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
 			break;
 		}
@@ -3927,39 +3927,16 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	ret = 0;
-	switch (val) {
-	case 0:
-		/* do nothing if already cleared */
-		if (!(topt->flags->val & topt->opt->bit))
-			break;
-
-		mutex_lock(&trace_types_lock);
-		if (current_trace->set_flag)
-			ret = current_trace->set_flag(topt->flags->val,
-						      topt->opt->bit, 0);
-		mutex_unlock(&trace_types_lock);
-		if (ret)
-			return ret;
-		topt->flags->val &= ~topt->opt->bit;
-		break;
-	case 1:
-		/* do nothing if already set */
-		if (topt->flags->val & topt->opt->bit)
-			break;
+	if (val != 0 && val != 1)
+		return -EINVAL;
 
+	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
-		if (current_trace->set_flag)
-			ret = current_trace->set_flag(topt->flags->val,
-						      topt->opt->bit, 1);
+		ret = __set_tracer_option(current_trace, topt->flags,
+					  topt->opt, val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
 			return ret;
-		topt->flags->val |= topt->opt->bit;
-		break;
-
-	default:
-		return -EINVAL;
 	}
 
 	*ppos += cnt;
