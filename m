Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbZIXLDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbZIXLDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZIXLDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:03:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZIXLDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:03:06 -0400
Date: Thu, 24 Sep 2009 11:01:35 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu, avi@redhat.com
In-Reply-To: <1253779628.10513.8.camel@marge.simson.net>
References: <1253779628.10513.8.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Handle relative paths while loading module symbols
Message-ID: <tip-dd906a0fe8d78b925702cd3916a65f34dfdfc011@git.kernel.org>
Git-Commit-ID: dd906a0fe8d78b925702cd3916a65f34dfdfc011
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 11:01:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd906a0fe8d78b925702cd3916a65f34dfdfc011
Gitweb:     http://git.kernel.org/tip/dd906a0fe8d78b925702cd3916a65f34dfdfc011
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 24 Sep 2009 10:07:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 11:40:35 +0200

perf tools: Handle relative paths while loading module symbols

Inform util/module.c::mod_dso__load_module_paths() that relative
paths do exist in some modules.dep, and make it fail noisily should
it encounter a path that it doesn't understand, or a module it
cannot open.

Reported-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: rostedt@goodmis.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <1253779628.10513.8.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/module.c |   96 +++++++++++++++++++++++++++++++--------------
 1 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
index 3d567fe..8f81622 100644
--- a/tools/perf/util/module.c
+++ b/tools/perf/util/module.c
@@ -4,6 +4,7 @@
 #include "module.h"
 
 #include <libelf.h>
+#include <libgen.h>
 #include <gelf.h>
 #include <elf.h>
 #include <dirent.h>
@@ -409,35 +410,40 @@ out_failure:
 static int mod_dso__load_module_paths(struct mod_dso *self)
 {
 	struct utsname uts;
-	int count = 0, len;
+	int count = 0, len, err = -1;
 	char *line = NULL;
 	FILE *file;
-	char *path;
+	char *dpath, *dir;
 	size_t n;
 
 	if (uname(&uts) < 0)
-		goto out_failure;
+		return err;
 
 	len = strlen("/lib/modules/");
 	len += strlen(uts.release);
 	len += strlen("/modules.dep");
 
-	path = calloc(1, len);
-	if (path == NULL)
-		goto out_failure;
+	dpath = calloc(1, len);
+	if (dpath == NULL)
+		return err;
 
-	strcat(path, "/lib/modules/");
-	strcat(path, uts.release);
-	strcat(path, "/modules.dep");
+	strcat(dpath, "/lib/modules/");
+	strcat(dpath, uts.release);
+	strcat(dpath, "/modules.dep");
 
-	file = fopen(path, "r");
-	free(path);
+	file = fopen(dpath, "r");
 	if (file == NULL)
 		goto out_failure;
 
+	dir = dirname(dpath);
+	if (!dir)
+		goto out_failure;
+	strcat(dir, "/");
+
 	while (!feof(file)) {
-		char *name, *tmp;
 		struct module *module;
+		char *name, *path, *tmp;
+		FILE *modfile;
 		int line_len;
 
 		line_len = getline(&line, &n, file);
@@ -445,17 +451,41 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 			break;
 
 		if (!line)
-			goto out_failure;
+			break;
 
 		line[--line_len] = '\0'; /* \n */
 
-		path = strtok(line, ":");
+		path = strchr(line, ':');
+		if (!path)
+			break;
+		*path = '\0';
+
+		path = strdup(line);
 		if (!path)
-			goto out_failure;
+			break;
+
+		if (!strstr(path, dir)) {
+			if (strncmp(path, "kernel/", 7))
+				break;
+
+			free(path);
+			path = calloc(1, strlen(dir) + strlen(line) + 1);
+			if (!path)
+				break;
+			strcat(path, dir);
+			strcat(path, line);
+		}
+
+		modfile = fopen(path, "r");
+		if (modfile == NULL)
+			break;
+		fclose(modfile);
 
 		name = strdup(path);
-		name = strtok(name, "/");
+		if (!name)
+			break;
 
+		name = strtok(name, "/");
 		tmp = name;
 
 		while (tmp) {
@@ -463,26 +493,25 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 			if (tmp)
 				name = tmp;
 		}
+
 		name = strsep(&name, ".");
+		if (!name)
+			break;
 
-		/* Quirk: replace '-' with '_' in sound modules */
+		/* Quirk: replace '-' with '_' in all modules */
 		for (len = strlen(name); len; len--) {
 			if (*(name+len) == '-')
 				*(name+len) = '_';
 		}
 
 		module = module__new(name, path);
-		if (!module) {
-			fprintf(stderr, "load_module_paths: allocation error\n");
-			goto out_failure;
-		}
+		if (!module)
+			break;
 		mod_dso__insert_module(self, module);
 
 		module->sections = sec_dso__new_dso("sections");
-		if (!module->sections) {
-			fprintf(stderr, "load_module_paths: allocation error\n");
-			goto out_failure;
-		}
+		if (!module->sections)
+			break;
 
 		module->active = mod_dso__load_sections(module);
 
@@ -490,13 +519,20 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 			count++;
 	}
 
-	free(line);
-	fclose(file);
-
-	return count;
+	if (feof(file))
+		err = count;
+	else
+		fprintf(stderr, "load_module_paths: modules.dep parsing failure!\n");
 
 out_failure:
-	return -1;
+	if (dpath)
+		free(dpath);
+	if (file)
+		fclose(file);
+	if (line)
+		free(line);
+
+	return err;
 }
 
 int mod_dso__load_modules(struct mod_dso *dso)
