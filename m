Return-Path: <linux-kernel-owner+w=401wt.eu-S965823AbXCVGFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823AbXCVGFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965824AbXCVGE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:57 -0400
Received: from ozlabs.org ([203.10.76.45]:57911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965823AbXCVGEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:04:07 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:29 +1100
Subject: [RFC/PATCH 13/15] get_unmapped_area handles MAP_FIXED in /dev/mem (nommu)
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060303.7561ADDFF9@ozlabs.org>
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
