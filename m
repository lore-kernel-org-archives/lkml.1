Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZLWW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZLWW6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZLWW6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:58:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42793 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZLWW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:58:51 -0500
Date: Thu, 24 Dec 2009 09:58:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>
Subject: linux-next: slab/percpu tree build failure
Message-Id: <20091224095848.f1586d1e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

mm/slub.c: In function 'alloc_kmem_cache_cpus':
mm/slub.c:2074: error: implicit declaration of function 'per_cpu_var'
mm/slub.c:2074: warning: assignment makes pointer from integer without a cast

Caused by commit 9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864 ("SLUB: Use
this_cpu operations in slub") from the slab interacting with commit
dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu: remove per_cpu__
prefix") from the percpu tree.

I have added the following patch for today and (can carry it as
necessary).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Dec 2009 09:56:29 +1100
Subject: [PATCH] slab: update for percpu API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6e34309..9e86e6b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2071,7 +2071,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 		 * Boot time creation of the kmalloc array. Use static per cpu data
 		 * since the per cpu allocator is not available yet.
 		 */
-		s->cpu_slab = per_cpu_var(kmalloc_percpu) + (s - kmalloc_caches);
+		s->cpu_slab = kmalloc_percpu + (s - kmalloc_caches);
 	else
 		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);
 
-- 
1.6.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
