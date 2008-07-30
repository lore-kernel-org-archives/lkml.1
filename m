Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbYG3SX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbYG3SX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG3SWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:22:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbYG3SWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:22:41 -0400
Message-Id: <20080730182239.523848312@goodmis.org>
References: <20080730182053.872043059@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jul 2008 14:20:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] rcu: trace fix possible mem-leak
Content-Disposition: inline; filename=rcu-trace-fix-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the initialization of the RCU trace module, if
rcupreempt_debugfs_init() fails, we never free the the trace buffer.

This patch frees the trace buffer in case the debugfs fails.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/rcupreempt_trace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-compile.git/kernel/rcupreempt_trace.c
===================================================================
--- linux-compile.git.orig/kernel/rcupreempt_trace.c	2008-07-15 23:55:47.000000000 -0400
+++ linux-compile.git/kernel/rcupreempt_trace.c	2008-07-30 13:58:41.000000000 -0400
@@ -308,11 +308,16 @@ out:
 
 static int __init rcupreempt_trace_init(void)
 {
+	int ret;
+
 	mutex_init(&rcupreempt_trace_mutex);
 	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
 	if (!rcupreempt_trace_buf)
 		return 1;
-	return rcupreempt_debugfs_init();
+	ret = rcupreempt_debugfs_init();
+	if (ret)
+		kfree(rcupreempt_trace_buf);
+	return ret;
 }
 
 static void __exit rcupreempt_trace_cleanup(void)

-- 
