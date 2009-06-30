Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZF3Wz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZF3Wz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZF3Wzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:55:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbZF3Wzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:55:40 -0400
Date: Tue, 30 Jun 2009 22:55:10 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246399282-20934-4-git-send-email-acme@redhat.com>
References: <1246399282-20934-4-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/urgent] perf report: Add --symbols parameter
Message-ID: <tip-7bec7a9134c25cecb0d7029199b59f7b1bef35b8@git.kernel.org>
Git-Commit-ID: 7bec7a9134c25cecb0d7029199b59f7b1bef35b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 22:55:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bec7a9134c25cecb0d7029199b59f7b1bef35b8
Gitweb:     http://git.kernel.org/tip/7bec7a9134c25cecb0d7029199b59f7b1bef35b8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 30 Jun 2009 19:01:22 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 00:07:10 +0200

perf report: Add --symbols parameter

So that we can filter by symbol name.

The 'pfunct' utility in the 'dwarves' package can be used to
create a file with the functions one wants.

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

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1246399282-20934-4-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
