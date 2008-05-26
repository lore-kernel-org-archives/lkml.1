Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYEZPj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYEZPj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYEZPjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:39:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58775 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYEZPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:39:20 -0400
Date: Mon, 26 May 2008 18:39:18 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Matt Mackall <mpm@selenic.com>, MinChan Kim <minchan.kim@gmail.com>,
       akpm@linux-foundation.org
Subject: [GIT PULL] SLUB/SLOB updates for 2.6.26
Message-ID: <Pine.LNX.4.64.0805261838340.24399@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

It has a fix for out-of-memory condition in SLOB and a new WARN_ON for SLUB to
detect ksize() abuse.

                Pekka

MinChan Kim (1):
      slob: Fix to return wrong pointer

Pekka Enberg (1):
      slub: ksize() abuse checks

 mm/slob.c |    5 +++--
 mm/slub.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 6038cba..a3ad667 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -469,8 +469,9 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			return ZERO_SIZE_PTR;
 
 		m = slob_alloc(size + align, gfp, align, node);
-		if (m)
-			*m = size;
+		if (!m)
+			return NULL;
+		*m = size;
 		return (void *)m + align;
 	} else {
 		void *ret;
diff --git a/mm/slub.c b/mm/slub.c
index a505a82..0987d1c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2726,9 +2726,10 @@ size_t ksize(const void *object)
 
 	page = virt_to_head_page(object);
 
-	if (unlikely(!PageSlab(page)))
+	if (unlikely(!PageSlab(page))) {
+		WARN_ON(!PageCompound(page));
 		return PAGE_SIZE << compound_order(page);
-
+	}
 	s = page->slab;
 
 #ifdef CONFIG_SLUB_DEBUG
