Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYKTQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYKTQoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYKTQoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:44:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:4640 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYKTQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=URQ6CF3xcGjc7MiMwEEpJcgktBn0geqE8bKERd5gnV9y+MV9DIl9PYN/0x1xJQf8zV
         Sob3hFalUj9LAnaIGnZ9wmdxfZuRqTtSV1iDsEazwtPdIxytH0aFe8lYK31xAe8UQC4M
         eW29fNt7kWEJZN7xQLCUAS/y6wu3M9KXa0re8=
Date: Thu, 20 Nov 2008 19:44:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: mm: slab - __cache_alloc NULL prefetch fix
Message-ID: <20081120164400.GC7363@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not prefetch NULL

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please check

 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.git/mm/slab.c
===================================================================
--- linux-2.6.git.orig/mm/slab.c
+++ linux-2.6.git/mm/slab.c
@@ -3395,10 +3395,11 @@ __cache_alloc(struct kmem_cache *cachep,
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
-	prefetchw(objp);
 
-	if (likely(objp))
+	if (likely(objp)) {
+		prefetchw(objp);
 		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
+	}
 
 	if (unlikely((flags & __GFP_ZERO) && objp))
 		memset(objp, 0, obj_size(cachep));
