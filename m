Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZFCPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZFCPTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZFCPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZFCPSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:21 -0400
Message-Id: <20090603151821.119336461@goodmis.org>
References: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       walimis <walimisdev@gmail.com>
Subject: [PATCH 3/5] tracing/events: fix output format of user stack
Content-Disposition: inline; filename=0003-tracing-events-fix-output-format-of-user-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: walimis <walimisdev@gmail.com>

According to "events/ftrace/user_stack/format", fix the output of
user stack.

before fix:

  sh-1073  [000]    31.137561:  <b7f274fe> <-  <0804e33c> <-  <080835c1>

after fix:

  sh-1072  [000]    37.039329:
 =>  <b7f8a4fe>
 =>  <0804e33c>
 =>  <080835c1>

Signed-off-by: walimis <walimisdev@gmail.com>
LKML-Reference: <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 64596a5..8dadbbb 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -389,17 +389,20 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 
 		if (ip == ULONG_MAX || !ret)
 			break;
-		if (i && ret)
-			ret = trace_seq_puts(s, " <- ");
+		if (ret)
+			ret = trace_seq_puts(s, " => ");
 		if (!ip) {
 			if (ret)
 				ret = trace_seq_puts(s, "??");
+			if (ret)
+				ret = trace_seq_puts(s, "\n");
 			continue;
 		}
 		if (!ret)
 			break;
 		if (ret)
 			ret = seq_print_user_ip(s, mm, ip, sym_flags);
+		ret = trace_seq_puts(s, "\n");
 	}
 
 	if (mm)
@@ -1012,10 +1015,10 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_userip_objs(field, s, flags))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
-	if (!trace_seq_putc(s, '\n'))
+	if (!seq_print_userip_objs(field, s, flags))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
-- 
1.6.3.1

-- 
