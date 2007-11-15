Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXKOGLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXKOGLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXKOGK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXKOGK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:26 -0500
Date: Wed, 14 Nov 2007 22:09:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 01/13] lockdep: fix mismatched lockdep_depth/curr_chain_hash
Message-ID: <20071115060917.GB7602@kroah.com>
References: <20071115042610.731859958@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch"
In-Reply-To: <20071115060544.GA7602@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gregory Haskins <ghaskins@novell.com>

patch 3aa416b07f0adf01c090baab26fb70c35ec17623 in mainline.

It is possible for the current->curr_chain_key to become inconsistent
with the current index if the chain fails to validate.  The end result
is that future lock_acquire() operations may inadvertently fail to find
a hit in the cache resulting in a new node being added to the graph for
every acquire.


Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
@@ -1534,7 +1534,7 @@ static int validate_chain(struct task_st
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+			lookup_chain_cache(chain_key, hlock->class)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -1576,7 +1576,7 @@ static int validate_chain(struct task_st
 #else
 static inline int validate_chain(struct task_struct *curr,
 	       	struct lockdep_map *lock, struct held_lock *hlock,
-		int chain_head)
+		int chain_head, u64 chain_key)
 {
 	return 1;
 }
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep
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

-- 
