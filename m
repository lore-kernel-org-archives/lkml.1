Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbXBDSj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbXBDSj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 13:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXBDSj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 13:39:59 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59110 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbXBDSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 13:39:58 -0500
Subject: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
From: David Moore <dcm@MIT.EDU>
To: linux-kernel <linux-kernel@vger.kernel.org>, discuss@x86-64.org,
       akpm@linux-foundation.org
Cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Jan Beulich <jbeulich@novell.com>
Content-Type: text/plain
Date: Sun, 04 Feb 2007 13:39:40 -0500
Message-Id: <1170614380.26464.52.camel@PISCES.MIT.EDU>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Moore <dcm@acm.org>

Adds missing call to phys_to_virt() in the
lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
panic will always occur whenever a SWIOTLB bounce buffer from a
scatter-gather list gets synced.

Signed-off-by: David Moore <dcm@acm.org>
---

This change was originally part of a larger patch by Jan Beulich, which
was more extensive and doesn't look destined to make it into 2.6.20:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/ia64-swiotlb-bug-fixes.patch

However, considering the severity of this one-liner bug, I would like to
request that this simplified patch make it into 2.6.20, despite how
close we are to the final cut.  It fixes real crashes:
http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
http://qa.mandriva.com/show_bug.cgi?id=28224
http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce

--- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
+++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
@@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, (void *) sg->dma_address,
+			sync_single(hwdev, phys_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 }
 


