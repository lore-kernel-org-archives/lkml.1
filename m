Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZGAOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZGAOH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZGAOHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:07:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:38799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZGAOHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:07:19 -0400
Date: Wed, 1 Jul 2009 14:06:32 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4B2351.5010300@cn.fujitsu.com>
References: <4A4B2351.5010300@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix trace_print_seq()
Message-ID: <tip-5c37f525657e879a17a27c83021602cd55837531@git.kernel.org>
Git-Commit-ID: 5c37f525657e879a17a27c83021602cd55837531
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c37f525657e879a17a27c83021602cd55837531
Gitweb:     http://git.kernel.org/tip/5c37f525657e879a17a27c83021602cd55837531
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 1 Jul 2009 16:50:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 16:03:50 +0200

tracing: Fix trace_print_seq()

We will lose something if trace_seq->buffer[0] is 0, because the copy length
is calculated by strlen() in seq_puts(), so using seq_write() instead of
seq_puts().

There have a example:
after reboot:

 # echo kmemtrace > current_tracer
 # echo 0 > options/kmem_minimalistic
 # cat trace
 # tracer: kmemtrace
 #
 #

Nothing is exported, because the first byte of trace_seq->buffer[ ]
is KMEMTRACE_USER_ALLOC.

( the value of KMEMTRACE_USER_ALLOC is zero, seeing
  kmemtrace_print_alloc_user() in kernel/trace/kmemtrace.c)

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <4A4B2351.5010300@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_output.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 7938f3a..e0c2545 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -27,8 +27,7 @@ void trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
 
-	s->buffer[len] = 0;
-	seq_puts(m, s->buffer);
+	seq_write(m, s->buffer, len);
 
 	trace_seq_init(s);
 }
