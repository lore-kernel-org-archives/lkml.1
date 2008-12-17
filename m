Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753006AbYLQVfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYLQVfF (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYLQVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:34:51 -0500
Received: from www.tglx.de ([62.245.132.106]:54619 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYLQVeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:34:50 -0500
Date: Wed, 17 Dec 2008 22:34:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: trace: fix task state printout
Message-ID: <alpine.LFD.2.00.0812172229490.3492@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: tracer task state decoding is wrong, size check is buggy

The tracing code has interesting varieties of printing out task state.
Unfortunalely only one of the instances is correct as it copies the
code from sched.c:sched_show_task(). The others are plain wrong as
they treatthe bitfield as an integer offset into the character
array. Also the size check of the character array is wrong as it
includes the trailing \0.

Use a common state decoder inline which does the Right Thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/trace.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -1301,6 +1301,13 @@ lat_print_timestamp(struct trace_seq *s,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
+static int task_state_char(unsigned long state)
+{
+	int bit = state ? __ffs(state) + 1 : 0;
+
+	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
+}
+
 /*
  * The message is supposed to contain an ending newline.
  * If the printing stops prematurely, try to add a newline of our own.
@@ -1395,12 +1402,8 @@ print_lat_fmt(struct trace_iterator *ite
 
 		trace_assign_type(field, entry);
 
-		T = field->next_state < sizeof(state_to_char) ?
-			state_to_char[field->next_state] : 'X';
-
-		state = field->prev_state ?
-			__ffs(field->prev_state) + 1 : 0;
-		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
+		T = task_state_char(field->next_state);
+		S = task_state_char(field->prev_state);
 		comm = trace_find_cmdline(field->next_pid);
 		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
 				 field->prev_pid,
@@ -1518,10 +1521,8 @@ static enum print_line_t print_trace_fmt
 
 		trace_assign_type(field, entry);
 
-		S = field->prev_state < sizeof(state_to_char) ?
-			state_to_char[field->prev_state] : 'X';
-		T = field->next_state < sizeof(state_to_char) ?
-			state_to_char[field->next_state] : 'X';
+		T = task_state_char(field->next_state);
+		S = task_state_char(field->prev_state);
 		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
 				       field->prev_pid,
 				       field->prev_prio,
@@ -1620,12 +1621,9 @@ static enum print_line_t print_raw_fmt(s
 
 		trace_assign_type(field, entry);
 
-		S = field->prev_state < sizeof(state_to_char) ?
-			state_to_char[field->prev_state] : 'X';
-		T = field->next_state < sizeof(state_to_char) ?
-			state_to_char[field->next_state] : 'X';
-		if (entry->type == TRACE_WAKE)
-			S = '+';
+		T = task_state_char(field->next_state);
+		S = entry->type == TRACE_WAKE ? '+' :
+			task_state_char(field->prev_state);
 		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
 				       field->prev_pid,
 				       field->prev_prio,
@@ -1711,12 +1709,9 @@ static enum print_line_t print_hex_fmt(s
 
 		trace_assign_type(field, entry);
 
-		S = field->prev_state < sizeof(state_to_char) ?
-			state_to_char[field->prev_state] : 'X';
-		T = field->next_state < sizeof(state_to_char) ?
-			state_to_char[field->next_state] : 'X';
-		if (entry->type == TRACE_WAKE)
-			S = '+';
+		T = task_state_char(field->next_state);
+		S = entry->type == TRACE_WAKE ? '+' :
+			task_state_char(field->prev_state);
 		SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
 		SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, S);
