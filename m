Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXISTZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXISTZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXISTY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:24:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXISTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:24:57 -0400
Date: Wed, 19 Sep 2007 21:24:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070919192453.GB18707@one.firstfloor.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919121017.0cbcbc30.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 12:10:17PM -0700, Andrew Morton wrote:
> On Wed, 19 Sep 2007 16:59:04 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > ---------8<---------8<---------8<---------8<---------8<---------8<----
> > That means
> > void agp_generic_destroy_page(void *addr)
> > {
> >         struct page *page;
> > 
> >         if (addr == NULL)
> >                 return;
> > 
> >         page = virt_to_page(addr);
> > (1)     unmap_page_from_agp(page);
> >         put_page(page);
> > (2)     free_page((unsigned long)addr);
> >         atomic_dec(&agp_bridge->current_memory_agp);
> > }
> > 
> > (1) unmap_page_from_agp -> change_page_attr -> change_page_attr_addr ->
> > __change_page_attr -> save_page -> list_add(&fpage->lru, &deferred_pages);
> > (2) free_page -> free_pages -> __free_pages -> free_hot_page ->
> > free_hot_cold_page -> list_add(&page->lru, &pcp->list);
> 
> that'll hurt.
> 
> > any ideas how to fix this?
> 
> We should hold a single reference on the page for its membership in
> deferred_pages.

The code is broken anyways. If you free pages without flushing
them first some other innocent user allocating them will end up
with possible uncached pages for some time.

Does this simple patch help? 

-Andi


Flush uncached AGP pages before freeing

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/drivers/char/agp/generic.c
===================================================================
--- linux.orig/drivers/char/agp/generic.c
+++ linux/drivers/char/agp/generic.c
@@ -1185,6 +1185,7 @@ void agp_generic_destroy_page(void *addr
 
 	page = virt_to_page(addr);
 	unmap_page_from_agp(page);
+	flush_agp_mappings();
 	put_page(page);
 	free_page((unsigned long)addr);
 	atomic_dec(&agp_bridge->current_memory_agp);
