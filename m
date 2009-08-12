Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbZHLVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbZHLVUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZHLVUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:20:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZHLVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:20:18 -0400
Date: Wed, 12 Aug 2009 18:19:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf report: Don't show unresolved DSOs and
	symbols when -S/-d is used
Message-ID: <20090812211957.GE3495@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're interested in just those symbols/DSOs, so filter out the
unresolved ones.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 58a4f08..6321951 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1340,10 +1340,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (show & show_mask) {
 		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
-		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
+		if (dso_list && (!dso || !dso->name ||
+				 !strlist__has_entry(dso_list, dso->name)))
 			return 0;
 
-		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+		if (sym_list && (!sym || !strlist__has_entry(sym_list, sym->name)))
 			return 0;
 
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
-- 
1.6.2.5


