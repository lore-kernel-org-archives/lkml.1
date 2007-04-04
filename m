Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXDDEDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXDDEDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992599AbXDDECo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:02:44 -0400
Received: from ozlabs.org ([203.10.76.45]:49672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992594AbXDDECc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:02:32 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:02:21 +1000
Subject: [PATCH 12/14] get_unmapped_area handles MAP_FIXED in /dev/mem (nommu)
In-Reply-To: <1175659331.690672.592289266160.qpush@grosgo>
Message-Id: <20070404040232.2FEF6DDEBA@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This also fixes a bug, I think, it used to return a pgoff (pfn)
instead of an address. (To split ?)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/char/mem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-cell/drivers/char/mem.c
===================================================================
--- linux-cell.orig/drivers/char/mem.c	2007-03-22 16:24:04.000000000 +1100
+++ linux-cell/drivers/char/mem.c	2007-03-22 16:26:30.000000000 +1100
@@ -246,9 +246,12 @@ static unsigned long get_unmapped_area_m
 					   unsigned long pgoff,
 					   unsigned long flags)
 {
+	if (flags & MAP_FIXED)
+		if ((addr >> PAGE_SHIFT) != pgoff)
+			return (unsigned long) -EINVAL;
 	if (!valid_mmap_phys_addr_range(pgoff, len))
 		return (unsigned long) -EINVAL;
-	return pgoff;
+	return pgoff << PAGE_SHIFT;
 }
 
 /* can't do an in-place private mapping if there's no MMU */
