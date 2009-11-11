Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZKKDvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZKKDvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbZKKDvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:51:19 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49226 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZKKDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cQoF/V+Vy2HOoc5NftvK0aJlg3kAF+NUyuqttDDKBMCqdtcwxcuYM/CDRhCodM8aBm
         u0kSFLhiRyBUsN+jsg2m9UAnYV9NuIw1fNLPecT6VK7GojNlJtsKsP3T5aEDBpoTREna
         9Jm/Yn5B3kNB9hqT9X4U4Bw5Ix4m3OmrbsbBU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 5/6] perf tools: Use perf_header__set/has_feat whenever possible
Date: Wed, 11 Nov 2009 04:51:06 +0100
Message-Id: <1257911467-28276-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And drop the alternate checks/sets using set_bit or other kind of
helpers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-record.c |    4 ++--
 tools/perf/util/header.c    |   12 ++----------
 tools/perf/util/header.h    |    1 -
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3044a62..04f335e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -431,11 +431,11 @@ static int __cmd_record(int argc, const char **argv)
 		header = perf_header__new();
 
 	if (raw_samples) {
-		perf_header__feat_trace_info(header);
+		perf_header__set_feat(header, HEADER_TRACE_INFO);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
 			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
-				perf_header__feat_trace_info(header);
+				perf_header__set_feat(header, HEADER_TRACE_INFO);
 				break;
 			}
 		}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 915b56e..9709d38 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -148,11 +148,6 @@ struct perf_file_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
-void perf_header__feat_trace_info(struct perf_header *header)
-{
-	set_bit(HEADER_TRACE_INFO, header->adds_features);
-}
-
 void perf_header__set_feat(struct perf_header *self, int feat)
 {
 	set_bit(feat, self->adds_features);
@@ -195,9 +190,8 @@ perf_header__adds_write(struct perf_header *self, int fd, bool at_exit)
 {
 	struct perf_file_section trace_sec;
 	u64 cur_offset = lseek(fd, 0, SEEK_CUR);
-	unsigned long *feat_mask = self->adds_features;
 
-	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
+	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
 		/* Write trace info */
 		trace_sec.offset = lseek(fd, sizeof(trace_sec), SEEK_CUR);
 		read_tracing_data(fd, attrs, nr_counters);
@@ -314,9 +308,7 @@ static void do_read(int fd, void *buf, size_t size)
 
 static void perf_header__adds_read(struct perf_header *self, int fd)
 {
-	const unsigned long *feat_mask = self->adds_features;
-
-	if (test_bit(HEADER_TRACE_INFO, feat_mask)) {
+	if (perf_header__has_feat(self, HEADER_TRACE_INFO)) {
 		struct perf_file_section trace_sec;
 
 		do_read(fd, &trace_sec, sizeof(trace_sec));
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 77186c9..a22d70b 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -49,7 +49,6 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
-void perf_header__feat_trace_info(struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
 bool perf_header__has_feat(const struct perf_header *self, int feat);
 
-- 
1.6.2.3

