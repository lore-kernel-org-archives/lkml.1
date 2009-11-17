Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZKQGd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZKQGd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZKQGdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:33:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:58655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbZKQGdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:33:52 -0500
Date: Tue, 17 Nov 2009 06:32:57 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258427892-16312-2-git-send-email-acme@infradead.org>
References: <1258427892-16312-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't die() in perf_header_attr__add_id()
Message-ID: <tip-5875412152ce67fb5087157b86ab6597f91d23e8@git.kernel.org>
Git-Commit-ID: 5875412152ce67fb5087157b86ab6597f91d23e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5875412152ce67fb5087157b86ab6597f91d23e8
Gitweb:     http://git.kernel.org/tip/5875412152ce67fb5087157b86ab6597f91d23e8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 17 Nov 2009 01:18:10 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:55 +0100

perf tools: Don't die() in perf_header_attr__add_id()

Propagate the errors instead, the users are the ones to decide
what to do if a library call fails.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258427892-16312-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
