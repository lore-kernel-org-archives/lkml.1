Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZDBHSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZDBHSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZDBHSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:18:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56259 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZDBHSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:18:39 -0400
Message-ID: <49D4666B.4010608@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 15:16:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing: allocate page when need
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Cleanup

Sometimes, we open trace_pipe_raw, but we don't read(2) it,
we just splice(2) it, thus, the page is not used.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7283b99..20e9f33 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3257,19 +3257,13 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	info->tr	= &global_trace;
 	info->cpu	= cpu;
-	info->spare	= ring_buffer_alloc_read_page(info->tr->buffer);
+	info->spare	= NULL;
 	/* Force reading ring buffer for first read */
 	info->read	= (unsigned int)-1;
-	if (!info->spare)
-		goto out;
 
 	filp->private_data = info;
 
 	return nonseekable_open(inode, filp);
-
- out:
-	kfree(info);
-	return -ENOMEM;
 }
 
 static ssize_t
@@ -3284,6 +3278,11 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (!count)
 		return 0;
 
+	if (!info->spare)
+		info->spare = ring_buffer_alloc_read_page(info->tr->buffer);
+	if (!info->spare)
+		return -ENOMEM;
+
 	/* Do we have previous read data to read? */
 	if (info->read < PAGE_SIZE)
 		goto read;
@@ -3322,7 +3321,8 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_buffer_info *info = file->private_data;
 
-	ring_buffer_free_read_page(info->tr->buffer, info->spare);
+	if (info->spare)
+		ring_buffer_free_read_page(info->tr->buffer, info->spare);
 	kfree(info);
 
 	return 0;




