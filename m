Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZLNJrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZLNJrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZLNJrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:47:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:48214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZLNJrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:47:04 -0500
Date: Mon, 14 Dec 2009 09:46:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC4D2.3000406@cn.fujitsu.com>
References: <4B1DC4D2.3000406@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ftrace: Call trace_parser_clear() properly
Message-ID: <tip-313254a9400d388b46150c0f355e216418a2f598@git.kernel.org>
Git-Commit-ID: 313254a9400d388b46150c0f355e216418a2f598
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  313254a9400d388b46150c0f355e216418a2f598
Gitweb:     http://git.kernel.org/tip/313254a9400d388b46150c0f355e216418a2f598
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:15:30 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:26 +0100

ftrace: Call trace_parser_clear() properly

I found a weird behavior:

  # echo 'fuse:*' > set_ftrace_filter
  bash: echo: write error: Invalid argument
  # cat set_ftrace_filter
  fuse_dev_fasync
  fuse_dev_poll
  fuse_copy_do

We should call trace_parser_clear() no matter ftrace_process_regex()
returns 0 or -errno, otherwise we will actually take the unaccepted
records from ftrace_regex_release().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC4D2.3000406@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 08a3fb5..ff8aecd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2208,10 +2208,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	    !trace_parser_cont(parser)) {
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
+		trace_parser_clear(parser);
 		if (ret)
 			goto out_unlock;
-
-		trace_parser_clear(parser);
 	}
 
 	ret = read;
