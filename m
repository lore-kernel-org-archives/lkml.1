Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZLMNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZLMNKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZLMNKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:10:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53483 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753130AbZLMNIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mqiEqrwjVu8YMDaNtKnQmRTg+X7revzhvRTeFlRDWp63jHzJ/ClaH7adW5lTRP+Gwr
         nl7TdpOd51bqWo4vkwzxAP4D7Lo9DR8RxuNMyXL3YN5aUOuUstPOqWkbQ6XCkWgU6e4Y
         dsN1JdxFdCGIujU76+8twOF6/Q9q2N9DSlgd4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/13] tracing: Simplify trace_option_write()
Date: Sun, 13 Dec 2009 14:08:11 +0100
Message-Id: <1260709694-5166-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.2.3

