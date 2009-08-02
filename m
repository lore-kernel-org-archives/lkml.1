Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZHBNwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZHBNwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZHBNwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:52:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZHBNwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:52:23 -0400
Date: Sun, 2 Aug 2009 13:51:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1248096665.15751.8816.camel@twins>
References: <1248096665.15751.8816.camel@twins>
Subject: [tip:core/locking] lockdep: Fix backtraces
Message-ID: <tip-4f84f4330a11b9eb828bf5af557f4c79c64614a3@git.kernel.org>
Git-Commit-ID: 4f84f4330a11b9eb828bf5af557f4c79c64614a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:51:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f84f4330a11b9eb828bf5af557f4c79c64614a3
Gitweb:     http://git.kernel.org/tip/4f84f4330a11b9eb828bf5af557f4c79c64614a3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 20 Jul 2009 15:27:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 15:41:31 +0200

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
 
