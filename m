Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZK3IWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZK3IWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZK3IWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:22:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:37741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZK3IWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:22:33 -0500
Date: Mon, 30 Nov 2009 08:22:02 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259133352-23685-3-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace: Add flag/symbolic format_flags
Message-ID: <tip-eb9a42caa7a926beb935a22bc59d981b35f0b652@git.kernel.org>
Git-Commit-ID: eb9a42caa7a926beb935a22bc59d981b35f0b652
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb9a42caa7a926beb935a22bc59d981b35f0b652
Gitweb:     http://git.kernel.org/tip/eb9a42caa7a926beb935a22bc59d981b35f0b652
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 25 Nov 2009 01:15:47 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Nov 2009 10:04:25 +0100

perf trace: Add flag/symbolic format_flags

It's useful to know whether a field is a flag or symbolic field
for e.g. when generating scripts - it allows us to translate
those fields specially rather than literally as plain numeric
values.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259133352-23685-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |   17 +++++++++++++++++
 tools/perf/util/trace-event.h       |    2 ++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 7021dc1..85d7163 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -48,6 +48,11 @@ static unsigned long long input_buf_siz;
 
 static int cpus;
 static int long_size;
+static int is_flag_field;
+static int is_symbolic_field;
+
+static struct format_field *
+find_any_field(struct event *event, const char *name);
 
 static void init_input_buf(char *buf, unsigned long long size)
 {
@@ -1301,6 +1306,16 @@ process_entry(struct event *event __unused, struct print_arg *arg,
 	arg->type = PRINT_FIELD;
 	arg->field.name = field;
 
+	if (is_flag_field) {
+		arg->field.field = find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_FLAG;
+		is_flag_field = 0;
+	} else if (is_symbolic_field) {
+		arg->field.field = find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
+		is_symbolic_field = 0;
+	}
+
 	type = read_token(&token);
 	*tok = token;
 
@@ -1668,9 +1683,11 @@ process_arg_token(struct event *event, struct print_arg *arg,
 			type = process_entry(event, arg, &token);
 		} else if (strcmp(token, "__print_flags") == 0) {
 			free_token(token);
+			is_flag_field = 1;
 			type = process_flags(event, arg, &token);
 		} else if (strcmp(token, "__print_symbolic") == 0) {
 			free_token(token);
+			is_symbolic_field = 1;
 			type = process_symbols(event, arg, &token);
 		} else if (strcmp(token, "__get_str") == 0) {
 			free_token(token);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index e7aaf00..aeb9157 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -29,6 +29,8 @@ enum format_flags {
 	FIELD_IS_SIGNED		= 4,
 	FIELD_IS_STRING		= 8,
 	FIELD_IS_DYNAMIC	= 16,
+	FIELD_IS_FLAG		= 32,
+	FIELD_IS_SYMBOLIC	= 64,
 };
 
 struct format_field {
