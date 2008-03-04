Return-Path: <linux-kernel-owner+w=401wt.eu-S1764446AbYCDVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764446AbYCDVxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYCDVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:53:45 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42377 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYCDVxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:53:44 -0500
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel bug while running libhugetlbfs
From: Adam Litke <agl@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
In-Reply-To: <20080304115158.505f33eb.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <47CDA0F1.9030908@linux.vnet.ibm.com>
	 <20080304115158.505f33eb.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM
Date: Tue, 04 Mar 2008 16:01:29 -0600
Message-Id: <1204668089.14779.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 11:51 -0800, Andrew Morton wrote:
> hugetlb-correct-page-count-for-surplus-huge-pages.patch adds:
> 
>         if (page) {
>                 /*
>                  * This page is now managed by the hugetlb allocator and has
>                  * no users -- drop the buddy allocator's reference.
>                  */
>                 int page_count = put_page_testzero(page);
>                 BUG_ON(page_count != 0);
> 
> 

Ugh I got bitten by put_page_testzero().  When it returns 1, the page
count is zero (not the page count).

My initial version had a BUG_ON() with side-effects.  When a reviewer
pointed it out, I thought I could fix the patch up on its way out the
door.  I have self-administered my punishment.  This patch will fix it:

Signed-off-by: Adam Litke <agl@us.ibm.com>

--- mm/hugetlb.c.orig	2008-03-04 13:36:30.000000000 -0800
+++ mm/hugetlb.c	2008-03-04 13:39:30.000000000 -0800
@@ -291,8 +291,8 @@ static struct page *alloc_buddy_huge_pag
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		int page_count = put_page_testzero(page);
-		BUG_ON(page_count != 0);
+		put_page_testzero(page);
+		VM_BUG_ON(page_count(page));
 		nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

