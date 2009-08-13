Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZHMKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZHMKWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHMKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:22:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZHMKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:22:08 -0400
Date: Thu, 13 Aug 2009 10:21:38 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090812211957.GE3495@ghostprotocols.net>
References: <20090812211957.GE3495@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf report: Don't show unresolved DSOs and symbols when -S/-d is used
Message-ID: <tip-8fd101f20bdf771949a8f3a5a779877d09b2fb56@git.kernel.org>
Git-Commit-ID: 8fd101f20bdf771949a8f3a5a779877d09b2fb56
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 10:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fd101f20bdf771949a8f3a5a779877d09b2fb56
Gitweb:     http://git.kernel.org/tip/8fd101f20bdf771949a8f3a5a779877d09b2fb56
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Aug 2009 18:19:57 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 12:05:52 +0200

perf report: Don't show unresolved DSOs and symbols when -S/-d is used

We're interested in just those symbols/DSOs, so filter out the
unresolved ones.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090812211957.GE3495@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 23e1457..b53a60f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1590,10 +1590,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
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
