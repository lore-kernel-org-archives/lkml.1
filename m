Return-Path: <linux-kernel-owner+w=401wt.eu-S934541AbYBUAbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541AbYBUAbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYBUAbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:31:01 -0500
Received: from mga06.intel.com ([134.134.136.21]:40465 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755334AbYBUAbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:31:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="258820079"
Date: Wed, 20 Feb 2008 16:35:28 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH]iova-lockdep-false-alarm-fix.
Message-ID: <20080221003528.GA5566@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep goes off on the iova copy_reserved_iova because it and a
function it calls grabs locks in the from, and the to of the copy
operation.

This patch gives the reserved_ioval_list locks special lockdep classes.


--mgross

Signed-off-by: <mgross@linux.intel.com>


Index: linux-2.6.24-mm1/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/intel-iommu.c	2008-02-20 15:52:23.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/intel-iommu.c	2008-02-20 16:08:27.000000000 -0800
@@ -1127,6 +1127,8 @@
 }
 
 static struct iova_domain reserved_iova_list;
+static struct lock_class_key reserved_alloc_key;
+static struct lock_class_key reserved_rbtree_key;
 
 static void dmar_init_reserved_ranges(void)
 {
@@ -1137,6 +1139,11 @@
 
 	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
 
+	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
+		&reserved_alloc_key);
+	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
+		&reserved_rbtree_key);
+
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
 		IOVA_PFN(IOAPIC_RANGE_END));
