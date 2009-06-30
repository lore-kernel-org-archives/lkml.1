Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZF3WBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZF3WBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZF3WB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:01:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:59028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZF3WB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:01:26 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH tip 3/3] perf_counter tools: Add --symbols parameter to 'perf report'
Date: Tue, 30 Jun 2009 19:01:22 -0300
Message-Id: <1246399282-20934-4-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1246399282-20934-3-git-send-email-acme@redhat.com>
References: <1246399282-20934-1-git-send-email-acme@redhat.com>
 <1246399282-20934-2-git-send-email-acme@redhat.com>
 <1246399282-20934-3-git-send-email-acme@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can filter by symbol name.

The 'pfunct' utility in the 'dwarves' package can be used to create a
file with the functions one wants.

Example:

[acme@doppio pahole]$ pfunct /usr/lib/debug/usr/lib64/libdw-0.141.so.debug | grep dwarf > /tmp/dwarf.symbols
[acme@doppio pahole]$ wc -l /tmp/dwarf.symbols
93 /tmp/dwarf.symbols
[acme@doppio pahole]$ head -3 /tmp/dwarf.symbols
dwfl_addrdwarf
dwfl_module_getdwarf
dwfl_getdwarf
[acme@doppio pahole]$ perf report --sort comm,dso,symbol --comms pahole --dsos /usr/lib64/libdw-0.141.so --symbols file:///tmp/dwarf.symbols

    33.99%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_tag
    29.07%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_decl_file
    27.71%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_getsrclines
     4.54%            pahole  /usr/lib64/libdw-0.141.so  0x00000000007400
     3.93%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_decl_line
     0.46%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_getlocation
     0.18%            pahole  /usr/lib64/libdw-0.141.so  [.] __libdwarf_next_prime
     0.13%            pahole  /usr/lib64/libdw-0.141.so  [.] dwarf_diecu

[acme@doppio pahole]$

Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    4 ++++
 tools/perf/builtin-report.c              |   10 ++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 4c44ef1..8aa3f8c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -28,6 +28,10 @@ OPTIONS
 --comms=::
 	Only consider symbols in these comms. CSV that understands
 	file://filename entries.
+-S::
+--symbols=::
+	Only consider these symbols. CSV that understands
+	file://filename entries.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8143477..135b783 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,8 +33,8 @@ static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso";
 static char		*sort_order = default_sort_order;
-static char		*dso_list_str, *comm_list_str;
-static struct strlist	*dso_list, *comm_list;
+static char		*dso_list_str, *comm_list_str, *sym_list_str;
+static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -1281,6 +1281,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
 			return 0;
 
+		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+			return 0;
+
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
 			eprintf("problem incrementing symbol count, skipping event\n");
 			return -1;
@@ -1672,6 +1675,8 @@ static const struct option options[] = {
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
 		   "only consider symbols in these comms"),
+	OPT_STRING('S', "symbols", &sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_END()
 };
 
@@ -1726,6 +1731,7 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	setup_list(&dso_list, dso_list_str, "dso");
 	setup_list(&comm_list, comm_list_str, "comm");
+	setup_list(&sym_list, sym_list_str, "symbol");
 
 	setup_pager();
 
-- 
1.6.2.5

