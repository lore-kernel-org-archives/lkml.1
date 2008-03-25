Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYCYRtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYCYRtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYCYRtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:49:40 -0400
Received: from usea-naimss1.unisys.com ([192.61.61.103]:2161 "EHLO
	usea-naimss1.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbYCYRtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:49:39 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 13:49:39 EDT
Subject: [PATCH] list_add corruption in slab.c
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Mar 2008 12:57:38 -0400
Message-Id: <1206464258.13473.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
X-OriginalArrivalTime: 25 Mar 2008 17:16:08.0164 (UTC) FILETIME=[EA46C240:01C88E9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing list_add corruption in slab.c on the ES7000 since the
2.6.24.1 kernel.  There are several places where the initkmem_list3
array is access by [somevalue + node].  This also needs to be done in
kmem_cache_init().  

Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

---
diff -Naur linux-2.6.25-rc5/mm/slab.c linux-2.6.25-rc5-new/mm/slab.c
--- linux-2.6.25-rc5/mm/slab.c	2008-03-10 01:22:27.000000000 -0400
+++ linux-2.6.25-rc5-new/mm/slab.c	2008-03-20 13:59:24.000000000 -0400
@@ -1481,7 +1481,7 @@
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which

