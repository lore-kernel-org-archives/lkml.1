Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZKQDS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZKQDS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZKQDSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:18:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:41291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbZKQDSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:18:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/4] perf tools: Don't die() in perf_header__new
Date: Tue, 17 Nov 2009 01:18:11 -0200
Message-Id: <1258427892-16312-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258427892-16312-2-git-send-email-acme@infradead.org>
References: <1258427892-16312-1-git-send-email-acme@infradead.org>
 <1258427892-16312-2-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Propagate the errors instead, the users are the ones to decide what
to do if a library call fails.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    5 +++++
 tools/perf/util/header.c    |   18 +++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2a85205..82260c5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -439,6 +439,11 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		header = perf_header__new();
 
+	if (header == NULL) {
+		pr_err("Not enough memory for reading perf file header\n");
+		return -1;
+	}
+
 	if (raw_samples) {
 		perf_header__set_feat(header, HEADER_TRACE_INFO);
 	} else {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index dee1ed2..726a0eb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -65,14 +65,15 @@ struct perf_header *perf_header__new(void)
 {
 	struct perf_header *self = calloc(sizeof(*self), 1);
 
-	if (!self)
-		die("nomem");
-
-	self->size = 1;
-	self->attr = malloc(sizeof(void *));
+	if (self != NULL) {
+		self->size = 1;
+		self->attr = malloc(sizeof(void *));
 
-	if (!self->attr)
-		die("nomem");
+		if (self->attr == NULL) {
+			free(self);
+			self = NULL;
+		}
+	}
 
 	return self;
 }
@@ -426,6 +427,9 @@ struct perf_header *perf_header__read(int fd)
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
+	if (self == NULL)
+		die("nomem");
+
 	if (perf_file_header__read(&f_header, self, fd) < 0)
 		die("incompatible file format");
 
-- 
1.6.2.5

