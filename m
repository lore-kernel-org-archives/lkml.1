Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbXJEE1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbXJEE1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXJEE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:26:56 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:51981
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbXJEE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:26:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] LOCKDEP: fix mismatched lockdep_depth/curr_chain_hash
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 05 Oct 2007 00:03:01 -0400
Message-ID: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
  I am seeing a problem on the latest -rt where lockdep completely overwhelms
  the system to the point that it grinds to a halt on large (8-way+) systems.
  The problem seems to be that the class->locks_before and locks_after grow
  unbounded (I have observed over 1M+ entries in them) so a lock_acquire call
  can take over 10 seconds to finish resolving.  Related to this seems to be
  that lockdep appears to see a chain-hash miss over and over for what I would
  assume should be an established graph (for instance, in
  double_lock_balance() in an rt_overload condition).  Turning off
  PROVE_LOCKING (statically, or by setting debug_locks=0 dynamically restores
  the system to normal behavior.

  I took some time tonight to study lockdep (it is quite an impressive body of
  code!), and came up with the following "fix".  It does improve things
  significantly by addressing what I believe is the issue with the
  cache-misses (though it would appear there are still a few more issues
  there that need addressing as some boots are still very lethargic).  I use 
  the term "fix" loosely since I am not confident that I fully understand the
  intention of your logic here so I can't say for sure if it was really
  broken, or if I have made it worse ;)

  Could you comment on what I have done here, or offer any advice on what to
  look for elsewhere?  I based the patch on pure linux-2.6.git since I see the
  same issue (by visual inspection, that is) there as well.

  Thanks in advance!
  -Greg   

------

LOCKDEP: fix mismatched lockdep_depth/curr_chain_hash

It is possible for the current->curr_chain_key to become inconsistent with the
current index if the chain fails to validate.  The end result is that future
lock_acquire() operations may inadvertently fail to find a hit in the cache
resulting in a new node being added to the graph for every acquire.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 734da57..efb0d7e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		chain_head = 1;
 	}
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
 	if (!validate_chain(curr, lock, hlock, chain_head))
 		return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP

