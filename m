Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZHBNO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZHBNO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZHBNO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:14:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:33933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZHBNO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:14:56 -0400
Date: Sun, 2 Aug 2009 13:14:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1248096665.15751.8816.camel@twins>
References: <1248096665.15751.8816.camel@twins>
Subject: [tip:core/locking] lockdep: Fix backtraces
Message-ID: <tip-96c6ab754464eb2d214b81392551ed581bd573ed@git.kernel.org>
Git-Commit-ID: 96c6ab754464eb2d214b81392551ed581bd573ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96c6ab754464eb2d214b81392551ed581bd573ed
Gitweb:     http://git.kernel.org/tip/96c6ab754464eb2d214b81392551ed581bd573ed
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 20 Jul 2009 15:27:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:59:29 +0200

lockdep: Fix backtraces

Truncate stupid -1 entries in backtraces.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1248096665.15751.8816.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1cedb00..2f09702 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -367,11 +367,21 @@ static int save_trace(struct stack_trace *trace)
 
 	save_stack_trace(trace);
 
+	/*
+	 * Some daft arches put -1 at the end to indicate its a full trace.
+	 *
+	 * <rant> this is buggy anyway, since it takes a whole extra entry so a
+	 * complete trace that maxes out the entries provided will be reported
+	 * as incomplete, friggin useless </rant>
+	 */
+	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+		trace->nr_entries--;
+
 	trace->max_entries = trace->nr_entries;
 
 	nr_stack_trace_entries += trace->nr_entries;
 
-	if (nr_stack_trace_entries == MAX_STACK_TRACE_ENTRIES) {
+	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES-1) {
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
