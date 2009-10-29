Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZJ2VF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZJ2VF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZJ2VF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:05:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZJ2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:05:23 -0400
Message-Id: <20091029210527.164613277@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 16:51:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 3/3][RFC] [PATCH 3/3] tracing/kprobes: Disable tracing registered jprobe callback functions
References: <20091029205151.852744305@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-kprobes-Disable-tracing-registered-jprobe-ca.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Functions registered with jprobes will cause the function graph tracer
to crash. This is because the implementation of the function graph
tracer and jprobes collide. This patch permanently removes the registered
jprobe function from being traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5240d75..2589b8a 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -42,6 +42,7 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/ftrace.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
 
@@ -897,6 +898,9 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 		jp = jps[i];
 		addr = arch_deref_entry_point(jp->entry);
 
+		/* This may mess up function graph tracer */
+		ftrace_disable_function(jp->entry);
+
 		if (!kernel_text_address(addr))
 			ret = -EINVAL;
 		else {
-- 
1.6.3.3


