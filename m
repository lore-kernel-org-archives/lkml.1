Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYH1DY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYH1DY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYH1DYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:24:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYH1DYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:24:18 -0400
Date: Wed, 27 Aug 2008 23:24:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: remove direct reference to mcount in trace code
Message-ID: <alpine.DEB.1.10.0808272323030.1782@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mcount record method of ftrace scans objdump for references to mcount.
Using mcount as the reference to test if the calls to mcount being replaced
are indeed calls to mcount, this use of mcount was also caught as a
location to change. Using a variable that points to the mcount address
moves this reference into the data section that is not scanned, and
we do not use a false location to try and modify.

The warn on code was what was used to detect this bug.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-27 22:13:39.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-27 22:16:52.000000000 -0400
@@ -37,6 +37,14 @@ int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
 /*
+ * Since MCOUNT_ADDR may point to mcount itself, we do not want
+ * to get it confused by reading a reference in the code as we
+ * are parsing on objcopy output of text. Use a variable for
+ * it instead.
+ */
+static unsigned long mcount_addr = MCOUNT_ADDR;
+
+/*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
  */
@@ -594,7 +602,7 @@ ftrace_code_disable(struct dyn_ftrace *r
 	ip = rec->ip;
 
 	nop = ftrace_nop_replace();
-	call = ftrace_call_replace(ip, MCOUNT_ADDR);
+	call = ftrace_call_replace(ip, mcount_addr);
 
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {

