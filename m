Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXGYOxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXGYOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXGYOxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:53:33 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:42453 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXGYOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:53:33 -0400
Date: Wed, 25 Jul 2007 15:53:30 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bob.picco@hp.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
Message-ID: <20070725145330.GA14970@skynet.ie>
References: <20070313104201.GA16842@skynet.ie> <20070724220116.0d9fb8b5.akpm@linux-foundation.org> <20070725144944.GD32445@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070725144944.GD32445@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/07/07 15:49), Mel Gorman didst pronounce:
> > SuperH allmodconfig blew up:
> > 
> > mm/sparse.c: In function `sparse_init':
> > mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> > mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> > mm/sparse.c: In function `sparse_add_one_section':
> > mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> > mm/sparse.c:553: warning: assignment makes pointer from integer without a cast
> 
> This error is due to a bad interaction between
> generic-virtual-memmap-support-for-sparsemem.patch and
> fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
> . Functions that are needed whether CONFIG_SPARSEMEM_VMEMMAP is set are
> not are depending on CONFIG_SPARSEMEM_VMEMMAP . This breaks on arch/sh
> for example where SPARSEMEM may be set but not NUMA.
> 

This patch only moves code and does not alter it. However, as SPARSEMEM
is set without NUMA, the code move generates a warning on SuperH because
NODE_DATA(nid) is a no-op. The following patch supresses the warning

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

---
 sparse.c |    3 +++
 1 file changed, 3 insertions(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c linux-2.6.23-rc1-mm1-010-sh-sparsemem-fix-warning/mm/sparse.c
--- linux-2.6.23-rc1-mm1-005-sh-sparsemem-fix/mm/sparse.c	2007-07-25 14:27:58.000000000 +0100
+++ linux-2.6.23-rc1-mm1-010-sh-sparsemem-fix-warning/mm/sparse.c	2007-07-25 15:43:07.000000000 +0100
@@ -245,6 +245,9 @@ static unsigned long *sparse_early_usema
 	if (usemap)
 		return usemap;
 
+	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
+	nid = 0;
+
 	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
 	return NULL;
 }
