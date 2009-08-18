Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZHRMHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZHRMHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZHRMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZHRMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:07:21 -0400
Date: Tue, 18 Aug 2009 12:06:36 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf annotate: Fix segmentation fault
Message-ID: <tip-15f3fa4e7f608c5ce19187b3b4a953222fdfa751@git.kernel.org>
Git-Commit-ID: 15f3fa4e7f608c5ce19187b3b4a953222fdfa751
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 12:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15f3fa4e7f608c5ce19187b3b4a953222fdfa751
Gitweb:     http://git.kernel.org/tip/15f3fa4e7f608c5ce19187b3b4a953222fdfa751
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 18 Aug 2009 13:52:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 14:00:52 +0200

perf annotate: Fix segmentation fault

Linus reported this perf annotate segfault:

        [torvalds@nehalem git]$ perf annotate unmap_vmas
        Segmentation fault

       	#0  map__clone (self=<value optimized out>) at builtin-annotate.c:236
       	#1  thread__fork (self=<value optimized out>) at builtin-annotate.c:372

The bug here was that builtin-annotate.c was a copy of
builtin-report.c and a threading related fix to builtin-report.c
didnt get propagated to builtin-annotate.c ...

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1dba568..343e7b1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -980,6 +980,13 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)(event->header.size),
 		event->fork.pid, event->fork.ppid);
 
+	/*
+	 * A thread clone will have the same PID for both
+	 * parent and child.
+	 */
+	if (thread == parent)
+		return 0;
+
 	if (!thread || !parent || thread__fork(thread, parent)) {
 		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
 		return -1;
