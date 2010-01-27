Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475Ab0A0XGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0A0XGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297Ab0A0XGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:06:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0A0XGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:06:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/9] perf session: Create kernel maps in the constructor
Date: Wed, 27 Jan 2010 21:05:52 -0200
Message-Id: <1264633557-17597-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264633557-17597-1-git-send-email-acme@infradead.org>
References: <1264633557-17597-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing one extra step needed in the tools that need this, fixing a bug
in 'perf probe' where this was not being done.

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c   |    5 -----
 tools/perf/builtin-record.c |    5 -----
 tools/perf/builtin-top.c    |    5 -----
 tools/perf/util/session.c   |   13 +++++++++++--
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index e8d716b..5d5dc6b 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -491,11 +491,6 @@ static int __cmd_kmem(void)
 	if (!perf_session__has_traces(session, "kmem record"))
 		goto out_delete;
 
-	if (perf_session__create_kernel_maps(session) < 0) {
-		pr_err("Problems creating kernel maps\n");
-		return -1;
-	}
-
 	setup_pager();
 	err = perf_session__process_events(session, &event_ops);
 	if (err != 0)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7bb9ca1..9034522 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -477,11 +477,6 @@ static int __cmd_record(int argc, const char **argv)
 		return -1;
 	}
 
-	if (perf_session__create_kernel_maps(session) < 0) {
-		pr_err("Problems creating kernel maps\n");
-		return -1;
-	}
-
 	if (!file_new) {
 		err = perf_header__read(&session->header, output);
 		if (err < 0)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 78f9c45..1fc018e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1191,11 +1191,6 @@ static int __cmd_top(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (perf_session__create_kernel_maps(session) < 0) {
-		pr_err("Problems creating kernel maps\n");
-		return -1;
-	}
-
 	if (target_pid != -1)
 		event__synthesize_thread(target_pid, event__process, session);
 	else
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1951e33..8e7c189 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,8 +70,17 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->unknown_events = 0;
 	map_groups__init(&self->kmaps);
 
-	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
-		goto out_delete;
+	if (mode == O_RDONLY) {
+		if (perf_session__open(self, force) < 0)
+			goto out_delete;
+	} else if (mode == O_WRONLY) {
+		/*
+		 * In O_RDONLY mode this will be performed when reading the
+		 * kernel MMAP event, in event__process_mmap().
+		 */
+		if (perf_session__create_kernel_maps(self) < 0)
+			goto out_delete;
+	}
 
 	self->sample_type = perf_header__sample_type(&self->header);
 out:
-- 
1.6.2.5

