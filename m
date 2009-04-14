Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDNAeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDNAeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZDNAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:34:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZDNAe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:34:29 -0400
Date: Tue, 14 Apr 2009 00:33:59 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, zhaolei@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       zhaolei@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E2F19A.3040006@cn.fujitsu.com>
References: <49E2F19A.3040006@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: Fix branch tracer header
Message-ID: <tip-557055bebe9212dfa6b9f5df811dfd0dac77ec55@git.kernel.org>
Git-Commit-ID: 557055bebe9212dfa6b9f5df811dfd0dac77ec55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 00:34:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  557055bebe9212dfa6b9f5df811dfd0dac77ec55
Gitweb:     http://git.kernel.org/tip/557055bebe9212dfa6b9f5df811dfd0dac77ec55
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Mon, 13 Apr 2009 16:02:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 02:30:36 +0200

tracing: Fix branch tracer header

Before patch:

  # tracer: branch
  #
  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
  #              | |       |          |         |
             <...>-2981  [000] 24008.872738: [  ok  ] trace_irq_handler_exit:irq_event_types.h:41
             <...>-2981  [000] 24008.872742: [  ok  ] note_interrupt:spurious.c:229
  ...

After patch:

  # tracer: branch
  #
  #           TASK-PID    CPU#    TIMESTAMP  CORRECT  FUNC:FILE:LINE
  #              | |       |          |         |       |
             <...>-2985  [000] 26329.142970: [  ok  ] slab_free:slub.c:1776
             <...>-2985  [000] 26329.142972: [  ok  ] trace_kmem_cache_free:kmem_event_types.h:191
  ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49E2F19A.3040006@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_branch.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index ad8c22e..8333715 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -155,6 +155,13 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
+static void branch_print_header(struct seq_file *s)
+{
+	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
+		"  FUNC:FILE:LINE\n");
+	seq_puts(s, "#              | |       |          |         |   "
+		"    |\n");
+}
 
 static struct trace_event trace_branch_event = {
 	.type		= TRACE_BRANCH,
@@ -169,6 +176,7 @@ static struct tracer branch_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_branch,
 #endif /* CONFIG_FTRACE_SELFTEST */
+	.print_header	= branch_print_header,
 };
 
 __init static int init_branch_tracer(void)
