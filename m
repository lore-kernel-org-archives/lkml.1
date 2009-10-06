Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZJFGLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZJFGLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbZJFGKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:10:46 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:45121 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbZJFGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qC0Ac4P+cbSTHhE66razruhzqYzJd+tqTZDsaogeLRA+cdd9vzEwILmCqHGtr/p5Fn
         k4eLohYwioIkj7HoWBFRyPmc2C6RbIlpRp5hR4MTMhw0DEtHE7XzBTOhlOizxjfUKTHQ
         HpqoJ6S3kPYkw+G/MsZJtq/2pvEeBordx3Cz8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 3/9] perf trace: Add string/dynamic cases to format_flags
Date: Tue,  6 Oct 2009 01:09:52 -0500
Message-Id: <1254809398-8078-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for distinguishing string fields in event stream processing.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |   24 ++++++++++++++++++++++++
 tools/perf/util/trace-event.h       |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index de3fc8b..6f851f9 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -721,6 +721,24 @@ static int event_read_id(void)
 	return -1;
 }
 
+static int field_is_string(struct format_field *field)
+{
+	if ((field->flags & FIELD_IS_ARRAY) &&
+	    (!strstr(field->type, "char") || !strstr(field->type, "u8") ||
+	     !strstr(field->type, "s8")))
+		return 1;
+
+	return 0;
+}
+
+static int field_is_dynamic(struct format_field *field)
+{
+	if (!strcmp(field->type, "__data_loc"))
+		return 1;
+
+	return 0;
+}
+
 static int event_read_fields(struct event *event, struct format_field **fields)
 {
 	struct format_field *field = NULL;
@@ -865,6 +883,12 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			free(brackets);
 		}
 
+		if (field_is_string(field)) {
+			field->flags |= FIELD_IS_STRING;
+			if (field_is_dynamic(field))
+				field->flags |= FIELD_IS_DYNAMIC;
+		}
+
 		if (test_type_token(type, token,  EVENT_OP, (char *)";"))
 			goto fail;
 		free_token(token);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index cb92978..5f59a39 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -27,6 +27,8 @@ enum format_flags {
 	FIELD_IS_ARRAY		= 1,
 	FIELD_IS_POINTER	= 2,
 	FIELD_IS_SIGNED		= 4,
+	FIELD_IS_STRING		= 8,
+	FIELD_IS_DYNAMIC	= 16,
 };
 
 struct format_field {
-- 
1.6.4.GIT

