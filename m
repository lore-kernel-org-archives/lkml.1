Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264Ab0AGQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0AGQk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053Ab0AGQk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:40:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:14596 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0AGQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kBqhnLCWNV6w2I/fGAsp/m8r+kcouprV0XXXHLLYpj9i/HGIWon0nr6pDZW4klBo+H
         aI+wZo4uULhE1pPjbZG0yM7Y7O8OIM8CBYlA9ENSNfoHCrxZIA0UuQT6n3aufyzfR+vU
         4Ip5q46ACI9geOc0FmlRZpfDRDBTZZWjqcV0I=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/2] perf: add close()/closedir() calls when needed
Date: Thu,  7 Jan 2010 19:40:46 +0300
Message-Id: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close file and directory descriptors before exiting or dying.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 tools/perf/builtin-kmem.c          |    2 ++
 tools/perf/builtin-trace.c         |    6 +++++-
 tools/perf/util/parse-events.c     |    1 +
 tools/perf/util/symbol.c           |    1 +
 tools/perf/util/trace-event-info.c |   20 +++++++++++++++++---
 5 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7ceb741..81735d2 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -112,7 +112,9 @@ static void setup_cpunode_map(void)
 				continue;
 			cpunode_map[cpu] = mem;
 		}
+		closedir(dir2);
 	}
+	closedir(dir1);
 }
 
 static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 574a215..5ad93e2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -507,7 +507,9 @@ static char *get_script_path(const char *script_root, const char *suffix)
 			}
 			free(__script_root);
 		}
+		closedir(lang_dir);
 	}
+	closedir(scripts_dir);
 
 	return path;
 }
@@ -615,7 +617,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		scripting_ops = script_spec__lookup(generate_script_lang);
 		if (!scripting_ops) {
 			fprintf(stderr, "invalid language specifier");
-			return -1;
+			err = -1;
+			goto out;
 		}
 
 		perf_header__read(&session->header, input);
@@ -634,5 +637,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	perf_session__delete(session);
 	cleanup_scripting();
 out:
+	close(input);
 	return err;
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5bc0fb..7739a37 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -483,6 +483,7 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 		if (parse_events(NULL, event_opt, 0))
 			return EVT_FAILED;
 	}
+	closedir(evt_dir);
 
 	return EVT_HANDLED_ALL;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ab92763..953e654 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1364,6 +1364,7 @@ static int perf_session__set_modules_path_dir(struct perf_session *self, char *d
 		}
 	}
 
+	closedir(dir);
 	return 0;
 failure:
 	closedir(dir);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index cace355..e191126 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -275,6 +275,7 @@ static void read_header_files(void)
 		die("wrong size for '%s' size=%lld read=%lld",
 		    path, size, check_size);
 	put_tracing_file(path);
+	close(fd);
 
 	path = get_tracing_file("events/header_event");
 	fd = open(path, O_RDONLY);
@@ -289,6 +290,7 @@ static void read_header_files(void)
 	if (size != check_size)
 		die("wrong size for '%s'", path);
 	put_tracing_file(path);
+	close(fd);
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -321,7 +323,11 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			closedir(dir);
+			die("malloc");
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 		free(format);
@@ -338,7 +344,11 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			closedir(dir);
+			die("malloc");
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
@@ -347,12 +357,15 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 			size = get_size(format);
 			write_or_die(&size, 8);
 			check_size = copy_file(format);
-			if (size != check_size)
+			if (size != check_size) {
+				closedir(dir);
 				die("error in size of file '%s'", format);
+			}
 		}
 
 		free(format);
 	}
+	closedir(dir);
 }
 
 static void read_ftrace_files(struct tracepoint_path *tps)
@@ -429,6 +442,7 @@ static void read_event_files(struct tracepoint_path *tps)
 		}
 		free(sys);
 	}
+	closedir(dir);
 
 	put_tracing_file(path);
 }
-- 
1.6.6

