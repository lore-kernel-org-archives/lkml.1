Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXL0U12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXL0U12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 15:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXL0U1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 15:27:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:63004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXL0U1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 15:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=AE4VCVQ+XuA4YPYmFs6Ye7EDFDwPQj0VBN5G/3+IjdEI7Oje9IfehQ7uSkHV9nuc5zyjYO57E1qojouHb6n1N8xCb9ZNvkDwpkzd0S1AykyksuARGFnpwWG1WFCpfxahqd0PKq7Cm0VeM9Su/kpl6XI6eII1kShfuzGxa6prTHs=
Date: Thu, 27 Dec 2007 21:28:52 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] slab: avoid double initialization & do it in 1 function
Message-ID: <20071227202849.GA11114@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* alloc_slabmgmt: initialize all slab fields in 1 function
* slab->nodeid was initialized twice: in alloc_slabmgmt
  and immediately after it in cache_grow

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
diff --git a/mm/slab.c b/mm/slab.c
index 2e338a5..458b07a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2626,6 +2626,7 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
 	slabp->nodeid = nodeid;
+	slabp->free = 0;
 	return slabp;
 }
 
@@ -2679,7 +2680,6 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		slab_bufctl(slabp)[i] = i + 1;
 	}
 	slab_bufctl(slabp)[i - 1] = BUFCTL_END;
-	slabp->free = 0;
 }
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
@@ -2812,7 +2812,6 @@ static int cache_grow(struct kmem_cache *cachep,
 	if (!slabp)
 		goto opps1;
 
-	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
 	cache_init_objs(cachep, slabp);
