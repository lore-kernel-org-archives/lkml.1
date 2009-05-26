Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZEZWW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZEZWW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZEZWWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZEZWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:17 -0400
Date: Tue, 26 May 2009 19:21:55 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 tip] perf: report should only load text symbols from
	kallsyms
Message-ID: <20090526222155.GJ4424@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7508bc84d541ac245be633803d393244b6860af6 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 26 May 2009 19:14:47 -0300
Subject: [PATCH] perf: report should only load text symbols from kallsyms

Just like we do for userspace when reading the symtab, reducing the
number of entries we insert on the symbols rbtree.

Before:

[acme@emilia ~]$ rm -f perf_report.perf ; perf record -o perf_report.perf perf stat perf report > /dev/null

 Performance counter stats for 'perf':

     218.138382  task clock ticks     (msecs)
              4  context switches     (events)
              8  CPU migrations       (events)
           2136  pagefaults           (events)
       32746212  CPU cycles           (events)  (scaled from 67.04%)
       11961102  instructions         (events)  (scaled from 66.19%)
          49841  cache references     (events)  (scaled from 21.96%)
          13777  cache misses         (events)  (scaled from 21.98%)

 Wall-clock time elapsed:   218.702477 msecs

[acme@emilia ~]$ perf report -i perf_report.perf | head
11.06          perf [.] 0x00000000000057cb /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__find_symbol
 9.15          perf [.] 0x00000000000056a0 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__insert_symbol
 8.72          perf [k] 0xffffffff8101b1d2 intel_pmu_enable_all
 8.51          perf [.] 0x0000000000006672 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: thread__symbol_incnew
 3.83          perf [k] 0xffffffff811cfc5a vsnprintf
 3.40          perf [.] 0x0000000000005e33 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex
 3.40          perf [.] 0x0000000000005ec7 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex2long
 3.19          perf [k] 0xffffffff811ce1c1 number
 2.77          perf [.] 0x0000000000006869 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: threads__findnew
 2.77          perf [.] 0x000000000000fde3 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: rb_insert_color
[acme@emilia ~]$

After:

acme@emilia ~]$ rm -f perf_report.perf ; perf record -o perf_report.perf perf stat perf report > /dev/null

 Performance counter stats for 'perf':

     190.228511  task clock ticks     (msecs)
              4  context switches     (events)
              7  CPU migrations       (events)
           1625  pagefaults           (events)
       29578745  CPU cycles           (events)  (scaled from 66.92%)
       10516914  instructions         (events)  (scaled from 66.47%)
          44015  cache references     (events)  (scaled from 22.04%)
           8248  cache misses         (events)  (scaled from 22.07%)

 Wall-clock time elapsed:   190.816096 msecs

[acme@emilia ~]$ perf report -i perf_report.perf | head
15.99          perf [.] 0x00000000000057a9 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__find_symbol
10.87          perf [.] 0x000000000000674d /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: thread__symbol_incnew
 8.74          perf [k] 0xffffffff8101b1d2 intel_pmu_enable_all
 5.54          perf [.] 0x0000000000005e42 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex
 4.48          perf [.] 0x0000000000005ebe /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: hex2long
 4.48          perf [k] 0xffffffff811cfba0 vsnprintf
 3.84          perf [.] 0x00000000000056b4 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__insert_symbol
 3.62          perf [.] 0x00000000000068d0 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: threads__findnew
 3.20          perf [k] 0xffffffff811ce0b3 number
 2.56          perf [.] 0x0000000000006d78 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: __cmd_report
[acme@emilia ~]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/builtin-report.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index c517483..a55f15d 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -3,6 +3,7 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+#include <ctype.h>
 
 #include "util/list.h"
 #include "util/rbtree.h"
@@ -408,13 +409,20 @@ static int load_kallsyms(void)
 
 		int len = hex2long(line, &start);
 		
-		len += 3; /* ' t ' */
-		if (len >= line_len)
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		char symbol_type = line[len];
+		/*
+		 * We're interested only in code ('T'ext)
+		 */
+		if (toupper(symbol_type) != 'T')
 			continue;
 		/*
 		 * Well fix up the end later, when we have all sorted.
 		 */
-		struct symbol *sym = symbol__new(start, 0xdead, line + len);
+		struct symbol *sym = symbol__new(start, 0xdead, line + len + 2);
 
 		if (sym == NULL)
 			goto out_delete_dso;
-- 
1.6.0.6

