Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbYI2ScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbYI2ScS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYI2ScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:32:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:51275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYI2ScB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JLPWTZ9AbKfXG28v519P8knh51/NYfJuwwRty0Lcv3MbX7qcDqsUi4kebutyprgu6q
         3skDIOE0V8ZaxXoOrPJUlZJ3SqNfnS/nqWqjcE5/bp7UE9KvvGt1ZV3ISjwzVtqQ2E+y
         ZLGNnC4XSr8qehzFdHmvWfb6X9YD1N/QXCxEw=
Message-ID: <48E11F1E.4060809@gmail.com>
Date: Mon, 29 Sep 2008 20:31:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@elte.hu
CC: pq@iki.fi, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: [PATCH -tip 4/4] Tracing/ftrace: adapt the boot tracer to the new
 print_line type
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adapts the boot tracer to the new type of the
print_line callback.
It still relays entries it doesn't support to default output
functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_boot.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d5c9e2e..48186b1 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -45,21 +45,24 @@ static void boot_trace_ctrl_update(struct trace_array *tr)
 		stop_boot_trace(tr);
 }
 
-static int initcall_print_line(struct trace_iterator *iter)
+static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 {
-	int ret = 0;
+	int ret;
 	struct trace_entry *entry = iter->ent;
 	struct boot_trace *it = &entry->field.initcall;
 	struct trace_seq *s = &iter->seq;
 
-	if (iter->ent->type == TRACE_BOOT)
+	if (iter->ent->type == TRACE_BOOT) {
 		ret = trace_seq_printf(s, "%pF called from %i "
 				       "returned %d after %lld msecs\n",
 				       it->func, it->caller, it->result,
 				       it->duration);
-	if (ret)
-		return 1;
-	return 0;
+		if (ret)
+			return TRACE_TYPE_HANDLED;
+		else
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+	return TRACE_TYPE_UNHANDLED;
 }
 
 struct tracer boot_tracer __read_mostly =
