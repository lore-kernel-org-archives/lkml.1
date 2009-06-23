Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZFWKEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZFWKEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZFWKEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:04:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFWKEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:04:13 -0400
Date: Tue, 23 Jun 2009 10:03:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Handle overlapping MMAP events
Message-ID: <tip-3d906ef10a539ff336010afab8f6f9c4fe379695@git.kernel.org>
Git-Commit-ID: 3d906ef10a539ff336010afab8f6f9c4fe379695
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 10:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d906ef10a539ff336010afab8f6f9c4fe379695
Gitweb:     http://git.kernel.org/tip/3d906ef10a539ff336010afab8f6f9c4fe379695
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 23 Jun 2009 11:23:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 11:42:44 +0200

perf_counter tools: Handle overlapping MMAP events

Martin Schwidefsky reported "perf report" symbol resolution
problems on S390.

Since we only report MMAP, not MUNMAP, we have to deal with
overlapping maps.

We used to simply throw out the old map on the assumption whole
maps got unmapped. This obviously doesn't deal with partial
unmaps. However it appears some dynamic linkers do fancy
partial unmaps (s390), so do something more elaborate and
truncate the old maps, only removing them when they've been
fully covered.

This resolves (part of) the S390 symbol resolution problems.

Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Tested-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ec230a0..b4e76f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -400,9 +400,27 @@ static void thread__insert_map(struct thread *self, struct map *map)
 
 	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
 		if (map__overlap(pos, map)) {
-			list_del_init(&pos->node);
-			/* XXX leaks dsos */
-			free(pos);
+			if (verbose >= 2) {
+				printf("overlapping maps:\n");
+				map__fprintf(map, stdout);
+				map__fprintf(pos, stdout);
+			}
+
+			if (map->start <= pos->start && map->end > pos->start)
+				pos->start = map->end;
+
+			if (map->end >= pos->end && map->start < pos->end)
+				pos->end = map->start;
+
+			if (verbose >= 2) {
+				printf("after collision:\n");
+				map__fprintf(pos, stdout);
+			}
+
+			if (pos->start >= pos->end) {
+				list_del_init(&pos->node);
+				free(pos);
+			}
 		}
 	}
 
