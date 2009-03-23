Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZCWIcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZCWIcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZCWIbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:31:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:51634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910AbZCWIbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:47 -0400
Date: Mon, 23 Mar 2009 08:31:11 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
References: <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/filters] tracing/events: don't discard an event after commit
Message-ID: <tip-b118415bfad6d75792a85ac999e25149db8e6919@git.kernel.org>
Git-Commit-ID: b118415bfad6d75792a85ac999e25149db8e6919
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:31:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b118415bfad6d75792a85ac999e25149db8e6919
Gitweb:     http://git.kernel.org/tip/b118415bfad6d75792a85ac999e25149db8e6919
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Mar 2009 00:18:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:22:15 +0100

tracing/events: don't discard an event after commit

When we want to filter an event, the filter test is done after
the event is commited to the ring-buffer to be discarded later if
needed.

But a reader could be reading this event while we are trying to discard
it. Other kind of racy events can even happen because the event is
commited and can be read and/or consumed.

What we want is to discard the event before committing it.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1237763919-21505-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
