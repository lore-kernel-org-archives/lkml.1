Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXITATI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXITATI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXITAS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:18:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:19622 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbXITAS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0DUy/GxI37nkwonpZcbP2pBRD2teOparU8psU0CIrZ2MUYtmmMCnaObWYtmlQTmi2RDnBZh4rzpej477GSFfCg4ajFyXjcApfpc2XTC6qAIZug4xhvCxI72UuS692tGJKdEIlj8f06JG045JhwqxLiGWadgVetMlMa8TAv73LE=
Message-ID: <21d7e9970709191718q1695e96bgbd280c2590c1aebd@mail.gmail.com>
Date: Thu, 20 Sep 2007 10:18:54 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070919192453.GB18707@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com>
	 <46F13938.1070709@gmail.com>
	 <20070919121017.0cbcbc30.akpm@linux-foundation.org>
	 <20070919192453.GB18707@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Sep 19, 2007 at 12:10:17PM -0700, Andrew Morton wrote:
> > On Wed, 19 Sep 2007 16:59:04 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> > > ---------8<---------8<---------8<---------8<---------8<---------8<----
> > > That means
> > > void agp_generic_destroy_page(void *addr)
> > > {
> > >         struct page *page;
> > >
> > >         if (addr == NULL)
> > >                 return;
> > >
> > >         page = virt_to_page(addr);
> > > (1)     unmap_page_from_agp(page);
> > >         put_page(page);
> > > (2)     free_page((unsigned long)addr);
> > >         atomic_dec(&agp_bridge->current_memory_agp);
> > > }
> > >
> > > (1) unmap_page_from_agp -> change_page_attr -> change_page_attr_addr ->
> > > __change_page_attr -> save_page -> list_add(&fpage->lru, &deferred_pages);
> > > (2) free_page -> free_pages -> __free_pages -> free_hot_page ->
> > > free_hot_cold_page -> list_add(&page->lru, &pcp->list);
> >
> > that'll hurt.
> >
> > > any ideas how to fix this?
> >
> > We should hold a single reference on the page for its membership in
> > deferred_pages.
>
> The code is broken anyways. If you free pages without flushing
> them first some other innocent user allocating them will end up
> with possible uncached pages for some time.
>
> Does this simple patch help?
>
> -Andi
>
>
> Flush uncached AGP pages before freeing

In theory this should be handled by the caller, so as to avoid the
overhead of continuous flushing however I can see a potential race
condition here if the pages are put back into the kernel before the
caller flushes the mappings..

Do we need some sort of two step approach here? as flushing after each
page would be a major overhead for dynamic agp stuff in the new memory
manager..

Dave.

>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> Index: linux/drivers/char/agp/generic.c
> ===================================================================
> --- linux.orig/drivers/char/agp/generic.c
> +++ linux/drivers/char/agp/generic.c
> @@ -1185,6 +1185,7 @@ void agp_generic_destroy_page(void *addr
>
>         page = virt_to_page(addr);
>         unmap_page_from_agp(page);
> +       flush_agp_mappings();
>         put_page(page);
>         free_page((unsigned long)addr);
>         atomic_dec(&agp_bridge->current_memory_agp);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
