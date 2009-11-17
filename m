Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZKQGdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZKQGdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZKQGdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:33:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:58631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbZKQGdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:33:35 -0500
Date: Tue, 17 Nov 2009 06:32:42 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258427892-16312-1-git-send-email-acme@infradead.org>
References: <1258427892-16312-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't die() in perf_header__add_attr()
Message-ID: <tip-11deb1f9f6ca6318fa9470e024b9f0634df48b4c@git.kernel.org>
Git-Commit-ID: 11deb1f9f6ca6318fa9470e024b9f0634df48b4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11deb1f9f6ca6318fa9470e024b9f0634df48b4c
Gitweb:     http://git.kernel.org/tip/11deb1f9f6ca6318fa9470e024b9f0634df48b4c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 17 Nov 2009 01:18:09 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:54 +0100

perf tools: Don't die() in perf_header__add_attr()

Propagate the errors instead, the users are the ones to decide
what to do if a library call fails.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258427892-16312-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    5 ++++-
 tools/perf/util/header.c    |   30 ++++++++++++++++++++++--------
 tools/perf/util/header.h    |    6 ++++--
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4c03bb7..5411be4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -221,7 +221,10 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	} else {
 		h_attr = perf_header_attr__new(a);
 		if (h_attr != NULL)
-			perf_header__add_attr(header, h_attr);
+			if (perf_header__add_attr(header, h_attr) < 0) {
+				perf_header_attr__delete(h_attr);
+				h_attr = NULL;
+			}
 	}
 
 	return h_attr;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2f07a23..23ccdda 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -33,6 +33,12 @@ struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr)
 	return self;
 }
 
+void perf_header_attr__delete(struct perf_header_attr *self)
+{
+	free(self->id);
+	free(self);
+}
+
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 {
 	int pos = self->ids;
@@ -66,22 +72,28 @@ struct perf_header *perf_header__new(void)
 	return self;
 }
 
-void perf_header__add_attr(struct perf_header *self,
-			   struct perf_header_attr *attr)
+int perf_header__add_attr(struct perf_header *self,
+			  struct perf_header_attr *attr)
 {
 	int pos = self->attrs;
 
 	if (self->frozen)
-		die("frozen");
+		return -1;
 
 	self->attrs++;
 	if (self->attrs > self->size) {
-		self->size *= 2;
-		self->attr = realloc(self->attr, self->size * sizeof(void *));
-		if (!self->attr)
-			die("nomem");
+		int nsize = self->size * 2;
+		struct perf_header_attr **nattr;
+
+		nattr = realloc(self->attr, nsize * sizeof(void *));
+		if (nattr == NULL)
+			return -1;
+
+		self->size = nsize;
+		self->attr = nattr;
 	}
 	self->attr[pos] = attr;
+	return 0;
 }
 
 #define MAX_EVENT_NAME 64
@@ -434,7 +446,9 @@ struct perf_header *perf_header__read(int fd)
 
 			perf_header_attr__add_id(attr, f_id);
 		}
-		perf_header__add_attr(self, attr);
+		if (perf_header__add_attr(self, attr) < 0)
+			 die("nomem");
+
 		lseek(fd, tmp, SEEK_SET);
 	}
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0cbd4c9..b0d5cd7 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -58,13 +58,15 @@ struct perf_header {
 struct perf_header *perf_header__read(int fd);
 void perf_header__write(struct perf_header *self, int fd, bool at_exit);
 
-void perf_header__add_attr(struct perf_header *self,
-			   struct perf_header_attr *attr);
+int perf_header__add_attr(struct perf_header *self,
+			  struct perf_header_attr *attr);
 
 void perf_header__push_event(u64 id, const char *name);
 char *perf_header__find_event(u64 id);
 
 struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
+void perf_header_attr__delete(struct perf_header_attr *self);
+
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
