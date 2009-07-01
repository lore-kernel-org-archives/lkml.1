Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZGAIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZGAIu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZGAIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:50:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZGAIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:50:17 -0400
Message-ID: <4A4B2351.5010300@cn.fujitsu.com>
Date: Wed, 01 Jul 2009 16:50:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix trace_print_seq()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.6.1.2

