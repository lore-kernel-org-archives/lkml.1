Return-Path: <linux-kernel-owner+w=401wt.eu-S1946256AbXBCCiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946256AbXBCCiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946255AbXBCChz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:37:55 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52885 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946259AbXBCCha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:37:30 -0500
Message-Id: <20070203023916.739906000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:15 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <rdreier@cisco.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, openib-general@openib.org,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 11/59] [stable] [PATCH] IB/mthca: Fix off-by-one in FMR handling on memfree
Content-Disposition: inline; filename=ib-mthca-fix-off-by-one-in-fmr-handling-on-memfree.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Michael S. Tsirkin <mst@mellanox.co.il>

mthca_table_find() will return the wrong address when the table entry
being searched for is exactly at the beginning of a sglist entry
(other than the first), because it uses >= when it should use >.

Example: assume we have 2 entries in scatterlist, 4K each, offset is
4K.  The current code will return first entry + 4K when we really want
the second entry.

In particular this means mapping an FMR on a memfree HCA may end up
writing the page table into the wrong place, leading to memory
corruption and also causing the HCA to use an incorrect address
translation table.

Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
This is upstream, and fixes a data corruption/crash bug with storage
over SRP.

 drivers/infiniband/hw/mthca/mthca_memfree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ linux-2.6.19.2/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -232,7 +232,7 @@ void *mthca_table_find(struct mthca_icm_
 
 	list_for_each_entry(chunk, &icm->chunk_list, list) {
 		for (i = 0; i < chunk->npages; ++i) {
-			if (chunk->mem[i].length >= offset) {
+			if (chunk->mem[i].length > offset) {
 				page = chunk->mem[i].page;
 				goto out;
 			}

--
