Return-Path: <linux-kernel-owner+w=401wt.eu-S935804AbZLHDSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935804AbZLHDSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934778AbZLHDSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:18:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60604 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934825AbZLHDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:18:35 -0500
Message-ID: <4B1DC578.9020909@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 11:18:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH 13/13] ksym_tracer: Fix compile warnings
References: <4B1DC476.3030700@cn.fujitsu.com>
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix these 2 warnings:

kernel/trace/trace_ksym.c: In function 'ksym_trace_filter_read':
kernel/trace/trace_ksym.c:239: warning: cast to pointer from integer of different size
kernel/trace/trace_ksym.c: In function 'ksym_trace_filter_write':
kernel/trace/trace_ksym.c:295: warning: ignoring return value of 'strstrip', declared with attribute warn_unused_result

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index acb87d4..e393146 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -236,7 +236,8 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
+		ret = trace_seq_printf(s, "%pS:",
+				(void *)(unsigned long)entry->attr.bp_addr);
 		if (entry->attr.bp_type == HW_BREAKPOINT_R)
 			ret = trace_seq_puts(s, "r--\n");
 		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
@@ -278,7 +279,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
-	char *input_string, *ksymname = NULL;
+	char *input_string, *buf, *ksymname = NULL;
 	unsigned long ksym_addr = 0;
 	int ret, op, changed = 0;
 
@@ -292,7 +293,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	input_string[count] = '\0';
 
-	strstrip(input_string);
+	buf = strstrip(input_string);
 
 	/*
 	 * Clear all breakpoints if:
@@ -300,14 +301,14 @@ static ssize_t ksym_trace_filter_write(struct file *file,
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
1.6.3

