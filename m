Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXJDPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXJDPSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbXJDPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:18:06 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:60739 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbXJDPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:18:05 -0400
Subject: [PATCH] RCU trace fix possible mem-leak
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 11:16:50 -0400
Message-Id: <1191511010.15186.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ For RCU trace which is not yet in mainline ]

In the initialization of the RCU trace module, if
rcupreempt_debugfs_init() fails, we never free the the trace buffer.

This patch frees the trace buffer in case the debugfs fails.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc9-rt1/kernel/rcupreempt_trace.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rcupreempt_trace.c
+++ linux-2.6.23-rc9-rt1/kernel/rcupreempt_trace.c
@@ -309,11 +309,16 @@ out:
 
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


