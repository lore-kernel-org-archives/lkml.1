Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZFCSso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZFCSso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZFCSrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:47:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37844 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZFCSrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:47:02 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090603846.816684333@firstfloor.org>
In-Reply-To: <20090603846.816684333@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [10/16] HWPOISON: Handle poisoned pages in set_page_dirty()
Message-Id: <20090603184644.190E71D0281@basil.firstfloor.org>
Date: Wed,  3 Jun 2009 20:46:43 +0200 (CEST)
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
--- linux.orig/mm/page-writeback.c	2009-06-03 19:36:20.000000000 +0200
+++ linux/mm/page-writeback.c	2009-06-03 19:36:23.000000000 +0200
@@ -1304,6 +1304,10 @@
 {
 	struct address_space *mapping = page_mapping(page);
 
+	if (unlikely(PageHWPoison(page))) {
+		SetPageDirty(page);
+		return 0;
+	}
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 #ifdef CONFIG_BLOCK
