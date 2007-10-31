Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXJaPqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXJaPqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXJaPqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:46:45 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:59634
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755128AbXJaPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:46:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] lockdep: fix mismatched lockdep_depth/curr_chain_hash
To: Greg KH <greg@kroah.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>, stable <stable@kernel.org>,
       <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 31 Oct 2007 11:44:05 -0400
Message-ID: <20071031154313.15685.72379.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
   Here is the backported version of the patch.  I applied it on top of
   2.6.22.10.  Let me know if you have any issues.

-Greg

------------------------------
lockdep: fix mismatched lockdep_depth/curr_chain_hash

It is possible for the current->curr_chain_key to become inconsistent with the
current index if the chain fails to validate.  The end result is that future
lock_acquire() operations may inadvertently fail to find a hit in the cache
resulting in a new node being added to the graph for every acquire.

[ peterz: this might explain some of the lockdep is so _slow_ complaints. ]
[ mingo: this does not impact the correctness of validation, but may slow
  down future operations significantly, if the chain gets very long. ]

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1a5ff22..072cf25 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2166,7 +2166,6 @@ out_calc_hash:
 	}
 #endif
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -2215,6 +2214,7 @@ out_calc_hash:
 		if (unlikely(!debug_locks))
 			return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP

