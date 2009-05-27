Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbZE0HVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbZE0HVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbZE0HRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:50216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760623AbZE0HRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:38 -0400
Date: Wed, 27 May 2009 07:16:15 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, rostedt@goodmis.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526222155.GJ4424@ghostprotocols.net>
References: <20090526222155.GJ4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf report: Only load text symbols from kallsyms
Message-ID: <tip-03f6316d32738ec5eda2e6f628c12d1c01e61a87@git.kernel.org>
Git-Commit-ID: 03f6316d32738ec5eda2e6f628c12d1c01e61a87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:16:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03f6316d32738ec5eda2e6f628c12d1c01e61a87
Gitweb:     http://git.kernel.org/tip/03f6316d32738ec5eda2e6f628c12d1c01e61a87
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 May 2009 19:21:55 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:10:36 +0200

perf report: Only load text symbols from kallsyms

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

[ Impact: optimization ]

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090526222155.GJ4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
