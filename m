Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYBAP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYBAP4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYBAPz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:55:56 -0500
Received: from xyzzy.farnsworth.org ([65.39.95.219]:39881 "EHLO
	xyzzy.farnsworth.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYBAPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:55:55 -0500
X-Greylist: delayed 2056 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 10:55:55 EST
Date: Fri, 1 Feb 2008 08:21:06 -0700
From: Dale Farnsworth <dale@farnsworth.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20080201152106.GA21534@farnsworth.org>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Subject: [PATCH] lockdep: Include all lock classes in all_lock_classes
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add each lock class to the all_lock_classes list when it is
first registered.

Previously, lock classes were added to all_lock_classes when
the lock class was first used.  Since one of the uses of the
list is to find unused locks, this didn't work well.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 kernel/lockdep.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 723bd9f..e630127 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -779,6 +779,10 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	 * parallel walking of the hash-list safe:
 	 */
 	list_add_tail_rcu(&class->hash_entry, hash_head);
+	/*
+	 * Add it to the global list of classes:
+	 */
+	list_add_tail_rcu(&class->lock_entry, &all_lock_classes);
 
 	if (verbose(class)) {
 		graph_unlock();
@@ -2282,10 +2286,6 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			return 0;
 		break;
 	case LOCK_USED:
-		/*
-		 * Add it to the global list of classes:
-		 */
-		list_add_tail_rcu(&this->class->lock_entry, &all_lock_classes);
 		debug_atomic_dec(&nr_unused_locks);
 		break;
 	default:
-- 
1.5.3.4

