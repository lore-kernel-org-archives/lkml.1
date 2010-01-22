Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596Ab0AVBQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0AVBQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430Ab0AVBQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:40 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0AVBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qniay9ntpmp/ujwjiEOlYCd0WbjD9IZ5fZQPq/U7emEY52q95wtVMjX18UOV95Id67
         W7tGNungeF2o/Xk1S1xAXSN/QoOEGza6x1iNQEmQkv3amukX/byfeq7NhM8ZQ8Mp6j+Y
         09y12V+zlkMxYUYrljkIf52f+v0x2a+gzDzJA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 04/10] ftrace: Ensure buffers are visibles to tracing callbacks right away
Date: Fri, 22 Jan 2010 02:16:16 +0100
Message-Id: <1264122982-1553-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tracer may need to allocate specific buffers before calling
function tracing callbacks. And these callbacks may use these
buffers. To avoid lazy memory ordering, the callbacks may need
to check the state of the buffers before doing anything. This
is wasteful on the tracing hot path.

Let's then put an appropriate barrier before registering tracing
callbacks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f258f67..3cdb35e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3099,6 +3099,14 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 		goto out;
 	}
 
+	/*
+	 * The tracing callbacks might use buffers that the tracer could
+	 * have allocated just before. Ensure this is all visible before
+	 * starting the tracing, so that we avoid null pointer checks
+	 * in the tracing hot paths.
+	 */
+	smp_mb();
+
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-- 
1.6.2.3

