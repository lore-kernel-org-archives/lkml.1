Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZFCIDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZFCIDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZFCICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:02:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:21202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZFCICL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P+eArhEOqlpCSOAeuRfM8kyqsesfDlWraLK3XIsIpapXyXubWhBvFbSwSO08HWERpR
         +zlVaSATUG0DWY4FZtuF+y7Sk5uXW+FkhOMpyMWhJYenwXV37Oz+Cr8XqWtByakJ0UnB
         qHkiW3oNA6FhT+PHs/xKd95cj2Yu5Qa8DTsCE=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing/events: fix output format of user stack
Date: Wed,  3 Jun 2009 16:01:30 +0800
Message-Id: <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
 <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.0.3

