Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbZDGPXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbZDGPXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbZDGPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:10:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328AbZDGPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:10:23 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: [PATCH] [12/16] POISON: Handle poisoned pages in set_page_dirty()
Message-Id: <20090407151009.AFEE01D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:10:09 +0200 (CEST)
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
--- linux.orig/mm/page-writeback.c	2009-04-07 16:39:22.000000000 +0200
+++ linux/mm/page-writeback.c	2009-04-07 16:39:39.000000000 +0200
@@ -1277,6 +1277,10 @@
 {
 	struct address_space *mapping = page_mapping(page);
 
+	if (unlikely(PagePoison(page))) {
+		SetPageDirty(page);
+		return 0;
+	}
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 #ifdef CONFIG_BLOCK
