Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYGPM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYGPM3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYGPM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:29:36 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:2636 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYGPM3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:29:35 -0400
Subject: [PATCH][RFC] slub: increasing order reduces memory usage of some
	key caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, mpm@selenic.com
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 13:29:31 +0100
Message-Id: <1216211371.3122.46.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This test patch increases the order of those caches that will gain an
extra object per slab. In particular on 64 bit this effects dentry &
radix_tree_node.

On a freshly booted box after a kernel compile (make clean;make) there
is significant savings in both dentry & radix_tree_node

on my amd64 3 gb ram desktop typical numbers :-

[kernel,objects,pages/slab,slabs,total pages,diff]
radix_tree_node
2.6.26 33922,2,2423 	4846
+patch 33541,4,1165	4660,-186
dentry
2.6.26	82136,1,4323	4323
+patch	79482,2,2038	4076,-247
the extra dentries would use 136 pages but that still leaves a saving of
111 pages.

I see some improvement in iozone write/rewrite numbers particularly
apparent at the beginning of a run (I guess when there are no dirty
pages ?). 

I've also run this patch on my old laptop( Pentuim M 384Mb ram) & it
works with no problems. After a kernel make there's not much difference
in the used memory but I think I'm seeing a improvement in the elapsed
time. 35 minutes -> 33 minutes. However I've not run this enough times
to tell if this is just luck or noise!   

I've been running this on my desktop for several weeks without any
problems.

Can anyone suggest any other tests that would be useful to run?
& Is there any way to measure what impact this is having on
fragmentation?

Patch against 2.6.26 git.

Thanks
Richard




diff --git a/mm/slub.c b/mm/slub.c
index 315c392..c365b04 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2301,6 +2301,14 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 	if (order < 0)
 		return 0;
 
+	if (order < slub_max_order ) {
+		unsigned long waste = (PAGE_SIZE << order) % size;
+		if ( waste *2 >= size ) {
+			order++;
+			printk ( KERN_INFO "SLUB: increasing order %s->[%d] [%ld]\n",s->name,order,size);
+		}
+	}
+
 	s->allocflags = 0;
 	if (order)
 		s->allocflags |= __GFP_COMP;


