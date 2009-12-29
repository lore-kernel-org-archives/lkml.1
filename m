Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZL2Atj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZL2Atj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZL2Atg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:49:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZL2Asr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:48:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/5] perf header: do_read shouldn't die
Date: Mon, 28 Dec 2009 22:48:32 -0200
Message-Id: <1262047716-23171-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Propagate the errors instead, its callers already propagate other
errors.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index df237c3..6b3cb94 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -432,19 +432,19 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 	return 0;
 }
 
-static void do_read(int fd, void *buf, size_t size)
+static int do_read(int fd, void *buf, size_t size)
 {
 	while (size) {
 		int ret = read(fd, buf, size);
 
-		if (ret < 0)
-			die("failed to read");
-		if (ret == 0)
-			die("failed to read: missing data");
+		if (ret <= 0)
+			return -1;
 
 		size -= ret;
 		buf += ret;
 	}
+
+	return 0;
 }
 
 int perf_header__process_sections(struct perf_header *self, int fd,
@@ -455,7 +455,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 	int nr_sections;
 	int sec_size;
 	int idx = 0;
-	int err = 0, feat = 1;
+	int err = -1, feat = 1;
 
 	nr_sections = bitmap_weight(self->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
@@ -469,8 +469,10 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
-	do_read(fd, feat_sec, sec_size);
+	if (do_read(fd, feat_sec, sec_size))
+		goto out_free;
 
+	err = 0;
 	while (idx < nr_sections && feat < HEADER_LAST_FEATURE) {
 		if (perf_header__has_feat(self, feat)) {
 			struct perf_file_section *sec = &feat_sec[idx++];
@@ -481,18 +483,18 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 		}
 		++feat;
 	}
-
+out_free:
 	free(feat_sec);
 	return err;
-};
+}
 
 int perf_file_header__read(struct perf_file_header *self,
 			   struct perf_header *ph, int fd)
 {
 	lseek(fd, 0, SEEK_SET);
-	do_read(fd, self, sizeof(*self));
 
-	if (self->magic     != PERF_MAGIC ||
+	if (do_read(fd, self, sizeof(*self)) ||
+	    self->magic     != PERF_MAGIC ||
 	    self->attr_size != sizeof(struct perf_file_attr))
 		return -1;
 
@@ -558,7 +560,8 @@ int perf_header__read(struct perf_header *self, int fd)
 		struct perf_header_attr *attr;
 		off_t tmp;
 
-		do_read(fd, &f_attr, sizeof(f_attr));
+		if (do_read(fd, &f_attr, sizeof(f_attr)))
+			goto out_errno;
 		tmp = lseek(fd, 0, SEEK_CUR);
 
 		attr = perf_header_attr__new(&f_attr.attr);
@@ -569,7 +572,8 @@ int perf_header__read(struct perf_header *self, int fd)
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
 
 		for (j = 0; j < nr_ids; j++) {
-			do_read(fd, &f_id, sizeof(f_id));
+			if (do_read(fd, &f_id, sizeof(f_id)))
+				goto out_errno;
 
 			if (perf_header_attr__add_id(attr, f_id) < 0) {
 				perf_header_attr__delete(attr);
@@ -589,7 +593,8 @@ int perf_header__read(struct perf_header *self, int fd)
 		events = malloc(f_header.event_types.size);
 		if (events == NULL)
 			return -ENOMEM;
-		do_read(fd, events, f_header.event_types.size);
+		if (do_read(fd, events, f_header.event_types.size))
+			goto out_errno;
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
 
@@ -599,6 +604,8 @@ int perf_header__read(struct perf_header *self, int fd)
 
 	self->frozen = 1;
 	return 0;
+out_errno:
+	return -errno;
 }
 
 u64 perf_header__sample_type(struct perf_header *header)
-- 
1.5.5.1

