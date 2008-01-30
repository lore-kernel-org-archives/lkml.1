Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbYA3SDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbYA3SDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYA3SDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:03:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbYA3SDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:03:14 -0500
Date: Wed, 30 Jan 2008 12:03:12 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks for
	subsystems with rmap
Message-ID: <20080130180312.GV26420@sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.699753910@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130022944.699753910@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second part of a patch posted to patch 1/6.


Index: git-linus/mm/rmap.c
===================================================================
--- git-linus.orig/mm/rmap.c	2008-01-30 11:55:56.000000000 -0600
+++ git-linus/mm/rmap.c	2008-01-30 12:01:28.000000000 -0600
@@ -476,8 +476,10 @@ int page_mkclean(struct page *page)
 		struct address_space *mapping = page_mapping(page);
 		if (mapping) {
 			ret = page_mkclean_file(mapping, page);
-			if (unlikely(PageExternalRmap(page)))
+			if (unlikely(PageExternalRmap(page))) {
 				mmu_rmap_notifier(invalidate_page, page);
+				ClearPageExported(page);
+			}
 			if (page_test_dirty(page)) {
 				page_clear_dirty(page);
 				ret = 1;
@@ -980,8 +982,10 @@ int try_to_unmap(struct page *page, int 
 	else
 		ret = try_to_unmap_file(page, migration);
 
-	if (unlikely(PageExternalRmap(page)))
+	if (unlikely(PageExternalRmap(page))) {
 		mmu_rmap_notifier(invalidate_page, page);
+		ClearPageExported(page);
+	}
 
 	if (!page_mapped(page))
 		ret = SWAP_SUCCESS;
