Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbXCSI1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbXCSI1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXCSI1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:27:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41010 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXCSI1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:27:20 -0400
Date: Mon, 19 Mar 2007 10:27:18 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: ast@domdv.de, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This changes kmem_cache_free() to deal with NULL objects passed to it. The 
current behavior is inconsistent with kfree() so there are callers 
passing NULL to kmem_cache_free().

Andreas, can you please confirm this fixes the oops you reported on 
linux-scsi?

Cc: Andreas Steinmetz <ast@domdv.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-03-19 10:18:52.000000000 +0200
+++ 2.6/mm/slab.c	2007-03-19 10:19:42.000000000 +0200
@@ -3741,6 +3741,8 @@ EXPORT_SYMBOL(__kmalloc);
  * @cachep: The cache the allocation was from.
  * @objp: The previously allocated object.
  *
+ * If @objp is NULL, no operation is performed.
+ *
  * Free an object which was previously allocated from this
  * cache.
  */
@@ -3748,6 +3750,9 @@ void kmem_cache_free(struct kmem_cache *
 {
 	unsigned long flags;
 
+	if (unlikely(!objp))
+		return;
+
 	BUG_ON(virt_to_cache(objp) != cachep);
 
 	local_irq_save(flags);
