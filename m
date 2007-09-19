Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbXISTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbXISTqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXISTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:46:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:8797 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXISTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fXZk7f1yKACEggui3AYnZ7qL1sTdsNs9A47vfcLf+W9Q8yTyc9YWx6gVtxXRmYh2Ib8FcdCXkalBqN6XTLcyWJfu/GAFNL06i57W7WHkeH7dOcpdA2CTv3indARxGU5H1+GcaexKuJi3Ye9ZgLCNH/MyWbGwgVbsjr/iyIgLnQE=
Message-ID: <46F17CA1.5080205@gmail.com>
Date: Wed, 19 Sep 2007 21:46:41 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org>
In-Reply-To: <20070919192453.GB18707@one.firstfloor.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 09:24 PM, Andi Kleen wrote:
> On Wed, Sep 19, 2007 at 12:10:17PM -0700, Andrew Morton wrote:
>> On Wed, 19 Sep 2007 16:59:04 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> ---------8<---------8<---------8<---------8<---------8<---------8<----
>>> That means
>>> void agp_generic_destroy_page(void *addr)
>>> {
>>>         struct page *page;
>>>
>>>         if (addr == NULL)
>>>                 return;
>>>
>>>         page = virt_to_page(addr);
>>> (1)     unmap_page_from_agp(page);
>>>         put_page(page);
>>> (2)     free_page((unsigned long)addr);
>>>         atomic_dec(&agp_bridge->current_memory_agp);
>>> }
>>>
>>> (1) unmap_page_from_agp -> change_page_attr -> change_page_attr_addr ->
>>> __change_page_attr -> save_page -> list_add(&fpage->lru, &deferred_pages);
>>> (2) free_page -> free_pages -> __free_pages -> free_hot_page ->
>>> free_hot_cold_page -> list_add(&page->lru, &pcp->list);
>> that'll hurt.
>>
>>> any ideas how to fix this?
>> We should hold a single reference on the page for its membership in
>> deferred_pages.
> 
> The code is broken anyways. If you free pages without flushing
> them first some other innocent user allocating them will end up
> with possible uncached pages for some time.
> 
> Does this simple patch help? 

Yeah. (But X doesn't run -- this is maybe the known issue in this release).

> Flush uncached AGP pages before freeing
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Tested-by: Jiri Slaby <jirislaby@gmail.com>

> 
> Index: linux/drivers/char/agp/generic.c
> ===================================================================
> --- linux.orig/drivers/char/agp/generic.c
> +++ linux/drivers/char/agp/generic.c
> @@ -1185,6 +1185,7 @@ void agp_generic_destroy_page(void *addr
>  
>  	page = virt_to_page(addr);
>  	unmap_page_from_agp(page);
> +	flush_agp_mappings();
>  	put_page(page);
>  	free_page((unsigned long)addr);
>  	atomic_dec(&agp_bridge->current_memory_agp);
> 

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
