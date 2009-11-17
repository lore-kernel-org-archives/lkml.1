Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZKQGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZKQGeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZKQGeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:34:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:58730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbZKQGeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:34:14 -0500
Date: Tue, 17 Nov 2009 06:33:13 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258427892-16312-3-git-send-email-acme@infradead.org>
References: <1258427892-16312-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't die() in perf_header__new()
Message-ID: <tip-a9a70bbce7ab0bf3b1cba3ac662c4d502da6305c@git.kernel.org>
Git-Commit-ID: a9a70bbce7ab0bf3b1cba3ac662c4d502da6305c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9a70bbce7ab0bf3b1cba3ac662c4d502da6305c
Gitweb:     http://git.kernel.org/tip/a9a70bbce7ab0bf3b1cba3ac662c4d502da6305c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 17 Nov 2009 01:18:11 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:56 +0100

perf tools: Don't die() in perf_header__new()

Propagate the errors instead, the users are the ones to decide
what to do if a library call fails.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258427892-16312-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
