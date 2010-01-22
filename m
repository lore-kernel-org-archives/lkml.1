Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435Ab0AVBS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0AVBS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463Ab0AVBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:18:53 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0AVBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Pqi8suvsFFACIGbWaq++90vIxFfSs7f55NWiIzE6p5SzuKZA/1abwvPyPqvpw+c6em
         6iuoq1OLMuI+Mv1Sk14muq/USMCTj+1BYebigHAJIminXMlnj7bzgwhKMbmH58I3QYK5
         hNFv6wueBFilwdV8psM/9GnCVuxWlM7D/sp08=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 02/10] ftrace: Ensure tracing has really stopped before leaving unregister_ftrace_graph
Date: Fri, 22 Jan 2010 02:16:14 +0100
Message-Id: <1264122982-1553-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we run under dynamic tracing, we know that after calling
unregister_ftrace_graph(), tracing has really stopped because of
the hot patching and use of stop_machine().

But in static tracing case, we only set stub callbacks. This is
not sufficient on archs that have weak memory ordering to assume
the older callbacks won't be called right after we leave
unregister_ftrace_graph().

Insert a read/write memory barrier in the end of
unregister_ftrace_graph() so that the code that follow can safely
assume tracing has really stopped. This can avoid its older tracing
callbacks to perform checks about various states like ensuring
needed buffers have been allocated, etc...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c050ce3..94117ec 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3128,6 +3128,18 @@ void unregister_ftrace_graph(void)
 
  out:
 	mutex_unlock(&ftrace_lock);
+
+	/*
+	 * In dynamic tracing case, tracing is really stopped here.
+	 * Otherwise we need to ensure ftrace_graph_return
+	 * and ftrace_graph_entry are seen uptodate, so that code
+	 * that follows unregister_ftrace_graph can safely assume
+	 * tracing has stopped. This avoid wasteful checks of tracing
+	 * states inside tracing callbacks.
+	 */
+#ifndef CONFIG_DYNAMIC_FTRACE
+	smp_mb();
+#endif
 }
 
 /* Allocate a return stack for newly created task */
-- 
1.6.2.3

