Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZLIWKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZLIWKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZLIWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:10:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbZLIWKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:10:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf symbols: perf_header__read_build_ids offset'n'size should be u64
Date: Wed,  9 Dec 2009 20:09:38 -0200
Message-Id: <1260396578-19116-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260396578-19116-1-git-send-email-acme@infradead.org>
References: <1260396578-19116-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As off_t is a long, so breaking things on 32-bit land. Now buildids work
on 32-bit land.

[root@ana ~]# uname -a
Linux ana.ghostprotocols.net 2.6.31.6-162.fc12.i686 #1 SMP Fri Dec 4 01:09:09 EST 2009 i686 i686 i386 GNU/Linux
[root@ana ~]# perf buildid-list | tail -5
136ee6792ba2ae57870ecd87369f4ae3194d5b27 /lib/libreadline.so.6.0
d202dcb1ad48d140065783657d37ae3f2d9ab83f /usr/bin/gdb
0a56c0c00dcc2e9e581ae9997f31957c9c4671df /usr/lib/libdwarf.so.0.0
5f9e6ac95241cbb3227608e0ff2a2e0cbbe72439 /home/acme/bin/perf
925d19eccc2ddb1c9d74dd178a011426f1b124a8 /bin/sleep
[root@ana ~]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data_map.c |    4 ++--
 tools/perf/util/data_map.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index ca0bedf..59b65d0 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -100,11 +100,11 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
-int perf_header__read_build_ids(int input, off_t offset, off_t size)
+int perf_header__read_build_ids(int input, u64 offset, u64 size)
 {
 	struct build_id_event bev;
 	char filename[PATH_MAX];
-	off_t limit = offset + size;
+	u64 limit = offset + size;
 	int err = -1;
 
 	while (offset < limit) {
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 3180ff7..258a87b 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -27,6 +27,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int full_paths,
 			    int *cwdlen,
 			    char **cwd);
-int perf_header__read_build_ids(int input, off_t offset, off_t file_size);
+int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif
-- 
1.6.5.2

