Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbZJFNIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbZJFNIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbZJFNIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:08:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:43911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbZJFNIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:08:12 -0400
Date: Tue, 6 Oct 2009 13:07:09 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254809398-8078-4-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-4-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add string/dynamic cases to format_flags
Message-ID: <tip-064739bc4b3d7f424b2f25547e6611bcf0132415@git.kernel.org>
Git-Commit-ID: 064739bc4b3d7f424b2f25547e6611bcf0132415
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 13:07:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  064739bc4b3d7f424b2f25547e6611bcf0132415
Gitweb:     http://git.kernel.org/tip/064739bc4b3d7f424b2f25547e6611bcf0132415
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 6 Oct 2009 01:09:52 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Oct 2009 15:04:46 +0200

perf trace: Add string/dynamic cases to format_flags

Needed for distinguishing string fields in event stream processing.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: lizf@cn.fujitsu.com
Cc: hch@infradead.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1254809398-8078-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
