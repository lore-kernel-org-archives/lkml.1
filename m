Return-Path: <linux-kernel-owner+w=401wt.eu-S935294AbZDBHTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294AbZDBHTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbZDBHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:18:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760798AbZDBHSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:18:41 -0400
Message-ID: <49D46668.8030806@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 15:16:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing: disable seeking for trace_pipe_raw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: disable pread()

We set tracing_buffers_fops.llseek to no_llseek,
but we can still perform pread() to read this file.
That is not expected.

This fix uses nonseekable_open() to disable it.

tracing_buffers_fops.llseek is still set to no_llseek,
it mark this file is a "non-seekable device" and is used by
sys_splice(). See also do_splice() or manual of splice(2):

ERRORS
       EINVAL Target file system doesn't support  splicing;
              neither  of the descriptors refers to a pipe;
              or offset given for non-seekable device.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a81dec..7283b99 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3265,7 +3265,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = info;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 
  out:
 	kfree(info);




