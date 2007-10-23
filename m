Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbXJWEYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbXJWEYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXJWEYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:24:44 -0400
Received: from lixom.net ([66.141.50.11]:54707 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXJWEYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:24:44 -0400
Date: Mon, 22 Oct 2007 23:31:48 -0500
From: Olof Johansson <olof@lixom.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Joachim Fenkes <fenkes@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: IB/ehca: Fix sg_page() fallout
Message-ID: <20071023043148.GA20904@lixom.net>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <20071023040948.GA19699@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023040948.GA19699@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

More fallout from sg_page changes, found with powerpc allyesconfig:

drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user1':
drivers/infiniband/hw/ehca/ehca_mrmw.c:1779: error: 'struct scatterlist' has no member named 'page'
drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_check_kpages_per_ate':
drivers/infiniband/hw/ehca/ehca_mrmw.c:1835: error: 'struct scatterlist' has no member named 'page'
drivers/infiniband/hw/ehca/ehca_mrmw.c: In function 'ehca_set_pagebuf_user2':
drivers/infiniband/hw/ehca/ehca_mrmw.c:1870: error: 'struct scatterlist' has no member named 'page'


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index da88738..a3037f3 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -1776,7 +1776,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 	list_for_each_entry_continue(
 		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
 		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
-			pgaddr = page_to_pfn(chunk->page_list[i].page)
+			pgaddr = page_to_pfn(sg_page(chunk->page_list[i]))
 				<< PAGE_SHIFT ;
 			*kpage = phys_to_abs(pgaddr +
 					     (pginfo->next_hwpage *
@@ -1832,7 +1832,7 @@ static int ehca_check_kpages_per_ate(struct scatterlist *page_list,
 {
 	int t;
 	for (t = start_idx; t <= end_idx; t++) {
-		u64 pgaddr = page_to_pfn(page_list[t].page) << PAGE_SHIFT;
+		u64 pgaddr = page_to_pfn(sg_page(page_list[t])) << PAGE_SHIFT;
 		ehca_gen_dbg("chunk_page=%lx value=%016lx", pgaddr,
 			     *(u64 *)abs_to_virt(phys_to_abs(pgaddr)));
 		if (pgaddr - PAGE_SIZE != *prev_pgaddr) {
@@ -1867,7 +1867,7 @@ static int ehca_set_pagebuf_user2(struct ehca_mr_pginfo *pginfo,
 		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
 		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
 			if (nr_kpages == kpages_per_hwpage) {
-				pgaddr = ( page_to_pfn(chunk->page_list[i].page)
+				pgaddr = ( page_to_pfn(sg_page(chunk->page_list[i]))
 					   << PAGE_SHIFT );
 				*kpage = phys_to_abs(pgaddr);
 				if ( !(*kpage) ) {
