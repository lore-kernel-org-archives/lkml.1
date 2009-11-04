Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZKDGss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZKDGss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZKDGsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:48:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZKDGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:48:46 -0500
Message-Id: <20091104064850.911978766@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 04 Nov 2009 01:48:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] [PATCH 2/2] ftrace: Fix unmatched locking in ftrace_regex_write()
References: <20091104064825.546743711@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-unmatched-locking-in-ftrace_regex_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

When a command is passed to the set_ftrace_filter, then
the ftrace_regex_lock is still held going back to user space.

 # echo 'do_open : foo' > set_ftrace_filter
 (still holding ftrace_regex_lock when returning to user space!)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AEF7F8A.3080300@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9c451a1..6dc4e5e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2222,15 +2222,15 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
 		if (ret)
-			goto out;
+			goto out_unlock;
 
 		trace_parser_clear(parser);
 	}
 
 	ret = read;
-
+out_unlock:
 	mutex_unlock(&ftrace_regex_lock);
-out:
+
 	return ret;
 }
 
-- 
1.6.3.3


