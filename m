Return-Path: <linux-kernel-owner+w=401wt.eu-S934578AbZKYHQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbZKYHQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934293AbZKYHP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:15:58 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33707 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934567AbZKYHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:15:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hsSpN+d0SDcU107JqmeMAi0jdU07h1MaYyhoG/HyLpr63FuxIMpdh99FuicA7iZW1T
         E9R1Zk19Ks8kizJiq8zdS0rfPc+jnKrmzbk17xnGD+2Fk7GV7SwGwuWzydAb+NmzfSvx
         5jxn9YrjV19W4PHvuj0vhWkacrkTqYH4SlIdY=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [RFC][PATCH 2/7] perf trace: Add flag/symbolic format_flags
Date: Wed, 25 Nov 2009 01:15:47 -0600
Message-Id: <1259133352-23685-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful to know whether a field is a flag or symbolic field for
e.g. when generating scripts - it allows us to translate those fields
specially rather than literally as plain numeric values.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |   17 +++++++++++++++++
 tools/perf/util/trace-event.h       |    2 ++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index eae5605..b2aa520 100644
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
@@ -1300,6 +1305,16 @@ process_entry(struct event *event __unused, struct print_arg *arg,
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
 
@@ -1667,9 +1682,11 @@ process_arg_token(struct event *event, struct print_arg *arg,
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
-- 
1.6.4.GIT

