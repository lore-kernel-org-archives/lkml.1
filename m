Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZLRPbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZLRPbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbZLRPbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:31:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:44930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbZLRPbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:31:34 -0500
Date: Fri, 18 Dec 2009 15:30:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1261148583-20395-1-git-send-email-acme@infradead.org>
References: <1261148583-20395-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Make events_stats u64 to avoid overflow on 32-bit arches
Message-ID: <tip-b5b60fda1e462a849bc37dfbace2888191be82cc@git.kernel.org>
Git-Commit-ID: b5b60fda1e462a849bc37dfbace2888191be82cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5b60fda1e462a849bc37dfbace2888191be82cc
Gitweb:     http://git.kernel.org/tip/b5b60fda1e462a849bc37dfbace2888191be82cc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Dec 2009 13:03:03 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Dec 2009 16:22:52 +0100

perf session: Make events_stats u64 to avoid overflow on 32-bit arches

Pekka Enberg reported weird percentages in perf report. It
turns out we are overflowing a 32-bit variables in struct
events_stats on 32-bit architectures.

Before:

 [acme@ana linux-2.6-tip]$ perf report -i pekka.perf.data 2> /dev/null | head -10
   281.96%       Xorg                        b710a561  [.] 0x000000b710a561
   140.15%       Xorg  [kernel]                        [k] __initramfs_end
    51.56%   metacity  libgobject-2.0.so.0.2000.1      [.] 0x00000000026e46
    35.12%  evolution  libcairo.so.2.10800.6           [.] 0x000000000203bd
    33.84%   metacity  libpthread-2.9.so               [.] 0x00000000007a3d

After:

 [acme@ana linux-2.6-tip]$ perf report -i pekka.perf.data 2> /dev/null | head -10
    30.04%       Xorg                       b710a561   [.] 0x000000b710a561
    14.93%       Xorg  [kernel]                        [k] __initramfs_end
     5.49%   metacity  libgobject-2.0.so.0.2000.1      [.] 0x00000000026e46
     3.74%  evolution  libcairo.so.2.10800.6           [.] 0x000000000203bd
     3.61%   metacity  libpthread-2.9.so               [.] 0x00000000007a3d

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1261148583-20395-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/event.h     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e50a6b1..5c2ab53 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -224,7 +224,7 @@ static int __cmd_report(void)
 
 	perf_session__collapse_resort(session);
 	perf_session__output_resort(session, session->events_stats.total);
-	fprintf(stdout, "# Samples: %ld\n#\n", session->events_stats.total);
+	fprintf(stdout, "# Samples: %Ld\n#\n", session->events_stats.total);
 	perf_session__fprintf_hists(session, NULL, false, stdout);
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8027309..690a96d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -95,8 +95,8 @@ typedef union event_union {
 } event_t;
 
 struct events_stats {
-	unsigned long total;
-	unsigned long lost;
+	u64 total;
+	u64 lost;
 };
 
 void event__print_totals(void);
