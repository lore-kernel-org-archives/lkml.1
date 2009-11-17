Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZKQGeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZKQGeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZKQGeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:34:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:58714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZKQGeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:34:04 -0500
Date: Tue, 17 Nov 2009 06:33:30 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258427892-16312-4-git-send-email-acme@infradead.org>
References: <1258427892-16312-4-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't die() in do_write()
Message-ID: <tip-3726cc75e581c157202da93bb2333cce25c15c98@git.kernel.org>
Git-Commit-ID: 3726cc75e581c157202da93bb2333cce25c15c98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3726cc75e581c157202da93bb2333cce25c15c98
Gitweb:     http://git.kernel.org/tip/3726cc75e581c157202da93bb2333cce25c15c98
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 17 Nov 2009 01:18:12 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:56 +0100

perf tools: Don't die() in do_write()

Propagate the errors instead, the users are the ones to decide
what to do if a library call fails.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258427892-16312-4-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 726a0eb..b01a953 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -161,31 +161,36 @@ bool perf_header__has_feat(const struct perf_header *self, int feat)
 	return test_bit(feat, self->adds_features);
 }
 
-static void do_write(int fd, void *buf, size_t size)
+static int do_write(int fd, const void *buf, size_t size)
 {
 	while (size) {
 		int ret = write(fd, buf, size);
 
 		if (ret < 0)
-			die("failed to write");
+			return -1;
 
 		size -= ret;
 		buf += ret;
 	}
+
+	return 0;
 }
 
-static void write_buildid_table(int fd, struct list_head *id_head)
+static int write_buildid_table(int fd, struct list_head *id_head)
 {
 	struct build_id_list *iter, *next;
 
 	list_for_each_entry_safe(iter, next, id_head, list) {
 		struct build_id_event *b = &iter->event;
 
-		do_write(fd, b, sizeof(*b));
-		do_write(fd, (void *)iter->dso_name, iter->len);
+		if (do_write(fd, b, sizeof(*b)) < 0 ||
+		    do_write(fd, iter->dso_name, iter->len) < 0)
+			return -1;
 		list_del(&iter->list);
 		free(iter);
 	}
+
+	return 0;
 }
 
 static void
@@ -233,12 +238,14 @@ perf_header__adds_write(struct perf_header *self, int fd)
 
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
-		write_buildid_table(fd, &id_list);
+		if (write_buildid_table(fd, &id_list) < 0)
+			die("failed to write buildid table");
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) - buildid_sec->offset;
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
-	do_write(fd, feat_sec, sec_size);
+	if (do_write(fd, feat_sec, sec_size) < 0)
+		die("failed to write feature section");
 	free(feat_sec);
 }
 
@@ -256,7 +263,8 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 		attr = self->attr[i];
 
 		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		do_write(fd, attr->id, attr->ids * sizeof(u64));
+		if (do_write(fd, attr->id, attr->ids * sizeof(u64)) < 0)
+			die("failed to write perf header");
 	}
 
 
@@ -272,13 +280,15 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 				.size   = attr->ids * sizeof(u64),
 			}
 		};
-		do_write(fd, &f_attr, sizeof(f_attr));
+		if (do_write(fd, &f_attr, sizeof(f_attr)) < 0)
+			die("failed to write perf header attribute");
 	}
 
 	self->event_offset = lseek(fd, 0, SEEK_CUR);
 	self->event_size = event_count * sizeof(struct perf_trace_event_type);
 	if (events)
-		do_write(fd, events, self->event_size);
+		if (do_write(fd, events, self->event_size) < 0)
+			die("failed to write perf header events");
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -306,7 +316,8 @@ void perf_header__write(struct perf_header *self, int fd, bool at_exit)
 	memcpy(&f_header.adds_features, &self->adds_features, sizeof(self->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
-	do_write(fd, &f_header, sizeof(f_header));
+	if (do_write(fd, &f_header, sizeof(f_header)) < 0)
+		die("failed to write perf header");
 	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
 	self->frozen = 1;
