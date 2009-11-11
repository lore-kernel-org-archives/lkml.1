Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZKKDvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZKKDvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZKKDvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:51:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:49171 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbZKKDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PVA8oomZvYEBFw2NlV181R17AopPa8/hGW6wJvQGGzKXcs1qqAxrdHwv3CLxWbo6d/
         jF12fcOVpyzZpei+nE9LMKK2EYqEUyffkET9Ul2en7F9h6zEOea8WgWimC/Q1jlXcNOn
         i3L3ouSKsc9PsRXISJ1rvu0J8GveCp5Xj0qiA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 4/6] perf tools: Read the build-ids from the header layer
Date: Wed, 11 Nov 2009 04:51:05 +0100
Message-Id: <1257911467-28276-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the build-ids reading implementation in the data mapping but move
its call to the headers so that we have a better control on it
(offset seeking, size passing, etc..).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/util/data_map.c |    8 ++------
 tools/perf/util/data_map.h |    2 ++
 tools/perf/util/header.c   |   14 ++++++++++++--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 00a9c11..66e58aa 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -70,8 +70,8 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
-static int perf_header__read_build_ids(const struct perf_header *self,
-				       int input, off_t file_size)
+int perf_header__read_build_ids(const struct perf_header *self,
+				int input, off_t file_size)
 {
 	off_t offset = self->data_offset + self->data_size;
 	struct build_id_event bev;
@@ -163,10 +163,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		if (curr_handler->sample_type_check(sample_type) < 0)
 			exit(-1);
 
-	if (perf_header__has_feat(header, HEADER_BUILD_ID) &&
-	    perf_header__read_build_ids(header, input, input_stat.st_size))
-		pr_debug("failed to read buildids, continuing...\n");
-
 	if (load_kernel(NULL) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 716d105..c412281 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -27,5 +27,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int full_paths,
 			    int *cwdlen,
 			    char **cwd);
+int perf_header__read_build_ids(const struct perf_header *self,
+				int input, off_t file_size);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2f702c2..915b56e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -9,6 +9,8 @@
 #include "../perf.h"
 #include "trace-event.h"
 #include "symbol.h"
+#include "data_map.h"
+#include "debug.h"
 
 /*
  * Create new perf.data header attribute:
@@ -322,6 +324,14 @@ static void perf_header__adds_read(struct perf_header *self, int fd)
 		trace_report(fd);
 		lseek(fd, trace_sec.offset + trace_sec.size, SEEK_SET);
 	}
+
+	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
+		struct stat input_stat;
+
+		fstat(fd, &input_stat);
+		if (perf_header__read_build_ids(self, fd, input_stat.st_size))
+			pr_debug("failed to read buildids, continuing...\n");
+	}
 };
 
 struct perf_header *perf_header__read(int fd)
@@ -382,14 +392,14 @@ struct perf_header *perf_header__read(int fd)
 
 	memcpy(&self->adds_features, &f_header.adds_features, sizeof(f_header.adds_features));
 
-	perf_header__adds_read(self, fd);
-
 	self->event_offset = f_header.event_types.offset;
 	self->event_size   = f_header.event_types.size;
 
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
+	perf_header__adds_read(self, fd);
+
 	lseek(fd, self->data_offset, SEEK_SET);
 
 	self->frozen = 1;
-- 
1.6.2.3

