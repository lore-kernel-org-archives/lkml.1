Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZKVQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZKVQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZKVQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:59:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:58622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbZKVQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:59:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf report: Do map lookups in resolve_callchain
Date: Sun, 22 Nov 2009 14:59:22 -0200
Message-Id: <1258909162-28496-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Bug introduced in 439d473b4777de510e1322168ac6f2f377ecd5bc, making the
initial map be used for all IPs, so that symbols outside this initial
map would either be erroneously resolved or not resolve at all.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d39e80..7e690f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -467,7 +467,7 @@ static int call__match(struct symbol *sym)
 	return 0;
 }
 
-static struct symbol **resolve_callchain(struct thread *thread, struct map *map,
+static struct symbol **resolve_callchain(struct thread *thread,
 					 struct ip_callchain *chain,
 					 struct symbol **parent)
 {
@@ -496,10 +496,10 @@ static struct symbol **resolve_callchain(struct thread *thread, struct map *map,
 		case PERF_CONTEXT_HV:
 			break;
 		case PERF_CONTEXT_KERNEL:
-			sym = kernel_maps__find_symbol(ip, &map, NULL);
+			sym = kernel_maps__find_symbol(ip, NULL, NULL);
 			break;
 		default:
-			sym = resolve_symbol(thread, &map, &ip);
+			sym = resolve_symbol(thread, NULL, &ip);
 			break;
 		}
 
@@ -529,7 +529,7 @@ hist_entry__add(struct thread *thread, struct map *map,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || callchain) && chain)
-		syms = resolve_callchain(thread, map, chain, &parent);
+		syms = resolve_callchain(thread, chain, &parent);
 
 	he = __hist_entry__add(thread, map, sym, parent,
 			       ip, count, level, &hit);
-- 
1.6.2.5

