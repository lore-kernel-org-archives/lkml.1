Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZEHPK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZEHPK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZEHPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:10:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54338 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbZEHPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:10:29 -0400
Subject: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
Cc: gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       cl@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rientjes@google.com
Date: Fri, 08 May 2009 18:10:29 +0300
Message-Id: <1241795429.28600.61.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
BUG_ON() calls.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..55216b4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2109,9 +2109,8 @@ static void early_kmem_cache_node_alloc(gfp_t gfpflags, int node)
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
-	page = new_slab(kmalloc_caches, gfpflags, node);
+	page = new_slab(kmalloc_caches, gfpflags | GFP_PANIC, node);
 
-	BUG_ON(!page);
 	if (page_to_nid(page) != node) {
 		printk(KERN_ERR "SLUB: Unable to allocate memory from "
 				"node %d\n", node);
@@ -4367,10 +4366,9 @@ static struct kset *slab_kset;
  */
 static char *create_unique_id(struct kmem_cache *s)
 {
-	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
-	char *p = name;
+	char *name, *p;
 
-	BUG_ON(!name);
+	p = name = kmalloc(ID_STR_LENGTH, GFP_KERNEL | GFP_PANIC);
 
 	*p++ = ':';
 	/*
-- 
1.5.6.3



