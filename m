Return-Path: <linux-kernel-owner+w=401wt.eu-S2992984AbXDYTZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992984AbXDYTZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992992AbXDYTZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:25:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34330 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992984AbXDYTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:25:41 -0400
Date: Wed, 25 Apr 2007 12:25:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
Subject: BUILD_BUG_ON does not work
Message-ID: <Pine.LNX.4.64.0704251202420.14341@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a simple patch attempting to use BUILD_ON to fail if a too
high slab size is requested. Currently we generate a link failure which
makes it difficult to detect bad kmallocs.

However the BUILD_BUG_ON never triggers. kmalloc(64 *1024*1024, 
GFP_KERNEL) returns 0 and we get an alloc from the 8 byte kmalloc cache.


kmalloc_index() returns a constant result and thus index is 
constant. What do I need to do to make BUILD_BUG_ON trigger?


SLUB: Use BUILD_BUG_ON to flag too big slab caches

Do not generate a link failure instead abort compilation
using BUILD_BUG_ON

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc7-mm1/include/linux/slub_def.h
===================================================================
--- linux-2.6.21-rc7-mm1.orig/include/linux/slub_def.h	2007-04-25 11:38:00.000000000 -0700
+++ linux-2.6.21-rc7-mm1/include/linux/slub_def.h	2007-04-25 11:38:14.000000000 -0700
@@ -140,17 +140,11 @@ static inline struct kmem_cache *kmalloc
 {
 	int index = kmalloc_index(size);
 
+	BUILD_BUG_ON(index < 0);
+
 	if (index == 0)
 		return NULL;
 
-	if (index < 0) {
-		/*
-		 * Generate a link failure. Would be great if we could
-		 * do something to stop the compile here.
-		 */
-		extern void __kmalloc_size_too_large(void);
-		__kmalloc_size_too_large();
-	}
 	return &kmalloc_caches[index];
 }
 
