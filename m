Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZCVXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZCVXSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZCVXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:18:45 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:58230 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbZCVXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o7igUHeP5fAY2AJrby5UVzfvCHK4J8+s5nkzZFRdHTxW5XeabMAqSPhvFf6tYS/3Zc
         6t9qejlwUFQg16dWWP7fNbBCbbVoLH3Py0oFke+2gSNLx5YYCzV6BDx6ezjIGaXBYKjq
         dzcs+2fyQUqfp155ZQsFQsQBS+RpmN5nOZ46o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2] tracing/events: don't discard an event after commit
Date: Mon, 23 Mar 2009 00:18:39 +0100
Message-Id: <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237763712-21423-1-git-send-email-fweisbec@gmail.com>
References: <1237763712-21423-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: depends on "tracing/events: don't use wake up for events"

When we want to filter an event, the filter test is done after
the event is commited to the ring-buffer to be discarded later if
needed.

But a reader could be reading this event while we are trying to discard
it. Other kind of racy events can even happen because the event is
commited and can be read and/or consumed.

What we want is to discard the event before committing it.

v2: add a reported-by Steven Rostedt

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events_stage_3.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 9a3bd49..9d2fa78 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -222,10 +222,11 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
-									\
 	if (call->preds && !filter_match_preds(call, entry))		\
 		ring_buffer_event_discard(event);			\
+									\
+	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
+									\
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void)				\
-- 
1.6.1

