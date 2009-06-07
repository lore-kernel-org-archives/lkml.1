Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZFGKWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZFGKWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZFGKWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:22:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZFGKWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:22:32 -0400
Date: Sun, 7 Jun 2009 10:22:10 GMT
From: tip-bot for walimis <walimisdev@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, walimisdev@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, walimisdev@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
References: <1244016090-7814-3-git-send-email-walimisdev@gmail.com>
Subject: [tip:tracing/core] tracing/events: fix output format of user stack
Message-ID: <tip-048dc50c5e7eada19ebabbad70b7966d14283d41@git.kernel.org>
Git-Commit-ID: 048dc50c5e7eada19ebabbad70b7966d14283d41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:22:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  048dc50c5e7eada19ebabbad70b7966d14283d41
Gitweb:     http://git.kernel.org/tip/048dc50c5e7eada19ebabbad70b7966d14283d41
Author:     walimis <walimisdev@gmail.com>
AuthorDate: Wed, 3 Jun 2009 16:01:30 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 3 Jun 2009 10:25:30 -0400

tracing/events: fix output format of user stack

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
