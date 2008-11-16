Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYKPKi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYKPKi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKPKiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:38:18 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:39862 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYKPKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:38:17 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: add proper bin iterator support
Date: Sun, 16 Nov 2008 16:08:00 +0530
Message-Id: <1226831883-26362-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
In-Reply-To: <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 4a90462..f6e21d8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2080,10 +2080,51 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
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
tg: (7195b67..) an/ftrace-bin-iterator.patch (depends on: master)
