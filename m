Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZKQDSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZKQDSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZKQDSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:18:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:41293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbZKQDSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:18:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] perf tools: Don't die() in perf_header_attr__add_id
Date: Tue, 17 Nov 2009 01:18:10 -0200
Message-Id: <1258427892-16312-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258427892-16312-1-git-send-email-acme@infradead.org>
References: <1258427892-16312-1-git-send-email-acme@infradead.org>
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
 tools/perf/builtin-record.c |    5 ++++-
 tools/perf/util/header.c    |   18 ++++++++++++------
 tools/perf/util/header.h    |    2 +-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5411be4..2a85205 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -327,7 +327,10 @@ try_again:
 		exit(-1);
 	}
 
-	perf_header_attr__add_id(h_attr, read_data.id);
+	if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+		pr_warning("Not enough memory to add id\n");
+		exit(-1);
+	}
 
 	assert(fd[nr_cpu][counter] >= 0);
 	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 23ccdda..dee1ed2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -39,18 +39,23 @@ void perf_header_attr__delete(struct perf_header_attr *self)
 	free(self);
 }
 
-void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
+int perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 {
 	int pos = self->ids;
 
 	self->ids++;
 	if (self->ids > self->size) {
-		self->size *= 2;
-		self->id = realloc(self->id, self->size * sizeof(u64));
-		if (!self->id)
-			die("nomem");
+		int nsize = self->size * 2;
+		u64 *nid = realloc(self->id, nsize * sizeof(u64));
+
+		if (nid == NULL)
+			return -1;
+
+		self->size = nsize;
+		self->id = nid;
 	}
 	self->id[pos] = id;
+	return 0;
 }
 
 /*
@@ -444,7 +449,8 @@ struct perf_header *perf_header__read(int fd)
 		for (j = 0; j < nr_ids; j++) {
 			do_read(fd, &f_id, sizeof(f_id));
 
-			perf_header_attr__add_id(attr, f_id);
+			if (perf_header_attr__add_id(attr, f_id) < 0)
+				die("nomem");
 		}
 		if (perf_header__add_attr(self, attr) < 0)
 			 die("nomem");
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index b0d5cd7..f46a94e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -67,7 +67,7 @@ char *perf_header__find_event(u64 id);
 struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
 void perf_header_attr__delete(struct perf_header_attr *self);
 
-void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
+int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
-- 
1.6.2.5

