Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbZAWBZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbZAWBZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760172AbZAWBP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:28 -0500
Received: from kroah.org ([198.145.64.141]:50366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756162AbZAWBOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:42 -0500
Date: Thu, 22 Jan 2009 17:11:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Kristian Hgsberg <krh@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 05/46] lib/idr.c: use kmem_cache_zalloc() for the idr_layer
	cache
Message-ID: <20090123011135.GF19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lib-idr.c-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 5b019e99016f3a692ba45bf68fba73a402d7c01a upstream.

David points out that the idr_remove_all() function returns unused slabs
to the kmem cache, but needs to zero them first or else they will be
uninitialized upon next use.  This causes crashes which have been observed
in the firewire subsystem.

He fixed this by zeroing the object before freeing it in idr_remove_all().

But we agree that simply removing the constructor and zeroing the object
at allocation time is simpler than relying upon slab constructor machinery
and might even be faster.

This problem was introduced by "idr: make idr_remove rcu-safe" (commit
cf481c20c476ad2c0febdace9ce23f5a4db19582), which was first released in
2.6.27.

There are no known codesites which trigger this bug in 2.6.27 or 2.6.28.
The post-2.6.28 firewire changes are the only known triggerer.

There might of course be not-yet-discovered triggerers in 2.6.27 and
2.6.28, and there might be out-of-tree triggerers which are added to those
kernel versions.  I'll let the -stable guys decide whether they want to
backport this fix.

Reported-by: David Moore <dcm@acm.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Kristian Hgsberg <krh@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/idr.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 {
 	while (idp->id_free_cnt < IDR_FREE_MAX) {
 		struct idr_layer *new;
-		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
+		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
 			return (0);
 		move_to_free_list(idp, new);
@@ -623,16 +623,10 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(void *idr_layer)
-{
-	memset(idr_layer, 0, sizeof(struct idr_layer));
-}
-
 void __init idr_init_cache(void)
 {
 	idr_layer_cache = kmem_cache_create("idr_layer_cache",
-				sizeof(struct idr_layer), 0, SLAB_PANIC,
-				idr_cache_ctor);
+				sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
 }
 
 /**

