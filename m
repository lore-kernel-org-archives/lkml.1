Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZLBIEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZLBIEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZLBIEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:04:22 -0500
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:65314 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZLBIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:04:21 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 03:04:21 EST
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, catalin.marinas@arm.com,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH 2/2] slab, kmemleak, bugfix, pass the correct pointer to kmemleak_erase()
Date: Wed,  2 Dec 2009 16:55:50 +0900
Message-Id: <1259740550-10394-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ____cache_alloc(), the variable 'ac' may be changed after
cache_alloc_refill() and the following kmemleak_erase() may get an
incorrect pointer.
Update 'ac' after cache_alloc_refill() unconditionally.
cf. http://marc.info/?l=linux-kernel&m=125873373124187&w=2
    and its thread.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 mm/slab.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 4e61449..66e9047 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3103,6 +3103,11 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	} else {
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
+		/*
+		 * the 'ac' may be updated by cache_alloc_refill(),
+		 * and kmemleak_erase() requires its correct value.
+		 */
+		ac = cpu_cache_get(cachep);
 	}
 	/*
 	 * To avoid a false negative, if an object that is in one of the
-- 
1.6.1.284.g5dc13

