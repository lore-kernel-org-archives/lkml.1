Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZKPSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZKPSdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZKPSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:32:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:55706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZKPScy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:32:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/5] perf symbols: pass the offset to perf_header__read_build_ids
Date: Mon, 16 Nov 2009 16:32:41 -0200
Message-Id: <1258396365-29217-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data_map.c |    3 +--
 tools/perf/util/data_map.h |    2 +-
 tools/perf/util/header.c   |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index aacb814..14cb846 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -70,11 +70,10 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
-int perf_header__read_build_ids(int input, off_t size)
+int perf_header__read_build_ids(int input, off_t offset, off_t size)
 {
 	struct build_id_event bev;
 	char filename[PATH_MAX];
-	off_t offset = lseek(input, 0, SEEK_CUR);
 	off_t limit = offset + size;
 	int err = -1;
 
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 20b4037..ae036ec 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -27,6 +27,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int full_paths,
 			    int *cwdlen,
 			    char **cwd);
-int perf_header__read_build_ids(int input, off_t file_size);
+int perf_header__read_build_ids(int input, off_t offset, off_t file_size);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ebed4f4..ca0d657 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -359,7 +359,7 @@ static void perf_header__adds_read(struct perf_header *self, int fd)
 
 		buildid_sec = &feat_sec[idx++];
 		lseek(fd, buildid_sec->offset, SEEK_SET);
-		if (perf_header__read_build_ids(fd, buildid_sec->size))
+		if (perf_header__read_build_ids(fd, buildid_sec->offset, buildid_sec->size))
 			pr_debug("failed to read buildids, continuing...\n");
 	}
 
-- 
1.6.2.5

