Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbYGOSXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbYGOSXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbYGOSW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:22:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59955 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbYGOSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:22:56 -0400
Date: Tue, 15 Jul 2008 21:22:38 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adobriyan@gmail.com, cl@linux-foundation.org, rabin@rab.in
Subject: [GIT PULL] SLUB/SLAB updates for 2.6.27
Message-ID: <Pine.LNX.4.64.0807152119160.1767@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The tree has some small fixes and cleanups accumulated over the past few weeks.

                Pekka

Alexey Dobriyan (1):
      slub: current is always valid

Christoph Lameter (1):
      slub: Add check for kfree() of non slab objects.

Rabin Vincent (1):
      slab: rename slab_destroy_objs

 mm/slab.c |   14 +++-----------
 mm/slub.c |    3 ++-
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 046607f..b4aa4c8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1901,15 +1901,7 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
 #endif
 
 #if DEBUG
-/**
- * slab_destroy_objs - destroy a slab and its objects
- * @cachep: cache pointer being destroyed
- * @slabp: slab pointer being destroyed
- *
- * Call the registered destructor for each object in a slab that is being
- * destroyed.
- */
-static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
+static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slabp)
 {
 	int i;
 	for (i = 0; i < cachep->num; i++) {
@@ -1938,7 +1930,7 @@ static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
 	}
 }
 #else
-static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
+static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slabp)
 {
 }
 #endif
@@ -1956,7 +1948,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 {
 	void *addr = slabp->s_mem - slabp->colouroff;
 
-	slab_destroy_objs(cachep, slabp);
+	slab_destroy_debugcheck(cachep, slabp);
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slab_rcu *slab_rcu;
 
diff --git a/mm/slub.c b/mm/slub.c
index 5f6e2c4..488400d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -411,7 +411,7 @@ static void set_track(struct kmem_cache *s, void *object,
 	if (addr) {
 		p->addr = addr;
 		p->cpu = smp_processor_id();
-		p->pid = current ? current->pid : -1;
+		p->pid = current->pid;
 		p->when = jiffies;
 	} else
 		memset(p, 0, sizeof(struct track));
@@ -2766,6 +2766,7 @@ void kfree(const void *x)
 
 	page = virt_to_head_page(x);
 	if (unlikely(!PageSlab(page))) {
+		BUG_ON(!PageCompound(page));
 		put_page(page);
 		return;
 	}
