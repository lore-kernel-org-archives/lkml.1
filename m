Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZA1ODX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZA1ODX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZA1N5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:47091 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbZA1N5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:32 -0500
Message-Id: <20090128135458.908979135@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:54:09 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/21] lockdep: remove macro usage from mark_held_locks()
Content-Disposition: inline; filename=lockdep-mark_held_locks.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have nice numerical relations for the states, remove the macro
magics.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2099,14 +2099,6 @@ enum mark_type {
 #undef LOCKDEP_STATE
 };
 
-#define MARK_HELD_CASE(__STATE)						\
-	case __STATE:							\
-		if (hlock->read)					\
-			usage_bit = LOCK_ENABLED_##__STATE##_READ;	\
-		else							\
-			usage_bit = LOCK_ENABLED_##__STATE;		\
-		break;
-
 /*
  * Mark all held locks with a usage bit:
  */
@@ -2120,13 +2112,11 @@ mark_held_locks(struct task_struct *curr
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		hlock = curr->held_locks + i;
 
-		switch (mark) {
-#define LOCKDEP_STATE(__STATE) MARK_HELD_CASE(__STATE)
-#include "lockdep_states.h"
-#undef LOCKDEP_STATE
-		default:
-			BUG();
-		}
+		usage_bit = 2 + (mark << 2); /* ENABLED */
+		if (hlock->read)
+			usage_bit += 1; /* READ */
+
+		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
 		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;

-- 

