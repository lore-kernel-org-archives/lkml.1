Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZLGHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZLGHnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZLGHnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:43:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758754AbZLGHnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:43:39 -0500
Message-ID: <4B1CB217.1030702@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:43:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/13] tracing: Simplify trace_option_write()
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove duplicate code inside trace_options_write()
- extract duplicate code in trace_options_write() and set_tracer_option()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |   85 ++++++++++++++++++-------------------------------
 1 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2801b0b..9359b74 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2318,38 +2318,39 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
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
@@ -2369,7 +2370,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int ret;
 	int i;
@@ -2381,16 +2382,15 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
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
@@ -3888,39 +3888,16 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
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
-- 
1.6.3

