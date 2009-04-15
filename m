Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZDOIsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZDOIsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZDOIsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:48:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46842 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZDOIsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:48:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH v3 6/6] fix wrong get_user_pages usage in iovlock.c
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Leech <christopher.leech@intel.com>, netdev@vger.kernel.org
In-Reply-To: <20090414155719.C66B.A69D9226@jp.fujitsu.com>
References: <200904141656.14191.nickpiggin@yahoo.com.au> <20090414155719.C66B.A69D9226@jp.fujitsu.com>
Message-Id: <20090415174658.AC4F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 17:48:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I would perhaps not fold gup_fast conversions into the same patch as
> > the fix.
> 
> OK. I'll fix.

Done.



===================================
Subject: [Untested][RFC][PATCH] fix wrong get_user_pages usage in iovlock.c

	down_read(mmap_sem)
	get_user_pages()
	up_read(mmap_sem)

is fork unsafe.
fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: netdev@vger.kernel.org
---
 drivers/dma/iovlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/dma/iovlock.c
===================================================================
--- a/drivers/dma/iovlock.c	2009-04-13 22:58:36.000000000 +0900
+++ b/drivers/dma/iovlock.c	2009-04-14 20:27:16.000000000 +0900
@@ -104,8 +104,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
 			0,	/* force */
 			page_list->pages,
 			NULL);
-		up_read(&current->mm->mmap_sem);
-
 		if (ret != page_list->nr_pages)
 			goto unpin;
 
@@ -127,6 +125,8 @@ void dma_unpin_iovec_pages(struct dma_pi
 	if (!pinned_list)
 		return;
 
+	up_read(&current->mm->mmap_sem);
+
 	for (i = 0; i < pinned_list->nr_iovecs; i++) {
 		struct dma_page_list *page_list = &pinned_list->page_list[i];
 		for (j = 0; j < page_list->nr_pages; j++) {


