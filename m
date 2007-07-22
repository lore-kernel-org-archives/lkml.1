Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXGVPpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXGVPpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXGVPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbXGVPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=InR6WEM2/CpT1AZcsJXTKvLnkcqN0nXDCcsAZEHpC/dgoWL4I81sugRRkhB9F6R9JWaFrhRoSuBsrkUJqS3fCIdINNRVhkgltG5OsgtcA808XSPYNBDoyamJdGVJ8nGkXgdFljye8WTL8PChdiTpj6JGB3nuMOtNxw4EzBa09GE=
Message-Id: <20070722153342.726607571@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 2/9] slab: fix memory leak in cpu hotplug error path
Content-Disposition: inline; filename=slab-cpuhotplug-memleak-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes memory leak in error path.

In reality, we don't need to call cpuup_canceled(cpu) for now.
But upcoming cpu hotplug error handling change needs this.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slab.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: 2.6-git/mm/slab.c
===================================================================
--- 2.6-git.orig/mm/slab.c
+++ 2.6-git/mm/slab.c
@@ -1282,13 +1282,18 @@ static int __cpuinit cpuup_prepare(long 
 			shared = alloc_arraycache(node,
 				cachep->shared * cachep->batchcount,
 				0xbaadf00d);
-			if (!shared)
+			if (!shared) {
+				kfree(nc);
 				goto bad;
+			}
 		}
 		if (use_alien_caches) {
 			alien = alloc_alien_cache(node, cachep->limit);
-			if (!alien)
+			if (!alien) {
+				kfree(shared);
+				kfree(nc);
 				goto bad;
+			}
 		}
 		cachep->array[cpu] = nc;
 		l3 = cachep->nodelists[node];
@@ -1315,6 +1320,7 @@ static int __cpuinit cpuup_prepare(long 
 	}
 	return 0;
 bad:
+	cpuup_canceled(cpu);
 	return -ENOMEM;
 }
 

-- 
