Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbZEGJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbZEGJZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbZEGJXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:40468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761480AbZEGJXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:46 -0400
Date: Thu, 7 May 2009 09:23:04 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144556.578777000@intel.com>
References: <20090403144556.578777000@intel.com>
Subject: [tip:tracing/core] x86, hw-branch-tracer: allocate selftest iterator on heap
Message-ID: <tip-4d657e51dfc042216febd4a007c6f36881f9256d@git.kernel.org>
Git-Commit-ID: 4d657e51dfc042216febd4a007c6f36881f9256d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:23:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d657e51dfc042216febd4a007c6f36881f9256d
Gitweb:     http://git.kernel.org/tip/4d657e51dfc042216febd4a007c6f36881f9256d
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:21 +0200

x86, hw-branch-tracer: allocate selftest iterator on heap

Allocate the trace_iterator for the hw-branch-tracer selftest on the heap.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144556.578777000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_selftest.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 499d01c..00dd648 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -757,7 +757,7 @@ int
 trace_selftest_startup_hw_branches(struct tracer *trace,
 				   struct trace_array *tr)
 {
-	struct trace_iterator iter;
+	struct trace_iterator *iter;
 	struct tracer tracer;
 	unsigned long count;
 	int ret;
@@ -777,17 +777,21 @@ trace_selftest_startup_hw_branches(struct tracer *trace,
 	 * The hw-branch tracer needs to collect the trace from the various
 	 * cpu trace buffers - before tracing is stopped.
 	 */
-	memset(&iter, 0, sizeof(iter));
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
 	memcpy(&tracer, trace, sizeof(tracer));
 
-	iter.trace = &tracer;
-	iter.tr = tr;
-	iter.pos = -1;
-	mutex_init(&iter.mutex);
+	iter->trace = &tracer;
+	iter->tr = tr;
+	iter->pos = -1;
+	mutex_init(&iter->mutex);
 
-	trace->open(&iter);
+	trace->open(iter);
 
-	mutex_destroy(&iter.mutex);
+	mutex_destroy(&iter->mutex);
+	kfree(iter);
 
 	tracing_stop();
 
