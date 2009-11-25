Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbZKYSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbZKYSVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbZKYSVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:21:30 -0500
Received: from smtp6.welho.com ([213.243.153.40]:54919 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbZKYSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:21:30 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
Date: Wed, 25 Nov 2009 20:21:19 +0200
Message-Id: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlikely() annotation in slab_alloc() covers too much of the expression.
It's actually very likely that the object is not NULL so use unlikely() only
for the __GFP_ZERO expression like SLAB does.

The patch reduces kernel text by 29 bytes on x86-64:

   text	   data	    bss	    dec	    hex	filename
  24185	   8560	    176	  32921	   8099	mm/slub.o.orig
  24156	   8560	    176	  32892	   807c	mm/slub.o

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4996fc7..0956396 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1735,7 +1735,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	}
 	local_irq_restore(flags);
 
-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, objsize);
 
 	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
-- 
1.6.3.3

