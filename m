Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbZLJHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbZLJHvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbZLJHvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:51:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:46570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760722AbZLJHvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:51:14 -0500
Date: Thu, 10 Dec 2009 07:50:58 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B20A195.8030106@cn.fujitsu.com>
References: <4B20A195.8030106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Show usage if no option is specified
Message-ID: <tip-90b86a9f7dc22e7ff8e8c79ed553860454ff8dd9@git.kernel.org>
Git-Commit-ID: 90b86a9f7dc22e7ff8e8c79ed553860454ff8dd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90b86a9f7dc22e7ff8e8c79ed553860454ff8dd9
Gitweb:     http://git.kernel.org/tip/90b86a9f7dc22e7ff8e8c79ed553860454ff8dd9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Dec 2009 15:21:57 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:30:27 +0100

perf kmem: Show usage if no option is specified

As Ingo suggested, make "perf kmem" show help information.
"perf kmem stat [--caller] [--alloc] .." will show memory
statistics.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <4B20A195.8030106@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
