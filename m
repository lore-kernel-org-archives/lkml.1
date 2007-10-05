Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXJEEYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXJEEYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXJEEY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:24:28 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:42744
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbXJEEY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:24:27 -0400
X-Greylist: delayed 1148 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 00:24:27 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] LOCKDEP: fix mismatched lockdep_depth/curr_chain_hash
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 05 Oct 2007 00:22:12 -0400
Message-ID: <20071005041939.20566.51093.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doh!  I guess there should be a rule about sending patches out after midnight
;)

The original patch I worked on was written before the code was moved to
validate_chain(), so my previous posting didnt quite translate when I merged
with git HEAD.  Here is an updated patch.  Sorry for the confusion.

Regards,
-Greg


---

 kernel/lockdep.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 734da57..42ae4a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head)
+	       	struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -1534,7 +1534,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+			lookup_chain_cache(chain_key, hlock->class)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -1576,7 +1576,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 #else
 static inline int validate_chain(struct task_struct *curr,
 	       	struct lockdep_map *lock, struct held_lock *hlock,
-		int chain_head)
+		int chain_head, u64 chain_key)
 {
 	return 1;
 }
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		chain_head = 1;
 	}
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
-	if (!validate_chain(curr, lock, hlock, chain_head))
+	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP

