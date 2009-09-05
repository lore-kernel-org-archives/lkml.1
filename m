Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZIEOPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZIEOPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 10:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZIEOPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 10:15:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57923 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZIEOPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 10:15:14 -0400
Date: Sat, 5 Sep 2009 17:15:16 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, eric.dumazet@gmail.com,
       paulmck@linux.vnet.ibm.com, stable@kernel.org, zdenek.kabelac@gmail.com
Subject: [GIT PULL] SLUB RCU fix for 2.6.31
Message-ID: <alpine.DEB.2.00.0909051710360.30081@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a last minute RCU fix for SLUB from Eric Dumazet. It's a bug fix to Paul
McKenney's commit 7ed9f7e5db58c6e8c2b4b738a75d5dcd8e17aad5 ("fix
RCU-callback-after-kmem_cache_destroy problem in sl[aou]b") that added the
rcu_barrier() call too early in kmem_cache_destroy(). You can find full
discussion of the bug here:

   http://thread.gmane.org/gmane.linux.kernel/876016/focus=876086

The bug can be triggered with "rmmod nf_conntrack", for example. I think 
the fix is simple enough to be merged this late in the release cycle 
but we can also defer the fix to 2.6.31.1 if you don't feel comfortable 
with merging it now.

 			Pekka

The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
   Linus Torvalds (1):
         Linux 2.6.31-rc8

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 slab/urgent

Eric Dumazet (1):
       slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU

  mm/slub.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..b627675 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2594,8 +2594,6 @@ static inline int kmem_cache_close(struct kmem_cache *s)
   */
  void kmem_cache_destroy(struct kmem_cache *s)
  {
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		rcu_barrier();
  	down_write(&slub_lock);
  	s->refcount--;
  	if (!s->refcount) {
@@ -2606,6 +2604,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
  				"still has objects.\n", s->name, __func__);
  			dump_stack();
  		}
+		if (s->flags & SLAB_DESTROY_BY_RCU)
+			rcu_barrier();
  		sysfs_slab_remove(s);
  	} else
  		up_write(&slub_lock);
