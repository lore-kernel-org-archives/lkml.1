Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYIZPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYIZPtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYIZPtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:49:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:60824 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYIZPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XucaZzVNnl+S06GuG4dIbMhzlgIeo0taWgn6MtgdPOC9HjdmCooBaWyeBGRl43k3sC
         U0VxEd2qhmbGRRtTfQ6YDTn1lSBp77O4TrlMnXDB/Q6Gak/KqSTv/ZoAuWKDAXcVtfvp
         kixds9oacKiHysBv1AyERCfYbJAZMLC3GFzhI=
Message-ID: <48DD0493.2050901@gmail.com>
Date: Fri, 26 Sep 2008 17:49:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@elte.hu
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH -tip 3/3] Tracing/ftrace: Adapt boot tracer to the new type
 of print_line
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the boot tracer to the new type of the print_line callback.
If it doesn't handle a type, it relays to next output functions.
It will let this tracer to accept sched, stack or print entries.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d5c9e2e..d1260b6 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -45,21 +45,25 @@ static void boot_trace_ctrl_update(struct trace_array *tr)
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
+
+	return TRACE_TYPE_UNHANDLED;
 }
 
 struct tracer boot_tracer __read_mostly =
