Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813Ab0AUQkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0AUQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503Ab0AUQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:40:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0AUQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:40:07 -0500
Date: Thu, 21 Jan 2010 17:39:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com, CAI Qian <caiqian@redhat.com>
Subject: [PATCH -mm] utrace: fix utrace_maybe_reap() vs
	find_matching_engine() race
Message-ID: <20100121163921.GA10096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of utrace-core.patch)

The comment in utrace_maybe_reap() correctly explains why
utrace_attach_task/utrace_control/etc can't modify or use
attaching/attached lists.  But find_matching_engine() can
scan ->attached under utrace->lock without any checks, it
can race with utrace_maybe_reap() destroying list nodes.

Change utrace_maybe_reap() to empty ->attached before it
drops utrace->lock, update the comments a bit.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/utrace.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

--- V1/kernel/utrace.c~8_REAP_FIND_RACE	2009-12-18 01:58:37.000000000 +0100
+++ V1/kernel/utrace.c	2010-01-21 17:31:18.000000000 +0100
@@ -1,7 +1,7 @@
 /*
  * utrace infrastructure interface for debugging user processes
  *
- * Copyright (C) 2006-2009 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2010 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -859,6 +859,7 @@ void utrace_maybe_reap(struct task_struc
 		       bool reap)
 {
 	struct utrace_engine *engine, *next;
+	struct list_head attached;
 
 	spin_lock(&utrace->lock);
 
@@ -897,16 +898,24 @@ void utrace_maybe_reap(struct task_struc
 	}
 
 	/*
-	 * utrace_add_engine() checks ->utrace_flags != 0.
-	 * Since @utrace->reap is set, nobody can set or clear
-	 * UTRACE_EVENT(REAP) in @engine->flags or change
-	 * @engine->ops, and nobody can change @utrace->attached.
+	 * utrace_add_engine() checks ->utrace_flags != 0.  Since
+	 * @utrace->reap is set, nobody can set or clear UTRACE_EVENT(REAP)
+	 * in @engine->flags or change @engine->ops and nobody can change
+	 * @utrace->attached after we drop the lock.
 	 */
 	target->utrace_flags = 0;
-	splice_attaching(utrace);
+
+	/*
+	 * We clear out @utrace->attached before we drop the lock so
+	 * that find_matching_engine() can't come across any old engine
+	 * while we are busy tearing it down.
+	 */
+	list_replace_init(&utrace->attached, &attached);
+	list_splice_tail_init(&utrace->attaching, &attached);
+
 	spin_unlock(&utrace->lock);
 
-	list_for_each_entry_safe(engine, next, &utrace->attached, entry) {
+	list_for_each_entry_safe(engine, next, &attached, entry) {
 		if (engine->flags & UTRACE_EVENT(REAP))
 			engine->ops->report_reap(engine, target);
 

