Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIZM3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIZM3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZIZM3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:29:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbZIZM3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:29:52 -0400
Date: Sat, 26 Sep 2009 14:29:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20090926122945.GA2188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      perf_event: Update PERF_EVENT_FORK header definition

Eric Dumazet (2):
      perf tools: Fix buffer allocation
      perf tools: Dont use openat()

Ingo Molnar (1):
      perf stat: Fix zero total printouts

Kirill Smelkov (1):
      perf tools: .gitignore += perf*.html

Mike Galbraith (2):
      perf tools: Fix module symbol loading bug
      perf tools: Handle relative paths while loading module symbols

Peter Zijlstra (1):
      perf_event, x86: Fix 'perf sched record' crashing the machine


 arch/x86/kernel/cpu/perf_event.c |    3 +
 include/linux/perf_counter.h     |    2 +-
 include/linux/perf_event.h       |    2 +-
 tools/perf/.gitignore            |    1 +
 tools/perf/builtin-stat.c        |   18 ++++++--
 tools/perf/util/module.c         |   96 ++++++++++++++++++++++++++------------
 tools/perf/util/parse-events.c   |   49 ++++++++-----------
 tools/perf/util/symbol.c         |   17 +++++--
 8 files changed, 119 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a3c7adb..b5801c3 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1790,6 +1790,9 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
 void set_perf_event_pending(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
+	if (!x86_pmu.apic || !x86_pmu_initialized())
+		return;
+
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
 #endif
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 368bd70..7b7fbf4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -361,7 +361,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index acefaf7..3a9d36d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -357,7 +357,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index d69a759..0854f11 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -10,6 +10,7 @@ perf-stat
 perf-top
 perf*.1
 perf*.xml
+perf*.html
 common-cmds.h
 tags
 TAGS
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 16af2d8..e5f6ece 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -338,14 +338,24 @@ static void nsec_printout(int counter, double avg)
 
 static void abs_printout(int counter, double avg)
 {
+	double total, ratio = 0.0;
+
 	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
 
 	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
-		fprintf(stderr, " # %10.3f IPC  ",
-				avg / avg_stats(&runtime_cycles_stats));
+		total = avg_stats(&runtime_cycles_stats);
+
+		if (total)
+			ratio = avg / total;
+
+		fprintf(stderr, " # %10.3f IPC  ", ratio);
 	} else {
-		fprintf(stderr, " # %10.3f M/sec",
-				1000.0 * avg / avg_stats(&runtime_nsecs_stats));
+		total = avg_stats(&runtime_nsecs_stats);
+
+		if (total)
+			ratio = 1000.0 * avg / total;
+
+		fprintf(stderr, " # %10.3f M/sec", ratio);
 	}
 }
 
diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
index 3d567fe..0d8c85d 100644
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
+	dpath = calloc(1, len + 1);
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
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 13ab4b8..87c424d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -165,33 +165,31 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	char id_buf[4];
-	int sys_dir_fd, fd;
+	int fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return NULL;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return NULL;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-			snprintf(evt_path, MAXPATHLEN, "%s/id",
+
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
 				 evt_dirent.d_name);
-			fd = openat(evt_dir_fd, evt_path, O_RDONLY);
+			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
 			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
@@ -225,7 +223,6 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 		closedir(evt_dir);
 	}
 
-cleanup:
 	closedir(sys_dir);
 	return NULL;
 }
@@ -761,28 +758,24 @@ static void print_tracepoint_events(void)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	int sys_dir_fd;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
@@ -791,8 +784,6 @@ static void print_tracepoint_events(void)
 		}
 		closedir(evt_dir);
 	}
-
-cleanup:
 	closedir(sys_dir);
 }
 
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
