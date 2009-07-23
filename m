Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZGWTW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZGWTW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZGWTWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:36978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZGWTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:12 -0400
Message-Id: <20090723191957.130373509@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/13] lockdep: Fix backtraces
Content-Disposition: inline; filename=lockdep-fix-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Truncate stupid -1 entries in backtraces.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1248096665.15751.8816.camel@twins>
---
 kernel/lockdep.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -367,11 +367,21 @@ static int save_trace(struct stack_trace
 
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
 

-- 

