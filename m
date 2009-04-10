Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZDJLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZDJLHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZDJLHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:07:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:45209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZDJLHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:07:23 -0400
Date: Fri, 10 Apr 2009 11:06:49 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D46668.8030806@cn.fujitsu.com>
References: <49D46668.8030806@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: disable seeking for trace_pipe_raw
Message-ID: <tip-d1e7e02f30be672c6f6ee40908be83877a0d49d1@git.kernel.org>
Git-Commit-ID: d1e7e02f30be672c6f6ee40908be83877a0d49d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:06:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1e7e02f30be672c6f6ee40908be83877a0d49d1
Gitweb:     http://git.kernel.org/tip/d1e7e02f30be672c6f6ee40908be83877a0d49d1
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 15:16:56 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:44:42 +0200

tracing: disable seeking for trace_pipe_raw

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <49D46668.8030806@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d28476..24b0168 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3285,7 +3285,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = info;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 
  out:
 	kfree(info);
