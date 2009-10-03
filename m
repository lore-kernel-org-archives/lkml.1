Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZJCXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZJCXjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZJCXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 19:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZJCXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 19:39:51 -0400
Date: Sat, 3 Oct 2009 20:30:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf tools: Remove show_mask bitmask
Message-ID: <20091003233048.GA30535@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it was not being exposed via any command line and with --dsos/--comms
we can do this and even more, like asking for just kernel + some module:

[root@doppio linux-2.6-tip]# perf report --dsos \[kernel\],\[drm\]
--vmlinux /home/acme/git/build/tip-recvmmsg/vmlinux --modules | head -15
 # Samples: 619669
 #
 # Overhead          Command  Shared Object  Symbol
 # ........  ...............  .............  ......
 #
      7.12%          swapper  [kernel]       [k] read_hpet
      6.86%             init  [kernel]       [k] read_hpet
      6.22%             init  [kernel]       [k] mwait_idle_with_hints
      5.34%          swapper  [kernel]       [k] mwait_idle_with_hints
      3.01%          firefox  [kernel]       [.] vread_hpet
      2.14%             Xorg  [drm]          [k] drm_clflush_pages
      2.09%           pidgin  [kernel]       [.] vread_hpet
      1.58%     npviewer.bin  [kernel]       [.] vread_hpet
      1.37%          swapper  [kernel]       [k] hpet_next_event
      1.23%             Xorg  [kernel]       [k] read_hpet
[root@doppio linux-2.6-tip]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    1 +
 tools/perf/builtin-annotate.c |   15 ++++-----------
 tools/perf/builtin-report.c   |   35 +++++++++++++----------------------
 tools/perf/util/event.h       |    6 ------
 4 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b063396..5a42996 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -323,6 +323,7 @@ LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += util/include/linux/list.h
 LIB_H += perf.h
+LIB_H += util/event.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8550942..35ed97b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -29,7 +29,6 @@ static char		const *input_name = "perf.data";
 
 static int		force;
 static int		input;
-static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		full_paths;
 
@@ -97,7 +96,6 @@ static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
-	int show = 0;
 	struct thread *thread;
 	u64 ip = event->ip.ip;
 	struct map *map = NULL;
@@ -121,13 +119,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 
 	if (event->header.misc & PERF_RECORD_MISC_KERNEL) {
-		show = SHOW_KERNEL;
 		level = 'k';
 		sym = kernel_maps__find_symbol(ip, &map);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (event->header.misc & PERF_RECORD_MISC_USER) {
-		show = SHOW_USER;
 		level = '.';
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
@@ -153,17 +149,14 @@ got_map:
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else {
-		show = SHOW_HV;
 		level = 'H';
 		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
-	if (show & show_mask) {
-		if (hist_entry__add(thread, map, sym, ip, 1, level)) {
-			fprintf(stderr,
-		"problem incrementing symbol count, skipping event\n");
-			return -1;
-		}
+	if (hist_entry__add(thread, map, sym, ip, 1, level)) {
+		fprintf(stderr, "problem incrementing symbol count, "
+				"skipping event\n");
+		return -1;
 	}
 	total++;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0e83ffc..fe4aadc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -38,7 +38,6 @@ static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
 static int		input;
-static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		full_paths;
 static int		show_nr_samples;
@@ -600,7 +599,6 @@ static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
-	int show = 0;
 	struct symbol *sym = NULL;
 	struct thread *thread;
 	u64 ip = event->ip.ip;
@@ -657,42 +655,35 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	if (cpumode == PERF_RECORD_MISC_KERNEL) {
-		show = SHOW_KERNEL;
 		level = 'k';
-
 		sym = kernel_maps__find_symbol(ip, &map);
 		dump_printf(" ...... dso: %s\n",
 			    map ? map->dso->long_name : "<not found>");
 	} else if (cpumode == PERF_RECORD_MISC_USER) {
-
-		show = SHOW_USER;
 		level = '.';
 		sym = resolve_symbol(thread, &map, &ip);
 
 	} else {
-		show = SHOW_HV;
 		level = 'H';
-
 		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
-	if (show & show_mask) {
-		if (dso_list &&
-		    (!map || !map->dso ||
-		     !(strlist__has_entry(dso_list, map->dso->short_name) ||
-		       (map->dso->short_name != map->dso->long_name &&
-			strlist__has_entry(dso_list, map->dso->long_name)))))
-			return 0;
+	if (dso_list &&
+	    (!map || !map->dso ||
+	     !(strlist__has_entry(dso_list, map->dso->short_name) ||
+	       (map->dso->short_name != map->dso->long_name &&
+		strlist__has_entry(dso_list, map->dso->long_name)))))
+		return 0;
 
-		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
-			return 0;
+	if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+		return 0;
 
-		if (hist_entry__add(thread, map, sym, ip,
-				    chain, level, period)) {
-			eprintf("problem incrementing symbol count, skipping event\n");
-			return -1;
-		}
+	if (hist_entry__add(thread, map, sym, ip,
+			    chain, level, period)) {
+		eprintf("problem incrementing symbol count, skipping event\n");
+		return -1;
 	}
+
 	total += period;
 
 	return 0;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a39520e..c2e62be 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -6,12 +6,6 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 
-enum {
-	SHOW_KERNEL	= 1,
-	SHOW_USER	= 2,
-	SHOW_HV		= 4,
-};
-
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
  */
-- 
1.6.2.5

