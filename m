Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYDRUJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYDRUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761097AbYDRUIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:08:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbYDRUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:08:51 -0400
Message-Id: <20080418200850.141548878@goodmis.org>
References: <20080418200538.788522018@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 16:05:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ftrace: replace simple_strtoul with strict_strtoul
Content-Disposition: inline; filename=ftrace-use-strict_strtoul.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton suggested using strict_strtoul over simple_strtoul.
This patch replaces them in ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-18 15:47:40.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-18 15:49:09.000000000 -0400
@@ -92,9 +92,16 @@ void trace_wake_up(void)
 
 static int __init set_nr_entries(char *str)
 {
+	unsigned long nr_entries;
+	int ret;
+
 	if (!str)
 		return 0;
-	trace_nr_entries = simple_strtoul(str, &str, 0);
+	ret = strict_strtoul(str, 0, &nr_entries);
+	/* nr_entries can not be zero */
+	if (ret < 0 || nr_entries == 0)
+		return 0;
+	trace_nr_entries = nr_entries;
 	return 1;
 }
 __setup("trace_entries=", set_nr_entries);
@@ -2050,8 +2057,9 @@ tracing_ctrl_write(struct file *filp, co
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	long val;
 	char buf[64];
+	long val;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2061,7 +2069,9 @@ tracing_ctrl_write(struct file *filp, co
 
 	buf[cnt] = 0;
 
-	val = simple_strtoul(buf, NULL, 10);
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
 
 	val = !!val;
 
@@ -2165,8 +2175,9 @@ tracing_max_lat_write(struct file *filp,
 		      size_t cnt, loff_t *ppos)
 {
 	long *ptr = filp->private_data;
-	long val;
 	char buf[64];
+	long val;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2176,7 +2187,9 @@ tracing_max_lat_write(struct file *filp,
 
 	buf[cnt] = 0;
 
-	val = simple_strtoul(buf, NULL, 10);
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
 
 	*ptr = val * 1000;
 
@@ -2432,6 +2445,7 @@ tracing_entries_write(struct file *filp,
 {
 	unsigned long val;
 	char buf[64];
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2441,7 +2455,9 @@ tracing_entries_write(struct file *filp,
 
 	buf[cnt] = 0;
 
-	val = simple_strtoul(buf, NULL, 10);
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
 
 	/* must have at least 1 entry */
 	if (!val)

-- 
