Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbZDJLJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbZDJLJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbZDJLIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:08:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:45277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765549AbZDJLIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:08:51 -0400
Date: Fri, 10 Apr 2009 11:07:01 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D4666B.4010608@cn.fujitsu.com>
References: <49D4666B.4010608@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: allocate page when needed
Message-ID: <tip-ddd538f3e6a1a4bec2f6942f83a753263e6577b4@git.kernel.org>
Git-Commit-ID: ddd538f3e6a1a4bec2f6942f83a753263e6577b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:07:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddd538f3e6a1a4bec2f6942f83a753263e6577b4
Gitweb:     http://git.kernel.org/tip/ddd538f3e6a1a4bec2f6942f83a753263e6577b4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 15:16:59 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:44:43 +0200

tracing: allocate page when needed

Impact: Cleanup

Sometimes, we open trace_pipe_raw, but we don't read(2) it,
we just splice(2) it, thus, the page is not used.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D4666B.4010608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 24b0168..8e189ff 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3277,19 +3277,13 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
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
@@ -3304,6 +3298,11 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
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
@@ -3342,7 +3341,8 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_buffer_info *info = file->private_data;
 
-	ring_buffer_free_read_page(info->tr->buffer, info->spare);
+	if (info->spare)
+		ring_buffer_free_read_page(info->tr->buffer, info->spare);
 	kfree(info);
 
 	return 0;
