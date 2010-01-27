Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479Ab0A0XHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0A0XHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307Ab0A0XGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:06:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0A0XGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:06:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/9] perf symbols: Factor out dso__load_vmlinux_path()
Date: Wed, 27 Jan 2010 21:05:50 -0200
Message-Id: <1264633557-17597-2-git-send-email-acme@infradead.org>
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

So that we can call it directly from regression tests, and also to
reduce the size of dso__load_kernel_sym(), making it more clear.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   38 ++++++++++++++++++++++++--------------
 tools/perf/util/symbol.h |    2 ++
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f1f609d..26ec603 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1578,6 +1578,27 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
+int dso__load_vmlinux_path(struct dso *self, struct map *map,
+			   struct perf_session *session, symbol_filter_t filter)
+{
+	int i, err = 0;
+
+	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
+		 vmlinux_path__nr_entries);
+
+	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
+		err = dso__load_vmlinux(self, map, session, vmlinux_path[i],
+					filter);
+		if (err > 0) {
+			pr_debug("Using %s for symbols\n", vmlinux_path[i]);
+			dso__set_long_name(self, strdup(vmlinux_path[i]));
+			break;
+		}
+	}
+
+	return err;
+}
+
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				struct perf_session *session, symbol_filter_t filter)
 {
@@ -1606,20 +1627,9 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 	if (vmlinux_path != NULL) {
-		int i;
-		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-			 vmlinux_path__nr_entries);
-		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-			err = dso__load_vmlinux(self, map, session,
-						vmlinux_path[i], filter);
-			if (err > 0) {
-				pr_debug("Using %s for symbols\n",
-					 vmlinux_path[i]);
-				dso__set_long_name(self,
-						   strdup(vmlinux_path[i]));
-				goto out_fixup;
-			}
-		}
+		err = dso__load_vmlinux_path(self, map, session, filter);
+		if (err > 0)
+			goto out_fixup;
 	}
 
 	/*
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ffe0b0f..a94997a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -129,6 +129,8 @@ struct perf_session;
 
 int dso__load(struct dso *self, struct map *map, struct perf_session *session,
 	      symbol_filter_t filter);
+int dso__load_vmlinux_path(struct dso *self, struct map *map,
+			   struct perf_session *session, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp, bool with_hits);
 
-- 
1.6.2.5

