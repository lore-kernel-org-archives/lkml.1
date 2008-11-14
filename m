Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYKNKql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYKNKql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKNKq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:46:27 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46012 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYKNKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:46:27 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ftrace: add proper bin iterator support
Date: Fri, 14 Nov 2008 16:16:04 +0530
Message-Id: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.608.ga9645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In s_show after print_trace_line we call trace_print_seq which
does a strlen on the buffer containing binary data. I guess that would
give wrong results for bin data even though we are null terminating it.
We also don't want header in the output file if we have  TRACE_ITER_BIN.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 kernel/trace/trace.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a499e2..fb32a5c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1833,10 +1833,51 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	return print_trace_fmt(iter);
 }
 
+static int s_bin_show(struct seq_file *m, void *v)
+{
+	int len;
+	enum print_line_t ret;
+	struct trace_iterator *iter = v;
+
+	if (iter->ent == NULL)
+		return 0;
+
+	if (iter->trace && iter->trace->print_line) {
+		ret = iter->trace->print_line(iter);
+		if (ret != TRACE_TYPE_UNHANDLED)
+			goto trace_handled;
+	}
+	/*
+	 * If  trace type is unhandled or if we don't have
+	 * a print_line call the standard bin_fmt callback
+	 */
+	print_bin_fmt(iter);
+
+trace_handled:
+	/* copy the trace buffer to seq file buffer */
+	if (iter->seq.len >= PAGE_SIZE)
+		len = PAGE_SIZE - 1;
+	else
+		len = iter->seq.len;
+
+	if (m->count + len < m->size) {
+		memcpy(m->buf + m->count, iter->seq.buffer, len);
+		m->count += len;
+	} else
+		m->count = m->size;
+	trace_seq_reset(&iter->seq);
+
+	return 0;
+}
+
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
 
+	if (trace_flags & TRACE_ITER_BIN)
+		return s_bin_show(m, v);
+
 	if (iter->ent == NULL) {
 		if (iter->tr) {
 			seq_printf(m, "# tracer: %s\n", iter->trace->name);
-- 
1.6.0.4.608.ga9645

