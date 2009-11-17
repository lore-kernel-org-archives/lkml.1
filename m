Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZKQUie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZKQUie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZKQUic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:38:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZKQUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:38:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf top: Allocate space only for the number of counters used
Date: Tue, 17 Nov 2009 18:38:01 -0200
Message-Id: <1258490282-1821-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258490282-1821-1-git-send-email-acme@infradead.org>
References: <1258490282-1821-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reducing memory consumption on a typical desktop machine:

From:

32710 root      20   0  172m 142m 1056 S  0.0  4.7   0:00.37 perf

To:

  420 root      20   0 47528  16m 1056 R  0.3  0.5   0:00.24 perf

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0d60c51..49cf876 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -111,7 +111,6 @@ static int			display_weighted		=     -1;
 struct sym_entry {
 	struct rb_node		rb_node;
 	struct list_head	node;
-	unsigned long		count[MAX_COUNTERS];
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
@@ -122,6 +121,7 @@ struct sym_entry {
 	struct source_line	*lines;
 	struct source_line	**lines_tail;
 	pthread_mutex_t		source_lock;
+	unsigned long		count[0];
 };
 
 /*
@@ -130,7 +130,7 @@ struct sym_entry {
 
 static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
 {
-       return (struct symbol *)(self + 1);
+       return ((void *)self) + symbol__priv_size;
 }
 
 static void get_term_dimensions(struct winsize *ws)
@@ -1314,8 +1314,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
-	symbol__init(sizeof(struct sym_entry));
-
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
@@ -1332,6 +1330,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (!nr_counters)
 		nr_counters = 1;
 
+	symbol__init(sizeof(struct sym_entry) +
+		     (nr_counters + 1) * sizeof(unsigned long));
+
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-- 
1.6.2.5

