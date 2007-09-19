Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbXISTKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbXISTKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXISTKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:10:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbXISTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:10:30 -0400
Date: Wed, 19 Sep 2007 12:10:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-Id: <20070919121017.0cbcbc30.akpm@linux-foundation.org>
In-Reply-To: <46F13938.1070709@gmail.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F10B69.5070008@gmail.com>
	<46F10DCB.1090302@gmail.com>
	<46F13938.1070709@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:59:04 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> ---------8<---------8<---------8<---------8<---------8<---------8<----
> That means
> void agp_generic_destroy_page(void *addr)
> {
>         struct page *page;
> 
>         if (addr == NULL)
>                 return;
> 
>         page = virt_to_page(addr);
> (1)     unmap_page_from_agp(page);
>         put_page(page);
> (2)     free_page((unsigned long)addr);
>         atomic_dec(&agp_bridge->current_memory_agp);
> }
> 
> (1) unmap_page_from_agp -> change_page_attr -> change_page_attr_addr ->
> __change_page_attr -> save_page -> list_add(&fpage->lru, &deferred_pages);
> (2) free_page -> free_pages -> __free_pages -> free_hot_page ->
> free_hot_cold_page -> list_add(&page->lru, &pcp->list);

that'll hurt.

> any ideas how to fix this?

We should hold a single reference on the page for its membership in
deferred_pages.
