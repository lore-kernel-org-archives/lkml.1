Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYBJKW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYBJKW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYBJKWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:22:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:9125 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYBJKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ia9io0GiXaGtvNGFVK1QGkpx4TT5zSbQ7v+Iok2ftRGyAFJ3yE4/tTws+Z9jEtwbkL4UxZ7pjLbDWjYJ3zQ4Pi7/uCSIgsDV51JxUw8ASe6YFKgD4si8UCUn9eBYGhclRbZtlTYR0m13FPuDN5GfR0zDAt9ZOzytdiy0tZxCP4M=
Date: Sun, 10 Feb 2008 11:21:54 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH resend] slab: avoid double initialization & do
	initialization in 1 place
Message-ID: <20080210102150.GD6737@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- alloc_slabmgmt: initialize all slab fields in 1 place
- slab->nodeid was initialized twice: in alloc_slabmgmt
  and immediately after it in cache_grow

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 40c00da..473e6c2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2630,6 +2630,7 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
 	slabp->nodeid = nodeid;
+	slabp->free = 0;
 	return slabp;
 }
 
@@ -2683,7 +2684,6 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		slab_bufctl(slabp)[i] = i + 1;
 	}
 	slab_bufctl(slabp)[i - 1] = BUFCTL_END;
-	slabp->free = 0;
 }
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
@@ -2816,7 +2816,6 @@ static int cache_grow(struct kmem_cache *cachep,
 	if (!slabp)
 		goto opps1;
 
-	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
 	cache_init_objs(cachep, slabp);
-- 
1.5.3.7

