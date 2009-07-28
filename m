Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZG1Vzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZG1Vzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZG1Vzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:55:43 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41260 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZG1Vzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QAix3RSFZK+nSRAEgMgj3IlnDZZujfHa503cuNb1UGb/+HG4b7uLZKEoQD/6tDDtNJ
         0zbqjDyauPsTeQVKyvDGD0DWowEpUwsQ6HaNAM1eBStCt5/GgIZuiQpFQOQp6FF+6kfK
         RsenD8kYWDIbOaK5I4haKoDQK4gh4u/SpsCbc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, stable@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing: Fix invalid function_graph entry
Date: Tue, 28 Jul 2009 23:55:33 +0200
Message-Id: <1248818134-5231-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
References: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

When print_graph_entry() computes a function call entry event, it needs
to also check the next entry to guess if it matches the return event of
the current function entry.
In order to look at this next event, it needs to consume the current
entry before going ahead in the ring buffer.

However, if the current event that gets consumed is the last one in the
ring buffer head page, the ring_buffer may reuse the page for writers.
The consumed entry will then become invalid because of possible
racy overwriting.

Me must then handle this entry by making a copy of it.

The fix also applies on 2.6.30

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: stable@kernel.org
LKML-Reference: <4A6EEAEC.3050508@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d2249ab..420ec34 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -843,9 +843,16 @@ print_graph_function(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
-		struct ftrace_graph_ent_entry *field;
+		/*
+		 * print_graph_entry() may consume the current event,
+		 * thus @field may become invalid, so we need to save it.
+		 * sizeof(struct ftrace_graph_ent_entry) is very small,
+		 * it can be safely saved at the stack.
+		 */
+		struct ftrace_graph_ent_entry *field, saved;
 		trace_assign_type(field, entry);
-		return print_graph_entry(field, s, iter);
+		saved = *field;
+		return print_graph_entry(&saved, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
-- 
1.6.2.3

