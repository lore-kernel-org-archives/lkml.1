Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZJFGPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZJFGPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZJFGPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:15:53 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:42297 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZJFGPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nrl/hW0RKCQseWRPcvBhCVT8qx0YdELkU6/EcCDY1npNIlHL+FfnHaLfCBFWrjiAj/
         DlVHJJGWRgoMYyaSwzAa+eF/SS1EUpWUpfBLJXXWXNzzgdyvXy0l/9r4Mib6yXlxx4+T
         n+OcnRhA6qG6QY4sLmyTv4kR3QCO9z3tDb59I=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 7/9] perf trace: Add FIELD_IS_FLAG/SYMBOLIC cases to format_flags
Date: Tue,  6 Oct 2009 01:09:56 -0500
Message-Id: <1254809398-8078-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detects whether a particular field is a 'flag' or 'symbolic' field and
uses that information in the Perl generate_event_handlers()
implementation.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |   17 +++++++++++++++++
 tools/perf/util/trace-event-perl.c  |   19 +++++++++++++++++--
 tools/perf/util/trace-event.h       |    2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index bc482c5..1dbe17f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -46,6 +46,11 @@ static unsigned long long input_buf_siz;
 
 static int cpus;
 static int long_size;
+static int is_flag_field;
+static int is_symbolic_field;
+
+static struct format_field *
+find_any_field(struct event *event, const char *name);
 
 static void init_input_buf(char *buf, unsigned long long size)
 {
@@ -1227,6 +1232,16 @@ process_entry(struct event *event __unused, struct print_arg *arg,
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
 
@@ -1617,9 +1632,11 @@ process_arg_token(struct event *event, struct print_arg *arg,
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
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 657b87a..b9fbd7b 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -428,7 +428,9 @@ static int perl_generate_event_handlers(const char *outfile)
 				fprintf(ofp, ", ");
 
 			fprintf(ofp, "%s=", f->name);
-			if (f->flags & FIELD_IS_STRING)
+			if (f->flags & FIELD_IS_STRING ||
+			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
 			else if (f->flags & FIELD_IS_SIGNED)
 				fprintf(ofp, "%%d");
@@ -444,7 +446,20 @@ static int perl_generate_event_handlers(const char *outfile)
 			if (not_first++)
 				fprintf(ofp, ", ");
 
-			fprintf(ofp, "$%s", f->name);
+			if (f->flags & FIELD_IS_FLAG) {
+				fprintf(ofp, "flag_str(\"");
+				fprintf(ofp, "%s::%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", $%s)", f->name,
+					f->name);
+			} else if (f->flags & FIELD_IS_SYMBOLIC) {
+				fprintf(ofp, "symbol_str(\"");
+				fprintf(ofp, "%s::%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", $%s)", f->name,
+					f->name);
+			} else
+				fprintf(ofp, "$%s", f->name);
 		}
 
 		fprintf(ofp, ");\n");
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 582e0eb..dc90b2e 100644
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
-- 
1.6.4.GIT

