Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZKQGcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZKQGcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZKQGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:32:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:58513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbZKQGcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:32:15 -0500
Date: Tue, 17 Nov 2009 06:31:37 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258407027-384-1-git-send-email-acme@infradead.org>
References: <1258407027-384-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't die in perf_header_attr__new()
Message-ID: <tip-dc79c0fc08a94b857aed446bfb47cdfde529400c@git.kernel.org>
Git-Commit-ID: dc79c0fc08a94b857aed446bfb47cdfde529400c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc79c0fc08a94b857aed446bfb47cdfde529400c
Gitweb:     http://git.kernel.org/tip/dc79c0fc08a94b857aed446bfb47cdfde529400c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 19:30:26 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:52 +0100

perf tools: Don't die in perf_header_attr__new()

We really should propagate such kinds of errors so that users of
these library functions decide what to do in such cases instead
of exiting in random places like now.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258407027-384-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    5 ++++-
 tools/perf/util/header.c    |   22 ++++++++++++----------
 tools/perf/util/header.h    |    4 +---
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 04f335e..4c03bb7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -220,7 +220,8 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 		h_attr = header->attr[nr];
 	} else {
 		h_attr = perf_header_attr__new(a);
-		perf_header__add_attr(header, h_attr);
+		if (h_attr != NULL)
+			perf_header__add_attr(header, h_attr);
 	}
 
 	return h_attr;
@@ -308,6 +309,8 @@ try_again:
 	}
 
 	h_attr = get_header_attr(attr, counter);
+	if (h_attr == NULL)
+		die("nomem\n");
 
 	if (!file_new) {
 		if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d8416f0..2f07a23 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -19,16 +19,16 @@ struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr)
 {
 	struct perf_header_attr *self = malloc(sizeof(*self));
 
-	if (!self)
-		die("nomem");
-
-	self->attr = *attr;
-	self->ids = 0;
-	self->size = 1;
-	self->id = malloc(sizeof(u64));
-
-	if (!self->id)
-		die("nomem");
+	if (self != NULL) {
+		self->attr = *attr;
+		self->ids  = 0;
+		self->size = 1;
+		self->id   = malloc(sizeof(u64));
+		if (self->id == NULL) {
+			free(self);
+			self = NULL;
+		}
+	}
 
 	return self;
 }
@@ -423,6 +423,8 @@ struct perf_header *perf_header__read(int fd)
 		tmp = lseek(fd, 0, SEEK_CUR);
 
 		attr = perf_header_attr__new(&f_attr.attr);
+		if (attr == NULL)
+			 die("nomem");
 
 		nr_ids = f_attr.ids.size / sizeof(u64);
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index f1b3bf7..0cbd4c9 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -64,9 +64,7 @@ void perf_header__add_attr(struct perf_header *self,
 void perf_header__push_event(u64 id, const char *name);
 char *perf_header__find_event(u64 id);
 
-
-struct perf_header_attr *
-perf_header_attr__new(struct perf_event_attr *attr);
+struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
