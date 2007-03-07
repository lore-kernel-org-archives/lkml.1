Return-Path: <linux-kernel-owner+w=401wt.eu-S1422968AbXCGR4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422968AbXCGR4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422776AbXCGROA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:42799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXCGRNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:51 -0500
Message-Id: <20070307171156.140479670@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, discuss@x86-64.org,
       Jan Beulich <jbeulich@novell.com>, David Moore <dcm@mit.edu>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       David Moore <dcm@acm.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 012/101] Missing critical phys_to_virt in lib/swiotlb.c
Content-Disposition: inline; filename=missing-critical-phys_to_virt-in-lib-swiotlb.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Moore <dcm@acm.org>

Missing critical phys_to_virt in lib/swiotlb.c

Adds missing call to phys_to_virt() in the
lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
panic will always occur whenever a SWIOTLB bounce buffer from a
scatter-gather list gets synced.  Affected are especially Intel x86_64
machines with more than about 3 GB RAM.

Signed-off-by: David Moore <dcm@acm.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/swiotlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/lib/swiotlb.c
+++ linux-2.6.20.1/lib/swiotlb.c
@@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, (void *) sg->dma_address,
+			sync_single(hwdev, phys_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 }
 

--
