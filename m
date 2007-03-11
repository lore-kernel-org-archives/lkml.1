Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXCKCKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXCKCKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXCKCKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:10:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57740 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932636AbXCKCK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:10:26 -0500
From: Christoph Lameter <clameter@sgi.com>
To: akpm@osdl.org
Cc: linux-mm@kvack.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070311021026.19963.48123.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070311021009.19963.11893.sendpatchset@schroedinger.engr.sgi.com>
References: <20070311021009.19963.11893.sendpatchset@schroedinger.engr.sgi.com>
Subject: [SLUB 3/3] Configurable slub_max_order
Date: Sat, 10 Mar 2007 18:10:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add slub_max_order

Avoid slabs getting to large. Do no longer enforce slub_min_objects
if the slab gets bigger than slub_max_order.

I am not sure if we really want this. Maybe we should make the
selection of the base page size depending on page allocator
defrag behavior? I.e. try to restrict allocations to order 0 and order 2
so that can limit fragmentation?

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc3/mm/slub.c
===================================================================
--- linux-2.6.21-rc3.orig/mm/slub.c	2007-03-10 13:14:06.000000000 -0800
+++ linux-2.6.21-rc3/mm/slub.c	2007-03-10 13:14:11.000000000 -0800
@@ -1211,6 +1211,7 @@ static __always_inline struct page *get_
  * take the list_lock.
  */
 static int slub_min_order = 0;
+static int slub_max_order = 4;
 
 /*
  * Minimum number of objects per slab. This is necessary in order to
@@ -1249,7 +1250,11 @@ static int calculate_order(int size)
 			order < MAX_ORDER; order++) {
 		unsigned long slab_size = PAGE_SIZE << order;
 
-		if (slab_size < slub_min_objects * size)
+		if (slub_max_order > order &&
+				slab_size < slub_min_objects * size)
+			continue;
+
+		if (slab_size < size)
 			continue;
 
 		rem = slab_size % size;
@@ -1637,6 +1642,15 @@ static int __init setup_slub_min_order(c
 
 __setup("slub_min_order=", setup_slub_min_order);
 
+static int __init setup_slub_max_order(char *str)
+{
+	get_option (&str, &slub_max_order);
+
+	return 1;
+}
+
+__setup("slub_max_order=", setup_slub_max_order);
+
 static int __init setup_slub_min_objects(char *str)
 {
 	get_option (&str, &slub_min_objects);
