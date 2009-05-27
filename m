Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbZE0UQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbZE0UQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761578AbZE0UMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:12:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35937 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761486AbZE0UMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:12:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905271012.668777061@firstfloor.org>
In-Reply-To: <200905271012.668777061@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [11/16] HWPOISON: Handle poisoned pages in set_page_dirty()
Message-Id: <20090527201237.B7A611D028F@basil.firstfloor.org>
Date: Wed, 27 May 2009 22:12:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bail out early in set_page_dirty for poisoned pages. We don't want any
of the dirty accounting done or file system write back started, because
the page will be just thrown away.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2009-05-26 22:15:37.000000000 +0200
+++ linux/mm/page-writeback.c	2009-05-27 21:14:21.000000000 +0200
@@ -1277,6 +1277,10 @@
 {
 	struct address_space *mapping = page_mapping(page);
 
+	if (unlikely(PageHWPoison(page))) {
+		SetPageDirty(page);
+		return 0;
+	}
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 #ifdef CONFIG_BLOCK
