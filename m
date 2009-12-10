Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbZLJHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbZLJHWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760481AbZLJHWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:22:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64703 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZLJHWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:22:12 -0500
Message-ID: <4B20A195.8030106@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 15:21:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf kmem: Show usage if no option is specified
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Ingo suggested, make "perf kmem" show help information.
"perf kmem stat [--caller] [--alloc] .." will show memory
statistics.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kmem.txt |   13 +++++---
 tools/perf/builtin-kmem.c              |   52 ++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
index 44b0ce3..eac4d85 100644
--- a/tools/perf/Documentation/perf-kmem.txt
+++ b/tools/perf/Documentation/perf-kmem.txt
@@ -8,16 +8,16 @@ perf-kmem - Tool to trace/measure kernel memory(slab) properties
 SYNOPSIS
 --------
 [verse]
-'perf kmem' {record} [<options>]
+'perf kmem' {record|stat} [<options>]
 
 DESCRIPTION
 -----------
-There's two variants of perf kmem:
+There are two variants of perf kmem:
 
   'perf kmem record <command>' to record the kmem events
   of an arbitrary workload.
 
-  'perf kmem' to report kernel memory statistics.
+  'perf kmem stat' to report kernel memory statistics.
 
 OPTIONS
 -------
@@ -25,8 +25,11 @@ OPTIONS
 --input=<file>::
 	Select the input file (default: perf.data)
 
---stat=<caller|alloc>::
-	Select per callsite or per allocation statistics
+--caller::
+	Show per-callsite statistics
+
+--alloc::
+	Show per-allocation statistics
 
 -s <key[,key2...]>::
 --sort=<key[,key2...]>::
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7551a5f..1b04787 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -526,7 +526,7 @@ static int __cmd_kmem(void)
 }
 
 static const char * const kmem_usage[] = {
-	"perf kmem [<options>] {record}",
+	"perf kmem [<options>] {record|stat}",
 	NULL
 };
 
@@ -686,18 +686,17 @@ static int parse_sort_opt(const struct option *opt __used,
 	return 0;
 }
 
-static int parse_stat_opt(const struct option *opt __used,
+static int parse_caller_opt(const struct option *opt __used,
 			  const char *arg, int unset __used)
 {
-	if (!arg)
-		return -1;
+	caller_flag = (alloc_flag + 1);
+	return 0;
+}
 
-	if (strcmp(arg, "alloc") == 0)
-		alloc_flag = (caller_flag + 1);
-	else if (strcmp(arg, "caller") == 0)
-		caller_flag = (alloc_flag + 1);
-	else
-		return -1;
+static int parse_alloc_opt(const struct option *opt __used,
+			  const char *arg, int unset __used)
+{
+	alloc_flag = (caller_flag + 1);
 	return 0;
 }
 
@@ -722,14 +721,17 @@ static int parse_line_opt(const struct option *opt __used,
 static const struct option kmem_options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		   "input file name"),
-	OPT_CALLBACK(0, "stat", NULL, "<alloc>|<caller>",
-		     "stat selector, Pass 'alloc' or 'caller'.",
-		     parse_stat_opt),
+	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
+			   "show per-callsite statistics",
+			   parse_caller_opt),
+	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
+			   "show per-allocation statistics",
+			   parse_alloc_opt),
 	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
 		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
 		     parse_sort_opt),
 	OPT_CALLBACK('l', "line", NULL, "num",
-		     "show n lins",
+		     "show n lines",
 		     parse_line_opt),
 	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
 	OPT_END()
@@ -773,18 +775,22 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
-	if (argc && !strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
-	else if (argc)
+	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
-	if (list_empty(&caller_sort))
-		setup_sorting(&caller_sort, default_sort_order);
-	if (list_empty(&alloc_sort))
-		setup_sorting(&alloc_sort, default_sort_order);
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strcmp(argv[0], "stat")) {
+		setup_cpunode_map();
+
+		if (list_empty(&caller_sort))
+			setup_sorting(&caller_sort, default_sort_order);
+		if (list_empty(&alloc_sort))
+			setup_sorting(&alloc_sort, default_sort_order);
 
-	setup_cpunode_map();
+		return __cmd_kmem();
+	}
 
-	return __cmd_kmem();
+	return 0;
 }
 
-- 
1.6.3


