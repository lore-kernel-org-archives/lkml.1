Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0BTBCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:02:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:35005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0BTBC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:02:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: Don't use parent comm if not set at fork time
Date: Fri, 19 Feb 2010 23:02:07 -0200
Message-Id: <1266627727-19715-1-git-send-email-acme@infradead.org>
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

As the parent comm then is worthless, confusing users about the thread where
the sample really happened, leading to think that the sample happened in the
parent, not where it really happened, in the children of a thread for which a
PERF_RECORD_COMM event was not received.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |   18 ++++++++++++------
 tools/perf/util/thread.h |    1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 634b7f7..9e8995e 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -36,7 +36,10 @@ int thread__set_comm(struct thread *self, const char *comm)
 	if (self->comm)
 		free(self->comm);
 	self->comm = strdup(comm);
-	return self->comm ? 0 : -ENOMEM;
+	if (self->comm == NULL)
+		return -ENOMEM;
+	self->comm_set = true;
+	return 0;
 }
 
 int thread__comm_len(struct thread *self)
@@ -255,11 +258,14 @@ int thread__fork(struct thread *self, struct thread *parent)
 {
 	int i;
 
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(parent->comm);
-	if (!self->comm)
-		return -ENOMEM;
+	if (parent->comm_set) {
+		if (self->comm)
+			free(self->comm);
+		self->comm = strdup(parent->comm);
+		if (!self->comm)
+			return -ENOMEM;
+		self->comm_set = true;
+	}
 
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 56f317b..0a28f39 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -15,6 +15,7 @@ struct thread {
 	struct map_groups	mg;
 	pid_t			pid;
 	char			shortname[3];
+	bool			comm_set;
 	char			*comm;
 	int			comm_len;
 };
-- 
1.5.5.1

