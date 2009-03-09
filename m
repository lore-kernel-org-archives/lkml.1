Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZCIJNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZCIJNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZCIJNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:13:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:40800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZCIJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:13:12 -0400
Date: Mon, 9 Mar 2009 09:12:34 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
References: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/printk] tracing: optimize trace_printk()
Message-ID: <tip-7bffc23e56e92c14b787bf4d95249a32085bfed5@git.kernel.org>
Git-Commit-ID: 7bffc23e56e92c14b787bf4d95249a32085bfed5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Mar 2009 09:12:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bffc23e56e92c14b787bf4d95249a32085bfed5
Gitweb:     http://git.kernel.org/tip/7bffc23e56e92c14b787bf4d95249a32085bfed5
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Mon, 9 Mar 2009 10:11:36 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 9 Mar 2009 10:11:36 +0100

tracing: optimize trace_printk()

Impact: micro-optimization

trace_printk() does this unconditionally:

	trace_printk_fmt = fmt;

Where trace_printk_fmt is an entry into a global array. This is
very SMP-unfriendly.

So only write it once per bootup.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/kernel.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4e726b9..7742798 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -454,7 +454,10 @@ do {									\
 do {									\
 	static const char *trace_printk_fmt				\
 	__attribute__((section("__trace_printk_fmt")));			\
-	trace_printk_fmt = fmt;					\
+									\
+	if (!trace_printk_fmt)						\
+		trace_printk_fmt = fmt;					\
+									\
 	__trace_printk_check_format(fmt, ##args);			\
 	__trace_printk(_THIS_IP_, trace_printk_fmt, ##args);		\
 } while (0)
@@ -467,7 +470,10 @@ __trace_printk(unsigned long ip, const char *fmt, ...)
 do {									\
 	static const char *trace_printk_fmt				\
 	__attribute__((section("__trace_printk_fmt")));			\
-	trace_printk_fmt = fmt;					\
+									\
+	if (!trace_printk_fmt)						\
+		trace_printk_fmt = fmt;					\
+									\
 	__ftrace_vprintk(_THIS_IP_, trace_printk_fmt, vargs);		\
 } while (0)
 
