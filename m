Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYJ1OfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYJ1OfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYJ1Oe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:34:57 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:60284 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYJ1Oe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:34:57 -0400
Date: Tue, 28 Oct 2008 09:25:31 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       heiko.carstens@de.ibm.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
In-Reply-To: <20081027145509.ebffcf0e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810280914010.15939@quilx.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
 <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
 <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20081027145509.ebffcf0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Andrew Morton wrote:

> Can we fix that instead?

How about this fix?



Subject: Move migrate_prep out from under mmap_sem

Move the migrate_prep outside the mmap_sem for the following system calls

1. sys_move_pages
2. sys_migrate_pages
3. sys_mbind()

It really does not matter when we flush the lru. The system is free to add
pages onto the lru even during migration which will make the page 
migration either skip the page (mbind, migrate_pages) or return a busy 
state (move_pages).

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/mm/mempolicy.c
===================================================================
--- linux-2.6.orig/mm/mempolicy.c	2008-10-28 09:16:18.475514878 -0500
+++ linux-2.6/mm/mempolicy.c	2008-10-28 09:22:46.486773874 -0500
@@ -489,12 +489,6 @@
  	int err;
  	struct vm_area_struct *first, *vma, *prev;

-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-
-		err = migrate_prep();
-		if (err)
-			return ERR_PTR(err);
-	}

  	first = find_vma(mm, start);
  	if (!first)
@@ -809,9 +803,13 @@
  	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
  {
  	int busy = 0;
-	int err = 0;
+	int err;
  	nodemask_t tmp;

+	err = migrate_prep();
+	if (err)
+		return err;
+
  	down_read(&mm->mmap_sem);

  	err = migrate_vmas(mm, from_nodes, to_nodes, flags);
@@ -974,6 +972,12 @@
  		 start, start + len, mode, mode_flags,
  		 nmask ? nodes_addr(*nmask)[0] : -1);

+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
+
+		err = migrate_prep();
+		if (err)
+			return err;
+	}
  	down_write(&mm->mmap_sem);
  	vma = check_range(mm, start, end, nmask,
  			  flags | MPOL_MF_INVERT, &pagelist);
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2008-10-28 09:15:46.578013464 -0500
+++ linux-2.6/mm/migrate.c	2008-10-28 09:16:14.038014180 -0500
@@ -841,12 +841,12 @@
  	struct page_to_node *pp;
  	LIST_HEAD(pagelist);

+	migrate_prep();
  	down_read(&mm->mmap_sem);

  	/*
  	 * Build a list of pages to migrate
  	 */
-	migrate_prep();
  	for (pp = pm; pp->node != MAX_NUMNODES; pp++) {
  		struct vm_area_struct *vma;
  		struct page *page;
