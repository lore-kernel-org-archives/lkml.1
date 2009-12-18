Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZLRPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZLRPDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZLRPDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:03:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbZLRPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:03:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf session: Make events_stats u64 to avoid overflow on 32-bit arches
Date: Fri, 18 Dec 2009 13:03:03 -0200
Message-Id: <1261148583-20395-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

With same perf.data file:

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
[acme@ana linux-2.6-tip]$

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.5.2

