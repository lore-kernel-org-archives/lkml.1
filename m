Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbXFAEOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbXFAEOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXFAEOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:14:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58560 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbXFAEOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:14:21 -0400
Date: Fri, 1 Jun 2007 13:13:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: Fix slab debug for non alien caches.
Message-ID: <20070601041317.GA8490@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when slab debugging is enabled, the WARN_ON() nodeid checks
trigger if we boot with 'noaliencache'. In the noaliencache case the
WARN_ON()'s seem to be superfluous, so only bother doing the nodeid
comparison if use_alien_caches is set.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 2e71a32..88db26b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2663,7 +2663,7 @@ static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slabp,
 	next = slab_bufctl(slabp)[slabp->free];
 #if DEBUG
 	slab_bufctl(slabp)[slabp->free] = BUFCTL_FREE;
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(use_alien_caches && slabp->nodeid != nodeid);
 #endif
 	slabp->free = next;
 
@@ -2677,7 +2677,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct slab *slabp,
 
 #if DEBUG
 	/* Verify that the slab belongs to the intended node */
-	WARN_ON(slabp->nodeid != nodeid);
+	WARN_ON(use_alien_caches && slabp->nodeid != nodeid);
 
 	if (slab_bufctl(slabp)[objnr] + 1 <= SLAB_LIMIT + 1) {
 		printk(KERN_ERR "slab: double free detected in cache "
