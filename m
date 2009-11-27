Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZK0S3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZK0S3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZK0S3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZK0S3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 10/12] perf symbols: When not using modules, discard its symbols
Date: Fri, 27 Nov 2009 16:29:21 -0200
Message-Id: <1259346563-12568-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-9-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
 <1259346563-12568-3-git-send-email-acme@infradead.org>
 <1259346563-12568-4-git-send-email-acme@infradead.org>
 <1259346563-12568-5-git-send-email-acme@infradead.org>
 <1259346563-12568-6-git-send-email-acme@infradead.org>
 <1259346563-12568-7-git-send-email-acme@infradead.org>
 <1259346563-12568-8-git-send-email-acme@infradead.org>
 <1259346563-12568-9-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    6 +++++-
 tools/perf/util/thread.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b6a2941..b788c2f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -381,6 +381,9 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 
 		module = strchr(pos->name, '\t');
 		if (module) {
+			if (!thread->use_modules)
+				goto discard_symbol;
+
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
@@ -420,7 +423,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map, struct thread
 		}
 
 		if (filter && filter(curr_map, pos)) {
-			rb_erase(&pos->rb_node, root);
+discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
 		} else {
 			if (curr_map != map) {
@@ -1635,6 +1638,7 @@ int symbol__init(struct symbol_conf *conf)
 		return -1;
 	}
 
+	kthread->use_modules = pconf->use_modules;
 	if (pconf->use_modules && thread__create_module_maps(kthread) < 0)
 		pr_debug("Failed to load list of modules in use, "
 			 "continuing...\n");
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 3bdd9b2..59b0d9b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -10,6 +10,7 @@ struct thread {
 	struct rb_root		maps[MAP__NR_TYPES];
 	struct list_head	removed_maps[MAP__NR_TYPES];
 	pid_t			pid;
+	bool			use_modules;
 	char			shortname[3];
 	char			*comm;
 	int			comm_len;
-- 
1.6.2.5

