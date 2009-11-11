Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZKKHoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZKKHoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZKKHoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:44:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:40916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820AbZKKHoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:44:21 -0500
Date: Wed, 11 Nov 2009 07:43:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1257911467-28276-5-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-5-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use perf_header__set/has_feat whenever possible
Message-ID: <tip-3e13ab2d83b6867a20663c73c184f29c2fde1558@git.kernel.org>
Git-Commit-ID: 3e13ab2d83b6867a20663c73c184f29c2fde1558
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e13ab2d83b6867a20663c73c184f29c2fde1558
Gitweb:     http://git.kernel.org/tip/3e13ab2d83b6867a20663c73c184f29c2fde1558
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Nov 2009 04:51:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 07:30:19 +0100

perf tools: Use perf_header__set/has_feat whenever possible

And drop the alternate checks/sets using set_bit or other kind
of helpers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <1257911467-28276-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    4 ++--
 tools/perf/util/header.c    |   12 ++----------
 tools/perf/util/header.h    |    1 -
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c35e61b..326e8a7 100644
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
 
