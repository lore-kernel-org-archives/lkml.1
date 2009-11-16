Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZKPVMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZKPVMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZKPVMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:12:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:39057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZKPVMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:12:40 -0500
Date: Mon, 16 Nov 2009 21:09:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258396365-29217-1-git-send-email-acme@infradead.org>
References: <1258396365-29217-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Pass the offset to perf_header__read_build_ids()
Message-ID: <tip-84fe8488ade7922afa9f3aa77c22d2d92beb9660@git.kernel.org>
Git-Commit-ID: 84fe8488ade7922afa9f3aa77c22d2d92beb9660
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84fe8488ade7922afa9f3aa77c22d2d92beb9660
Gitweb:     http://git.kernel.org/tip/84fe8488ade7922afa9f3aa77c22d2d92beb9660
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 16:32:41 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 22:05:49 +0100

perf symbols: Pass the offset to perf_header__read_build_ids()

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258396365-29217-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
