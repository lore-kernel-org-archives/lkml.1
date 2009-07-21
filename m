Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZGUUVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZGUUVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZGUUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:21:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbZGUUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:21:30 -0400
Date: Tue, 21 Jul 2009 17:11:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clark Williams <williams@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf report: Introduce -u/--unresolved-symbols
Message-ID: <20090721201126.GH3091@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can concentrate on getting more symtabs or on figuring out
which files we have to recompile with -g or ask proprietary vendors for
graciously ship us rich symtabs.

For instance, shame on me:

 [acme@doppio ~]$ perf report -us comm,dso,symbol | head -7
 # Samples: 22501
 #
 # Overhead       Command                           Shared Object        Symbol
 # ........  ............  ............................................  ......
 # 
     82.53%  npviewer.bin  /usr/lib64/mozilla/plugins/libflashplayer.so  [.] 0x000000003820d7
      6.34%         skype  /opt/skype_static-2.0.0.72/skype              [.] 0x00000000e1e0b1

;-)

But the next cset should be rather nice, as I realized that doing:

yum install /usr/lib/debug/<DSO NAME WITH MISSING SYMTAB>.debug

Works!

Now think about a world where:

yum install /usr/lib/debug/<DSO NAME WITH MISSING SYMTAB>.symtab

Works, makes the internet a better place by not downloading whales,
oops, debuginfo files full of crap we don't need.

Don't get me wrong, the aforementioned crap has its place in this world,
just not for the perf tools, _so far_.

Ah, and replace 'yum' with zypper, apt-get (I tried!), smart, urpmi,
whatever-is-your-still-non-standardized way to get needed pieces to do
real work.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>,
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    5 +++++
 tools/perf/builtin-report.c              |   11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index e72e931..86aec08 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -48,6 +48,11 @@ OPTIONS
 	all occurances of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
+-u::
+--unresolved-symbols
+
+	Consider only unresolved symbols.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a118bc7..c30f4cd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,6 +52,7 @@ static int		modules;
 
 static int		full_paths;
 static int		show_nr_samples;
+static int		show_only_unresolved_symbols;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -1556,8 +1557,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
 			return 0;
 
-		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
-			return 0;
+		if (sym) {
+			if (show_only_unresolved_symbols)
+				return 0;
+			if (sym_list && !strlist__has_entry(sym_list, sym->name))
+				return 0;
+		}
 
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
 			eprintf("problem incrementing symbol count, skipping event\n");
@@ -2020,6 +2025,8 @@ static const struct option options[] = {
 	OPT_STRING('t', "field-separator", &field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
+	OPT_BOOLEAN('u', "unresolved-symbols", &show_only_unresolved_symbols,
+		    "Show only the symbols that were no resolved to names"),
 	OPT_END()
 };
 
-- 
1.6.2.5

