Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZIWLuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZIWLuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZIWLuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:50:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:43401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZIWLuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:50:02 -0400
Date: Wed, 23 Sep 2009 11:49:18 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu, avi@redhat.com
In-Reply-To: <1253697658.11461.36.camel@marge.simson.net>
References: <1253697658.11461.36.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix module symbol loading bug
Message-ID: <tip-508c4d0874acf8584787bbab7e4a3798e2834c1a@git.kernel.org>
Git-Commit-ID: 508c4d0874acf8584787bbab7e4a3798e2834c1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 11:49:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  508c4d0874acf8584787bbab7e4a3798e2834c1a
Gitweb:     http://git.kernel.org/tip/508c4d0874acf8584787bbab7e4a3798e2834c1a
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 23 Sep 2009 11:20:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 13:45:48 +0200

perf tools: Fix module symbol loading bug

Avi Kivity reported 'perf annotate' failures with modules, the
requested function was not annotated.

If there are no modules currently loaded, or the last module
scanned is not loaded, dso__load_modules() steps on the value from
dso__load_vmlinux(), so we happily load the kallsyms symbols on top
of what we've already loaded.

Fix that such that the total count of symbols loaded is returned.
Should module symbol load fail after parsing of vmlinux, is's a
hard failure, so do not silently fall-back to kallsyms.

Reported-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: rostedt@goodmis.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <1253697658.11461.36.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/symbol.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fd3d9c8..559fb06 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -833,7 +833,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
 	struct mod_dso *mods = mod_dso__new_dso("modules");
 	struct module *pos;
 	struct rb_node *next;
-	int err;
+	int err, count = 0;
 
 	err = mod_dso__load_modules(mods);
 
@@ -852,14 +852,16 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
 			break;
 
 		next = rb_next(&pos->rb_node);
+		count += err;
 	}
 
 	if (err < 0) {
 		mod_dso__delete_modules(mods);
 		mod_dso__delete_self(mods);
+		return err;
 	}
 
-	return err;
+	return count;
 }
 
 static inline void dso__fill_symbol_holes(struct dso *self)
@@ -913,8 +915,15 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 
 	if (vmlinux) {
 		err = dso__load_vmlinux(self, vmlinux, filter, v);
-		if (err > 0 && use_modules)
-			err = dso__load_modules(self, filter, v);
+		if (err > 0 && use_modules) {
+			int syms = dso__load_modules(self, filter, v);
+
+			if (syms < 0) {
+				fprintf(stderr, "dso__load_modules failed!\n");
+				return syms;
+			}
+			err += syms;
+		}
 	}
 
 	if (err <= 0)
