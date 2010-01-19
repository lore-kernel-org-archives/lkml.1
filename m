Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434Ab0ASMg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0ASMg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489Ab0ASMg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:36:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0ASMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:36:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jamie Iles <jamie.iles@picochip.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf symbols: If only --vmlinux if specified
Date: Tue, 19 Jan 2010 10:36:14 -0200
Message-Id: <1263904574-30732-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263904574-30732-1-git-send-email-acme@infradead.org>
References: <1263904574-30732-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Found while analysing a perf.data file collected on an ARM machine where
an explicitely specified vmlinux was being disregarded.

Reported-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Jamie Iles <jamie.iles@picochip.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   67 ++++++++++++++++++++++++++++------------------
 1 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a4e7459..b6ab23d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1572,7 +1572,7 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, session, self->long_name, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, session, vmlinux, fd, filter, 1, 0);
 	close(fd);
 
 	return err;
@@ -1584,6 +1584,26 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	int err;
 	const char *kallsyms_filename = NULL;
 	char *kallsyms_allocated_filename = NULL;
+	/*
+	 * Step 1: if the user specified a vmlinux filename, use it and only
+	 * it, reporting errors to the user if it cannot be used.
+	 *
+	 * For instance, try to analyse an ARM perf.data file _without_ a
+	 * build-id, or if the user specifies the wrong path to the right
+	 * vmlinux file, obviously we can't fallback to another vmlinux (a
+	 * x86_86 one, on the machine where analysis is being performed, say),
+	 * or worse, /proc/kallsyms.
+	 *
+	 * If the specified file _has_ a build-id and there is a build-id
+	 * section in the perf.data file, we will still do the expected
+	 * validation in dso__load_vmlinux and will bail out if they don't
+	 * match.
+	 */
+	if (symbol_conf.vmlinux_name != NULL) {
+		err = dso__load_vmlinux(self, map, session,
+					symbol_conf.vmlinux_name, filter);
+		goto out_try_fixup;
+	}
 
 	if (vmlinux_path != NULL) {
 		int i;
@@ -1618,46 +1638,41 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 				goto do_kallsyms;
 			}
 		}
-
+		/*
+		 * Now look if we have it on the build-id cache in
+		 * $HOME/.debug/[kernel.kallsyms].
+		 */
 		build_id__sprintf(self->build_id, sizeof(self->build_id),
 				  sbuild_id);
 
 		if (asprintf(&kallsyms_allocated_filename,
 			     "%s/.debug/[kernel.kallsyms]/%s",
-			     getenv("HOME"), sbuild_id) != -1) {
-			if (access(kallsyms_filename, F_OK)) {
-				kallsyms_filename = kallsyms_allocated_filename;
-				goto do_kallsyms;
-			}
+			     getenv("HOME"), sbuild_id) == -1)
+			return -1;
+
+		if (access(kallsyms_filename, F_OK)) {
 			free(kallsyms_allocated_filename);
-			kallsyms_allocated_filename = NULL;
+			return -1;
 		}
 
-		goto do_vmlinux;
-	}
-
-	if (self->long_name[0] == '[') {
+		kallsyms_filename = kallsyms_allocated_filename;
+	} else {
+		/*
+		 * Last resort, if we don't have a build-id and couldn't find
+		 * any vmlinux file, try the running kernel kallsyms table.
+		 */
 		kallsyms_filename = "/proc/kallsyms";
-		goto do_kallsyms;
 	}
 
-do_vmlinux:
-	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
-	if (err <= 0) {
-		if (self->has_build_id)
-			return -1;
-
-		pr_info("The file %s cannot be used, "
-			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, kallsyms_filename, map, session, filter);
-		if (err > 0 && kallsyms_filename == NULL)
-                        dso__set_long_name(self, strdup("[kernel.kallsyms]"));
-		free(kallsyms_allocated_filename);
-	}
+	err = dso__load_kallsyms(self, kallsyms_filename, map, session, filter);
+	free(kallsyms_allocated_filename);
 
+out_try_fixup:
 	if (err > 0) {
 out_fixup:
+		if (kallsyms_filename == NULL)
+			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
-- 
1.6.2.5

