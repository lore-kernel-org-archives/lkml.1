Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZLMNJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZLMNJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZLMNI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753100AbZLMNIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nr6gacCvNsv/BZuPACv4R+a3tjAdXczu+K3dPKkiMmqilQ4toEYtT/X7efYMMjnKBq
         /gQh86gi+5EqfmrXTVc3tqtLAvERAVgoJx0/VEp54n453L1mQtHaV3c2TU+RT0sCSwVm
         +xyNAza33cwbiJBAPdeCNUVVUlmaAoScWGqSQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/13] ksym_tracer: Fix compile warnings
Date: Sun, 13 Dec 2009 14:08:14 +0100
Message-Id: <1260709694-5166-14-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Fix these 2 warnings:

kernel/trace/trace_ksym.c: In function 'ksym_trace_filter_read':
kernel/trace/trace_ksym.c:239: warning: cast to pointer from integer of different size
kernel/trace/trace_ksym.c: In function 'ksym_trace_filter_write':
kernel/trace/trace_ksym.c:295: warning: ignoring return value of 'strstrip', declared with attribute warn_unused_result

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
LKML-Reference: <4B1DC578.9020909@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_ksym.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index ddfa0fd..e7a8995 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -235,7 +235,8 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
+		ret = trace_seq_printf(s, "%pS:",
+				(void *)(unsigned long)entry->attr.bp_addr);
 		if (entry->attr.bp_type == HW_BREAKPOINT_R)
 			ret = trace_seq_puts(s, "r--\n");
 		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
@@ -277,7 +278,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
-	char *input_string, *ksymname = NULL;
+	char *input_string, *buf, *ksymname = NULL;
 	unsigned long ksym_addr = 0;
 	int ret, op, changed = 0;
 
@@ -291,7 +292,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	input_string[count] = '\0';
 
-	strstrip(input_string);
+	buf = strstrip(input_string);
 
 	/*
 	 * Clear all breakpoints if:
@@ -299,14 +300,14 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!input_string[0] || !strcmp(input_string, "0") ||
-	    !strcmp(input_string, "*:---")) {
+	if (!buf[0] || !strcmp(buf, "0") ||
+	    !strcmp(buf, "*:---")) {
 		__ksym_trace_reset();
 		kfree(input_string);
 		return count;
 	}
 
-	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
+	ret = op = parse_ksym_trace_str(buf, &ksymname, &ksym_addr);
 	if (ret < 0) {
 		kfree(input_string);
 		return ret;
-- 
1.6.2.3

