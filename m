Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZKDLKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZKDLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZKDLKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:10:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:39725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbZKDLKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:10:17 -0500
Date: Wed, 4 Nov 2009 11:09:57 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AEF7F8A.3080300@cn.fujitsu.com>
References: <4AEF7F8A.3080300@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ftrace: Fix unmatched locking in ftrace_regex_write()
Message-ID: <tip-ed146b25942b428f8e8056587b7638ce76573c2f@git.kernel.org>
Git-Commit-ID: ed146b25942b428f8e8056587b7638ce76573c2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed146b25942b428f8e8056587b7638ce76573c2f
Gitweb:     http://git.kernel.org/tip/ed146b25942b428f8e8056587b7638ce76573c2f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 3 Nov 2009 08:55:38 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 4 Nov 2009 01:42:10 -0500

ftrace: Fix unmatched locking in ftrace_regex_write()

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
 
